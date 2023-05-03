//
//  Font.hpp
//  TextKit
//
//  Created by Michael Lin on 4/29/23.
//

#ifndef Font_hpp
#define Font_hpp

#include "CGL/vector3D.h"
#include <stdio.h>
#include <iostream>
#include <map>
#include <set>
#include "BezierCurves.hpp"
#include <vector>

using namespace std;

namespace TextKit {

struct Font {
public:

    struct RenderContext {
        size_t size = 18;

        size_t weight = 400;

        Vector3D color = {255};
    };

    Font(string path, set<char> characters);

    string path;

    string name;

    set<char> characters;

    vector<BezierCurve *> outline(RenderContext context, char glyph) const;

    void summarizeOutline(char glyph) const;
};

}


#endif /* Font_hpp */
