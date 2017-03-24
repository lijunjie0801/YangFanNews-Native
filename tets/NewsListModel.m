//
//  NewsListModel.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/3.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "NewsListModel.h"

@implementation NewsListModel
- (void)dealloc {
 

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
- (CGFloat)cellHeight {
   
    if (self.flag==1) {
         CGSize s=[self.title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
        CGSize s1=[self.source boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
        return 30+s.height+s1.height+90;
    }else{
        return 110;
    }
     
}

@end
