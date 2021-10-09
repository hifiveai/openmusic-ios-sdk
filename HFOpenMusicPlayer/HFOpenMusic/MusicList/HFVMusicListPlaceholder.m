//
//  HFVMusicListPlaceholder.m
//  HFVMusicKit
//
//  Created by Pan on 2020/11/23.
//

//MARK: - 音乐列表占位图
#import "HFVMusicListPlaceholder.h"

@implementation HFVMusicListPlaceholder

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KScreenWidth, [HFVGlobalTool shareTool].songListHeight-KScale(55));
        [self createUI];
    }
    return self;
}

-(void)createUI {
    UIView *container = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = KBoundleImageName(@"currentPlayNodata");
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:KBoundleImageName(@"music_listPlaceholder_border") forState:UIControlStateNormal];
    [button setTitle:@"添加歌曲" forState:UIControlStateNormal];
    [button setTitleColor:KColorHex(0xFF8622) forState:UIControlStateNormal];
    button.titleLabel.font = KBoldFont(16);
    [button addTarget:self action:@selector(addMusicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [container addSubview:imageView];
    [container addSubview:button];
    [self addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.height.mas_equalTo(KScale(211));
        make.width.equalTo(self);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container);
        make.centerX.equalTo(container);
        make.size.mas_equalTo(CGSizeMake(KScale(200), KScale(150)));
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(KScale(21));
        make.height.mas_equalTo(KScale(40));
        make.centerX.equalTo(container);
    }];
}

-(void)addMusicButtonAction:(UIButton *)sender {
     
    if ([self.delegate respondsToSelector:@selector(addMusic)]) {
        [self.delegate addMusic];
    }
}

@end
