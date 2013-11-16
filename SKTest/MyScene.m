//
//  MyScene.m
//  SKTest
//
//  Created by Syuuhi on 13-10-12.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import "MyScene.h"
#import "SpaceShip.h"

#define kInvaderSize CGSizeMake(24, 16)
#define kInvaderName @"invader"
#define kScoreName @"score"
#define kHealthHudName @"health"
#define kShipName @"spaceShip"
#define kInvaderGridSpacing CGSizeMake(12, 12)
#define kInvaderRowCount 6
#define kInvaderColCount 6

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    if(!self.contentCreated){
        [self creatContent];
        //self.motionManager = [[CMMotionManager alloc]init];
        //[self.motionManager startAccelerometerUpdates];
        self.tapQueue = [NSMutableArray array];
        self.userInteractionEnabled = YES;
        self.contentCreated = YES;
        self.contactQueue = [NSMutableArray array];
        self.physicsWorld.contactDelegate = self;
        self.score = 0;
        self.health = 1.0;
    }
}

-(void)creatContent{
    
    //SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    CGPoint location = CGPointMake(self.frame.size.width/2, 100);
    //sprite.position = loaction;
    SpaceShip *spaceShip = [[SpaceShip alloc]initWith:location];
    [spaceShip setName:kShipName];
    spaceShip.physicsBody.categoryBitMask = kShipCategory;
    spaceShip.physicsBody.contactTestBitMask = 0x0;
    spaceShip.physicsBody.collisionBitMask = kSceneEdgeCategory;
    _mySpaceShip = spaceShip;
    self.physicsBody.categoryBitMask = kSceneEdgeCategory;
    //self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
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
    if (_mySpaceShip.touched == YES) {
        [self fireShipBullets];
    }
    
    [self processContactsForUpdate:currentTime];
}

-(SKSpriteNode*)makeInvaderOfType:(InvaderType)invaderType{
    SKColor* invaderColor;
    switch (invaderType) {
        case InvaderTypeA:
            invaderColor = [SKColor redColor];
            break;
        case InvaderTypeB:
            invaderColor = [SKColor greenColor];
            break;
        case InvaderTypeC:
        default:
            invaderColor = [SKColor blueColor];
            break;
    }

    SKSpriteNode* invader = [SKSpriteNode spriteNodeWithColor:invaderColor size:kInvaderSize];
    invader.name = kInvaderName;
    invader.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:invader.frame.size];
    invader.physicsBody.dynamic = NO;
    invader.physicsBody.categoryBitMask = kInvaderCategory;
    invader.physicsBody.contactTestBitMask = 0x0;
    invader.physicsBody.collisionBitMask = 0x0;
    return invader;
}

-(void)setupInvaders {

    CGPoint baseOrigin = CGPointMake(kInvaderSize.width / 2, 800);
    for (NSUInteger row = 0; row < kInvaderRowCount; ++row) {

        InvaderType invaderType;
        if (row % 3 == 0)      invaderType = InvaderTypeA;
        else if (row % 3 == 1) invaderType = InvaderTypeB;
        else                   invaderType = InvaderTypeC;

        CGPoint invaderPosition = CGPointMake(baseOrigin.x, row * (kInvaderGridSpacing.height + kInvaderSize.height) + baseOrigin.y);
        
        //4
        for (NSUInteger col = 0; col < kInvaderColCount; ++col) {
            //5
            SKNode* invader = [self makeInvaderOfType:invaderType];
            invader.position = invaderPosition;
            [self addChild:invader]; 
            //6 
            invaderPosition.x += kInvaderSize.width + kInvaderGridSpacing.width; 
        } 
    } 
}

#pragma mark - setupHud Helpers
-(void)setupHud{
    SKLabelNode* scoreLable = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    scoreLable.name = kScoreName;
    scoreLable.fontSize =15;
    scoreLable.fontColor = [SKColor whiteColor];
    scoreLable.text = [NSString stringWithFormat:@"Score: %ld",self.score];
    scoreLable.position = CGPointMake(scoreLable.frame.size.width/2+20, self.size.height-(scoreLable.frame.size.height/2+35));
    [self addChild:scoreLable];
    
    SKLabelNode* healthLable = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    healthLable.name = kHealthHudName;
    healthLable.fontSize = 15;
    healthLable.fontColor = [SKColor greenColor];
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
#pragma mark - Ship Fire Helpers
-(void)fireShipBullets {
    SKNode* existingBullet = [self childNodeWithName:kShipFiredBulletName];
    if (!existingBullet) {
        SpaceShip* ship = (SpaceShip*)[self childNodeWithName:kShipName];
        SKNode* bullet = [ship makeBulletOfType:ShipFiredBulletType];
        bullet.position = CGPointMake(ship.position.x, ship.position.y + ship.frame.size.height - bullet.frame.size.height / 2);
        CGPoint bulletDestination = CGPointMake(ship.position.x, self.frame.size.height + bullet.frame.size.height / 2);
        [ship releaseBullet:bullet toDestination:bulletDestination withDuration:1.0 soundFileName:@"ShipBullet.wav"];
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
        //2
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
        //3
        // Ship bullet hit an invader
        [self runAction:[SKAction playSoundFileNamed:@"Hit.wav" waitForCompletion:NO]];
        [contact.bodyA.node removeFromParent]; 
        [contact.bodyB.node removeFromParent];
        [self updateScoreWith:100];
        
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
}

@end



