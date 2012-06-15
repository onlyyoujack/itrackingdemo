//
//  ERTGLCameraOutputProtocol.h
//  Face Hunter
//
//  Created by James Hurley on 6/15/12.
//  Copyright (c) 2012 James Hurley. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ERTGLCameraOutputProtocol <NSObject>

- (void) updateTextureData: (uint8_t*) frame_NV12;

@end
