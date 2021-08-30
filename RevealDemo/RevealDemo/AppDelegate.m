//
//  AppDelegate.m
//  RevealDemo
//
//  Created by zwzh_14 on 2021/8/30.
//

#import "AppDelegate.h"
#include <dlfcn.h>


@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self loadReveal];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)loadReveal

{
    
    if (NSClassFromString(@"IBARevealLoader") == nil)
        
    {
        
        NSString *revealLibName = @"libReveal"; // or @"libReveal-tvOS" for tvOS targets
        
        NSString *revealLibExtension = @"dylib";
        
        NSString *error;
        
        NSString *dyLibPath = [[NSBundle mainBundle] pathForResource:revealLibName ofType:revealLibExtension];
        
        if (dyLibPath != nil)
            
        {
            
            NSLog(@"Loading dynamic library: %@", dyLibPath);
            
            void *revealLib = dlopen([dyLibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
            
            if (revealLib == NULL)
                
            {
                
                error = [NSString stringWithUTF8String:dlerror()];
                
            }
            
        }
        
        else
            
        {
            
            error = @"File not found.";
            
        }
        
        if (error != nil)
            
        {
            
            NSString *message = [NSString stringWithFormat:@"%@.%@ failed to load with error: %@", revealLibName, revealLibExtension, error];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reveal library could not be loaded"
                                        
                                                                           message:message
                                        
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            
            [[[[[UIApplication sharedApplication] windows] firstObject] rootViewController] presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
    
}



@end
