//
//  ProjectsVC.m
//  Taiga
//
//  Created by DeveloperiOs on 13.11.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "ProjectsVC.h"
#import "APIManager.h"
#import "Masonry.h"

@interface ProjectsVC ()<APIManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSDictionary * dictionaryOfProfile;

@property (nonatomic, strong) NSString * userToken;

@property (nonatomic, strong) NSArray * arrayOfProjects;

@end

@implementation ProjectsVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
    
    [self loadProjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadProjects {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    _dictionaryOfProfile = [[NSDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"profile"]];
    
    _userToken = [_dictionaryOfProfile objectForKey:@"auth_token"];
    
    NSString *serverURL = [userDefaults objectForKey:@"serverURL"];
    
    serverURL = [serverURL stringByAppendingString:@"projects"];
    
    [[APIManager managerWithDelegate:self] getDataFromURL:serverURL withParams:nil andToken:_userToken];
}

-(void) createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0.0, 0.0, 0.0);
    
    self.tableView.delegate = self;
    
    self.tableView.allowsSelection = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);;
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayOfProjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary* project = [[NSDictionary alloc] initWithDictionary:[_arrayOfProjects objectAtIndex:indexPath.row]];
    
    cell.textLabel.text = [project objectForKey:@"name"];
    
    cell.detailTextLabel.text = [project objectForKey:@"description"];

    
    return cell;
}

#pragma mark - APIManager

-(void)response:(APIManager *)manager Answer:(id)respObject{
    if (respObject != nil) {
        
        
        NSArray *sortedArray;
        sortedArray = [respObject sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = a [@"modified_date"];
            NSDate *second = b [@"modified_date"];
            return [second compare:first];
        }];
        
        _arrayOfProjects = [[NSArray alloc] initWithArray:sortedArray];
        

        [self.tableView reloadData];
    }
}


-(void)responseError:(APIManager *)manager Error:(NSError *)error{
    
}


@end
