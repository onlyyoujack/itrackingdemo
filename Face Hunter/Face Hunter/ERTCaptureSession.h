//
//  ERTCaptureSession.h
//  Face Hunter
//
//  Created by Yue Chang Hu on 6/15/12.
//  Copyright (c) 2012 James Hurley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ERTCaptureSession : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *previewLayer;
}
- (id) initWithView: (UIView*) view;
- (void) startRecording;
- (void) stopRecording;
@end
