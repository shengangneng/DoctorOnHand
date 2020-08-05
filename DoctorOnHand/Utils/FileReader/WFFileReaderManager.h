//
//  WFFileReaderManager.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/21.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFFileReaderConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface WFFileReaderManager : NSObject

/**
 *  @brief 文件model
 *  @param filePath 文件路径
 *  @return NSArray
 */
+ (NSArray *)fileModelsWithFilePath:(NSString *)filePath;

#pragma mark - 文件类型

/**
 *  @brief 判断是否是系统文件夹
 *  @param filePath 文件路径
 *  @return BOOL
 */
+ (BOOL)isFileSystemWithFilePath:(NSString *)filePath;

/**
 *  @brief 筛选所需类型文件
 *  @param type 文件类型
 *  @return BOOL
 */
+ (BOOL)isFilterFileTypeWithFileType:(NSString *)type;

/**
 *  @brief 判断文件类型
 *  @param filePath 文件路径
 *  @return SYCacheFileType
 */
+ (WFFileReaderType)fileTypeReadWithFilePath:(NSString *)filePath;

#pragma mark - 文件类型对应图标

/**
 *  @brief 文件类型对应图标
 *  @param filePath 文件路径
 *  @return UIImage
 */
+ (UIImage *)fileTypeImageWithFilePath:(NSString *)filePath;

#pragma mark - 文件名称与类型

/**
 *  @brief 文件名称（如：hello.png）
 *  @param filePath 文件路径
 *  @return NSString
 */
+ (NSString *)fileNameWithFilePath:(NSString *)filePath;

/**
 *  @brief 文件类型（如：.png）
 *  @param filePath 文件路径
 *  @return NSString
 */
+ (NSString *)fileTypeWithFilePath:(NSString *)filePath;

/**
 *  @brief 文件类型（如：png）
 *  @param filePath 文件路径
 *  @return NSString
 */
+ (NSString *)fileTypeExtensionWithFilePath:(NSString *)filePath;

#pragma mark - 文件目录

#pragma mark 系统目录

/**
 *  @brief Home目录路径
 *  @return NSString
 */
+ (NSString *)homeDirectoryPath;

/**
 *  @brief Document目录路径
 *  @return NSString
 */
+ (NSString *)documentDirectoryPath;

/**
 *  @brief Cache目录路径
 *  @return NSString
 */
+ (NSString *)cacheDirectoryPath;

/**
 *  @brief Library目录路径
 *  @return NSString
 */
+ (NSString *)libraryDirectoryPath;

/**
 *  @brief Tmp目录路径
 *  @return NSString
 */
+ (NSString *)tmpDirectoryPath;

#pragma mark 目录文件

/**
 *  @brief 获取目录列表里所有层级子目录下的所有文件，及目录
 *  @param filePath 文件路径
 *  @return NSArray
 */
+ (NSArray *)subPathsWithFilePath:(NSString *)filePath;

/**
 *  @brief 获取目录列表里当前层级的文件名及文件夹名
 *  @param filePath 文件路径
 *  @return NSArray
 */
+ (NSArray *)subFilesPathsWithFilePath:(NSString *)filePath;

/**
 *  @brief 判断一个文件路径是否是文件夹
 *  @param filePath 文件路径
 *  @return BOOL
 */
+ (BOOL)isFileDirectoryWithFilePath:(NSString *)filePath;

/**
 *  @brief 获取指定文件路径的所有文件夹
 *  @param filePath 文件路径
 *  @return NSArray
 */
+ (NSArray *)subfileDirectionsWithFilePath:(NSString *)filePath;

/**
 *  @brief 获取指定文件路径的所有文件
 *  @param filePath 文件路径
 *  @return NSArray
 */
+ (NSArray *)subfilesWithFilePath:(NSString *)filePath;

#pragma mark - 文件与目录的操作

/**
 *  @brief 文件，或文件夹是否存在
 *  @param filepath 文件路径
 *  @return BOOL
 */
