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

//保存Board信息
-(void) saveBoard:(BoardInfo*) board;

//读取board分页信息
-(void) loadBoard:(BoardInfo*)b;

@end
