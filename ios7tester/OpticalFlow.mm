//
//  FarnebeckOpticalFlow.m
//  ios7tester
//
//  Created by Sam Fox on 10/14/13.
//  Copyright (c) 2013 Sam Fox. All rights reserved.
//

#import "OpticalFlow.h"

cv::Mat prev_image;
cv::Mat prev_features;

@implementation OpticalFlow


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
static void drawArrows(cv::Mat frame, const cv::vector<cv::Point2f>& prevPts, const cv::vector<cv::Point2f>& nextPts, const cv::vector<uchar>& status,
                      cv::Scalar line_color = cv::Scalar(0, 0, 255))
{
    for (size_t i = 0; i < prevPts.size(); ++i)
    {
        if (status[i])
        {
            int line_thickness = 1;
            
            cv::Point p = prevPts[i];
            cv::Point q = nextPts[i];
            
            double angle = atan2((double) p.y - q.y, (double) p.x - q.x);
            
            double hypotenuse = sqrt( (double)(p.y - q.y)*(p.y - q.y) + (double)(p.x - q.x)*(p.x - q.x) );
            
            if (hypotenuse < 1.0)
                continue;
            
            // Here we lengthen the arrow by a factor of three.
            q.x = (int) (p.x - 3 * hypotenuse * cos(angle));
            q.y = (int) (p.y - 3 * hypotenuse * sin(angle));
            
            // Now we draw the main line of the arrow.
            line(frame, p, q, line_color, line_thickness);
            
            // Now draw the tips of the arrow. I do some scaling so that the
            // tips look proportional to the main line of the arrow.
            
            p.x = (int) (q.x + 9 * cos(angle + CV_PI / 4));
            p.y = (int) (q.y + 9 * sin(angle + CV_PI / 4));
            line(frame, p, q, line_color, line_thickness);
            
            p.x = (int) (q.x + 9 * cos(angle - CV_PI / 4));
            p.y = (int) (q.y + 9 * sin(angle - CV_PI / 4));
            line(frame, p, q, line_color, line_thickness);
        }
    }
}

- (void) processImage:(cv::Mat &)image{
    cv::Mat grey_image;
    cv::Mat flow;
    cv::vector<cv::Mat> channels;
    split(image, channels);
    cv::vector<uchar> status;
    cv::vector<cv::Point2f> features;
    cv::vector<cv::Point2f> nextPoints;
    cv::Mat downsampled_grey( image.rows, image.cols, CV_8UC1 );;
    cv::Mat output[] = { downsampled_grey };
    int from_to[] = { 0,0 };

    cv::mixChannels(&image, 1, output, 1, from_to, 1);

    //cv::cvtColor(image, downsampled_grey, CV_BGR2GRAY);
    
    cv::Mat err;
    
    if (prev_image.empty()) {
        downsampled_grey.copyTo(prev_image);
    }
    if (self.type == LUCAS_KANADE_SPARSE){
        cv::goodFeaturesToTrack(downsampled_grey, features, 20, 0.1, 0.2);
        cv::calcOpticalFlowPyrLK(prev_image, downsampled_grey, features, nextPoints, status, err);
        drawArrows(image, features, nextPoints, status);
    }
    else if (self.type == FARNEBECK_DENSE){
        cv::calcOpticalFlowFarneback(prev_image, downsampled_grey, flow, 0.2, 3, 14, 3, 5, 1.2, 0);
        drawOptFlowMap(flow, image, 12, 1.6, CV_RGB(0, 255, 0));
    }
    
    downsampled_grey.copyTo(prev_image);
}

@end
