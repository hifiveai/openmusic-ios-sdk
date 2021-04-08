//
//  CheckBoxView.h
//  HFOpenMusicPlayerDemo
//
//  Created by 郭亮 on 2021/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckBoxView : UIView


@property(nonatomic ,strong)NSMutableArray *btnArray;
//@property(nonatomic ,strong)NSArray *Array;

-(instancetype)initWithTitle:(NSString *)title dataArray:(NSArray *)dataArray;
-(int)getResult;
@end

NS_ASSUME_NONNULL_END
