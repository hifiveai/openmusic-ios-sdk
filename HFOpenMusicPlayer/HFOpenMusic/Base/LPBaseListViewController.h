//
//  LPBaseListViewController.h
//  HFVMusicKit
//
//  Created by Pan on 2020/11/12.
//

#import <UIKit/UIKit.h>
#import "LPMJGifHeader.h"
#import "LPMJGifFooter.h"


NS_ASSUME_NONNULL_BEGIN

@interface LPBaseListViewController : UIViewController

@property (nonatomic, strong) UITableView     *myTableView;
@property (nonatomic, strong) LPMJGifHeader  *mjHeaderView;
@property (nonatomic, strong) LPMJGifFooter  *mjFooterView;


-(void)refreshAction;
-(void)loadMoreAction;
-(void)endRefresh;

@end

NS_ASSUME_NONNULL_END
