//
//  Invader.m
//  SKTest
//
//  Created by Syuuhi on 13-12-28.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import "Invader.h"

@implementation Invader

-(id)initWithLocation:(CGPoint)location withType:(InvaderType)type{

    self = [super initWithColor:[UIColor clearColor] size:kInvaderSize];
    if (self) {
        UIColor* invaderColor;
        switch (type) {
            case InvaderTypeA:
                invaderColor = [UIColor redColor];
                break;
            case InvaderTypeB:
                invaderColor = [UIColor greenColor];
                break;
            case InvaderTypeC:
                default:
                invaderColor = [UIColor blueColor];
                break;
        }
        self.position = location;
        self.name = kInvaderName;
        self.color = invaderColor;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = kInvaderCategory;
        self.physicsBody.contactTestBitMask = 0x0;
        self.physicsBody.collisionBitMask = 0x0;
        
        
    }
    return  self;
}
@end
