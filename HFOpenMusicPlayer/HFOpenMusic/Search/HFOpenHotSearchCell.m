//
//  HFOpenHotSearchCell.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/18.
//

#import "HFOpenHotSearchCell.h"

@interface HFOpenHotSearchCell ()

@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end
@implementation HFOpenHotSearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;
        [self createUI];
    }
    return  self;
}

-(void)createUI {
    self.contentView.backgroundColor = KColorHex(0x282828);
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.rankLabel];
    //[self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.bottomLine];


    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView.mas_left).offset(KScale(25));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(KScale(36));
        make.right.mas_equalTo(KScale(-90));
    }];
//    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.right.mas_equalTo(-KScale(20));
//    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KScale(20));
        make.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(KScale(0.5));
    }];
}

-(void)cellReloadData:(HFOpenMusicModel *)model rank:(NSInteger)rank{
    NSMutableString *detailStr = [NSMutableString stringWithCapacity:0];
    [detailStr appendString:model.musicName];
    NSArray *artists = model.artist;
    if (artists && artists.count>0) {
        NSDictionary *dict= artists[0];
        NSString *name = [dict hfv_objectForKey_Safe:@"name"];
        [detailStr appendString:@" - "];
        [detailStr appendString:name];
    }
    self.nameLabel.text = detailStr;
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",(long)rank];
    if (1<=rank && rank<=3) {
        self.rankLabel.textColor = KColorHex(0xD34747);
    } else {
        self.rankLabel.textColor = KColorHex(0xFFFFFF);
    }
}

#pragma mark - 懒加载---UI
-(UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = KColorHex(0xFFFFFF);//0xD34747
        _rankLabel.font = KFont(14);
        _rankLabel.textAlignment = NSTextAlignmentCenter;
        _rankLabel.text = @"1";
    }
    return _rankLabel;
}

-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = KColorHex(0xFFFFFF);
        _nameLabel.font = KFont(12);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"Something Just Like This - 佚名";
    }
    return _nameLabel;
}
//-(UILabel *)numberLabel {
//    if (!_numberLabel) {
//        _numberLabel = [[UILabel alloc] init];
//        _numberLabel.textColor = KColorHex(0x999999);
//        _numberLabel.font = KFont(12);
//        _numberLabel.textAlignment = NSTextAlignmentRight;
//        _numberLabel.text = @"1825371";
//    }
//    return _numberLabel;
//}
-(UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = KColorHex(0x666666);
    }
    return _bottomLine;
}




@end
