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

@interface DataMagic : NSObject

+(instancetype) Instance;

//请求图片
-(void)requestPic;

//展示结束
-(void)finishShowPage;

//是否展示结束
-(bool)isFinishShow;

//当前请求的页数
@property int loading_page;
//已经完成展示的页数
@property int finished_page;

//是否请求花瓣
@property bool isHuaban;

//通知回调
@property NSString * NOTIFY_HTTP_PIC_REQ ;
@property NSString * NOTIFY_FINISH_PIC_REQ ;
@property NSString * NOTIFY_FINISH_PIC_PARSE;

//board画板对应的信息,
@property NSMutableDictionary * Boards ;

@end
