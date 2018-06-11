//
//  LeftViewController.m
//  ViewControllerTransition
//
//  Created by 陈旺 on 2017/7/10.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "NextTableViewCell.h"
#import "NextViewController.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation LeftViewController



- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[@"personal_member_icons",@"personal_myservice_icons",@"personal_news_icons",@"personal_order_icons",@"personal_preview_icons",@"personal_service_icons"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@"present下一个界面",@"Push下一个界面",@"Push下一个界面",@"Push下一个界面",@"显示alertView",@"主动收起抽屉"];
    }
    return _titleArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupHeader];
    
    [self setupTableView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect rect = self.view.frame;
    
    switch (_drawerType) {
        case DrawerDefaultLeft:
            [self.view.superview sendSubviewToBack:self.view];
            break;
        case DrawerTypeMaskLeft:
            rect.size.width = kCWSCREENWIDTH * 0.75;
            break;
        default:
            break;
    }
    
    self.view.frame = rect;
}




- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, kCWSCREENWIDTH * 0.75, CGRectGetHeight(self.view.bounds)-300) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    //    tableView.backgroundColor = [UIColor clearColor];
    _tableView = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:@"NextTableViewCell" bundle:nil] forCellReuseIdentifier:@"NextCell"];
}

- (void)setupHeader {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCWSCREENWIDTH * 0.75, 300)];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:imageV];
}


- (void)dealloc {
    NSLog(@"%s",__func__);
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NextCell"];
    cell.imageName = self.imageArray[indexPath.row];
    cell.title = self.titleArray[indexPath.row];
    //    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.titleArray.count - 1) { // 点击最后一个主动收起抽屉
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (indexPath.row == self.titleArray.count - 2) { // 显示alertView
        [self showAlterView];
        return;
    }
    
    NextViewController *vc = [NextViewController new];
    if (indexPath.row == 0) {
        if (_drawerType == DrawerDefaultLeft) { // 默认动画左侧滑出的情况用这种present方式
            [self presentViewController:vc animated:YES completion:nil];
        }else if (_drawerType == DrawerTypeMaskLeft) { // Mask动画左侧滑出的情况用这种present方式
            [self cw_presentViewController:vc drewerHiddenDuration:0.01];
        }else{ // 右侧滑出的情况用这种present方式
            [self cw_presentViewController:vc];
        }
    }else {
        if (_drawerType == DrawerTypeMaskLeft) {
            [self cw_pushViewController:vc drewerHiddenDuration:0.01];
        }else {
            [self cw_pushViewController:vc];
        }
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (void)showAlterView {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"hello world!" message:@"hello world!嘿嘿嘿" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"😂😄" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

@end
