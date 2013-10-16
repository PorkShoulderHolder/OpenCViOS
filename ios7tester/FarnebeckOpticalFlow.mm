//
//  FarnebeckOpticalFlow.m
//  ios7tester
//
//  Created by Sam Fox on 10/14/13.
//  Copyright (c) 2013 Sam Fox. All rights reserved.
//

#import "FarnebeckOpticalFlow.h"

cv::Mat prev_image;

@implementation FarnebeckOpticalFlow


void drawOptFlowMap(const cv::Mat& flow, cv::Mat& cflowmap, int step,double, const cv::Scalar& color)
	{
        for(int y = 0; y < cflowmap.rows; y += step)
            for(int x = 0; x < cflowmap.cols; x += step)
            {
                	            const cv::Point2f& fxy = flow.at<cv::Point2f>(y, x);
                line(cflowmap, cv::Point(x,y), cv::Point(cvRound(x+fxy.x), cvRound(y+fxy.y)),
                                     	                 color);
                circle(cflowmap, cv::Point(x,y), 1, CV_RGB(200, 0, 0), -1);
            }
    
	}

- (void) processImage:(cv::Mat &)image{
    cv::Mat grey_image;
    cv::Mat flow;
    cv::Mat downsampled_grey;
    cv::cvtColor(image, downsampled_grey, CV_BGR2GRAY);

    if (prev_image.empty()) {
        downsampled_grey.copyTo(prev_image);
    }
    
    cv::calcOpticalFlowFarneback(prev_image, downsampled_grey, flow, 0.5, 3, 14, 3, 5, 1.2, 0);
   // int sampleRate = 2 * 10;
    drawOptFlowMap(flow, image, 12, 1.6, CV_RGB(0, 255, 0));
    
    downsampled_grey.copyTo(prev_image);
}

@end
