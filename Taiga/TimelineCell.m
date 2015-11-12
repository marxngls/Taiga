//
//  TimelineCell.m
//  Taiga
//
//  Created by Джонни Диксон on 29.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "TimelineCell.h"
#import "Masonry.h"

@implementation TimelineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

-(void) commonInit{
    [self setImageView];
    
    [self setTextEvent];
    
    [self setPubDate];

    
}

- (void)setImageView {
    _userPhoto = [UIImageView new];
    
    _userPhoto.image = [UIImage imageNamed:@"placeholder"];
    
    [self.contentView addSubview:_userPhoto];
    
    [_userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@35);
        make.width.equalTo(@35);
    }];
}

-(void) setPubDate{
    _pubDateLabel = [UILabel new];
    
    _pubDateLabel.font = [UIFont systemFontOfSize:10];
    
    _pubDateLabel.textColor = [UIColor lightGrayColor];
    
    _pubDateLabel.numberOfLines = 0;
    
    [self.contentView addSubview:_pubDateLabel];
    
    [_pubDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void) setTextEvent {
    _textEventLabel = [UILabel new];
    
    _textEventLabel.font = [UIFont systemFontOfSize:15];
    
    _textEventLabel.lineBreakMode = NSLineBreakByWordWrapping;

    _textEventLabel.numberOfLines = 0;
    
    [self.contentView addSubview:_textEventLabel];
    
    [_textEventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userPhoto.mas_right).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
}




@end
