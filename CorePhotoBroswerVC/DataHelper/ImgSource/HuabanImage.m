//
//  DataMagic.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/26.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "HuabanImage.h"

@interface HuabanImage()

@property NSString * finish_notify;

@end

@implementation HuabanImage


//通知回调
static HuabanImage * instance ;

+(instancetype) Instance{
    if( instance == nil){
        instance = [[HuabanImage alloc] init];

    }
    return instance;
}


//请求图片
-(void) requestPic:(NSString * )notify finish:(NSString*)finish_callback{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notify object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseBoardCallback:) name:notify object:nil];

    NSArray * list = [self getFollowList];

    //轮训 board
    NSString * board_url = nil;
    int _loading_page = [[DataHolder sharedInstance] getBoardsIndex];
    
    if(_loading_page < [list count]){
        board_url = [list objectAtIndex:_loading_page];
    }else{
        board_url = [list objectAtIndex:_loading_page % [list count]];
    }
    [[DataHolder sharedInstance] saveBoardIndex:++_loading_page];

    //根据url获取board_id,就是key
    NSNumber * key = [NSNumber numberWithLongLong:[[board_url lastPathComponent]longLongValue ]];
    
    //init board
    NSMutableDictionary * _Boards = [[DataMagic Instance]Boards];
    BoardInfo * b = [_Boards objectForKey:key];
    if(b == nil){
        b = [BoardInfo initByUrl:board_url];
        b.magic_type = 1;
        [_Boards setObject:b forKey: key];
    }
    [[DataHolder sharedInstance]loadBoard:b];
    
    //NSLog(@"request %@",board_url);
    //b.max =@"46420493";

    NSString * url = [NSString stringWithFormat:@"%@?max=%@&limit=20&wfl=1",board_url,b.max];//381205601,999999999
    [[HttpHelper Instance] request:url notify:notify isJson:true];
    
    [DataMagic Instance].loading_page++;
    
    _finish_notify = finish_callback;
}

//处理请求返回
-(void) parseBoardCallback: (NSNotification*) aNotification{
    NSError *error;
    NSData * rsp = [aNotification object];
    
    if (rsp == nil || [rsp length] == 0 ){
        NSLog(@"no data %@" , rsp);
        [self handeError];
        return ;
    }
    NSDictionary * rs = [NSJSONSerialization JSONObjectWithData:rsp options:NSJSONReadingMutableLeaves error:&error];
    
    if([rs objectForKey:@"board"] == 0){
        [self handeError];
        return ;
    }
    
    NSDictionary * board = [rs objectForKey:@"board"];
    
    NSString * board_id = [board objectForKey:@"board_id"] ;
    NSArray * pins = [board objectForKey:@"pins"];
    
    NSMutableDictionary * _Boards = [[DataMagic Instance]Boards];
    
    BoardInfo * b = [_Boards objectForKey:[NSNumber numberWithLongLong:[[NSString stringWithFormat:@"%@",board_id ] longLongValue]]];
    
    b.hasAddBefore = NO;
    
    [pins enumerateObjectsUsingBlock:^(NSDictionary * pin_dic, NSUInteger idx, BOOL *stop) {
        
        Pin* pin = [Pin initPin:pin_dic];
        //设置b的start和max
        if([b.max isEqualToString:@"999999999"]){
            //0.....实际测试,因为max=9999,所以进入此逻辑的,一定是新开始的请求,只要判断last_start和start一致即可,代码没改
            //第一次,start=nil和last_start=nil,第二次进逻辑,start应该不等于last_start
            //1.idx = 0, max =999 表示,此次循环是第一次返回的数据
            if(idx == 0){
                //NSLog(@"last_start = %@" , pin.pin_id);
                //NSLog(@"start %@" , b.start);

                //2.last_start存储的是上次请求来的第一条数据
                if(b.last_start != nil && b.start != nil){
                    
                    //3.如果上次请求的第一条数据,与该board第一条记录id一致,认为已经读取过
                    if([b.last_start longLongValue] == [b.start longLongValue]){//last_start != nil ,说明不是新的一次请求
                        //NSLog(@"max pin = %@" , b.last_start);
                        b.hasAddBefore = YES;
                    }
                }

                //3.如果last_start=nil说明是该board第一次请求, last_start > start,说明是有新的
                if(b.last_start == nil || b.last_start > b.start){
                     b.last_start = pin.pin_id;
                }
            }
        }
        if(!b.hasAddBefore){
            if([pin.pin_id longLongValue ] >= [b.start longLongValue] || [b.last_start longLongValue]<= [b.start longLongValue]){
                [b addPin:pin];
            }else{
                //NSLog(@"min pin = %@" , pin.pin_id);
                [b resetBoard];
                //NSLog(@" board end ");
            }
        }
    }];
    
    if ([pins count]==0) {
        [b resetBoard];
        //NSLog(@" board end ");
    }
    
    if(b.start == nil || [b.start longLongValue] < [b.last_start longLongValue]){
        b.start = b.last_start;// ________last_start________start__________这种情况,需要更新start为last_start
    }
    
    [[DataHolder sharedInstance] saveBoard:b];
    
    //通知界面更新
    [[NSNotificationCenter defaultCenter] postNotificationName:_finish_notify object:board_id userInfo:nil];
}

