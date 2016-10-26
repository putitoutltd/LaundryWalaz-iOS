//
//  AppDelegate.m
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "AppDelegate.h"
#import "PIOAppController.h"
@import Firebase;

@interface AppDelegate ()
{
    Reachability *internetReach;
    Reachability *internetReachable;
    Reachability *hostReachable;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    sleep(5);
    [self internetConnectionChecking];
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self setWindowRootViewController];
    [FIRApp configure];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    [self performSelector: @selector(configureNavigationBar) withObject: nil afterDelay: 0.1];
}

- (void)configureNavigationBar
{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"configureNavigationBar" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setWindowRootViewController
{
    UINavigationController *navigationController = [[PIOAppController sharedInstance] navigationController];
    navigationController.navigationBarHidden = NO;
    [self.window setRootViewController:navigationController];
}

- (void)internetConnectionChecking
{
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            [PIOAppController sharedInstance].internetActive = NO;
            [[PIOAppController sharedInstance] showInternetNotAvailableAletr];
            break;
        }
        case ReachableViaWiFi:
        {
            [PIOAppController sharedInstance].internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            [PIOAppController sharedInstance].internetActive = YES;
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            [PIOAppController sharedInstance].internetActive = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            [PIOAppController sharedInstance].internetActive = YES;
            break;
        }
        case ReachableViaWWAN:
        {
            [PIOAppController sharedInstance].internetActive = YES;
            break;
        }
    }
}


@end
