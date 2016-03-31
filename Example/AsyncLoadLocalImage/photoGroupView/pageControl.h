//
//  pageControl.h
//  brandv1.2
//
//  Created by Apple on 14-9-13.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pageControl : UIView
-(void)setPageCount:(int)pageCount;
-(void)setSelected:(int)pageSelected;
@property(nonatomic)BOOL isVertical;
@end
