//
//  ViewController.m
//  MySpriteKitGame
//
//  Created by Michael Snowden on 4/18/14.
//  Copyright (c) 2014 Michael Snowden. All rights reserved.
//

//HELLO GITHUB
#import "ViewController.h"
#import "DifficultyViewController.h"
#import "MyScene.h"
#import "InfoViewController.h"

@interface ViewController ()

@property (nonatomic, strong) MyScene *scene;
@property (nonatomic, strong) SKTexture *spriteTexture;
@property (assign) CGSize spriteSize;
@property (weak, nonatomic) IBOutlet UIButton *difficultyButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES ];

    // Configure the view.
    SKView * skView = (SKView *)self.view;

    
    // Create and configure the scene.
    CGSize size = skView.bounds.size;
    self.scene = [MyScene sceneWithSize:size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.difficultyButton setHidden:YES];  // reveal when puzzle is initialized

    [self initModel];

    // Present the scene.
    [skView presentScene:self.scene];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)initModel
{
    self.spriteSize = CGSizeMake(100.0f, 100.0f);
    self.spriteTexture = [SKTexture textureWithImageNamed:@"Spaceship.png"];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Settings stuff



#pragma mark - Camera roll stuff

- (void)takePhoto {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:NULL];

}

- (void)selectPhoto {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    if (originalImage.size.width < 640)
    {
        NSLog(@"Image too narrow!");
        [picker dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    CGSize chosenSize = chosenImage.size;
    if (chosenSize.width != chosenSize.height)
    {
        NSLog(@"Non-square edited image!");
        [picker dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    [self.scene createPuzzleWithWidth:3 image:chosenImage];
    [self.difficultyButton setHidden:NO];

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - User Interaction

- (IBAction)newImageButtonPressed:(id)sender {
    [self selectPhoto];
}

- (IBAction)difficultyButtonPressed:(id)sender {
    DifficultyViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DifficultyViewController"];
    dvc.delegate = self;
    [self presentViewController:dvc animated:YES completion:nil];
}

- (IBAction)infoButtonPressed:(id)sender {
    InfoViewController *ifc = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
    [self presentViewController:ifc animated:YES completion:nil];
}

#pragma mark - DifficultyViewControllerDelegate methods
- (void)receiveDifficulty: (int) difficulty
{
    [self.scene createPuzzleWithWidth:difficulty image:self.scene.image];
}

#pragma mark - Status Bar
- (BOOL)prefersStatusBarHidden {
    [[UIApplication sharedApplication] setStatusBarHidden:YES ];
    return TRUE;
}

@end
