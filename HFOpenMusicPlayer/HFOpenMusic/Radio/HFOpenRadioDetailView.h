//
//  HFOpenRadioDetailView.h
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/22.
//

#import <UIKit/UIKit.h>

@interface HFOpenRadioDetailView : UIView

//@property (nonatomic, strong) HFVCompanySheetModel  *sheetModel;
//@property (nonatomic ,copy) NSArray <HFVMemberSheetModel *>*sheets;
-(void)addRaidoDetailViewToView:(UIView *)view;
-(void)showView:(HFOpenChannelSheetModel *)model;
-(void)dismissView;
//-(void)showView;
@end


