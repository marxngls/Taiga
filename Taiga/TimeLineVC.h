//
//  TimeLineVC.h
//  Taiga
//
//  Created by Джонни Диксон on 27.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineVC : UIViewController


@property (nonatomic, strong) UITableView * tableView;

-(void) loadData:(NSUserDefaults*) userDefaults;

@end
