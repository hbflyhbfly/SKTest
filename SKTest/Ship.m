//
//  Ship.m
//  SKTest
//
//  Created by Syuuhi on 13-11-13.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import "Ship.h"

@implementation Ship
#pragma mark – Bullet Helpers
-(void)releaseBullet:(SKSpriteNode*)bullet toDestination:(CGPoint)destination withDuration:(double)duration withFrequency:(float)frequency {
    SKAction* bulletAction = [SKAction sequence:@[[SKAction playSoundFileNamed:@"ShipBullet.wav" waitForCompletion:NO],
                                                  [SKAction moveTo:destination duration:duration],
                                                  [SKAction removeFromParent]]];


    [bullet runAction:bulletAction];
    [self.parent addChild:bullet];
    
}

-(SKSpriteNode*)makeBulletOfType:(BulletType)bulletType {
    SKSpriteNode *bullet;
    switch (bulletType) {
        case ShipFiredBulletType:
            bullet = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:kBulletSize];
            bullet.name = kShipFiredBulletName;
            bullet.physicsBody.categoryBitMask = kShipFiredBulletCategory;
            bullet.physicsBody.contactTestBitMask = kInvaderCategory;
            

            break;
        case InvaderFiredBulletType:
            bullet = [SKSpriteNode spriteNodeWithColor:[SKColor purpleColor] size:kBulletSize];
            bullet.name = kInvaderFiredBulletName;
            bullet.physicsBody.categoryBitMask = kInvaderFiredBulletCategory;
            bullet.physicsBody.contactTestBitMask = kShipCategory;

            break;
            default:
            break;
    }
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    bullet.physicsBody.dynamic = YES;
    bullet.physicsBody.affectedByGravity = NO;
    bullet.physicsBody.usesPreciseCollisionDetection = YES;
    bullet.physicsBody.collisionBitMask = 0x0;
    return bullet;
}
@end