//处理没有数据
-(void)handeError{
    NSLog(@"no data huaban error");
    
    [DataMagic Instance].isHuaban = false;
    [DataMagic Instance].loading_page--;
    
    //通知界面更新
    [[NSNotificationCenter defaultCenter] postNotificationName:_finish_notify object:nil userInfo:nil];
}

//返回默认的一些关注列表
-(NSArray * ) getFollowList{
    NSMutableArray * b = [[NSMutableArray alloc]init];
  [b addObject:@"http://huaban.com/boards/19702548"];[b addObject:@"http://huaban.com/boards/24056708"];[b addObject:@"http://huaban.com/boards/20023087"];[b addObject:@"http://huaban.com/boards/20048346"];[b addObject:@"http://huaban.com/boards/16602530"];[b addObject:@"http://huaban.com/boards/16660764"];[b addObject:@"http://huaban.com/boards/16658499"];[b addObject:@"http://huaban.com/boards/16712363"];[b addObject:@"http://huaban.com/boards/16660800"];[b addObject:@"http://huaban.com/boards/16714227"];[b addObject:@"http://huaban.com/boards/19419223"];[b addObject:@"http://huaban.com/boards/8822440"];[b addObject:@"http://huaban.com/boards/17906021"];[b addObject:@"http://huaban.com/boards/19787146"];[b addObject:@"http://huaban.com/boards/19676340"];[b addObject:@"http://huaban.com/boards/19241298"];[b addObject:@"http://huaban.com/boards/17555499"];[b addObject:@"http://huaban.com/boards/463899"];[b addObject:@"http://huaban.com/boards/20191915"];[b addObject:@"http://huaban.com/boards/19414684"];[b addObject:@"http://huaban.com/boards/19403018"];[b addObject:@"http://huaban.com/boards/19401858"];[b addObject:@"http://huaban.com/boards/16269069"];[b addObject:@"http://huaban.com/boards/19148731"];[b addObject:@"http://huaban.com/boards/16229305"];[b addObject:@"http://huaban.com/boards/19406146"];[b addObject:@"http://huaban.com/boards/19399209"];[b addObject:@"http://huaban.com/boards/19422653"];[b addObject:@"http://huaban.com/boards/19588148"];[b addObject:@"http://huaban.com/boards/19843939"];[b addObject:@"http://huaban.com/boards/19110465"];[b addObject:@"http://huaban.com/boards/18249190"];[b addObject:@"http://huaban.com/boards/20027831"];[b addObject:@"http://huaban.com/boards/17435030"];[b addObject:@"http://huaban.com/boards/19422086"];[b addObject:@"http://huaban.com/boards/24189249"];[b addObject:@"http://huaban.com/boards/19995597"];[b addObject:@"http://huaban.com/boards/20017213"];[b addObject:@"http://huaban.com/boards/20017249"];[b addObject:@"http://huaban.com/boards/9045921"];[b addObject:@"http://huaban.com/boards/18021298"];[b addObject:@"http://huaban.com/boards/19250633"];[b addObject:@"http://huaban.com/boards/13577345"];[b addObject:@"http://huaban.com/boards/16842428"];[b addObject:@"http://huaban.com/boards/19107590"];[b addObject:@"http://huaban.com/boards/16842427"];[b addObject:@"http://huaban.com/boards/19823919"];[b addObject:@"http://huaban.com/boards/24052205"];[b addObject:@"http://huaban.com/boards/19979243"];[b addObject:@"http://huaban.com/boards/19905292"];[b addObject:@"http://huaban.com/boards/18865864"];[b addObject:@"http://huaban.com/boards/17389053"];[b addObject:@"http://huaban.com/boards/18422306"];[b addObject:@"http://huaban.com/boards/19630297"];[b addObject:@"http://huaban.com/boards/17803618"];[b addObject:@"http://huaban.com/boards/24113445"];[b addObject:@"http://huaban.com/boards/18867274"];[b addObject:@"http://huaban.com/boards/18998719"];[b addObject:@"http://huaban.com/boards/16021437"];[b addObject:@"http://huaban.com/boards/15744260"];[b addObject:@"http://huaban.com/boards/16197319"];[b addObject:@"http://huaban.com/boards/19659085"];[b addObject:@"http://huaban.com/boards/19189927"];[b addObject:@"http://huaban.com/boards/18976661"];[b addObject:@"http://huaban.com/boards/19965556"];[b addObject:@"http://huaban.com/boards/20119792"];[b addObject:@"http://huaban.com/boards/13780840"];[b addObject:@"http://huaban.com/boards/19740472"];[b addObject:@"http://huaban.com/boards/19885174"];[b addObject:@"http://huaban.com/boards/24125935"];[b addObject:@"http://huaban.com/boards/20193543"];[b addObject:@"http://huaban.com/boards/3289898"];[b addObject:@"http://huaban.com/boards/19818775"];[b addObject:@"http://huaban.com/boards/22524354"];[b addObject:@"http://huaban.com/boards/22529748"];[b addObject:@"http://huaban.com/boards/24114816"];[b addObject:@"http://huaban.com/boards/19978921"];[b addObject:@"http://huaban.com/boards/3295689"];[b addObject:@"http://huaban.com/boards/24112418"];[b addObject:@"http://huaban.com/boards/19239822"];[b addObject:@"http://huaban.com/boards/20004163"];[b addObject:@"http://huaban.com/boards/16842515"];[b addObject:@"http://huaban.com/boards/19584174"];[b addObject:@"http://huaban.com/boards/3731833"];[b addObject:@"http://huaban.com/boards/19315855"];[b addObject:@"http://huaban.com/boards/19558681"];[b addObject:@"http://huaban.com/boards/17832507"];[b addObject:@"http://huaban.com/boards/20077996"];[b addObject:@"http://huaban.com/boards/22190859"];[b addObject:@"http://huaban.com/boards/1161553"];[b addObject:@"http://huaban.com/boards/19693320"];[b addObject:@"http://huaban.com/boards/19387978"];[b addObject:@"http://huaban.com/boards/19487984"];[b addObject:@"http://huaban.com/boards/13892193"];[b addObject:@"http://huaban.com/boards/13908423"];[b addObject:@"http://huaban.com/boards/17495051"];[b addObject:@"http://huaban.com/boards/24041791"];[b addObject:@"http://huaban.com/boards/20078004"];[b addObject:@"http://huaban.com/boards/23513317"];[b addObject:@"http://huaban.com/boards/20078104"];[b addObject:@"http://huaban.com/boards/20095442"];[b addObject:@"http://huaban.com/boards/13348825"];[b addObject:@"http://huaban.com/boards/20078014"];[b addObject:@"http://huaban.com/boards/24046689"];[b addObject:@"http://huaban.com/boards/19350628"];[b addObject:@"http://huaban.com/boards/20078047"];[b addObject:@"http://huaban.com/boards/20077991"];[b addObject:@"http://huaban.com/boards/18466097"];[b addObject:@"http://huaban.com/boards/16446166"];[b addObject:@"http://huaban.com/boards/3212501"];[b addObject:@"http://huaban.com/boards/19374196"];[b addObject:@"http://huaban.com/boards/18306846"];[b addObject:@"http://huaban.com/boards/16230706"];[b addObject:@"http://huaban.com/boards/19414445"];[b addObject:@"http://huaban.com/boards/19414483"];[b addObject:@"http://huaban.com/boards/19627612"];[b addObject:@"http://huaban.com/boards/19422552"];[b addObject:@"http://huaban.com/boards/19428827"];[b addObject:@"http://huaban.com/boards/18710890"];[b addObject:@"http://huaban.com/boards/19132437"];[b addObject:@"http://huaban.com/boards/14396402"];[b addObject:@"http://huaban.com/boards/19859042"];[b addObject:@"http://huaban.com/boards/19491681"];[b addObject:@"http://huaban.com/boards/19419195"];[b addObject:@"http://huaban.com/boards/19963332"];[b addObject:@"http://huaban.com/boards/19235270"];[b addObject:@"http://huaban.com/boards/19143156"];[b addObject:@"http://huaban.com/boards/19378458"];[b addObject:@"http://huaban.com/boards/14342360"];[b addObject:@"http://huaban.com/boards/15495361"];[b addObject:@"http://huaban.com/boards/1432799"];[b addObject:@"http://huaban.com/boards/3376217"];[b addObject:@"http://huaban.com/boards/19477312"];[b addObject:@"http://huaban.com/boards/19414398"];[b addObject:@"http://huaban.com/boards/19452043"];[b addObject:@"http://huaban.com/boards/19511505"];[b addObject:@"http://huaban.com/boards/19484961"];[b addObject:@"http://huaban.com/boards/17538066"];[b addObject:@"http://huaban.com/boards/2958822"];[b addObject:@"http://huaban.com/boards/19740798"];[b addObject:@"http://huaban.com/boards/13896198"];[b addObject:@"http://huaban.com/boards/12520365"];[b addObject:@"http://huaban.com/boards/15941182"];[b addObject:@"http://huaban.com/boards/19877354"];[b addObject:@"http://huaban.com/boards/19740153"];[b addObject:@"http://huaban.com/boards/19717669"];[b addObject:@"http://huaban.com/boards/19419368"];[b addObject:@"http://huaban.com/boards/19877303"];[b addObject:@"http://huaban.com/boards/14343343"];[b addObject:@"http://huaban.com/boards/20000780"];[b addObject:@"http://huaban.com/boards/18966448"];[b addObject:@"http://huaban.com/boards/3446583"];[b addObject:@"http://huaban.com/boards/13752007"];[b addObject:@"http://huaban.com/boards/19075506"];[b addObject:@"http://huaban.com/boards/18484046"];[b addObject:@"http://huaban.com/boards/19403062"];[b addObject:@"http://huaban.com/boards/2724764"];[b addObject:@"http://huaban.com/boards/3671622"];[b addObject:@"http://huaban.com/boards/19728156"];[b addObject:@"http://huaban.com/boards/5931805"];[b addObject:@"http://huaban.com/boards/19708831"];[b addObject:@"http://huaban.com/boards/3399987"];[b addObject:@"http://huaban.com/boards/18467259"];[b addObject:@"http://huaban.com/boards/19572002"];[b addObject:@"http://huaban.com/boards/19753280"];[b addObject:@"http://huaban.com/boards/19742673"];[b addObject:@"http://huaban.com/boards/19742533"];[b addObject:@"http://huaban.com/boards/16269912"];[b addObject:@"http://huaban.com/boards/19156050"];[b addObject:@"http://huaban.com/boards/19730939"];[b addObject:@"http://huaban.com/boards/19621852"];[b addObject:@"http://huaban.com/boards/18914812"];[b addObject:@"http://huaban.com/boards/16366900"];[b addObject:@"http://huaban.com/boards/17324249"];[b addObject:@"http://huaban.com/boards/19563266"];[b addObject:@"http://huaban.com/boards/13372279"];[b addObject:@"http://huaban.com/boards/15999669"];[b addObject:@"http://huaban.com/boards/19364783"];[b addObject:@"http://huaban.com/boards/19457032"];[b addObject:@"http://huaban.com/boards/16231730"];[b addObject:@"http://huaban.com/boards/16397718"];[b addObject:@"http://huaban.com/boards/19048078"];[b addObject:@"http://huaban.com/boards/17013153"];[b addObject:@"http://huaban.com/boards/19109106"];[b addObject:@"http://huaban.com/boards/18238465"];[b addObject:@"http://huaban.com/boards/13912576"];[b addObject:@"http://huaban.com/boards/18752538"];[b addObject:@"http://huaban.com/boards/13876811"];[b addObject:@"http://huaban.com/boards/7513408"];[b addObject:@"http://huaban.com/boards/13725528"];[b addObject:@"http://huaban.com/boards/14488244"];[b addObject:@"http://huaban.com/boards/17712556"];[b addObject:@"http://huaban.com/boards/16887102"];[b addObject:@"http://huaban.com/boards/644577"];[b addObject:@"http://huaban.com/boards/3237184"];[b addObject:@"http://huaban.com/boards/14004092"];[b addObject:@"http://huaban.com/boards/5842951"];[b addObject:@"http://huaban.com/boards/336066"];[b addObject:@"http://huaban.com/boards/3256226"];[b addObject:@"http://huaban.com/boards/2888252"];
    
    //wahaha2099
    [b addObject:@"http://huaban.com/boards/19760628"];
    //[b addObject:@"http://huaban.com/boards/19750378"];
    //end wahaha
    
    return b;
}

NSString * notify_follow = @"Notification_finish_follow";
//请求远程,解析我关注的人
-(void) parseFollow{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFollowSuccess:) name:notify_follow object:nil];
    NSString * followUrl = @"http://huaban.com/sksq7twbdf/following/";
    [[HttpHelper Instance]request:followUrl notify:notify_follow isJson:false];
}

//请求数据返回
- (void) getFollowSuccess: (NSNotification*) aNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notify_follow object:nil ];
    
    //NSString * rsp = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    NSString * rsp = [aNotification object];
    NSLog(@"follow %@" , rsp);
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
