//
//  circleDetector.m
//  ios7tester
//
//  Created by Sam Fox on 10/14/13.
//  Copyright (c) 2013 Sam Fox. All rights reserved.
//
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif

@implementation circleDetector : UIViewController

- (void) processImage:(cv::Mat &)image{
    cv::Mat grayImage;
    cv::cvtColor(image, grayImage, CV_BGR2GRAY);
    cv::GaussianBlur(grayImage, grayImage, cv::Size(9 ,9 ),2 ,2);
    std::vector<cv::Vec3f> circles;
    cv::HoughCircles(grayImage, circles, CV_HOUGH_GRADIENT, 1, grayImage.rows/8,100, 50,0,0);
    
    for( size_t i = 0; i < circles.size(); i++ )
    {
        cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
        int radius = cvRound(circles[i][2]);
        // draw the circle center
        cv::circle( image, center, 3, cv::Scalar(0,255,0), -1, 8, 0 );
        // draw the circle outline
        
        cv::circle( image, center, radius, cv::Scalar(0,0,255), 3, 8, 0 );
    }
}

@end
