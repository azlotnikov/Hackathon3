#define OFFLINE_GAME YES

@import GameKit;

@protocol GameKitHelperDelegate
- (void)matchStarted;
- (void)matchEnded;
- (void)matchDismissed;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data
   fromPlayer:(NSString *)playerID;
@end

extern NSString *const PresentAuthenticationViewController;
extern NSString *const LocalPlayerIsAuthenticated;

@interface MRGameKitHelper : NSObject<GKMatchmakerViewControllerDelegate, GKMatchDelegate>

@property BOOL gameReady;
@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

@property (nonatomic, strong) GKMatch *match;
@property (nonatomic, assign) id <GameKitHelperDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *playersDict;

+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController
                       delegate:(id<GameKitHelperDelegate>)theDelegate;
@end
