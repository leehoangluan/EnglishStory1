//
//  StoryViewController.m
//  EnglishStoryPro
//
//  Created by Lê Đình Tuấn on 9/2/14.
//  Copyright (c) 2014 ChauApple. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController ()
{
    AVAudioPlayer *_audioPlayer;
}
@end

@implementation StoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//When view control load
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create object story from table view control
    Story *story = self.storyView;
    
    //Set information for view control
    [self.navigation setTitle:[@"Story " stringByAppendingString:[NSString stringWithFormat:@"%d", story.id]]];
    [self.textView setText:story.content];
    [self.textView setFont:[UIFont fontWithName:@"Helvetica Neue" size:20.0f]];
    self.textView.textColor = [UIColor blackColor];
    self.textView.textAlignment = NSTextAlignmentJustified;
    
    // Construct URL to sound file
    NSString *filePath = [@"%@/" stringByAppendingString:[[NSString stringWithFormat:@"%d", story.id] stringByAppendingString:@".mp3"]];
    NSString *path = [NSString stringWithFormat:filePath, [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    //set time start end for slider bar
    self.slider.minimumValue = 0;
    self.slider.maximumValue = _audioPlayer.duration;
}

//When view control close
-(void)viewWillDisappear:(BOOL)animated
{
    [_audioPlayer stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//When submit play button
- (IBAction)playSound:(id)sender {
    [_audioPlayer play];
    self.updateTimer =  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSliderBar) userInfo:nil repeats:YES];
}

//When submit pause button
- (IBAction)pauseSound:(id)sender {
    [_audioPlayer pause];
}

//When drag slider control
- (IBAction)changeSlider:(id)sender {
    [_audioPlayer stop];
    _audioPlayer.currentTime = self.slider.value;
    [_audioPlayer prepareToPlay];
    [self playSound:self];
}

//Update infor slider bar
- (void)updateSliderBar{
    float progress = _audioPlayer.currentTime;
    [self.slider setValue:progress];
}

//Calculator time audio
- (IBAction)seekTime:(id)sender {
    _audioPlayer.currentTime = self.slider.value;
}

@end
