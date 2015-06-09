//
//  CacheViewController.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CacheViewController.h"

@interface CacheViewController ()
@property (weak, nonatomic) IBOutlet PhotoScrollView *scrollView;

@end

@implementation CacheViewController

-(void)initTab{
    UITabBarItem * tempBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:2];
    
    /**/
    self.tabBarItem.title=@"离线";
    self.tabBarItem.image= tempBarItem.selectedImage;
//    self.tabBarItem.badgeValue=@"10";
    
    NSArray * files = [[SDImageCache sharedImageCache]getDiskKeys];
    [files enumerateObjectsUsingBlock:^(NSURL * url, NSUInteger idx, BOOL *stop) {
        Pin * pin = [[Pin alloc]init];
        pin.url658 = [url path];
        pin.url320 = [url path];
        //pin.image = [pin loadLocalImage];
        pin.is_cache = true;
        pin.idx = [super.pins count];
        [super.pins addObject:pin];
    }];
    
    //    PhotoScrollView* v = (PhotoScrollView*)[self getScrollView];
    self.scrollView.isCacheMode = true;
}

-(PhotoScrollView*) getScrollView{
    return self.scrollView;
}


@end
