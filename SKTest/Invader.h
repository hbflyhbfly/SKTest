//
//  Invader.h
//  SKTest
//
//  Created by Syuuhi on 13-12-28.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import "Ship.h"
#define kInvaderName @"invader"
#define kInvaderSize CGSizeMake(24, 16)

typedef enum InvaderType {
    InvaderTypeA,
    InvaderTypeB,
    InvaderTypeC
} InvaderType;
@interface Invader : Ship
-(id)initWithLocation:(CGPoint)location withType:(InvaderType)type;
@end
