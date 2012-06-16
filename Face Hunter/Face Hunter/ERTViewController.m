//
//  ERTViewController.m
//  Face Hunter
//
//  Created by James Hurley on 6/15/12.
//  Copyright (c) 2012 James Hurley. All rights reserved.
//

#import "ERTViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_SAMP_Y,
    UNIFORM_SAMP_UV,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    ATTRIB_COORD,
    NUM_ATTRIBUTES
};

GLfloat gCubeVertexData[216] = 
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          1.0f, 0.0f, 0.0f,
    
    0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};

GLfloat gPreviewVerts[16] =
{
    0.75f,-0.95f,         0.f,0.f,
    0.95f,-0.95f,         0.6875f, 0.f,
    0.95f,-0.79f,         0.6875f, 0.5625f,
    0.75f,-0.79f,         0.f, 0.5625f
};

void generateCube(GLKVector3 center, float w, float h, float l, GLfloat* data)
{
    w /= 2.f;
   // w += center.x;
    h /= 2.f;
   // h += center.y;
    l /= 2.f;
   // l += center.z;
    
    float nw = center.x - w;
    w += center.x;
    
    float nh = center.y - h;
    h += center.y;
    
    float nl = center.z - l;
    l += center.z;
    
    GLfloat verts[216] =
    {
        // Data layout for each line below is:
        // positionX, positionY, positionZ,     normalX, normalY, normalZ,
        w, nh, nl,        1.0f, 0.0f, 0.0f,
        w, h, nl,         1.0f, 0.0f, 0.0f,
        w, nh, l,         1.0f, 0.0f, 0.0f,
        w, nh, l,         1.0f, 0.0f, 0.0f,
        w, h, nl,         1.0f, 0.0f, 0.0f,
        w, h, l,          1.0f, 0.0f, 0.0f,
        
        w, h, nl,         0.0f, 1.0f, 0.0f,
        nw, h, nl,        0.0f, 1.0f, 0.0f,
        w, h, l,          0.0f, 1.0f, 0.0f,
        w, h, l,          0.0f, 1.0f, 0.0f,
        nw, h, nl,        0.0f, 1.0f, 0.0f,
        nw, h, l,         0.0f, 1.0f, 0.0f,
        
        nw, h, nl,        -1.0f, 0.0f, 0.0f,
        nw, nh, nl,       -1.0f, 0.0f, 0.0f,
        nw, h, l,         -1.0f, 0.0f, 0.0f,
        nw, h, l,         -1.0f, 0.0f, 0.0f,
        nw, nh, nl,       -1.0f, 0.0f, 0.0f,
        nw, nh, l,        -1.0f, 0.0f, 0.0f,
        
        nw, nh, nl,       0.0f, -1.0f, 0.0f,
        w, nh, nl,        0.0f, -1.0f, 0.0f,
        nw, nh, l,        0.0f, -1.0f, 0.0f,
        nw, nh, l,        0.0f, -1.0f, 0.0f,
        w, nh, nl,        0.0f, -1.0f, 0.0f,
        w, nh, l,         0.0f, -1.0f, 0.0f,
        
        w, h, l,          0.0f, 0.0f, 1.0f,
        nw, h, l,         0.0f, 0.0f, 1.0f,
        w, nh, l,         0.0f, 0.0f, 1.0f,
        w, nh, l,         0.0f, 0.0f, 1.0f,
        nw, h, l,         0.0f, 0.0f, 1.0f,
        nw, nh,l,        0.0f, 0.0f, 1.0f,
        
        w, nh, nl,        0.0f, 0.0f, -1.0f,
        nw, nh, nl,       0.0f, 0.0f, -1.0f,
        w, h, nl,         0.0f, 0.0f, -1.0f,
        w, h, nl,         0.0f, 0.0f, -1.0f,
        nw, nh, nl,       0.0f, 0.0f, -1.0f,
        nw, h, nl,        0.0f, 0.0f, -1.0f
    };

    memcpy(data,verts,sizeof(verts));
    
}

#define SAMPLE_COUNT 20
#define W 0.75

@interface ERTViewController () {
    
    float weights[SAMPLE_COUNT];
    
    NSMutableArray* centerSamples;
    NSMutableArray* upSamples;
    
    GLuint _program, _previewProgram;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray, _prevArray;
    GLuint _vertexBuffer, _prevBuf;
    
    GLuint _texY, _texUV;
    
