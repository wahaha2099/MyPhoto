//
//  SettingViewController.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/6.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "IndexViewController.h"
#import "NetViewController.h"

@interface IndexViewController ()//<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


//@property (nonatomic) UINavigationBar * navBar;


@property CGFloat maxWidth;
@property CGFloat maxHeight;
@property CGFloat headOffset;
@property NSInteger cacheSize;

//添加花瓣id
@property NSString * addHuabanId;
@end

@implementation IndexViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    CGRect size = self.tabBarController.tabBar.frame  ;
    
    CGRect frame = self.view.frame;
    frame.size.height = screen.size.height - size.size.height * 2  ;
    
    [self.view setFrame:frame];
 //   [frame setSize:CGSizeMake(screen.size.width, ];
    [self extendedLayout];
    //self.automaticallyAdjustsScrollViewInsets = false;
    /*
    //table view
    _settingView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headOffset, _maxWidth, _maxHeight) style:UITableViewStyleGrouped] ;
    _settingView.delegate = self;
    _settingView.dataSource = self;
    
    [self.view addSubview:_settingView];
  
    
    //[self.navigationController pushViewController:_settingView animated:YES];
    
    
    //navBar
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _headOffset)];
    navBar.backgroundColor = [UIColor whiteColor];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"分类";
    navBar.items = @[ navItem ];
    self.navBar = navBar;
    [self.view addSubview:navBar];
  */
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
    
    if(section == 0)return 4;
    
    else
        return 1;
}


/**
 3、设置行的高度
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height / 4 ;
    //return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}

/**
 4、返回指定的 row 的 cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    cell.imageView.image=[UIImage imageNamed:@"1.jpeg"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.textLabel setText:[NSString stringWithFormat:@"萌宠"]];
                    break;
                }
                case 1:{
                    cell.imageView.image=[UIImage imageNamed:@"2.jpeg"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.textLabel setText:[NSString stringWithFormat:@"多肉"]];
                    break;
                }
                case 2:{
                    cell.imageView.image=[UIImage imageNamed:@"3.jpeg"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.textLabel setText:[NSString stringWithFormat:@"座驾"]];
                    break;
                }
                case 3:{
                    cell.imageView.image=[UIImage imageNamed:@"4.jpeg"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.textLabel setText:[NSString stringWithFormat:@"女神"]];
                    break;
                }
                default:
                    break;
            }
            
            break;
            }
        default:
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
    
    //第一个分区标题为"亚洲",第二个分区标题为"欧洲"
    if(section==0)
    {
        return @"亚洲";
    }
    else
    {
        return @"欧洲";
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    NSLog(@"add text field %@" , textField.text);
    self.addHuabanId = textField.text;
}

-(void)showCacheSize{
    _cacheSize = [[SDImageCache sharedImageCache] getSize ];
}


/**
 5、点击单元格时的处理
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self goToPage:nil];
}

-(void)goToPage:(UIButton * )sender{
    
    NetViewController *netView = [[NetViewController alloc]initWithNibName:@"NetPhotoScene" bundle:nil];
    [self.navigationController pushViewController:netView animated:YES];
    
    [netView initTabItem];
}

/**
 //美好的 http://huaban.com/boards/2059352/
 //多肉 http://huaban.com/boards/19912795/
 //http://huaban.com/boards/19368381/
 //http://huaban.com/boards/14183359/
 //http://huaban.com/boards/13518603/
 //http://huaban.com/boards/1955721/
 //http://huaban.com/boards/1820003/
 //http://huaban.com/boards/1820003/
 
 //宠物
 //http://huaban.com/boards/17970755/ gougou
 //http://huaban.com/boards/18310689/ 汪星人
 //http://huaban.com/boards/18031874/ 狗狗
 //http://huaban.com/boards/3868349/  花瓣萌宠
 //http://huaban.com/boards/16004129/
 
 //汽车
 //http://huaban.com/boards/19611747/
 //http://huaban.com/boards/16408142/
 //http://huaban.com/boards/16047656/
 //http://huaban.com/boards/2092705/
 */

@end
