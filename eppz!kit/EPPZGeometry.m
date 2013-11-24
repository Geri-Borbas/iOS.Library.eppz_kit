//
//  EPPZGeometry.m
//  eppz!kit
//
//  Created by Borbás Geri on 10/18/09.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZGeometry.h"


#pragma mark - Helpers

CGFloat cube(CGFloat scalar)
{ return scalar * scalar; }

CGFloat absoluteValue(CGFloat scalar)
{ return fabsf(scalar); }

BOOL isOdd(int scalar)
{ return (scalar % 2 != 0) ? YES : NO; }


#pragma mark - Randomizers

CGFloat randomNumberInRange(CGFloat range)
{
    if (range <= 0) return 0.0;
    return (float)(arc4random() % (int)range);
}

CGPoint randomPointInFrame(CGRect frame)
{ return (CGPoint){frame.origin.x + randomNumberInRange(frame.size.width), frame.origin.y + randomNumberInRange(frame.size.height)}; }


#pragma mark CGSize, CGRect helpers

const CGSize CGSizeOne = (CGSize){1.0f, 1.0f};
const CGVector CGVectorZero = (CGVector){1.0f, 1.0f};

CGPoint incrementPoint(CGPoint point)
{ return (CGPoint){point.x + 1.0f, point.y + 1.0f}; }

CGSize sizeFromSizeWithPadding(CGSize size, CGFloat padding)
{
    return (CGSize){
        size.width - padding * 2.0f,
        size.height - padding * 2.0f
    };
}

CGRect rectFromRectWithPadding(CGRect rect, CGFloat padding)
{
    return (CGRect){
        rect.origin.x + padding,
        rect.origin.y + padding,
        rect.size.width - padding * 2.0f,
        rect.size.height - padding * 2.0f
    };
}

CGSize sizeFromSizeWithMargin(CGSize size, CGFloat margin)
{ return sizeFromSizeWithPadding(size, -margin); }
    
CGRect rectFromRectWithMargin(CGRect rect, CGFloat margin)
{ return rectFromRectWithPadding(rect, -margin); }

CGSize scaleSize(CGSize size, CGFloat scalar)
{ return (CGSize){size.width * scalar, size.height * scalar}; }
    

#pragma mark - Trigonometry

CGVector vectorBetweenPoints(CGPoint from, CGPoint to)
{ return (CGVector){to.x - from.x, to.y - from.y}; }

CGPoint vectorPointBetweenPoints(CGPoint from, CGPoint to)
{ return (CGPoint){to.x - from.x, to.y - from.y}; }

CGFloat distanceBetweenPoints(CGPoint from, CGPoint to)
{
    CGVector vector = vectorBetweenPoints(from, to);
    return sqrtf(powf(vector.dx, 2) + powf(vector.dy, 2));
}

CGFloat angleBetweenPoints(CGPoint from, CGPoint to)
{
    CGFloat x = from.x - to.x;
    CGFloat y = from.y - to.y;
    CGFloat angle = atan2f(y, x);
    return angle;
}

CGFloat degreesToRadians(CGFloat degrees)
{ return degrees / 180.0f * M_PI; }

CGFloat radiansToDegrees(CGFloat radians)
{ return radians * 180.0f / M_PI; }


#pragma mark - Basic vector operations

CGVector vectorFromPoint(CGPoint point)
{ return (CGVector){point.x, point.y}; }

CGPoint pointFromVector(CGVector vector)
{ return (CGPoint){vector.dx, vector.dy}; }

CGVector addVectors(CGVector one, CGVector other)
{ return (CGVector){one.dx + other.dx, one.dy +  other.dy}; }

CGVector subtractVectors(CGVector one, CGVector other)
{ return (CGVector){one.dx - other.dx, one.dy - other.dy}; }

CGFloat lengthOfVector(CGVector vector)
{ return sqrt(pow(vector.dx, 2) + pow(vector.dy, 2)); }

CGVector scaleVector(CGVector vector, CGFloat scale)
{ return (CGVector){vector.dx * scale, vector.dy * scale}; }

CGVector normalizeVector(CGVector vector)
{ return scaleVector(vector, 1.0f / lengthOfVector(vector)); }

CGVector rotateVector(CGVector vector, CGFloat radians)
{
    // Checks.
    if (radians == 0.0f) return vector;
    if (radians == (M_PI * 2.0f)) return vector;
    
    CGFloat cosine = cos(radians);
    CGFloat sine = sin(radians);
    return (CGVector){
        vector.dx * cosine - vector.dy * sine,
        vector.dx * sine + vector.dy * cosine
    };
}

CGPoint addVectorPoints(CGPoint one, CGPoint other)
{ return (CGPoint){one.x + other.x, one.y + other.y}; }

CGPoint subtractVectorPoints(CGPoint one, CGPoint other)
{ return (CGPoint){one.x - other.x, one.y - other.y}; }

