//
//  SpaceShip.h
//  SKTest
//
//  Created by Syuuhi on 13-10-14.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Ship.h"
#define kShipFiredBulletName @"shipFiredBullet"
#define kInvaderFiredBulletName @"invaderFiredBullet"
#define kBulletSize CGSizeMake(4, 8)





@interface SpaceShip : Ship
@property (nonatomic,assign) CGFloat angle;
@property (nonatomic,assign) BOOL touched;
-(id)initWith:(CGPoint ) location;
-(void)releaseBullet:(SKNode*)bullet toDestination:(CGPoint)destination withDuration:(NSTimeInterval)duration soundFileName:(NSString*)soundFileName;
-(SKNode*)makeBulletOfType:(BulletType)bulletType;
@end
