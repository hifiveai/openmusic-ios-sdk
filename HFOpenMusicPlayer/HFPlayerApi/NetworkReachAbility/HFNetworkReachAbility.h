//
//  HFNetworkReachAbility.h
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/18.
//

#import <Foundation/Foundation.h>
#import "HFReachability.h"

@protocol HFReachabilityProtocol <NSObject>

@optional

-(void)reachabilityChanged:(NetworkStatus) status;

@end

@interface HFNetworkReachAbility : NSObject

@property(nonatomic ,weak)id <HFReachabilityProtocol> delegate;

-(void)startListenNetWorkStatus;
-(void)stopListenNetWorkStatus;

@end


