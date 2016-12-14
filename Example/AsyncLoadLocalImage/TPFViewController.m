//
//  TPFViewController.m
//  AsyncLoadLocalImage
//
//  Created by pzhtpf on 03/25/2016.
//  Copyright (c) 2016 pzhtpf. All rights reserved.
//
#import <AsyncLoadLocalImage/TPF_ImageViewLoadLocalImage.h>
#import <AsyncLoadLocalImage/TPF_ImageCache.h>
#import <AsyncLoadLocalImage/TPF_loadLocalImage.h>
#import "TPFViewController.h"
#import "collectionCell.h"
#import "photoGroup.h"


@interface TPFViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)TPFImageCache *loadImage;
@property(strong,nonatomic)NSArray *data;
@end

@implementation TPFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _loadImage = [TPFImageCache sharedImageCache];
    [TPF_LocalImageLoader sharedLoader].transitionAnimation = TransitionAnimationFade;
    
    _data = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.JPG",@"7.jpg",@"8.jpg",@"9.png",@"10.jpg",@"11.jpg",@"12.png",@"13.png",@"14.png",@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.JPG",@"7.jpg",@"8.jpg",@"9.png",@"10.jpg",@"11.jpg",@"12.png",@"13.png",@"14.png",@"15.jpg"];
//
//      _data = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.JPG",@"7.jpg",@"8.jpg",@"9.png",@"10.jpg",@"11.jpg",@"12.png",@"13.png",@"14.png"];
    
//     _data = @[@"1.jpg"];
    
    [self.view addSubview:[self createCollectionView]];
}
#pragma mark---------------   创建网格视图   -----------------
- (UICollectionView*)createCollectionView
{
    int width = self.view.frame.size.width-16;
    
    int itemWidth = (width-30)/3;
    
    
    //1.创建布局对象(流水布局,规则的布局对象).
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2.设置上下左右的间距
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //3.设置cell的大小
    layout.itemSize = CGSizeMake(itemWidth,itemWidth);
    //4.设置cell的横向间距
    layout.minimumInteritemSpacing = 8;
    //5.设置cell的纵向间距
    layout.minimumLineSpacing = 10;
    
    //2.创建网格视图
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(8,38,width,self.view.frame.size.height-40) collectionViewLayout:layout];
    _collectionView.showsVerticalScrollIndicator = YES;
    
    _collectionView.dataSource = self ;
    _collectionView.delegate = self ;
    
    //设置背景颜色
    _collectionView.backgroundColor = UIColorFromRGB(0xf8f8f8);    //注册cell
    
    [_collectionView registerClass:[collectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    
    return _collectionView ;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return _data.count;
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //从重用队列获取
    collectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"collectionCell" forIndexPath:indexPath];
    cell.imageView.image = nil;
   
    NSString *path = [[NSBundle mainBundle]pathForResource:_data[indexPath.row] ofType:@""];
   
    //以下为三种加载方法，大家自行注释，试一下
   //   The following are three ways to load,You can compare the three ways.
    
//    (1)
    
//    __weak __typeof(UIImageView *)wself = cell.imageView;
//    
//    [[TPF_LoadLocalImage sharedImageCache] loadLocalImageWithUrl:path callback:^(UIImage *image, NSString *url, BOOL finished){
//    
//                wself.image = image;
//                [wself setNeedsLayout];
//    
//    }];
    
//    [_loadImage queryDiskCacheForKey:path done:^(UIImage *image,TPFImageCacheType cacheType) {
//        
//        wself.image = image;
//        [wself setNeedsLayout];
//        
//    }];
    
    
//    (2)
    
    
//    [cell.imageView loadLocalImageWithUrl:path callback:nil];
    [cell.imageView loadLocalImageWithUrlToThumbnail:path maxPixelSize:cell.imageView.frame.size.width*[UIScreen mainScreen].scale callback:^(UIImage *image, NSString *url, BOOL finished) {
        
    }];
    
//    (3)
    
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//
//    image = SDScaledImageForKey(path, image);
//    image = [UIImage decodedImageWithImage:image];
//    
//    cell.imageView.image = image;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    collectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"collectionCell" forIndexPath:indexPath];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:_data[indexPath.row] ofType:@""];
    
//    [[TPF_LoadLocalImage sharedImageCache] loadLocalImageWithUrl:path callback:^(UIImage *image, NSString *url, BOOL finished){
//
//       
//
//    }];
    
    [[TPF_LoadLocalImage sharedImageCache] loadLocalImageWithUrlToThumbnail:path maxPixelSize:cell.imageView.frame.size.width*[UIScreen mainScreen].scale callback:^(UIImage *image, NSString *url, BOOL finished) {
        
        NSMutableArray *items = [NSMutableArray new];
        
        for (NSString *name in _data) {
            
            NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@""];
            [items addObject:path];
        }
        
        int row = floorf((float)indexPath.row/3);
        int col = indexPath.row%3;
        
        CGRect selectViewFrame = [_collectionView convertRect:CGRectMake(col*(cell.imageView.frame.size.width+8), row*(cell.imageView.frame.size.height+10), cell.imageView.frame.size.width, cell.imageView.frame.size.height) toView:self.view];
        
        photoGroup *_photoGroup = [[photoGroup alloc] initItems:items selectViewFrame:selectViewFrame selectImage:image];
        _photoGroup.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _photoGroup.selectIndex = (int)indexPath.row;
        //    _photoGroup.backImage = [self.view snapshotImage];
        [self presentViewController:_photoGroup animated:NO completion:^(){}];
        
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
