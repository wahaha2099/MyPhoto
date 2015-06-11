//
//  DataHolder.h
//  Kingjoy
//
//  Created by Apple on 15/4/28.
//  Copyright (c) 2015年 Kingjoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardInfo.h"

@interface DataHolder : NSObject

+ (DataHolder *)sharedInstance;

@property (assign) int level;
@property (assign) int score;

//boards的信息
@property NSMutableDictionary* boards;

#pragma mark ------------save board---------
//保存Board信息
-(void) saveBoard:(BoardInfo*) board;

//读取board分页信息
-(void) loadBoard:(BoardInfo*)b;
#pragma mark ------------save board end---------

#pragma mark ------------save page info ---------
//保存当前请求到哪个board
-(void) saveBoardIndex:(int )index;

//获取当前请求的board数
-(int) getBoardsIndex;
#pragma mark ------------save page info end---------
@end
