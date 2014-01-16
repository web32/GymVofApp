//
//  MSNewsCell.m
//  Gymnasium Vilshofen
//
//  Created by Maximilian Söllner on 07.01.14.
//  Copyright (c) 2014 Maximilian Söllner. All rights reserved.
//

#import "MSNewsCell.h"

@implementation MSNewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel = [[UILabel alloc] initWithFrame:self.textLabel.frame =
                          CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 20)];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

-(void)setCellText:(NSString *)text
{
    self.textLabel.text = text;
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    
    CGSize expected = [self.textLabel sizeThatFits:CGSizeMake(self.textLabel.bounds.size.width - 50, CGFLOAT_MAX)];
    
    
    [self.textLabel setFrame:CGRectMake(10, 10, expected.width, expected.height)];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, expected.height + 20);
    
    
    
    
}

@end
