//
//  SKLabelNode+CustomizeLable.h
//  SKTest
//
//  Created by Syuuhi on 14-1-19.
//  Copyright (c) 2014年 周飞. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@interface SKLabelNode (CustomizeLable)
-(instancetype)initWithFont:(NSString*)font withSize:(float)size withColor:(SKColor*)color withPosition:(CGPoint)position withText:(NSString*)text withName:(NSString*)name;

@end
