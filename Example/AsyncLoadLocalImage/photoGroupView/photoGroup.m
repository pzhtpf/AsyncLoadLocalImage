//
//  planToLagreImage.m
//  OGProject
//
//  Created by tianpengfei on 15/9/29.
//  Copyright © 2015年 钟伟迪. All rights reserved.
//

#import "photoGroup.h"
@import AsyncLoadLocalImage;


@interface photoGroup ()<UIScrollViewDelegate>
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UIImageView *back;
@property(strong,nonatomic)UIImage *selectImage;
@property(strong,nonatomic)UILabel *totalCount;
@end

@implementation photoGroup
@synthesize scrollView,back;
-(id)initItems:(NSArray *)items selectViewFrame:(CGRect)selectViewFrame selectImage:(UIImage *)selectImage{
    
    self = [super init];
    if (self) {
        // Initialization code
        
        _photopreViewtype  = photoPreViewTypeInfinite;
        _selectImageViewFrame = selectViewFrame;
        _imageData = items;
        _selectImage = selectImage;
        
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
 // Do any additional setup after loading the view.
    
    _origrinFrame = [NSMutableDictionary new];
    _relativeFrame = [NSMutableDictionary new];
    
    //增加一个长按手势
    self.view.userInteractionEnabled = YES;
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressImage:)];
    [self.view addGestureRecognizer:longPress];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self initBackView];

    
    if(_photopreViewtype  == photoPreViewTypeOrigin){
    
      
    }
    else if(_photopreViewtype  == photoPreViewTypeInfinite){
    
        [self initInfiniteView];
    }
    
   
}
-(void)initBackView{
    
    back = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    NSString *Path = [[NSBundle mainBundle]pathForResource:@"photoGroupBack.jpg" ofType:@""];
    _backImage = [UIImage imageWithContentsOfFile:Path];
    
    back.image = _backImage;
    back.alpha = 0;
    back.tag = 50;
    
    [back setUserInteractionEnabled:NO];
    [self.view addSubview:back];
    
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width*_imageData.count, 0);
    scrollView.pagingEnabled= YES;
    scrollView.delegate = self;
    
    [scrollView setContentOffset:CGPointMake(_selectIndex*self.view.frame.size.width, 0)];
    [self addDot: (int)_imageData.count];
    [self updateSelectIndex];


}
-(void)initInfiniteView{

    UIScrollView *tempScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(_selectIndex*self.view.frame.size.width, 0, self.view.frame.size.width,  self.view.frame.size.height)];
    tempScroll.minimumZoomScale = 1.0;
    tempScroll.maximumZoomScale = 3.0;
    tempScroll.delegate = self;
    
    int originalHeight;
    int originalY;
    
    _selectedImageView = [UIImageView new];
    _selectedImageView.tag = _selectIndex;
    
    _selectedImageView.image = _selectImage;
    
    if(_selectedImageView.image)
        originalHeight = _selectedImageView.image.size.height*self.view.frame.size.width/_selectedImageView.image.size.width;
    else
        originalHeight = self.view.frame.size.width;
    
    originalY = (self.view.frame.size.height-originalHeight)/2;
    originalY = originalY>0?originalY:0;    //说明是长图
    
    if(originalY==0)
        [tempScroll setContentSize:CGSizeMake(0, originalHeight)];
   
    _selectedImageView.userInteractionEnabled = NO;
    _selectedImageView.frame = _selectImageViewFrame;
    
    [tempScroll addSubview:_selectedImageView];
    tempScroll.tag = _selectedImageView.tag+100;
    [scrollView addSubview:tempScroll];
    
    
    
    [UIView animateWithDuration:0.5 animations:^(){
        
        _selectedImageView.frame = CGRectMake(0,originalY, self.view.frame.size.width, originalHeight>self.view.frame.size.height?self.view.frame.size.height:originalHeight);
        back.alpha = 1;
        
    } completion:^(BOOL finished){
        
        _selectedImageView.frame = CGRectMake(0,originalY, self.view.frame.size.width,originalHeight);
        
         [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn:)]];
        
        [self initOtherInfiniteView];
    }];
    
}
-(void)initOtherInfiniteView{

    if (_selectIndex<_imageData.count-1) {
        
        if(![scrollView viewWithTag:_selectIndex+100+1])
        [self addOtherInfiniteView:_selectIndex+1];
        
    }
    if (_selectIndex>0){
    
        if(![scrollView viewWithTag:_selectIndex+100-1])
         [self addOtherInfiniteView:_selectIndex-1];
    }
    
}
-(void)addOtherInfiniteView:(int)index{

    UIImageView  *imageview = [UIImageView new];
    imageview.userInteractionEnabled = NO;
    imageview.tag = index;


    UIScrollView *tempScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(index*self.view.frame.size.width, 0, self.view.frame.size.width,  self.view.frame.size.height)];
    tempScroll.minimumZoomScale = 1.0;
    tempScroll.maximumZoomScale = 3.0;
    tempScroll.delegate = self;

    [self initSize:imageview scrollView:tempScroll];

    tempScroll.tag = imageview.tag+100;
    [tempScroll addSubview:imageview];


    if([_imageData[index] isKindOfClass:[UIImage class]]){
        
        UIImage *image = _imageData[index];
        imageview.image = image;
        [self initSize:imageview scrollView:tempScroll];
    }

    else if([self NSStringIsValidLink:_imageData[index]]){    //如果是链接，用SDWebImage加载，这里注释掉
        
//         [imageview sd_cancelCurrentImageLoad];
//        
//        [imageview sd_setImageWithURL:[NSURL URLWithString:_imageData[index]==nil?@"":_imageData[index]] placeholderImage:imageview.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize){
//            
//            //    NSLog(@"%ld : %ld",receivedSize,expectedSize);
//            
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//            
//            if(imageview.frame.size.width == imageview.frame.size.height)
//                [self initSize:imageview scrollView:(UIScrollView *)[imageview superview]];
//        }];
    }
    else{
    
        [imageview loadLocalImageWithUrl:_imageData[index] callback:^(UIImage *image, NSString *url, BOOL finished){
        
        
             [self initSize:imageview scrollView:(UIScrollView *)[imageview superview]];
        }];
    
    }
    [scrollView addSubview:tempScroll];

}

