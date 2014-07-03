//
//  LoginViewController.h
//  MyWebService
//
//  Created by Alexis RENART on 15/04/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtnLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerBtnLabel;
@property (weak, nonatomic) IBOutlet UILabel *rememberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageFontOutlet;


@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UISwitch *switchOutlet;

@property (strong, nonatomic) NSString *usernameFieldTMP;




- (IBAction)loginBtn:(id)sender;

- (IBAction)registerBtn:(id)sender;

- (IBAction)switchAction:(id)sender;

@end
