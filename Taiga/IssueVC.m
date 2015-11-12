//
//  IssueVC.m
//  Taiga
//
//  Created by Джонни Диксон on 27.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "IssueVC.h"
#import "Masonry.h"

@interface IssueVC ()

@end

@implementation IssueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [UILabel new];
    
    label.text = @"Team Here Soon...";
    
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
