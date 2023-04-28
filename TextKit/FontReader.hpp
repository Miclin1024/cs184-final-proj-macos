//
//  FontReader.hpp
//  TextKit
//
//  Created by Michael Lin on 4/24/23.
//

#ifndef FontReader_hpp
#define FontReader_hpp

#include <freetype2/ft2build.h>
#include FT_FREETYPE_H
#include FT_OUTLINE_H
#include FT_IMAGE_H

#include <stdio.h>
#include "BezierCurves.hpp"

using namespace std;

namespace FontReader {

    int initialize();

    int loadTTF(const char* path);

    vector<ConicBezierCurve> readCurves(const char c);
};

#endif
