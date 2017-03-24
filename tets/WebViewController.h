//
//  WebViewController.h
//  tets
//
//  Created by lijunjie on 2016/12/14.
//  Copyright © 2016年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property(nonatomic,strong)NSString *url;
@property (nonatomic, copy) NSString *docid;   //唯一标识
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *flag; //标记是从阅读push，还是新闻push，为转到评论做唯一标识
@property (nonatomic, copy) NSString *url_3w;
@end
