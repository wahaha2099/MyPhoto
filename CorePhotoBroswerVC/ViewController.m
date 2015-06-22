//
//  ViewController.m
//  CorePhotoBroswerVC
//
//  Created by 成林 on 15/5/4.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//


#import "ViewController.h"

/*
#import "PhotoBroswerVC.h"
#import "PhotoCotentView.h"
#import "DataMagic.h"

#import "UIImage+ReMake.h"
*/
@interface ViewController ()<ADBannerViewDelegate>

//@property (weak, nonatomic) IBOutlet PhotoScrollView *scrollView;
//@property (nonatomic,strong) NSMutableArray *pins;

@end

@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _pins = [[NSMutableArray alloc]init];
    
    [self initTab];
    [self initController];
}
/*
-(void)showViewPhoto{
    
    ViewPhotoController * controller = [[ViewPhotoController alloc]init];
    controller.parentViewController = self;
    controller.scrollView = _scrollView;
    [controller initController];
}
*/

-(void)initTab{

}

- (void)initController {
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [[iAdHelper Instance] addADBanner:self.view top:YES];
    
    [[SDImageCache sharedImageCache]setMaxMemoryCost:10 ];
    long maxCacheAge = 60 * 60 * 24 * 7; // 1 week
    
    [[SDImageCache sharedImageCache] setMaxCacheAge:maxCacheAge * 4 * 12 * 5];//5年
    
    [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];

    //[[SDImageCache sharedImageCache]setMaxCacheSize:];
    
    //事件
    [self event];

//    [[self getScrollView] initScrollView:self];
    //_scrollView.delegate = self;
    
}

-(void)initNetMode{
    //展示数据
    //[self contentViewDataPrepare];
    //[self performSelectorInBackground:@selector(contentViewDataPrepare) withObject:nil];
    
    //请求远程图片
    //[self performSelectorInBackground:@selector(loadWebData) withObject:nil];
    
    //添加注册
    [self loadWebData];
}

//请求远程图片
-(void)loadWebData{
    //添加远程数据
    NSString * notify = [[DataMagic Instance]NOTIFY_FINISH_PIC_PARSE];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWebPhoto:) name:notify object:nil];
    //[[DataMagic Instance]requestPic];
}

/** 展示本地9张图片 */
-(void)contentViewDataPrepare{
    NSUInteger i = 0;
    for ( i = 0; i < 9 ; i++ ) {
        UIImage *imagae =[UIImage imageNamed:[NSString stringWithFormat:@"%@",@(i+1)]];
        
        Pin * pin = [[Pin alloc]init];
        pin.image = imagae;
        pin.is_local = true;
        pin.idx = i;
        [_pins addObject:pin];
        [[self getScrollView] showImages:pin];
    }
    //return;
}

/** 事件 */
-(void)event{
    PhotoScrollView* v = (PhotoScrollView*)[self getScrollView];
    v.ClickImageBlock = ^(NSUInteger index){
        
        //本地图片展示
        //        [self localImageShow:index];
        
        //展示网络图片
        [self networkImageShow:index];
    };
}


- (IBAction)showAction:(id)sender {
    
    
}

/*
 *  本地图片展示

-(void)localImageShow:(NSUInteger)index{
    
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
        
        NSArray *localImages = weakSelf.pins;
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:localImages.count];
        for (NSUInteger i = 0; i< localImages.count; i++) {
            Pin * pin = _pins[i];
            if(!pin.is_local){
                break;
            }
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
            pbModel.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
            pbModel.image = localImages[i];
            
            //源frame
            UIImageView *imageV =(UIImageView *) weakSelf.scrollView.subviews[i];
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}
 */

/*
 *  展示网络图片
 */
