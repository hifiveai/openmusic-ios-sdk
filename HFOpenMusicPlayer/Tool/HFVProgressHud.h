//
//  HFVProgressHud.h
//  HFLivePlayer
//
//  Created by 郭亮 on 2020/12/11.
//

#import <Foundation/Foundation.h>

@interface HFVProgressHud : NSObject

+(void)showErrorWithError:(NSError *)error;

+(void)showErrorWithStatus:(NSString *)status;

+(void)showInfoWithStatus:(NSString *)status;

+(void)showSuccessWithStatus:(NSString *)status;

@end


