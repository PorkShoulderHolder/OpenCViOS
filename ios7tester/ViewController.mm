//
//  ViewController.m
//  ios7tester
//
//  Created by Sam Fox on 10/4/13.
//  Copyright (c) 2013 Sam Fox. All rights reserved.
//



#import "ViewController.h"
#import "CVDelegate.h"
#import "templateMatcher.h"
#import "circleDetector.h"
#import "FarnebeckOpticalFlow.h"
#import "freak.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    CvVideoCamera* videoCamera;
    [super viewDidLoad];
    
    //self.farnebeck = [[FarnebeckOpticalFlow alloc] init];
    self.freek = [[freak alloc] init];
    //self.del = [[CVDelegate alloc] init];
	videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imgView];
    [UIView animateWithDuration:0.33f animations:^()
     {
         self.imgView.transform = CGAffineTransformMakeRotation(3*M_PI/2);
         self.imgView.frame.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 200); // change this to whatever rect you want
     }];
    
    
    videoCamera.delegate = self.freek;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    [videoCamera start];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    //[device setTorchMode:AVCaptureTorchModeOn];
    [device unlockForConfiguration];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CV_Algo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Lucas-Kanade Sparse Optical Flow";
            break;
        case 1:
            cell.textLabel.text = @"template matching";
            break;
        case 2:
            cell.textLabel.text = @"Hough Circle Detector";
            break;
        case 3:
            cell.textLabel.text = @"FREAK: Fast Retina Keypoints";
            break;
        case 4:
            cell.textLabel.text = @"Farneback Dense Optical Flow";
            break;
        default:
            break;
    }
    return cell;
}

//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    switch (indexPath.row) {
//        case 0:
//            [UIViewController ]
//            break;
//        case 1:
//            cell.textLabel.text = @"template matching";
//            break;
//        case 2:
//            cell.textLabel.text = @"Hough Circle Detector";
//            break;
//        case 3:
//            cell.textLabel.text = @"FREAK: Fast Retina Keypoints";
//            break;
//        case 4:
//            cell.textLabel.text = @"Farneback Dense Optical Flow";
//            break;
//        default:
//            break;
//    }
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
