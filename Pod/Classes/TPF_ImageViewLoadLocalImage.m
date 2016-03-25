//
//  ImageViewLoadLocalImage.m
//  Pods
//
//  Created by tianpengfei on 16/3/25.
//
//

#import "TPF_ImageViewLoadLocalImage.h"
#import "TPF_ImageDecoder.h"

@implementation UIImageView(LoadLocalImage)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)loadLocalImageWithUrl:(NSString *)url callback:(void (^)(UIImage *image))callback{
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self
                                                                           selector:@selector(downloadImage:)
                                                                             object:url];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
}
- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image {
    return SDScaledImageForKey(key, image);
}
-(void)downloadImage:(NSString *)url{
    NSLog(@"url:%@", url);
    UIImage *diskImage = [UIImage imageWithContentsOfFile:url];
    
    diskImage = [self scaledImageForKey:url image:diskImage];
    diskImage = [UIImage decodedImageWithImage:diskImage];
    
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:diskImage waitUntilDone:YES];
}
-(void)updateUI:(UIImage*) image{
    
    __weak __typeof(self)wself = self;
    
    wself.image = image;
    [wself setNeedsLayout];
}
@end
