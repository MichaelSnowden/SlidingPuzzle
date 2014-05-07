//
//  MyScene.h
//  MySpriteKitGame
//

//  Copyright (c) 2014 Michael Snowden. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define MINIMUM_DIFFICULTY 3
#define MAXIMUM_DIFFICULTY 7

@interface MyScene : SKScene

@property (nonatomic, strong) UIImage *image;

-(void)createPuzzleWithWidth: (int) width image: (UIImage *) image;

@end
