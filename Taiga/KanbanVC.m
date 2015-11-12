//
//  KanbanVC.m
//  Taiga
//
//  Created by Джонни Диксон on 27.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "KanbanVC.h"
#import "Masonry.h"
#import "KanbanCell.h"
#import "APIManager.h"
#import <SDWebImage/UIImageView+WebCache.h>


#define API_URL           @"http://taiga.vestnikburi.com/api/v1/userstories"


@interface KanbanVC ()<UITableViewDataSource, UITableViewDelegate, APIManagerDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * arrayOfNew;

@property (nonatomic, strong) NSMutableArray * arrayOfReady;

@property (nonatomic, strong) NSMutableArray * arrayOfProgress;

@property (nonatomic, strong) NSMutableArray * arrayOfReadyFor;

@property (nonatomic, strong) NSMutableArray * arrayOfDone;

@property (nonatomic, strong) NSMutableArray * arrayOfArchived;

@property (nonatomic, strong) NSDictionary * dictionaryOfProfile;

@property (nonatomic, strong) NSString * userToken;


@end

@implementation KanbanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    _dictionaryOfProfile = [[NSDictionary alloc] initWithDictionary:[user objectForKey:@"profile"]];
    
    _userToken = [_dictionaryOfProfile objectForKey:@"auth_token"];
    
    [[APIManager managerWithDelegate:self] getDataFromURL:API_URL withParams:nil andToken:_userToken];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0.0, 0.0, 0.0);
    
    [self.tableView registerClass:[KanbanCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRows;
    
    switch (section) {
        case 0:
            numberOfRows = 0;
            break;
        case 1:
            numberOfRows = _arrayOfNew.count;
            break;
        case 2:
            numberOfRows = _arrayOfReady.count;
            break;
        case 3:
            numberOfRows = _arrayOfProgress.count;
            break;
        case 4:
            numberOfRows = _arrayOfReadyFor.count;
            break;
        case 5:
            numberOfRows = _arrayOfDone.count;
            break;
        case 6:
            numberOfRows = _arrayOfArchived.count;
            break;
        default:
            break;
    }
    
    return numberOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KanbanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            [self workOnCell:cell ForIndexPAth:indexPath withDataArray:self.arrayOfNew];
            break;
        case 2:
            [self workOnCell:cell ForIndexPAth:indexPath withDataArray:self.arrayOfReady];
            break;
        case 3:
            [self workOnCell:cell ForIndexPAth:indexPath withDataArray:self.arrayOfProgress];
            break;
        case 4:
            [self workOnCell:cell ForIndexPAth:indexPath withDataArray:self.arrayOfReadyFor];
            break;
        case 5:
            [self workOnCell:cell ForIndexPAth:indexPath withDataArray:self.arrayOfDone];
            break;
        case 6:
            [self workOnCell:cell ForIndexPAth:indexPath withDataArray:self.arrayOfArchived];
            break;
        default:
            break;
    }
    
    return cell;

}

- (void)workOnCell:(KanbanCell *)cell ForIndexPAth:(NSIndexPath*) indexPath withDataArray:(NSArray*) array{
    
    if (![[[array objectAtIndex:indexPath.row] objectForKey:@"assigned_to_extra_info"] isKindOfClass:[NSNull class]]) {
        NSString * urlPhoto = [[[array objectAtIndex:indexPath.row] objectForKey:@"assigned_to_extra_info"] objectForKey:@"photo"];
        
        if ([[urlPhoto substringToIndex:3] isEqualToString:@"//"]) {
            urlPhoto = [urlPhoto substringFromIndex:2];
            urlPhoto = [NSString stringWithFormat:@"http://%@",urlPhoto];
        }
        
        
        [cell.storyImageView sd_setImageWithURL:[NSURL URLWithString:urlPhoto]
                               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    cell.storyNumber.text = [NSString stringWithFormat:@"#%@",[[array objectAtIndex:indexPath.row] objectForKey:@"ref"]];
    
    cell.storyName.text = [[array objectAtIndex:indexPath.row] objectForKey:@"subject"];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString * headerTitle;
    
    switch (section) {
        case 0:
            break;
        case 1:
            headerTitle = @"NEW";
            break;
        case 2:
            headerTitle = @"READY";
            break;
        case 3:
            headerTitle = @"IN PROGRESS";
            break;
        case 4:
            headerTitle = @"READY FOR TEST";
            break;
        case 5:
            headerTitle = @"DONE";
            break;
        case 6:
            headerTitle = @"ARCHIEVED";
            break;
        default:
            break;
    }
    
    return headerTitle;
}

#pragma mark - APIManagerDelegate

- (void) response: (APIManager* ) manager Answer:(id) respObject{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *currentProjectID = [userDefaults objectForKey:@"currentProject"];
    
    for (NSDictionary * object in respObject) {
        
        NSNumber *projectID = [object objectForKey:@"project"];
        
        if (currentProjectID == projectID)
        {
            NSString * status = [[object objectForKey:@"status_extra_info"] objectForKey:@"name"];
            
            if ([status isEqualToString:@"Ready for test"]) {
                if (_arrayOfReadyFor == nil) {
                    _arrayOfReadyFor = [NSMutableArray new];
                }
                [_arrayOfReadyFor addObject:object];
            }
            else if ([status isEqualToString:@"Ready"]){
                if (_arrayOfReady == nil) {
                    _arrayOfReady = [NSMutableArray new];
                }
                [_arrayOfReady addObject:object];
            }
            else if ([status isEqualToString:@"In progress"]){
                if (_arrayOfProgress == nil) {
                    _arrayOfProgress = [NSMutableArray new];
                }
                [_arrayOfProgress addObject:object];
            }
            else if ([status isEqualToString:@"Done"]){
                if (_arrayOfDone == nil) {
                    _arrayOfDone = [NSMutableArray new];
                }
                [_arrayOfDone addObject:object];
            }
            else if ([status isEqualToString:@"Archived"]){
                if (_arrayOfArchived == nil) {
                    _arrayOfArchived = [NSMutableArray new];
                }
                [_arrayOfArchived addObject:object];
            }

        }
        
    }
    
    [_tableView reloadData];
}
- (void) responseError: (APIManager* ) manager Error:(NSError*) error{
    NSLog(@"%@",error);
}


@end
