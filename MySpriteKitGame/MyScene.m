//
//  MyScene.m
//  MySpriteKitGame
//
//  Created by Michael Snowden on 4/18/14.
//  Copyright (c) 2014 Michael Snowden. All rights reserved.
//

#import "MyScene.h"
#import "SPTile.h"
#import <AVFoundation/AVFoundation.h>

#define LABEL_DEBUG false


@interface MyScene ()

@property (nonatomic, strong) NSMutableArray *tiles;
@property (assign) int tileCount;
@property (assign) CGSize tileSize;
@property (assign) float puzzleWidth;
@property (assign) CGPoint puzzleOrigin;
@property (nonatomic, strong) SPTile *emptyTile;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {
        /* Setup your scene here */

        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];

        // Replace @"Spaceship" with your background image:
        SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"wallpaper.jpg"];
        sn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        sn.name = @"BACKGROUND";
        
        [self addChild:sn];
    }
    return self;
}

-(void)createPuzzleWithWidth: (int) width image: (UIImage *) image
{
    if (width < 3)
    {
        return;
    }
    [self resetBoard];
    self.image = image;

    _puzzleWidth = self.size.width * .9f;
    _tileSize = CGSizeMake(_puzzleWidth / width , _puzzleWidth / width);
    _puzzleOrigin = CGPointMake(self.size.width * .05, self.size.height * .7f - _tileSize.width);

    self.tileCount = width;
    float spritePixelSize = CGImageGetWidth(image.CGImage) / width;
    self.tiles = [[NSMutableArray alloc] initWithCapacity:width];

    for (int i = 0; i < width; ++i)
    {
        NSMutableArray *col = [[NSMutableArray alloc] initWithCapacity:width];

        for (int j = 0; j < width; ++j)
        {
            CGImageRef topImgRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(spritePixelSize * i,
                                                                                  spritePixelSize * j,
                                                                                  spritePixelSize,
                                                                                  spritePixelSize));
            SKTexture *texture = [SKTexture textureWithCGImage:topImgRef];

            SPTile *tile = [SPTile spriteNodeWithTexture:texture size:_tileSize];
            tile.anchorPoint = CGPointMake(0.0f, 0.0f);
            tile.puzzleWidth = _tileCount;
            tile.position = CGPointMake(_puzzleOrigin.x + _tileSize.width * i,
                                        _puzzleOrigin.y - _tileSize.width * j);
            tile.name = @"Tile";
            tile.col = i;
            tile.row = j;
            tile.icol = i;
            tile.irow = j;

#if LABEL_DEBUG
            SKLabelNode *originalLabel = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-CondensedBold"];
            originalLabel.fontSize = 25.0f;
            originalLabel.fontColor = [UIColor colorWithRed:0.75f green:0.0f blue:0.0f alpha:1.0f];
            originalLabel.text = [NSString stringWithFormat:@"{%i}", [tile originalValue]];
            originalLabel.position = CGPointMake(tile.frame.size.width / 2.0f, 0.0f);
            originalLabel.name = @"OriginalLabel";
            [tile addChild:originalLabel];

            SKLabelNode *currentLabel = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-CondensedBold"];
            currentLabel.fontSize = 25.0f;
            currentLabel.fontColor = [UIColor colorWithRed:0.0f green:0.75f blue:0.0f alpha:1.0f];
            currentLabel.text = [NSString stringWithFormat:@"{%i}", [tile currentValue]];
            currentLabel.position = CGPointMake(tile.frame.size.width / 2.0f, tile.frame.size.height / 5.0f);
            currentLabel.name = @"CurrentLabel";
            [tile addChild:currentLabel];

            SKLabelNode *inversionLabel = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-CondensedBold"];
            inversionLabel.fontSize = 25.0f;
            inversionLabel.fontColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.75f alpha:1.0f];
            inversionLabel.text = [NSString stringWithFormat:@"%i", 0];
            inversionLabel.position = CGPointMake(tile.frame.size.width / 2.0f, tile.frame.size.height / 2.0f);
            inversionLabel.name = @"InversionLabel";
            [tile addChild:inversionLabel];

#endif

            [self addChild:tile];

            if (i == _tileCount - 1 && j == _tileCount - 1)
            {
                _emptyTile = tile;
                [_emptyTile setHidden:YES];
                [_emptyTile setColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f]];
            }
            [col addObject:tile];
        }
        [self.tiles addObject:col];
    }

    for (int i = 0; i <= width; ++i)
    {
        // add lines
        SKShapeNode *horizontalLine = [SKShapeNode node];
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        float lineY = _puzzleOrigin.y - _tileSize.width * (i - 1);
        CGPathMoveToPoint(pathToDraw, NULL, _puzzleOrigin.x, lineY);
        CGPathAddLineToPoint(pathToDraw, NULL, _puzzleOrigin.x + _puzzleWidth, lineY);
        horizontalLine.path = pathToDraw;
        horizontalLine.name = @"Line";
        [horizontalLine setStrokeColor:[UIColor blackColor]];
        [self addChild:horizontalLine];

        SKShapeNode *verticalLine = [SKShapeNode node];
        float lineX = _puzzleOrigin.x + _tileSize.width * i;
        CGPathMoveToPoint(pathToDraw, NULL, lineX, _puzzleOrigin.y + _tileSize.width);
        CGPathAddLineToPoint(pathToDraw, NULL, lineX, _puzzleOrigin.y - _puzzleWidth + _tileSize.width);
        verticalLine.path = pathToDraw;
        verticalLine.name = @"Line";
        [verticalLine setStrokeColor:[UIColor blackColor]];
        [self addChild:verticalLine];
    }

    [self randomizeTiles];
}

