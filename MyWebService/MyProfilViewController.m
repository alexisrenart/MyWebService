//
//  MyProfilViewController.m
//  MyWebService
//
//  Created by Alexis RENART on 21/04/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import "MyProfilViewController.h"
#import "API.h"
#import "UIAlertView+error.h"
#import "UIImage+Resize.h"
#import "UIImagePickerController+OrientationFix.h"

#import "SVProgressHUD.h"

#include <CommonCrypto/CommonDigest.h>

@interface MyProfilViewController ()

@end

@implementation MyProfilViewController

@synthesize usernameMyProfilField, firstnameMyProfilField, lastnameMyProfilField, mailMyProfilField, birthdateMyProfilField, adress1MyProfilField, adress2MyProfilField, countryMyProfilField, zipcodeMyProfilField, cityMyProfilField;
@synthesize savechangesBtnOutlet, photoprofilBtnOutlet, connectionLabel, segmentControlOutlet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



//////////////////////////////////////////////////// ViewDidLoad ////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // ScrollView size
    [self.myprofilScrollView setScrollEnabled:YES];
    [self.myprofilScrollView setContentSize:(CGSizeMake(1024, 1024))];
    
    // Hide keyboard from txtfields when tap outside
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // Return receivers
    self.usernameMyProfilField.delegate = self;
    self.firstnameMyProfilField.delegate = self;
    self.lastnameMyProfilField.delegate = self;
    self.mailMyProfilField.delegate = self;
    self.birthdateMyProfilField.delegate = self;
    self.adress1MyProfilField.delegate = self;
    self.adress2MyProfilField.delegate = self;
    self.countryMyProfilField.delegate = self;
    self.zipcodeMyProfilField.delegate = self;
    self.cityMyProfilField.delegate = self;
    
    // Username txtfield disabled
    [usernameMyProfilField setBackgroundColor:[UIColor clearColor]];
    [usernameMyProfilField setBorderStyle:UITextBorderStyleNone];
    usernameMyProfilField.enabled = NO;
    
    [self readMyProfil];
    
    [self updatePhotoProfil];

    // Button save changes disabled
    savechangesBtnOutlet.enabled = NO;
    
    
    // Init alertViews when changing the password
    alertViewNewPass = [[UIAlertView alloc] initWithTitle:@"New password"
                                                  message:@"Tap your new password."
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Ok", nil] ;
    alertViewNewPass.tag = 3;
    alertViewNewPass.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    alertViewNewPassVerif = [[UIAlertView alloc] initWithTitle:@"New password verification"
                                                       message:@"Tap your new password again."
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Ok", nil] ;
    alertViewNewPassVerif.tag = 4;
    alertViewNewPassVerif.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    
    alertViewDelProfil = [[UIAlertView alloc] initWithTitle:@"!!! WARNING !!!"
                                                       message:@"Are you sure to delete your profile?"
                                                      delegate:self
                                             cancelButtonTitle:@"NO"
                                             otherButtonTitles:@"YES", nil] ;
    alertViewDelProfil.tag = 5;
    alertViewDelProfil.alertViewStyle = UIAlertViewStyleDefault;
    
    
    // Defaut selected segment control
    connectionLabel.textColor = [UIColor greenColor];
    segmentControlOutlet.selectedSegmentIndex = 0;
    

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Detect txtfield return
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


// Detect txtfield begin editing
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textfield {

    savechangesBtnOutlet.enabled = NO;
    
    // Hide the pickerViews
    [pickerView removeFromSuperview];
    
    // Adjust scrollview
    if ((textfield != self.usernameMyProfilField)&&(textfield != self.firstnameMyProfilField)&&(textfield != self.lastnameMyProfilField)) {
        [_myprofilScrollView setContentOffset:CGPointMake(0,textfield.center.y-300) animated:YES];
    }
    
    
    
    if (textfield == self.birthdateMyProfilField)
    {
        [self datebirth];
        return NO;
    } else if (textfield == self.countryMyProfilField)
    {
        [self country];
        return NO;
    } else {
        return YES;
    }
    
}

// Detect txtfield end editing
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    //// Form validation
    
    /// Email
    if (textField == self.mailMyProfilField) {
     if(![self validateEmail:textField.text])
     {
     // user entered invalid email address
     [UIAlertView error:@"Invalid email address!"];
     return [self validateEmail:textField.text];
     }
    }

    /// ZipCode
    if (textField == self.zipcodeMyProfilField) {
        if ((textField.text.length < 5 )&&(![textField.text  isEqual: @""])) {
            [UIAlertView error:@"Zip Code must be at least 5-digit long!"];
            return NO;
        }
    }

    self.savechangesBtnOutlet.enabled = YES;
    
    return YES;    
}

// Detect changes from txtfields
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

// Hide keyboards from txtfields
-(void)dismissKeyboard {
    [usernameMyProfilField resignFirstResponder];
    [firstnameMyProfilField resignFirstResponder];
    [lastnameMyProfilField resignFirstResponder];
    [mailMyProfilField resignFirstResponder];
    [adress1MyProfilField resignFirstResponder];
    [adress2MyProfilField resignFirstResponder];
    [zipcodeMyProfilField resignFirstResponder];
    [cityMyProfilField resignFirstResponder];
    [pickerView removeFromSuperview];

    
}

// My profil reading from SQL database
-(void)readMyProfil {
    
    // Display the spinner during loading
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1]];
    [SVProgressHUD showWithStatus:@"Please Wait" maskType:SVProgressHUDMaskTypeGradient];
   
    // Build tab and sent command to JSON request
    NSString* command = @"readmyprofil";
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  command, @"command",
                                  [[[API sharedInstance] user] objectForKey:@"iduser"], @"iduser",
                                  nil];
    
    // Make the call to the web API
    [[API sharedInstance] commandWithParams:params
                               onCompletion:^(NSDictionary *json) {
                                   // Result returned
                                   NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
                                   
                                   if ([json objectForKey:@"error"]==nil)  {
                                       
                                       usernameMyProfilField.text = [res objectForKey:@"username"];
                                       firstnameMyProfilField.text = [res objectForKey:@"firstname"];
                                       lastnameMyProfilField.text = [res objectForKey:@"lastname"];
                                       mailMyProfilField.text = [res objectForKey:@"email"];
            
                                       //// Convert date from SQL database
                                       NSString *dateStringSQL = [res objectForKey:@"birthdate"];
                                       NSDateFormatter *dateFormatterSQL = [[NSDateFormatter alloc] init];
                                       dateFormatterSQL.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                       
                                       NSString *dateTimeStringSQL = [[NSString alloc] initWithFormat:@"%@ 12:00:00",dateStringSQL];
                                       
                                       NSDate *date = [dateFormatterSQL dateFromString:dateTimeStringSQL];
                                       
                                       NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"ddMMYYYY" options:0 locale:[NSLocale currentLocale]];
                                       NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc] init];
                                       [currentDateFormatter setDateFormat:formatString];
                                       currentDateFormatter.dateStyle = NSDateFormatterShortStyle;
                                       
                                       NSString *dateString = [currentDateFormatter stringFromDate:date];
                                       
                                       if ([[res objectForKey:@"birthdate"] isEqualToString:@"0000-00-00"]) {
                                           [birthdateMyProfilField.text isEqualToString:@""];
                                       } else {
                                           birthdateMyProfilField.text = dateString;
                                           birthdateSQL = [res objectForKey:@"birthdate"];
                                       }
                                       ////
                                       
                                       self.adress1MyProfilField.text = [res objectForKey:@"adress1"];
                                       self.adress2MyProfilField.text = [res objectForKey:@"adress2"];
                                       
                                       
                                       _countrycode = [res objectForKey:@"country"];
                                       
                                       if (![_countrycode isEqualToString:@""]) {
                                           countrypicker = [[CountryPicker alloc] init];
                                           
                                           [countrypicker setSelectedCountryCode:[res objectForKey:@"country"]];
                                           
                                           countryMyProfilField.text = countrypicker.selectedCountryName;
                                         
                                       } else {
                                           countryMyProfilField.text = @"";
                                       }
                                       
                                       
                                       if ([[res objectForKey:@"zipcode"] isEqualToString:@"0"]) {
                                           [zipcodeMyProfilField.text isEqualToString:@""];
                                       } else {
                                           zipcodeMyProfilField.text = [res objectForKey:@"zipcode"];
                                       }
                                       cityMyProfilField.text = [res objectForKey:@"city"];
                                       
                                       // Hide spinner
                                       [SVProgressHUD dismiss];

                                       
                                   } else {
                                       
                                       // Hide spinner
                                       [SVProgressHUD dismiss];
                                       
                                       // Error message
                                       [UIAlertView error:[json objectForKey:@"error"]];
                                       
                                   }
                                   
                               }];
}

