//
//  LNDownloadManager.h
//  LNDownloader
//
//  Created by Lenny on 2018/12/17.
//

#import <Foundation/Foundation.h>
#import <LNDownloader/LNDownloadConst.h>

@interface LNDownloadManager : NSObject

@property(nonatomic, assign) NSUInteger maxConcurrentDownloadCount;

@property(nonatomic, copy) NSString * downloadFileDirectory;

+(instancetype)defaultManager;


- (void)download:(NSURL *)URL
           state:(LNDownloadStateBlock)stateBlock
        progress:(LNDownloadProgressBlock)progressBlock
      completion:(LNDownloadCompletionBlock)completionBlock;

- (void)download:(NSURL *)URL
        destPath:(NSString *)destPath
           state:(LNDownloadStateBlock)stateBlock
        progress:(LNDownloadProgressBlock)progressBlock
      completion:(LNDownloadCompletionBlock)completionBlock;

#pragma mark - Downloads
- (void)suspendDownloadOfURL:(NSURL *)URL;
- (void)suspendAllDownloads;

- (void)resumeDownloadOfURL:(NSURL *)URL;
- (void)resumeAllDownloads;

- (void)cancelDownloadOfURL:(NSURL *)URL;
- (void)cancelAllDownloads;

#pragma mark - Files

- (NSString *)fileFullPathOfURL:(NSURL *)URL;

- (CGFloat)downloadedProgressOfURL:(NSURL *)URL;

- (void)deleteFile:(NSString *)fileName;
- (void)deleteFileOfURL:(NSURL *)URL;
- (void)deleteAllFiles;
@end
