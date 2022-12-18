//
//  LNDownloadConst.h
//  LNDownloader
//
//  Created by Lenny on 2022/12/18.
//

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, LNDownloadState) {
    LNDownloadStateWaiting,
    LNDownloadStateRunning,
    LNDownloadStateSuspended,
    LNDownloadStateCanceled,
    LNDownloadStateCompleted,
    LNDownloadStateFailed
};

typedef void(^LNDownloadStateBlock)(LNDownloadState state);

typedef void(^LNDownloadProgressBlock)(NSInteger receiveSize, NSInteger expectedSize, CGFloat progress);

typedef void(^LNDownloadCompletionBlock)(BOOL isSuccess, NSString  *filePath, NSError *error);



@interface LNDownloadConst : NSObject

@end

//NS_ASSUME_NONNULL_END
