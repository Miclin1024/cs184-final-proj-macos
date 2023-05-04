//
//  FontRasterizer.hpp
//  TextKit
//
//  Created by Michael Lin on 4/29/23.
//

#ifndef FontRasterizer_hpp
#define FontRasterizer_hpp

#include <stdio.h>
#include <iostream>
#include <map>
#include "BezierCurves.hpp"
#include "Font.hpp"
#include <vector>


using namespace std;

namespace TextKit {

class Rasterizer {
public:

    struct GLTextAtlas {

        struct Frame {
            Vector2D position;
            Vector2D size;
            double baseline;
        };

        struct Bitmap {
            uint8_t * data;
            int width;
            int height;

            void setPixel(Vector2D position, Vector3D color, uint8_t alpha);
            void savePNG(char const *name);
        };

        Bitmap bitmap;
        map<char, Frame> frames;
    };

    map<string, GLTextAtlas> atlas = {};

    GLTextAtlas rasterize(Font font, Font::RenderContext context);

    GLTextAtlas::Bitmap rasterize(Font font, Font::RenderContext context, char glyph, double *baseline) const;

private:
    string keyFromRenderInfo(Font font, Font::RenderContext context) const;
};

}

#endif /* FontRasterizer_hpp */
