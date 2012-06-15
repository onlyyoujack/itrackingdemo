//
//  ERTCamera.h
//  Face Hunter
//
//  Created by James Hurley on 6/15/12.
//  Copyright (c) 2012 James Hurley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ERTCamera : NSObject
{
    GLKVector3 up, target, eye;
    GLKMatrix4 current;
}
@property (readonly, atomic) GLKMatrix4 current;
@property (assign, nonatomic) GLKVector3 up;
@property (assign, nonatomic) GLKVector3 target;
@property (assign, nonatomic) GLKVector3 eye;

- (void) update;

@end