// Update txtfields with SQL database (and read profil)
-(void)updateMyProfil {
    
    // Display the spinner during loading
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1]];
    [SVProgressHUD showWithStatus:@"Please Wait" maskType:SVProgressHUDMaskTypeGradient];
    
    // Change values of birthdate and zipcode if are null
    if ([birthdateSQL  isEqual: @""]) {
        birthdateSQL = @"0000-00-00";
    }
    
    NSString* zipcode = [[NSString alloc] init];
    if ([zipcodeMyProfilField.text  isEqual: @""]) {
        zipcode = @"0";
    } else {
        zipcode = zipcodeMyProfilField.text;
    }
    
    
    // Build tab and sent command to JSON request
    NSString* command = @"updateprofil";
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  command, @"command",
                                  firstnameMyProfilField.text, @"firstname",
                                  lastnameMyProfilField.text, @"lastname",
                                  mailMyProfilField.text, @"email",
                                  adress1MyProfilField.text, @"adress1",
                                  adress2MyProfilField.text, @"adress2",
                                  _countrycode, @"country",
                                  cityMyProfilField.text, @"city",
                                  zipcode, @"zipcode",
                                  birthdateSQL, @"birthdate",
                                  nil];
    
    // Make the call to the web API
    [[API sharedInstance] commandWithParams:params
                               onCompletion:^(NSDictionary *json) {
                                   
                                   if ([json objectForKey:@"error"]==nil)  {
                                       
                                       // Result returned
                                       NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
                                       
                                       if ([json objectForKey:@"error"]==nil)  {
                                           
                                           
                                           usernameMyProfilField.text = [res objectForKey:@"username"];
                                           firstnameMyProfilField.text = [res objectForKey:@"firstname"];
                                           lastnameMyProfilField.text = [res objectForKey:@"lastname"];
                                           mailMyProfilField.text = [res objectForKey:@"email"];
                                           
                                           //// Convert date from SQL database
                                           NSString *dateStringSQL = [res objectForKey:@"birthdate"];
                                           NSDateFormatter *dateFormatterSQL = [[NSDateFormatter alloc] init];
                                           dateFormatterSQL.dateFormat = @"yyyy-MM-dd";
                                           NSDate *date = [dateFormatterSQL dateFromString:dateStringSQL];
                                           
                                           NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"ddMMYYYY" options:0 locale:[NSLocale currentLocale]];
                                           NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc] init];
                                           [currentDateFormatter setDateFormat:formatString];
                                           [currentDateFormatter setDateStyle:NSDateFormatterShortStyle];

                                           NSString *dateString = [currentDateFormatter stringFromDate:date];
                                           
                                           if ([[res objectForKey:@"birthdate"] isEqualToString:@"0000-00-00"]) {
                                               [birthdateMyProfilField.text isEqualToString:@""];
                                           } else {
                                               birthdateMyProfilField.text = dateString;
                                           }
                                           ////
                                           
                                           self.adress1MyProfilField.text = [res objectForKey:@"adress1"];
                                           self.adress2MyProfilField.text = [res objectForKey:@"adress2"];
                                           
                                           //
                                           if (![_countrycode isEqualToString:@""]) {
                                               countrypicker = [[CountryPicker alloc] init];
                                               
                                               [countrypicker setSelectedCountryCode:[res objectForKey:@"country"]];
                                               
                                               countryMyProfilField.text = countrypicker.selectedCountryName;
                                           
                                           } else {
                                               countryMyProfilField.text = @"";
                                           }
                                           //
                                           
                                           
                                           if ([[res objectForKey:@"zipcode"] isEqualToString:@"0"]) {
                                               [zipcodeMyProfilField.text isEqualToString:@""];
                                           } else {
                                               zipcodeMyProfilField.text = [res objectForKey:@"zipcode"];
                                           }
                                           cityMyProfilField.text = [res objectForKey:@"city"];
                                           
                                           
                                       } else {
                                           
                                           // Error message
                                           [UIAlertView error:[json objectForKey:@"error"]];
                                           
                                       }

                                       
                                       // Hide spinner
                                       [SVProgressHUD dismiss];
                                       
                                       // Success request message
                                       [[[UIAlertView alloc] initWithTitle:@"Profil saved"
                                                                   message:[NSString stringWithFormat:@"Your informations has been recorded. " ]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Close"
                                                         otherButtonTitles: nil] show];
                                       
                                       
                                   } else {
                                       
                                       // Hide spinner
                                       [SVProgressHUD dismiss];
                                       
                                       // Error message
                                       [UIAlertView error:[json objectForKey:@"error"]];
                                       
                                   }
                                   
                               }];

}

