//
//  EPPZGestureRecognizer.h
//  eppz!kit
//
//  Created by Borbas Geri on 4/30/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO Recognized SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>


@protocol EPPZGestureRecognizerDelegate <NSObject>
@optional
-(void)tapBeganWithLocation:(NSValue*) location;
-(void)tapEndedWithLocation:(NSValue*) location;
-(void)doubleTapRecognizedWithLocation:(NSValue*) location;
-(void)tripleTapRecognizedWithLocation:(NSValue*) location;
/*
-(void)panBeganRecognizedWithLocation:(CGPoint) location;
-(void)panChangedRecognizedWithLocation:(CGPoint) location;
-(void)panEndedRecognizedWithLocation:(CGPoint) location;
*/
-(void)pinchChangedScale:(NSNumber*) amount;
-(void)pinchEndedWithScale:(NSNumber*) amount;
-(void)longPressRecognized;
-(void)doubleLongPressRecognized;
-(void)tripleLongPressRecognized;
-(void)swipeUpRecognized;
-(void)swipeDownRecognized;
-(void)swipeLeftRecognized;
-(void)swipeRightRecognized;
-(void)doubleSwipeUpRecognized;
-(void)doubleSwipeDownRecognized;
-(void)doubleSwipeLeftRecognized;
-(void)doubleSwipeRightRecognized;
-(void)tripleSwipeUpRecognized;
-(void)tripleSwipeDownRecognized;
-(void)tripleSwipeLeftRecognized;
-(void)tripleSwipeRightRecognized;
@end


@interface EPPZGestureRecognizer : NSObject

    <UIGestureRecognizerDelegate>

+(id)gestureRecognizerWithView:(UIView*) view delegate:(id<EPPZGestureRecognizerDelegate>) delegate;
-(void)addTapGesture;
-(void)addDoubleTapGesture;
-(void)addTripleTapGesture;
/*
-(void)addPanGesture;
*/
-(void)addPinchGesture;
-(void)addLongPressGesture;
-(void)addDoubleLongPressGesture;
-(void)addTripleLongPressGesture;
-(void)addSwipeUpGesture;
-(void)addSwipeDownGesture;
-(void)addSwipeLeftGesture;
-(void)addSwipeRightGesture;
-(void)addDoubleSwipeUpGesture;
-(void)addDoubleSwipeDownGesture;
-(void)addDoubleSwipeLeftGesture;
-(void)addDoubleSwipeRightGesture;
-(void)addTripleSwipeUpGesture;
-(void)addTripleSwipeDownGesture;
-(void)addTripleSwipeLeftGesture;
-(void)addTripleSwipeRightGesture;


@end
