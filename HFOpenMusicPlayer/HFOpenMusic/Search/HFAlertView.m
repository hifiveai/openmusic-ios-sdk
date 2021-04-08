//
//  HFAlertView.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/22.
//

#import "HFAlertView.h"
@interface HFAlertView()

@property(nonatomic ,strong)UIView *contentView;
@property(nonatomic ,strong)UIButton *sureBtn;
@property(nonatomic ,strong)UIButton *neverBtn;

@end

@implementation HFAlertView

-(instancetype)init {
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}

-(void)configUI {
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
    
    //子view
    UIView *contenView = [[UIView alloc] init];
    contenView.backgroundColor = UIColor.whiteColor;
    contenView.layer.cornerRadius = KScale(10);
    _contentView = contenView;
    [self addSubview:contenView];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"歌曲将加入到收藏列表·····";
    titleLabel.textColor = KColorHex(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:14];
    [contenView addSubview:titleLabel];
    UIImageView *imageView = [[UIImageView alloc] init];
    [contenView addSubview:imageView];
    UIButton *neverBtn = [[UIButton alloc] init];
    [neverBtn setTitle:@"不再提示" forState:UIControlStateNormal];
    [neverBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [neverBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [neverBtn setTitleColor:KColorHex(0x999999) forState:UIControlStateNormal];
    neverBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _neverBtn = neverBtn;
    [contenView addSubview:neverBtn];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.backgroundColor = UIColor.whiteColor;
    sureBtn.layer.cornerRadius = KScale(10);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn = sureBtn;
    [self addSubview:sureBtn];
    
    [contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(KScale(10));
        make.right.equalTo(self).offset(KScale(-10));
        make.height.mas_equalTo(KScale(214));
        //make.top.equalTo(self.mas_bottom);
        make.bottom.equalTo(self).offset(KScale(214));
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(KScale(10));
        make.right.equalTo(self).offset(KScale(-10));
        make.height.mas_equalTo(KScale(52));
        //make.top.equalTo(self.mas_bottom).offset(KScale(222));
        make.bottom.equalTo(self).offset(KScale(274));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contenView).offset(KScale(20));
        make.centerX.equalTo(contenView);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(KScale(20));
        make.centerX.equalTo(contenView);
        make.width.mas_equalTo(KScale(335));
        make.height.mas_equalTo(KScale(86));
    }];
    [neverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(KScale(20));
        make.centerX.equalTo(contenView);
    }];
}

-(void)sureBtnClick {
    //下降动画
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2f animations:^{
        [self->_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(KScale(214));
        }];
        [self->_sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(KScale(274));
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //上升动画
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2f animations:^{
        [self->_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(KScale(-104));
        }];
        [self->_sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(KScale(-44));
        }];
        [self layoutIfNeeded];
    }];
}

@end
