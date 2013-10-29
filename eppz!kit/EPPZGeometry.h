//
//  EPPZGeometry.h
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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


static NSString *const version = @"eppz!geometry 1.0.0";


#pragma mark - Helpers

CGFloat cube(CGFloat scalar);
CGFloat absoluteValue(CGFloat scalar);
BOOL isOdd(int scalar);


#pragma mark - Randomizers

CGFloat randomNumberInRange(CGFloat range);
CGPoint randomPointInFrame(CGRect frame);


#pragma mark CGSize, CGRect helpers

CG_EXTERN const CGSize CGSizeOne;
CG_EXTERN const CGVector CGVectorZero;
CGPoint incrementPoint(CGPoint point);
CGSize sizeFromSizeWithPadding(CGSize size, CGFloat padding);
CGRect rectFromRectWithPadding(CGRect rect, CGFloat padding);
CGSize sizeFromSizeWithMargin(CGSize size, CGFloat margin);
CGRect rectFromRectWithMargin(CGRect rect, CGFloat margin);


#pragma mark - Trigonometry

CGVector vectorBetweenPoints(CGPoint from, CGPoint to);
CGFloat distanceBetweenPoints(CGPoint from, CGPoint to);
CGFloat angleBetweenPoints(CGPoint from, CGPoint to);

CGFloat degreesToRadians(CGFloat degrees);
CGFloat radiansToDegrees(CGFloat radians);


#pragma mark - Basic vector operations

CGVector vectorFromPoint(CGPoint point);
CGPoint pointFromVector(CGVector vector);

CGVector addVectors(CGVector one, CGVector other);
CGVector subtractVectors(CGVector one, CGVector other);
CGFloat lengthOfVector(CGVector vector);
CGVector scaleVector(CGVector vector, CGFloat scale);
CGVector normalizeVector(CGVector vector);
CGVector rotateVector(CGVector vector, CGFloat radians);

CGPoint addVectorPoints(CGPoint one, CGPoint other);
CGPoint subtractVectorPoints(CGPoint one, CGPoint other);
CGFloat lengthOfVectorPoint(CGPoint vectorPoint);
CGPoint scaleVectorPoint(CGPoint vectorPoint, CGFloat scale);
CGPoint normalizeVectorPoint(CGPoint vectorPoint);
CGPoint rotateVectorPoint(CGPoint vectorPoint, CGFloat radians);


#pragma mark - CGLine features

typedef struct
{
    CGPoint a;
    CGPoint b;
} CGLine;

CGRect boundingBoxOfLine(CGLine line);

CGFloat distanceBetweenPointAndLine(CGPoint point, CGLine line);
BOOL isPointTriumphCCW(CGPoint first, CGPoint second, CGPoint third);
BOOL areLineSegmentsIntersecting(CGLine one, CGLine other); // Does not evaluate endpoint overlapping.
BOOL doLinesHaveCommonPoints(CGLine one, CGLine other);
BOOL areLinesIntersecting(CGLine one, CGLine other);


#pragma mark - CGLine features (with tolerance)

BOOL pointsAreEqualWithTolerance(CGPoint one, CGPoint other, CGFloat tolerance);
BOOL linesAreEqualWithTolerance(CGLine one, CGLine other, CGFloat tolerance);
BOOL linesHaveCommonPointsWithTolerance(CGLine one, CGLine other, CGFloat tolerance);
BOOL isPointWithinBoundingBoxOfLineWithTolerance(CGPoint point, CGLine line, CGFloat tolerance);
BOOL isPointOnLineWithTolerance(CGPoint point, CGLine line, CGFloat tolerance);


#pragma mark - Circle features

typedef struct
{
    CGPoint center;
    CGFloat radius;
} CGCircle;

CGFloat circumfenceOfCircle(CGCircle circle);
CGFloat areaOfCircle(CGCircle circle);

typedef struct
{
    CGPoint a;
    CGPoint b;
    CGPoint c; // Point 'c' is the point where the line through the circle intersection points crosses the line between the circle centers.
    BOOL areCirclesIntersecting;
    BOOL areCirclesContainingEachOther;
} CGCircleIntersection;

CGCircleIntersection intersectionOfCircles(CGCircle one, CGCircle other);

