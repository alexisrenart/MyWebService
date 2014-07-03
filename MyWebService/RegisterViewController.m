//
//  RegisterViewController.m
//  MyWebService
//
//  Created by Alexis RENART on 15/04/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import "RegisterViewController.h"
#import "API.h"
#import "UIAlertView+error.h"

#include <CommonCrypto/CommonDigest.h>


@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize usernameRegField, passwordRegField, verifpasswordRegField, firstnameRegField, lastnameRegField, emailRegField, birthdateRegField, adress1RegField, adress2RegField, countryRegField, cityRegField, zipcodeRegField;

@synthesize picker = _picker;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.usernameRegField.text = nil;
        self.passwordRegField.text = nil;
        self.verifpasswordRegField.text = nil;
        self.firstnameRegField.text = nil;
        self.lastnameRegField.text = nil;
        self.emailRegField.text = nil;
        self.birthdateRegField.text = nil;
        self.adress1RegField.text = nil;
        self.adress2RegField.text = nil;
        self.countryRegField.text = nil;
        self.cityRegField.text = nil;
        self.zipcodeRegField.text = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Hide keyboard from txtfields when tap outside
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // Receiver return
    self.usernameRegField.delegate = self;
    self.passwordRegField.delegate = self;
    self.verifpasswordRegField.delegate = self;
    self.firstnameRegField.delegate = self;
    self.lastnameRegField.delegate = self;
    self.emailRegField.delegate = self;
    self.birthdateRegField.delegate = self;
    self.adress1RegField.delegate = self;
    self.adress2RegField.delegate = self;
    self.countryRegField.delegate = self;
    self.cityRegField.delegate = self;
    self.zipcodeRegField.delegate = self;
    
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



// Hide keyboards from txtfields
-(void)dismissKeyboard {
    [usernameRegField resignFirstResponder];
    [passwordRegField resignFirstResponder];
    [verifpasswordRegField resignFirstResponder];
    [firstnameRegField resignFirstResponder];
    [lastnameRegField resignFirstResponder];
    [emailRegField resignFirstResponder];
    [adress1RegField resignFirstResponder];
    [adress2RegField resignFirstResponder];
    [cityRegField resignFirstResponder];
    [zipcodeRegField resignFirstResponder];

}

// Detect txtfield editing
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textfield {
    
    
    // Hide the pickerViews
    [pickerView removeFromSuperview];
    
    // Adjust scrollview
    if ((textfield != self.usernameRegField)&&(textfield != self.passwordRegField)&&(textfield != self.verifpasswordRegField)&&(textfield != self.firstnameRegField)) {
        [_registerScrollView setContentOffset:CGPointMake(0,textfield.center.y-300) animated:YES];
    }
    
    
    
    if (textfield == self.birthdateRegField)
    {
        [self datebirth];
        return NO;
    } else if (textfield == self.countryRegField)
    {
        [self country];
        return NO;
    } else {
        return YES;
    }
    
}

// Detect txtfield return
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//// COUNTRY PICKER VIEW
-(void)country {
    // Remove others pickerviews or keyboards from others txtfields
    [self dismissKeyboard];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    CGFloat screenHeight = screenRect.size.width;
    
    pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight/3 * 2, screenWidth, screenHeight/2)];
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
    
    countryRegField.text = countrypicker.selectedCountryName;
    
    _countrycode = countrypicker.selectedCountryCode;
    
    [pickerView removeFromSuperview];
}

-(void)cancelCountryPickerBtn {
    
    [pickerView removeFromSuperview];
}

////


/// DATE PICKER VIEW
-(void)datebirth {
    // Remove others pickerviews or keyboards from others txtfields
    [self dismissKeyboard];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    CGFloat screenHeight = screenRect.size.width;

    pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight/3 * 2, screenWidth, screenHeight/2)];
    
    pickerView.backgroundColor = [UIColor whiteColor];
    
    
    UIDatePicker* picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, screenWidth, screenHeight/2 - 40)];
    [picker setDatePickerMode:UIDatePickerModeDate];
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
    
    // init birthdate with current date
    birthdate = [NSDate date];
    
    [picker addTarget:self action:@selector(pickerChanged:) forControlEvents:(UIControlEventValueChanged)];

}

