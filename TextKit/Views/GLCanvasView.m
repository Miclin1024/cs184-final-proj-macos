//
//  GLCanvasView.m
//  TextKit
//
//  Created by Michael Lin on 4/28/23.
//

#import "GLCanvasView.h"
#include <OpenGl/gl.h>
#import "Reader.hpp"
#import "Font.hpp"
#import "Rasterizer.hpp"
#include <vector>
#import <math.h>


@implementation GLCanvasView

- (void) drawRect:(NSRect)bounds {
    glClearColor(0,0,0,0);
    glClear(GL_COLOR_BUFFER_BIT);
    draw();
    glFlush();
}

static void draw(void) {
    TextKit::Reader::initialize();

    set<char> charSet = {};
    for (char c = 'A'; c < 'Z'; c++)
        charSet.insert(c);
    for (char c = 'a'; c < 'z'; c++)
        charSet.insert(c);
    TextKit::Font font = TextKit::Font("/Library/Fonts/SF-Pro.ttf", charSet);

    TextKit::Rasterizer rasterizer{};
    TextKit::Rasterizer::GLTextAtlas atlas = rasterizer.rasterize(font, TextKit::Font::RenderContext{});
    glColor3f(0.5f, 0.5f, 0.5f);
    
    float width = atlas.frames['A'].size.x;
    float height = atlas.frames['A'].size.y;
    NSLog(@"The value of width is %f", width);

    
    
    
    float dim = 3000;
    for (int i = 0; i < (int)dim; i++) {
        for (int j = 0; j < (int)dim; j++) {

            uint8_t val = atlas.bitmap.data[(i * (int)atlas.bitmap.width + j) * 4 + 3];
            if (val > 0) {
                glBegin(GL_QUADS);
                {
                    glVertex3f(-1 + 2 * j / dim,  1 + 2 * -i / dim, 0.0);
                    glVertex3f(-1 + 2 * j / dim, 1 + 2 * -(i+1) / dim, 0.0);
                    glVertex3f(-1 + 2 * (j+1) / dim,  1 + 2 * -(i+1) / dim, 0.0);
                    glVertex3f(-1 + 2 * (j+1) / dim, 1 + 2 * -i / dim, 0.0);
                }
                glEnd();
            }
        }
    }
}




@end
