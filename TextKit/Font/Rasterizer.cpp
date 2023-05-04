//
//  Rasterizer.cpp
//  TextKit
//
//  Created by Michael Lin on 4/29/23.
//

#include "Rasterizer.hpp"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

#define STB_TRUETYPE_IMPLEMENTATION
#include "stb_truetype.h"

using namespace std;
using namespace TextKit;

Rasterizer::GLTextAtlas Rasterizer::rasterize(Font font, Font::RenderContext context) {

    Rasterizer::GLTextAtlas atlas{};

    vector<pair<char, Rasterizer::GLTextAtlas::Bitmap>> bitmapComponents = {};

    for (char c : font.characters) {
        double baseline;
        auto bitmap = rasterize(font, context, c, &baseline);
        Rasterizer::GLTextAtlas::Frame frame = {};
        frame.size = Vector2D(bitmap.width, bitmap.height);
        frame.baseline = baseline;
        atlas.frames.emplace(c, frame);

//        string name = "";
//        name.append(1, c);
//        name.append(".png");
//        bitmap.savePNG(name.c_str());

        bitmapComponents.emplace_back(c, bitmap);
    }

    int frameWidth = 0, frameHeight = 0;
    for (auto elem : bitmapComponents) {
        auto bitmap = elem.second;
        frameWidth = max(bitmap.width, frameWidth);
        frameHeight = max(bitmap.height, frameHeight);
    }
    double ratio = (double) frameHeight / frameWidth;

    int n_w = round(sqrt(bitmapComponents.size() * ratio));
    int n_h = ceil((double) bitmapComponents.size() / n_w);

    atlas.bitmap.width = n_w * frameWidth;
    atlas.bitmap.height = n_h * frameHeight;
    atlas.bitmap.data = new uint8_t[atlas.bitmap.width * atlas.bitmap.height * 4];
    int frameByteSize = frameWidth * frameHeight * 4;

    for (int idx = 0; idx < bitmapComponents.size(); idx++) {
        int row = idx / n_w, col = idx % n_w;

        char c = bitmapComponents[idx].first;
        auto bitmap = bitmapComponents[idx].second;

        auto frameIter = atlas.frames.find(c);
        assert(frameIter != atlas.frames.end());
        frameIter->second.position = Vector2D(col * frameWidth, row * frameHeight);

        // We will copy the data of each glyph line by line
        // First, compute the starting index. Each glyph not on the
        // same row occupies the full frameByteSize. Glyphs on
        // the same row only uses the first line.
        int dst = row * n_w * frameByteSize + frameWidth * col * 4;

        // The byte length of each line.
        int cpylen = bitmap.width * 4;

        // For the remainder of the line, we will set pixels to
        // a default value. These are the unused regions of the
        // atlas.
        int setlen = (frameWidth - bitmap.width) * 4;
        uint8_t setValue = 0;

        // We skip to the same location on next line when we are done.
        int stride = atlas.bitmap.width * 4;

        // src will start from the beginning, and moving row by row,
        // incrementing dst pointer along the way.
        for (int src = 0;
             src < bitmap.width * bitmap.height * 4;
             src += cpylen, dst += stride) {
            memcpy(&atlas.bitmap.data[dst], &bitmap.data[src], cpylen);
            memset(&atlas.bitmap.data[dst + cpylen], setValue, setlen);
        }
    }

//    atlas.bitmap.savePNG("output.png");
    return atlas;
}

Rasterizer::GLTextAtlas::Bitmap Rasterizer::rasterize(Font font, Font::RenderContext context, char glyph, double *baseline) const {
    vector<BezierCurve *> outlines = font.outline(context, glyph);

    double minX = numeric_limits<double>::infinity(), minY = minX;
    double maxX = -numeric_limits<double>::infinity(), maxY = maxX;

    for (auto outline : outlines) {
        auto boundingBox = outline->boundingBox();
        minX = min(boundingBox[0].x, minX);
        minY = min(boundingBox[0].y, minY);
        maxX = max(boundingBox[1].x, maxX);
        maxY = max(boundingBox[1].y, maxY);
    }

    Rasterizer::GLTextAtlas::Bitmap bitmap{};
    bitmap.width = maxX - minX;
    bitmap.height = maxY - minY;
    bitmap.data = new uint8_t[bitmap.width * bitmap.height * 4];
    *baseline = minY;

    for (int row = 0; row < bitmap.height; row++) {
        vector<double> intersectX{};
        for (auto curve : outlines) {
            auto x = curve->solve(row + .5 + minY);
            intersectX.insert(end(intersectX), begin(x), end(x));
        }

        sort(intersectX.begin(), intersectX.end());

        int fillStart = 0;
        for (int i = 0; i < intersectX.size(); i+=2) {
            double x1 = intersectX[i] - minX, x2 = intersectX[i+1] - minX;
            int col = fillStart;
            for (; col < floor(x1); col++)
                bitmap.setPixel(Vector2D(col, row), context.color, 0);

            for (; col < floor(x2); col++)
                bitmap.setPixel(Vector2D(col, row), context.color, 255);

            fillStart = col;
        }

        for (int col = fillStart; col < bitmap.width; col++)
            bitmap.setPixel(Vector2D(col, row), context.color, 0);
    }

    return bitmap;
}

void Rasterizer::GLTextAtlas::Bitmap::setPixel(Vector2D position, Vector3D color, uint8_t alpha) {
    size_t loc = ((height - position.y) * width + position.x) * 4;
    data[loc] = color.x;
    data[loc + 1] = color.y;
    data[loc + 2] = color.z;
    data[loc + 3] = alpha;
}

void Rasterizer::GLTextAtlas::Bitmap::savePNG(char const *name) {
    int result = stbi_write_png(name, width, height, 4, data, width * 4);

    if (result) {
        std::cout << "Texture successfully saved" << std::endl;
    } else {
        std::cerr << "Error saving texture" << std::endl;
    }
}

