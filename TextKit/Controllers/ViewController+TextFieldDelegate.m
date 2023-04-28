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
}

@end

NS_ASSUME_NONNULL_END
