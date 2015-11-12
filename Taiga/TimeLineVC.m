//
//  TimeLineVC.m
//  Taiga
//
//  Created by Джонни Диксон on 27.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "TimeLineVC.h"
#import "Masonry.h"
#import "APIManager.h"
#import "TimelineCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TimeLineVC ()<APIManagerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL isHide;
}

@property (nonatomic, strong) NSDictionary * profileDictionary;

@property (nonatomic, strong) NSString * userToken;

@property (nonatomic, strong) NSDictionary *projectDesc;

@property (nonatomic, strong) NSString * userID;

@property (nonatomic, strong) NSMutableArray * timelineArray;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIRefreshControl * refreshControl;

@property (nonatomic, strong) NSUserDefaults * userDefaults;

@end

@implementation TimeLineVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeNavbarTransparent];
    
    _timelineArray = [NSMutableArray new];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    _profileDictionary = [[NSDictionary alloc] initWithDictionary:[_userDefaults objectForKey:@"profile"]];
    
    _userToken = [_profileDictionary objectForKey:@"auth_token"];
    
    _userID = [_profileDictionary objectForKey:@"id"];
    
    [self setPullToRefresh];
    
    [self loadData:_userDefaults];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPullToRefresh {
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
}

-(void) loadData:(NSUserDefaults*) userDefaults{
    
    NSString *currentProjectID = [userDefaults objectForKey:@"currentProject"];
    
    NSString* serverURL = [userDefaults objectForKey:@"serverURL"];
    
    serverURL = [serverURL stringByAppendingString:@"timeline/project/"];
    
    NSString *timeLineURL = [NSString stringWithFormat:@"%@%@", serverURL, currentProjectID];
    
    [[APIManager managerWithDelegate:self] getDataFromURL:timeLineURL withParams:nil andToken:_userToken];
}

- (void)makeNavbarTransparent {
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage new]
     forBarMetrics:UIBarMetricsDefault];
    
}

-(void) pullToRefresh{
    
    [self.refreshControl beginRefreshing];
    
    [self loadData:_userDefaults];
    
    [self.refreshControl endRefreshing];
}


-(void) createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0.0, 0.0, 0.0);
    
    self.tableView.delegate = self;
    
    self.tableView.allowsSelection = NO;
    
    [self.tableView registerClass:[TimelineCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);;
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
}

