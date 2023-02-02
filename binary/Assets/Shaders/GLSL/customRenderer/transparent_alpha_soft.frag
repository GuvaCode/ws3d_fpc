uniform sampler2D Tex0;
uniform sampler2D Tex1;
uniform float ScreenWidth;
uniform float ScreenHeight;
uniform float Lighting;

#define FACTOR 5.0

varying float Depth;
varying vec3 Normal;


void main()
{
    vec2 coord = gl_FragCoord.xy / vec2(ScreenWidth, ScreenHeight);
    float backgroundDepth = texture2D(Tex1, coord).r;
    
    if (Depth > backgroundDepth)
        discard;

    float diff = backgroundDepth - Depth;
    float softness = clamp(FACTOR * diff, 0.0, 1.0);

    vec4 color = texture2D(Tex0, gl_TexCoord[0].xy);

    vec4 color2 = color * vec4(1.0, 1.0, 1.0, softness);
    
   /*vec3 vNormal;
    float vDepth;

    if(Lighting < 0.5)
    {
        vNormal= vec3(0.0);
        vDepth= 1.0;
    }
    else
    {
        vNormal = normalize(Normal);
        vNormal *= 0.5;
        vNormal += 0.5;
        vDepth = Depth;
    }*/

    gl_FragData[0] = color2;
    //gl_FragData[1] = vec4(vNormal * Lighting, 0.0);
    //gl_FragData[2] = vec4(vDepth, 0.0, 0.0, 0.0);
    
}
