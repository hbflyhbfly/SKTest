//
//  GameOverScene.m
//  SKTest
//
//  Created by Syuuhi on 13-11-13.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene

-(void)didMoveToView:(SKView *)view{
    NSString *localHTMLPageName = @"GameOver";

    NSString *localHTMLPageFilePath = [[NSBundle mainBundle] pathForResource:localHTMLPageName ofType:@"html"];

    NSURL *localHTMLPageFileURL = [NSURL fileURLWithPath:localHTMLPageFilePath];
  
    [_webView loadRequest:[NSURLRequest requestWithURL:localHTMLPageFileURL]];
}
@end
