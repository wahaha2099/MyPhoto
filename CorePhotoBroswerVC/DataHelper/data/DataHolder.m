//
//  DataHolder.m
//  Kingjoy
//
//  Created by Apple on 15/4/28.
//  Copyright (c) 2015年 Kingjoy. All rights reserved.
//

#import "DataHolder.h"


NSString * const keyAccount = @"accounts";

@implementation DataHolder

- (id) init
{
    self = [super init];
    if (self)
    {
        //_level = 0;
        //_score = 0;
    }
    return self;
}

+ (DataHolder *)sharedInstance
{
    static DataHolder *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^
                  {
                      _sharedInstance = [[self alloc] init];
                  });
    
    return _sharedInstance;
}

//保存Board信息
-(void) saveBoard:(BoardInfo*) board{
    //1.创建NSArray存储
    
    if(_boards == nil){
        _boards = [[NSMutableDictionary alloc]init];
        
        NSDictionary * dic3 = [[NSUserDefaults standardUserDefaults] objectForKey:keyAccount];
        [_boards addEntriesFromDictionary:dic3];
    }
    
    //2.添加进去
    NSDictionary* exist = [_boards objectForKey:[board idx]];

    if( exist != nil ){
        //change to mutable dictionary
        NSMutableDictionary* exist2 = [[NSMutableDictionary alloc]init];
        [exist2 addEntriesFromDictionary:exist];
        exist = exist2;
        
        [exist setValue:board.max forKey:@"max"];// board.max;
        [exist setValue:[NSString stringWithFormat:@"%i",board.page ] forKey:@"page"];
        [exist setValue:board.last_start forKey:@"last_start"];
        
    }else{  //存储部分数据
        exist = [[NSMutableDictionary alloc]init];
        [exist setValue:board.max forKey:@"max"];// board.max;
        [exist setValue:board.start forKey:@"start"];
        [exist setValue:board.last_start forKey:@"last_start"];
        
        [exist setValue:board.idx forKey:@"idx"];
        [exist setValue:board.url forKey:@"url"];
        [exist setValue:[NSString stringWithFormat:@"%i",board.page ] forKey:@"page"];
        
    }
    //NSLog(@" save b %@ start=%@ max=%@ page=%i" , board.idx , board.start , board.max , board.page);

    //3.本地存储
    [_boards setValue:exist forKey:[board idx]];//add to array

    [[NSUserDefaults standardUserDefaults] setObject:_boards forKey:keyAccount];//save
}


//读取board分页信息
-(void) loadBoard:(BoardInfo*)b
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:keyAccount])
    {
        NSDictionary * acc = [[NSUserDefaults standardUserDefaults] objectForKey:keyAccount];

        NSDictionary *e = [acc objectForKey:b.idx];
        if(e!=nil){
            b.start = [e objectForKey:@"start"];
            b.last_start = [e objectForKey:@"last_start"];
            b.max = [e objectForKey:@"max"];
            b.page = [[e objectForKey:@"page"] intValue];
        }
        NSLog(@" load b %@ start=%@ max=%@ page=%i" , b.idx , b.start , b.max , b.page);
    }
}


@end
