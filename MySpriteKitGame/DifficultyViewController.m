//
//  DifficultyViewController.m
//  MySpriteKitGame
//
//  Created by Michael Snowden on 4/19/14.
//  Copyright (c) 2014 Michael Snowden. All rights reserved.
//

#import "DifficultyViewController.h"
#import "MyScene.h"

@interface DifficultyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *customLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation DifficultyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES ];

    [_stepper setMinimumValue:MINIMUM_DIFFICULTY];
    [_stepper setMaximumValue:MAXIMUM_DIFFICULTY];
    [_stepper setValue:6];
    _customLabel.text = [NSString stringWithFormat:@"%i", (int)_stepper.value];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES ];
}

- (IBAction)easyButtonPressed:(id)sender {
    [self.delegate receiveDifficulty:3];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)mediumButtonPressed:(id)sender {
    [self.delegate receiveDifficulty:4];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hardButtonPressed:(id)sender {
    [self.delegate receiveDifficulty:5];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)customButtonPressed:(id)sender {
    [self.delegate receiveDifficulty:_stepper.value];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)stepperButtonPressed:(id)sender {
    int value = [(UIStepper *)sender value];
    _customLabel.text = [NSString stringWithFormat:@"%i", value];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Status Bar
- (BOOL)prefersStatusBarHidden {
    [[UIApplication sharedApplication] setStatusBarHidden:YES ];
    return TRUE;
}

@end
