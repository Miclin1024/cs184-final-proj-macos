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


    FontReader *reader = new FontReader();
    return NSApplicationMain(argc, argv);
}
