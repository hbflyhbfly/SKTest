//
//  StartScene.h
//  SKTest
//
//  Created by Syuuhi on 13-11-13.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
#import "SKLabelNode+CustomizeLable.h"
#define START @"start"
#define ABOUT @"about"
#define SCORE @"score"
@interface StartScene : SKScene
@property BOOL contentCreated;
@property UIWebView* webView;
@end
