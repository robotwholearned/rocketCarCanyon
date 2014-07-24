//
//  WallSprite.m
//  RocketCarCanyon
//
//  Created by Sandquist, Cassandra G on 7/24/14.
//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import "WallSprite.h"

@implementation WallSprite

- (id) initWithWallWidth:(float)wallWidth {
    if (self = [super init]) {
        self = [WallSprite spriteNodeWithColor:[Common getRandomColor] size:CGSizeMake(wallWidth, WALL_HEIGHT)];
        [self setUpHeroDetails];
        
    }
    return self;
}

-(void) setUpHeroDetails {
    self.name = @"heroNode";
}

@end
