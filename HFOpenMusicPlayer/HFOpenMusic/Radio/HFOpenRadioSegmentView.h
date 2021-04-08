//
//  HFOpenRadioSegmentView.h
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/22.
//

#import <UIKit/UIKit.h>

@interface HFOpenRadioSegmentView : UIView

@property (nonatomic, assign) BOOL  isShow;
@property (nonatomic ,copy) NSArray *sheets;

-(void)addRaidoStationViewToView:(UIView *)view;
-(void)showSegmentView;
-(void)dismissSegmentView;


@end

