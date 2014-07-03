//
//  API.h
//  MyWebService
//
//  Created by Alexis RENART on 16/04/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

// Cryptage Key (= 45 char.)
#define kSalt @"Choose%a%new%key%here%:%change%it%by%your%key"

@interface API : AFHTTPSessionManager 


-(NSURL*)urlForImage:(NSNumber*)IdPhoto :(NSString *)pseudo :(NSString *)categorie isThumb:(BOOL)isThumb isProfil:(BOOL)isProfil;

// The authorized user
@property (strong, nonatomic) NSDictionary* user;

// API call completion block with result as JSON
typedef void (^JSONResponseBlock)(NSDictionary* json);


+(API *) sharedInstance;


// Check whether there's an authorized user
-(BOOL)isAuthorized;

// Send an API command to the server
-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;


@end
