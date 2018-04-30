//
//  capture.m
//  camCapture
//
//  Created by Charley on 24/4/18.
//  Copyright © 2018 Charley. All rights reserved.
//

#import "capture.h"

@interface capture()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@end

@implementation capture
+ (NSArray *)getDevices {
    NSMutableArray *devices = [NSMutableArray new];
    //we want to find the devices that can record video and audio
    [devices addObjectsFromArray:[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]];
    [devices addObjectsFromArray:[AVCaptureDevice devicesWithMediaType:AVMediaTypeMuxed]];
    
    return devices;
}

+ (AVCaptureDevice *)getDefaultVid {
    //get the default video recording device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //if it doesn't exist
    if (device == nil) {
        return NULL;
    }
    return device;
}

- (void) initiateSession: (AVCaptureDevice *) device {
    NSError *error;
    //initiate the session
    self.captureSession = [AVCaptureSession new];
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    //this sets the input device to our specified default one
    //doing this adds a capture device to our session
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    //we then add this deviceInput to our captureSession provided there are no errors
    if ([self.captureSession canAddInput:self.deviceInput]) {
        [self.captureSession addInput: self.deviceInput];
    }
    //we now need to configure our capture outputs so that we can actually get an output from the session
    //since we're only capturing still images for now we just need to setup output for still images
    self.imageOutput = [AVCaptureStillImageOutput new];
    //specify JPEG format
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecTypeJPEG};
    [self.imageOutput setOutputSettings:outputSettings];
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
    
    //here we need to find the connection whose input port is collecting video
    //we need to initiate a still image capture
    for (AVCaptureConnection *connection in self.imageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                self.videoConnection = connection;
                break;
            }
        }
        if (self.videoConnection) {break;}
    }
    
}

-(void)startSession {
    [self.captureSession startRunning];
}
-(void) saveImageCapture: (AVCaptureDevice *) device {
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:self.videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         //returns NSData representation of the image data and metadata
         NSData *imageD = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         //write imageD to file
         [imageD writeToFile:@"temp" atomically:YES];

     }];
    //stop session after completion
    [self stopSession];
}

-(void) stopSession {
    
}
@end
