//
//  HuabanImageUrl.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/7/11.
//
//

#import "HuabanImageUrl.h"

@implementation HuabanImageUrl

//获取url地址
+(NSArray * ) getFollowsUrl:(int)type{
    switch (type) {
        case 0:
            return [self getDogsUrl];
            break;
            
        default:
            break;
    }
    return nil;
}

//获取狗狗的地址
+(NSArray * ) getDogsUrl{
    NSMutableArray * b = [[NSMutableArray alloc]init];
    [b addObject:@"http://huaban.com/boards/17970755"];
    
    [b addObject:@"http://huaban.com/boards/18310689"];
    [b addObject:@"http://huaban.com/boards/18031874"];
    [b addObject:@"http://huaban.com/boards/3868349"];
    [b addObject:@"http://huaban.com/boards/16004129"];
    return b;
}

//获取植物的地址
+(NSArray * ) getFlowerUrl{
    NSMutableArray * b = [[NSMutableArray alloc]init];
    [b addObject:@"http://huaban.com/boards/2059352"];
    [b addObject:@"http://huaban.com/boards/19912795/"];
    [b addObject:@"http://huaban.com/boards/14183359/"];
    [b addObject:@"http://huaban.com/boards/13518603/"];
    [b addObject:@"http://huaban.com/boards/1955721/"];
    [b addObject:@"http://huaban.com/boards/1820003//"];
    return b;
}

//获取座驾的地址
+(NSArray * ) getCarUrl{
    NSMutableArray * b = [[NSMutableArray alloc]init];
    [b addObject:@"http://huaban.com/boards/19611747/"];
    [b addObject:@"http://huaban.com/boards/16408142/"];
    [b addObject:@"http://huaban.com/boards/16047656/"];
    [b addObject:@"http://huaban.com/boards/2092705/"];
    return b;
}


@end
