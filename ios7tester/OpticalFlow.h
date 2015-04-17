//
//  FarnebeckOpticalFlow.h
//  ios7tester
//
//  Created by Sam Fox on 10/14/13.
//  Copyright (c) 2013 Sam Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/cap_ios.h>

#define FARNEBECK_DENSE 0
#define LUCAS_KANADE_SPARSE 1


@interface OpticalFlow : NSObject<CvVideoCameraDelegate>
@property(nonatomic, readwrite) int type;

@end
