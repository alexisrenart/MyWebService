//
//  LogoutViewController.m
//  MyWebService
//
//  Created by Alexis RENART on 17/04/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import "LogoutViewController.h"
#import "API.h"

@interface LogoutViewController ()

@end

@implementation LogoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        //logout the user from the server, and also upon success destroy the local authorization
        [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 @"logout",@"command",
                                                 nil]
                                   onCompletion:^(NSDictionary *json) {
                                       
                                       //logged out from server
                                       [API sharedInstance].user = nil;
                                       
                                       // Return to loginview controller
                                       [self performSegueWithIdentifier:@"dismissSegue2" sender:self];
                                       
                                       // Disconnected message
                                       [[[UIAlertView alloc] initWithTitle:@"Disconnected"
                                                                   message:@"See you later ;-)"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Close"
                                                         otherButtonTitles: nil] show];

                                   }];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
