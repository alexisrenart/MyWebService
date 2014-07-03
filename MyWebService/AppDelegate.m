//
//  AppDelegate.m
//  MyWebService
//
//  Created by Alexis RENART on 15/04/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"

//#import "API.h"

//#import "LoginViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    // Display the network activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
  
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
    
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    NSMutableDictionary *paramslogout = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   @"logout",@"command",
//                                   nil];
//    
//    NSError *errorlogout = nil;
//    NSString * urlStringlogout = [NSString stringWithFormat:@"%@%@", kAPIHost, kAPIPath];
//    
//    
////    
////    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://admin.poslavu.com/cp/reqserv/"]];
////    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
////    [request setHTTPBody:[[NSString stringWithFormat:@"dataname=tangere_techno&key=dBkeY&token=dBt0kEn&table=menu_groups"] dataUsingEncoding:NSUTF8StringEncoding]];
////    [request setHTTPMethod:@"POST"];
//    
//    
//    // 1. Create AFHTTPRequestSerializer which will create your request.
//    AFHTTPRequestSerializer *serializerlogout = [AFHTTPRequestSerializer serializer];
//    
//    // 2. Create an NSMutableURLRequest.
//    NSMutableURLRequest *request =
//    [serializerlogout multipartFormRequestWithMethod:@"POST"
//                                           URLString:urlStringlogout
//                                          parameters:paramslogout
//                           constructingBodyWithBlock:nil                                               error:&errorlogout];
////    NSError *error = nil; NSURLResponse *response = nil;
////    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
////    if (error) {
////        NSLog(@"Error:%@", error.localizedDescription);
////    }
////    else {
////        //success
////    }
//    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    [connection start];
//
//    
//    
////    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
////    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
////        NSLog(@"SUCCESS");
////        //NSData *data = (NSData *)responseObject;
////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        NSLog(@"Error: %@", error);
////    }];
////    [operation start];
//    
//
//    
////    // 1. Create AFHTTPRequestSerializer which will create your request.
////    AFHTTPRequestSerializer *serializerlogout = [AFHTTPRequestSerializer serializer];
////    
////    // 2. Create an NSMutableURLRequest.
////    NSMutableURLRequest *requestlogout =
////    [serializerlogout multipartFormRequestWithMethod:@"POST"
////                                     URLString:urlStringlogout
////                                    parameters:paramslogout
////                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
////                         
////                     }
////                                         error:&errorlogout];
////    
////    // Request timeout interval (in seconds)
////    [requestlogout setTimeoutInterval:10.0];
////    
////    // 3. Create and use AFHTTPRequestOperationManager to create an AFHTTPRequestOperation from the NSMutableURLRequest that we just created.
////    AFHTTPRequestOperationManager *managerlogout = [AFHTTPRequestOperationManager manager];
////    AFHTTPRequestOperation *operationlogout =
////    [managerlogout HTTPRequestOperationWithRequest:requestlogout
////                                     success:^(AFHTTPRequestOperation *operationlogout, id responseObject) {
////                                         NSLog(@"Success ");
////                                         //completionBlock(responseObject);
////                                     } failure:^(AFHTTPRequestOperation *operationlogout, NSError *errorlogout) {
////                                         NSLog(@"Failure ");
////                                         //completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
////                                     }];
////    
////    
////    
////    
////    //    // 4. Set the progress block of the operation.
////    //    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
////    //                                        NSInteger totalBytesWritten,
////    //                                        NSInteger totalBytesExpectedToWrite) {
////    //        NSLog(@"Wrote %ld/%ld bytes", (long)totalBytesWritten, (long)totalBytesExpectedToWrite);
////    //    }];
////    
////    
////    // 5. Begin!
////    [operationlogout start];
    

    
    
    
     NSLog(@"applicationDidEnterBackground");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationBecomeActive");
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //[self logout];
    
    NSLog(@"applicationWillTerminate");
}


// Supported interface orientation for imagepicker controller
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
}
/*
-(void)logout {
    
    //logout the user from the server, and also upon success destroy the local authorization
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"logout",@"command",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //logged out from server
                                   [API sharedInstance].user = nil;
                                   
                                   // Return to loginview controller
                                   
                                   //// Return to LoginView when the application did enter background
                                   // Init the view with loginview from storyboard
                                   UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                   LoginViewController *loginViewController = (LoginViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"loginViewController"];
                                   //set the root controller to loginViewController
                                   self.window.rootViewController = loginViewController;
                                   
                                   
                                   // Disconnected message
                                   [[[UIAlertView alloc] initWithTitle:@"Disconnected"
                                                               message:@"You have been disconnected."
                                                              delegate:nil
                                                     cancelButtonTitle:@"Close"
                                                     otherButtonTitles: nil] show];
                                   
                               }];

    
}
*/


@end
