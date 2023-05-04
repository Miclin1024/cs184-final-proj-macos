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

NSTextField *tf;

- (void)popUpButtonAction:(id)sender {
    NSString *selectedTitle = [sender titleOfSelectedItem];
    NSInteger selectedIndex = [_fontSel indexOfSelectedItem];
    _canvas->index = (int)selectedIndex - 1;
    [_fontSel setTitle: selectedTitle];
}

- (void)configureViews {
    // Create a canvas view
    _canvas = [[GLCanvasView alloc] initWithFrame:NSZeroRect];
    _canvas.translatesAutoresizingMaskIntoConstraints = NO;
    _color = [NSColor whiteColor];
    NSColor *curColor = [NSColor whiteColor];
    _color = [curColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    [self.view addSubview:_canvas];
    
    [NSLayoutConstraint activateConstraints:@[
        [_canvas.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [_canvas.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [_canvas.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20],
        //[canvas.bottomAnchor constraintEqualToAnchor:containerBox.topAnchor constant:-10],
        [_canvas.heightAnchor constraintGreaterThanOrEqualToConstant:400],
    ]];
    
    [_canvas setWantsLayer:YES];
    _canvas.layer.cornerRadius = 15;
    [_canvas.layer setBackgroundColor:NSColor.textBackgroundColor.CGColor];
    
    // Container box for font editing
    NSBox *containerBox = [[NSBox alloc] initWithFrame:NSZeroRect];
    containerBox.translatesAutoresizingMaskIntoConstraints = NO;
    containerBox.boxType = NSBoxCustom;
    containerBox.borderWidth = 0;
    [self.view addSubview:containerBox];
    
    // Font selector dropdown
    _fontSel = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 200, 25) pullsDown:YES];
    [_fontSel addItemsWithTitles:@[@"Select Font", @"SF Pro", @"Helvetica", @"Times New Roman", @"Inter", @"Comic Sans"]];
    [_fontSel setTarget:self];
    [_fontSel setAction:@selector(popUpButtonAction:)];
    
    [containerBox.contentView addSubview:_fontSel];
    
    // Colour picker for font color
    NSColorWell *colorWell = [[NSColorWell alloc] initWithFrame:NSZeroRect];
    colorWell.translatesAutoresizingMaskIntoConstraints = NO;
    [containerBox.contentView addSubview:colorWell];
    
    [colorWell setTarget:self];
    [colorWell setAction:@selector(showColorPanel:)];
    
    // Font size text input
    _fontSizeField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    //[containerBox.contentView addSubview:fontSizeField];
    _fontSizeField.translatesAutoresizingMaskIntoConstraints = NO;
    _fontSizeField.placeholderString = @"180";
    _fontSizeField.stringValue = @"180";
    _fontSizeField.alignment = NSTextAlignmentLeft;
    _fontSizeField.controlSize = NSControlSizeLarge;
    _fontSizeField.bezelStyle = NSTextFieldRoundedBezel;
    _fontSizeField.font = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeLarge]];
    [containerBox.contentView addSubview:_fontSizeField];
    
//    // Font weight
//    NSPopUpButton *weightSel = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(355, 0, 100, 25) pullsDown:YES];
//    [weightSel addItemsWithTitles:@[@"Regular", @"Medium", @"Bold", @"Extra Bold"]];
//    [weightSel setTarget:self];
//    [weightSel setAction:@selector(comboBoxSelectionDidChange:)];
//    [containerBox.contentView addSubview:weightSel];
    
    //    // Create an NSOpenPanel to choose files
    //    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    //    [openPanel setCanChooseFiles:YES];
    //    [openPanel setCanChooseDirectories:NO];
    //    [openPanel setAllowsMultipleSelection:YES];
    //    [openPanel setAllowedFileTypes:@[@"ttf"]];
    //
    //    if ([openPanel runModal] == NSModalResponseOK) {
    //        for (NSURL *fileURL in [openPanel URLs]) {
    //            NSString *fileName = [fileURL lastPathComponent];
    //            NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:fileName action:nil keyEquivalent:@""];
    //            [menuItem setRepresentedObject:fileURL];
    //            [fileDropdown.menu addItem:menuItem];
    //        }
    //    }
    // [self.view addSubview:fileDropdown];
    
    [NSLayoutConstraint activateConstraints:@[
        [containerBox.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:5],
        [containerBox.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0],
        [containerBox.topAnchor constraintEqualToAnchor:_canvas.bottomAnchor constant:10],
        
        [_fontSel.leadingAnchor constraintEqualToAnchor:containerBox.contentView.leadingAnchor constant:10],
        [_fontSel.centerYAnchor constraintEqualToAnchor:containerBox.contentView.centerYAnchor],
        [_fontSel.trailingAnchor constraintEqualToAnchor:colorWell.leadingAnchor constant:-10],
        
        [colorWell.trailingAnchor constraintEqualToAnchor:_fontSizeField.leadingAnchor constant:-10],
        [colorWell.centerYAnchor constraintEqualToAnchor:containerBox.contentView.centerYAnchor],
        [colorWell.widthAnchor constraintEqualToConstant: 70],
        
        [_fontSizeField.centerYAnchor constraintEqualToAnchor:containerBox.contentView.centerYAnchor],
        [_fontSizeField.widthAnchor constraintEqualToConstant: 60],
        
//        [weightSel.trailingAnchor constraintEqualToAnchor:containerBox.contentView.trailingAnchor constant:-10],
//        [weightSel.centerYAnchor constraintEqualToAnchor:containerBox.contentView.centerYAnchor],
    ]];
    
    
    // Create a text field
        tf = [[NSTextField alloc] initWithFrame:NSZeroRect];
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
           [tf.topAnchor constraintEqualToAnchor:containerBox.bottomAnchor constant:8],
           [tf.widthAnchor constraintGreaterThanOrEqualToConstant:380],
       ]];
    
    
        self.inputTextField = tf;
    
//        NSButton *renderButton = [[NSButton alloc] initWithFrame:NSMakeRect(390, 0, 80, 50)];
//        [renderButton setTitle:@"Render"];
//        [renderButton setButtonType:NSButtonTypeMomentaryPushIn];
//        [renderButton setBezelStyle:NSBezelStyleRounded];
//        [renderButton setTarget:self];
//        [self.view addSubview:renderButton];
//
//        [NSLayoutConstraint activateConstraints:@[
//            // tf.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10],
//            //[renderButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
//            [renderButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10],
//            //[renderButton.widthAnchor constraintEqualToAnchor:constant:60]
//        ]];
}


- (void)showColorPanel:(id)sender {
    [[NSColorPanel sharedColorPanel] setTarget:self];
    [[NSColorPanel sharedColorPanel] setAction:@selector(updateColor:)];
    [[NSColorPanel sharedColorPanel] orderFront:self];
}

- (void)updateColor:(id)sender {
    _color = [sender color];
    [self.canvas.layer setBackgroundColor:_color.CGColor];
    
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
