//
//  ERTCaptureSession.h
//  Face Hunter
//
//  Created by Yue Chang Hu on 6/15/12.
//  Copyright (c) 2012 James Hurley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ERTGLCameraOutputProtocol.h"
#import <GLKit/GLKit.h>

@interface ERTCaptureSession : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *previewLayer;
    
    id<ERTGLCameraOutputProtocol> delegate;
    AVAssetWriterInputPixelBufferAdaptor *pbAdaptor;
}
@property (assign) id<ERTGLCameraOutputProtocol> delegate;

- (id) initWithView: (UIView*) view;
- (void) startRecording;
- (void) stopRecording;
@end
