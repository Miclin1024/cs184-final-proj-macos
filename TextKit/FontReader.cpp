//
//  FontReader.cpp
//  TextKit
//
//  Created by Michael Lin on 4/24/23.
//

#include "FontReader.hpp"

FontReader::FontReader() {
    this->initialize();
}

FontReader::~FontReader() {}

int FontReader::initialize() {
    if (FT_Init_FreeType(&this->library)) {
        fprintf(stderr, "Error initializing FreeType library.");
        return 1;
    }

    return 0;
}

int FontReader::loadTTF(const char* path) {
    if (FT_New_Face(this->library, path, 0, &this->face)) {
        fprintf(stderr, "Error loading font file.");
        return 1;
    }

    return 0;
}



