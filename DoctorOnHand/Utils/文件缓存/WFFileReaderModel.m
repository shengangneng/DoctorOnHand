//
//  WFFileReaderModel.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/21.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFFileReaderModel.h"
#import "WFFileReaderManager.h"

@implementation WFFileReaderModel

- (NSString *)fileSize {
    if (self.fileType == WFFileReaderTypeUnknow) {
        return [WFFileReaderManager fileSizeTotalStringWithDirectory:self.filePath];
    }
    return [WFFileReaderManager fileSizeStringWithFilePath:self.filePath];
}

- (WFFileReaderType)fileType {
    return [WFFileReaderManager fileTypeReadWithFilePath:self.filePath];
}

@end
