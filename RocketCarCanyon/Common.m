//
//  Common.m
//  RocketCarCanyon
//
//  Created by Sandquist, Cassandra G on 7/24/14.
//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import "Common.h"

@implementation Common

const float WALL_HEIGHT = 15.0;


+(int)getRandomNumberBetween:(int)from to:(int)to
{
    return (int)from + arc4random() % (to - from + 1);
}
+ (UIColor*)getRandomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0); //  0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5; //  0.5 to 1.0, away from white
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5; //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
