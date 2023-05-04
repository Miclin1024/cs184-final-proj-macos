//
//  main.m
//  TextKit
//
//  Created by Michael Lin on 4/24/23.
//

#import <Cocoa/Cocoa.h>
#import "Reader.hpp"
#import "Font.hpp"
#import "Rasterizer.hpp"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
    }
    TextKit::Reader::initialize();

    set<char> charSet = {};
    for (char c = 'A'; c < 'Z'; c++)
        charSet.insert(c);
    for (char c = 'a'; c < 'z'; c++)
        charSet.insert(c);

    TextKit::Font font = TextKit::Font("/Library/Fonts/SF-Pro.ttf", charSet);

    TextKit::Rasterizer rasterizer{};
    rasterizer.rasterize(font, TextKit::Font::RenderContext{});

    NSApplicationMain(argc, argv);
}