// Delete the profile
-(void)deleteMyProfil {
    
    // Dsiplay the spinner during loading
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1]];
    [SVProgressHUD showWithStatus:@"Please Wait" maskType:SVProgressHUDMaskTypeGradient];
    
    // Build tab and sent command to JSON request
    NSString* command = @"deleteprofil";
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  command, @"command",
                                  [[[API sharedInstance] user] objectForKey:@"iduser"], @"iduser",
                                  [[[API sharedInstance] user] objectForKey:@"username"], @"username",
                                  nil];
    
    // Make the call to the web API
    [[API sharedInstance] commandWithParams:params
                               onCompletion:^(NSDictionary *json) {
                                   
                                   if ([json objectForKey:@"error"]==nil) {
                                       // Success
                                       // Hide spinner
                                       [SVProgressHUD dismiss];
                                       
                                   } else {
                                       // Hide spinner
                                       [SVProgressHUD dismiss];
                                       // Error message
                                       [UIAlertView error:[json objectForKey:@"error"]];
                                       
                                   }
                                   
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


//// COUNTRY PICKER VIEW
-(void)country {
    // Remove others pickerviews or keyboards from others txtfields
    [self dismissKeyboard];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UITabBarController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
    
    NSLog(@"FRAME : %f",  tabbar.tabBar.frame.size.height);
    NSLog(@"FRAME : %f",  screenHeight);
    NSLog(@"FRAME : %f",  screenWidth);
    
    pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-((screenHeight/3)+49) , screenWidth, screenHeight/3)];
    pickerView.backgroundColor = [UIColor whiteColor];
    
    countrypicker = [[CountryPicker alloc] initWithFrame:CGRectMake(0, 40, screenWidth, screenHeight/2 - 40)];
    countrypicker.selectedLocale = [NSLocale currentLocale];
    
    [pickerView addSubview:countrypicker];
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, screenWidth, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIButton *doneButton = [UIButton buttonWithType:100];
    [doneButton addTarget:self action:@selector(doneCountryPickerBtn) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *cancelButton = [UIButton buttonWithType:100];
    [cancelButton addTarget:self action:@selector(cancelCountryPickerBtn) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    toolbar.items = [NSArray arrayWithObjects:cancelButtonItem,flexibleSpace, doneButtonItem, nil];
    
    [pickerView addSubview:toolbar];
    
    
    [self.view addSubview:pickerView];
    
    
}

-(void)doneCountryPickerBtn {
    
    countryMyProfilField.text = countrypicker.selectedCountryName;
    
    [pickerView removeFromSuperview];
    
    _countrycode = countrypicker.selectedCountryCode;
    
    savechangesBtnOutlet.enabled = YES;
}

-(void)cancelCountryPickerBtn {
    
    countryMyProfilField.text = @"";
    
    [pickerView removeFromSuperview];
    
    savechangesBtnOutlet.enabled = YES;
}

////


/// DATE PICKER VIEW
-(void)datebirth {
    // Remove others pickerviews or keyboards from others txtfields
    [self dismissKeyboard];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-((screenHeight/3)+49) , screenWidth, screenHeight/3)];
    
    pickerView.backgroundColor = [UIColor whiteColor];
    
    
    UIDatePicker* picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, screenWidth, screenHeight/2 - 40)];
    [picker setDatePickerMode:UIDatePickerModeDate];
    
    if ([birthdateMyProfilField.text isEqual:@""]) {
        // init birthdate with current date
        birthdate = [NSDate date];
        picker.date = [NSDate date];
    } else {
        // init birthdate with birthdate textField
        
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"ddMMYYYY" options:0 locale:[NSLocale currentLocale]];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        
        birthdate = [dateFormatter dateFromString:birthdateMyProfilField.text];
        
        picker.date = birthdate;
    }
    
    
    
    [pickerView addSubview:picker];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, screenWidth, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIButton *doneButton = [UIButton buttonWithType:100];
    [doneButton addTarget:self action:@selector(donePickerBtn) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *cancelButton = [UIButton buttonWithType:100];
    [cancelButton addTarget:self action:@selector(cancelPickerBtn) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];

    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    toolbar.items = [NSArray arrayWithObjects:cancelButtonItem,flexibleSpace, doneButtonItem, nil];
    
    
    [pickerView addSubview:toolbar];
    
    [self.view addSubview:pickerView];

    
    [picker addTarget:self action:@selector(pickerChanged:) forControlEvents:(UIControlEventValueChanged)];
    
}

