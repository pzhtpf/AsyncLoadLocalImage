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

    [self loadLocalImageWithUrlMethod:url maxPixelSize:@(self.frame.size.width*[UIScreen mainScreen].scale) callback:callback];
}
-(void)loadLocalImageWithUrlToThumbnail:(NSString *)url maxPixelSize:(int)maxPixelSize callback:(TPF_LocalImageLoadCompletedBlock)callback{
    
    [self loadLocalImageWithUrlMethod:url maxPixelSize:@(maxPixelSize) callback:callback];
}
-(void)loadLocalImageWithUrlMethod:(NSString *)url maxPixelSize:(NSNumber *)maxPixelSize callback:(TPF_LocalImageLoadCompletedBlock)callback{
    
    if(!url || url.length==0)
        return;
    
    NSArray *pathArray = [url componentsSeparatedByString:@"/"];
    
    if(!pathArray || pathArray.count==0)
        return;
    
    NSString *thumbUrlKey = pathArray[pathArray.count-1];
    if(maxPixelSize)
        thumbUrlKey = [NSString stringWithFormat:@"%@_%@",thumbUrlKey,maxPixelSize];
    
    [self sd_cancelImageLoadOperationWithKey:@"loadOperation"];
    [self sd_cancelImageLoadOperationWithKey:@"loadOperationFromCache"];
    
    
     objc_setAssociatedObject(self, &urlKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
     __weak __typeof(self)wself = self;

    __block NSOperation *loadOperationFromCache;
    __weak NSOperation *weakOperation = loadOperationFromCache;
    
     weakOperation =  [[TPFImageCache sharedImageCache] queryDiskCacheForKey:thumbUrlKey done:^(UIImage *image,TPFImageCacheType cacheType) {
        
        
        if(image){
        
//        wself.image = image;
        [wself switchImageWithTransition:image];
        [wself setNeedsLayout];
        
        
        if(callback){
            
             NSString *url = objc_getAssociatedObject(wself, &urlKey);
             callback(image,url,YES);
            
            }
            
        }
        
        else{
    
       NSOperation *loadOperation = [[TPF_LocalImageLoader sharedLoader] loadLocalImage:url maxPixelSize:maxPixelSize completed:^(UIImage *image,NSString *url, BOOL finished){
            
            if (!wself) return;
            
            [[TPFImageCache sharedImageCache] storeImage:image recalculateFromImage:NO imageData:nil forKey:thumbUrlKey toDisk:YES];
            
            dispatch_main_sync_safe(^{
           
                if (!wself) return;
                
                else if (image) {
                    
//                    wself.image = image;
                    [wself switchImageWithTransition:image];
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
- (void)switchImageWithTransition:(UIImage *)image {
    
    //set up crossfade transition
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    //apply transition to imageview backing layer
    [self.layer addAnimation:transition forKey:nil];
    self.image = image;
}
@end
