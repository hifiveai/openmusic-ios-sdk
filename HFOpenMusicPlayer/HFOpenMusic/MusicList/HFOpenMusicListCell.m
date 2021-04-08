//
//  HFVMusicListCell.m
//  HFVMusicKit
//
//  Created by Pan on 2020/11/4.
//

#import "HFOpenMusicListCell.h"


@interface HFOpenMusicListCell ()

@property (nonatomic, strong) HFOpenMusicModel  *model;
@property (nonatomic, assign) BOOL  isPlaying;
//@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) FLAnimatedImageView *playAnimation;


@end

@implementation HFOpenMusicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = KColorHex(0x282828);
        [self createUI];
    }
    return  self;
}


//-(UILabel *)numberLabel {
//    if (!_numberLabel) {
//        _numberLabel = [[UILabel alloc] init];
//        _numberLabel.textColor = KColorHex(0x282828);
//        _numberLabel.font = KFont(15);
//        _numberLabel.textAlignment = NSTextAlignmentCenter;
//        _numberLabel.text = @"1";
//    }
//    return _numberLabel;
//}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = KColorHex(0xFFFFFF);
        _nameLabel.font = KFont(14);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"原始数据哈哈哈哈哈";
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
-(UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setTitleColor:KColorHex(0x282828) forState:UIControlStateNormal];
        [_deleteButton setImage:[HFVKitUtils bundleImageWithName:@"music_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
-(FLAnimatedImageView *)playAnimation {
    if (!_playAnimation) {
        _playAnimation = [[FLAnimatedImageView alloc] init];
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HFOpenMusic" ofType:@"bundle"]];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[bundle pathForResource:@"playingAnimation" ofType:@"gif"]]];
        _playAnimation.animatedImage = image;
        _playAnimation.hidden = YES;
    }
    return _playAnimation;
}

-(void)createUI {
    [self.contentView addSubview:self.playAnimation];
    //[self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.deleteButton];
    
    [self.playAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(KScale(15));
        make.width.height.mas_equalTo(KScale(16));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(self.playAnimation.hidden?KScale(15):KScale(41));
        make.width.mas_lessThanOrEqualTo(KScale(150));
        //make.right.mas_equalTo(KScale(-50));
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self.contentView);
        make.width.height.mas_equalTo(KScale(40));
    }];
}

-(void)setShowDelete:(BOOL)showDelete {
    _showDelete = showDelete;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.right).offset(10);
        make.centerY.equalTo(self.contentView);
        self.showDelete?make.right.mas_lessThanOrEqualTo(self.deleteButton.mas_left).offset(-KScale(10)):
        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-KScale(10))
        ;
    }];
}

-(void)cellReloadPlayingStatus:(BOOL)isPlaying {
   
}


//MARK: - 删除弹窗提示
- (void)deleteButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteMusic:)]) {
        [self.delegate deleteMusic:self.model];
    }
}


-(void)cellReloadData:(HFOpenMusicModel *)item rank:(NSInteger)rank {
    HFOpenMusicModel *model = item;
    _model = model;
    _nameLabel.text = model.musicName;
    NSMutableString *detailStr = [NSMutableString stringWithCapacity:0];
    NSArray *artistAry = model.artist;
    if (artistAry && artistAry.count>0) {
        for (NSDictionary *dic in artistAry) {
            [detailStr appendString:@"，"];
            [detailStr appendString:[dic hfv_objectForKey_Safe:@"name"]];
        }
        [detailStr deleteCharactersInRange:NSMakeRange(0, 1)];
        [detailStr appendString:@"-"];
    }
    [detailStr appendString:model.albumName];
    _detailLabel.text = detailStr;
    if (item.isPlaying) {
        self.nameLabel.textColor = KColorHex(0xD34747);
        self.detailLabel.textColor = KColorHex(0xD34747);
        self.playAnimation.hidden = false;
        [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(self.playAnimation.hidden?KScale(15):KScale(41));
            make.width.mas_lessThanOrEqualTo(KScale(150));
        }];
    } else {
        self.nameLabel.textColor = KColorHex(0xFFFFFF);
        self.detailLabel.textColor = KColorHex(0x999999);
        self.playAnimation.hidden = true;
        [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(self.playAnimation.hidden?KScale(15):KScale(41));
            make.width.mas_lessThanOrEqualTo(KScale(150));
        }];
    }
    self.deleteButton.hidden = !_showDelete;
}

@end
