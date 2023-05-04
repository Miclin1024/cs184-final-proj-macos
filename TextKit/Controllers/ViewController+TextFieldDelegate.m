//
//  ViewController+NSTextDelegate.m
//  TextKit
//
//  Created by Michael Lin on 4/28/23.
//

#import "ViewController+TextFieldDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@implementation ViewController (TextFieldDelegate)

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (commandSelector == @selector(insertNewline:)) {
        NSEvent *event = NSApp.currentEvent;
        // Use shift+enter to newline
        if (event.modifierFlags & NSEventModifierFlagShift) {
            return NO;
        }
        [self handleInputString:self.inputTextField.stringValue];
        return YES;
    }

    return NO;
}

- (void)handleInputString:(NSString *)input {
    NSLog(@"Received string: %@", input);

    const char *cString = [input UTF8String];
    self.canvas->charToRender = cString[0];
    self.canvas->r = self.color.redComponent;
    self.canvas->g = self.color.greenComponent;
    self.canvas->b = self.color.blueComponent;
    [self.fontSel selectItemAtIndex:1];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *sizeFormat = [formatter numberFromString:self.fontSizeField.stringValue];
    int size;
    if (sizeFormat) {
        // the string can be converted to an integer
        size = [sizeFormat intValue];
    } else {
        size = 18;
    }
    self.canvas->fontSize = size;
    [self.canvas setNeedsDisplay:true];
}

@end

NS_ASSUME_NONNULL_END
