//
//  HFOpenSearchResultCell.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/18.
//

#import "HFOpenSearchResultCell.h"

@interface HFOpenSearchResultCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
//@property (nonatomic, strong) UIButton *likeButton;
//@property (nonatomic, strong) UIButton *kButton;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) HFOpenMusicModel *model;

@end

@implementation HFOpenSearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self configUI];
    }
    return  self;
}

-(void)cellReloadData:(HFOpenMusicModel *)model {
    _model = model;
    _nameLabel.text = model.musicName;
    NSMutableString *detailStr = [NSMutableString stringWithCapacity:0];
    NSArray *artistAry = model.artist;
    if (artistAry && artistAry.count>0) {
        for (NSDictionary *dic in artistAry) {
            [detailStr appendString:@"，"];
            [detailStr appendString:[dic hfv_objectForKey_Safe:@"name"]];
        }
        if (detailStr && detailStr.length>0) {
            [detailStr deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        [detailStr appendString:@"-"];
    }
    [detailStr appendString:model.albumName];
    _detailLabel.text = detailStr;
}

#pragma mark - Action
//-(void)likeButtonAction:(UIButton *)sender {
//    sender.selected = !sender.selected;
//}
//
//-(void)kSongButtonAction:(UIButton *)sender {
//    sender.selected = !sender.selected;
//}

#pragma mark - UI
-(void)configUI {
    self.backgroundColor = KColorHex(0x282828);
   
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
//    [self.contentView addSubview:self.likeButton];
//    [self.contentView addSubview:self.kButton];
   // [self.contentView addSubview:self.bottomLine];

    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(KScale(KScale(15)));
        make.width.mas_lessThanOrEqualTo(KScale(KScale(100)));
        make.right.equalTo(self.detailLabel.mas_left).offset(-KScale(10));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-KScale(20));
    }];
//    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.right.mas_equalTo(KScale(-60));
//        make.width.height.mas_equalTo(KScale(20));
//    }];
//    [self.kButton mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.centerY.equalTo(self.contentView);
//           make.right.mas_equalTo(KScale(-20));
//           make.width.height.mas_equalTo(KScale(20));
//    }];
//    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(KScale(20));
//        make.bottom.right.equalTo(self.contentView);
//        make.height.mas_equalTo(KScale(0.5));
//    }];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.detailLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - 懒加载---UI
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = KColorHex(0xFFFFFF);
        _nameLabel.font = KFont(14);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
-(UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = KColorHex(0x999999);
        _detailLabel.font = KFont(11);
        _detailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _detailLabel;
}
//-(UIButton *)likeButton {
//    if (!_likeButton) {
//        _likeButton = [[UIButton alloc] init];
//        [_likeButton setImage:[HFVKitUtils bundleImageWithName:@"music_joinMyLike"] forState:UIControlStateNormal];
//        [_likeButton setImage:[HFVKitUtils bundleImageWithName:@"music_joinMyLike_s"] forState:UIControlStateSelected];
//        [_likeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _likeButton;
//}
//-(UIButton *)kButton {
//    if (!_kButton) {
//        _kButton = [[UIButton alloc] init];
//        [_kButton setImage:[HFVKitUtils bundleImageWithName:@"music_joinKSong"] forState:UIControlStateNormal];
//        [_kButton setImage:[HFVKitUtils bundleImageWithName:@"music_joinKSong_s"] forState:UIControlStateSelected];
//        [_kButton addTarget:self action:@selector(kSongButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _kButton;
//}
-(UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = KColorHex(0xEBEBEB);
    }
    return _bottomLine;
}


@end
