//
//  ViewController.h
//  ios7tester
//
//  Created by Sam Fox on 10/4/13.
//  Copyright (c) 2013 Sam Fox. All rights reserved.
//


#import <Availability.h>


#import <opencv2/opencv.hpp>
using namespace cv;
#import <opencv2/highgui/cap_ios.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CVDelegate.h"
#import "circleDetector.h"
#import "templateMatcher.h"
#import "FarnebeckOpticalFlow.h"
#import "freak.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) IBOutlet UIImageView *imgView;
@property (nonatomic,retain) CVDelegate *del;
@property (nonatomic,retain) circleDetector *circleD;
@property (nonatomic,retain) templateMatcher *templateDel;
@property (nonatomic,retain) FarnebeckOpticalFlow *farnebeck;
@property (nonatomic,retain) freak *freek;
@property (nonatomic,retain) IBOutlet UITableView *tableView;

@end
