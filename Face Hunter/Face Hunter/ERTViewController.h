//
//  ERTViewController.h
//  Face Hunter
//
//  Created by James Hurley on 6/15/12.
//  Copyright (c) 2012 James Hurley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "ERTCaptureSession.h"
#import "ERTGLCameraOutputProtocol.h"

@interface ERTViewController : GLKViewController<ERTGLCameraOutputProtocol>
{
    ERTCaptureSession *session;
}


@end
