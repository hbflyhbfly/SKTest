//
//  MyScene.m
//  SKTest
//
//  Created by Syuuhi on 13-10-12.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import "MyScene.h"
#import "SpaceShip.h"
#import "Invader.h"
#import "GameOverScene.h"

#define kScoreName @"score"
#define kHealthHudName @"health"
#define kInvaderGridSpacing CGSizeMake(12, 12)
#define kInvaderRowCount 6
#define kInvaderColCount 6

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    if(!self.contentCreated){
        [self creatContent];
        self.userInteractionEnabled = YES;
        self.contentCreated = YES;
        self.physicsWorld.contactDelegate = self;
        self.physicsBody.categoryBitMask = kSceneEdgeCategory;
    }
}

-(void)creatContent{
    self.score = 0;
    self.health = 1.0;
    self.gameOver = NO;
    self.contactQueue = [NSMutableArray array];
    self.invaderQueue = [NSMutableArray array];
    SpaceShip *spaceShip = [[SpaceShip alloc]initWith:CGPointMake(self.frame.size.width/2, 100)];
    _mySpaceShip = spaceShip;
    [self addChild:_mySpaceShip];
    [self setupInvaders];
    [self setupHud];
    self.invaderMovementDirection = InvaderMovementDirectionRight;
    self.timePerMove = 0.0;
    self.timeOfLastMove = 0.0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
//    UITouch * touch = [touches anyObject];
//        CGPoint target = [touch locationInNode:self];
//        SpaceShip *mySpaceShip = (SpaceShip *)[self childNodeWithName:kShipName];
//        CGPoint location = mySpaceShip.position;
//        CGFloat angle = atan((target.x - location.x)/(target.y-location.y));
//        angle = angle+M_PI/2;
//        SKAction *action = [SKAction rotateByAngle:mySpaceShip.angle-angle duration:0.1];
//        [mySpaceShip runAction:[SKAction repeatAction:action count:1]];
//        [mySpaceShip setAngle:angle];
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        if (n != self && [n.name isEqual: @"restartLabel"]) {
            [[self childNodeWithName:@"restartLabel"] removeFromParent];
            [[self childNodeWithName:@"winLoseLabel"] removeFromParent];
            [self creatContent];
            return;
        }
    }
    
    //do not process anymore touches since it's game over
    if (_gameOver) {
        return;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _mySpaceShip.touched = NO;
}


- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_mySpaceShip position];
    if([[_mySpaceShip name] isEqualToString:kShipName]) {
        [_mySpaceShip setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
        _mySpaceShip.touched = YES;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    CGPoint previousPosition = [touch previousLocationInNode:self];
    CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    [self panForTranslation:translation];
}


-(void)update:(NSTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self moveInvaderForUpdate:currentTime];
    [self fireShipBullets:InvaderFiredBulletType];
    if (_mySpaceShip.touched == YES) {
        [self fireShipBullets:ShipFiredBulletType];
    }
    
    [self processContactsForUpdate:currentTime];
}

-(void)setupInvaders {

    CGPoint baseOrigin = CGPointMake(kInvaderSize.width / 2, 800);
    for (NSUInteger row = 0; row < kInvaderRowCount; ++row) {

        InvaderType invaderType;
        if (row % 3 == 0)      invaderType = InvaderTypeA;
        else if (row % 3 == 1) invaderType = InvaderTypeB;
        else                   invaderType = InvaderTypeC;

        CGPoint invaderPosition = CGPointMake(baseOrigin.x, row * (kInvaderGridSpacing.height + kInvaderSize.height) + baseOrigin.y);
        
        for (NSUInteger col = 0; col < kInvaderColCount; ++col) {
            Invader *invader = [[Invader alloc]initWithLocation:invaderPosition withType:invaderType];
            [_invaderQueue addObject:invader];
            [self addChild:invader];
            invaderPosition.x += kInvaderSize.width + kInvaderGridSpacing.width;
        } 
    } 
}

