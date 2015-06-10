//
//  SettingViewController.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/6.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic) UINavigationBar * navBar;

@property CGFloat maxWidth;
@property CGFloat maxHeight;
@property CGFloat headOffset;
@property NSInteger cacheSize;
@end

@implementation SettingViewController

CGFloat maxWidth;
CGFloat maxHeight;

//设置tabItem名称
-(void)initTabItem{
    UITabBarItem * tempBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:3];
    
    
    /**/
    self.tabBarItem.title=@"设置";
    self.tabBarItem.image= tempBarItem.selectedImage;
    
    [self performSelectorInBackground:@selector(showCacheSize) withObject:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self extendedLayout];
    //self.automaticallyAdjustsScrollViewInsets = false;
    
    //table view
    _settingView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headOffset, _maxWidth, _maxHeight) style:UITableViewStyleGrouped] ;
    _settingView.delegate = self;
    _settingView.dataSource = self;
    
    [self.view addSubview:_settingView];
    
    //navBar
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _headOffset)];
    navBar.backgroundColor = [UIColor whiteColor];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Setting";
    navBar.items = @[ navItem ];
    self.navBar = navBar;
    [self.view addSubview:navBar];
    
}

- (void)extendedLayout
{
    BOOL iOS7 = [UIDevice currentDevice].systemVersion.floatValue >= 7.0;
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    CGFloat offset = _headOffset = iOS7 ? 64 : 44;
    _maxWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    _maxHeight = CGRectGetHeight(self.view.frame)-offset;
    
    self.navigationController.navigationBar.translucent = NO;
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
    return 50.0f;
}

/**
 4、返回指定的 row 的 cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    switch (indexPath.row) {
        case 0:{
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.textLabel setText:[NSString stringWithFormat:@"Cache Size :%lu M" , _cacheSize / 1000 / 1000]];
            
            [self performSelectorInBackground:@selector(showCacheSize) withObject:nil];
            
            //添加按钮
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button addTarget:self action:@selector(ClearCache:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"Clear" forState:UIControlStateNormal];
            [cell.contentView addSubview:button];
            
            //相对于contentView右对齐,向左30
            NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-30.f];
            
            //和textLabel保持同一行
            NSLayoutConstraint * lineConstraint =[NSLayoutConstraint constraintWithItem:button
                                                       attribute:NSLayoutAttributeBaseline
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:cell.textLabel
                                                       attribute:NSLayoutAttributeBaseline
                                                      multiplier:1                                                        constant:0];

            [cell.contentView addConstraint:constraint];
            [cell.contentView addConstraint:lineConstraint];
            
            break;
        }
    }

    return cell;
}

-(void)showCacheSize{
    _cacheSize = [[SDImageCache sharedImageCache] getSize ];
}


/**
 5、点击单元格时的处理
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)ClearCache:(UIButton * )sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete the cache?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //删除按钮点击
    if([[alertView title] isEqualToString:@"Delete"] && buttonIndex == 1)
    {
        [[SDImageCache sharedImageCache] clearDisk];
        [_settingView reloadData];
    }
}

@end
