//
//  ViewController.h
//  TextKit
//
//  Created by Michael Lin on 4/24/23.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : NSViewController

@property(nonatomic) NSTextField *inputTextField;

#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@property(nonatomic) NSOpenGLView *canvas;
#pragma GCC diagnostic pop

@end

NS_ASSUME_NONNULL_END
