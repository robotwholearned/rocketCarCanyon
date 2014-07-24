//
//  Common.h
//  RocketCarCanyon
//
//  Created by Sandquist, Cassandra G on 7/24/14.
//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

extern NSString *SiteApiURL;

+(int)getRandomNumberBetween:(int)from to:(int)to;
+(UIColor*)getRandomColor;

@end
