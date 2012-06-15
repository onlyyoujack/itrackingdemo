//
//  ERTCaptureSession.m
//  Face Hunter
//
//  Created by Yue Chang Hu on 6/15/12.
//  Copyright (c) 2012 James Hurley. All rights reserved.
//

#import "ERTCaptureSession.h"
#import <dispatch/dispatch.h>
#import <CoreImage/CoreImage.h>
@implementation ERTCaptureSession
@synthesize delegate;

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
            NSDictionary * videoSettings = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithUnsignedInt: kCVPixelFormatType_32BGRA], (NSString*)kCVPixelBufferPixelFormatTypeKey,nil];
            
            [cOut setVideoSettings:videoSettings];
            
        }
        session = [[AVCaptureSession alloc] init];
        [session addInput:camIn];
        [session addOutput: cOut];
        [session setSessionPreset: AVCaptureSessionPresetLow];
        previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        previewLayer.frame = view.bounds;
        [view.layer addSublayer:previewLayer];

        canProcessFrame = TRUE;
        
    }
    
    return self;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
	   fromConnection:(AVCaptureConnection *)connection 
{
    int w = 352;
    int h = 288;
    int hh = h/2;
    
    //uint8_t* frame = (uint8_t*)malloc((w*h)+(h*hh)) ;
    
    CVImageBufferRef img = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(img,0);
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    {
        
         CIImage* ciimg = [CIImage imageWithCVPixelBuffer:img];
        __block ERTCaptureSession * bSelf = self;
        
        CVPixelBufferUnlockBaseAddress(img,0);
        
        if(canProcessFrame) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                
                NSAutoreleasePool * p = [[NSAutoreleasePool alloc] init];
                bSelf->canProcessFrame = FALSE;
                
                CIImage * _img = ciimg;
                
                [_img retain];
                
                CIDetector* det = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy]];
                
                NSArray* features = [det featuresInImage:ciimg];
                
                GLKVector2 leftEyeCenter, rightEyeCenter;
                
                for ( CIFaceFeature* f in features)
                {
                    if(f.hasLeftEyePosition)
                    {
                        NSLog(@"Has left eye");
                        
                    }
                    if(f.hasRightEyePosition)
                    {
                        NSLog(@"Has right eye");
                    }
                }
                
                [_img release];
                [p drain];
                
                bSelf->canProcessFrame = TRUE;
                
            });
        }
        //[ciimg release];
        
        
    }
    [pool drain];
    
    //uint8_t* base1 = (uint8_t*)CVPixelBufferGetBaseAddressOfPlane(img,0); // Y
    //uint8_t* base2 = (uint8_t*)CVPixelBufferGetBaseAddressOfPlane(img,1); // UV
    
    //memcpy(frame,base1, w*h);
    //memcpy(frame+(w*h),base2, w*hh);
    

    /*
    void (^updateTex)(void) = ^{
        [delegate updateTextureData:frame];
    };
    
    dispatch_queue_t q_current = dispatch_get_current_queue();
    
    if(q_current == dispatch_get_main_queue())
    {
        updateTex();
    } else {
        dispatch_sync(dispatch_get_main_queue(), updateTex);
    }*/
}

- (void) startRecording{
    [session startRunning];
}
- (void) stopRecording{
    [session stopRunning];
}

@end
