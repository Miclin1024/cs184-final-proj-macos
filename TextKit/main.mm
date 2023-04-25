//
//  main.m
//  TextKit
//
//  Created by Michael Lin on 4/24/23.
//

#import <Cocoa/Cocoa.h>
#import "FontReader.hpp"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
    }


    FontReader::initialize();
    FontReader::loadTTF("/Library/Fonts/SF-Pro.ttf");
    FontReader::readCurves('a');
    return NSApplicationMain(argc, argv);
}
