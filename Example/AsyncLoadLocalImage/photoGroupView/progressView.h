//
//  progressView.h
//  softDecorationMaster
//
//  Created by tianpengfei on 16/1/4.
//  Copyright © 2016年 tianpengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface progressView : UIView
-(id)initWithFrame:(CGRect)frame;
@property(nonatomic)float progress;
@property(strong,nonatomic)UILabel *progressText;
@end
