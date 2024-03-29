//
//  MRGameViewController.m
//  lastwar
//
//  Created by Зинов Михаил  on 24.04.15.
//  Copyright (c) 2015 MAYAK. All rights reserved.
//

#import "MRGameViewController.h"
#import "GameScene.h"
#import "MRMultiplayerNetworking.h"
#import "MRGameOverViewController.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];

    return scene;
}

@end

@implementation MRGameViewController {
    MRMultiplayerNetworking *_networkingEngine;
    MRMatchEndType endType;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

//    if (!OFFLINE_GAME) {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"offline"]) {
        if (![MRGameKitHelper sharedGameKitHelper].gameReady) {
            return;
        }
    }

    SKView *skView = (SKView*)self.view;

    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    // Create and configure the scene.
    GameScene* scene = [GameScene sceneWithSize:CGSizeMake(320, 568)];
    scene.scaleMode = SKSceneScaleModeResizeFill;

    scene.gameOverBlock = ^(MRMatchEndType mEndType) {
        [skView presentScene:nil];
        endType = mEndType;
        [self performSegueWithIdentifier:@"gameOverSegue" sender:self];
    };

    scene.goBack = ^() {
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
//    if (OFFLINE_GAME) {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"offline"]) {
        [skView presentScene:scene];
    } else {
        scene.gameStartBlock = ^() {
            [skView presentScene:scene];
        };
    }


//    if (OFFLINE_GAME) {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"offline"]) {
        return;
    }

    _networkingEngine = [[MRMultiplayerNetworking alloc] init];
    _networkingEngine.delegate = scene;
    scene.networkingEngine = _networkingEngine;
    [[MRGameKitHelper sharedGameKitHelper] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:_networkingEngine];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gameOverSegue"]) {
        [MRGameKitHelper sharedGameKitHelper].gameReady = NO;
        MRGameOverViewController *gameOverViewController = segue.destinationViewController;
        gameOverViewController.endType = endType;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
