//
//  LNViewController.m
//  LNDownloader
//
//  Created by dongjianxiong on 12/17/2022.
//  Copyright (c) 2022 dongjianxiong. All rights reserved.
//

#import "LNViewController.h"
#import <LNDownloader/LNDownloadManager.h>

@interface DownloadTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *downloadStateLabel;
@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, assign) LNDownloadState state;
@property(nonatomic, assign) CGFloat progress;


@end

@implementation DownloadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 40)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.downloadStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 60, 40)];
        self.downloadStateLabel.textColor = [UIColor redColor];
        self.downloadStateLabel.font = [UIFont systemFontOfSize:14];
        self.downloadStateLabel.text = @"点击下载";
        [self.contentView addSubview:self.downloadStateLabel];
        
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(60, 60, self.contentView.frame.size.width - 160, 10)];
        self.progressView.progressTintColor = [UIColor blueColor];
        [self.contentView addSubview:self.progressView];
        
        
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 60, 40, 100, 40)];
        self.progressLabel.font = [UIFont systemFontOfSize:14];
        self.progressLabel.textColor = [UIColor greenColor];
        self.progressLabel.text = @"0.0%";
        [self.contentView addSubview:self.progressLabel];
        
        
//        self.titleLabel.backgroundColor = [UIColor grayColor];
//        self.downloadStateLabel.backgroundColor = [UIColor yellowColor];
////        self.progressView.backgroundColor = [UIColor cyanColor];
//        self.progressLabel.backgroundColor = [UIColor orangeColor];
        
    
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.progressView.progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", (progress * 100.0)];
}

- (void)setState:(LNDownloadState)state
{
    _state = state;
    self.downloadStateLabel.text = [self textWithState:state];
}

- (NSString *)textWithState:(LNDownloadState)state
{
    NSString *str = @"等待下载";
    switch (state) {
        case LNDownloadStateWaiting:
            str = @"等待下载";
            break;
        case LNDownloadStateRunning:
            str = @"正在下载";
            break;
        case LNDownloadStateSuspended:
            str = @"暂停下载";
            break;
        case LNDownloadStateCanceled:
            str = @"已经取消";
            break;
        case LNDownloadStateCompleted:
            str = @"下载完成";
            break;
        case LNDownloadStateFailed:
            str = @"下载失败";
            break;
        default:
            break;
    }
    return str;
}


@end


@interface LNViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *downloadUrlList;

@end

@implementation LNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.view addSubview:self.tableView];
    
    self.downloadUrlList = @[@"https://issuepcdn.baidupcs.com/issue/netdisk/MACguanjia/4.16.2/BaiduNetdisk_mac_4.16.2_x64.dmg",
         @"https://issuepcdn.baidupcs.com/issue/netdisk/MACguanjia/4.16.2/BaiduNetdisk_mac_4.16.2_arm64.dmg",
         @"https://issuepcdn.baidupcs.com/issue/netdisk/yunguanjia/BaiduNetdisk_7.23.0.10.exe",
         @"https://issuepcdn.baidupcs.com/issue/netdisk/LinuxGuanjia/4.15.6/baidunetdisk-4.15.6.x86_64.rpm",
         @"https://issuepcdn.baidupcs.com/issue/netdisk/LinuxGuanjia/4.15.6/baidunetdisk_4.15.6_amd64.deb",
                             @"https://issuepcdn.baidupcs.com/issue/netdisk/LinuxGuanjia/4.15.6/baidunetdisk_4.15.6_amd64.deb",
                             @"https://issuepcdn.baidupcs.com/issue/netdisk/LinuxGuanjia/4.15.6/baidunetdisk_4.15.6_amd64.deb",
                             @"https://issuepcdn.baidupcs.com/issue/netdisk/LinuxGuanjia/4.15.6/baidunetdisk_4.15.6_amd64.deb",
    ];
    
    [LNDownloadManager defaultManager].maxConcurrentDownloadCount = 2;

	// Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downloadUrlList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DownloadTableViewCell";
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[DownloadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *urlStr = self.downloadUrlList[indexPath.row];
    NSURL *url = [NSURL URLWithString:urlStr];
    cell.titleLabel.text = [url lastPathComponent];
    CGFloat progress = [[LNDownloadManager defaultManager] downloadedProgressOfURL:url];
    cell.progress = progress;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlStr = self.downloadUrlList[indexPath.row];
    NSURL *url = [NSURL URLWithString:urlStr];
    DownloadTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.state == LNDownloadStateWaiting || cell.state == LNDownloadStateCanceled){
        [[LNDownloadManager defaultManager] download:url destPath:nil state:^(LNDownloadState state) {
            cell.state = state;
//            NSLog(@"state:%@", cell.downloadStateLabel.text);
        } progress:^(NSInteger receiveSize, NSInteger expectedSize, CGFloat progress) {
//            NSLog(@"receiveSize:%@, totalSize:%@", @(receiveSize), @(expectedSize));
            cell.progress = progress;
        } completion:^(BOOL isSuccess, NSString *filePath, NSError *error) {
            if(isSuccess){
                NSLog(@"Download succeed@");
            }else{
                NSLog(@"Download fail with error:%@", error);
            }
        }];
    }else if(cell.state == LNDownloadStateRunning){
        [[LNDownloadManager defaultManager] suspendDownloadOfURL:url];
    }else if(cell.state == LNDownloadStateCompleted){
        [[LNDownloadManager defaultManager] deleteFileOfURL:url];
        CGFloat progress = [[LNDownloadManager defaultManager] downloadedProgressOfURL:url];
        cell.progress = progress;
        cell.state = LNDownloadStateWaiting;
        cell.downloadStateLabel.text = @"点击下载";
    }else if (cell.state == LNDownloadStateFailed){
        cell.state = LNDownloadStateWaiting;
        cell.downloadStateLabel.text = @"重新下载";
        [[LNDownloadManager defaultManager] cancelDownloadOfURL:url];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
