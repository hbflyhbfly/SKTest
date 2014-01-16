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
-(void)releaseBullet:(SKNode*)bullet toDestination:(CGPoint)destination withDuration:(double)duration withFrequency:(float)frequency {
    SKAction* bulletAction = [SKAction sequence:@[[SKAction playSoundFileNamed:@"ShipBullet.wav" waitForCompletion:YES],
                                                  [SKAction moveTo:destination duration:duration],
                                                  [SKAction waitForDuration:frequency],
                                                  [SKAction removeFromParent]]];

    if ([bullet.name isEqual:kShipFiredBulletName]) {
        bulletAction = [SKAction sequence:@[[SKAction waitForDuration:.5],
                                            [SKAction playSoundFileNamed:@"ShipBullet.wav" waitForCompletion:YES],
                                            [SKAction moveTo:destination duration:duration],
                                            [SKAction waitForDuration:frequency],
                                            [SKAction removeFromParent]]];
    }
    [bullet runAction:bulletAction];
    [self.parent addChild:bullet];
    
}

-(SKNode*)makeBulletOfType:(BulletType)bulletType {
    SKNode *bullet;
    switch (bulletType) {
        case ShipFiredBulletType:
            bullet = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:kBulletSize];
            bullet.name = kShipFiredBulletName;
            bullet.physicsBody.categoryBitMask = kShipFiredBulletCategory;
            bullet.physicsBody.contactTestBitMask = kInvaderCategory;
            bullet.physicsBody.collisionBitMask = kInvaderCategory;

            break;
        case InvaderFiredBulletType:
            bullet = [SKSpriteNode spriteNodeWithColor:[SKColor purpleColor] size:kBulletSize];
            bullet.name = kInvaderFiredBulletName;
            bullet.physicsBody.categoryBitMask = kInvaderFiredBulletCategory;
            bullet.physicsBody.contactTestBitMask = kShipCategory;
            bullet.physicsBody.collisionBitMask = kShipCategory;

            break;
            default:
            break;
    }
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.frame.size];
    bullet.physicsBody.dynamic = YES;
    bullet.physicsBody.affectedByGravity = NO;
    bullet.physicsBody.collisionBitMask = 0x0;
    bullet.physicsBody.usesPreciseCollisionDetection = YES;
    return bullet;
}
@end
