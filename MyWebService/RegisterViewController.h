//
//  RegisterViewController.h
//  MyWebService
//
//  Created by Alexis RENART on 15/04/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryPicker.h"



@interface RegisterViewController : UIViewController <UITextFieldDelegate> {
    
    UIView *pickerView;
    NSDate *birthdate;
    NSString *birthdateSQL;
    CountryPicker *countrypicker;

    
}
@property (strong, nonatomic) IBOutlet NSString *countrycode;

@property (weak, nonatomic) IBOutlet UIScrollView *registerScrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameRegField;
@property (weak, nonatomic) IBOutlet UITextField *passwordRegField;
@property (weak, nonatomic) IBOutlet UITextField *verifpasswordRegField;
@property (weak, nonatomic) IBOutlet UITextField *firstnameRegField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameRegField;
@property (weak, nonatomic) IBOutlet UITextField *emailRegField;
@property (weak, nonatomic) IBOutlet UITextField *birthdateRegField;
@property (weak, nonatomic) IBOutlet UITextField *adress1RegField;
@property (weak, nonatomic) IBOutlet UITextField *adress2RegField;
@property (weak, nonatomic) IBOutlet UITextField *countryRegField;
@property (weak, nonatomic) IBOutlet UITextField *cityRegField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeRegField;


@property (nonatomic, assign, readwrite) UIDatePicker *picker;


- (IBAction)cancelBtn:(id)sender;
- (IBAction)registerBtn:(id)sender;

-(void)cancelPickerBtn;
-(void)donePickerBtn;

@end
