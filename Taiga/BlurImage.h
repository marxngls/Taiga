//
//  BlurImage.h
//  Taiga
//
//  Created by Джонни Диксон on 27.10.15.
//  Copyright © 2015 Lavskiy Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BlurImage : NSObject

+ (UIImage*)imageByApplyingBlurToImage:(UIImage*)inputImage withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
