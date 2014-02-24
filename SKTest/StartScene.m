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
    self.backgroundColor = [SKColor whiteColor];
    if (!self.contentCreated) {
        [self creatContent];
    }
    
    for (SKLabelNode *lable in self.children) {
        if ([lable.name  isEqual: START]) {
            [self moveUp:lable withTaget:CGPointMake(self.size.width/2, self.size.height/2-20)];
        }else if([lable.name  isEqual: SCORE]){
            [self moveUp:lable withTaget:CGPointMake(self.size.width/2, self.size.height/2-60)];
        }else if([lable.name  isEqual: ABOUT]){
            [self moveUp:lable withTaget:CGPointMake(self.size.width/2, self.size.height/2-100)];
        }
    }
}

-(void)creatContent{
    SKSpriteNode* title = [SKSpriteNode spriteNodeWithImageNamed:@"title"];
    title.position = CGPointMake((self.frame.size.width)/2, 700);
    [self addChild:title];
    SKLabelNode *start = [[SKLabelNode alloc ]initWithFont:@"ArialHebrew" withSize:230 withColor:[SKColor blackColor] withPosition:CGPointMake(self.size.width/2, -20) withText:@"立即开始" withName:START];
    [self addChild:start];
    SKLabelNode *about = [[SKLabelNode alloc ]initWithFont:@"ArialHebrew" withSize:230 withColor:[SKColor blackColor] withPosition:CGPointMake(self.size.width/2, -20) withText:@"关于" withName:ABOUT];
    [self addChild:about];
    SKLabelNode *score = [[SKLabelNode alloc ]initWithFont:@"ArialHebrew" withSize:230 withColor:[SKColor blackColor] withPosition:CGPointMake(self.size.width/2, -20) withText:@"排行榜" withName:SCORE];
    [self addChild:score];
}

-(void)moveUp:(SKNode *)node withTaget:(CGPoint )taget{
    SKAction *up  = [SKAction moveToY:taget.y duration:1];
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
    }else if ([touchedNode.name isEqualToString:SCORE]){

        SKScene* score = [[SKScene alloc]init];
        [self.view presentScene:score];
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
