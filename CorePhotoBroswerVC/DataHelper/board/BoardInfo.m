//
//  BoardInfo.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/28.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "BoardInfo.h"

@implementation BoardInfo

+(BoardInfo*) initByUrl:(NSString *)url{
    BoardInfo * b = [[BoardInfo alloc ] init ] ;
    
    b.url = url;
    b.idx = [url lastPathComponent];
    b.pins = [[NSMutableArray alloc]init];
    b.max =@"999999999";
    return b;
}

+(BoardInfo*) initByInt:(NSString *)url idx:(NSString*)idx{
    BoardInfo * b = [[BoardInfo alloc ] init ] ;
    
    b.url = url;
    b.idx = idx;
    b.pins = [[NSMutableArray alloc]init];
    b.max =@"999999999";
    return b;
}

-(NSString*)getIdx{
    return _idx;
}

//根据json解析得到
-(void) addPin:(Pin*)pin{
    [_pins addObject:pin];
    //获取最后文件的max
    _max = pin.pin_id;
}
/**
 "board":{
 "board_id":297159,
 "user_id":92371,
 "title":"动物",
 "description":"",
 "category_id":"pets",
 "seq":19,
 "pin_count":732,
 "follow_count":180,
 "like_count":0,
 "created_at":1330069700,
 "updated_at":1432630812,
 "deleting":0,
 "is_private":0,
 "extra":null,
 */
@end
