//
//  ViewController.m
//  TextKit
//
//  Created by Michael Lin on 4/24/23.
//

#import "ViewController.h"
#include <OpenGL/gl.h>

@implementation ViewController


NSTextField *myTextField;

- (void)buttonClicked:(id)sender {
    NSLog(myTextField.stringValue);
}

-(void) drawRect: (NSRect) bounds
{
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    drawAnObject();
    glFlush();
}

static void drawAnObject ()
{
    glColor3f(1.0f, 0.85f, 0.35f);
    glBegin(GL_TRIANGLES);
    {
        glVertex3f(  0.0,  0.6, 0.0);
        glVertex3f( -0.2, -0.3, 0.0);
        glVertex3f(  0.2, -0.3 ,0.0);
    }
    glEnd();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // text field
    NSRect frame = NSMakeRect(10, 15, 400, 22);
    myTextField = [[NSTextField alloc] initWithFrame:frame];
    [myTextField setPlaceholderString:@"Enter text here"];
    [[self view] addSubview:myTextField];
    
    // button
    NSButton *myButton = [[NSButton alloc] initWithFrame:NSMakeRect(420, 11, 100, 30)];
    [myButton setTarget:self];
    [myButton setAction:@selector(buttonClicked:)];
    NSFont *buttonFont = [NSFont systemFontOfSize:20.0];
    NSMutableDictionary *buttonAttrs = [NSMutableDictionary dictionaryWithDictionary:[[myButton cell] attributedTitle].attributeKeys];
    [buttonAttrs setObject:buttonFont forKey:NSFontAttributeName];
    [[myButton cell] setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Render" attributes:buttonAttrs]];
    [myButton setWantsLayer:YES];
    [myButton.layer setBackgroundColor:[[NSColor grayColor] CGColor]];
    [myButton.layer setMasksToBounds:true];
    [myButton.layer setCornerRadius:8.0];
    [myButton setBordered:NO];
    [[self view] addSubview:myButton];
    
    NSOpenGLView *renderFrame = [[NSOpenGLView alloc] initWithFrame:NSMakeRect(10, 50, 500, 250)];
    [renderFrame setWantsLayer:YES];
    [[renderFrame layer] setBackgroundColor:[[NSColor blackColor] CGColor]];
    
    [[self view] addSubview:renderFrame];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
