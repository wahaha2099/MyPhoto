//
//  BaiduImage.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/2.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "BaiduImage.h"

@interface BaiduImage()

@property NSString * finish_notify;

@end

@implementation BaiduImage
//


NSString * baidu_board_id = @"99999999";

BaiduImage * instance;
+(instancetype) Instance{
    if( instance == nil){
        instance = [[BaiduImage alloc] init];
    }
    return instance;
}


-(void) requestPic:(NSString * )notify finish:(NSString*)finish_callback{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notify object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseBoardCallback:) name:notify object:nil];
    

    
    //根据url获取board_id,就是key
    NSNumber * key = [NSNumber numberWithInt:[baidu_board_id intValue]];
    
    //
    NSString * url = @"http://image.baidu.com/data/imgs?col=%E7%BE%8E%E5%A5%B3&tag=%E5%85%A8%E9%83%A8&sort=0&tag3=&rn=20&p=channel&from=1";
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&pn=%i", [DataMagic Instance].loading_page * 20 ] ];

    //init board
    BoardInfo * b = [[[DataMagic Instance] Boards] objectForKey:key];
    if(b == nil){
        b = [BoardInfo initByInt:url idx:baidu_board_id];
        [[[DataMagic Instance] Boards] setObject:b forKey: key];
    }
    
    NSLog(@"request %@",url);
    
    //NSString * url = [NSString stringWithFormat:@"%@?max=%@&limit=20&wfl=1",board_url,b.max];//381205601,999999999
    [[HttpHelper Instance] request:url notify:notify isJson:false];
    
    [DataMagic Instance].loading_page++;
    
    _finish_notify = finish_callback;
}
     
//处理请求返回
-(void) parseBoardCallback: (NSNotification*) aNotification{
    NSError *error;
    NSData * rsp = [aNotification object];
    
    if (rsp == nil || [rsp length] == 0 ){
        NSLog(@"no data %@" , rsp);
        
        [DataMagic Instance].loading_page--;
        //_loading_page--;
        
        //通知界面更新
        [[NSNotificationCenter defaultCenter] postNotificationName:_finish_notify object:nil userInfo:nil];
        return ;
    }
    NSDictionary * rs = [NSJSONSerialization JSONObjectWithData:rsp options:NSJSONReadingMutableLeaves error:&error];
    //NSDictionary * board = [rs objectForKey:@""];
    
    NSArray * pins = [rs objectForKey:@"imgs"];
    //NSArray * pins = [board objectForKey:@"pins"];
    
    //add pin to board
    NSMutableDictionary * Boards  = [[DataMagic Instance] Boards];
    NSNumber * key = [NSNumber numberWithInt:[baidu_board_id intValue]];
    
    for(int i =0 ; i < [pins count]-1 ; i++){
        //Pin* pin = [Pin initPin:pin_dic];
        NSDictionary * file = pins[i];
        Pin* pin = [[Pin alloc]init];
        
        pin.url320 = [file objectForKey:@"thumbLargeUrl"];//thumbLargeUrl最小,thumbLargeTnUrl适中
        pin.url658 = [file objectForKey:@"thumbLargeTnUrl"];//downloadUrl最大,原图下载，可能有100KB以上
        pin.pin_id = [file objectForKey:@"id"];
        pin.board_id = baidu_board_id;

        [[Boards objectForKey:key] addPin:pin];

    }

    //通知界面更新
    [[NSNotificationCenter defaultCenter] postNotificationName:_finish_notify object:key userInfo:nil];
}
@end
