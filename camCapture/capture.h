//
//  capture.h
//  camCapture
//
//  Created by Charley on 24/4/18.
//  Copyright © 2018 Charley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface capture : NSObject

+ (NSArray *)getDevices;

+ (AVCaptureDevice *)getDefaultVid;

- (void) initiateSession: (AVCaptureDevice *) device;
- (void) startSession;
- (void) saveImageCapture: (AVCaptureDevice *) device;

- (void) stopSession;

@end
