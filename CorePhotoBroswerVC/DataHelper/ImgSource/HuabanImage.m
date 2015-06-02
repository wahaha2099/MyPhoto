//
//  DataMagic.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/26.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "DataMagic.h"


@implementation DataMagic

NSString * notify = @"Notification_finish_follow";

//通知回调
static DataMagic * instance ;

+(instancetype) Instance{
    if( instance == nil){
        instance = [[DataMagic alloc] init];
        instance.Boards = [[NSMutableDictionary alloc]init];
        
        instance.NOTIFY_HTTP_PIC_REQ = @"NOTIFY_HTTP_PIC_REQ";
        instance.NOTIFY_FINISH_PIC_REQ = @"NOTIFY_FINISH_PIC_REQ";
        instance.NOTIFY_FINISH_PIC_PARSE = @"NOTIFY_FINISH_PIC_PARSE";
    }

    return instance;
}


//请求图片
-(void) requestPic{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_NOTIFY_HTTP_PIC_REQ object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseBoardCallback:) name:_NOTIFY_HTTP_PIC_REQ object:nil];

    NSArray * list = [self getFollowList];

    //轮训 board
    NSString * board_url = nil;
    if(_loading_page < [list count]){
        board_url = [list objectAtIndex:_loading_page];
    }else{
        board_url = [list objectAtIndex:_loading_page % [list count]];
    }

    //根据url获取board_id,就是key
    NSNumber * key = [NSNumber numberWithLongLong:[[board_url lastPathComponent]longLongValue ]];
    
    //init board
    BoardInfo * b = [_Boards objectForKey:key];
    if(b == nil){
        b = [BoardInfo initByUrl:board_url];
        [_Boards setObject:b forKey: key];
    }
    
    NSLog(@"request %@",board_url);

    NSString * url = [NSString stringWithFormat:@"%@?max=%@&limit=20&wfl=1",board_url,b.max];//381205601,999999999
    [[HttpHelper Instance] request:url notify:_NOTIFY_HTTP_PIC_REQ isJson:true];
    _loading_page++;
    
    /*
    [list enumerateObjectsUsingBlock:^( NSString * obj, NSUInteger idx, BOOL *stop) {
        if(idx < 2){
            NSLog(@"request %@",obj);
     
            BoardInfo * b = [BoardInfo initByUrl:obj];
            NSNumber * key = [NSNumber numberWithLongLong:[[b getIdx]longLongValue ]];
            [_Boards setObject:b forKey: key];
            
            NSString * url = [NSString stringWithFormat:@"%@?max=999999999&limit=20&wfl=1",obj];//381205601,999999999
            [[HttpHelper Instance] request:url notify:_NOTIFY_HTTP_PIC_REQ isJson:true];
        }
    }];*/
}

