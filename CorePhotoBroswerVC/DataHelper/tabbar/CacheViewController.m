//
//  CacheViewController.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CacheViewController.h"

@interface CacheViewController ()
@property (weak, nonatomic) IBOutlet PhotoScrollView *cacheView;

@end

@implementation CacheViewController

-(void)initTabItem{
    UITabBarItem * tempBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
    
    /**/
    self.tabBarItem.title=@"离线";
    self.tabBarItem.image= tempBarItem.selectedImage;
}

-(void)initTab{
    NSArray * files = [[SDImageCache sharedImageCache]getDiskKeys];
    [files enumerateObjectsUsingBlock:^(NSURL * url, NSUInteger idx, BOOL *stop) {
        Pin * pin = [[Pin alloc]init];
        pin.url658 = [url path];
        pin.url320 = [url path];
        //pin.image = [pin loadLocalImage];
        pin.is_cache = true;
        pin.idx = [super.pins count];
        
        if( idx < 18 )
           [_cacheView showImages:pin];
        
        [super.pins addObject:pin];
    }];
    
    if( [files count] < 9 ){
        for (int i = 0; i < 9 - [files count] ; i++) {
            Pin * pin = [[Pin alloc]init];
            UIImage *imagae =[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpeg",@(i+1)]];
            pin.idx = i;
            pin.image = imagae;
            pin.is_local = true;
            
            [_cacheView showImages:pin];
            [super.pins addObject:pin];
        }
    }

    //    PhotoScrollView* v = (PhotoScrollView*)[self getScrollView];
    self.cacheView.isCacheMode = true;
    
    [[self getScrollView] initScrollView:self];
}

-(PhotoScrollView*) getScrollView{
    return self.cacheView;
}


@end
