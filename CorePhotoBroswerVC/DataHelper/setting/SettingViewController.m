//
//  SettingViewController.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/6.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView * settingView;
@property (weak, nonatomic) IBOutlet UINavigationBar * navBar;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.automaticallyAdjustsScrollViewInsets = false;
    
    UITabBarItem * tempBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:1];

    
    /**/
    self.tabBarItem.title=@"设置";
    self.tabBarItem.image= tempBarItem.selectedImage;
    
    self.navBar.frame = CGRectMake(0 , 0 ,self.view.frame.size.width, self.view.frame.size.height-100);
    
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.settingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    NSLog(@"width %i" , (int)self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView methods
/**
 1、返回 UITableView 的区段数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/**
 2、返回 UITableView 的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

/**
 3、设置行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.0f;
}

/**
 4、返回指定的 row 的 cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"cache_cell"];
    
    UIButton *objectOfButton = (UIButton *)[Cell viewWithTag:1];
    UILabel * label = (UILabel*)[Cell viewWithTag:2];
    [objectOfButton addTarget:self action:@selector(YourSelector:) forControlEvents:UIControlEventTouchUpInside];
    NSUInteger size = [[SDImageCache sharedImageCache] getSize ];
    [label setText:[NSString stringWithFormat:@"%lu M" , size / 1000 / 1000]];
    
    [[SDImageCache sharedImageCache] getDiskKeys];
    return Cell;
}

/**
 5、点击单元格时的处理
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(IBAction)YourSelector:(UIButton * )sender{
    // Your Button in Cell is selected.
    // Do your stuff.
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    NSLog(@"Button Clicked Index = %i" , (int)sender.tag);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
