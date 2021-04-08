//
//  HFInputView.m
//  HFOpenMusicPlayerDemo
//
//  Created by 郭亮 on 2021/4/7.
//

#import "HFInputView.h"
#import "Masonry.h"

@interface HFInputView () <UITextFieldDelegate>



@end

@implementation HFInputView

-(instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        [self configUIWithTitle:title];
    }
    return self;
}

-(void)configUIWithTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = UIColor.blackColor;
    titleLabel.text = title;
    [self addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    
    UITextField *field = [[UITextField alloc] init];
    [field addTarget:self action:@selector(myFieldTextChanged:) forControlEvents:UIControlEventValueChanged];
    field.text = 0;
    field.textColor = UIColor.blackColor;
    field.layer.borderWidth = 1;
    field.layer.borderColor = UIColor.blackColor.CGColor;
    field.delegate = self;
    [self addSubview:field];
    _field = field;
    
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(150);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(200);
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}
@end
