//
//  WFFileReaderTableView.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/21.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFFileReaderTableView.h"
#import "WFFileReaderTableViewCell.h"
#import "WFFileReaderModel.h"
#import "WFFileReaderManager.h"

@interface WFFileReaderTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSIndexPath *previousIndex;

@end

@implementation WFFileReaderTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[WFFileReaderTableViewCell class] forCellReuseIdentifier:reuseWFFileReaderDirectoryCell];
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cacheDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return heightWFFileReaderDirectoryCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFFileReaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseWFFileReaderDirectoryCell];
    // 数据
    WFFileReaderModel *model = self.cacheDatas[indexPath.row];
    cell.model = model;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WFFileReaderModel *model = self.cacheDatas[indexPath.row];
    
    // 音频播放
    WFFileReaderType type = [WFFileReaderManager fileTypeReadWithFilePath:model.filePath];
    if (WFFileReaderTypeAudio == type) {
        model.fileProgressShow = YES;
        NSString *currentPath = model.filePath;
        
        if (self.previousIndex) {
            WFFileReaderModel *previousModel = self.cacheDatas[self.previousIndex.row];
            NSString *previousPath = previousModel.filePath;
            if (![currentPath isEqualToString:previousPath]) {
                previousModel.fileProgress = 0.0;
                previousModel.fileProgressShow = NO;
            }
        }
        
        self.previousIndex = indexPath;
    }

    // 回调响应
    if (self.itemClick) {
        self.itemClick(indexPath);
    }
}

#pragma mark 编辑

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WFFileReaderModel *model = self.cacheDatas[indexPath.row];
        // 系统数据不可删除
        if ([WFFileReaderManager isFileSystemWithFilePath:model.filePath]) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"系统文件不能删除" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
            return;
        }
        
        // 删除数据：删除数组、删除本地文件/文件夹、刷新页面、发通知刷新文件大小统计
        // 删除数组
        [self.cacheDatas removeObjectAtIndex:indexPath.row];
        // 删除本地文件/文件夹
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL isDelete = [WFFileReaderManager deleteFileWithDirectory:model.filePath];
        });
        // 刷新页面
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
