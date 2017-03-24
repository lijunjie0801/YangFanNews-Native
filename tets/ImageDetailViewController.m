//
//  ImageDetailViewController.m
//  tets
//
//  Created by lijunjie on 2017/1/4.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "UIImageView+WebCache.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface ImageDetailViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imgView;


//@property (nonatomic) CGFloat width;
//@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat currentScale;
@property (nonatomic) CGFloat offsetY;
@end

@implementation ImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setview];
}
-(void)setview{
    CellModel *model=(CellModel *)self.imageArray[self.index];
//    UIImageView *imageview=[[UIImageView alloc]initWithFrame:self.view.bounds];
//    [imageview sd_setImageWithURL:[NSURL URLWithString:model.imgURL]];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 5.0;
    CGFloat ratio = model.imgWidth/model.imgHeight*SCREEN_HEIGHT/SCREEN_WIDTH;
    CGFloat min = MIN(ratio, 1.0);
    _scrollView.minimumZoomScale = min;
    
    CGFloat height = model.imgHeight/model.imgWidth * SCREEN_WIDTH;
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.contentOffset.x+100, _scrollView.contentOffset.y+230, 10, 10)];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imgURL]];
    
    CGFloat y = (SCREEN_HEIGHT - height)/2.0;
    _offsetY = 0.0-y;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
    [_scrollView addSubview:_imgView];
    _scrollView.contentOffset = CGPointMake(0, 0.0-y);

    [UIView animateWithDuration:0.6
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         _imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                         self.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                     }
     ];
    
    
    UITapGestureRecognizer *tapImgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandle)];
    tapImgView.numberOfTapsRequired = 1;
    tapImgView.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapImgView];
    
    UITapGestureRecognizer *tapImgViewTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandleTwice:)];
    tapImgViewTwice.numberOfTapsRequired = 2;
    tapImgViewTwice.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapImgViewTwice];
    [tapImgView requireGestureRecognizerToFail:tapImgViewTwice];
    
    
    
//    UITapGestureRecognizer *saveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveTapHandler)];
//    UIButton *save = [commonFunctions generateImage:@"save-pic-button.png" hover:@"save-pic-button-hover.png" withX:245 withY:420];
//    [save addGestureRecognizer:saveTap];
//    [self.view addSubview:save];
    
//    _activityIndicatorView = [commonFunctions generateActivityIndicatorView];
//    [self.view addSubview:_activityIndicatorView];
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    _currentScale = scale;
    NSLog(@"current scale:%f",scale);
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imgView;
}
//-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    //当捏或移动时，需要对center重新定义以达到正确显示未知
//    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
//    NSLog(@"adjust position,x:%f,y:%f",xcenter,ycenter);
//    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
//    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
//    //双击放大时，图片不能越界，否则会出现空白。因此需要对边界值进行限制。
////    if(_isDoubleTapingForZoom){
//        NSLog(@"taping center");
//        xcenter = 2*(SCREEN_WIDTH - cgrectgetce);
//        ycenter = 2*(SCREEN_HEIGHT - _touchY);
//        if(xcenter > (kMaxZoom - 0.5)*kScreenWidth){//放大后左边超界
//            xcenter = (kMaxZoom - 0.5)*kScreenWidth;
//        }else if(xcenter <0.5*kScreenWidth){//放大后右边超界
//            xcenter = 0.5*kScreenWidth;
//        }
//        if(ycenter > (kMaxZoom - 0.5)*kScreenHeight){//放大后左边超界
//            ycenter = (kMaxZoom - 0.5)*kScreenHeight +_offsetY*kMaxZoom;
//        }else if(ycenter <0.5*kScreenHeight){//放大后右边超界
//            ycenter = 0.5*kScreenHeight +_offsetY*kMaxZoom;
//        }
//        NSLog(@"adjust postion sucess, x:%f,y:%f",xcenter,ycenter);
//  //  }
//    [_imgView setCenter:CGPointMake(xcenter, ycenter)];
//}
#pragma mark - tap
//-(void)tapImgViewHandle{
//    NSLog(@"%d",_isTwiceTaping);
//    if(_isTwiceTaping){
//        return;
//    }
//    NSLog(@"tap once");
//    
//    [UIView animateWithDuration:0.6
//                          delay:0.0
//                        options: UIViewAnimationCurveEaseOut
//                     animations:^{
//                         _imgView.frame = CGRectMake(_scrollView.contentOffset.x+100, _scrollView.contentOffset.y+230, 10, 10);
//                         self.alpha = 0.0;
//                     }
//                     completion:^(BOOL finished){
//                         [self removeFromSuperview];
//                     }
//     ];
//    
//}
//-(void)tapImgViewHandleTwice:(UIGestureRecognizer *)sender{
//    _touchX = [sender locationInView:sender.view].x;
//    _touchY = [sender locationInView:sender.view].y;
//    if(_isTwiceTaping){
//        return;
//    }
//    _isTwiceTaping = YES;
//    
//    NSLog(@"tap twice");
//    
//    if(_currentScale > 1.0){
//        _currentScale = 1.0;
//        [_scrollView setZoomScale:1.0 animated:YES];
//    }else{
//        _isDoubleTapingForZoom = YES;
//        _currentScale = kMaxZoom;
//        [_scrollView setZoomScale:kMaxZoom animated:YES];
//    }
//    _isDoubleTapingForZoom = NO;
//    //延时做标记判断，使用户点击3次时的单击效果不生效。
//    [self performSelector:@selector(twiceTaping) withObject:nil afterDelay:0.65];
//    NSLog(@"sdfdf");
//}
//-(void)twiceTaping{
//    NSLog(@"no");
//    _isTwiceTaping = NO;
//}
//-(void) saveTapHandler{
//    if([_activityIndicatorView isAnimating]){
//        return;
//    }
//    [_activityIndicatorView startAnimating] ;
//    UIImageWriteToSavedPhotosAlbum(_imgView.image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
//}
//#pragma mark - savePhotoAlbumDelegate
//- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo {
//    NSString *message;
//    NSString *title;
//    
//    [_activityIndicatorView stopAnimating];
//    if (!error) {
//        title = @"恭喜";
//        message = @"成功保存到相册";
//    } else {
//        title = @"失败";
//        message = [error description];
//    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//}

@end
