//
//  ImageViewLoadLocalImage.h
//  Pods
//
//  Created by tianpengfei on 16/3/25.
//
//

#import <UIKit/UIKit.h>

@interface UIImageView(LoadLocalImage)
-(void)loadLocalImageWithUrl:(NSString *)url callback:(void (^)(UIImage *image))callback;
@end
