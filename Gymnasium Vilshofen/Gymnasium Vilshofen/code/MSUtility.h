//
//  MSUtility.h
//  Gym Vilshofen
//
//  Created by Maximilian Söllner on 25.10.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface MSUtility : NSObject <NSURLSessionDelegate>

+(MSUtility*)sharedInstance;
+(NSURLSession *)sharedSession;

+(bool)teacherMode;
+(void)setTeacherMode:(bool)mode;

+(void)loadURL:(NSURL *)url withCompletionHandler:(void (^)(NSString *response))completionHandler;
+(NSString*)httpStringFromURL:(NSURL *)url;
+(NSString *)cleanString:(NSString *)input;


@end
