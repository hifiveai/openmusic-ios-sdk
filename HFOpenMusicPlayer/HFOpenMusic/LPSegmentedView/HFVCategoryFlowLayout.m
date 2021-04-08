//
//  HFVCategoryFlowLayout.m
//  HFVMusicKit
//
//  Created by 郭亮 on 2020/12/7.
//

#import "HFVCategoryFlowLayout.h"

@implementation HFVCategoryFlowLayout

-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    if (attributes && attributes.count>0) {
        UICollectionViewLayoutAttributes *firstAttributes = attributes[0];
        CGRect firFrame = firstAttributes.frame;
        //多出来的偏移量
        float padding = firFrame.origin.x - self.leftMargin;
        NSMutableArray *targetArray = [NSMutableArray arrayWithCapacity:0];
        for (UICollectionViewLayoutAttributes *attribute in attributes) {
            CGRect frame = attribute.frame;
            frame.origin.x = frame.origin.x-padding;
            attribute.frame = frame;
            [targetArray addObject: attribute];
        }
        return [targetArray copy];
    }
    return attributes;
}

@end
