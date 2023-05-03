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

    for (char c = 'a'; c <= 'z'; c++) {
        auto bitmap = rasterize(font, context, c);
        string name = "";
        name.append(1, c);
        name.append(".png");
        bitmap.savePNG(name.c_str());
    }
    
    return atlas;
}

Rasterizer::GLTextAtlas::Bitmap Rasterizer::rasterize(Font font, Font::RenderContext context, char glyph) const {
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
    bitmap.baseline = minY;
    bitmap.data = new uint8_t[bitmap.width * bitmap.height * 4];

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

