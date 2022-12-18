//
//  LNDownloadTask.m
//  LNDownloader
//
//  Created by Lenny on 2018/12/17.
//

#import "LNDownloadTask.h"

@implementation LNDownloadTask
@synthesize state = _state;

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setState:(LNDownloadState)state
{
    LNDownloadState lastState = _state;
    _state = state;
    if(lastState == LNDownloadStateWaiting || lastState != state){
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.stateBlock){
                self.stateBlock(state);
            }
            if(self.associateTasks.count > 0){
                for (LNDownloadTask *task  in self.associateTasks) {
                    if(task.stateBlock){
                        task.stateBlock(state);
                    }
                }
            }
        });
    }
}

- (NSMutableArray<LNDownloadTask *> *)associateTasks
{
    if(!_associateTasks){
        _associateTasks = [NSMutableArray array];
    }
    return _associateTasks;
}


//- (void)callBackWhenStateChanged
//{
//    LNDownloadState state = _state;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if(self.stateBlock){
//            self.stateBlock(state);
//        }
//        if(self.associateTasks.count > 0){
//            for (LNDownloadTask *task  in self.associateTasks) {
//                if(task.stateBlock){
//                    task.stateBlock(state);
//                }
//            }
//        }
//    });
//}

//- (void)callBackWhenProgressChanged
//{
//    NSInteger receivedSize = _receivedSize;
//    NSInteger expectedSize = _TotalSize;
//    CGFloat progress = 0.0;
//    if(expectedSize != 0){
//        progress = 1.0 * receivedSize / expectedSize;
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if(self.progressBlock){
//            self.progressBlock(receivedSize, expectedSize, progress);
//        }
//        if(self.associateTasks.count > 0){
//            for (LNDownloadTask *task  in self.associateTasks) {
//                if(task.progressBlock){
//                    task.progressBlock(receivedSize, expectedSize, progress);
//                }
//            }
//        }
//    });
//}
//
//- (void)callBackWhenTaskCompletion
//{

//}

- (void)setupWithOtherTask:(LNDownloadTask *)task
{
    self.totalSize = task.totalSize;
    self.receivedSize = task.receivedSize;
    self.fileName = task.fileName;
    self.filePath = task.filePath;
    self.destPath = task.destPath;
    self.URL = task.URL;
    self.state = task.state;
}

- (NSOutputStream *)writeStream
{
    if(!_writeStream){
        _writeStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];
    }
    return _writeStream;
}

- (void)openWriteStream
{
    if(!_writeStream){
        return;
    }
    [_writeStream open];
}

- (void)closeWriteStream
{
    if (!_writeStream) {
        return;
    }
    if (_writeStream.streamStatus > NSStreamStatusNotOpen && _writeStream.streamStatus < NSStreamStatusClosed) {
        [_writeStream close];
    }
    _writeStream = nil;
}




@end
