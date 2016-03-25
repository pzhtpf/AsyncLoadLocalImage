//
//  collectionCell.m
//  AsyncLoadLocalImage
//
//  Created by tianpengfei on 16/3/25.
//  Copyright © 2016年 pzhtpf. All rights reserved.
//

#import "collectionCell.h"

@implementation collectionCell
-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if(self){
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.contentMode = 1;
        _imageView.clipsToBounds = YES;
        
        _imageView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        
        [self.contentView addSubview:_imageView];
    
    }

    return self;
}
@end
