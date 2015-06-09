//
//  DataMagic.h
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/26.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardInfo.h"
#import "HttpHelper.h"
#import "DataMagic.h"
#import "DataHolder.h"

@interface HuabanImage : NSObject

+(instancetype) Instance;

//请求图片
-(void) requestPic:(NSString * )notify finish:(NSString*)finish_callback;

//解析关注的人
-(void) parseFollow;




@end
