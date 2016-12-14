//
//  TPF_LocalImageLoader.m
//  Pods
//
//  Created by tianpengfei on 16/3/29.
//
//

#import "TPF_LocalImageLoader.h"
#import "TPF_ImageDecoder.h"
#import <ImageIO/ImageIO.h>
#import "objc/runtime.h"

static char urlKey;

@interface TPF_LocalImageLoader ()

@property (strong, nonatomic) NSOperationQueue *downloadQueue;
@property (copy, nonatomic) TPF_LocalImageLoaderCompletedBlock completedBlock;
@property (strong, nonatomic) NSMutableDictionary *URLCallbacks;
@property (SDDispatchQueueSetterSementics, nonatomic) dispatch_queue_t barrierQueue;
@end

@implementation TPF_LocalImageLoader
+ (TPF_LocalImageLoader *)sharedLoader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {

        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 6;
        _URLCallbacks = [NSMutableDictionary new];
        _barrierQueue = dispatch_queue_create("com.roctian.TPFWebImageDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)dealloc {
    
    [self.downloadQueue cancelAllOperations];
    self.completedBlock  = nil;
}
-(NSOperation *)loadLocalImage:(NSString *)url maxPixelSize:(NSNumber *)maxPixelSize completed:(TPF_LocalImageLoaderCompletedBlock)completedBlock{
    
    objc_setAssociatedObject(url, &urlKey,[[NSUUID UUID] UUIDString], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    __block NSInvocationOperation *operation;
    __weak __typeof(self)wself = self;
    
    operation = [[NSInvocationOperation alloc]initWithTarget:wself selector:@selector(downloadImage:)
                                                      object:@[url,maxPixelSize?maxPixelSize:@(-1)]];
    
    [self addCompletedBlock:completedBlock url:url NoParamsBlock:^(){
    
        [wself.downloadQueue addOperation:operation];
    
    }];
    
    return operation;
}
-(void)downloadImage:(NSArray *)array{
   
    NSString *url = array[0];
    int maxPixelSize = [array[1] intValue];
    
    UIImage *compressedImage = [self fmt_p_compress:nil maxPixelSize:maxPixelSize fileURL:url];
    
    [self performSelectorOnMainThread:@selector(callBackImage:) withObject:@[compressedImage,url] waitUntilDone:YES];
}
-(void)callBackImage:(NSArray *)data{

    UIImage *image = data[0];
    NSString *url = data[1];
    
    NSString *UUID = objc_getAssociatedObject(url, &urlKey);
    
    __weak __typeof(self)wself = self;
    
    __block TPF_LocalImageLoaderCompletedBlock callback;
    dispatch_barrier_sync(self.barrierQueue, ^{
        
        callback = [wself.URLCallbacks[UUID] copy];
        [wself.URLCallbacks removeObjectForKey:UUID];
        
    });
    
    if (callback){
        
        callback(image,url,YES);
    }

}
- (void)addCompletedBlock:(TPF_LocalImageLoaderCompletedBlock)completedBlock url:(NSString *)url NoParamsBlock:(TPF_LocalImageNoParamsBlock)createCallback{
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        
        
        NSString *UUID = objc_getAssociatedObject(url, &urlKey);
        
        self.URLCallbacks[UUID] = [completedBlock copy];
        

        createCallback();


    });
}
- (UIImage *)fmt_p_compress:(NSData *)imageData maxPixelSize:(int)maxPixelSize fileURL:(NSString *)fileURL{
//    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    
    NSURL *imageURL = [NSURL fileURLWithPath:fileURL];
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
    
    CFDictionaryRef options;
    if(maxPixelSize !=-1)
     options = (__bridge CFDictionaryRef) @{
                                                           (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                           (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                           (id) kCGImageSourceThumbnailMaxPixelSize : @(maxPixelSize)
                                                           };
    else
        options = (__bridge CFDictionaryRef) @{
                                               (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                               (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES
                                               };
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
    CFRelease(src);
    UIImage *img = [[UIImage alloc]initWithCGImage:thumbnail];
    

    
    return img;
}
@end
