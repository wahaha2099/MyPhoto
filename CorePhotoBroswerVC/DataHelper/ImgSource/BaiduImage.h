//
//  BaiduImage.h
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/2.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataMagic.h"
#import "DataHolder.h"

@interface BaiduImage : NSObject

+(instancetype) Instance;

//请求图片
-(void) requestPic:(NSString * )notify finish:(NSString*)finish_callback;

@end