#pragma mark - setupHud Helpers
-(void)setupHud{
    SKLabelNode* scoreLable = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    scoreLable.name = kScoreName;
    scoreLable.fontSize =15;
    scoreLable.fontColor = [SKColor blackColor];
    scoreLable.text = [NSString stringWithFormat:@"Score: %ld",self.score];
    scoreLable.position = CGPointMake(scoreLable.frame.size.width/2+20, self.size.height-(scoreLable.frame.size.height/2+35));
    [self addChild:scoreLable];
    
    SKLabelNode* healthLable = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    healthLable.name = kHealthHudName;
    healthLable.fontSize = 15;
    healthLable.fontColor = [SKColor blackColor];
    healthLable.text = [NSString stringWithFormat:@"Health: %.1f",self.health*100.0f];
    healthLable.position = CGPointMake(self.frame.size.width - (scoreLable.frame.size.width/2+35), self.size.height-(scoreLable.frame.size.height/2+35));
    [self addChild:healthLable];
    
}

#pragma mark - Scene Update Helpers
-(void)moveInvaderForUpdate:(NSTimeInterval)currentTime{
    
    [self determineInvaderMovementDirection];
    
    [self enumerateChildNodesWithName:kInvaderName usingBlock:^(SKNode *node, BOOL *stop) {
        switch (self.invaderMovementDirection) {
            case InvaderMovementDirectionRight:
                node.position = CGPointMake(node.position.x + 5, node.position.y);
                break;
            case InvaderMovementDirectionLeft:
                node.position = CGPointMake(node.position.x - 5, node.position.y);
                break;
            case InvaderMovementDirectionDownThenRight:
            case InvaderMovementDirectionDownThenLeft:
                node.position = CGPointMake(node.position.x, node.position.y - 10);
                break;
            InvaderMovementDirectionNone:
            default:
                break;
        }
    }];
    self.timeOfLastMove = currentTime;
}

#pragma mark - Invader Movement Helpers
-(void)determineInvaderMovementDirection{
    __block InvaderMovementDirection proposedMovementDirection = self.invaderMovementDirection;
    [self enumerateChildNodesWithName:kInvaderName usingBlock:^(SKNode *node, BOOL *stop) {
        switch (proposedMovementDirection) {
            case InvaderMovementDirectionRight:
                if (CGRectGetMaxX(node.frame)>=node.scene.size.width - 1.0f) {
                    proposedMovementDirection = InvaderMovementDirectionDownThenLeft;
                    *stop = YES;
                }
                break;
            case InvaderMovementDirectionLeft:
                if (CGRectGetMinX(node.frame)<=1.0f) {
                    proposedMovementDirection = InvaderMovementDirectionDownThenRight;
                    *stop = YES;
                }
                break;
            case InvaderMovementDirectionDownThenRight:
                proposedMovementDirection = InvaderMovementDirectionRight;
                *stop = YES;
                break;
            case InvaderMovementDirectionDownThenLeft:
                proposedMovementDirection = InvaderMovementDirectionLeft;
                *stop = YES;
                break;
            default:
                break;
        }
    }];
    if (proposedMovementDirection != self.invaderMovementDirection) {
        self.invaderMovementDirection = proposedMovementDirection;
    }
}
#pragma mark - Fire Helpers
-(void)fireShipBullets:(BulletType)bulletType {
    SKNode* existingInvaderBullet = [self childNodeWithName:kInvaderFiredBulletName];
    SpaceShip *ship = (SpaceShip*)[self childNodeWithName:kShipName];
    SKNode* shipFiredbullet = [ship makeBulletOfType:bulletType];
    switch (bulletType) {
        case InvaderFiredBulletType:

            if (!existingInvaderBullet) {
                NSMutableArray* allInvaders = [NSMutableArray array];
                [self enumerateChildNodesWithName:kInvaderName usingBlock:^(SKNode *node, BOOL *stop) {
                    [allInvaders addObject:node];
                }];
                if ([allInvaders count] > 0) {
                    NSUInteger InvadersIndex = arc4random_uniform((int)[allInvaders count]);
                    Invader* invader = (Invader*)[allInvaders objectAtIndex:InvadersIndex];
                    SKNode* invaderFiredbullet = [invader makeBulletOfType:bulletType];
                    invaderFiredbullet.position = CGPointMake(invader.position.x, invader.position.y - invader.frame.size.height - invaderFiredbullet.frame.size.height / 2);
                    CGPoint bulletDestination = CGPointMake(invader.position.x, -invaderFiredbullet.frame.size.height/2);
                    [invader releaseBullet:invaderFiredbullet toDestination:bulletDestination withDuration:2 withFrequency:1];
                }
                
            }
            break;
        case ShipFiredBulletType:
            shipFiredbullet.position = CGPointMake(ship.position.x, ship.position.y + ship.frame.size.height - shipFiredbullet.frame.size.height / 2);
            CGPoint bulletDestination = CGPointMake(ship.position.x, self.frame.size.height + shipFiredbullet.frame.size.height / 2);
            [ship releaseBullet:shipFiredbullet toDestination:bulletDestination withDuration:2 withFrequency:1];
            break;
            default:
            break;
    }
    }
