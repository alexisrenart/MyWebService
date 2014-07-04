//
//  API.m
//  MyWebService
//
//  Created by Alexis RENART on 16/04/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import "API.h"

#import "UIKit+AFNetworking/UIActivityIndicatorView+AFNetworking.h"

// Web location of the service
#define kAPIHost @"http://localhost/"
#define kAPIPath @"mywebservice/"

@implementation API


// Create URL for image
-(NSURL*)urlForImage:(NSNumber*)IdPhoto :(NSString *)pseudo :(NSString *)categorie isThumb:(BOOL)isThumb isProfil:(BOOL)isProfil {
    NSString* urlString = [NSString stringWithFormat:@"%@%@upload/%@/%@/%@%@.jpg",
                           kAPIHost, kAPIPath, pseudo, categorie, (isProfil)?@"profil":IdPhoto, (isThumb)?@"-thumb":@""
                           ];
    return [NSURL URLWithString:urlString];
}


@synthesize user;


// Singleton methods
+(API *)sharedInstance
{
    static API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
    });
    
    
    sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];

    return sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
    if(self) {
        
        [self.requestSerializer setValue:@"Accept" forHTTPHeaderField:@"application/json"];
        
    }
    
    return self;
}


// User authorization
-(BOOL)isAuthorized
{
    return [[user objectForKey:@"iduser"] intValue]>0;
}



// Void to send a command with parameters and to receive data from request
-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
    NSError *error = nil;
    NSData* uploadFile = nil;
    NSString * urlString = [NSString stringWithFormat:@"%@%@", kAPIHost, kAPIPath];
    
    if ([params objectForKey:@"file"]) {
        uploadFile = (NSData*)[params objectForKey:@"file"];
        [params removeObjectForKey:@"file"];
    }
    
    // 1. Create AFHTTPRequestSerializer which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    // 2. Create an NSMutableURLRequest.
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST"
                                     URLString:urlString
                                    parameters:params
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         // if UPLOAD
                         if (uploadFile) {
                    
                             [formData appendPartWithFileData:uploadFile
                                                         name:@"file"
                                                     fileName:@"photo.jpg"
                                                     mimeType:@"image/jpeg"];
                         }

                     }
                                         error:&error];
    
    // Request timeout interval (in seconds)
    [request setTimeoutInterval:10.0];
    
    // 3. Create and use AFHTTPRequestOperationManager to create an AFHTTPRequestOperation from the NSMutableURLRequest that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         //NSLog(@"Success %@", responseObject);
                                         completionBlock(responseObject);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         //NSLog(@"Failure %@", error.description);
                                         completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
                                     }];

    
    
    
//    // 4. Set the progress block of the operation.
//    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
//                                        NSInteger totalBytesWritten,
//                                        NSInteger totalBytesExpectedToWrite) {
//        NSLog(@"Wrote %ld/%ld bytes", (long)totalBytesWritten, (long)totalBytesExpectedToWrite);
//    }];
    

    // 5. Begin!
    [operation start];


    
    
    
}



@end
