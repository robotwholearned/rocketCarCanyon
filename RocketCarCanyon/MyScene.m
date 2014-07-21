//
//  MyScene.m
//  RocketCarCanyon
//
//  Created by Cassandra Sandquist on 2/8/2014.
//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import "MyScene.h"

const float WALL_HEIGHT = 15.0;
const float WALL_DELTA = 10;

static const uint32_t rocketCarCategory = 0x1 << 0;
static const uint32_t wallCategory = 0x1 << 1;

@interface MyScene ()

@property (nonatomic) CFTimeInterval previousTime;
@property (nonatomic) CFTimeInterval timeCounter;

@end

@implementation MyScene {
    SKAction* actionMoveUp;
    SKAction* actionMoveDown;
}

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        screenHeight = self.size.height;
        screenWidth = self.size.width;

        /* Setup your scene here */

        self.backgroundColor = [SKColor colorWithRed:0.33 green:0.18 blue:0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;

        self.walls = [NSMutableArray new];
        self.sisterWalls = [NSMutableArray new];
        [self startWalls];

        SKSpriteNode* verticalEquator = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(2, screenHeight)];
        verticalEquator.position = CGPointMake(screenWidth / 2, verticalEquator.size.height / 2);
        [self addChild:verticalEquator];

        self.rocketCar = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(50, 25)];
        NSLog(@"Starting x's: %f, %f", ((SKSpriteNode*)self.walls[0]).position.x, ((SKSpriteNode*)self.sisterWalls[0]).position.x);
        float rocketCarStartX = (((SKSpriteNode*)self.sisterWalls[0]).position.x + ((SKSpriteNode*)self.walls[0]).position.x) / 2;
        NSLog(@"Starting x: %f", rocketCarStartX);
        self.rocketCar.position = CGPointMake(rocketCarStartX, (CGRectGetMinY(self.frame) + self.rocketCar.size.height));
        self.rocketCar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.rocketCar.size];
        self.rocketCar.physicsBody.categoryBitMask = rocketCarCategory;
        self.rocketCar.physicsBody.collisionBitMask = wallCategory;

        [self addChild:self.rocketCar];

        self.previousTime = 0;
    }
    return self;
}
- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */

    if (self.previousTime == 0) {
        self.previousTime = currentTime;
    }
    self.timeCounter += currentTime - self.previousTime;
    if (self.timeCounter > 0.5) {
        self.timeCounter = 0;
        [self updateWalls];
    }
    self.previousTime = currentTime;
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    /* Called when a touch begins */
    for (UITouch* touch in touches) {
        CGPoint location = [touch locationInNode:self.scene];
        CGPoint fixedLocation = CGPointMake(location.x, (CGRectGetMinY(self.frame) + self.rocketCar.size.height));
        self.rocketCar.position = fixedLocation;
    }
}
- (void)updateWalls
{
    //infiniti walls
    [self addWallsAtLastWalls:(int)[self.walls count]];

    for (SKSpriteNode* wall in self.walls) {
        SKAction* moveDownByHeight = [SKAction moveTo:CGPointMake(wall.position.x, wall.position.y - WALL_HEIGHT) duration:0];
        [wall runAction:moveDownByHeight];
    }
    for (SKSpriteNode* wall in self.sisterWalls) {
        SKAction* moveDownByHeight = [SKAction moveTo:CGPointMake(wall.position.x, wall.position.y - WALL_HEIGHT) duration:0];
        [wall runAction:moveDownByHeight];
    }

    //remove walls off screen
    [[self.walls objectAtIndex:0] removeFromParent];
    [self.walls removeObjectAtIndex:0];

    [[self.sisterWalls objectAtIndex:0] removeFromParent];
    [self.sisterWalls removeObjectAtIndex:0];
}
- (void)startWalls
{
    int randomSeed = [self getRandomNumberBetween:25 to:(screenWidth / 2 - 25)];
    //int randomSeed = 283;
    NSLog(@"Random seed: %i", randomSeed);
    SKSpriteNode* firstWall = [self makeWallWithWidth:randomSeed];
    SKSpriteNode* firstSisterWall = [self makeWallWithWidth:screenWidth - (randomSeed + screenWidth / 2)];

    firstWall.position = CGPointMake(firstWall.size.width / 2, WALL_HEIGHT / 2);
    firstSisterWall.position = CGPointMake(screenWidth - (firstSisterWall.size.width / 2), WALL_HEIGHT / 2);

    [self.walls addObject:firstWall];
    [self.sisterWalls addObject:firstSisterWall];

    [self addChild:firstWall];
    [self addChild:firstSisterWall];

    for (int i = 1; i < screenHeight / WALL_HEIGHT; i++) {
        //NSLog(@"Make block %i", i);
        [self addWallsAtLastWalls:i];
    }
}
- (void)addWallsAtLastWalls:(int)index
{
    SKSpriteNode* previousWall = self.walls[index - 1];

    float nextWidth = [self getRandomNumberBetween:previousWall.size.width - WALL_DELTA to:previousWall.size.width + WALL_DELTA];
    if (nextWidth >= screenWidth / 2) {
        NSLog(@"1: nextWidth: %f", nextWidth);
        nextWidth = (screenWidth / 2 - WALL_DELTA);
    } else if (nextWidth < WALL_DELTA) {
        NSLog(@"2: nextWidth: %f", nextWidth);
        nextWidth = WALL_DELTA;
    }
    float nextSisterWidth = screenWidth - (nextWidth + screenWidth / 2); //nextX+screenWidth/2;

    SKSpriteNode* nextWall = [self makeWallWithWidth:nextWidth];
    SKSpriteNode* nextSisterWall = [self makeWallWithWidth:nextSisterWidth];

    float nextY = (index * WALL_HEIGHT) + (WALL_HEIGHT / 2);

    nextWall.position = CGPointMake(nextWall.size.width / 2, nextY);
    nextSisterWall.position = CGPointMake(screenWidth - (nextSisterWidth / 2), nextY);

    [self.walls addObject:nextWall];
    [self.sisterWalls addObject:nextSisterWall];
    [self addChild:nextSisterWall];
    [self addChild:nextWall];
}
- (SKSpriteNode*)makeWallWithWidth:(float)wallWidth
{
    SKSpriteNode* wall = [SKSpriteNode spriteNodeWithColor:[self getRandomColor] size:CGSizeMake(wallWidth, WALL_HEIGHT)];
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.size];
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
- (UIColor*)getRandomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0); //  0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5; //  0.5 to 1.0, away from white
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5; //  0.5 to 1.0, away from black

    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
