precision mediump float;

uniform sampler2D uSampY;
uniform sampler2D uSampUV;

varying vec2 vCoord;

const vec3 dY = vec3(-0.87075,0.52975,-1.08175);
const vec3 dU = vec3(0.0,-0.391,2.018);
const vec3 dV = vec3(1.596,-0.813,0.0);

void main(void)
{
    
    vec3 pY = texture2D(uSampY, vCoord).rrr;
    vec2 pUV = texture2D(uSampUV, vCoord).ra;
    
    gl_FragColor = vec4(dY + (1.164*pY) + (dU*pUV.xxx) + (dV*pUV.yyy),1.0);
    
}