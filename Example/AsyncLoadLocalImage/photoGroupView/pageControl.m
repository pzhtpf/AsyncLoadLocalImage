//
//  pageControl.m
//  brandv1.2
//
//  Created by Apple on 14-9-13.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "pageControl.h"

@implementation pageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isVertical = false;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setIsVertical:(BOOL)isVertical{

    _isVertical = isVertical;
}
-(void)setPageCount:(int)pageCount{
    
    
    UIView *temp = [self viewWithTag:400];
    if(temp){
        [temp removeFromSuperview];
    }
    
    if(pageCount>1){
        UIView *view = [[UIView alloc] init];
        view.tag = 400;
        
        for(int i =0;i<pageCount;i++){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*15,4, 8, 8)];
            
            if(_isVertical)
                imageView.frame = CGRectMake(0, i*15,8, 8);
            
            imageView.tag = i;
            NSString *hotimagepath = [[NSBundle mainBundle]pathForResource:@"unselectedDot.png" ofType:@""];
            if(i == 0){
                hotimagepath = [[NSBundle mainBundle]pathForResource:@"selectedDot.png" ofType:@""];
            }
            UIImage *image = [UIImage imageWithContentsOfFile:hotimagepath];
            imageView.image =image;
            [view addSubview:imageView];
        }
        int width = pageCount*15;
      //  [view setCenter:self.center];
        
        if(_isVertical)
        view.frame= CGRectMake(0,self.frame.size.height/2-width/2, 20,width);
        
        else
        view.frame= CGRectMake(self.frame.size.width/2-width/2,0, width, 20);
        
        [self addSubview:view];
    }

   
}
-(void)setSelected:(int)pageSelected{

    UIView *temp = [self viewWithTag:400];
    NSArray *allSubViews = [temp subviews];
    for(UIImageView *temp in allSubViews){
        
        NSString *hotimagepath = [[NSBundle mainBundle]pathForResource:@"unselectedDot.png" ofType:@""];
        if(temp.tag == pageSelected){
            hotimagepath = [[NSBundle mainBundle]pathForResource:@"selectedDot.png" ofType:@""];
        }
        UIImage *image = [UIImage imageWithContentsOfFile:hotimagepath];
        temp.image =image;
        
        
    }
}

@end