    GLKVector2 leftEye, rightEye;
    ERTCamera *camera;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
- (void) checkGLErrors: (int) line;
- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
- (GLKVector2) computWeightedMean: (NSMutableArray*) array;

@end

@implementation ERTViewController

- (GLKVector2) computWeightedMean: (NSMutableArray*) array
{
    GLKVector2 ov;
    ov.x = 0.f;
    ov.y = 0.f;
    
    int i = 0;
    for ( NSValue * v in array)
    {
        CGPoint val = [v CGPointValue];
        
        ov.x += val.x * weights[i];
        ov.y += val.y * weights[i++];
    }
    
    return ov;
}

- (void) setEyePositions:(GLKVector2)left Right:(GLKVector2)right
{
    leftEye = left;
    rightEye = right;
//    printf("left %lf -- right %lf \n",left.x, right.x);
    
    GLKVector2 le = GLKVector2AddScalar(leftEye, -0.5f);
    GLKVector2 re = GLKVector2AddScalar(rightEye, -0.5f);
    
    GLKVector2 center = GLKVector2DivideScalar(GLKVector2Add(le, re), 2);
    center.x *=1.5*4.f;
    center.y *=1.5*3.f;
    
    [centerSamples insertObject:[NSValue valueWithCGPoint:CGPointMake(center.x,center.y)] atIndex:0];
    if(centerSamples.count > SAMPLE_COUNT)
        [centerSamples removeLastObject];
    
    
    GLKVector2 subLeftRight = GLKVector2Subtract(rightEye, leftEye);
    
    [upSamples insertObject:[NSValue valueWithCGPoint:CGPointMake(subLeftRight.x, subLeftRight.y)] atIndex:0];
    if(upSamples.count > SAMPLE_COUNT)
        [upSamples removeLastObject];
    
    
}
- (void) checkGLErrors: (int) line
{
    GLint err = glGetError();
    
    switch(err)
    {
        case GL_NO_ERROR:
            break;
        case GL_INVALID_ENUM:
            NSLog(@"%d: Invalid Enum", line );
            break;
        case GL_INVALID_VALUE:
            NSLog(@"%d: Invalid Value", line );
            break;
        case GL_INVALID_OPERATION:
            NSLog(@"%d: Invalid Operation", line );
            break;
        case GL_OUT_OF_MEMORY:
            NSLog(@"%d: Out of Memory", line );
            break;
    }
}

- (void) updateTextureData: (uint8_t*) frame_NV12
{
    int w = 352;
    int h = 288;
    int hh = h/2;
    glActiveTexture(GL_TEXTURE0);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, GL_LUMINANCE, GL_UNSIGNED_BYTE, frame_NV12);
    
    glActiveTexture(GL_TEXTURE1);
    glTexSubImage2D(GL_TEXTURE_2D, 0,0,0,w,hh,GL_LUMINANCE_ALPHA,GL_UNSIGNED_BYTE, frame_NV12+(w*h));
    [self checkGLErrors:__LINE__];
    
}
- (void)dealloc
{
    [_context release];
    [_effect release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    centerSamples = [[NSMutableArray alloc]init];
    upSamples = [[NSMutableArray alloc]init];
    
    
    // prepare weights
    
    float v = (1.0 - pow(W, SAMPLE_COUNT)) / (1.0 - W);
    
    for ( int i = 0 ; i < SAMPLE_COUNT ; i ++ )
    {
        weights[i] = pow(W, i) / v;
    }
    
    session = [[ERTCaptureSession alloc] initWithView:nil];
    session.delegate = self;
    [session startRecording];
    camera = [[ERTCamera alloc] init];
    GLKVector3 e = {0.f,0.f,3.f};
    GLKVector3 u = {0.f,1.f,0.f};
     GLKVector3 t = {0.f,0.f,-10.f};
    camera.eye = e;
    camera.up = u;
    camera.target= t;
    
    self.context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2] autorelease];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    self.effect = [[[GLKBaseEffect alloc] init] autorelease];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    
    glEnable(GL_DEPTH_TEST);
      [self checkGLErrors:__LINE__];
    glGenVertexArraysOES(1, &_vertexArray);
    glGenVertexArraysOES(1, &_prevArray);
    glBindVertexArrayOES(_prevArray);
    glGenBuffers(1,&_prevBuf);
    glBindBuffer(GL_ARRAY_BUFFER, _prevBuf);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gPreviewVerts), gPreviewVerts, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 16, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(ATTRIB_COORD);
    glVertexAttribPointer(ATTRIB_COORD, 2, GL_FLOAT, GL_FALSE, 16, BUFFER_OFFSET(8));
    
    glBindVertexArrayOES(_vertexArray);
      [self checkGLErrors:__LINE__];
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    
    GLfloat * cubeData = (GLfloat*) malloc(sizeof(gCubeVertexData)*10);
