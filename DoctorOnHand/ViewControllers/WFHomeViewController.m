//
//  WFHomeViewController.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/18.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFHomeViewController.h"
#import "WFLoginViewController.h"
#import "CMPMSignatureViewController.h"
#import "WFHomeVideoViewController.h"

@interface WFHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation WFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupAttributes {
    self.navigationItem.title = @"掌上医生";
    self.dataArray = @[
        @"登录",
        @"手写板",
        @"录音",
        @"拍照",
        @"摄像",
        @"文件上传",
        @"文件缓存查看"
    ];
}

- (void)setupSubViews {
    [self.view addSubview:self.tableView];
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            // 登录
            WFLoginViewController *login = [[WFLoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }break;
        case 1: {
            // 手写板
            CMPMSignatureViewController *sign = [[CMPMSignatureViewController alloc] init];
            [self.navigationController pushViewController:sign animated:YES];
        }break;
        case 2: {
            // 音视频
            WFHomeVideoViewController *video = [[WFHomeVideoViewController alloc] init];
            [self.navigationController pushViewController:video animated:YES];
        }break;
        case 3: {
            // 拍照
        }break;
        case 4: {
            // 摄像
        }break;
        case 5: {
            // 文件上传
        }break;
        case 6: {
            // 文件缓存查看
        }break;
        default:
            break;
    }
}

#pragma mark - Lazy Init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kCommomBackgroundColor;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

@end
