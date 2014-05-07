//
//  MyTile.m
//  MySpriteKitGame
//
//  Created by Michael Snowden on 4/19/14.
//  Copyright (c) 2014 Michael Snowden. All rights reserved.
//

#import "SPTile.h"

@implementation SPTile

- (int)originalValue
{
    return _irow * _puzzleWidth + _icol;
}

- (int)currentValue
{
    return _row * _puzzleWidth + _col;
}

- (bool)isInCorrectPosition
{
    if ([self originalValue] == [self currentValue])
        return true;
    else
        return false;
}

@end
