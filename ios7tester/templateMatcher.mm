//
//  templateMatcher.m
//  ios7tester
//
//  Created by Sam Fox on 10/12/13.
//  Copyright (c) 2013 Sam Fox. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/highgui/cap_ios.h>
#import "templateMatcher.h"
int match_method = CV_TM_SQDIFF_NORMED;

cv::Mat _template,result,greyTemplate;

@implementation templateMatcher
-(id)init{
    if (self = [super init]) {
        UIImage *img = [UIImage imageNamed:@"square_annies_logo.jpg"];
        cv::Mat _temp = [self cvMatFromUIImage:img];
        cv::resize(_temp, _template, cv::Size(70,70));
        cv::cvtColor(_template, greyTemplate, CV_BGR2GRAY);
    }
    return self;
}

- (void)processImage:(cv::Mat &)image{
   // int result_cols =  image.cols - _template.cols + 1;
   // int result_rows = image.rows - _template.rows + 1;
    
    //result.create( result_cols, result_rows, CV_32FC1 );
    
    cv::Mat greyImage;
    cv::cvtColor(image, greyImage, CV_BGR2GRAY);
    
    cv::matchTemplate(greyImage, greyTemplate, result, match_method);
    
    
    cv::normalize(result, result, 0, 1, cv::NORM_MINMAX, -1, cv::Mat());

    double minVal; double maxVal; cv::Point minLoc; cv::Point maxLoc;
    cv::Point matchLoc;
    minMaxLoc( result, &minVal, &maxVal, &minLoc, &maxLoc );
    if( match_method  == CV_TM_SQDIFF || match_method == CV_TM_SQDIFF_NORMED )
        { matchLoc = minLoc; }
    else
        { matchLoc = maxLoc; }
    
    rectangle( image, matchLoc, cv::Point( matchLoc.x + greyTemplate.cols , matchLoc.y + greyTemplate.rows ), cv::Scalar::all(0), 2, 8, 0 );
    
    

}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

@end
