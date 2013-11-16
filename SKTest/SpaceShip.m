//
//  SpaceShip.m
//  SKTest
//
//  Created by Syuuhi on 13-10-14.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import "SpaceShip.h"

@implementation SpaceShip
-(id)initWith:(CGPoint)location{
    self = [super initWithImageNamed:@"Spaceship"];
    if (self) {
        [self setPosition:location];
        [self setTouched:NO];
        [self setAngle:M_PI/2];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.mass = 2.0;
        SKShapeNode *light1 = [self newLight];
        light1.position = CGPointMake(-40.0, -20.0);
        [self addChild:light1];
        SKShapeNode *light2 = [self newLight];
        light2.position = CGPointMake(40.0, -20.0);
        [self addChild:light2];
        SKAction *shake = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-1.0f) duration:0.1],
                                               [SKAction rotateByAngle:0.0 duration:0.1],
                                               [SKAction rotateByAngle:degToRad(1.0f) duration:0.1]]];
        SKAction *shakeForever = [SKAction repeatActionForever:shake];
        [self runAction:shakeForever];
    }
    return self;
}

#pragma mark – Bullet Helpers
-(void)releaseBullet:(SKNode*)bullet toDestination:(CGPoint)destination withDuration:(NSTimeInterval)duration soundFileName:(NSString*)soundFileName{
    SKAction* bulletAction = [SKAction sequence:@[[SKAction moveTo:destination duration:duration],
                                                  [SKAction waitForDuration:3.0/60.0],
                                                  [SKAction removeFromParent]]];
    SKAction* soundAction  = [SKAction playSoundFileNamed:soundFileName waitForCompletion:YES];
    [bullet runAction:[SKAction group:@[bulletAction, soundAction]]];
    [self.parent addChild:bullet];
    
}

-(SKNode*)makeBulletOfType:(BulletType)bulletType {
    SKNode *bullet;
    switch (bulletType) {
        case ShipFiredBulletType:
            bullet = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:kBulletSize];
            bullet.name = kShipFiredBulletName;
            bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.frame.size];
            bullet.physicsBody.dynamic = YES;
            bullet.physicsBody.affectedByGravity = NO;
            bullet.physicsBody.categoryBitMask = kShipFiredBulletCategory;
            bullet.physicsBody.contactTestBitMask = kInvaderCategory;
            bullet.physicsBody.collisionBitMask = 0x0;
            break;
        case InvaderFiredBulletType:
            bullet = [SKSpriteNode spriteNodeWithColor:[SKColor purpleColor] size:kBulletSize];
            bullet.name = kInvaderFiredBulletName;
            break;
        default:
            break;
    }
    return bullet;
}

-(SKShapeNode*)newLight{
    SKShapeNode *ball = [[SKShapeNode alloc] init];
    
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 0.0, 3.0, M_PI*2,0,M_PI*2, YES);
    ball.path = myPath;
    
    ball.lineWidth = 0.2;
    ball.fillColor = [SKColor blueColor];
    ball.strokeColor = [SKColor whiteColor];
    ball.glowWidth = 0.3;
    
    //SKSpriteNode *light = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(8, 8)];
    SKAction *blink = [SKAction sequence:@[[SKAction fadeInWithDuration:0.25],[SKAction fadeOutWithDuration:0.80]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [ball runAction:blinkForever];
    return ball;
}

float degToRad(float degree) {
    return degree / 180.0f * M_PI;
}
@end