#define floff(i) (216*i)
    {
        GLKVector3 t = {2.f,0.f,-2.f};               // middle right
        generateCube(t, 0.5f, 0.25f, 8.f, cubeData);
    }
    {
        GLKVector3 t = {2.f,2.f,-2.f};              // top right
        generateCube(t, 0.5f, 0.25f, 8.f, cubeData+floff(1));
    }
    {
        GLKVector3 t = {2.f,-2.f,-2.f};              // bottom right
        generateCube(t, 0.5f, 0.25f, 8.f, cubeData+floff(2));
    }
    {
        GLKVector3 t = {0.f,2.f,-2.f};              // top middle
        generateCube(t, 0.5f, 0.25f, 8.f, cubeData+floff(3));
    }
    {
        GLKVector3 t = {-2.f,2.f,-2.f};              // top left
        generateCube(t, 0.5f, 0.25f, 8.f, cubeData+floff(4));
    }
    {
        GLKVector3 t = {-2.f,0.f,-2.f};              // middle left
        generateCube(t, 0.5f, 0.25f, 8.f, cubeData+floff(5));
    }
    {
        GLKVector3 t = {-2.f,-2.f,-2.f};              // bottom left
        generateCube(t, 0.5f, 0.25f, 8.f, cubeData+floff(6));
    }
    {
        GLKVector3 t = {0.f,-2.f,-2.f};              // bottom middle
        generateCube(t, 0.5f, 0.25f, 8.f, cubeData+floff(7));
    }
    
    
    
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData)*8, cubeData, GL_STATIC_DRAW);
    
    free(cubeData);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    
    glBindVertexArrayOES(0);
      [self checkGLErrors:__LINE__];
    glGenTextures(1,&_texUV);
    glGenTextures(1, &_texY);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texY);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, 352, 288, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, 0);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    
    glActiveTexture(GL_TEXTURE1);
    
    glBindTexture(GL_TEXTURE_2D, _texUV);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE_ALPHA, 352, 288,0, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, 0);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
      [self checkGLErrors:__LINE__];
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
 //   self.effect.transform.projectionMatrix = projectionMatrix;
 
    // Compute the model view matrix for the object rendered with GLKit
    GLKMatrix4 modelViewMatrix;
    [camera update];
    modelViewMatrix = camera.current;
    
    

    
    GLKVector2 o = [self computWeightedMean:centerSamples];
    
    GLKVector3 e2 ={-o.x,o.y, 3.f};
    camera.eye = e2;
   
    GLKVector2 u = [self computWeightedMean:upSamples];
    GLKVector3 up = {-u.y, u.x, 0.f};
        
    
    up = GLKVector3Normalize(up);
    up.x = -up.x;
    if (up.x == up.x && up.y == up.y){
        camera.up = up;
    }
    
    
    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    glUseProgram(_program);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLES, 0, 36*8);
    

}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader, fsPrev, vsPrev;
    NSString *vertShaderPathname, *fragShaderPathname, *fsPrevPath, *vsPrevPath;
    
    _previewProgram = glCreateProgram();
    
    fsPrevPath = [[NSBundle mainBundle] pathForResource:@"Preview" ofType:@"fsh"];
    vsPrevPath = [[NSBundle mainBundle] pathForResource:@"Preview" ofType:@"vsh"];
    
    {
        if (![self compileShader:&vsPrev type:GL_VERTEX_SHADER file: vsPrevPath])
        {
            printf("crap");
            return NO;
        }
        if (![self compileShader:&fsPrev type:GL_FRAGMENT_SHADER file: fsPrevPath])
        {
            printf("poops");
            return NO;
        }
          [self checkGLErrors:__LINE__];
        glAttachShader(_previewProgram, vsPrev);
        glAttachShader(_previewProgram, fsPrev);
        
        glBindAttribLocation(_previewProgram, ATTRIB_VERTEX, "aPos");
        glBindAttribLocation(_previewProgram, ATTRIB_COORD, "aCoord");
        
        if (![self linkProgram:_previewProgram]) {
            NSLog(@"Failed to link program: %d", _program);
            
            if (vsPrev) {
                glDeleteShader(vsPrev);
                vertShader = 0;
            }
            if (fsPrev) {
                glDeleteShader(fsPrev);
                fragShader = 0;
            }
            if (_program) {
                glDeleteProgram(_program);
                _program = 0;
            }
            
            return NO;
        }

        glUseProgram(_previewProgram);
        
        uniforms[UNIFORM_SAMP_Y] = glGetUniformLocation(_previewProgram, "uSampY");
        uniforms[UNIFORM_SAMP_UV] = glGetUniformLocation(_previewProgram, "uSampUV");
        
        glUniform1i(uniforms[UNIFORM_SAMP_Y], GL_TEXTURE0);
        glUniform1i(uniforms[UNIFORM_SAMP_UV], GL_TEXTURE1);
        
        glDeleteShader(vsPrev);
        glDeleteShader(fsPrev);
          [self checkGLErrors:__LINE__];
    }
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_program, ATTRIB_NORMAL, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
      [self checkGLErrors:__LINE__];
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
      [self checkGLErrors:__LINE__];
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
      [self checkGLErrors:__LINE__];
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
