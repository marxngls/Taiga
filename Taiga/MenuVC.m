//
//  MenuVC.m
//  Taiga
//
//  Created by Джонни Диксон on 30.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "MenuVC.h"
#import "Masonry.h"
#import "IssueVC.h"
#import "KanbanVC.h"
#import "DasboardVC.h"
#import "TimeLineVC.h"
#import "APIManager.h"
#import "LoginVC.h"
#import "SignInVC.h"
#import "ProjectsVC.h"

@interface MenuVC ()<UITableViewDataSource, UITableViewDelegate, APIManagerDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSDictionary * dictionaryOfProfile;

@property (nonatomic, strong) NSString * userToken;

@property (nonatomic, strong) NSArray * arrayOfProjects;

@property (nonatomic, strong) NSMutableArray * arrayOfLastProjects;

@property (nonatomic, strong) NSString * currentProjectID;

@end

@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    _dictionaryOfProfile = [[NSDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"profile"]];
    
    _userToken = [_dictionaryOfProfile objectForKey:@"auth_token"];
    
    NSString *serverURL = [userDefaults objectForKey:@"serverURL"];
    
    serverURL = [serverURL stringByAppendingString:@"projects"];
    
    [[APIManager managerWithDelegate:self] getDataFromURL:serverURL withParams:nil andToken:_userToken];
    
    [self createTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0.0, 0.0, 0.0);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
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
    
    int numberOfRows;
    
    switch (section) {
        case 0:
            numberOfRows = 4;
            break;
        case 1:
            numberOfRows = (int)_arrayOfLastProjects.count + 1;
            break;
        case 2:
            numberOfRows = 1;
        default:
            break;
    }
    
    return numberOfRows;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString * title;
    
    switch (section) {
        case 0:
            title = @"";
            break;
        case 1:
            title = @"Projects";
            break;
        default:
            title = @"";
            break;
    }
    
    return title;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *project;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    [cell prepareForReuse];
    
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Dashboard";
                    break;
                case 1:
                    cell.textLabel.text = @"TimeLine";
                    break;
                case 2:
                    cell.textLabel.text = @"Kanban";
                    break;
                case 3:
                    cell.textLabel.text = @"Team";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            
            
            if (indexPath.row == 3) {
                cell.textLabel.text= @"more";
            }
            else {
            project = [[NSDictionary alloc] initWithDictionary:[_arrayOfLastProjects objectAtIndex:indexPath.row]];

            cell.textLabel.text = [project objectForKey:@"name"];
            cell.detailTextLabel.text = [project objectForKey:@"description"];
            }
            
            if ([project objectForKey:@"id"] == _currentProjectID) {
                cell.imageView.image = [UIImage imageNamed:@"taiga-logo"];
            }
            
            
            
            
            break;
        case 2:
            
            cell.textLabel.text = @"Выйти";
            
            break;
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id VC = [DasboardVC new];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                VC = [DasboardVC new];
                break;
            case 1:
                VC = [TimeLineVC new];
                break;
            case 2:
                VC = [KanbanVC new];
                
                break;
            case 3:
                VC = [IssueVC new];
                break;
            default:
                break;
        }
        
        [_drawController setCenterViewController:VC];
        
        [_drawController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        
    }
    else if (indexPath.section == 1){
        
        if (indexPath.row == 3) {
            ProjectsVC * projectVC = [ProjectsVC new];
            [_drawController setCenterViewController:projectVC withCloseAnimation:YES completion:nil];
        }
        else {
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        
        NSString * newID = [[_arrayOfLastProjects objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        [user setObject:newID  forKey:@"currentProject"];
        
        cell.imageView.image = [UIImage imageNamed:@"taiga-logo"];
        
        for (UITableViewCell * existCell in tableView.visibleCells) {
                if (existCell != cell) {
                    existCell.imageView.image = nil;
                }
            }
        
        if ([_drawController.centerViewController isKindOfClass:[TimeLineVC class]]) {
            
            TimeLineVC * timeLineVC = (TimeLineVC*)_drawController.centerViewController;
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [timeLineVC loadData:user];

            });
   
        }
        
        [_drawController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            
        }
        
    }
    else if (indexPath.section == 2){
        
        SignInVC * signInVC = [SignInVC new];
        
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        
        [user removeObjectForKey:@"profile"];
        
        [_drawController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
            UINavigationController * signInNC = [[UINavigationController alloc] initWithRootViewController:signInVC];
           
            [_drawController presentViewController:signInNC animated:YES completion:nil];
            
        }];
                
        
    }
    
    
    
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
        
        
        _arrayOfLastProjects = [NSMutableArray new];
        
        
        for (int i = 0; i < 3; i++ ) {
            [_arrayOfLastProjects addObject:[_arrayOfProjects objectAtIndex:i]];
        }
        
        [self setCurrentProject];
        
        
        [self.tableView reloadData];
    }
}

- (void) setCurrentProject{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([user objectForKey:@"currentProject"] == nil) {
        [user setObject:[[_arrayOfLastProjects firstObject] objectForKey:@"id"] forKey:@"currentProject"] ;
    }
    
    _currentProjectID = [user objectForKey:@"currentProject"];
    
}

-(void)responseError:(APIManager *)manager Error:(NSError *)error{
    
}

@end
