//
//  loadLocalImage.h
//  softDecorationMaster
//
//  Created by tianpengfei on 16/2/23.
//  Copyright © 2016年 tianpengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface loadLocalImage : NSObject{

    //Callback blocks
    void (^successCallbackFile)(UIImage *image);
}
@property (retain, nonatomic) dispatch_queue_t ioQueue;
@property (retain, nonatomic)NSOperationQueue *operationQueue;
+ (loadLocalImage *)sharedImageCache;
-(void)loadLocalImageWithUrl:(NSString *)url callback:(void (^)(UIImage *image))callback;
-(void)saveLocalImageWithUrl:(NSString *)url image:(UIImage *)image callback:(void (^)(BOOL isFinished))callback;
@end