#pragma mark – Physics Contact Helpers
-(void)didBeginContact:(SKPhysicsContact *)contact{
    [self.contactQueue addObject:contact];
}
-(void)handleContact:(SKPhysicsContact*)contact {

    if (!contact.bodyA.node.parent || !contact.bodyB.node.parent) return;
    
    NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
    if ([nodeNames containsObject:kShipName] && [nodeNames containsObject:kInvaderFiredBulletName]) {
        // Invader bullet hit a ship
        [self runAction:[SKAction playSoundFileNamed:@"Hit.wav" waitForCompletion:NO]];
        if (self.health <= 0) {
            [contact.bodyA.node removeFromParent];
            [contact.bodyB.node removeFromParent];
        } else {
            SpaceShip* ship = (SpaceShip*)[self childNodeWithName:kShipName];
            if (ship == contact.bodyA.node) {
                [contact.bodyB.node removeFromParent];
            }else{
                [contact.bodyA.node removeFromParent];
            }
        }
        [self updateHealthWith:-0.334f];
    } else if ([nodeNames containsObject:kInvaderName] && [nodeNames containsObject:kShipFiredBulletName]) {
        // Ship bullet hit an invader
        [self runAction:[SKAction playSoundFileNamed:@"Hit.wav" waitForCompletion:NO]];
        [contact.bodyA.node removeFromParent]; 
        [contact.bodyB.node removeFromParent];
        [self updateScoreWith:100];
        if (![self childNodeWithName:kInvaderName]) {
            //win
            [self endTheScene:kEndReasonWin];
        }
    } 
}
-(void)processContactsForUpdate:(NSTimeInterval)currentTime {
    for (SKPhysicsContact* contact in [self.contactQueue copy]) {
        [self handleContact:contact];
        [self.contactQueue removeObject:contact];
    } 
}

#pragma mark - Hud Update Helpers
-(void)updateScoreWith:(NSInteger)point{
    self.score += point;
    SKLabelNode* score = (SKLabelNode*)[self childNodeWithName:kScoreName];
    score.text = [NSString stringWithFormat:@"Score: %ld",self.score];
    
}
-(void)updateHealthWith:(CGFloat)adjustment{
    self.health = MAX(self.health+adjustment, 0);
    SKLabelNode* health = (SKLabelNode*)[self childNodeWithName:kHealthHudName];
    health.text = [NSString stringWithFormat:@"Health: %.1f",self.health*100.0f];
    if (self.health<=0) {
        [self endTheScene:kEndReasonLose];
    }
    
}

- (void)endTheScene:(EndReason)endReason {
    if (_gameOver) {
        return;
    }
    
    [self removeAllActions];
    [self removeAllChildren];
    _gameOver = YES;
    
    NSString *message;
    if (endReason == kEndReasonWin) {
        message = @"You win!";
    } else if (endReason == kEndReasonLose) {
        message = @"You lost!";
    }
    
    SKLabelNode *label;
    label = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    label.name = @"winLoseLabel";
    label.text = message;
    label.scale = 0.1;
    label.position = CGPointMake(self.frame.size.width/2, self.frame.size.height * 0.6);
    label.fontColor = [SKColor yellowColor];
    [self addChild:label];
    
    SKLabelNode *restartLabel;
    restartLabel = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    restartLabel.name = @"restartLabel";
    restartLabel.text = @"Play Again?";
    restartLabel.scale = 0.5;
    restartLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height * 0.4);
    restartLabel.fontColor = [SKColor yellowColor];
    [self addChild:restartLabel];
    
    SKAction *labelScaleAction = [SKAction scaleTo:1.0 duration:0.5];
    
    [restartLabel runAction:labelScaleAction];
    [label runAction:labelScaleAction];
    
}
@end



