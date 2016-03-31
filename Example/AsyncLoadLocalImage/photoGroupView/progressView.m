//
//  progressView.m
//  softDecorationMaster
//
//  Created by tianpengfei on 16/1/4.
//  Copyright © 2016年 tianpengfei. All rights reserved.
//

#import "progressView.h"

@implementation progressView
-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if(self){
    
      //  [self setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _progressText = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, self.frame.size.height/2-8, 40,16)];
        [self addSubview:_progressText];
        
        _progressText.font =  [UIFont fontWithName: @"Helvetica" size: 12];
        _progressText.textColor = [UIColor whiteColor];
        _progressText.textAlignment = NSTextAlignmentCenter;
    }
    return  self;

}
-(void)setProgress:(float)progress{

    if(progress>=0 && progress<=1){
    _progress = progress;
    [self setNeedsDisplay];
    }

}
-(void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    float minSize =50;
    float lineWidth = 5;
    float radius = (minSize-lineWidth)/2;
    float endAngle = M_PI/2+ M_PI*(self.progress*2);
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, center.x, center.y);
    CGContextRotateCTM(ctx, -M_PI*0.5);
    
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    //  "Full" Background Circle:
    
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, 0, 0, radius, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor lightGrayColor] colorWithAlphaComponent:0.9].CGColor);
    CGContextStrokePath(ctx);
    
    //    Progress Arc:
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, 0, 0, radius, M_PI/2, endAngle, 0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
    
   // [self drawText];
       NSString *text = [NSString stringWithFormat:@"%d％",(int)(self.progress*100)];
      [_progressText setText:text];
    
}
- (void)drawText
{
    //Draw Text
    CGRect textRect = CGRectMake(self.frame.size.width/2-15, self.frame.size.height/2-8, 30,16);
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 12], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: textStyle};
    
    NSString *text = [NSString stringWithFormat:@"%d％",(int)(self.progress*100)];
    
    [text drawInRect: textRect withAttributes: textFontAttributes];
}
@end
