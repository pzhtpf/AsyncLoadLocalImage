//
//  ImageViewLoadLocalImage.m
//  Pods
//
//  Created by tianpengfei on 16/3/25.
//
//

#import "TPF_ImageViewLoadLocalImage.h"
#import "TPF_ImageCache.h"
#import "objc/runtime.h"
#import "TPF_ImageDecoder.h"
#import "TPF_LocalImageLoader.h"
#import "UIView+WebCacheOperation.h"
#import "TPF_loadLocalImage.h"

static char urlKey;

@implementation UIImageView(LoadLocalImage)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)loadLocalImageWithUrl:(NSString *)url callback:(TPF_LocalImageLoadCompletedBlock)callback{
    
    [self sd_cancelImageLoadOperationWithKey:@"loadOperation"];
    [self sd_cancelImageLoadOperationWithKey:@"loadOperationFromCache"];
    
    
     objc_setAssociatedObject(self, &urlKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
     __weak __typeof(self)wself = self;

    __block NSOperation *loadOperationFromCache;
    __weak NSOperation *weakOperation = loadOperationFromCache;
    
     weakOperation =  [[TPFImageCache sharedImageCache] queryDiskCacheForKey:url done:^(UIImage *image,TPFImageCacheType cacheType) {
        
        
        if(image){
        
        wself.image = image;
        [wself setNeedsLayout];
        
        
        if(callback){
            
             NSString *url = objc_getAssociatedObject(wself, &urlKey);
             callback(image,url,YES);
            
            }
            
        }
        
        else{
    
       NSOperation *loadOperation = [[TPF_LocalImageLoader sharedLoader] loadLocalImage:url completed:^(UIImage *image,NSString *url, BOOL finished){
            
            if (!wself) return;
            
            [[TPFImageCache sharedImageCache] storeImage:image recalculateFromImage:NO imageData:nil forKey:url toDisk:YES];
            
            dispatch_main_sync_safe(^{
           
                if (!wself) return;
                
                else if (image) {
                    
                    wself.image = image;
                    [wself setNeedsLayout];
                    
                    if(callback){
                        
                        NSString *url = objc_getAssociatedObject(wself, &urlKey);
                        callback(image,url,YES);
                    }
                }
            });
           
            
            }];
            
            [self sd_setImageLoadOperation:loadOperation forKey:@"loadOperation"];
        }
        
    }];
    
    if(loadOperationFromCache)
    [self sd_setImageLoadOperation:loadOperationFromCache forKey:@"loadOperationFromCache"];
}
@end
