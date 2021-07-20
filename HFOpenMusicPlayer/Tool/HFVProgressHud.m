//
//  HFVProgressHud.m
//  HFLivePlayer
//
//  Created by 郭亮 on 2020/12/11.
//

#import "HFVProgressHud.h"
#import <SVProgressHUD/SVProgressHUD.h>
@implementation HFVProgressHud

+(void)showErrorWithError:(NSError *)error {
    if (error && error.userInfo) {
        NSString *status = [HFVKitUtils getErrorMessage:error.userInfo];
        if (status && status.length>0) {
            [SVProgressHUD showErrorWithStatus:status];
            [SVProgressHUD dismissWithDelay:2];
        }
    }
}

+(void)showInfoWithStatus:(NSString *)status {
    if (status && status.length>0) {
        [SVProgressHUD showInfoWithStatus:status];
        [SVProgressHUD dismissWithDelay:1];
    }
}

+(void)showSuccessWithStatus:(NSString *)status {
    if (status && status.length>0) {
        [SVProgressHUD setSuccessImage:[HFVKitUtils bundleImageWithName:@"success_hud"]];
        [SVProgressHUD showSuccessWithStatus:status];

        [SVProgressHUD dismissWithDelay:1];
    }
}

+(void)showErrorWithStatus:(NSString *)status {
    if (status && status.length>0) {
        [SVProgressHUD showErrorWithStatus:status];
        [SVProgressHUD dismissWithDelay:1];
    }
}

@end
