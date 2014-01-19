//
//  SpaceShip.h
//  SKTest
//
//  Created by Syuuhi on 13-10-14.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Ship.h"
#define kShipSize CGSizeMake(70, 70)

#define kShipName @"spaceShip"
@interface SpaceShip : Ship
@property (nonatomic,assign) CGFloat angle;
@property (nonatomic,assign) BOOL touched;
@property SKEmitterNode *smokeTrail;
-(id)initWith:(CGPoint ) location;
@end
