//
//  MyScene.h
//  SKTest
//

//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "SpaceShip.h"
#pragma mark – Custom Type Definitions
typedef enum InvaderType {
    InvaderTypeA,
    InvaderTypeB,
    InvaderTypeC
} InvaderType;
typedef enum InvaderMovementDirection{
    InvaderMovementDirectionRight,
    InvaderMovementDirectionLeft,
    InvaderMovementDirectionDownThenRight,
    InvaderMovementDirectionDownThenLeft,
    InvaderMovementDirectionNone
}InvaderMovementDirection;

@interface MyScene : SKScene <SKPhysicsContactDelegate>
@property (nonatomic, strong) SpaceShip *mySpaceShip;
@property BOOL contentCreated;
@property InvaderMovementDirection invaderMovementDirection;
@property NSTimeInterval timeOfLastMove;
@property NSTimeInterval timePerMove;
@property (strong) NSMutableArray* tapQueue;
@property (strong) NSMutableArray* contactQueue;
@property NSInteger score;
@property CGFloat health;
@end
