//
//  FontReader.cpp
//  TextKit
//
//  Created by Michael Lin on 4/24/23.
//

#include "Reader.hpp"
#include "BezierCurves.hpp"

FT_Face face = nullptr;
FT_Library library = nullptr;

using namespace TextKit;

int Reader::initialize() {
    int result = FT_Init_FreeType(&library);
    if (result) {
        fprintf(stderr, "Error initializing FreeType library.");
    }

    return result;
}

int Reader::loadTTF(const string path) {
    int result = FT_New_Face(library, path.c_str(), 0, &face);
    if (result) {
        fprintf(stderr, "Error loading font file.");
    }

    return result;
}

Vector2D currentPoint;
vector<ConicBezierCurve> curves;

int moveTo(const FT_Vector* to, void* user) {
    currentPoint = {
        static_cast<double>(to->x),
        static_cast<double>(to->y)
    };

    return 0;
}

int lineTo(const FT_Vector* to, void* user) {
    ConicBezierCurve curve;
    curve.startPoint = currentPoint;
    curve.endPoint = {
        static_cast<double>(to->x),
        static_cast<double>(to->y)
    };
    curve.controlPoint = .5 * (curve.startPoint + curve.endPoint);

    curves.push_back(curve);
    currentPoint = curve.endPoint;

    return 0;
}

int conicTo(const FT_Vector* control, const FT_Vector* to, void* user) {
    ConicBezierCurve curve;
    curve.startPoint = currentPoint;
    curve.controlPoint = {
        static_cast<double>(control->x),
        static_cast<double>(control->y)
    };
    curve.endPoint = {
        static_cast<double>(to->x),
        static_cast<double>(to->y)
    };

    curves.push_back(curve);
    currentPoint = curve.endPoint;

    return 0;
}

vector<ConicBezierCurve> Reader::readCurves(const char c) {
    FT_ULong charCode = c;
    FT_UInt glyphIndex = FT_Get_Char_Index(face, charCode);

    if (FT_Load_Glyph(face, glyphIndex, FT_LOAD_DEFAULT)) {
        fprintf(stderr, "Error loading glyph.");
        return {};
    }

    curves = {};
    currentPoint = {0, 0};

    FT_Outline_Funcs outlineFunctions;
    outlineFunctions.move_to = moveTo;
    outlineFunctions.line_to = lineTo;
    outlineFunctions.conic_to = conicTo;
    outlineFunctions.shift = 0;
    outlineFunctions.delta = 0;

    FT_Outline_Decompose(&face->glyph->outline, &outlineFunctions, nullptr);

    return curves;
}


