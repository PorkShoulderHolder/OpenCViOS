//
//  CVDelegate.h
//  Sommely
//
//  Created by Sam Fox on 8/30/13.
//  Copyright (c) 2013 Jason. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/cap_ios.h>


@interface CVDelegate : NSObject <CvVideoCameraDelegate>

@property (nonatomic, assign) int threshold;
@property (nonatomic, assign) int erosion;
@property (nonatomic, assign) int dilation;


@end
