//
//  CVDelegate.h
//  Sommely
//
//  Created by Sam Fox on 8/30/13.
//  Copyright (c) 2013 Jason. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <opencv2/highgui/cap_ios.h>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/video/tracking.hpp"
#include "opencv2/features2d/features2d.hpp"



@interface CVDelegate : NSObject <CvVideoCameraDelegate>

@property (nonatomic, assign) int threshold;
@property (nonatomic, assign) int erosion;
@property (nonatomic, assign) int dilation;


@end
