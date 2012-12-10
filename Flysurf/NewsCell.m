//
//  NewsCell.m
//  Flysurf
//
//  Created by Garri Adrian Nablo on 12/10/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "NewsCell.h"
#import "News.h"

@implementation NewsCell

@synthesize Thumbnail, Date, Title, Details;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
