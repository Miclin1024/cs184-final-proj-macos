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
#include <vector>
#include <array>

using namespace CGL;

class BezierCurve {

public:
    Vector2D startPoint, endPoint;

    virtual std::array<Vector2D, 2> boundingBox() const {
        std::cout << "Virtual" << std::endl;
        return {};
    };

    virtual std::vector<Vector2D> polynomialForm() const { return {};};

    virtual std::vector<double> solve(double y) const { return {};};
};

class LinearBezierCurve: public BezierCurve {

public:
    std::array<Vector2D, 2> boundingBox() const {
        return {
            Vector2D(
                     std::min({startPoint.x, endPoint.x}),
                     std::min({startPoint.y, endPoint.y})
                     ),
            Vector2D(
                     std::max({startPoint.x, endPoint.x}),
                     std::max({startPoint.y, endPoint.y})
                     ),

        };
    }

    std::vector<Vector2D> polynomialForm() const {
        return {
            endPoint - startPoint,
            startPoint
        };
    }

    std::vector<double> solve(double y) const {
        std::vector<Vector2D> coefficients = polynomialForm();
        double ay = coefficients[0].y, by = coefficients[1].y - y;

        if (ay != 0) {
            double t = -by / ay;
            if (t >= 0 && t <= 1) {
                double ax = coefficients[0].x, bx = coefficients[1].x;
                return {ax * t + bx};
            } else {
                return {};
            }
        }

        if (by != 0) {
            return {};
        }

        return {startPoint.x, endPoint.x};
    }
};

class QuadBezierCurve: public BezierCurve {

public:
    Vector2D controlPoint;

    std::array<Vector2D, 2> boundingBox() const {
        return {
            Vector2D(
                     std::min({startPoint.x, endPoint.x, controlPoint.x}),
                     std::min({startPoint.y, endPoint.y, controlPoint.y})
                     ),
            Vector2D(
                     std::max({startPoint.x, endPoint.x, controlPoint.x}),
                     std::max({startPoint.y, endPoint.y, controlPoint.y})
                     ),

        };
    }

    std::vector<Vector2D> polynomialForm() const {
        return {
            startPoint - 2 * controlPoint + endPoint,
            2 * (controlPoint - startPoint),
            startPoint,
        };
    }

    std::vector<double> solve(double y) const {
        std::vector<Vector2D> coefficients = polynomialForm();
        double ay = coefficients[0].y;
        double by = coefficients[1].y;
        double cy = coefficients[2].y - y;

        double det = pow(by, 2) - 4 * ay * cy;

        if (det < 0)
            return {};

        std::vector<double> ts = {};
        if (det == 0) {
            ts.push_back(-by / 2. / ay);
        } else {
            ts.push_back((-by - sqrt(det)) / 2 / ay);
            ts.push_back((-by + sqrt(det)) / 2 / ay);
        }

        double ax = coefficients[0].x;
        double bx = coefficients[1].x;
        double cx = coefficients[2].x;
        std::vector<double> results = {};
        for (double t : ts) {
            if (t >= 0 && t <= 1)
                results.push_back(ax * pow(t, 2) + bx * t + cx);
        }

        return results;
    }
};

#endif /* BezierCurves_hpp */
