//
//  MyScene.h
//  RocketCarCanyon
//

//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate, UIAccelerometerDelegate>
{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    double currentMaxAccelX;
    double currentMaxAccelY;
}
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic) SKSpriteNode * rocketCar;

@end
