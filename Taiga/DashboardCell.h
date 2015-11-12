//
//  DashboardCell.h
//  Taiga
//
//  Created by Джонни Диксон on 26.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardCell : UITableViewCell

@property (nonatomic, strong) UILabel * storyName;

@property (nonatomic, strong) UILabel * storyType;

@property (nonatomic, strong) UILabel * storyStatus;

@property (nonatomic, strong) UILabel * storyNumber;

@property (nonatomic, strong) UILabel * projectName;

@property (nonatomic, strong) UIImageView * storyImageView;

@end
