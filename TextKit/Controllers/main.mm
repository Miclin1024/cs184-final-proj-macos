//
//  main.m
//  TextKit
//
//  Created by Michael Lin on 4/24/23.
//

#import <Cocoa/Cocoa.h>
#import "Reader.hpp"
#import "Font.hpp"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
    }
    TextKit::Reader::initialize();

    set<char> charSet = {'a', 'b', 'c'};
    TextKit::Font font = TextKit::Font("/Library/Fonts/SF-Pro.ttf", charSet);

    TextKit::Reader::loadTTF("/Library/Fonts/SF-Pro.ttf");
    TextKit::Reader::readCurves('a');
    return NSApplicationMain(argc, argv);
}
