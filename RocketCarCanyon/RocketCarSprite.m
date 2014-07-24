//
//  RocketCarSprite.m
//  RocketCarCanyon
//
//  Created by Sandquist, Cassandra G on 7/24/14.
//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import "RocketCarSprite.h"

static NSString* rocketCarCategoryName = @"rocketCar";
static const uint32_t rocketCarCategory = 0x1 << 0;
static NSString* wallCategoryName = @"wall";
static const uint32_t wallCategory = 0x1 << 1;

@implementation RocketCarSprite

-(instancetype)init{
    
    self = [super init];
    if (self) {
        self = [[RocketCarSprite alloc] initWithColor:[SKColor redColor] size:CGSizeMake(25.0, 25.0)];
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = rocketCarCategory;
        self.physicsBody.contactTestBitMask = wallCategory;
        self.physicsBody.collisionBitMask = wallCategory;

        self.physicsBody.linearDamping = 0.0f;
        self.physicsBody.allowsRotation = NO;
        self.name = rocketCarCategoryName;
   
    }
    return self;
}

@end
