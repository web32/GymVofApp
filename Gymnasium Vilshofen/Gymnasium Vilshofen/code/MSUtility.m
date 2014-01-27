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

static MSUtility *sharedInstance;
static NSURLSession *sharedSession;

+(MSUtility *) sharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[MSUtility alloc] init];
    }
    return sharedInstance;
}

+(NSURLSession *) sharedSession {
    if (!sharedSession) {
        sharedSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:[MSUtility sharedInstance] delegateQueue:nil];
    }
    return sharedSession;
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{    
    if ([challenge previousFailureCount] == 0) {
        [[challenge sender] useCredential:
         [NSURLCredential credentialWithUser:[[NSUserDefaults standardUserDefaults] objectForKey:@"u"]
                                    password:[[NSUserDefaults standardUserDefaults] objectForKey:@"p"]
                                 persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    if ([challenge previousFailureCount] == 0) {
        [[challenge sender] useCredential:
         [NSURLCredential credentialWithUser:[[NSUserDefaults standardUserDefaults] objectForKey:@"u"]
                                    password:[[NSUserDefaults standardUserDefaults] objectForKey:@"p"]
                                 persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
    
}

+(void)loadURL:(NSURL *)url withCompletionHandler:(void (^)(NSString *response))completionHandler
{
    [[[MSUtility sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Konvertiere die Bytes zuerst als UTF8
        NSString *stringResponse = [MSUtility cleanString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        
        //Wenn die Konvertierung mit UTF8 fehlschlägt, gehen wir von ISO-Latin-1 aus
        if (stringResponse.length == 0) {
            stringResponse = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        }
        
        if(error)
        {
            //Sollte ein Fehler bestehen wir er in der Konsole ausgegeben
            NSLog(@"Fehler beim Download: %@", error);
        }
        
        //Completion-Handler ausführen
        completionHandler(stringResponse);
    }] resume];
}


+(NSString*)httpStringFromURL:(NSURL *)url
{
    //Erstelle eine Anfrage mit der übergebenen URL
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //Setze den User-Agent auf die AppVersion
    NSString *userAgent = [NSString stringWithFormat:@"MS-GymVof-App-%@-%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[UIDevice currentDevice] name]];
    [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [request setTimeoutInterval:5];
    
    NSURLResponse *response;
    NSError *error;
    
    //Sende die Anfrage und speichere die Daten als NSData
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    
    if(error)
    {
        //Sollte ein Fehler bestehen wir er in der Konsole ausgegeben
        NSLog(@"Fehler beim Download: %@", error);
    }
    
    //Konvertiere die Bytes zuerst als UTF8
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //Wenn die Konvertierung mit UTF8 fehlschlägt, gehen wir von ISO-Latin-1 aus
    if (dataString.length == 0) {
        dataString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    }
    
    
    //Wenn die Konvertierung mit beiden Kodierungen fehlschlägt wird null zurückgegeben, sonst der String selbst
    if(dataString) {
        return dataString;
    } else
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