//处理请求返回
-(void) parseBoardCallback: (NSNotification*) aNotification{
    NSError *error;
    NSData * rsp = [aNotification object];
    
    if (rsp == nil || [rsp length] == 0 ){
        NSLog(@"no data %@" , rsp);
        
        _loading_page--;
        
        //通知界面更新
        [[NSNotificationCenter defaultCenter] postNotificationName:_NOTIFY_FINISH_PIC_PARSE object:nil userInfo:nil];
        return ;
    }
    NSDictionary * rs = [NSJSONSerialization JSONObjectWithData:rsp options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary * board = [rs objectForKey:@"board"];
    
    NSString * board_id = [board objectForKey:@"board_id"];
    NSArray * pins = [board objectForKey:@"pins"];
    [pins enumerateObjectsUsingBlock:^(NSDictionary * pin_dic, NSUInteger idx, BOOL *stop) {
        Pin* pin = [Pin initPin:pin_dic];
        [[_Boards objectForKey:[NSNumber numberWithLongLong:[pin.board_id longLongValue]]] addPin:pin];
    }];
    
    //通知界面更新
    [[NSNotificationCenter defaultCenter] postNotificationName:_NOTIFY_FINISH_PIC_PARSE object:board_id userInfo:nil];
}

//返回默认的一些关注列表
-(NSArray * ) getFollowList{
    NSMutableArray * b = [[NSMutableArray alloc]init];
  [b addObject:@"http://huaban.com/boards/2399123"];[b addObject:@"http://huaban.com/boards/2399339"];[b addObject:@"http://huaban.com/boards/2858568"];[b addObject:@"http://huaban.com/boards/3222303"];[b addObject:@"http://huaban.com/boards/3381682"];[b addObject:@"http://huaban.com/boards/3654333"];[b addObject:@"http://huaban.com/boards/3671622"];[b addObject:@"http://huaban.com/boards/3724214"];[b addObject:@"http://huaban.com/boards/3815051"];[b addObject:@"http://huaban.com/boards/3847883"];[b addObject:@"http://huaban.com/boards/3851761"];[b addObject:@"http://huaban.com/boards/3920336"];[b addObject:@"http://huaban.com/boards/5921418"];[b addObject:@"http://huaban.com/boards/5931805"];[b addObject:@"http://huaban.com/boards/7512699"];[b addObject:@"http://huaban.com/boards/9398935"];[b addObject:@"http://huaban.com/boards/9449237"];[b addObject:@"http://huaban.com/boards/10566050"];[b addObject:@"http://huaban.com/boards/13716047"];[b addObject:@"http://huaban.com/boards/14413285"];[b addObject:@"http://huaban.com/boards/15841044"];[b addObject:@"http://huaban.com/boards/15861463"];[b addObject:@"http://huaban.com/boards/15936265"];[b addObject:@"http://huaban.com/boards/15966405"];[b addObject:@"http://huaban.com/boards/15999669"];[b addObject:@"http://huaban.com/boards/16021437"];[b addObject:@"http://huaban.com/boards/16080681"];[b addObject:@"http://huaban.com/boards/16198023"];[b addObject:@"http://huaban.com/boards/16507978"];[b addObject:@"http://huaban.com/boards/16973190"];[b addObject:@"http://huaban.com/boards/17019649"];[b addObject:@"http://huaban.com/boards/17190823"];[b addObject:@"http://huaban.com/boards/17323384"];[b addObject:@"http://huaban.com/boards/17434946"];[b addObject:@"http://huaban.com/boards/17435030"];[b addObject:@"http://huaban.com/boards/17507834"];[b addObject:@"http://huaban.com/boards/17521770"];[b addObject:@"http://huaban.com/boards/17555499"];[b addObject:@"http://huaban.com/boards/17666108"];[b addObject:@"http://huaban.com/boards/18021298"];[b addObject:@"http://huaban.com/boards/18028589"];[b addObject:@"http://huaban.com/boards/18238482"];[b addObject:@"http://huaban.com/boards/18249190"];[b addObject:@"http://huaban.com/boards/18442584"];[b addObject:@"http://huaban.com/boards/18453654"];[b addObject:@"http://huaban.com/boards/18518188"];[b addObject:@"http://huaban.com/boards/18560744"];[b addObject:@"http://huaban.com/boards/18624221"];[b addObject:@"http://huaban.com/boards/18710890"];[b addObject:@"http://huaban.com/boards/18722949"];[b addObject:@"http://huaban.com/boards/18776966"];[b addObject:@"http://huaban.com/boards/18831204"];[b addObject:@"http://huaban.com/boards/18865864"];[b addObject:@"http://huaban.com/boards/18879923"];[b addObject:@"http://huaban.com/boards/18894850"];[b addObject:@"http://huaban.com/boards/18914812"];[b addObject:@"http://huaban.com/boards/18961236"];[b addObject:@"http://huaban.com/boards/18961249"];[b addObject:@"http://huaban.com/boards/19047885"];[b addObject:@"http://huaban.com/boards/19110465"];[b addObject:@"http://huaban.com/boards/19163874"];[b addObject:@"http://huaban.com/boards/19239913"];[b addObject:@"http://huaban.com/boards/19332986"];[b addObject:@"http://huaban.com/boards/19368515"];[b addObject:@"http://huaban.com/boards/19452063"];[b addObject:@"http://huaban.com/boards/19572002"];[b addObject:@"http://huaban.com/boards/19587909"];[b addObject:@"http://huaban.com/boards/19623706"];[b addObject:@"http://huaban.com/boards/19630297"];[b addObject:@"http://huaban.com/boards/19654192"];[b addObject:@"http://huaban.com/boards/19659085"];[b addObject:@"http://huaban.com/boards/19702009"];[b addObject:@"http://huaban.com/boards/19702548"];[b addObject:@"http://huaban.com/boards/19705253"];[b addObject:@"http://huaban.com/boards/19730939"];[b addObject:@"http://huaban.com/boards/19730945"];[b addObject:@"http://huaban.com/boards/19735392"];[b addObject:@"http://huaban.com/boards/19735418"];[b addObject:@"http://huaban.com/boards/19736122"];[b addObject:@"http://huaban.com/boards/19740798"];[b addObject:@"http://huaban.com/boards/19742687"];[b addObject:@"http://huaban.com/boards/19748970"];[b addObject:@"http://huaban.com/boards/19774644"];[b addObject:@"http://huaban.com/boards/19776585"];[b addObject:@"http://huaban.com/boards/19779616"];[b addObject:@"http://huaban.com/boards/19879570"];[b addObject:@"http://huaban.com/boards/19889791"];[b addObject:@"http://huaban.com/boards/19896394"];[b addObject:@"http://huaban.com/boards/22245722"];[b addObject:@"http://huaban.com/boards/22525623"];[b addObject:@"http://huaban.com/boards/23958350"];
    return b;
}

//请求远程,解析我关注的人
-(void) parseFollow{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFollowSuccess:) name:notify object:nil];
    NSString * followUrl = @"http://huaban.com/sksq7twbdf/following/";
    [[HttpHelper Instance]request:followUrl notify:notify isJson:false];
}

//请求数据返回
- (void) getFollowSuccess: (NSNotification*) aNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notify object:nil ];
    
    //NSString * rsp = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    NSString * rsp = [aNotification object];
    NSLog(@"follow %@" , rsp);
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
