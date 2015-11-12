//
//  SignInVC.m
//  Taiga
//
//  Created by Джонни Диксон on 26.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "SignInVC.h"
#import "Masonry.h"
#import "APIManager.h"
#import "DasboardVC.h"
#import "TabBar.h"
#import "TimeLineVC.h"
#import "KanbanVC.h"
#import "IssueVC.h"
#import "MenuVC.h"
#import <MMDrawerController/MMDrawerController.h>


#define DEFAULT_URL @"http://taiga.vestnikburi.com/api/v1/auth"

@interface SignInVC ()<UITextFieldDelegate, APIManagerDelegate>

@property (nonatomic, strong) UIButton * loginButton;

@property (nonatomic, strong) NSString * login;

@property (nonatomic, strong) NSString * pass;

@property (nonatomic, strong) NSString * type;

@property (nonatomic, strong) NSString * server;

@property (nonatomic, strong) UITextField * loginTF;

@property (nonatomic, strong) UITextField * passTF;

@property (nonatomic, strong) UITextField * serverTF;

@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createInterface];
    
}

- (void) createInterface{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createLoginButton];
    
    [self createServerTextField];
    
    [self createLoginTextField];
    
    [self createPassTextField];
    
}

- (void) createLoginTextField{
    UITextField * loginTF = [UITextField new];
    
    loginTF.borderStyle = UITextBorderStyleRoundedRect;
    
    loginTF.delegate = self;
    
    loginTF.tag = 0;
    
    [self.view addSubview:loginTF];
    
    [loginTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loginButton.mas_top).with.offset(-85);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
    }];
}

- (void) createPassTextField{
    UITextField * passTF = [UITextField new];
    
    passTF.delegate = self;
    
    passTF.tag = 1;
    
    passTF.borderStyle = UITextBorderStyleRoundedRect;
    
    passTF.placeholder = @"Password(case sensitive)";
    
    passTF.secureTextEntry = YES;
    
    [self.view addSubview:passTF];
    
    [passTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_top).with.offset(-80);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
    }];
}

- (void)createServerTextField {
    UITextField * serverTF = [UITextField new];
    
    serverTF.borderStyle = UITextBorderStyleRoundedRect;
    
    serverTF.delegate = self;
    
    serverTF.tag = 2;
    
    serverTF.text = self.server = DEFAULT_URL;
    
    [self.view addSubview:serverTF];
    
    [serverTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_top).with.offset(-45);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        //        make.bottom.equalTo(self.view.mas_bottom).with.offset(self.view.frame.size.height-65);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
    }];
}

- (void)createLoginButton {
    
    self.loginButton = [UIButton new];
    
    [self.loginButton setTitle:@"SIGN IN" forState:UIControlStateNormal];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showError {
    UIAlertController * emptyAlert =   [UIAlertController
                                        alertControllerWithTitle:@"Error"
                                        message:@"Message"
                                        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel your yes please button action here
                                   [emptyAlert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    [emptyAlert addAction:okButton];
    
    [self.navigationController presentViewController:emptyAlert animated:YES completion:nil];
}

- (void)setConnection {
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:self.login,@"username",
                             self.pass,@"password",
                             @"normal",@"type", nil];
    
    [[APIManager managerWithDelegate:self] postDataFromURL:self.server withParams:params];
}

- (void) loginAction{
    [self.view endEditing:YES];
    
    if (self.login == nil || self.pass == nil || self.server == nil) {
        [self showError];
    }
    else{
        
        [self setConnection];
    }
}

#pragma mark - UITextFieldDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 0:
            self.login = textField.text;
            break;
        case 1:
            self.pass = textField.text;
            
            break;
        case 2:
            self.server = textField.text;
            
            break;
            
        default:
            break;
    }
    
    [self resignFirstResponder];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            self.login = textField.text;
            break;
        case 1:
            self.pass = textField.text;
            
            break;
        case 2:
            self.server = textField.text;
            
            break;
            
        default:
            break;
    }
    
    [self resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            self.login = textField.text;
            break;
        case 1:
            self.pass = textField.text;
            
            break;
        case 2:
            self.server = textField.text;
            
            break;
            
        default:
            break;
    }
    
    [self resignFirstResponder];
    return YES;
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

#pragma mark - APIManagerDelegate

- (void) response: (APIManager* ) manager Answer:(id) respObject{
        
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    [user setObject:respObject forKey:@"profile"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadWithMenu];
    });
    
}
- (void) responseError: (APIManager* ) manager Error:(NSError*) error{
    
}

@end
