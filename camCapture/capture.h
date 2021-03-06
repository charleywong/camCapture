//
//  capture.h
//  camCapture
//
//  Created by Charley on 24/4/18.
//  Copyright © 2018 Charley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//#import <UIKit/UIKit.h>

@interface capture : NSObject

+ (NSArray *)getDevices;

+ (AVCaptureDevice *)getDefaultVid;

- (void) initiateSession: (AVCaptureDevice *) device;
- (void) startSession;
- (void) saveImageCapture;

- (void) stopSession;

@end
