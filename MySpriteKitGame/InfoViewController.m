//
//  InfoViewController.m
//  MySpriteKitGame
//
//  Created by Michael Snowden on 4/23/14.
//  Copyright (c) 2014 Michael Snowden. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@property (nonatomic, strong) SKScene *scene;
@property (assign) int numLabels;

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarHidden:YES ];

    // Configure the view.
    SKView * skView = (SKView *)self.view;

    // Create and configure the scene.
    CGSize size = skView.bounds.size;
    self.scene = [SKScene sceneWithSize:size];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    [_scene setBackgroundColor:[UIColor blackColor]];

    self.numLabels = 0;
    [self addLabelWithText:@"Select \"new image\" from the previous view to"];
    [self addLabelWithText:@"initialize a 3 x 3 slider puzzle with that"];
    [self addLabelWithText:@"image."];
    ++_numLabels;
    [self addLabelWithText:@"Tap the tiles to recreate the image."];
    ++_numLabels;
    [self addLabelWithText:@"You can play on difficulties ranging from 3 - 7."];
    ++_numLabels;
    [self addLabelWithText:@"Panoramic and narrow photos will not work."];
    ++_numLabels;
    [self addLabelWithText:@"The puzzle is created randomly with an"];
    [self addLabelWithText:@"algorithm known as the \"Fischer-Yates\""];
    [self addLabelWithText:@"algorithm. It is always solvable, and it"];
    [self addLabelWithText:@"produces the best random distribution."];
    ++_numLabels;
    [self addLabelWithText:@"Created by deltasheep."];
    SKSpriteNode *logoNode = [SKSpriteNode spriteNodeWithImageNamed:@"deltasheep.png"];
    logoNode.name = @"Logo";
    [logoNode setSize:CGSizeMake(200.0f, 123.6f)];
    [logoNode setAnchorPoint:CGPointMake(0.5f, 1.0f)];
    [_scene addChild:logoNode];
    [logoNode setPosition:CGPointMake(CGRectGetMidX(_scene.frame), CGRectGetMidY(_scene.frame) * 5 / 3 - _numLabels * 16.0f)];

    // Present the scene.
    [skView presentScene:_scene];
}

- (void)addLabelWithText:(NSString *)text
{
    SKLabelNode *label = [[SKLabelNode alloc] initWithFontNamed:@"AmericanTypewriter-Condensed"];
    label.fontColor = [UIColor whiteColor];
    label.fontSize = 16.0f;
    label.text = text;
    label.name = @"Label";
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [_scene addChild:label];
    [label setPosition:CGPointMake(20.0f, CGRectGetMidY(_scene.frame) * 5 / 3 - _numLabels * 16.0f)];
    ++_numLabels;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Status Bar
- (BOOL)prefersStatusBarHidden {
    [[UIApplication sharedApplication] setStatusBarHidden:YES ];
    return TRUE;
}

@end
