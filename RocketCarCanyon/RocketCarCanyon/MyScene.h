//
//  MyScene.h
//  RocketCarCanyon
//

//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

// These constanst are used to define the physics interactions between physics bodies in the scene.
static const uint32_t rocketCarCategory =  0x1 << 0;
static const uint32_t wallCategory      =  0x1 << 1;
//static const uint32_t edgeCategory      =  0x1 << 2;

@interface MyScene : SKScene <SKPhysicsContactDelegate, UIAccelerometerDelegate>
{
    CGRect  screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    double currentMaxAccelX;
    double currentMaxAccelY;
}
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic) SKSpriteNode *rocketCar;
@property (strong, nonatomic) NSMutableArray *walls;
@property (strong, nonatomic) NSMutableArray *sisterWalls;

@end
