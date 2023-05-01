//
//  Font.hpp
//  TextKit
//
//  Created by Michael Lin on 4/29/23.
//

#ifndef Font_hpp
#define Font_hpp

#include <stdio.h>
#include <iostream>
#include <map>
#include <set>
#include "BezierCurves.hpp"

using namespace std;

namespace TextKit {

struct Font {
public:

    struct RenderContext {
        size_t size;

        size_t weight;
    };

    Font(string path, set<char> characters);

    string path;

    string name;

    map<char, vector<ConicBezierCurve>> outlines;

    void summarizeOutline(char glyph);
};

}


#endif /* Font_hpp */