- (void)resetBoard
{
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"Victory" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"Line" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
        SPTile *tile = (SPTile *)node;
        if (tile != _emptyTile)
        {
            CGPoint point = [touch locationInNode:self];
            CGRect rect = tile.frame;
            if (CGRectContainsPoint(rect, point))
            {
                if ([self tileIsAdjacent:_emptyTile to:tile])
                {
                    [self moveNode:tile toEmpty:_emptyTile];
                }
            }
        }
    }];

}

#pragma mark - Randomizing the board. Most of these methods don't work after the first randomization.

- (void) randomizeTiles {
    [self initTiles];
    if (![self isSolvableWithWidth:_tileCount height:_tileCount emptyRow:_emptyTile.row + 1])
    {
        if (_emptyTile.row == 0 && _emptyTile.col <= 1)
        {
            [self swap:_tileCount - 2 :_tileCount - 1 :_tileCount - 1 :_tileCount - 1 withPosition:YES];
        }
        else
        {
            [self swap: 0 : 0 : 1 : 0 withPosition:YES];
        }
    }
}

- (void) initTiles {
    int i = _tileCount * _tileCount - 1;
    while (i > 0) {
        int j = floor(drand48() * i);
        int xi = i % _tileCount;
        int yi = i / _tileCount;
        int xj = j % _tileCount;
        int yj = j / _tileCount;
        [self swap: xi : yi : xj : yj withPosition:YES];
        --i;
    }
}

- (int) countInversions: (int) i : (int) j {
    int inversions = 0;
    int tileNum = j * _tileCount + i;
    int lastTile = _tileCount * _tileCount;
    SPTile *tile1 = _tiles[i][j];
    int tileValue = tile1.irow * _tileCount + tile1.icol;
    for (int q = tileNum + 1; q < lastTile; ++q) {
        int k = q % _tileCount;
        int l = q / _tileCount;

        SPTile *tile2 = _tiles[k][l];
        int compValue = tile2.irow * _tileCount + tile2.icol;
        if (tileValue > compValue && tileValue != (lastTile - 1) && tile1 != _emptyTile && tile2 != _emptyTile) {
            ++inversions;
        }
    }
    return inversions;
}