-(void)pickerChanged:(id)sender {
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"ddMMYYYY" options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc] init];
    [currentDateFormatter setDateFormat:formatString];
    [currentDateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSString *dateString = [currentDateFormatter stringFromDate:[(UIDatePicker*)sender date]];
    
    
    birthdate = [currentDateFormatter dateFromString:dateString];
    
}

-(void)cancelPickerBtn {

    birthdateMyProfilField.text = @"";
    birthdateSQL = @"0000-00-00";
    
    [pickerView removeFromSuperview];
    
    savechangesBtnOutlet.enabled = YES;

}

-(void)donePickerBtn {
    
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"ddMMYYYY" options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc] init];
    [currentDateFormatter setDateFormat:formatString];
    [currentDateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSDateFormatter *dateFormatterSQL = [[NSDateFormatter alloc] init];
    dateFormatterSQL.dateFormat = @"yyyy-MM-dd";
    
    birthdateSQL = [dateFormatterSQL stringFromDate:birthdate];
    
    NSLog(@"DATE SQL : %@", birthdateSQL);
    NSLog(@"DATE : %@", birthdate);
    
    [birthdateMyProfilField setText:[currentDateFormatter stringFromDate:birthdate]];
    
    [pickerView removeFromSuperview];
    
    savechangesBtnOutlet.enabled = YES;
}