CGFloat lengthOfVectorPoint(CGPoint vectorPoint)
{ return lengthOfVector(vectorFromPoint(vectorPoint)); }

CGPoint scaleVectorPoint(CGPoint vectorPoint, CGFloat scale)
{ return (CGPoint){vectorPoint.x * scale, vectorPoint.y * scale}; }

CGPoint normalizeVectorPoint(CGPoint vectorPoint)
{ return scaleVectorPoint(vectorPoint, 1.0f / lengthOfVectorPoint(vectorPoint)); }

CGPoint rotateVectorPoint(CGPoint vectorPoint, CGFloat radians)
{ return pointFromVector(rotateVector(vectorFromPoint(vectorPoint), radians)); }


#pragma mark - Circle features

CGCircle CGCircleMake(CGPoint center, CGFloat radius)
{
    CGCircle circle;
    circle.center = center;
    circle.radius = radius;
    return circle;
}

CGRect boundingBoxOfCircle(CGCircle circle)
{
    return (CGRect){
        circle.center.x - circle.radius,
        circle.center.y - circle.radius,
        circle.radius * 2.0,
        circle.radius * 2.0};
}

CGFloat circumfenceOfCircle(CGCircle circle)
{ return 2.0 * circle.radius * M_PI; }

CGFloat areaOfCircle(CGCircle circle)
{ return cube(circle.radius) * M_PI; }


BOOL areCirclesOverlapping(CGCircle one, CGCircle other)
{
    CGFloat radiuses = one.radius + other.radius;
    return distanceBetweenPoints(one.center, other.center) <= radiuses;
}

CGCircleIntersection intersectionOfCircles(CGCircle one, CGCircle other)
{
    // Default flags.
    CGCircleIntersection intersections;
    intersections.areCirclesIntersecting = NO;
    intersections.areCirclesContainingEachOther = NO;
    
    // Distances between centers.
    CGFloat verticalCenterDistance = other.center.x - one.center.x;
    CGFloat horizontalCenterDistance = other.center.y - one.center.y;
    CGFloat centerDistance = sqrt((horizontalCenterDistance*horizontalCenterDistance) + (verticalCenterDistance*verticalCenterDistance));
    
    // Check for solvability.
    if (centerDistance > (one.radius + other.radius))
    {
        // Do not intersect at all.
        return intersections;
    }
    if (centerDistance < (one.radius - other.radius))
    {
        // Are containing each other
        intersections.areCirclesContainingEachOther = YES;
        return intersections;
    }
    
    // Good news.
    intersections.areCirclesIntersecting = YES;
    
    // Point 'c' is the point where the line through the circle intersection points crosses the line between the circle centers.
    CGPoint c = CGPointZero;
    
    // Determine the distance from one circle to 'c'.
    CGFloat distanceFromOneToMiddle = (cube(one.radius) - cube(other.radius) + cube(centerDistance)) / (2.0 * centerDistance);
    
    // Bake 'c' coordinates.
    c.x = one.center.x + (verticalCenterDistance * distanceFromOneToMiddle / centerDistance);
    c.y = one.center.y + (horizontalCenterDistance * distanceFromOneToMiddle / centerDistance);
    
    // Distance from 'c' to intersection(s).
    CGFloat distanceFromMiddleToIntersection = sqrt(cube(one.radius) - cube(distanceFromOneToMiddle));
    
    // Intersection offsets from 'c'.
    CGVector intersectionOffset;
    intersectionOffset.dx = -horizontalCenterDistance * (distanceFromMiddleToIntersection / centerDistance);
    intersectionOffset.dy = verticalCenterDistance * (distanceFromMiddleToIntersection / centerDistance);
    
    // Bake intersection coordinates.
    intersections.a = (CGPoint){c.x + intersectionOffset.dx, c.y + intersectionOffset.dy};
    intersections.b = (CGPoint){c.x - intersectionOffset.dx, c.y - intersectionOffset.dy};
    intersections.c = c;
    
    return intersections;
}


#pragma mark - CGLine features

CGLine CGLineMake(CGFloat aX, CGFloat aY, CGFloat bX, CGFloat bY, CGFloat width)
{
    CGLine line;
    line.a = (CGPoint){aX, aY};
    line.b = (CGPoint){bX, bY};
    line.width = width;
    return line;
}

CGRect boundingBoxOfLine(CGLine line)
{
    CGFloat left = (line.a.x < line.b.x) ? line.a.x : line.b.x;
    CGFloat right = (line.a.x < line.b.x) ? line.b.x : line.a.x;
    CGFloat top = (line.a.y < line.b.y) ? line.a.y : line.b.y;
    CGFloat bottom = (line.a.y < line.b.y) ? line.b.y : line.a.y;
    return (CGRect){ left, top, right - left, bottom - top };
}

