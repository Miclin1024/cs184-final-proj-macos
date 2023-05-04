//
//  GLCanvasView.m
//  TextKit
//
//  Created by Michael Lin on 4/28/23.
//

#import "GLCanvasView.h"
#include <OpenGl/gl.h>

@implementation GLCanvasView

- (void) drawRect:(NSRect)bounds {
    glClearColor(0,0,0,0);
    glClear(GL_COLOR_BUFFER_BIT);
    draw();
    glFlush();
}

static void draw(void) {
    
    glColor3f(0.5f, 0.5f, 0.5f);
    float seed = arc4random_uniform(100) + 1.0;
    for (int i = 0; i < seed; i++) {
        for (int j = 0; j < seed; j++) {
            int draw = arc4random_uniform(2);
            if (draw == 1) {
                glBegin(GL_QUADS);
                {
                    glVertex3f(-1 + 2 * i / seed,  -1 + 2 * j / seed, 0.0);
                    glVertex3f(-1 + 2 * i / seed, -1 + 2 * (j+1) / seed, 0.0);
                    glVertex3f(-1 + 2 * (i+1) / seed,  -1 + 2 * (j+1) / seed, 0.0);
                    glVertex3f(-1 + 2 * (i+1) / seed, -1 + 2 * j / seed, 0.0);
                }
                glEnd();
            }
        }
    }
}




@end