///


- (BOOL)validateEmail:(NSString *)emailStr
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ((alertView.tag == 2)&&(buttonIndex == 1)) {
        
        // Display spinner
        [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1]];
        [SVProgressHUD showWithStatus:@"Please Wait" maskType:SVProgressHUDMaskTypeGradient];
        
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        
        // Salt password
        NSString* saltedPassword = [NSString stringWithFormat:@"%@%@", alertTextField.text, kSalt];
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
        NSString* command = @"checkpass";
        NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      command, @"command",
                                      hashedPassword, @"password",
                                      nil];
        
        // Make the call to the web API
        [[API sharedInstance] commandWithParams:params
                                   onCompletion:^(NSDictionary *json) {
                                       // Result returned
                                       NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
                                       
                                       if ([json objectForKey:@"error"]==nil && [[res objectForKey:@"iduser"] intValue]>0) {
                                           
                                           [SVProgressHUD dismiss];
                                           [alertViewNewPass show];
                                           
                                       } else {
                                           [SVProgressHUD dismiss];
                                           // Error message
                                           [UIAlertView error:[json objectForKey:@"error"]];
                                           
                                       }
                                       
                                   }];
    }
    
    
    if ((alertView.tag == 3)&&(buttonIndex == 1)) {
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        passTMP = alertTextField.text;
        [alertViewNewPassVerif show];
    }
    
    if ((alertView.tag == 4)&&(buttonIndex == 1)) {
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        
        
        if ([alertTextField.text isEqualToString:passTMP]) {
            
            [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1]];
            [SVProgressHUD showWithStatus:@"Please Wait" maskType:SVProgressHUDMaskTypeGradient];
            
            // Salt the password
            NSString* saltedPassword = [NSString stringWithFormat:@"%@%@", alertTextField.text, kSalt];
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
            NSString* command = @"changepass";
            NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          command, @"command",
                                          hashedPassword, @"password",
                                          nil];
            
            // Make the call to the web API
            [[API sharedInstance] commandWithParams:params
                                       onCompletion:^(NSDictionary *json) {
                                           
                                           if ([json objectForKey:@"error"]==nil) {
                                               
                                               [SVProgressHUD dismiss];
                                               
                                               [[[UIAlertView alloc] initWithTitle:@"Success"
                                                                           message:[NSString stringWithFormat:@"Your new password have been saved."]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"Close"
                                                                 otherButtonTitles: nil] show];
                                               
                                           } else {
                                               
                                               [SVProgressHUD dismiss];
                                               
                                               // Error message
                                               [UIAlertView error:[json objectForKey:@"error"]];
                                               
                                           }
                                           
                                       }];
        } else {
            [UIAlertView error:@"Passwords are different."];
        }
        
    }
    
    
    
    if ((alertView.tag == 5)&&(buttonIndex == 1)) {
        
        [self deleteMyProfil];
        
        // Logout the user from the server, and also upon success destroy the local authorization
        [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 @"logout",@"command",
                                                 nil]
                                   onCompletion:^(NSDictionary *json) {
                                       
                                       // Logged out from server
                                       [API sharedInstance].user = nil;
                                       
                                       [self performSegueWithIdentifier:@"dismissSegue3" sender:self];
                                       
                                       [[[UIAlertView alloc] initWithTitle:@"Your profil have been deleted"
                                                                   message:@"I'm looking forward to seeing you again."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Close"
                                                         otherButtonTitles: nil] show];
                                       
                                   }];

        
    }
    

}