-(void)initSize:(UIImageView *)imageview scrollView:(UIScrollView *)tempScrollView{

    int originalHeight;
    
    if (imageview.image)
        originalHeight = imageview.image.size.height*self.view.frame.size.width/imageview.image.size.width;
    else
        originalHeight = self.view.frame.size.width;
    
    int originalY = (self.view.frame.size.height-originalHeight)/2;
    originalY = originalY>0?originalY:0;    //说明是长图
    imageview.frame = CGRectMake(0,originalY, self.view.frame.size.width,originalHeight);

    if(originalY==0)
        [tempScrollView setContentSize:CGSizeMake(0, originalHeight)];
}
-(void)zoomIn:(UIGestureRecognizer *)GestureRecognizer{
    
    for (int i =0; i<_imageData.count; i++) {
        
        
        int tag = 100+i;
        
        UIImageView *imageView = [[scrollView viewWithTag:tag+100] viewWithTag:tag];
        imageView.userInteractionEnabled = YES;
        
        if(_selectIndex==i){
            
            _selectedImageView = imageView;
            
            continue;
        }
        
        imageView.frame = CGRectFromString([_origrinFrame valueForKey:[NSString stringWithFormat:@"%d",tag]]);
       
        
        [_parentView addSubview:imageView];
    }
    
    [UIView animateWithDuration:0.5 animations:^(){
        
        
        if(_photopreViewtype == photoPreViewTypeOrigin){
        
             _selectImageViewFrame = CGRectFromString([_relativeFrame valueForKey:[NSString stringWithFormat:@"%ld",_selectedImageView.tag]]);
            _selectedImageView.frame = _selectImageViewFrame;
            [[self.view viewWithTag:50] setAlpha:0];
            _pictureControl.alpha = 0;
        }
        
        else
            [self.view setAlpha:0];
        
    } completion:^(BOOL finished){
        
         _selectedImageView.frame = CGRectFromString([_origrinFrame valueForKey:[NSString stringWithFormat:@"%ld",_selectedImageView.tag]]);
        [_parentView addSubview:_selectedImageView];
        
        if([_photoGroupDelegate respondsToSelector:@selector(photoGroupClose)])
            [_photoGroupDelegate photoGroupClose];
        
        [self dismissViewControllerAnimated:NO completion:^{
            
            NSArray *subScrollView = [scrollView subviews];
            
            for (UIScrollView *tempScrollView in subScrollView) {
                
                if([tempScrollView isKindOfClass:[UIScrollView class]]){
                    [tempScrollView removeFromSuperview];
                    tempScrollView.delegate = nil;
                }
            }
            
            
            [_pictureControl removeFromSuperview];
            _pictureControl= nil;
            [scrollView removeFromSuperview];
            scrollView.delegate = self;
            scrollView = nil;
            [[self.view viewWithTag:50] removeFromSuperview];
            [_origrinFrame removeAllObjects];
            _origrinFrame = nil;
        }];

    }];
    
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView1
{
    
    if(scrollView1== scrollView)
        return;
    
    UIView *subView = [scrollView1.subviews objectAtIndex:0];
    
    CGFloat offsetX = MAX((scrollView1.bounds.size.width - scrollView1.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView1.bounds.size.height - scrollView1.contentSize.height) * 0.5, 0.0);
    
    subView.center = CGPointMake(scrollView1.contentSize.width * 0.5 + offsetX,
                                 scrollView1.contentSize.height * 0.5 + offsetY);
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return  [aScrollView.subviews objectAtIndex:0];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{

    if(scrollView1 == scrollView){
    int x =floor(scrollView1.contentOffset.x);
    _selectIndex = x/self.view.frame.size.width;
    [self updateSelectIndex];
    [self initOtherInfiniteView];
    }
}
-(void)addDot:(int)count{
    
    //   NSLog(@"%d",count);
    
    if(_imageData.count<10){
    
    if(_pictureControl ==nil){
        _pictureControl = [[pageControl alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-60,self.view.frame.size.width, 20)];
        [_pictureControl setPageCount:count];
        
        [self.view addSubview:_pictureControl];
    }
    }
    else{
    
        if(!_totalCount){
        
            _totalCount = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-40, self.view.frame.size.width-40, 21)];
            _totalCount.textColor = [UIColor greenColor];
            _totalCount.textAlignment = NSTextAlignmentCenter;
        }
    
         [self.view addSubview:_totalCount];
    }
}
-(void)updateSelectIndex{

    if(_imageData.count<10){
        
        [_pictureControl setSelected:_selectIndex];
    }
    else{
        
        _totalCount.text = [NSString stringWithFormat:@"%d/%d",_selectIndex+1,(int)_imageData.count];
    }

}
-(void)longPressImage:(UILongPressGestureRecognizer*)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        UIImageView *imageView = [[scrollView viewWithTag:_selectIndex+200] viewWithTag:_selectIndex+100];
        id image = imageView.image;
        if([image isKindOfClass:[UIImage class]]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"保存到相册",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        }
        
        
    }
    
    
    
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
       
        UIImageView *imageView = [[scrollView viewWithTag:_selectIndex+200] viewWithTag:_selectIndex+100];
        id image = imageView.image;
        [self saveImageToPhotos:image];
        
        
    }else  {
        
        
    }
    
    
}
- (void)saveImageToPhotos:(UIImage*)savedImage

{
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                          
                                                    message:msg
                          
                                                   delegate:self
                          
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
    
}

/*
#pragma mark
检验是否合法的超链接
*/
-(BOOL)NSStringIsValidLink:(NSString *)link{
    
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:link];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dealloc{

    NSLog(@"dealloc");
}
@end