CGFloat distanceBetweenPointAndLine(CGPoint point, CGLine line)
{
    // From http://www.allegro.cc/forums/thread/589720/644831
    CGFloat a = point.x - line.a.x;
    CGFloat b = point.y - line.a.y;
    CGFloat c = line.b.x - line.a.x;
    CGFloat d = line.b.y - line.a.y;
    return absoluteValue(a * d - c * b) / sqrt(c * c + d * d);
}

CGFloat distanceBetweenPointAndLineSegment(CGPoint point, CGLine line)
{
    // From http://www.allegro.cc/forums/thread/589720/644831
    CGFloat a = point.x - line.a.x;
    CGFloat b = point.y - line.a.y;
    CGFloat c = line.b.x - line.a.x;
    CGFloat d = line.b.y - line.a.y;
    
    CGFloat e = a * c + b * d;
    CGFloat f = c * c + d * d;
    CGFloat test = e / f;
    
    CGPoint testPoint;
    
    if(test < 0.0)
    { testPoint = line.a; }
    
    else if (test > 1.0)
    { testPoint = line.b; }
    
    else
    {
        testPoint = (CGPoint){
            line.a.x + test * c,
            line.a.y + test * d
        };
    }
    
    return distanceBetweenPoints(point, testPoint);
}

BOOL isPointTriumphCCW(CGPoint first, CGPoint second, CGPoint third)
{ return ((third.y - first.y) * (second.x - first.x) > (second.y - first.y) * (third.x - first.x)); }

BOOL areLineSegmentsIntersecting(CGLine one, CGLine other)
{
    // Credits to http://www.bryceboe.com
    return ((isPointTriumphCCW(one.a, other.a, other.b) != isPointTriumphCCW(one.b, other.a, other.b)) &&
            (isPointTriumphCCW(one.a, one.b, other.a) != isPointTriumphCCW(one.a, one.b, other.b)));
}

BOOL doLinesHaveCommonPoints(CGLine one, CGLine other)
{
    return (CGPointEqualToPoint(one.a, other.a) ||
            CGPointEqualToPoint(one.a, other.b) ||
            CGPointEqualToPoint(one.b, other.a) ||
            CGPointEqualToPoint(one.b, other.b));
}

BOOL areLinesIntersecting(CGLine one, CGLine other)
{
    return (doLinesHaveCommonPoints(one, other) ||
            areLineSegmentsIntersecting(one, other));
}


#pragma mark - CGLine features with tolerance

void calculateCirclesForLine(CGLine *line)
{
    line->circleA = (CGCircle){line->a, line->width / 2.0};
    line->circleB = (CGCircle){line->b, line->width / 2.0};
}

BOOL areLineEndpointsOverlappingConsideringWidths(CGLine one, CGLine other)
{
    calculateCirclesForLine(&one);
    calculateCirclesForLine(&other);
    
    return ((areCirclesOverlapping(one.circleA, other.circleA) && areCirclesOverlapping(one.circleB, other.circleB)) ||
            (areCirclesOverlapping(one.circleA, other.circleB) && areCirclesOverlapping(one.circleB, other.circleA)));
}

BOOL linesHaveCommonPointsConsideringWidths(CGLine one, CGLine other)
{
    calculateCirclesForLine(&one);
    calculateCirclesForLine(&other);
    
    return (areCirclesOverlapping(one.circleA, other.circleA) ||
            areCirclesOverlapping(one.circleA, other.circleB) ||
            areCirclesOverlapping(one.circleB, other.circleA) ||
            areCirclesOverlapping(one.circleB, other.circleB));
}

BOOL isCircleOverlappingRect(CGCircle circle, CGRect rect)
{
    CGRect rectWithTolerance = rectFromRectWithMargin(rect, circle.radius);
    return CGRectContainsPoint(rectWithTolerance, circle.center);
}

BOOL isCircleOverlappingLineConsideringWidth(CGCircle circle, CGLine line)
{
    BOOL isOverlapping = NO;
    CGFloat widths = circle.radius + line.width / 2.0;
    isOverlapping = (distanceBetweenPointAndLineSegment(circle.center, line) <= widths);
    return isOverlapping;
}

BOOL areLinesIntersectingConsideringWidth(CGLine one, CGLine other)
{
    // Segments are intersecting.
    BOOL areIntersecting = areLineSegmentsIntersecting(one, other);
    if (areIntersecting) return areIntersecting;
    
    // Endpoints.
    calculateCirclesForLine(&one);
    calculateCirclesForLine(&other);
    return (isCircleOverlappingLineConsideringWidth(one.circleA, other) ||
            isCircleOverlappingLineConsideringWidth(one.circleB, other) ||
            isCircleOverlappingLineConsideringWidth(other.circleA, one) ||
            isCircleOverlappingLineConsideringWidth(other.circleB, one));
}
