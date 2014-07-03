//
//  DetailViewController.h
//  MyWebService
//
//  Created by Alexis RENART on 05/05/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoprofilOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *imgcountryOutlet;

@property (weak, nonatomic) IBOutlet UILabel *usernameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *firstnameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *lastnameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *emailOutlet;
@property (weak, nonatomic) IBOutlet UILabel *birthdateOutlet;
@property (weak, nonatomic) IBOutlet UILabel *adress1Outlet;
@property (weak, nonatomic) IBOutlet UILabel *adress2Outlet;
@property (weak, nonatomic) IBOutlet UILabel *countryOutlet;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeOutlet;
@property (weak, nonatomic) IBOutlet UILabel *cityOutlet;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *hideMasterBtnOutlet;


@property (readwrite, nonatomic) BOOL hideMaster;

@property (readwrite, nonatomic) BOOL onlineState;

- (IBAction)hideMasterBtn:(id)sender;


@end
