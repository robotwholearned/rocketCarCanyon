//
//  MyScene.m
//  RocketCarCanyon
//
//  Created by Cassandra Sandquist on 2/8/2014.
//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import "MyScene.h"

const float WALL_HEIGHT = 25.0;
const float WALL_WIDTH = 25.0;

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        //screenRect = [[UIScreen mainScreen] bounds];
        
        screenHeight = self.size.height;
        screenWidth = self.size.width;
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.33 green:0.18 blue:0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        self.walls = [NSMutableArray new];
        self.sisterWalls = [NSMutableArray new];
        [self startWalls];
        
        self.rocketCar = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(25, 25)];
        NSLog(@"Starting x's: %f, %f", ((SKSpriteNode *)self.walls[0]).position.x , ((SKSpriteNode *)self.sisterWalls[0]).position.x );
        float rocketCarStartX = (((SKSpriteNode *)self.sisterWalls[0]).position.x + ((SKSpriteNode *)self.walls[0]).position.x )/2;
        NSLog(@"Starting x: %f", rocketCarStartX);
        self.rocketCar.position = CGPointMake(rocketCarStartX,(CGRectGetMinY(self.frame) + self.rocketCar.size.height));
        self.rocketCar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.rocketCar.size];
        self.rocketCar.physicsBody.categoryBitMask = rocketCarCategory;
        self.rocketCar.physicsBody.collisionBitMask = wallCategory;
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
    
    //get all walls
    //    self.walls
    //    self.sisterWalls
    //move each wall down 1 height
    //    ((SKSpriteNode *)[self.walls objectAtIndex:0]).position.y -= (WALL_HEIGHT);
    //add walls at top
    //remove walls off screen
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
}
-(void)startWalls
{
    SKSpriteNode *firstWall = [self makeWall];
    SKSpriteNode *firstSisterWall = [self makeWall];
    
    int startPosition = [self getRandomNumberBetween:WALL_WIDTH to:screenWidth/3];
    firstWall.position = CGPointMake(startPosition, WALL_HEIGHT/2);
    firstSisterWall.position = CGPointMake(startPosition+screenWidth/2, WALL_HEIGHT/2);
    
    NSLog(@"first wall position: (%f,%f) ",  firstWall.position.x, firstWall.position.y);
    NSLog(@"first sister wall position: (%f,%f) ",  firstSisterWall.position.x, firstSisterWall.position.y);
    NSLog(@"view: (%f,%f) ",  screenWidth, screenHeight);
    
    [self.walls addObject:firstWall];
    [self.sisterWalls addObject:firstSisterWall];
    
    [self addChild:firstWall];
    [self addChild:firstSisterWall];
    
    for(int i = 1; i < screenHeight/WALL_HEIGHT; i++)
    {
        //NSLog(@"Make block %i", i);
        SKSpriteNode *nextWall = [self makeWall];
        SKSpriteNode *nextSisterWall = [self makeWall];
        
        SKSpriteNode *previousWall = self.walls[i-1];
        
        int nextX = [self getRandomNumberBetween:previousWall.position.x-10 to:previousWall.position.x+10];
        if (nextX < WALL_WIDTH/2)
        {
            nextX +=10;
        }
        int nextY = i*WALL_HEIGHT+(WALL_HEIGHT/2);
        int nextSisterX = nextX+screenWidth/2;
        if (nextSisterX > screenWidth-(WALL_WIDTH/2)) {
            nextSisterX -= 10;
            nextX -= 10;
        }
        
        nextWall.position = CGPointMake(nextX, nextY);
        nextSisterWall.position = CGPointMake(nextSisterX, nextY);
        
        [self.walls addObject:nextWall];
        [self.sisterWalls addObject:nextSisterWall];
        [self addChild:nextSisterWall];
        [self addChild:nextWall];
    }
}
-(SKSpriteNode *)makeWall
{
    SKSpriteNode *wall = [SKSpriteNode spriteNodeWithColor:[self getRandomColor] size:CGSizeMake(WALL_HEIGHT, WALL_WIDTH)];
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
