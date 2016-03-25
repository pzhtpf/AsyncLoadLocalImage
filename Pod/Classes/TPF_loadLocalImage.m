//
//  loadLocalImage.m
//  softDecorationMaster
//
//  Created by tianpengfei on 16/2/23.
//  Copyright © 2016年 tianpengfei. All rights reserved.
//

#import "TPF_loadLocalImage.h"
#import "TPF_ImageDecoder.h"

@implementation loadLocalImage
+ (loadLocalImage *)sharedImageCache {
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
    
        // Create IO serial queue
        _ioQueue = dispatch_queue_create("com.softDecorationMaster.loadLocalImage", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}
-(void)loadLocalImageWithUrl:(NSString *)url callback:(void (^)(UIImage *image))callback{

    
    dispatch_async(self.ioQueue, ^{
       
        UIImage  *diskImage  = [UIImage imageWithContentsOfFile:url];
        
        
        diskImage = [self scaledImageForKey:url image:diskImage];
        diskImage = [UIImage decodedImageWithImage:diskImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            callback(diskImage);
        });

    
    });

}
- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image {
    return SDScaledImageForKey(key, image);
}
-(void)saveLocalImageWithUrl:(NSString *)url image:(UIImage *)image callback:(void (^)(BOOL))callback{

       [UIImagePNGRepresentation(image) writeToFile:url options:NSAtomicWrite error:nil];
    
       callback(YES);
}
@end
