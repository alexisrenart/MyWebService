//
//  MyProfilViewController.h
//  MyWebService
//
//  Created by Alexis RENART on 21/04/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryPicker.h"

@interface MyProfilViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
    UIView *pickerView;
    NSDate *birthdate;
    NSString *birthdateSQL;
    CountryPicker *countrypicker;
    UIAlertView *alertViewNewPass;
    UIAlertView *alertViewNewPassVerif;
    NSString *passTMP;
    UIAlertView *alertViewDelProfil;
    }

@property (strong, nonatomic) IBOutlet NSString *countrycode;

@property (weak, nonatomic) IBOutlet UIScrollView *myprofilScrollView;

@property (weak, nonatomic) IBOutlet UITextField *usernameMyProfilField;
@property (weak, nonatomic) IBOutlet UITextField *firstnameMyProfilField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameMyProfilField;
@property (weak, nonatomic) IBOutlet UITextField *mailMyProfilField;
@property (weak, nonatomic) IBOutlet UITextField *birthdateMyProfilField;
@property (weak, nonatomic) IBOutlet UITextField *adress1MyProfilField;
@property (weak, nonatomic) IBOutlet UITextField *adress2MyProfilField;
@property (weak, nonatomic) IBOutlet UITextField *countryMyProfilField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeMyProfilField;
@property (weak, nonatomic) IBOutlet UITextField *cityMyProfilField;

@property (weak, nonatomic) IBOutlet UIButton *savechangesBtnOutlet;

@property (nonatomic, assign, readwrite) UIDatePicker *picker;

@property (weak, nonatomic) IBOutlet UIButton *photoprofilBtnOutlet;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlOutlet;

@property (weak, nonatomic) IBOutlet UILabel *connectionLabel;

-(void)cancelPickerBtn;
-(void)donePickerBtn;


- (IBAction)changepasswordBtn:(id)sender;

- (IBAction)photoprofilBtn:(id)sender;

- (IBAction)savechangesBtn:(id)sender;

- (IBAction)deleteprofilBtn:(id)sender;

- (IBAction)segmentControlBtn:(UISegmentedControl *)sender;

@end
