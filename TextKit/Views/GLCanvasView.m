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

NSArray *paths = @[@"SF-Pro.ttf", @"Helvetica.ttf", @"times new roman.ttf", @"Inter-Regular.ttf", @"ComicSans.ttf"];

- (void) drawRect:(NSRect)bounds {
    glClearColor(0,0,0,0);
    glClear(GL_COLOR_BUFFER_BIT);
    if (charToRender != 0) {
        [self draw];
    }
    glFlush();
}

- (void)setCharToRender:(char)newCharToRender {
    charToRender = newCharToRender;
}

- (void) draw {
    TextKit::Reader::initialize();

    set<char> charSet = {};
    for (char c = 'A'; c < 'Z'; c++)
        charSet.insert(c);
    
    for (char c = 'a'; c < 'z'; c++)
        charSet.insert(c);
    NSString *path = @"/Library/Fonts/";
    path = [path stringByAppendingString:paths[index]];
    TextKit::Font font = TextKit::Font([path UTF8String], charSet);

    TextKit::Rasterizer rasterizer{};
    TextKit::Rasterizer::GLTextAtlas atlas = rasterizer.rasterize(font, TextKit::Font::RenderContext{});
    GLfloat rf = r;
    GLfloat gf = g;
    GLfloat bf = b;
    glColor3f(rf, gf, bf);
    char curChar = self->charToRender;
    float width = atlas.frames[curChar].size.x;
    float height = atlas.frames[curChar].size.y;
    float xOffset = atlas.frames[curChar].position.x;
    float yOffset = atlas.frames[curChar].position.y;
    float dim = MAX(width, height);
    float shrink = 0.05 * (fontSize / 18.0);
    for (int i = 0; i < (int)dim; i++) {
        for (int j = 0; j < (int)dim; j++) {

            uint8_t val = atlas.bitmap.data[((i + (int)yOffset) * (int)atlas.bitmap.width + (j + (int)xOffset)) * 4 + 3];
            if (val > 0) {
                glBegin(GL_QUADS);
                {
                    glVertex3f(-1 * shrink + 2 * shrink * (j) / dim,  1 * shrink + 2 * shrink * -(i) / dim, 0.0);
                    glVertex3f(-1 * shrink+ 2 * shrink * (j) / dim, 1 * shrink + 2 * shrink * -(i+1) / dim, 0.0);
                    glVertex3f(-1 * shrink + 2 * shrink * (j+1) / dim,  1 * shrink + 2 *shrink * -(i+1) / dim, 0.0);
                    glVertex3f(-1 * shrink + 2 * shrink * (j+1) / dim, 1 * shrink + 2 *shrink * -(i) / dim, 0.0);
                }
                glEnd();
            }
        }
    }
}




@end
