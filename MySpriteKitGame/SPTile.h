//
//  MyTile.h
//  MySpriteKitGame
//
//  Created by Michael Snowden on 4/19/14.
//  Copyright (c) 2014 Michael Snowden. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SPTile : SKSpriteNode

@property (assign) int irow;
@property (assign) int icol;
@property (assign) int row;
@property (assign) int col;
@property (assign) int puzzleWidth;

- (int)originalValue;
- (int)currentValue;
- (bool)isInCorrectPosition;

@end
