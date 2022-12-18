//
//  LNDownloadTask.h
//  LNDownloader
//
//  Created by Lenny on 2018/12/17.
//

#import <Foundation/Foundation.h>
#import <LNDownloader/LNDownloadConst.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNDownloadTask : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *destPath;
/** Stream to write datas to the dest file*/
@property (nonatomic, strong) NSOutputStream *writeStream;

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, assign) NSInteger receivedSize;

@property (nonatomic, assign) NSInteger totalSize;

@property (nonatomic, assign) LNDownloadState state;

@property (nonatomic, copy) LNDownloadStateBlock stateBlock;

@property (nonatomic, copy) LNDownloadProgressBlock progressBlock;

@property (nonatomic, copy) LNDownloadCompletionBlock completionBlock;

/** Associate tasks with the same URL*/
@property (nonatomic, strong) NSMutableArray <LNDownloadTask *> * associateTasks;
- (void)setupWithOtherTask:(LNDownloadTask *)task;

- (void)openWriteStream;
- (void)closeWriteStream;

@end

NS_ASSUME_NONNULL_END
