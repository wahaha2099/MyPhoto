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
@property NSString * start;//第一张图片的id,花瓣是通过id去取图片,分页的,start=lastMaxId
@property NSString * last_start;//最后一次请求回来的第一个头
@property bool hasAddBefore;//图片是否已经读取过
@property NSString * max;//最后一张图片id,分页的
@property long timestamp ; //当前这张图片时间戳
@property int page;//百度用page存页数,花瓣用start,max存
@property NSMutableArray * pins;//图片具体信息
@property int pin_idx;//最后显示的pin在pins的index下标

-(NSString*) getIdx;
+(BoardInfo*) initByUrl:(NSString *)url;
+(BoardInfo*) initByInt:(NSString *)url idx:(NSString *)idx;

//根据json解析得到
-(void) addPin:(Pin*)pin;

//上次读取过后的,记录了start和max,重新更新max,让从头再来拉取,和start比对id,如果id小于start,则忽略
-(void)resetBoard;

@end
