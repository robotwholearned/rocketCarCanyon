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
        //        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        //        background.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        //        [self addChild:background];

        SKLabelNode* gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        gameOverLabel.fontSize = 42;
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
