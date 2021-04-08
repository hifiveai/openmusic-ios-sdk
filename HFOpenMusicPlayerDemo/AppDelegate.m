//
//  AppDelegate.m
//  HFOpenMusicPlayerDemo
//
//  Created by 郭亮 on 2021/4/6.
//

#import "AppDelegate.h"
#import "TestConfigViewController.h"
#import <HFOpenMusicPlayer/HFOpenApiManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //注册
    [[HFOpenApiManager shared] registerAppWithAppId:@"300a44d050c942eebeae8765a878b0ee" serverCode:@"0e31fe11b31247fca8" clientId:@"hf7no8v6o7t2ve3r90" version:@"V4.0.1" success:^(id  _Nullable response) {
        NSLog(@"注册成功");
    } fail:^(NSError * _Nullable error) {
        NSLog(@"注册失败");
    }];
    
    if (@available(iOS 13.0,*)) {
        
    } else {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[TestConfigViewController new]];
        [self.window makeKeyAndVisible];
    }
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