- (int) sumInversions {
    int inversions = 0;
    for (int j = 0; j < _tileCount; ++j) {
        for (int i = 0; i < _tileCount; ++i) {
            inversions += [self countInversions: i : j];
        }
    }
    NSLog(@"Sum Inversions: %i", inversions);
    return inversions;
}

- (bool) isSolvableWithWidth: (int) width height: (int) height emptyRow: (int) emptyRow
{
    if (width % 2 == 1)
    {
        return [self sumInversions] % 2 == 0;
    }
    else
    {
        return ([self sumInversions] + height - emptyRow) % 2 == 0;
    }
}

#pragma mark - Ending the game

- (bool) isSolved
{
    __block BOOL flag = true;
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
        SPTile *tile = (SPTile *)node;
        if (![tile isInCorrectPosition])
        {
            flag = false;
            *stop = YES;
        }
    }];
    return flag;
}

- (void) checkIfSolved
{
    if ([self isSolved])
    {
        // display victory somehow
        [self showVictory];
    }
}

- (void) showVictory
{
    [_emptyTile setHidden:NO];
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];

    myLabel.text = @"Victory";
    myLabel.name = @"Victory";
    myLabel.fontSize = 30;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    [self addChild:myLabel];
}

#pragma mark - Tile interaction

- (bool)tilesAreAdjacent: (int) i : (int) j : (int) k : (int) l
{

    int distance = abs(k - i) + abs(l - j);
    if (distance == 1)
        return true;
    else
        return false;
}

- (bool)tileIsAdjacent: (SPTile *)node1 to: (SPTile *)node2
{
    float distance = abs(node1.position.x - node2.position.x) + abs(node1.position.y - node2.position.y);
    if (distance > node1.frame.size.width)
        return false;
    else
        return true;
}

- (void)moveNode: (SPTile *) node1 toEmpty: (SPTile *)empty
{
    CGPoint position1 = node1.position;
    SKAction *animate = [SKAction moveTo: empty.position duration:0.10f];
    [node1 runAction:animate];
    [node1 setZPosition:1.0f];


    double delayInSeconds = .10;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        empty.position = position1;
        [self swapIndexOfTile:node1 withTile:empty];
        [self sumInversions];
        [self checkIfSolved];
        [node1 setZPosition:0];
    });
}

- (void)swap: (int) i : (int) j : (int) k : (int) l withPosition: (bool) withPosition
{
    SPTile *node1 = self.tiles[i][j];
    SPTile *node2 = self.tiles[k][l];

    node1.col = k;
    node1.row = l;
    node2.col = i;
    node2.row = j;

    if (withPosition)
    {
        [self swapPositionOfNode:node1 withNode:node2];
    }
    self.tiles[k][l] = node1;
    self.tiles[i][j] = node2;
}

- (void)swapIndexOfTile: (SPTile *)node1 withTile: (SPTile *)node2
{
    [self swap:node1.col :node1.row :node2.col :node2.row withPosition:NO];
}

- (void)swapPositionOfNode: (SPTile *)node1 withNode: (SPTile *)node2
{
    CGPoint position1 = node1.position;
    node1.position = node2.position;
    node2.position = position1;
}

- (void)update:(CFTimeInterval)currentTime {
#if LABEL_DEBUG
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
        SPTile *tile = (SPTile *) node;
        SKLabelNode *currentLabel = (SKLabelNode *)[node childNodeWithName:@"CurrentLabel"];
        currentLabel.text = [NSString stringWithFormat:@"{%i}", [tile currentValue]];
        SKLabelNode *inversionLabel = (SKLabelNode *)[node childNodeWithName:@"InversionLabel"];
        inversionLabel.text = [NSString stringWithFormat:@"%i", [self countInversions:tile.col :tile.row]];
    }];
#endif
}

@end