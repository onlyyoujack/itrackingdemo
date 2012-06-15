//
//  ERTCamera.m
//  Face Hunter
//
//  Created by James Hurley on 6/15/12.
//  Copyright (c) 2012 James Hurley. All rights reserved.
//

#import "ERTCamera.h"

@implementation ERTCamera
@synthesize current, up, target, eye;

- (void) update
{
    current = GLKMatrix4Identity;
    
    GLKVector3 f, s, u;
    
    f.x = target.x - eye.x;
    f.y = target.y - eye.y;
    f.z = target.z - eye.z;
    f = GLKVector3Normalize(f);
    
    s = GLKVector3CrossProduct(f, up);
    s = GLKVector3Normalize(s);
    
    u = GLKVector3CrossProduct(s, f);
    
    current.m[0] = s.x;
    current.m[4] = s.y;
    current.m[8] = s.z;
    current.m[12] = 0.0;
    
    current.m[1] = u.x;
    current.m[5] = u.y;
    current.m[9] = u.z;
    current.m[13] = 0.0;
    
    current.m[2] = -f.x;
    current.m[6] = -f.y;
    current.m[10] = -f.z;
    current.m[14] = 0.0;
    
    current.m[3] = current.m[7] = current.m[11] = 0.0;
    current.m[15] = 1.0;
    
    
    current = GLKMatrix4Translate(current, -eye.x, -eye.y, -eye.z);
    
}

@end
