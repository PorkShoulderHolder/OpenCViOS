//
//  freak.h
//  ios7tester
//
//  Created by Sam Fox on 10/16/13.
//  Copyright (c) 2013 Sam Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/cap_ios.h>

@interface freak : NSObject<CvVideoCameraDelegate>

@property (nonatomic,retain) UIImage *templateImg;

@end
