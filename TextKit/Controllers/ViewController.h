//
//  ViewController.h
//  TextKit
//
//  Created by Michael Lin on 4/24/23.
//

#import <Cocoa/Cocoa.h>
#import "GLCanvasView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : NSViewController

@property(nonatomic, readonly) NSTextField *inputTextField;

@property(nonatomic, readonly) GLCanvasView *canvas;

@end

NS_ASSUME_NONNULL_END
