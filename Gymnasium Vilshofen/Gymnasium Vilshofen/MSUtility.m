//
//  MSUtility.m
//  Gym Vilshofen
//
//  Created by Maximilian Söllner on 25.10.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import "MSUtility.h"

@implementation NSString (NSAddition)
-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSScanner* scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}
@end

@implementation MSUtility


+(NSString*)httpStringFromURL:(NSURL *)url
{
    //Check if there is an internet connection

    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *userAgent = [NSString stringWithFormat:@"MS-GymVof-App-%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //Check if the request has been redirected
    if (response.URL != url && false) {
        NSLog(@"Response URL does not match the request URL: %@ != %@", url, response.URL);
        return nil;
    }
    
    if(error)
    {
        //If the error exists print it to the console
        NSLog(@"%@", error);
    }
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (dataString.length == 0) {
        dataString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    }
    
    
    
    //Return the string or nil of no data was recieved
    if(dataString) {
        return dataString;
    }
    else
    {
        return nil;
    }
}

+(NSString *)cleanString:(NSString *)input {
    NSMutableString *aString = [NSMutableString stringWithString:input];
    [aString replaceOccurrencesOfString:@"&ouml;" withString:@"ö"
                               options:NSCaseInsensitiveSearch range: NSMakeRange(0, aString.length)];
    [aString replaceOccurrencesOfString:@"&uuml;" withString:@"ü"
                                options:NSCaseInsensitiveSearch range: NSMakeRange(0, aString.length)];
    [aString replaceOccurrencesOfString:@"&auml;" withString:@"ä"
                                options:NSCaseInsensitiveSearch range: NSMakeRange(0, aString.length)];
    [aString replaceOccurrencesOfString:@"&szlig;" withString:@"ß"
                                options:NSCaseInsensitiveSearch range: NSMakeRange(0, aString.length)];
    
    return [NSString stringWithString:aString];
}

@end
