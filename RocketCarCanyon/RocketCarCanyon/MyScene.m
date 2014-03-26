//
//  MyScene.m
//  RocketCarCanyon
//
//  Created by Cassandra Sandquist on 2/8/2014.
//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        screenRect = [[UIScreen mainScreen] bounds];
        screenHeight = screenRect.size.height;
        screenWidth = screenRect.size.width;
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.33 green:0.18 blue:0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        self.rocketCar = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(25, 25)];
        self.rocketCar.position = CGPointMake(CGRectGetMidX(self.frame),(CGRectGetMinY(self.frame) + self.rocketCar.size.height));
        self.rocketCar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.rocketCar.size];
        self.rocketCar.physicsBody.categoryBitMask = rocketCarCategory;
        self.rocketCar.physicsBody.collisionBitMask = wallCategory;
        [self addChild:self.rocketCar];
        
        self.walls = [NSMutableArray new];
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
        [self startWalls];
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
-(void)startWalls
{
    SKSpriteNode *wall = [self makeWall];
    
    int startPosition = [self getRandomNumberBetween:wall.size.width to:self.size.width/3];
    wall.position = CGPointMake(startPosition, wall.size.height/2);
    NSLog(@"wall position: (%f,%f) ",  wall.position.x, wall.position.y);
    NSLog(@"view: (%f,%f) ",  self.size.width, self.size.height);
    
    [self.walls addObject:wall];
    [self addChild:self.walls[0]];
    
    for(int i = 1; i < (self.size.height)/wall.size.height; i++)
    {
        NSLog(@"Make %i block", i);
        SKSpriteNode *nextWall = [self makeWall];
        SKSpriteNode *sisterWall = [self makeWall];
        SKSpriteNode *previousWall = self.walls[i-1];
        int nextX = [self getRandomNumberBetween:previousWall.position.x-10 to:previousWall.position.x+10];
        int nextY = i*nextWall.size.height+(nextWall.size.height/2);
        int sisterX = nextX+300;
        nextWall.position = CGPointMake(nextX, nextY);
        sisterWall.position = CGPointMake(sisterX, nextY);
        NSLog(@"wall position: (%f,%f) ",  nextWall.position.x, nextWall.position.y);

        [self.walls addObject:nextWall];
        [self addChild:sisterWall];
        [self addChild:nextWall];
    }
}
-(SKSpriteNode *)makeWall
{
    SKSpriteNode *wall = [SKSpriteNode spriteNodeWithColor:[self getRandomColor] size:CGSizeMake(25, 25)];
    wall.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:wall.size];
    wall.physicsBody.categoryBitMask = wallCategory;
    wall.physicsBody.collisionBitMask = rocketCarCategory;
    wall.physicsBody.dynamic = NO;
    return wall;
}

/*Helper Methods*/
- (int)getRandomNumberBetween:(int)from to:(int)to
{
    return (int)from + arc4random() % (to - from + 1);
}
-(UIColor *)getRandomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}
@end
