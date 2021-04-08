//
//  LPSearchHistoryView.m
//  HFVMusicKit
//
//  Created by Pan on 2020/11/20.
//

#import "LPSearchHistoryView.h"

// 搜索历史存储路径
#define PYSearchHistoriesPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HFOpenSearchs.plist"]
#define KHistoryTag 3545

@interface LPSearchHistoryView()

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton  *clearButton;

@property (nonatomic, strong) NSMutableArray<UIButton *>  *historyTagArray;

@end

@implementation LPSearchHistoryView

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"搜索历史";
        _titleLabel.font = KBoldFont(14);
        _titleLabel.textColor = UIColor.whiteColor;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UIButton *)clearButton{
    if (!_clearButton) {
        // 添加清空按钮
        _clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KScale(30), KScale(30))];
        [_clearButton setImage:[HFVKitUtils bundleImageWithName:@"search_clearHistory"] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearHistoryAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}
-(NSMutableArray<UIButton *> *)historyTagArray {
    if (!_historyTagArray) {
        _historyTagArray = [[NSMutableArray alloc] init];
    }
    return _historyTagArray;
}
-(void)setHistoryArray:(NSMutableArray *)historyArray {
    _historyArray = historyArray;
    
//    if (historyArray.count <= 0) {
//        return;
//    }
    [self setupTagViews];
}

-(instancetype)init {
    if (self = [super init]) {
        [self createUI];
        [self requestHistoryData];
    }
    return self;
}

-(void)createUI {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.clearButton];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(KScale(20));
        make.height.mas_equalTo(KScale(20));
        //make.bottom.equalTo(self);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
       make.right.mas_equalTo(-KScale(10));
       make.width.height.mas_equalTo(KScale(25));
        //make.bottom.equalTo(self);
    }];
    
    
}
-(void)setupTagViews{
    
    for (int i = 0; i < self.historyTagArray.count; i++) {
        [self.historyTagArray[i] removeFromSuperview];
    }
    [self.historyTagArray removeAllObjects];
    
    CGFloat x = KScale(20);
    CGFloat y = KScale(32);
    CGFloat height = KScale(24);    // 高度
    CGFloat space = KScale(20);  // 边距
    CGFloat edgSpaceToText = KScale(20);  // 文字距边框距离
    CGFloat interitemSpacing = KScale(10);  // 标签左右距离
    CGFloat lineSpacing = KScale(10);  // 标签上下距离
    NSUInteger rows = 0;
    
    
    for (int i = 0; i < self.historyArray.count; i++) {

        UIButton *button = [self buttonWithTitle:self.historyArray[i]];
        button.tag = KHistoryTag + i;
        [self.historyTagArray addObject:button];
        
        CGFloat width = button.frame.size.width + edgSpaceToText;
        if (x + width + space > KScreenWidth) {
            y += lineSpacing + height;//换行
            x = space; //15位置开始
            rows++;
        }
        //button.frame = CGRectMake(x, y, width, height);
        if (rows<2) {
            [self addSubview:button];
            
            if (i==self.historyArray.count-1 || rows==1) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(x);
                    make.top.equalTo(self).offset(y);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(height);
                    make.bottom.equalTo(self);
                }];
            } else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(x);
                    make.top.equalTo(self).offset(y);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(height);
                }];
            }
        }
        
        
        x += width + interitemSpacing;//宽度+间隙
    }
    
    if (self.historyArray.count <= 0) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.mas_equalTo(KScale(20));
            make.height.mas_equalTo(KScale(20));
            make.bottom.equalTo(self);
        }];
        [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
           make.right.mas_equalTo(-KScale(10));
           make.width.height.mas_equalTo(KScale(25));
            make.bottom.equalTo(self);
        }];
    } else {
//        [self layoutIfNeeded];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.mas_equalTo(KScale(20));
            make.height.mas_equalTo(KScale(20));
            //make.bottom.equalTo(self);
            //make.bottom.equalTo(self.historyTagArray[0].mas_top);
        }];
        [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
           make.right.mas_equalTo(-KScale(10));
           make.width.height.mas_equalTo(KScale(25));
            //make.bottom.equalTo(self.historyTagArray[0].mas_top);
        }];
        //[self layoutIfNeeded];
    }
    
}


- (UIButton *)buttonWithTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = KColorHex(0x282828);
    button.layer.borderColor = KColorHex(0x666666).CGColor;
    button.layer.borderWidth = KScale(1);
    [button setTitleColor:KColorHex(0x999999) forState:UIControlStateNormal];
    button.titleLabel.font = KFont(12);
    button.userInteractionEnabled = YES;
    button.layer.cornerRadius = KScale(12);
    button.layer.masksToBounds = true;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    //超过十个字符用...表示
    if (title && title.length>10) {
        NSString *tempStr = [title substringToIndex:10];
        [button setTitle:[NSString stringWithFormat:@"%@%@",tempStr,@"..."] forState:UIControlStateNormal];
    }else {
        [button setTitle:title forState:UIControlStateNormal];
    }
    [button sizeToFit];
    [button addTarget:self action:@selector(historyTagAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)requestHistoryData {
    self.historyArray = [[NSMutableArray alloc] initWithContentsOfFile: PYSearchHistoriesPath];
    if (!_historyArray) {
        _historyArray = [NSMutableArray arrayWithCapacity:0];
    }
}

//MARK: - 添加搜索记录
-(void)addSearchText:(NSString *)searchString {
    BOOL have = false;
    for (int i = 0; i < self.historyArray.count; i++) {
        if ([searchString isEqualToString:self.historyArray[i]]) {
            [self.historyArray removeObjectAtIndex:i];
            [self.historyArray insertObject:searchString atIndex:0];
            have = true;
            break;
        }
    }
    if (!have) {
        [self.historyArray insertObject:searchString atIndex:0];
    }
    [self.historyArray writeToFile:PYSearchHistoriesPath atomically:YES];
}


/** 点击清空历史按钮 */
- (void)clearHistoryAction {
    // 移除所有历史搜索
    if (self.historyArray.count <= 0) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.historyArray removeAllObjects];
        [self.historyArray writeToFile:PYSearchHistoriesPath atomically:YES];
        [HFVProgressHud showSuccessWithStatus:@"删除成功"];
        [self setupTagViews];
    }];
    
    NSMutableAttributedString *alertMsgStr = [[NSMutableAttributedString alloc] initWithString:@"是否确定清空历史记录？"];
    [alertMsgStr addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(0, alertMsgStr.length)];
    [alertMsgStr addAttribute:NSForegroundColorAttributeName value:KColorHex(0x999999) range:NSMakeRange(0, alertMsgStr.length)];
    [alert setValue:alertMsgStr forKey:@"attributedMessage"];
    [cancle setValue:KColorHex(0x000000) forKey:@"titleTextColor"];
    [sure setValue:KColorHex(0xD34747) forKey:@"titleTextColor"];

    [alert addAction:sure];
    [alert addAction:cancle];
    
    [[HFVKitUtils getViewControllerIn:self] presentViewController:alert animated:true completion:nil];
}

-(void)historyTagAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(historySelectedTag:)]) {
        NSString *searchString = self.historyArray[sender.tag - KHistoryTag];
        [self.delegate historySelectedTag:searchString];
    }
}
@end
