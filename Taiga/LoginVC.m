//
//  LoginVC.m
//  Taiga
//
//  Created by Джонни Диксон on 26.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//
#import "MenuVC.h"
#import "LoginVC.h"
#import "Masonry.h"
#import "SignInVC.h"
#import "DasboardVC.h"
#import "TabBar.h"
#import <MMDrawerController/MMDrawerController.h>

@interface LoginVC ()

@property (nonatomic, strong) UIButton * loginButton;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    }

- (void)loadWithMenu {
    
    DasboardVC* dashboard = [DasboardVC new];
    
    MenuVC * menu = [MenuVC new];
 
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:dashboard leftDrawerViewController:menu];
    
    menu.drawController = drawerController;
    
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.navigationController presentViewController:drawerController animated:NO completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([user objectForKey:@"profile"] != nil) {
        
        [self loadWithMenu];
        
        
    }
    else{
        [self createInterface];
    }

}

- (void) createInterface{
    
    [self.navigationController setNavigationBarHidden:YES];

    [self createLoginButton];

}

- (void)createLoginButton {
    
    self.loginButton = [UIButton new];
    
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    
    self.loginButton.backgroundColor = [UIColor darkGrayColor];
    
    [self.loginButton addTarget:self
                 action:@selector(loginAction)
       forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.loginButton];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height/2);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        //        make.bottom.equalTo(self.view.mas_bottom).with.offset(self.view.bounds.size.height/2-50);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
    }];
}

- (void) loginAction{
    
    SignInVC * signInVC = [SignInVC new];
    
    [self.navigationController pushViewController:signInVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
