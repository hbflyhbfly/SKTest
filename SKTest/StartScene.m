//
//  StartScene.m
//  SKTest
//
//  Created by Syuuhi on 13-11-13.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import "StartScene.h"
#import "MyScene.h"
@implementation StartScene
-(void)didMoveToView:(SKView *)view{
    self.backgroundColor = [SKColor blackColor];
    if (!self.contentCreated) {
        [self creatContent];
    }
    
    for (SKLabelNode *lable in self.children) {
        if ([lable.name  isEqual: START]) {
            [self moveUp:lable withTaget:CGPointMake(self.size.width/2, self.size.height/2-20)];
        }else{
            [self moveUp:lable withTaget:CGPointMake(self.size.width/2, self.size.height/2-60)];
        }
    }
}

-(void)creatContent{
    SKLabelNode *start = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    
    [start setText:@"立即开始"];
    [start setFontSize:20];
    [start setName:START];
    [start setFontColor:[SKColor whiteColor]];
    [start setPosition:CGPointMake(self.size.width/2, -20)];
    [self addChild:start];
    SKLabelNode *about = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    [about setText:@"关于"];
    [about setFontSize:20];
    [about setName:ABOUT];
    [about setFontColor:[SKColor whiteColor]];
    [about setPosition:CGPointMake(self.size.width/2, -20)];
    [self addChild:about];
}

-(void)moveUp:(SKNode *)node withTaget:(CGPoint )taget{
    SKAction *up  = [SKAction moveToY:taget.y duration:0.5];
    up.timingMode = SKActionTimingEaseInEaseOut;
    [node runAction:up completion:^{
        [node removeAllActions];
    }];
}

-(void)menueBar:(NSString *)menueName{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject];
    SKNode *touchedNode = [self nodeAtPoint:[touch locationInNode:self]];
    if ([touchedNode.name isEqualToString:START]) {
        MyScene *gameMainScene = [[MyScene alloc]initWithSize:self.size];
        gameMainScene.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *door = [SKTransition flipHorizontalWithDuration:0.5];
        [self.view presentScene:gameMainScene transition:door];
    }else if ([touchedNode.name isEqualToString:ABOUT]){
        NSString *localHTMLPageName = @"GameOver";
        NSString *localHTMLPageFilePath = [[NSBundle mainBundle] pathForResource:localHTMLPageName ofType:@"html"];
        NSURL *localHTMLPageFileURL = [NSURL fileURLWithPath:localHTMLPageFilePath];
        [_webView setFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
        [self.view addSubview:_webView];
        [_webView loadRequest:[NSURLRequest requestWithURL:localHTMLPageFileURL]];
    }
}
@end