#pragma mark - UITableViewDataSource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView;
    
    if (section == 0) {
        
        headerView = [[UIView alloc] initWithFrame:tableView.tableHeaderView.frame];
        
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel * nameLabel = [UILabel new];
        
        nameLabel.font = [UIFont systemFontOfSize:25];
        
        nameLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(97/255.0) blue:(0/255.0) alpha:1];
        
        nameLabel.textAlignment = NSTextAlignmentLeft;
        
        nameLabel.text = [_projectDesc objectForKey:@"name"];
        
        nameLabel.text = nameLabel.text.uppercaseString;
        
        [headerView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(15);
            make.bottom.equalTo(headerView.mas_centerY);
        }];
        
        UILabel *subNameLabel = [UILabel new];
        
        subNameLabel.font = [UIFont systemFontOfSize:13];
        
        subNameLabel.textColor = [UIColor blackColor];
        
        subNameLabel.textAlignment = NSTextAlignmentLeft;
        
        subNameLabel.text = [_projectDesc objectForKey:@"description"];
        
        [headerView addSubview:subNameLabel];

        [subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(15);
            make.top.equalTo(nameLabel.mas_bottom).offset(8);
//            make.bottom.equalTo(headerView.mas_centerY);
        }];
    }
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return 125;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _timelineArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimelineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSString * imgUrl = [[_timelineArray objectAtIndex:indexPath.row] objectForKey:@"imgUrl"];
    
    [cell.userPhoto sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cell.textEventLabel.text = [[_timelineArray objectAtIndex:indexPath.row] objectForKey:@"text"];
    
    cell.pubDateLabel.text = [[_timelineArray objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber * height = [[_timelineArray objectAtIndex:indexPath.row] objectForKey:@"height"];
    
    if (height.floatValue > 50) {
        return height.floatValue + 10;
    }
    else
        return 60;
    
}



#pragma mark - APIManager

-(void)response:(APIManager *)manager Answer:(id)respObject{
    
    if (_timelineArray.count > 0) {
        [_timelineArray removeAllObjects];
    }
    
            NSArray *sortedArray;
            sortedArray = [respObject sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *first = a [@"created"];
                NSDate *second = b [@"created"];
                return [second compare:first];
            }];
            
            [self getDataFromArray:sortedArray];
    
            [_tableView reloadData];
}

-(NSString*) setActionNameFrom:(NSString*) string{
    
    if ([string containsString:@"task"]) {
        if ([string containsString:@"change"]) {
            string = @"изменил аттрибут";
        }
        else if ([string containsString:@"create"]){
            string = @"создал задачу";
            
        }
    }
    else if ([string containsString:@"userstory"]){
        if ([string containsString:@"change"]) {
            string = @"обновил аттрибут";
            
        }
        else if ([string containsString:@"create"]){
            string = @"создал новую ПИ";
        }
    }
    
    return string;
}

-(void) getDataFromArray:(NSArray*) array{
    
    _projectDesc = [[NSDictionary alloc] initWithDictionary:[[[array firstObject] objectForKey:@"data"] objectForKey:@"project"]];
    
    for (NSDictionary * timelineObject in array) {
        
        NSString * imgUrl = [[[timelineObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"photo"];
        
        NSString * userName = [[[timelineObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"name"];
        
        NSString * actionName = [timelineObject objectForKey:@"event_type"];
        
        NSString * actionObjectName;
        
        NSString * changedAtt;
        
        if ([[[timelineObject objectForKey:@"data"] objectForKey:@"values_diff"] objectForKey:@"subject"]) {
            changedAtt = @"\"Тема\"";
        }
        else if ([[[timelineObject objectForKey:@"data"] objectForKey:@"values_diff"] objectForKey:@"status"]){
            changedAtt = @"\"Статус\"";
        }
        else if ([[[timelineObject objectForKey:@"data"] objectForKey:@"values_diff"] objectForKey:@"assigned_to"]){
            changedAtt = @"\"Назначено\"";
        }
        else if ([[[timelineObject objectForKey:@"data"] objectForKey:@"values_diff"] objectForKey:@"description_diff"]){
                changedAtt = @"\"Описание\"";
        }else{
            changedAtt = @"";
        }

        
        NSString * whereObject;
        
        NSString * eventNumber;
        
        actionName = [self setActionNameFrom:actionName];
        
        if ([[timelineObject objectForKey:@"data"] objectForKey:@"userstory"]) {
            actionObjectName = [[[timelineObject objectForKey:@"data"] objectForKey:@"userstory"] objectForKey:@"subject"];
            eventNumber = [[[timelineObject objectForKey:@"data"] objectForKey:@"userstory"] objectForKey:@"ref"];
            
            eventNumber = [NSString stringWithFormat:@"#%@",eventNumber];

        }
        else if ([[timelineObject objectForKey:@"data"] objectForKey:@"task"]){
            actionObjectName = [[[timelineObject objectForKey:@"data"] objectForKey:@"task"] objectForKey:@"subject"];
            eventNumber = [[[timelineObject objectForKey:@"data"] objectForKey:@"task"] objectForKey:@"ref"];
            eventNumber = [NSString stringWithFormat:@"#%@",eventNumber];
        }
        
        if ([[timelineObject objectForKey:@"data"] objectForKey:@"project"] &&
            ![_userID isEqual:[[[timelineObject objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"id"]]) {
            whereObject = [[[timelineObject objectForKey:@"data"] objectForKey:@"project"] objectForKey:@"name"];
            whereObject = [NSString stringWithFormat:@"in %@",whereObject];
        }
        
        NSString *pubDate = [timelineObject objectForKey:@"created"];
        
        pubDate = [pubDate substringToIndex:10];
        
        NSString * text;
        
        if (whereObject != nil) {
            text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",userName,actionName,changedAtt,eventNumber,actionObjectName, whereObject];
        }
        else{
            text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",userName,actionName,changedAtt,eventNumber,actionObjectName];
        }
        
        CGRect cellRect = [text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 125, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
        
        NSNumber * cellHeight = [[NSNumber alloc] initWithFloat:cellRect.size.height];
        
        NSMutableDictionary * dataObject = [NSMutableDictionary new];
        
        [dataObject setValue:imgUrl forKey:@"imgUrl"];
        [dataObject setValue:cellHeight forKey:@"height"];
        [dataObject setValue:text forKey:@"text"];
        [dataObject setValue:pubDate forKey:@"pubDate"];

        
        [_timelineArray addObject:dataObject];
    }
}

-(void)responseError:(APIManager *)manager Error:(NSError *)error{
    
}
@end
