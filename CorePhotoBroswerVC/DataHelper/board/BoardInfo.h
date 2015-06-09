//
//  BoardInfo.h
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/28.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pin.h"

@interface BoardInfo : NSObject

@property NSString * idx;//主键id
@property NSString * url;//board url
@property int total;//总共多少张
@property int magic_type;//1=花瓣 , 2=百度
@property NSString * start;//第一张图片的id,花瓣是通过id去取图片,分页的
@property NSString * max;//最后一张图片id,分页的
@property long timestamp ; //当前这张图片时间戳
@property NSMutableArray * pins;//图片具体信息
@property int pin_idx;//最后显示的pin在pins的index下标

-(NSString*) getIdx;
+(BoardInfo*) initByUrl:(NSString *)url;
+(BoardInfo*) initByInt:(NSString *)url idx:(NSString *)idx;

//根据json解析得到
-(void) addPin:(Pin*)pin;

@end
