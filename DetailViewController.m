//
//  DetailViewController.m
//  MyWebService
//
//  Created by Alexis RENART on 05/05/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import "DetailViewController.h"
#import "SplitViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize photoprofilOutlet;

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
    
    _hideMaster = 0;
    
}

- (void)HideShowMaster {
    
    _hideMaster = !_hideMaster;
    
    _hideMasterBtnOutlet.title = (_hideMaster) ? @">>" : @"<<";
    
    // Must manually reset the delegate back to self in order to force call "shouldHideViewController"
    [self.splitViewController.view setNeedsLayout];
    self.splitViewController.delegate = nil;
    self.splitViewController.delegate = self;
    
    [self.splitViewController willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

#pragma mark - SplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return _hideMaster;
}


#pragma mark - Button

- (IBAction)hideMasterBtn:(id)sender
{
    [self HideShowMaster];
}



@end
