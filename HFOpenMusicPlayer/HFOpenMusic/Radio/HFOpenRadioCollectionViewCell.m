//
//  HFOpenRadioCollectionViewCell.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/22.
//

#import "HFOpenRadioCollectionViewCell.h"
@interface HFOpenRadioCollectionViewCell()

@property (nonatomic, strong) UIImageView  *coverImage;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation HFOpenRadioCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(UIImageView *)coverImage {
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc] init];
        _coverImage.layer.masksToBounds = true;
        _coverImage.layer.cornerRadius = KScale(4);
    }
    return _coverImage;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = KColorHex(0xFFFFFF);
        _nameLabel.font = KFont(14);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

-(void)createUI {
    self.contentView.userInteractionEnabled = YES;
    self.backgroundColor = KColorHex(0x282828);

    [self.contentView addSubview:self.coverImage];
    [self.contentView addSubview:self.nameLabel];
    self.coverImage.backgroundColor = UIColor.grayColor;
    self.nameLabel.text = @"人气爆棚！直播时爱听的歌";


    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(self.coverImage.mas_width);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.coverImage.mas_bottom).offset(KScale(5));
    }];
}

-(void)cellReloadData:(HFOpenChannelSheetModel *)item {
    HFOpenMusicCoverModel *cover = item.cover[0];
    [self.coverImage yy_setImageWithURL:[NSURL URLWithString:cover.url] placeholder:KBoundleImageName(@"music_DefaultImage")];
    self.nameLabel.text = item.sheetName;
}


@end
