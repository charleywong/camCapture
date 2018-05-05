//
//  main.m
//  camCapture
//
//  Created by Charley on 31/3/18.
//  Copyright © 2018 Charley. All rights reserved.
//

//+(AVCaptureDevice *)defaultVidDevice;

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#include "capture.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        NSLog(@"Hello, World!");
//        capture *ca = [capture alloc];
//        AVCaptureDevice *t;
//        t = [capture getDefaultVid];
//        NSLog(@"%@", t);
        //get default device
        AVCaptureDevice *device = [capture getDefaultVid];
        //setup session
        capture *c = [capture new];
        [c initiateSession:device];
        NSLog(@"initiated session with %@", device);
        [c startSession];
        [c saveImageCapture];
        [c stopSession];
        NSLog(@"executed image capture");
        
    }
    return 0;
}

