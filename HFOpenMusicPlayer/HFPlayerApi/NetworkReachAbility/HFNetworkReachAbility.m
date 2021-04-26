//
//  HFNetworkReachAbility.m
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/18.
//

#import "HFNetworkReachAbility.h"
#import "HFReachability.h"

@interface HFNetworkReachAbility ()

@property (nonatomic, strong) HFReachability *interNetReachability;

@end

@implementation HFNetworkReachAbility

-(instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

-(void)startListenNetWorkStatus {
    // KVO监听，监听kReachabilityChangedNotification的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        // 初始化 Reachability 当前网络环境
        self.interNetReachability = [HFReachability reachabilityForInternetConnection];
        // 开始监听
        [self.interNetReachability startNotifier];
    
    
    
    
//    NetworkStatus netStatus = [self.interNetReachability currentReachabilityStatus];
//    if ([self.delegate respondsToSelector:@selector(reachabilityChanged:)]) {
//        [self.delegate reachabilityChanged:netStatus];
//    }
}

- (void) reachabilityChanged:(NSNotification *)note {
    LPLog(@"网络状态被改变了！！！！");
    // 当前发送通知的 reachability
    HFReachability *reachability = [note object];
    
    // 当前网络环境（在其它需要获取网络连接状态的地方调用 currentReachabilityStatus 方法）
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    // 断言 如果出错则发送错误信息
    NSParameterAssert([reachability isKindOfClass:[HFReachability class]]);
    
    if ([self.delegate respondsToSelector:@selector(reachabilityChanged:)]) {
        [self.delegate reachabilityChanged:netStatus];
    }
}


-(void)stopListenNetWorkStatus {
    // Reachability停止监听网络， 苹果官方文档上没有实现，所以不一定要实现该方法
    [self.interNetReachability stopNotifier];
        
    // 移除Reachability的NSNotificationCenter监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
