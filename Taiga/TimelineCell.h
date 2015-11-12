//
//  TimelineCell.h
//  Taiga
//
//  Created by Джонни Диксон on 29.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineCell : UITableViewCell

@property (nonatomic,strong) UIImageView * userPhoto;

@property (nonatomic,strong) UILabel * textEventLabel;

@property (nonatomic,strong) UILabel * pubDateLabel;

@end
