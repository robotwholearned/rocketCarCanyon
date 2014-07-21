//
//  MyScene.h
//  RocketCarCanyon
//

//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

extern const float WALL_HEIGHT;
extern const float WALL_DELTA;

@interface MyScene : SKScene <SKPhysicsContactDelegate> {
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
}
@property (nonatomic) SKSpriteNode* rocketCar;
@property (strong, nonatomic) NSMutableArray* walls;
@property (strong, nonatomic) NSMutableArray* sisterWalls;

@end
