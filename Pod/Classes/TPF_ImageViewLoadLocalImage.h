//
//  ImageViewLoadLocalImage.h
//  Pods
//
//  Created by tianpengfei on 16/3/25.
//
//

#import <UIKit/UIKit.h>

typedef void(^TPF_LocalImageLoadCompletedBlock)(UIImage *image,NSString *url, BOOL finished);

@interface UIImageView(LoadLocalImage)
-(void)loadLocalImageWithUrl:(NSString *)url callback:(TPF_LocalImageLoadCompletedBlock)callback;
-(void)loadLocalImageWithUrlToThumbnail:(NSString *)url maxPixelSize:(int)maxPixelSize callback:(TPF_LocalImageLoadCompletedBlock)callback;
@end
