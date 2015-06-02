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
@property NSString * max;//最后一张图片id大小
@property long timestamp ; //当前这张图片时间戳
@property NSMutableArray * pins;//图片具体信息
@property int pin_idx;//最后显示的pin在pins的index下标

-(NSString*) getIdx;
+(BoardInfo*) initByUrl:(NSString *)url;
+(BoardInfo*) initByInt:(NSString *)url idx:(NSString *)idx;

//根据json解析得到
-(void) addPin:(Pin*)pin;

@end
