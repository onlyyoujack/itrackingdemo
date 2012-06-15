//
//  ERTCaptureSession.m
//  Face Hunter
//
//  Created by Yue Chang Hu on 6/15/12.
//  Copyright (c) 2012 James Hurley. All rights reserved.
//

#import "ERTCaptureSession.h"

@implementation ERTCaptureSession

- (id) initWithView: (UIView*) view
{
    if (( self = [super init] )) 
    {
        AVCaptureDeviceInput * camIn;
        
        NSArray* cams = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        
        for ( AVCaptureDevice * device in cams )
        {
            if ( device.position == AVCaptureDevicePositionFront )
            {
                camIn = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            }
        }
        
        AVCaptureVideoDataOutput* cOut = [[AVCaptureVideoDataOutput alloc] init];
        
        dispatch_queue_t queue = dispatch_queue_create("com.curiousminds.capture.output", NULL);
        
        cOut.alwaysDiscardsLateVideoFrames = YES;
        [cOut setSampleBufferDelegate:self queue:queue];
        {
            NSDictionary * videoSettings = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithUnsignedInt: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], (NSString*)kCVPixelBufferPixelFormatTypeKey,nil];
            
            [cOut setVideoSettings:videoSettings];
        }
        session = [[AVCaptureSession alloc] init];
        [session addInput:camIn];
        [session addOutput: cOut];
        [session setSessionPreset: AVCaptureSessionPreset640x480];
        previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        previewLayer.frame = view.bounds;
        [view.layer addSublayer:previewLayer];

                
    }
    
    return self;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
	   fromConnection:(AVCaptureConnection *)connection 
{
    
}

- (void) startRecording{
    [session startRunning];
}
- (void) stopRecording{
    [session stopRunning];
}

@end
