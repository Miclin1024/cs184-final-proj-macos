//
//  Reader.hpp
//  TextKit
//
//  Created by Michael Lin on 4/24/23.
//

#ifndef Reader_hpp
#define Reader_hpp

#include <freetype2/ft2build.h>
#include FT_FREETYPE_H
#include FT_OUTLINE_H
#include FT_IMAGE_H

#include <stdio.h>
#include <iostream>
#include "BezierCurves.hpp"

using namespace std;

namespace TextKit {

namespace Reader {

int initialize();

int loadTTF(const string path);

vector<ConicBezierCurve> readCurves(const char c);

};

};

#endif