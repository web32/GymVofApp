//
//  MSTabBarController.m
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 26.12.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import "MSTabBarController.h"

@implementation MSTabBarController

-(void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];    


}





-(void)keyBoardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat tabBarHeight = self.tabBar.frame.size.height;
    
    CGRect frame = self.tabBar.frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        frame.origin.y = screenHeight - keyboardSize.height - tabBarHeight;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        frame.origin.y = screenHeight - keyboardSize.height - tabBarHeight;
    }
    
    [UIView animateWithDuration:0.25f animations:^
     {
         self.tabBar.frame = frame;
     }];
}

-(void)keyBoardWillHide:(NSNotification *)notification
{
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat tabBarHeight = self.tabBar.frame.size.height;
    
    CGRect frame = self.tabBar.frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        frame.origin.y = screenHeight - tabBarHeight;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        frame.origin.y = screenHeight- tabBarHeight;
    }
    
    [UIView animateWithDuration:0.25f animations:^
     {
         self.tabBar.frame = frame;
     }];
    
}



@end
