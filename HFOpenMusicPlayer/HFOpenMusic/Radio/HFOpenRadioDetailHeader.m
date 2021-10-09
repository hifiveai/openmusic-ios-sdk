//
//  HFOpenRadioDetailHeader.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/22.
//

#import "HFOpenRadioDetailHeader.h"
@interface HFOpenRadioDetailHeader()

//@property (nonatomic, strong) HFVCompanySheetModel  *musicModel;
@property (nonatomic, strong) UIImageView  *coverImage;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *introduceLalbel;
@property (nonatomic, strong) UILabel  *tagLabel;

@end
@implementation HFOpenRadioDetailHeader

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, KScreenWidth, KScale(160));
        //self.backgroundColor = [KColorHex(0x000000) colorWithAlphaComponent:0.61];
        self.backgroundColor = KColorHex(0x282828);
        [self createUI];
    }
    return self;
}

-(void)reloadData:(HFOpenChannelSheetModel *)model {
    HFOpenMusicCoverModel *cover = model.cover[0];
    [self.coverImage yy_setImageWithURL:[NSURL URLWithString:cover.url] placeholder:KBoundleImageName(@"music_DefaultImage")];
    self.titleLabel.text = model.sheetName;
    self.introduceLalbel.text = model.describe;
    NSArray *tags = model.tag;
    NSMutableString *tagStr = [NSMutableString stringWithCapacity:0];
    for (HFOpenChannelSheetTagModel *tagModel in tags) {
        if (tagModel.tagName && tagModel.tagName.length>0) {
            [tagStr appendString:@"，"];
            [tagStr appendString:tagModel.tagName];
        }
    }
    if (tagStr && tagStr.length>0) {
        [tagStr deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    self.tagLabel.text = tagStr;
}


-(UIImageView *)coverImage{
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc] init];
        _coverImage.layer.masksToBounds = true;
        _coverImage.layer.cornerRadius = KScale(5);
        _coverImage.backgroundColor = UIColor.redColor;
    }
    return _coverImage;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = KBoldFont(14);
        _titleLabel.textColor = KColorHex(0xFFFFFF);
    }
    return _titleLabel;
}
-(UILabel *)introduceLalbel {
    if (!_introduceLalbel) {
        _introduceLalbel = [[UILabel alloc] init];
        _introduceLalbel.font = KFont(11);
        _introduceLalbel.textColor = KColorHex(0x999999);
        _introduceLalbel.numberOfLines = 2;
    }
    return _introduceLalbel;
}
-(UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = KFont(11);
        _tagLabel.textColor = KColorHex(0xFFFFFF);
    }
    return _tagLabel;
}


-(void)createUI {
    
    [self addSubview:self.coverImage];
    [self addSubview:self.titleLabel];
    [self addSubview:self.introduceLalbel];
    [self addSubview:self.tagLabel];

    [self.coverImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KScale(45));
        make.left.mas_equalTo(KScale(20));
        make.width.height.mas_equalTo(KScale(100));
    }];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImage.top);
        make.left.mas_equalTo(self.coverImage.right).offset(KScale(10));
        make.right.mas_equalTo(-KScale(20));
    }];
    [self.introduceLalbel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.bottom).offset(KScale(6));
        make.height.mas_equalTo(KScale(45));
    }];
    
    [self.tagLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self.coverImage.bottom);
        make.height.mas_equalTo(KScale(15));
    }];

}


/// 解析tag
//-(NSString *)getTagString:(NSArray<HFVTagModel *> *)tagArray {
//    NSString *tagString = @"";
//    for (int i = 0; i < tagArray.count; i ++) {
//        if (tagString.length > 0) {
//            tagString = [tagString stringByAppendingString:@"，"];
//        }
//        tagString = [tagString stringByAppendingString:tagArray[i].tagName];
//
//        if (tagString.length > 0 && [self getTagString:tagArray[i].child].length > 0) {
//            tagString = [tagString stringByAppendingString:@"，"];
//            tagString = [tagString stringByAppendingString:[self getTagString:tagArray[i].child]];
//        }
//    }
//    return tagString;
//}


@end
