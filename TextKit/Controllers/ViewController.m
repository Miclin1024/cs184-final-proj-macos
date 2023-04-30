//
//  ViewController.m
//  TextKit
//
//  Created by Michael Lin on 4/24/23.
//

#import "ViewController.h"
#import "ViewController+TextFieldDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewController ()

@property(nonatomic, readwrite) NSTextField *inputTextField;

@property(nonatomic, readwrite) GLCanvasView *canvas;

@end

@implementation ViewController

- (void)configureViews {
    NSTextField *tf = [[NSTextField alloc] initWithFrame:NSZeroRect];
    tf.translatesAutoresizingMaskIntoConstraints = NO;
    tf.placeholderString = @"Text to Render";
    tf.stringValue = @"";
    tf.alignment = NSTextAlignmentLeft;
    tf.controlSize = NSControlSizeLarge;
    tf.bezelStyle = NSTextFieldRoundedBezel;
    tf.font = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeLarge]];

    [self.view addSubview:tf];
    tf.delegate = self;

    [NSLayoutConstraint activateConstraints:@[
        [tf.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10],
        [tf.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
        [tf.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10],
        [tf.widthAnchor constraintGreaterThanOrEqualToConstant:500],
    ]];

    self.inputTextField = tf;

    GLCanvasView *canvas = [[GLCanvasView alloc] initWithFrame:NSZeroRect];
    canvas.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:canvas];

    [NSLayoutConstraint activateConstraints:@[
        [canvas.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [canvas.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [canvas.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20],
        [canvas.bottomAnchor constraintEqualToAnchor:tf.topAnchor constant:-30],
        [canvas.heightAnchor constraintGreaterThanOrEqualToConstant:400],
    ]];

    [canvas setWantsLayer:YES];
    canvas.layer.cornerRadius = 15;
    [canvas.layer setBackgroundColor:NSColor.textBackgroundColor.CGColor];

    self.canvas = canvas;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureViews];
}


- (void)setRepresentedObject:(nullable id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end

NS_ASSUME_NONNULL_END
