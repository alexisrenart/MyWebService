//
//  LoginViewController.m
//  MyWebService
//
//  Created by Alexis RENART on 15/04/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import "LoginViewController.h"

#import "API.h"
#import "UIAlertView+error.h"

#import "SVProgressHUD.h"

#import "Reachability.h"

#include <CommonCrypto/CommonDigest.h>



@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameLabel, passwordLabel, loginBtnLabel, registerBtnLabel, rememberLabel, usernameField, passwordField, switchOutlet, imageFontOutlet;




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
    
    //// FADE IN ANIMATION
    usernameLabel.alpha = 0;
    passwordLabel.alpha = 0;
    loginBtnLabel.alpha = 0;
    registerBtnLabel.alpha = 0;
    rememberLabel.alpha = 0;
    usernameField.alpha = 0;
    passwordField.alpha = 0;
    switchOutlet.alpha = 0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //don't forget to add delegate.....
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDuration:1.0];
    usernameLabel.alpha = 1;
    passwordLabel.alpha = 1;
    loginBtnLabel.alpha = 1;
    registerBtnLabel.alpha = 1;
    rememberLabel.alpha = 1;
    usernameField.alpha = 0.9;
    passwordField.alpha = 0.9;
    switchOutlet.alpha = 1;
    
    //also call this before commit animations......
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
    
    ////
    
    
    // Hide keyboard from txtfields when tap outside
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // Receiver return
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    
    //NSLog(@"%@",switchbool?@"YES":@"NO");
    [self.switchOutlet setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"switchDefaults"] animated:YES];
    self.usernameField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    self.passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    
    [self flashOn:imageFontOutlet];
    
}


- (void)flashOff:(UIView *)v
{
    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = .01;  //don't animate alpha to 0, otherwise you won't be able to interact with it
    } completion:^(BOOL finished) {
        [self flashOn:v];
    }];
}

- (void)flashOn:(UIView *)v
{
    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = 1;
    } completion:^(BOOL finished) {
        [self flashOff:v];
    }];
}


-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished    context:(void *)context {
    {
        usernameLabel.alpha = 1;
        passwordLabel.alpha = 1;
        loginBtnLabel.alpha = 1;
        registerBtnLabel.alpha = 1;
        rememberLabel.alpha = 1;
        usernameField.alpha = 0.9;
        passwordField.alpha = 0.9;
        switchOutlet.alpha = 1;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    // Check internet connection
    //[self checkInternetConnection];
    
}

-(void)checkInternetConnection {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        
        //Code when there is no connection
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No connection available!", @"AlertView")
                                                            message:NSLocalizedString(@"You have no internet connection available. Please check your network settings!", @"AlertView")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", @"AlertView")
                                                  otherButtonTitles:nil,
                                  nil];
        alertView.tag = 10;
        [alertView show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 10)&&(buttonIndex == 0))
    {
        exit(0);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"This memory warning from the LoginViewController. (I don't know the reasons)");
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

// Hide keyboards from txtfields
-(void)dismissKeyboard {
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

// Detect txtfield return
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Detect txtfield begin editing
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.usernameField) {
        _usernameFieldTMP = textField.text;
    }
    
    return YES;
}

// Detect txtfield end editing
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ((textField == self.usernameField)&&(![textField.text isEqualToString:_usernameFieldTMP])) {
        
            switchOutlet.on = NO;
            [[NSUserDefaults standardUserDefaults] setBool:0 forKey:@"switchDefaults"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;    
}


- (IBAction)loginBtn:(id)sender {
    
    
    //// Form validation
    // Username
    if (usernameField.text.length < 4 ) {
        [UIAlertView error:@"Entrer un pseudo de 4 charactères minimum."];
        return;
    }
    // Password
    if (passwordField.text.length < 4 ) {
        [UIAlertView error:@"Entrer un mot de passe de 4 charactères minimum."];
        return;
    }
    
    
    // Salt the password
    NSString* saltedPassword = [NSString stringWithFormat:@"%@%@", passwordField.text, kSalt];
    
    // Prepare hashed stockage
    NSString* hashedPassword = nil;
    unsigned char hashedPasswordData[CC_SHA1_DIGEST_LENGTH];
    
    // Hash the password
    NSData *data = [saltedPassword dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_SHA1([data bytes], [data length], hashedPasswordData)) {
        hashedPassword = [[NSString alloc] initWithBytes:hashedPasswordData length:sizeof(hashedPasswordData) encoding:NSASCIIStringEncoding];
    } else {
        [UIAlertView error:@"Password can't be sent"];
        return;
    }
    
    // Build tab and sent command to JSON request
    NSString* command = @"login";
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  command, @"command",
                                  usernameField.text, @"username",
                                  hashedPassword, @"password",
                                  nil];
    
    // Display spinner during loading
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1]];
    [SVProgressHUD showWithStatus:@"Please Wait" maskType:SVProgressHUDMaskTypeGradient];
    
    
    // Make the call to the web API
    [[API sharedInstance] commandWithParams:params
                               onCompletion:^(NSDictionary *json) {
                                   // Result returned
                                   NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
                                   
                                   if ([json objectForKey:@"error"]==nil && [[res objectForKey:@"iduser"] intValue]>0) {
                                       
                                       [[API sharedInstance] setUser: res];
                                       
                                       // Hide spinner
                                       [SVProgressHUD dismiss];
                                       
                                       // Message of connection success
                                       [[[UIAlertView alloc] initWithTitle:@"Connected"
                                                                   message:[NSString stringWithFormat:@"Welcome %@",[res objectForKey:@"username"] ]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Close"
                                                         otherButtonTitles: nil] show];
                                       
                                       [self performSegueWithIdentifier:@"authorizedSegue" sender:self];
                                       

                                       
                                   } else {
                                       
                                       [SVProgressHUD dismiss];
                                       
                                       // Error message
                                       [UIAlertView error:[json objectForKey:@"error"]];
                                       
                                   }
                                   
                               }];

    }

- (IBAction)registerBtn:(id)sender {
    
}

- (IBAction)switchAction:(id)sender {
    if (switchOutlet.on) {
        
        [[NSUserDefaults standardUserDefaults] setBool:switchOutlet.on forKey:@"switchDefaults"];
        [[NSUserDefaults standardUserDefaults] setValue:usernameField.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setValue:passwordField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        
        [[NSUserDefaults standardUserDefaults] setBool:0 forKey:@"switchDefaults"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