-(void)networkImageShow:(NSUInteger)index{
    
    
    //__weak typeof(self) weakSelf=self;
    __weak NSMutableArray * __pins = _pins;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeModal index:index photoModelBlock:^NSArray *{
        
        NSArray * networkImages = self.pins;
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< [networkImages count]; i++) {
            
            Pin * pin = __pins[i];
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.pin = pin;
            //pbModel.title = pin.raw_text;
            //pbModel.desc = pin.raw_text;
            
            //设置回调
            pbModel.PageCountBlock = ^(void){
                return (int)[__pins count];
            };
            
            if(pin.is_local)
                pbModel.image = pin.image;
            if( pin.is_cache ){
                pbModel.is_local_cache = YES;
                pbModel.image_HD_U = pin.url_658;
                
            }else
                pbModel.image_HD_U = pin.url_658;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

//远程查询数据结束
-(void)showWebPhoto: (NSNotification*) aNotification{
    NSNumber * board_id = [aNotification object];
    
    if(board_id == nil){
        [[DataMagic Instance]finishShowPage];
        return ;
    }
    NSDictionary * Boards = [[DataMagic Instance]Boards];
    BoardInfo * board = [Boards objectForKey:board_id];
    [self performSelectorInBackground:@selector(addPin2UI:) withObject:board ];
}

//异步添加图片到ui
-(void)addPin2UI:(BoardInfo*)board{
    __weak NSMutableArray * __pins = _pins;
    [board.pins enumerateObjectsUsingBlock:^(Pin * pin, NSUInteger idx, BOOL *stop) {
        if( pin == nil){
            NSLog(@"ViewController 神奇了,pin 居然=nil");
        }
        pin.idx = [__pins count];
        
        [__pins addObject:pin];
        
        //if([_pins count] < 18)//2页
        //[[self getScrollView] showImages:pin];
    }];

    //清除board里面的数据
    board.pins = nil;
    board.pins = [[NSMutableArray alloc]init];
    
    //[[SDImageCache sharedImageCache] clearMemory];
    //[[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];

    
    [[DataMagic Instance]finishShowPage];
    
    [[self getScrollView] pinsRefresh];
}

-(void)showTabBarController:(bool)show{
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    CGRect size = self.tabBarController.tabBar.frame  ;
    if(show ){
        size.origin.y = screen.size.height - size.size.height;
        
    }else if(!show){
        size.origin.y = screen.size.height ;
    }
    self.tabBarController.tabBar.frame = size;
}

//隐藏广告
-(void)hideADBanner{
    [[iAdHelper Instance] hideADBanner];
    //[self showTabBarController:YES];
}

//显示广告
-(void)showADBanner{
    [[iAdHelper Instance] showADBanner:self.view top:YES];
    //[self showTabBarController:NO];
}

-(id) getScrollView{
    return nil;
}

#pragma mark ========切换tab时,删除和重新显示======
//回收全部imageView
-(void)removeAllPage{
    [[self getScrollView]removeAllPage];
}
//显示当前page的imageView
-(void)addCurrentPage{
    [[self getScrollView ]addCurrentPage];
}
#pragma mark ========切换tab时,删除和重新显示======

//删除按钮后的通知
-(void) removePinNotify:(NSNotification*) aNotification{
    Pin* pin = aNotification.object ;
    if ( [_pins objectAtIndex:pin.idx ] != nil) {
        //NSLog(@"removeing %i" , (int)pin.idx );
        [self.pins removeObjectAtIndex:pin.idx];
        //    [self.pins objectAtIndex:pin.idx];
        
        //pin的下标
        [_pins enumerateObjectsUsingBlock:^(Pin * obj, NSUInteger idx, BOOL *stop) {
            if( idx >= pin.idx){
                obj.idx = obj.idx - 1;
            }
        }];
        
        //重新布局
        [[self getScrollView]relayout:(int)pin.idx];
        
        //[[self getScrollView]removeAllPage];
        //[[self getScrollView ] addCurrentPage];
    }
}

#pragma mark ====tab切换操作======
//选中当前controller
-(void)tabSelected{
    //子类实现
}
//切换tab,没选中当前
-(void)tabNotSelected{
    //子类实现
}
#pragma mark =====
@end
