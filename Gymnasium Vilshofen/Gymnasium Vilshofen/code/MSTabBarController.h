//
//  MSTabBarController.h
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 26.12.13.
//  Copyright (c) 2013 Maximilian Söllner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSPlanViewController.h"

@interface MSTabBarController : UITabBarController <UIGestureRecognizerDelegate>

@property (readonly) NSString *day;


-(void)keyBoardWillShow:(NSNotification *)notification;

-(void)keyBoardWillHide:(NSNotification *)notification;

@end
