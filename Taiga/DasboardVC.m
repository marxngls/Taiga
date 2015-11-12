//
//  DasboardVC.m
//  Taiga
//
//  Created by Джонни Диксон on 26.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "DasboardVC.h"
#import "APIManager.h"
#import "Masonry.h"
#import "DashboardCell.h"
#import "BlurImage.h"
#import "TimeLineVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DasboardVC ()<APIManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString * userToken;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * arrayOfUserStories;

@property (nonatomic, strong) NSArray * arrayOfProjects;

@property (nonatomic, strong) NSMutableArray * arrayOfWatch;

@property (nonatomic, strong) NSDictionary * dictionaryOfProfile;

@property (nonatomic, strong) UIRefreshControl * refreshControl;


@end

@implementation DasboardVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    _dictionaryOfProfile = [[NSDictionary alloc] initWithDictionary:[user objectForKey:@"profile"]];
    
    _userToken = [_dictionaryOfProfile objectForKey:@"auth_token"];
    
    [self createTableView];
    
    [self makeNavbarTransparent];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
    
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loadData{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    NSString* serverURL = [user objectForKey:@"serverURL"];
    
    NSString* projectsURL = [serverURL stringByAppendingString:@"projects"];
    
    NSString* userStoriesURL = [serverURL stringByAppendingString:@"userstories"];
    
    [[APIManager managerWithDelegate:self] getDataFromURL:projectsURL withParams:nil andToken:_userToken];
    
    [[APIManager managerWithDelegate:self] getDataFromURL:userStoriesURL withParams:nil andToken:_userToken];
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
    
    [self loadData];
    
    [self.refreshControl endRefreshing];
}

-(void) createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0.0, 0.0, 0.0);
    
    [self.tableView registerClass:[DashboardCell class] forCellReuseIdentifier:@"Cell"];
    
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
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger numberOfRows;
    
    switch (section) {
        case 0:
            numberOfRows = 0;
            break;
        case 1:
            numberOfRows = self.arrayOfUserStories.count;
            break;
        case 2:
            numberOfRows = self.arrayOfWatch.count;
            break;
        default:
            break;
    }
    
    return numberOfRows;
}

- (UIImageView *)setImagesInHeader:(UIImageView *)imgBlur {
    UIImageView* imgPhoto = [UIImageView new];
    
    imgPhoto.layer.cornerRadius = 25;
    
    imgPhoto.clipsToBounds = YES;
    
    imgBlur = [[UIImageView alloc] initWithFrame:_tableView.tableHeaderView.frame];
    
    [imgBlur addSubview:imgPhoto];
    
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgBlur.mas_centerY);
        make.centerX.equalTo(imgBlur.mas_centerX);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    NSString * urlPhoto = [_dictionaryOfProfile objectForKey:@"photo"];
    
        if ([[urlPhoto substringToIndex:3] isEqualToString:@"//"]) {
            urlPhoto = [urlPhoto substringFromIndex:2];
            urlPhoto = [NSString stringWithFormat:@"http://%@",urlPhoto];
        }
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:urlPhoto]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    imgBlur.image = [BlurImage imageByApplyingBlurToImage:image withRadius:30 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
                                    imgPhoto.image = image;
                                }
                            }];
        
    
    
    return imgBlur;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIImageView * imgBlur;
    
    if (section == 0) {
        
        
        imgBlur = [self setImagesInHeader:imgBlur];
        
        UILabel * nameLabel = [UILabel new];
        
        nameLabel.textColor = [UIColor whiteColor];
        
        nameLabel.textAlignment = NSTextAlignmentCenter;
        
        nameLabel.text = [_dictionaryOfProfile objectForKey:@"full_name"];
        
        [imgBlur addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imgBlur.mas_centerX);
            make.bottom.equalTo(imgBlur.mas_bottom).offset(-8);
            make.left.equalTo(imgBlur.mas_left).offset(15);
        }];
        
    }
    
    return imgBlur;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DashboardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            [self workOnCell:cell ForIndexPAth:indexPath withDataArray:self.arrayOfUserStories];
            break;
        case 2:
            [self workOnCell:cell ForIndexPAth:indexPath withDataArray:self.arrayOfWatch];
            break;
        default:
            break;
    }

    return cell;
}

- (void)workOnCell:(DashboardCell *)cell ForIndexPAth:(NSIndexPath*) indexPath withDataArray:(NSArray*) array{
    NSString * projectName;
    
    NSNumber * projectID = [[array objectAtIndex:indexPath.row] objectForKey:@"project"];
    
    for (NSDictionary * project in _arrayOfProjects) {
        
        NSNumber * ownProjectID = [project objectForKey:@"id"];
        
        if (ownProjectID.integerValue == projectID.integerValue) {
            projectName = [project objectForKey:@"name"];
        }
    }
    if (![[[array objectAtIndex:indexPath.row] objectForKey:@"assigned_to_extra_info"] isKindOfClass:[NSNull class]]) {
        NSString * urlPhoto = [[[array objectAtIndex:indexPath.row] objectForKey:@"assigned_to_extra_info"] objectForKey:@"photo"];
        
        if ([[urlPhoto substringToIndex:3] isEqualToString:@"//"]) {
            urlPhoto = [urlPhoto substringFromIndex:2];
            urlPhoto = [NSString stringWithFormat:@"http://%@",urlPhoto];
        }
        
        
        [cell.storyImageView sd_setImageWithURL:[NSURL URLWithString:urlPhoto]
                               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    
    cell.projectName.text = projectName;
    
    if ([[array objectAtIndex:indexPath.row] objectForKey:@"generated_from_issue"]) {
        cell.storyType.text = @"User Story";
    }
    
    cell.storyStatus.text = [[[array objectAtIndex:indexPath.row] objectForKey:@"status_extra_info"] objectForKey:@"name"];
    
    cell.storyNumber.text = [NSString stringWithFormat:@"#%@",[[array objectAtIndex:indexPath.row] objectForKey:@"ref"]];
    
    cell.storyName.text = [[array objectAtIndex:indexPath.row] objectForKey:@"subject"];
}

#pragma mark - UITableViewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString * headerTitle;
    
    switch (section) {
        case 0:
            break;
        case 1:
            headerTitle = @"Работает над";
            break;
        case 2:
            headerTitle = @"Отслеживаемые";
            break;
        default:
            break;
    }
    
    return headerTitle;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 125;
    }
    else{
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - APIManagerDelegate

- (void) response: (APIManager* ) manager Answer:(id) respObject{
    
    if (self.arrayOfWatch.count > 0) {
        [_arrayOfWatch removeAllObjects];
    }
    
    if ([respObject isKindOfClass:[NSArray class]]) {
        
        if ([[respObject firstObject] objectForKey:@"creation_template"]) {
            
            self.arrayOfProjects = [[NSArray alloc] initWithArray:respObject];
        }
        else{
            self.arrayOfUserStories = [[NSMutableArray alloc] initWithArray:respObject];
            
            for (NSDictionary * object in self.arrayOfUserStories) {
                if ([[object objectForKey:@"watchers"] count] != 0) {
                    if (self.arrayOfWatch == nil) {
                        self.arrayOfWatch = [NSMutableArray new];
                    }
    
                    [self.arrayOfWatch addObject:object];
                }
            }

        }
        
    }
    
    if (_arrayOfProjects.count != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
    }
   
}
- (void) responseError: (APIManager* ) manager Error:(NSError*) error{
    NSLog(@"%@",error);
}




@end
