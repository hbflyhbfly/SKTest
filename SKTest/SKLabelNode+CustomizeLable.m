//
//  SKLabelNode+CustomizeLable.m
//  SKTest
//
//  Created by Syuuhi on 14-1-19.
//  Copyright (c) 2014年 周飞. All rights reserved.
//

#import "SKLabelNode+CustomizeLable.h"

@implementation SKLabelNode (CustomizeLable)

-(instancetype)initWithFont:(NSString*)font withSize:(float)size withColor:(SKColor*)color withPosition:(CGPoint)position withText:(NSString*)text withName:(NSString*)name{
    self =[self initWithFontNamed:font];
    if (self) {
        self.name = name;
        self.text = text;
        self.scale = 0.1;
        self.position = position;
        self.fontColor = color;
        self.fontSize = size;
    }
    return self;
}

@end
