//
//  Font.cpp
//  TextKit
//
//  Created by Michael Lin on 4/29/23.
//

#include "Font.hpp"
#include "Reader.hpp"

using namespace std;
using namespace TextKit;

vector<string> split(string str, char separator) {
    vector<string> strings;
    int startIndex = 0, endIndex = 0;
    for (int i = 0; i <= str.size(); i++) {
        if (str[i] == separator || i == str.size()) {
            endIndex = i;
            string temp;
            temp.append(str, startIndex, endIndex - startIndex);
            strings.push_back(temp);
            startIndex = endIndex + 1;
        }
    }

    return strings;
}

Font::Font(string path, set<char> characters) : path(path),  characters(characters) {
    vector<string> comps = split(path, '/');
    string filename = comps.back();
    comps = split(filename, '.');
    name = comps.front();
}

vector<BezierCurve *> Font::outline(RenderContext context, char glyph) const {
    Reader::loadTTF(path);
    Reader::setFontSize(context.size);
    return Reader::readCurves(glyph);
}

void Font::summarizeOutline(char glyph) const {
    auto outlines = outline(RenderContext(), glyph);
    printf("Outline summary for glyph %c:\n", glyph);
    printf("\tSize: %lu\n", outlines.size());
    double minX = 0.0, minY = numeric_limits<double>::infinity();
    double maxX = 0.0, maxY = -numeric_limits<double>::infinity();

    for (auto outline : outlines) {
        minX = min(outline->startPoint.x, minX);
        minY = min(outline->startPoint.y, minY);
        maxX = max(outline->startPoint.x, maxX);
        maxY = max(outline->startPoint.y, maxY);
    }
    printf("\tStarting point X:\n\t\t(min) %f,\n\t\t(max) %f\n", minX, maxX);
    printf("\tStarting point Y:\n\t\t(min) %f,\n\t\t(max) %f\n", minY, maxY);
}