-(void)pickerChanged:(id)sender {

    birthdate = [(UIDatePicker*)sender date];

}

-(void)cancelPickerBtn {

    [pickerView removeFromSuperview];
}

-(void)donePickerBtn {
    
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"ddMMYYYY" options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc] init];
    [currentDateFormatter setDateFormat:formatString];
    
    NSDateFormatter *dateFormatterSQL = [[NSDateFormatter alloc] init];
    dateFormatterSQL.dateFormat = @"yyyy-MM-dd";
    
    birthdateSQL = [dateFormatterSQL stringFromDate:birthdate];
    
    [birthdateRegField setText:[currentDateFormatter stringFromDate:birthdate]];
    
    [pickerView removeFromSuperview];
}

///




- (IBAction)cancelBtn:(id)sender {

}

- (BOOL)validateEmail:(NSString *)emailStr
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
    
}


- (IBAction)registerBtn:(id)sender {
    
    //// Form validation
    /// Username
    if (usernameRegField.text.length < 4 ) {
        [UIAlertView error:@"The username must be at least 4 characters long!"];
        return;
    }
    /// Password
    if (passwordRegField.text.length < 4 ) {
        [UIAlertView error:@"The password must be at least 4 characters long!"];
        return;
    }
    /// Password confirmation
    if (![[NSString stringWithFormat:@"%@",passwordRegField.text] isEqualToString:[NSString stringWithFormat:@"%@",verifpasswordRegField.text]]) {
        //NSLog(@"%@ = %@",passwordRegField.text, verifpasswordRegField.text);
        [UIAlertView error:@"Bad password confirmation!"];
        return;
    }
    /// Email
    if(![self validateEmail:emailRegField.text])
    {
        // user entered invalid email address
        [UIAlertView error:@"Invalid email address!"];
        return;
    }
    /// ZipCode
    if ((zipcodeRegField.text.length < 5 )&&(![zipcodeRegField.text  isEqual: @""])) {
        [UIAlertView error:@"Zip Code must be at least 5-digit long!"];
        return;
    }


    
    // Salt the password
    NSString* saltedPassword = [NSString stringWithFormat:@"%@%@", passwordRegField.text, kSalt];
    
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
    NSString* command = @"register";
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  command, @"command",
                                  usernameRegField.text, @"username",
                                  hashedPassword, @"password",
                                  firstnameRegField.text, @"firstname",
                                  lastnameRegField.text, @"lastname",
                                  emailRegField.text, @"email",
                                  adress1RegField.text, @"adress1",
                                  adress2RegField.text, @"adress2",
                                  _countrycode, @"country",
                                  cityRegField.text, @"city",
                                  zipcodeRegField.text, @"zipcode",
                                  birthdateSQL, @"birthdate",
                                  nil];
    
    // Make the call to the web API
    [[API sharedInstance] commandWithParams:params
                               onCompletion:^(NSDictionary *json) {
                                   // Result returned
                                   NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
                                   
                                   if ([json objectForKey:@"error"]==nil)  {
                                       
                                       // Success connection message
                                       [[[UIAlertView alloc] initWithTitle:@"Registration saved"
                                                            message:[NSString stringWithFormat:@"Welcome %@ \n(Login to start)",[res objectForKey:@"username"] ]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Close"
                                                         otherButtonTitles: nil] show];
                                       
                                       [self performSegueWithIdentifier:@"dismissSegue" sender:self];
                                       
                                   } else {
                                       
                                       // Error message
                                       [UIAlertView error:[json objectForKey:@"error"]];

                                   }
                                   
                               }];

}
@end
