//
//  MyScene.m
//  RocketCarCanyon
//
//  Created by Cassandra Sandquist on 2/8/2014.
//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import "MyScene.h"
#import "GameOverScene.h"
#import "WallSprite.h"

const float WALL_DELTA = 10;

static NSString* rocketCarCategoryName = @"rocketCar";
static NSString* wallCategoryName = @"wall";

static const uint32_t rocketCarCategory = 0x1 << 0;
static const uint32_t wallCategory = 0x1 << 1;

@interface MyScene ()

@property (nonatomic) CFTimeInterval previousTime;
@property (nonatomic) CFTimeInterval timeCounter;
@property (nonatomic) BOOL isTouchingCar;
@property (nonatomic) int distanceSurvived;
@property (nonatomic) int numWallsAdded;

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

#warning equator is for testing only
        SKSpriteNode* verticalEquator = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(2, screenHeight)];
        verticalEquator.position = CGPointMake(screenWidth / 2, verticalEquator.size.height / 2);
        [self addChild:verticalEquator];

        self.rocketCar = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(25, 25)];
        float rocketCarStartX = (((SKSpriteNode*)self.sisterWalls[0]).position.x + ((SKSpriteNode*)self.walls[0]).position.x) / 2;
        self.rocketCar.position = CGPointMake(rocketCarStartX, (CGRectGetMinY(self.frame) + self.rocketCar.size.height));
        self.rocketCar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.rocketCar.size];
        self.rocketCar.physicsBody.categoryBitMask = rocketCarCategory;
        self.rocketCar.physicsBody.contactTestBitMask = wallCategory;
        self.rocketCar.physicsBody.collisionBitMask = wallCategory;

        self.rocketCar.physicsBody.linearDamping = 0.0f;
        self.rocketCar.physicsBody.allowsRotation = NO;
        self.rocketCar.name = rocketCarCategoryName;

        [self addChild:self.rocketCar];

        self.previousTime = 0;
        self.numWallsAdded = 0;
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
#pragma mark Wall Handling
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
    int randomSeed = [Common getRandomNumberBetween:25 to:(screenWidth / 2 - 25)];

    WallSprite* firstWall = [[WallSprite alloc] initWithWallWidth:randomSeed];
    WallSprite* firstSisterWall = [[WallSprite alloc] initWithWallWidth:screenWidth - (randomSeed + screenWidth / 2)];

    firstWall.position = CGPointMake(firstWall.size.width / 2, WALL_HEIGHT / 2);
    firstSisterWall.position = CGPointMake(screenWidth - (firstSisterWall.size.width / 2), WALL_HEIGHT / 2);

    [self.walls addObject:firstWall];
    [self.sisterWalls addObject:firstSisterWall];

    [self addChild:firstWall];
    [self addChild:firstSisterWall];

    for (int i = 1; i < screenHeight / WALL_HEIGHT; i++) {
        [self addWallsAtLastWalls:i];
    }
}
- (void)addWallsAtLastWalls:(int)index
{
    SKSpriteNode* previousWall = self.walls[index - 1];

    float nextWidth = [Common getRandomNumberBetween:previousWall.size.width - WALL_DELTA to:previousWall.size.width + WALL_DELTA];
    if (nextWidth >= screenWidth / 2) {
        nextWidth = (screenWidth / 2 - WALL_DELTA);
    } else if (nextWidth < WALL_DELTA) {
        nextWidth = WALL_DELTA;
    }
    float nextSisterWidth = screenWidth - (nextWidth + screenWidth / 2); //nextX+screenWidth/2;

    WallSprite* nextWall = [[WallSprite alloc] initWithWallWidth:nextWidth];
    WallSprite* nextSisterWall = [[WallSprite alloc] initWithWallWidth:nextSisterWidth];

    float nextY = (index * WALL_HEIGHT) + (WALL_HEIGHT / 2);

    nextWall.position = CGPointMake(nextWall.size.width / 2, nextY);
    nextSisterWall.position = CGPointMake(screenWidth - (nextSisterWidth / 2), nextY);

    [self.walls addObject:nextWall];
    [self.sisterWalls addObject:nextSisterWall];
    [self addChild:nextSisterWall];
    [self addChild:nextWall];
    self.numWallsAdded++;
}

#pragma mark physics contact delegate
- (void)didBeginContact:(SKPhysicsContact*)contact
{
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;

    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if (firstBody.categoryBitMask == rocketCarCategory && secondBody.categoryBitMask == wallCategory) {
        GameOverScene* gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size distanceTraveled:self.distanceSurvived];
        [self.view presentScene:gameOverScene];
    }
}
#pragma mark Touch Event Handlers
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    /* Called when a touch begins */
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:location];
    
    if (body && [body.node.name isEqualToString:rocketCarCategoryName]) {
        NSLog(@"Began touch on car");
        self.isTouchingCar = YES;
    }
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    CGPoint previousLocation = [touch previousLocationInNode:self];
    
    SKSpriteNode* rocketCar = (SKSpriteNode*)[self childNodeWithName:rocketCarCategoryName];
    
    int rocketCarX = rocketCar.position.x + (location.x - previousLocation.x);
    int rocketCarY = rocketCar.position.y + (location.y - previousLocation.y);
    
    rocketCarX = MAX(rocketCarX, rocketCar.size.width / 2);
    rocketCarX = MIN(rocketCarX, self.size.width - rocketCar.size.width / 2);
    
    rocketCarY = MAX(rocketCarY, rocketCar.size.height/2);
    rocketCarY = MIN(rocketCarY, self.size.height-rocketCar.size.height/2);
    
    rocketCar.position = CGPointMake(rocketCarX, rocketCarY);
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    self.isTouchingCar = NO;
}
@end
