//
//  loadLocalImage.h
//  softDecorationMaster
//
//  Created by tianpengfei on 16/2/23.
//  Copyright © 2016年 tianpengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPF_ImageCache.h"
#import "TPF_LocalImageLoader.h"

@interface TPF_LoadLocalImage : NSObject{

    //Callback blocks
    void (^successCallbackFile)(UIImage *image);
}
+ (TPF_LoadLocalImage *)sharedImageCache;
-(void)loadLocalImageWithUrl:(NSString *)url callback:(TPF_LocalImageLoaderCompletedBlock)completedBlock;
@end
