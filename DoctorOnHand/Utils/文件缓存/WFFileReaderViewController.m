//
//  WFFileReaderViewController.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/21.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFFileReaderViewController.h"
#import "WFFileReaderTableView.h"
#import "WFFileReader.h"
#import "WFFileReaderConst.h"
#import "WFFileReaderModel.h"
#import "WFFileReaderManager.h"

@interface WFFileReaderViewController ()

@property (nonatomic, strong) WFFileReaderTableView *tableView;
@property (nonatomic, strong) WFFileReader *fileReader;

@end

@implementation WFFileReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = (_cacheTitle ? _cacheTitle : WFFileReaderTitle);
    
    [self setUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadView {
    [super loadView];
    self.navigationItem.title = @"缓存文件查看";
    self.view.backgroundColor = kWhiteColor;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.navigationController.navigationBar.translucent = NO;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.fileReader) {
        [self.fileReader releaseWFFileReader];
    }
}

#pragma mark - 视图

- (void)setUI {
    typeof(self) __weak weakSelf = self;
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    
    // 点击
    self.tableView.itemClick = ^(NSIndexPath *indexPath) {
        
        if (weakSelf.tableView.isEditing) {
            return ;
        }
        
        WFFileReaderModel *model = weakSelf.cacheArray[indexPath.row];
        // 路径
        NSString *path = model.filePath;
        // 类型
        WFFileReaderType type = model.fileType;
        if (WFFileReaderTypeUnknow == type) {
            // 标题
            NSString *title = model.fileName;
            // 子目录文件
            NSArray *files = [WFFileReaderManager fileModelsWithFilePath:path];
            
            WFFileReaderViewController *cacheVC = [[WFFileReaderViewController alloc] init];
            cacheVC.cacheTitle = title;
            cacheVC.cacheArray = (NSMutableArray *)files;
            [weakSelf.navigationController pushViewController:cacheVC animated:YES];
        } else {
            [weakSelf.fileReader fileReadWithFilePath:path target:weakSelf];
        }
    };
}

#pragma mark - 响应

#pragma mark - 数据

- (void)loadData {
    if (self.cacheArray == nil) {
        // 初始化，首次显示总目录
        NSString *path = [WFFileReaderManager homeDirectoryPath];
        NSArray *array = [WFFileReaderManager fileModelsWithFilePath:path];
        self.cacheArray = [NSMutableArray arrayWithArray:array];
    }
    
    if (self.cacheArray && 0 < self.cacheArray.count) {
        self.tableView.cacheDatas = self.cacheArray;
        [self.tableView reloadData];
    }
}

#pragma mark - getter

- (WFFileReaderTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WFFileReaderTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _tableView;
}

- (WFFileReader *)fileReader {
    if (!_fileReader) {
        _fileReader = [[WFFileReader alloc] init];
    }
    return _fileReader;
}

@end
