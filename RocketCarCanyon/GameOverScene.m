//
//  GameOverScene.m
//  BreakoutSpriteKitTutorial
//
//  Created by Cassandra Sandquist on 2014-07-21.
//  Copyright (c) 2014 Cassandra Sandquist. All rights reserved.
//

#import "GameOverScene.h"
#import "MyScene.h"

@implementation GameOverScene

- (id)initWithSize:(CGSize)size distanceTraveled:(int)distance
{
    self = [super initWithSize:size];

    if (self) {

        SKLabelNode* gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        gameOverLabel.fontSize = 35;
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

        self.backgroundColor = [UIColor redColor];
        gameOverLabel.text = [NSString stringWithFormat:@"You went %i units!", distance];

        [self addChild:gameOverLabel];
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    MyScene* rocketCarCanyonScene = [[MyScene alloc] initWithSize:self.size];

    [self.view presentScene:rocketCarCanyonScene];
}
@end
