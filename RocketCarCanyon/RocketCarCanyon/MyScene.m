//
//  MyScene.m
//  RocketCarCanyon
//
//  Created by Cassandra Sandquist on 2/8/2014.
//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size])
    {
        screenRect = [[UIScreen mainScreen] bounds];
        screenHeight = screenRect.size.height;
        screenWidth = screenRect.size.width;
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.33 green:0.18 blue:0 alpha:1.0];
        
        self.rocketCar = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(25, 25)];
        self.rocketCar.position = CGPointMake(CGRectGetMidX(self.frame),(CGRectGetMinY(self.frame) + self.rocketCar.size.height));
        
        [self addChild:self.rocketCar];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 0.2;
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             [self outputAccelertionData:accelerometerData.acceleration];
             if(error)
             {
                 NSLog(@"%@", error);
             }
             
         }];
    }
    return self;
}
-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;

    if(fabs(acceleration.x) > fabs(currentMaxAccelX))
    {
        currentMaxAccelX = acceleration.x;
    }
    if(fabs(acceleration.y) > fabs(currentMaxAccelY))
    {
        currentMaxAccelY = acceleration.y;
    }
}
-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    float maxX, maxY, minX, minY, newY, newX, adjustedMaxXAccel, adjustedMaxYAccel;
    
    maxY = screenWidth - self.rocketCar.size.width/2;
    minY = self.rocketCar.size.width/2;
    
    maxX = screenHeight - self.rocketCar.size.height/2;
    minX = self.rocketCar.size.height/2;
    
    adjustedMaxXAccel = MAX((currentMaxAccelX * 10 + self.rocketCar.position.x), minY);
    newX = MIN(adjustedMaxXAccel,maxY);
    
    //plus six so that tilt works for y, otherwise have to flip iDevice
    adjustedMaxYAccel = MAX((currentMaxAccelY * 10 + 6.0 + self.rocketCar.position.y), minX);
    newY = MIN(adjustedMaxYAccel, maxX);
    
    self.rocketCar.position = CGPointMake(newX, newY);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
}

-(void)startCar
{
    
}

@end
