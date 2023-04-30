//
//  BezierCurves.hpp
//  TextKit
//
//  Created by Michael Lin on 4/25/23.
//

#ifndef BezierCurves_hpp
#define BezierCurves_hpp

#include <stdio.h>
#include "CGL/vector2D.h"

using namespace CGL;

struct ConicBezierCurve {
    Vector2D startPoint, endPoint, controlPoint;
};

#endif /* BezierCurves_hpp */
