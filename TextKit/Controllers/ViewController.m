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
    // Create a text field
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
    
    // Create a container box
    NSBox *containerBox = [[NSBox alloc] initWithFrame:NSZeroRect];
    containerBox.translatesAutoresizingMaskIntoConstraints = NO;
    containerBox.boxType = NSBoxCustom;
    containerBox.borderColor = [NSColor lightGrayColor];
    containerBox.borderWidth = 0;
    [self.view addSubview:containerBox];
    
    // Create a combo button dropdown
    NSPopUpButton *popUpButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 150, 25) pullsDown:YES];
    [popUpButton addItemsWithTitles:@[@"Bold", @"Medium", @"Regular", @"Light"]];
    [popUpButton setTarget:self];
    [popUpButton setAction:@selector(comboBoxSelectionDidChange:)];
    [containerBox.contentView addSubview:popUpButton];
    
    // Create a color well
       NSColorWell *colorWell = [[NSColorWell alloc] initWithFrame:NSZeroRect];
       colorWell.translatesAutoresizingMaskIntoConstraints = NO;
       [self.view addSubview:colorWell];

       // Set the target and action for the color well to open the color panel
       [colorWell setTarget:self];
       [colorWell setAction:@selector(showColorPanel:)];
    
    // Create a font size text field
        NSTextField *fontSizeField = [[NSTextField alloc] initWithFrame:NSZeroRect];
        //[containerBox.contentView addSubview:fontSizeField];
        fontSizeField.translatesAutoresizingMaskIntoConstraints = NO;
        fontSizeField.placeholderString = @"12px";
        fontSizeField.stringValue = @"";
        fontSizeField.alignment = NSTextAlignmentLeft;
        fontSizeField.controlSize = NSControlSizeLarge;
        fontSizeField.bezelStyle = NSTextFieldRoundedBezel;
        fontSizeField.font = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeLarge]];
        [self.view addSubview:fontSizeField];



        
    [NSLayoutConstraint activateConstraints:@[
        [containerBox.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:5],
        [containerBox.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0],
        [containerBox.bottomAnchor constraintEqualToAnchor:tf.topAnchor constant:-5],
        [popUpButton.leadingAnchor constraintEqualToAnchor:containerBox.contentView.leadingAnchor constant:10],
        [popUpButton.centerYAnchor constraintEqualToAnchor:containerBox.contentView.centerYAnchor],
        // [colorWell.trailingAnchor constraintEqualToAnchor:containerBox.contentView.trailingAnchor constant:-10],
        [colorWell.centerYAnchor constraintEqualToAnchor:containerBox.contentView.centerYAnchor],
        [popUpButton.trailingAnchor constraintEqualToAnchor:colorWell.leadingAnchor constant:-10],
        [fontSizeField.trailingAnchor constraintEqualToAnchor:containerBox.contentView.trailingAnchor constant:-10],
        [fontSizeField.centerYAnchor constraintEqualToAnchor:containerBox.contentView.centerYAnchor],
        [fontSizeField.widthAnchor constraintEqualToConstant:50],
        
        //[fileUploadButton.trailingAnchor constraintEqualToAnchor:fontSizeField.trailingAnchor constant:-10],
        //[fileUploadButton.centerYAnchor constraintEqualToAnchor:containerBox.contentView.centerYAnchor],
    ]];
    
    //self.containerBox = containerBox;
    
    
    // Create a canvas view
    GLCanvasView *canvas = [[GLCanvasView alloc] initWithFrame:NSZeroRect];
    canvas.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:canvas];
    
    [NSLayoutConstraint activateConstraints:@[
        [canvas.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [canvas.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [canvas.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20],
        [canvas.bottomAnchor constraintEqualToAnchor:containerBox.topAnchor constant:-10],
        [canvas.heightAnchor constraintGreaterThanOrEqualToConstant:400],
    ]];
    
    [canvas setWantsLayer:YES];
    canvas.layer.cornerRadius = 15;
    [canvas.layer setBackgroundColor:NSColor.textBackgroundColor.CGColor];
    
    self.canvas = canvas;
}

- (void)showColorPanel:(id)sender {
    [[NSColorPanel sharedColorPanel] setTarget:self];
    [[NSColorPanel sharedColorPanel] setAction:@selector(updateColor:)];
    [[NSColorPanel sharedColorPanel] orderFront:self];
}

- (void)updateColor:(id)sender {
    NSColor *color = [sender color];
    [self.canvas.layer setBackgroundColor:color.CGColor];
    
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
