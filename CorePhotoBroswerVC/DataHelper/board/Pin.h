//
//  Pin.h
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/28.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Pin : NSObject

@property NSString * created_at;
@property NSString * raw_text;
@property NSString * type;
@property NSString * key;
@property NSString * pin_id;
@property NSString * board_id;

//其他图片的地址
@property NSString * url320;
@property NSString * url658;

+(Pin*) initPin:(NSDictionary*)json;

//返回图片地址

-(NSString * ) url_320;
-(NSString * ) url_658;
//[NSString stringWithFormat:@"http://img.hb.aicdn.com/%@_fw320",pin.key]

//本地图片对象
@property UIImage * image;

//远程图片默认
@property UIImage * placehold;

//是否默认的那9张本地图片
@property bool is_local;
//当前的pin对应的index
@property NSUInteger idx;
@end
