//
//  WallSprite.m
//  RocketCarCanyon
//
//  Created by Sandquist, Cassandra G on 7/24/14.
//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import "WallSprite.h"

static NSString* wallCategoryName = @"wall";
static const uint32_t wallCategory = 0x1 << 1;

@implementation WallSprite

- (id) initWithWallWidth:(float)wallWidth {
    if (self = [super init]) {
        self = [WallSprite spriteNodeWithColor:[Common getRandomColor] size:CGSizeMake(wallWidth, WALL_HEIGHT)];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = wallCategory;
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.dynamic = NO;
        self.name = wallCategoryName;
        
    }
    return self;
}

@end
