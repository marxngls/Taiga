//
//  LoginModel.h
//  Taiga
//
//  Created by Джонни Диксон on 26.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import "JSONModel.h"

@interface LoginModel : JSONModel

@property (strong, nonatomic) NSString* login;
@property (strong, nonatomic) NSString* pass;
@property (strong, nonatomic) NSString* type;

@end