///// UPLOAD PHOTO
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        
        case 0:
        [self takePhoto]; break;
        case 1:
        [self choosePhoto];break;
        case 2:
        [self erasePhoto];
        break;
        
    }
}


- (void)erasePhoto {
    UIImage *imageprofildefaut = [UIImage imageNamed:@"profil"] ;
    [photoprofilBtnOutlet setBackgroundImage:imageprofildefaut forState:UIControlStateNormal];
    
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1]];
    [SVProgressHUD showWithStatus:@"Please Wait" maskType:SVProgressHUDMaskTypeGradient];
    
    // Build tab and sent command to JSON request
    NSString* command = @"erasephotoprofil";
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  command, @"command",
                                  [[[API sharedInstance] user] objectForKey:@"username"], @"username",
                                  @"profil", @"group",
                                  nil];
    // Make the call to the web API
    [[API sharedInstance] commandWithParams:params
                               onCompletion:^(NSDictionary *json) {
                                   
                                   
                                   if ([json objectForKey:@"error"]==nil) {
                                       
                                       [SVProgressHUD dismiss];
                                       
                                       // Operation success message
                                       [[[UIAlertView alloc] initWithTitle:@"Success"
                                                                   message:[NSString stringWithFormat:@"Your photo have been deleted."]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Close"
                                                         otherButtonTitles: nil] show];
                                   } else {
                                       
                                       [SVProgressHUD dismiss];
                                       
                                       // Error message
                                       [UIAlertView error:[json objectForKey:@"error"]];
                                   }
                                   
                               }];
    
    
    
    
}


// ACCESS TO CAMERA
-(void)takePhoto {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


// ACCES TO ALBUMS
-(void)choosePhoto {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}




-(void)uploadPhoto:(NSString *)pseudo :(UIImage *)file :(NSString *)title :(NSString *)group {
    
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1]];
    [SVProgressHUD showWithStatus:@"Please Wait" maskType:SVProgressHUDMaskTypeGradient];
    
    // Upload the image and the title to the web service
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"upload",@"command",
                                             pseudo, @"username",
                                             UIImageJPEGRepresentation(file,70), @"file",
                                             title, @"title",
                                             group, @"group",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //completion
                                   if (![json objectForKey:@"error"]) {
                                       
                                       [SVProgressHUD dismiss];
                                       
                                       //success
                                       [[[UIAlertView alloc]initWithTitle:@"Success"
                                                                  message:@"Photo saved"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil] show];
                                       
                                   } else {
                                       [SVProgressHUD dismiss];
                                       
                                       // Error, check for expired session and if so - authorize the user
                                       NSString* errorMsg = [json objectForKey:@"error"];
                                       [UIAlertView error:errorMsg];
                                       
                                       if ([@"Authorization required" compare:errorMsg]==NSOrderedSame) {
                                           // Back to the previous view
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }
                                   }
                                   
                               }];
}




