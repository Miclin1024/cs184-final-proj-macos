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
        };

        char * bitmap;
        size_t width;
        size_t height;
        map<char, Frame> frames;
    };

    map<string, GLTextAtlas> atlas = {};

    GLTextAtlas rasterize(Font font, Font::RenderContext context);

private:
    string keyFromFontInfo(string name, size_t size);
};

}

#endif /* FontRasterizer_hpp */
