//
//  AppDelegate.m
//  MyWebService
//
//  Created by Alexis RENART on 15/04/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import "UIAlertView+error.h"

@implementation UIAlertView(error)
+(void)error:(NSString*)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Error" 
                                message:msg 
                               delegate:nil 
                      cancelButtonTitle:@"Close" 
                      otherButtonTitles: nil] show];
}
@end
