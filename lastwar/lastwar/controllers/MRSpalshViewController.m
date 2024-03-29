//
//  MRSpalshViewController.m
//  lastwar
//
//  Created by Зинов Михаил  on 24.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRSpalshViewController.h"
#import "MRMenuViewController.h"

@interface MRSpalshViewController ()
@property(nonatomic) AVAudioPlayer *audio;
@end

@implementation MRSpalshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(showMainMenuController) withObject:nil afterDelay:2.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMainMenuController
{
    [self performSegueWithIdentifier:@"mainMenuSegue" sender:self];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"door" ofType:@"wav"];
    self.audio = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    [self.audio play];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



@end
