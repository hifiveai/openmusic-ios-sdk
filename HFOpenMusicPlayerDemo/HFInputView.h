//
//  HFInputView.h
//  HFOpenMusicPlayerDemo
//
//  Created by 郭亮 on 2021/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFInputView : UIView

@property(nonatomic ,strong)UITextField *field;

-(instancetype)initWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
