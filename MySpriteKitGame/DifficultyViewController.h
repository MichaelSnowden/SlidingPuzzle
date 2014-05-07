//
//  DifficultyViewController.h
//  MySpriteKitGame
//
//  Created by Michael Snowden on 4/19/14.
//  Copyright (c) 2014 Michael Snowden. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DifficultyViewControllerDelegate <NSObject>

- (void)receiveDifficulty: (int) difficulty;

@end

@interface DifficultyViewController : UIViewController

@property (nonatomic, weak) id<DifficultyViewControllerDelegate> delegate;

@end
