//
//  AppDelegate.m
//  YWReader
//
//  Created by guohaoyang on 2020/12/3.
//

#import "AppDelegate.h"
#import "YWMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    YWMainViewController *controller = [[YWMainViewController alloc] init];
    window.rootViewController = controller;
    [window makeKeyAndVisible];
    
    return YES;
}

@end
