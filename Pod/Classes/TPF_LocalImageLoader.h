//
//  TPF_LocalImageLoader.h
//  Pods
//
//  Created by tianpengfei on 16/3/29.
//
//

#import <Foundation/Foundation.h>

typedef void(^TPF_LocalImageLoaderCompletedBlock)(UIImage *image,NSString *url, BOOL finished);
typedef void(^TPF_LocalImageNoParamsBlock)();

@interface TPF_LocalImageLoader : NSObject{}
+ (TPF_LocalImageLoader *)sharedLoader;
-(NSOperation *)loadLocalImage:(NSString *)url maxPixelSize:(NSNumber *)maxPixelSize completed:(TPF_LocalImageLoaderCompletedBlock)completedBlock;
@end
