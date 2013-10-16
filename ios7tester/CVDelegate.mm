//
//  CVDelegate.m
//  Sommely
//
//  Created by Sam Fox on 8/30/13.
//  Copyright (c) 2013 Jason. All rights reserved.
//


#import "CVDelegate.h"

#define number_of_features 50

@implementation CVDelegate


inline static double square(int a)
{
    return a * a;
}


-(id)init{
    if (self = [super init]) {
        self.threshold = 25;
        self.erosion = 1;
        self.dilation = 2;
    }
    return self;
}

cv::Mat image_copy;
cv::Mat diff;
cv::Mat diffimage;
cv::Mat im;
cv::Mat imcopy;
int c = 0;
int erosion_size = 1;
typedef cv::vector<cv::vector<cv::Point> > TContours;
TContours contours;
cv::vector<cv::Vec4i> hierarchy;
cv::Mat element = cv::getStructuringElement(cv::MORPH_ELLIPSE,
                                            cv::Size(2 * erosion_size + 1, 2 * erosion_size + 1),
                                            cv::Point(erosion_size, erosion_size) );



std::vector<cv::Point2f> features[2];
int calibrationRounds = 3;
cv::Point lightLocation;
int avgThresh =  0;
cv::TermCriteria termcrit(cv::TermCriteria::COUNT|cv::TermCriteria::EPS,20,0.03);
cv::Size subPixWinSize(10,10), winSize(31,31);
#ifdef __cplusplus

- (void)subtractiveAnalysis: (cv::Mat)image{
    cv::vector<cv::Rect> boundingBoxes = [self findBlinksBetweenImage:image andPrevImage:image_copy];
    
    
    
    if (boundingBoxes.size() == 1) {
        
        cv::Point tempLoc = [self getLocationOfCapDemo:boundingBoxes];
        
        if (euclideanDist(tempLoc, lightLocation) > 40) {
            lightLocation = tempLoc;
            
        }
    }
    
    
    
    ///***** copy image for use in next frame *****///
    
    cvtColor(image, image_copy, CV_BGRA2GRAY);
    
    
    ///***** draw rects around each detected led state change *****///
    
    for (int i = 0; i < boundingBoxes.size(); i++) {
        rectangle( image, boundingBoxes[i].tl(),boundingBoxes[i].br(),CV_RGB(0,100,0),1, 8, 0);
    }

}

- (void)processImage:(cv::Mat&)image;
{
    [self calOpticalFlowPrev:image_copy andNext:image].copyTo(image);
    
}

float euclideanDist(cv::Point& p, cv::Point& q) {
    cv::Point diff = p - q;
    return cv::sqrt(diff.x*diff.x + diff.y*diff.y);
}

- (cv::Mat)calOpticalFlowPrev:(cv::Mat)prevIm andNext:(cv::Mat)nextIm{
    cv::Mat image;
    cv::cvtColor(nextIm, image, CV_BGR2GRAY);
    cv::vector<uchar> status;
    cv::vector<float> err;
    
    if(image_copy.empty()){
        image.copyTo(image_copy);
    }
    
    features[0] = [self getFeatures:image_copy];
    
    features[1] = [self getFeatures:image];
    cv::cornerSubPix(image, features[1], subPixWinSize, cv::Size(-1,-1), termcrit);

    cv::calcOpticalFlowPyrLK(image_copy, image, features[0], features[1], status, err,winSize, 3, termcrit, 0, 0.001);
    
    
    cv::cvtColor(image, image, CV_GRAY2BGR);
    for(int i = 0; i < number_of_features; i++)
    {
        /* If Pyramidal Lucas Kanade didn't really find the feature, skip it. */
        if ( status[i] == 0 ) continue;
        if (err[i] == 1) {
            continue;
        }
        int line_thickness; line_thickness = 1;
        /* CV_RGB(red, green, blue) is the red, green, and blue components
         * of the color you want, each out of 255.
         */
        CvScalar line_color; line_color = CV_RGB(0,0,255);
        
        /* Let's make the flow field look nice with arrows. */
        /* The arrows will be a bit too short for a nice visualization because of the
         high framerate
         * (ie: there's not much motion between the frames). So let's lengthen them
         by a factor of 3.
         */
        cv::Point p,q;
        p.x = (int) features[0][i].x;
        p.y = (int) features[0][i].y;
        q.x = (int) features[1][i].x;
        q.y = (int) features[1][i].y;
        double angle; angle = atan2( (double) p.y - q.y, (double) p.x - q.x );
        double hypotenuse; hypotenuse = sqrt( square(p.y - q.y) + square(p.x - q.x) )
        ;
        /* Here we lengthen the arrow by a factor of three. */
        q.x = (int) (p.x - 3 * hypotenuse * cos(angle));
        q.y = (int) (p.y - 3 * hypotenuse * sin(angle));
        /* Now we draw the main line of the arrow. */
/* "frame1" is the frame to draw on.
* "p" is the point where the line begins.
* "q" is the point where the line stops.
* "CV_AA" means antialiased drawing.
* "0" means no fractional bits in the center cooridinate or radius.
*/
        cv::line( image, p, q, CV_RGB(100,0,255), line_thickness, CV_AA, 0 );
        /* Now draw the tips of the arrow. I do some scaling so that the
         * tips look proportional to the main line of the arrow.
         */
        p.x = (int) (q.x + 9 * cos(angle + M_PI / 4));
        p.y = (int) (q.y + 9 * sin(angle + M_PI / 4));
        cv::line( image, p, q, CV_RGB(100,0,255), line_thickness, CV_AA, 0 );
        p.x = (int) (q.x + 9 * cos(angle - M_PI / 4));
        p.y = (int) (q.y + 9 * sin(angle - M_PI / 4));
        cv::line( image, p, q, CV_RGB(100,0,255), line_thickness, CV_AA, 0 );
}
    
    cv::cvtColor(nextIm, image_copy, CV_BGR2GRAY);
   
    return image;
    
}



