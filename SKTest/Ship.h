//
//  Ship.h
//  SKTest
//
//  Created by Syuuhi on 13-11-13.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum BulletType {
    ShipFiredBulletType,
    InvaderFiredBulletType
} BulletType;

static const u_int32_t kInvaderCategory            = 0x1 << 0;
static const u_int32_t kShipFiredBulletCategory    = 0x1 << 1;
static const u_int32_t kShipCategory               = 0x1 << 2;
static const u_int32_t kSceneEdgeCategory          = 0x1 << 3;
static const u_int32_t kInvaderFiredBulletCategory = 0x1 << 4;
@interface Ship : SKSpriteNode

@end
