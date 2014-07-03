//
//  SplitViewController.m
//  MyWebService
//
//  Created by Alexis RENART on 07/05/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import "SplitViewController.h"
#import "API.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

#import "UIAlertView+error.h"


@interface SplitViewController ()

@end

@implementation SplitViewController

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
    
    MasterViewController *masterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:masterVC];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailVC];

    
    masterVC.detailViewController = detailVC;

    
    self.viewControllers = [NSArray arrayWithObjects:masterNav, detailNav, nil];
    
    self.view.window.rootViewController = self;
    
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
