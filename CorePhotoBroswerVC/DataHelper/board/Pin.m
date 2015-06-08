//
//  Pin.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/28.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Pin.h"


@implementation Pin

+(Pin*) initPin:(NSDictionary*)json{
    Pin* pin = [[Pin alloc]init];
    
    NSDictionary * file = [json objectForKey:@"file"];

    pin.key = [file objectForKey:@"key"];
    pin.type = [file objectForKey:@"type"];//image/gif;
    //pin.created_at = [json objectForKey:@"created_at"];
    pin.pin_id = [json objectForKey:@"pin_id"];
    //pin.raw_text = [json objectForKey:@"raw_text"];
    pin.board_id = [json objectForKey:@"board_id"];
    
    return pin;
}

//返回图片地址
-(NSString * ) url_320{
    if(_url320 != nil)
        return _url320;
    
    return [NSString stringWithFormat:@"http://img.hb.aicdn.com/%@_fw320",_key];
};
-(NSString * ) url_658{
    if(_url658 != nil )
        return _url658;
    
    return [NSString stringWithFormat:@"http://img.hb.aicdn.com/%@_fw658",_key];
};

//读取本地图片
-(UIImage*) loadLocalImage{
    UIImage *image=[UIImage imageWithContentsOfFile:_url658];
    return image;
}
//读取本地图片,缩小一倍
-(UIImage*) loadSmallImage{
    UIImage *image=[UIImage imageWithContentsOfFile:_url658];
    
    int width = [[UIScreen mainScreen] bounds].size.width;
    int height = [[UIScreen mainScreen] bounds].size.height;
    //NSLog(@"w = %i" , (int)image.size.width );
    //NSLog(@"h = %i" , (int)image.size.height );
    
    float rate =   width / 3 / image.size.width;//计算缩放比例 , 界面宽度 / 3张图片 /图片大小
    float rateHei =  height / 3 / image.size.height;
    
    float scale = rate < rateHei ? rate : rateHei;
    NSString* formattedNumber = [NSString stringWithFormat:@"%.1f", scale];
    float floatTwoDecimalDigits = atof([formattedNumber UTF8String]);
    //NSLog(@" scale %@" , formattedNumber);
    UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:floatTwoDecimalDigits orientation:image.imageOrientation];
    return scaledImage;
}
/*
 pin页面对象:
 pin{
 "pin_id":389245094,
 "user_id":92371,
 "board_id":297159,
 "file_id":48678853,
 "file":{
 "farm":"farm1",
 "bucket":"hbimg",
 "key":"0289ff68ba818c0bb9e3f9ef2973c214ed15eb1c1e4228-kzzPlb",
 "type":"image/gif",
 "width":400,
 "height":267,
 "frames":50
 },
 "media_type":0,
 "source":"sakairyo.tumblr.com",
 "link":"http://sakairyo.tumblr.com/post/119420817060/gif-tv-other-funny-gifs",
 "raw_text":"这么。。。。迫不急待么？",
 "text_meta":null,
 "via":385365939,
 "via_user_id":174313,
 "original":385365939,
 "created_at":1432630804,
 "like_count":0,
 "comment_count":0,
 "repin_count":0,
 "is_private":0,
 "orig_source":null,
 "hide_origin":false
 }
 */

@end
