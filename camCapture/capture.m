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
@property (nonatomic, strong) dispatch_queue_t imageQueue;

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
//    verbose("initiating session");
    self.imageQueue = dispatch_queue_create("Image Queue", NULL);
    NSLog(@"initiating session");
    self.captureSession = [AVCaptureSession new];
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    //this sets the input device to our specified default one
    //doing this adds a capture device to our session
    NSLog(@"setting device input");
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    //we then add this deviceInput to our captureSession provided there are no errors
    if (!error && [self.captureSession canAddInput:self.deviceInput]) {
        NSLog(@"adding input");
        [self.captureSession addInput: self.deviceInput];
    }
    //we now need to configure our capture outputs so that we can actually get an output from the session
    //since we're only capturing still images for now we just need to setup output for still images
    self.imageOutput = [AVCaptureStillImageOutput new];
    //specify JPEG format
    self.imageOutput.outputSettings = @{ AVVideoCodecKey : AVVideoCodecTypeJPEG};
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        NSLog(@"setting image output");
        [self.captureSession addOutput:self.imageOutput];
    }
    
    //here we need to find the connection whose input port is collecting video
    //we need to initiate a still image capture
    for (AVCaptureConnection *connection in self.imageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                self.videoConnection = connection;
                NSLog(@"set video conneciton");
                break;
            }
        }
        if (self.videoConnection) {break;}
    }
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
    
    //here we need to find the connection whose input port is collecting video
    //we need to initiate a still image capture
    for (AVCaptureConnection *connection in self.imageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                self.videoConnection = connection;
                NSLog(@"set video conneciton");
                break;
            }
        }
        if (self.videoConnection) {break;}
    }
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }

//    NSLog(@"imag outpoot!! : %@", self.imageOutput);
//    [self startSession];
}

-(void)startSession {
    [self.captureSession startRunning];
}
-(void) saveImageCapture {
//    NSLog(@"imag outpoot!! : %@", self.imageOutput);
//    NSLog(@"session still running: %hhd", self.captureSession.running);
    if (self.captureSession.running) {
        
        
        int i = 0;
        while (i < 51475) {
//            dispatch_async(self.imageQueue, ^{
                NSString *str = [NSString stringWithFormat:@"temp%d.jpg",i];
//            __weak __typeof__(str) filename = str;
                [self.imageOutput captureStillImageAsynchronouslyFromConnection:self.videoConnection completionHandler:
                 ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                     //returns NSData representation of the image data and metadata
                     NSData *imageD = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                     dispatch_async(self.imageQueue, ^{
                         [imageD writeToFile:str atomically:YES];
                     });
                 }];
                
//             });
            i++;
        }
    } else {
        NSLog(@"capture session not running");
    }
//    self.imageQueue.
    //stop session after completion
//    NSLog(@"Stopping session");
//    [self stopSession];
}

-(void) stopSession {
    [self.captureSession stopRunning];
}
@end
