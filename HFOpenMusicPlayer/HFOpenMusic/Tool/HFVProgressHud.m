//
//  HFVProgressHud.m
//  HFLivePlayer
//
//  Created by 郭亮 on 2020/12/11.
//

#import "HFVProgressHud.h"

@implementation HFVProgressHud

+(void)showErrorWithError:(NSError *)error {
    if (error && error.userInfo) {
        NSString *status = [HFVKitUtils getErrorMessage:error.userInfo];
        if (status && status.length>0) {
            [HFSVProgressHUD showErrorWithStatus:status];
            [HFSVProgressHUD dismissWithDelay:2];
        }
    }
}

+(void)showInfoWithStatus:(NSString *)status {
    if (status && status.length>0) {
        [HFSVProgressHUD showInfoWithStatus:status];
        [HFSVProgressHUD dismissWithDelay:1];
    }
}

+(void)showSuccessWithStatus:(NSString *)status {
    if (status && status.length>0) {
        [HFSVProgressHUD setSuccessImage:[HFVKitUtils bundleImageWithName:@"success_hud"]];
        [HFSVProgressHUD showSuccessWithStatus:status];

        [HFSVProgressHUD dismissWithDelay:1];
    }
}

+(void)showErrorWithStatus:(NSString *)status {
    if (status && status.length>0) {
        [HFSVProgressHUD showErrorWithStatus:status];
        [HFSVProgressHUD dismissWithDelay:1];
    }
}

@end
