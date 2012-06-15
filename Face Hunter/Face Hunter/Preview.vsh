attribute vec2 aPos;
attribute vec2 aCoord;

varying lowp vec2 vCoord;

void main(void)
{
    gl_Position = vec4(aPos,0.0,1.0);
    
    vCoord = aCoord;
}