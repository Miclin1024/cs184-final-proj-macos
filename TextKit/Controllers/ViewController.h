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

@property(nonatomic) NSColor* color;

@property(nonatomic) NSTextField *fontSizeField;

@property(nonatomic) NSPopUpButton *fontSel;

@end

NS_ASSUME_NONNULL_END