- (cv::Mat)outlineFeatures:(cv::Mat)im{
    cv::Mat image;
    std::vector<cv::Point2f> feats;
    cv::cvtColor(im, image, CV_BGR2GRAY);
    cv::goodFeaturesToTrack(image, feats, number_of_features, 0.01, 10);
    for (size_t idx = 0; idx < feats.size(); idx++) {
        cv::circle(image,feats.at(idx),5,CV_RGB(100, 0, 0),1);
    }
    cv::FREAK detector;
    return image;
}

- (std::vector<cv::Point2f>)getFeatures:(cv::Mat)im{
    std::vector<cv::Point2f> feats;
    cv::goodFeaturesToTrack(im, feats, number_of_features, 0.01, 10);
    return feats;
}

- (cv::Point)getLocationOfCapDemo:(cv::vector<cv::Rect>) boundingBoxes{
    
        cv::Point point;
        point.x = (boundingBoxes[0].tl().x + boundingBoxes[0].br().x) / 2;
        point.y = (boundingBoxes[0].tl().y + boundingBoxes[0].br().y) / 2;
        return point;
   }

- (int)calibrateThresholdWith:(cv::Mat&)image andWith:(cv::Mat)prevImage forTargetCount:(int)targets{
    int saveThresh = self.threshold;
    int positiveResults = 0;
    self.threshold = 120;
    int count = 0;
    while (positiveResults < 3) {
        if (targets != [self findBlinksBetweenImage:image andPrevImage:prevImage].size() && count < 253) {
            self.threshold -= 5;
            positiveResults = 0;
        }
        else{
            positiveResults++;
            self.threshold -= 1;
        }
        count++;
    }
    if (count >= 253) {
        self.threshold = saveThresh;
        return -1;
    }
    int upperBound = self.threshold;
    count = 0;
    self.threshold = 1;
    positiveResults = 0;
    while (positiveResults < 3) {
        if (targets != [self findBlinksBetweenImage:image andPrevImage:prevImage].size() && count < 253) {
            self.threshold += 5;
            positiveResults = 0;
        }
        else{
            positiveResults++;
            self.threshold += 1;
        }
        count++;
    }
    int lowerBound = self.threshold;
    if (count >= 253) {
        self.threshold = saveThresh;
        return -1;
    }
    self.threshold = saveThresh;
    return (lowerBound + upperBound) / 2;
    
}



void rotate(cv::Mat& image, double angle)
{
    cv::Point2f src_center(image.cols/2.0F, image.rows/2.0F);
    
    cv::Mat rot_matrix = getRotationMatrix2D(src_center, angle, 1.0);
    
    cv::Mat rotated_img(cv::Size(image.size().height, image.size().width), image.type());
    
    warpAffine(image, rotated_img, rot_matrix, image.size());
    
    image = rotated_img;
}


- (cv::vector<cv::Rect>)findBlinksBetweenImage:(cv::Mat&)image andPrevImage:(cv::Mat&)prevImage{
    
    cv::Mat grayIm;
    cv::Mat diffimage;
    
    ///***** if first go, make sure variables are populated *****///
    
    cvtColor(image, grayIm, CV_BGRA2GRAY);
    if (c == 0) {
        cvtColor(image, prevImage, CV_BGRA2GRAY);
        cvtColor(image, diffimage, CV_BGRA2GRAY);
    }
    

    ///***** take absolute difference between two frames *****///

    cv::absdiff(grayIm, prevImage, diffimage);
    
    
    ///***** apply binary threshold with *****///
    
    cv::threshold(diffimage, diffimage, self.threshold, 255, cv::THRESH_BINARY);
    
    
    ///***** apply neccesary erosion and dilation operations *****///
    
    int k = self.erosion;
    while(k > 0){
        cv::erode(diffimage, diffimage, element);
        k--;
    }
    
    k = self.dilation;
    while(k > 0){
        cv::dilate(diffimage, diffimage, element);
        k--;
    }
    
    
    ///***** enumerate contours (basically blob detection) on binary image *****///

    cv::findContours( diffimage, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    
    
    ///***** get bounding boxes around each contour *****///
    
    cv::vector<cv::Rect> rects(contours.size());
    
    for (int i = 0; i < contours.size(); i++) {
        rects[i] = cv::boundingRect(contours[i]);
    }
    
    c++;
    return rects;
}

#endif



@end
