//
//  KanbanCell.m
//  Taiga
//
//  Created by Джонни Диксон on 30.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "KanbanCell.h"
#import "Masonry.h"

@implementation KanbanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void) commonInit{
    
    [self setCellLayer];
    
    [self setImageView];
    
    [self setStoryNumber];
        
    [self setStoryName];
    
}

-(void) setCellLayer{
    self.contentView.layer.backgroundColor = [UIColor colorWithRed:(160/255.0) green:(97/255.0) blue:(5/255.0) alpha:0.2].CGColor ;
    
    self.contentView.layer.borderWidth = 3;
    
    self.contentView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
}

- (void)setImageView {
    _storyImageView = [UIImageView new];
    
    _storyImageView.image = [UIImage imageNamed:@"placeholder"];
    
    _storyImageView.layer.borderWidth = 1;
    
    _storyImageView.layer.cornerRadius = 5;
    
    _storyImageView.clipsToBounds = YES;
    
    _storyImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
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
    
    _storyNumber.textColor = [UIColor blackColor];
    
    _storyNumber.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:_storyNumber];
    
    [_storyNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storyImageView.mas_right).offset(15);
        make.bottom.equalTo(self.contentView.mas_centerY);
    }];
}

- (void)setStoryName {
    _storyName = [UILabel new];
    
    _storyName.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:_storyName];
    
    [_storyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storyNumber.mas_right).offset(8);
        make.bottom.equalTo(self.contentView.mas_centerY);
    }];
}


@end
