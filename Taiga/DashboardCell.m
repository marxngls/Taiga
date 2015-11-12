//
//  DashboardCell.m
//  Taiga
//
//  Created by Джонни Диксон on 26.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "DashboardCell.h"
#import "Masonry.h"

@implementation DashboardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)setProjectName {
    _projectName = [UILabel new];
    
    _projectName.textColor = [UIColor lightGrayColor];
    
    _projectName.font = [UIFont systemFontOfSize:11];
    
    [self.contentView addSubview:_projectName];
    
    [_projectName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
}

- (void) commonInit{
    
    [self setImageView];
    
    [self setStoryNumber];
    
    [self setStoryType];
    
    [self setStoryName];
    
    [self setStoryStatus];
    
    [self setProjectName];
    
}

- (void)setImageView {
    _storyImageView = [UIImageView new];
    
    _storyImageView.image = [UIImage imageNamed:@"placeholder"];
    
    [self.contentView addSubview:_storyImageView];
    
    [_storyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@35);
        make.width.equalTo(@35);
    }];
}

- (void)setStoryNumber {
    _storyNumber = [UILabel new];
    
    _storyNumber.textColor = [UIColor lightGrayColor];
    
    _storyNumber.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:_storyNumber];
    
    [_storyNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storyImageView.mas_right).offset(15);
        make.top.equalTo(self.contentView.mas_centerY);
    }];
}

- (void)setStoryName {
    _storyName = [UILabel new];
    
    _storyName.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:_storyName];
    
    [_storyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storyNumber.mas_right).offset(8);
        make.top.equalTo(self.contentView.mas_centerY);
    }];
}

- (void)setStoryType {
    _storyType = [UILabel new];
    
    _storyType.font = [UIFont systemFontOfSize:11];
    
    [self.contentView addSubview:_storyType];
    
    [_storyType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.storyImageView.mas_right).offset(8);
    }];
}

- (void)setStoryStatus {
    _storyStatus = [UILabel new];
    
    _storyStatus.font = [UIFont systemFontOfSize:11];
    
    _storyStatus.textColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:_storyStatus];
    
    [_storyStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.storyType.mas_right).offset(8);
    }];
}



@end
