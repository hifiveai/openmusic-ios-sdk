//
//  HFOpenRadioListControllerViewController.h
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/22.
//

#import "LPBaseCollectionViewController.h"
#import "HFOpenRadioDetailView.h"

@interface HFOpenRadioListViewController : LPBaseCollectionViewController

@property (nonatomic, strong) HFOpenRadioDetailView  *detailView;
@property (nonatomic, copy) NSString *groupId;

@end


