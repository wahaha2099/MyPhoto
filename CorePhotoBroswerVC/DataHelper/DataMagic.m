//
//  DataMagic.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/26.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "DataMagic.h"
#import "BaiduImage.h"
#import "HuabanImage.h"

@implementation DataMagic


//通知回调
static DataMagic * instance ;

+(instancetype) Instance{
    if( instance == nil){
        instance = [[DataMagic alloc] init];
        instance.Boards = [[NSMutableDictionary alloc]init];
        instance.NOTIFY_HTTP_PIC_REQ = @"NOTIFY_HTTP_PIC_REQ";
        instance.NOTIFY_FINISH_PIC_REQ = @"NOTIFY_FINISH_PIC_REQ";
        instance.NOTIFY_FINISH_PIC_PARSE = @"NOTIFY_FINISH_PIC_PARSE";
        instance.isHuaban = true;
    }
    return instance;
}


//请求图片
-(void) requestPic{
    if(_isHuaban)
        [[HuabanImage Instance]requestPic:_NOTIFY_HTTP_PIC_REQ finish:_NOTIFY_FINISH_PIC_PARSE];
    else
        [[BaiduImage Instance]requestPic:_NOTIFY_HTTP_PIC_REQ finish:_NOTIFY_FINISH_PIC_PARSE];
}

//展示结束
-(void)finishShowPage{
    _finished_page = _loading_page;
}

//是否展示结束
-(bool)isFinishShow{
    return _finished_page == _loading_page;
}
/*
 follow页面的解析方式
 //sksq7twbdf/following/
 //http://huaban.com/boards/19750378/
 var users = app.page['users'];
 var boards = {};
 for(var i = 0 ; i < users.length ; i ++){
 var u = users[i];
 for(var pin in u['pins']) {
 var boardId = u['pins'][pin].board_id;//boardId是画报,pin是推荐的图片
 boards[boardId] = boardId;
 }
 }
 for(var i in boards){
 addtxt('[b addObject:@"http://huaban.com/boards/'+i+'"];');
 }
 function addtxt(txt){
 var para = document.createElement("p");
 var node = document.createTextNode(txt);
 para.appendChild(node)
 document.body.appendChild(para);
 }
 //max是最后的那个pin的id
 //http://huaban.com/boards/2024544?ia6h9ch3&max=121551580&limit=20&wfl=1*/

/**
 图片解析方式
 //img.hb.aicdn.com
 //_fw320
 //_fw658
 */

@end
