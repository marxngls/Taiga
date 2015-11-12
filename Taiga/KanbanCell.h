//
//  KanbanCell.h
//  Taiga
//
//  Created by Джонни Диксон on 30.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KanbanCell : UITableViewCell

@property (nonatomic, strong) UILabel * storyName;

@property (nonatomic, strong) UILabel * storyNumber;

@property (nonatomic, strong) UILabel * projectName;

@property (nonatomic, strong) UIImageView * storyImageView;

@end
