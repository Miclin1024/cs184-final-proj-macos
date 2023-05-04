//
//  GLCanvasView.h
//  TextKit
//
//  Created by Michael Lin on 4/28/23.
//

#define GL_SILENCE_DEPRECATION
#ifndef GLCanvasView_h
#define GLCanvasView_h

#import <Cocoa/Cocoa.h>

#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@interface GLCanvasView : NSOpenGLView
{
    
}

- (void) drawRect:(NSRect)bounds;

@end
#pragma GCC diagnostic pop

#endif /* GLCanvasView_h */