+ (BOOL)isFileExists:(NSString *)filepath;

#pragma mark 文件写入

// 比如NSArray、NSDictionary、NSData、NSString都可以直接调用writeToFile方法写入文件
+ (BOOL)writeFileWithFilePath:(NSString *)filePath data:(id)data;

#pragma mark 文件数据

/**
 *  @brief 指定文件路径的二进制数据
 *  @param filePath 文件路径
 *  @return NSData
 */
+ (NSData *)readFileWithFilePath:(NSString *)filePath;

#pragma mark 文件创建

/**
 *  @brief 新建目录，或文件
 *  @param filePath 新建目录所在的目录
 *  @param fileName 新建目录的目录名称，如xxx，或xxx/xxx，或xxx.png，或xxx/xx.png
 *  @return NSString
 */
+ (NSString *)newFilePathWithPath:(NSString *)filePath name:(NSString *)fileName;

/**
 *  @brief 新建Document目录的目录
 *  @param fileName 新建的目录名称
 *  @return NSString
 */
+ (NSString *)newFilePathDocumentWithName:(NSString *)fileName;

/**
 *  @brief 新建Cache目录下的目录
 *  @param fileName 新建的目录名称
 *  @return NSString
 */
+ (NSString *)newFilePathCacheWithName:(NSString *)fileName;

#pragma mark 文件删除

/**
 *  @brief 删除指定文件路径的文件
 *  @param filepath 文件路径
 *  @return BOOL
 */
+ (BOOL)deleteFileWithFilePath:(NSString *)filePath;

/**
 *  @brief 删除指定目录的所有文件
 *  @param directory 指定目录
 *  @return BOOL
 */
+ (BOOL)deleteFileWithDirectory:(NSString *)directory;

#pragma mark 文件复制

/**
 *  @brief 文件复制
 *  @param fromPath 目标文件路径
 *  @param toPath   复制后文件路径
 *  @return BOOL
 */
+ (BOOL)copyFileWithFilePath:(NSString *)fromPath toPath:(NSString *)toPath;

#pragma mark 文件移动

/**
 *  @brief 文件移动
 *  @param fromPath 移动前位置
 *  @param toPath   移动后位置
 *  @return BOOL
 */

+ (BOOL)moveFileWithFilePath:(NSString *)fromPath toPath:(NSString *)toPath;

#pragma mark 文件重命名

/**
 *  @brief 文件重新名
 *  @param filePath 文件路径
 *  @param newName 文件新名称
 *  @return BOOL
 */
+ (BOOL)renameFileWithFilePath:(NSString *)filePath newName:(NSString *)newName;

#pragma mark - 文件信息

/**
 *  @brief 文件信息字典
 *  @param filePath 文件路径
 *  @return NSDictionary
 */
+ (NSDictionary *)fileAttributesWithFilePath:(NSString *)filePath;

/**
 *  @brief 单个文件的大小 double
 *  @param filePath 文件路径
 *  @return double
 */
+ (double)fileSizeNumberWithFilePath:(NSString *)filePath;

/**
 *  @brief 文件类型转换：数值型转字符型
 *  1MB = 1024KB 1KB = 1024B
 *  @param fileSize 文件大小
 *  @return NSString
 */
+ (NSString *)fileSizeStringConversionWithNumber:(double)fileSize;

/**
 *  @brief 单个文件的大小 String
 *  @param filePath 文件路径
 *  @return String
 */
+ (NSString *)fileSizeStringWithFilePath:(NSString *)filePath;

/**
 *  @brief 遍历文件夹大小 double
 *  @param directory 指定目录
 *  @return double
 */
+ (double)fileSizeTotalNumberWithDirectory:(NSString *)directory;

/**
 *  @brief 遍历文件夹大小 NSString
 *  @param directory 指定目录
 *  @return NSString
 */
+ (NSString *)fileSizeTotalStringWithDirectory:(NSString *)directory;


@end

NS_ASSUME_NONNULL_END
