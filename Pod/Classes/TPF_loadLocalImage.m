//
//  loadLocalImage.m
//  softDecorationMaster
//
//  Created by tianpengfei on 16/2/23.
//  Copyright © 2016年 tianpengfei. All rights reserved.
//

#import "TPF_loadLocalImage.h"
#import "UIView+WebCacheOperation.h"
#import "objc/runtime.h"

//static char url;

@implementation TPF_LoadLocalImage
+ (TPF_LoadLocalImage *)sharedImageCache {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
-(id)init{

    self = [super init];

    if(self){
    
    }
    
    return self;
}
-(void)loadLocalImageWithUrl:(NSString *)url callback:(TPF_LocalImageLoaderCompletedBlock)completedBlock{

    
    __weak __typeof(self)wself = self;
    
   [[TPFImageCache sharedImageCache] queryDiskCacheForKey:url done:^(UIImage *image,TPFImageCacheType cacheType) {
        
        
        if(image){
            
            completedBlock(image,nil,YES);
            
        }
        
        else{
            
           [[TPF_LocalImageLoader sharedLoader] loadLocalImage:url completed:^(UIImage *image,NSString *url, BOOL finished){
                
                if (!wself) return;
                
                [[TPFImageCache sharedImageCache] storeImage:image recalculateFromImage:NO imageData:nil forKey:url toDisk:YES];
                
                dispatch_main_sync_safe(^{
                    if (!wself) return;
                    else if (image) {
                        
                          completedBlock(image,nil,YES);
                    }
                });
                
                
            }];
            
          
        }
        
    }];
    

}
@end
