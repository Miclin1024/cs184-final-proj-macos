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

GLCanvasView *canvas;
NSColor *color;
NSTextField *tf;
NSPopUpButton *fontSel;
NSTextField *fontSizeField;


- (IBAction)renderUsingAppKit:(id)sender {
    NSString *stringValue = tf.stringValue;
    const char *cString = [stringValue UTF8String];
    canvas->charToRender = cString[0];
    canvas->r = color.redComponent;
    canvas->g = color.greenComponent;
    canvas->b = color.blueComponent;
    [fontSel selectItemAtIndex:1];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *sizeFormat = [formatter numberFromString:fontSizeField.stringValue];
    int size;
    if (sizeFormat) {
        // the string can be converted to an integer
        size = [sizeFormat intValue];
    } else {
        size = 18;
    }
    canvas->fontSize = size;
    [canvas setNeedsDisplay:true];
}

- (void)popUpButtonAction:(id)sender {
    NSString *selectedTitle = [sender titleOfSelectedItem];
    NSInteger selectedIndex = [fontSel indexOfSelectedItem];
    canvas->index = (int)selectedIndex - 1;
    [fontSel setTitle: selectedTitle];
}

- (void)configureViews {
    
    
    // Create a canvas view
    canvas = [[GLCanvasView alloc] initWithFrame:NSZeroRect];
    canvas.translatesAutoresizingMaskIntoConstraints = NO;
    color = [NSColor whiteColor];
    NSColor *curColor = [NSColor whiteColor];
    color = [curColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    [self.view addSubview:canvas];
    
    [NSLayoutConstraint activateConstraints:@[
        [canvas.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [canvas.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [canvas.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20],
        //[canvas.bottomAnchor constraintEqualToAnchor:containerBox.topAnchor constant:-10],
        [canvas.heightAnchor constraintGreaterThanOrEqualToConstant:400],
    ]];
    
    [canvas setWantsLayer:YES];
    canvas.layer.cornerRadius = 15;
    [canvas.layer setBackgroundColor:NSColor.textBackgroundColor.CGColor];
    
    self.canvas = canvas;
    
    // Container box for font editing
    NSBox *containerBox = [[NSBox alloc] initWithFrame:NSZeroRect];
    containerBox.translatesAutoresizingMaskIntoConstraints = NO;
    containerBox.boxType = NSBoxCustom;
    containerBox.borderWidth = 0;
    [self.view addSubview:containerBox];
    
    // Font selector dropdown
    fontSel = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 200, 25) pullsDown:YES];
    [fontSel addItemsWithTitles:@[@"Select Font", @"SF Pro", @"Helvetica", @"Times New Roman", @"Inter", @"Comic Sans"]];
    [fontSel setTarget:self];
    [fontSel setAction:@selector(popUpButtonAction:)];
    
    [containerBox.contentView addSubview:fontSel];
    
    // Colour picker for font color
    NSColorWell *colorWell = [[NSColorWell alloc] initWithFrame:NSZeroRect];
    colorWell.translatesAutoresizingMaskIntoConstraints = NO;
    [containerBox.contentView addSubview:colorWell];
    
    [colorWell setTarget:self];
    [colorWell setAction:@selector(showColorPanel:)];
    
    // Font size text input
    fontSizeField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    //[containerBox.contentView addSubview:fontSizeField];
    fontSizeField.translatesAutoresizingMaskIntoConstraints = NO;
    fontSizeField.placeholderString = @"180";
    fontSizeField.stringValue = @"180";
    fontSizeField.alignment = NSTextAlignmentLeft;
    fontSizeField.controlSize = NSControlSizeLarge;
    fontSizeField.bezelStyle = NSTextFieldRoundedBezel;
    fontSizeField.font = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeLarge]];
    [containerBox.contentView addSubview:fontSizeField];
    
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
        [containerBox.topAnchor constraintEqualToAnchor:canvas.bottomAnchor constant:10],
        
        [fontSel.leadingAnchor constraintEqualToAnchor:containerBox.contentView.leadingAnchor constant:10],
        [fontSel.centerYAnchor constraintEqualToAnchor:containerBox.contentView.centerYAnchor],
        [fontSel.trailingAnchor constraintEqualToAnchor:colorWell.leadingAnchor constant:-10],
        
        [colorWell.trailingAnchor constraintEqualToAnchor:fontSizeField.leadingAnchor constant:-10],
        [colorWell.centerYAnchor constraintEqualToAnchor:containerBox.contentView.centerYAnchor],
        [colorWell.widthAnchor constraintEqualToConstant: 70],
        
        [fontSizeField.centerYAnchor constraintEqualToAnchor:containerBox.contentView.centerYAnchor],
        [fontSizeField.widthAnchor constraintEqualToConstant: 60],
        
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
           //[tf.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
           [tf.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10],
           [tf.topAnchor constraintEqualToAnchor:containerBox.bottomAnchor constant:8],
           [tf.widthAnchor constraintGreaterThanOrEqualToConstant:380],
       ]];
    
    
        self.inputTextField = tf;
    
        NSButton *renderButton = [[NSButton alloc] initWithFrame:NSMakeRect(390, 0, 80, 50)];
        [renderButton setTitle:@"Render"];
        [renderButton setButtonType:NSButtonTypeMomentaryPushIn];
        [renderButton setBezelStyle:NSBezelStyleRounded];
        [renderButton setTarget:self];
        [renderButton setAction:@selector(renderUsingAppKit:)];
        [self.view addSubview:renderButton];

        [NSLayoutConstraint activateConstraints:@[
            // tf.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10],
            //[renderButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
            [renderButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10],
            //[renderButton.widthAnchor constraintEqualToAnchor:constant:60]
        ]];
}


- (void)showColorPanel:(id)sender {
    [[NSColorPanel sharedColorPanel] setTarget:self];
    [[NSColorPanel sharedColorPanel] setAction:@selector(updateColor:)];
    [[NSColorPanel sharedColorPanel] orderFront:self];
}

- (void)updateColor:(id)sender {
    color = [sender color];
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
