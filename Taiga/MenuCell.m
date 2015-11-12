//
//  MenuCell.m
//  Taiga
//
//  Created by Джонни Диксон on 08.11.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupCell];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void) setupCell{
    
}

@end
