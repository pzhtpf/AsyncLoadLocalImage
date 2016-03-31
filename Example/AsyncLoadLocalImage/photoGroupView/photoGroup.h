//
//  planToLagreImage.h
//  OGProject
//
//  Created by tianpengfei on 15/9/29.
//  Copyright © 2015年 钟伟迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pageControl.h"
#import "progressView.h"

typedef NS_ENUM(NSInteger, photoPreViewType) {
    photoPreViewTypeOrigin          = -1,
    photoPreViewTypeInfinite     = 0
};

@protocol photoGroupDelegate <NSObject>

@optional
-(void)photoGroupClose;

@end

@interface photoGroup : UIViewController<UIActionSheetDelegate>
-(id)initItems:(NSArray *)items selectViewFrame:(CGRect)selectViewFrame selectImage:(UIImage *)selectImage;
@property (nonatomic,strong) NSArray  *imageData;
@property (nonatomic,strong) pageControl * pictureControl ;
@property (nonatomic,strong) UIScrollView * photoScroview ;
@property(nonatomic) int selectIndex;
@property (nonatomic,strong) UIView *parentView;
@property (nonatomic,strong) UIImageView *selectedImageView;
@property (nonatomic) CGRect selectImageViewFrame;
@property (nonatomic,strong) UIImage *backImage;
@property(nonatomic,strong)NSMutableDictionary *origrinFrame;
@property(nonatomic,strong)NSMutableDictionary *relativeFrame;
@property(weak,nonatomic) id<photoGroupDelegate> photoGroupDelegate;

@property(nonatomic)photoPreViewType photopreViewtype;
@end