-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // Resize the image from the camera
	UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(photoprofilBtnOutlet.frame.size.width, photoprofilBtnOutlet.frame.size.height) interpolationQuality:kCGInterpolationHigh];
    // Crop the image to a square (yikes, fancy!)
    UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width -photoprofilBtnOutlet.frame.size.width)/2, (scaledImage.size.height -photoprofilBtnOutlet.frame.size.height)/2, photoprofilBtnOutlet.frame.size.width, photoprofilBtnOutlet.frame.size.height)];
    // Show the photo on the screen
    [photoprofilBtnOutlet setBackgroundImage:croppedImage forState:UIControlStateNormal];
    
    // Upload photo on server
    [self uploadPhoto:([[[API sharedInstance] user] objectForKey:@"username"]) :(UIImage *)croppedImage :@"myprofil" :@"profil"];
    
    [[picker presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[picker presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}


- (void)updatePhotoProfil {
    NSString* fonction = @"myphoto";
    NSString* group = @"profil";
    NSMutableDictionary* param =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 fonction,@"command",
                                 [[[API sharedInstance] user] objectForKey:@"username"],@"username",
                                 group,@"group",
                                 nil];
    API* api = [API sharedInstance];
    [api commandWithParams:param
              onCompletion:^(NSDictionary *json) {
                  
                  
                  
                  if (![json objectForKey:@"error"]) {
                      //success
                      
                      // result returned
                      NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
                      
                      
                      if ([[res objectForKey:@"idphoto"] intValue]>0) {
                          
                          int currentidphoto = [[res objectForKey:@"idphoto"] intValue];
                          
                          // Show photo into the appropriate button
                          NSURL* imageURL = [api urlForImage:[NSNumber numberWithInt:currentidphoto] :(NSString *)[[[API sharedInstance] user] objectForKey:@"username"] :@"profil" isThumb:NO isProfil:YES];
                          
                          UIImage *imageFromImageView = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
                          [photoprofilBtnOutlet setBackgroundImage:imageFromImageView forState:UIControlStateNormal];
                      }
                      
                  } else {
                      // Error, check for expired session and if so - authorize the user
                      NSString* errorMsg = [json objectForKey:@"error"];
                      [UIAlertView error:errorMsg];
                      
                  }
                  
              }];
}


/////

-(void)checkConnectionStatus:(int)state {
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1]];
    [SVProgressHUD showWithStatus:@"Please Wait" maskType:SVProgressHUDMaskTypeGradient];
    
    NSString *stateStr = [NSString stringWithFormat:@"%d",state];
    
    // Upload the image and the title to the web service
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"onoffline",@"command",
                                             stateStr, @"state",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //completion
                                   if (![json objectForKey:@"error"]) {
                                       
                                       [SVProgressHUD dismiss];
                                       
                                       //success
                                       
                                       
                                   } else {
                                       
                                       [SVProgressHUD dismiss];
                                       
                                       //error
                                       NSString* errorMsg = [json objectForKey:@"error"];
                                       [UIAlertView error:errorMsg];
                                       
                                   }
                                   
                               }];
}




//////////////////////////////////////////////////   BUTTONS / ACTIONS    ///////////////////////////////////////////////////
- (IBAction)changepasswordBtn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Current password ?"
                                                        message:@"Tap your current password."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil] ;
    alertView.tag = 2;
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertView show];
}

- (IBAction)photoprofilBtn:(id)sender {
    
    //show the app menu
    UIActionSheet *mymenu = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Annuler"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Camera", @"Photo album", @"Delete photo", nil];
    
    
    mymenu.destructiveButtonIndex = 2;
    [mymenu showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)savechangesBtn:(id)sender {
    [self updateMyProfil];    
    savechangesBtnOutlet.enabled = NO;
    
}

- (IBAction)deleteprofilBtn:(id)sender {
    [alertViewDelProfil show];
}

- (IBAction)segmentControlBtn:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self checkConnectionStatus:1];
            connectionLabel.text = @"You are Online";
            connectionLabel.textColor = [UIColor greenColor];
            break;
        case 1:
            [self checkConnectionStatus:0];
            connectionLabel.text = @"You are Offline";
            connectionLabel.textColor = [UIColor redColor];
            break;

        default:
            break;
    }
    
    

}

@end
