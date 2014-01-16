//
//  MSNewsCell.h
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 07.01.14.
//  Copyright (c) 2014 Maximilian Söllner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSNewsCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *textLabel;

-(void)setCellText:(NSString *)text;

@end
