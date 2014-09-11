//
//  StoryViewController.h
//  EnglishStoryPro
//
//  Created by Lê Đình Tuấn on 9/2/14.
//  Copyright (c) 2014 ChauApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import <AVFoundation/AVFoundation.h>
#import "GADInterstitial.h"


@interface StoryViewController : UIViewController<GADInterstitialDelegate> {
    GADInterstitial *interstitial_;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *navigation;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic, strong) NSTimer *updateTimer;

@property(strong) Story *storyView;

- (IBAction)playSound:(id)sender;
- (IBAction)pauseSound:(id)sender;
- (IBAction)changeSlider:(id)sender;

@end
