//
//  CheckBoxView.m
//  HFOpenMusicPlayerDemo
//
//  Created by 郭亮 on 2021/4/7.
//

#import "CheckBoxView.h"
#import "Masonry.h"

@implementation CheckBoxView

-(instancetype)initWithTitle:(NSString *)title dataArray:(NSArray *)dataArray {
    if (self = [super init]) {
        [self configUIWithTitle:title dataArray:dataArray];
    }
    return self;
}

-(void)configUIWithTitle:(NSString *)title dataArray:(NSArray *)dataArray {
    self.btnArray = [NSMutableArray arrayWithArray:0];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = UIColor.blackColor;
    titleLabel.text = title;
    [self addSubview:titleLabel];
    
    UIButton *buttonA = [[UIButton alloc] init];
    [buttonA setTitle:dataArray[0] forState:UIControlStateNormal];
    [buttonA setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [buttonA setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
    [buttonA setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [buttonA addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    buttonA.imageView.contentMode = UIViewContentModeScaleAspectFit;
    buttonA.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:buttonA];
    [self.btnArray addObject:buttonA];
    
    UIButton *buttonB = [[UIButton alloc] init];
    [buttonB setTitle:dataArray[1] forState:UIControlStateNormal];
    [buttonB setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [buttonB setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
    [buttonB setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [buttonB addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    buttonB.imageView.contentMode = UIViewContentModeScaleAspectFit;
    buttonB.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:buttonB];
    [self.btnArray addObject:buttonB];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    [buttonA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(150);
        make.height.mas_equalTo(20);
        //make.width.mas_equalTo(50);
        make.centerY.equalTo(self);
    }];
    [buttonB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonA.mas_right).offset(0);
        make.height.mas_equalTo(20);
        //make.width.mas_equalTo(50);
        make.centerY.equalTo(self);
    }];
    
    if (dataArray.count>2) {
        UIButton *buttonC = [[UIButton alloc] init];
        [buttonC setTitle:dataArray[2] forState:UIControlStateNormal];
        [buttonC setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [buttonC setImage:[UIImage imageNamed:@"normol"] forState:UIControlStateNormal];
        [buttonC setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [buttonC addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        buttonC.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:buttonC];
        [self.btnArray addObject:buttonC];
        buttonC.titleLabel.font = [UIFont systemFontOfSize:14];
        [buttonC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buttonB.mas_right).offset(0);
            make.height.mas_equalTo(20);
            //make.width.mas_equalTo(50);
            make.centerY.equalTo(self);
        }];
    }
}

-(void)click:(UIButton *)sender {
    if (!sender.selected) {
        //选中
        for (UIButton *btn in self.btnArray) {
            btn.selected = false;
        }
    }
    sender.selected = !sender.selected;
}

-(int)getResult {
    for (int i =0; i<self.btnArray.count; i++) {
        UIButton *btn = self.btnArray[i];
        if (btn.selected) {
            return i;
        }
    }
    return -1;
}
@end
