'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' ----------------------------------------------------------------------------
'' Пример 23: Тестирование возможностей видеокарты
'' Пример выполняет тестироваание каждой отдельной возможности видеокарты.
'' Обычно это полезно для того, чтобы узнать какие возможности поддерживает видеокарта,
'' чтобы применить соответствующие материалы к объектам сцены.
'' ----------------------------------------------------------------------------

'#define __STATIC__

#Include "../Include/WorldSim3D.bi"
#include "../Include/SampleFunctions.bi"

'///Variables
Dim as wDriverTypes driver_type		=wDRT_NULL

Dim as Int32 render                	=0

Dim as string wndCaption 			="Example 23: Video Feature Test "

Dim as string wDF_YES(wVDF_COUNT)={ "The driver is able to render to a surface",_
									"Hardeware transform and lighting is supported",_
									"Multiple textures per material are possible",_
									"The driver is able to render with a bilinear filter applied",_
									"The driver can handle mip maps",_
									"The driver can update mip maps automatically",_
									"Stencilbuffers are switched on and the device does support stencil buffers",_
									"Vertex Shader 1.1 is supported",_
									"Vertex Shader 2.0 is supported",_
									"Vertex Shader 3.0 is supported",_
									"Vertex Shader 4.0 is supported",_
									"Vertex Shader 4.2 is supported",_
									"Pixel Shader 1.1 is supported",_
									"Pixel Shader 1.2 is supported",_
									"Pixel Shader 1.3 is supported",_
									"Pixel Shader 1.4 is supported",_
									"Pixel Shader 2.0 is supported",_
									"Pixel Shader 3.0 is supported",_
									"Pixel Shader 4.0 is supported",_
									"Pixel Shader 4.2 is supported",_
									"ARB vertex programs v1.0 are supported",_
									"ARB fragment programs v1.0 are supported",_
									"GLSL is supported",_
									"HLSL is supported",_
									"non-power-of-two textures are supported",_
									"framebuffer objects are supported",_
									"vertex buffer objects are supported",_
									"alpha to coverage is supported",_
									"color masks are supported",_
									"multiple render targets are supported",_
									"seperate blend settings for render targets are supported",_
									"seperate color masks for render targets are supported",_
									"seperate blend functions for render targets are supported",_
									"geometry shaders are supported",_
									"occlusion query are supported",_
									"poligon offset are supported",_
									"blend operations are supported",_
									"separate blending for RGB and Alpha are supported",_
									"texture coord transformation via texture matrix are supported",_
									"DXTn compressed textures are supported",_
									"PVRTC compressed textures are supported",_
									"PVRTC2 compressed textures are supported",_
									"ETC1 compressed textures are supported",_
									"ETC2 compressed textures are supported",_
									"cube map textures are supported"}

Dim as string wDF_NO(wVDF_COUNT)={  "The driver is NOT able to render to a surface",_
									"Hardeware transform and lighting is NOT supported",_
									"Multiple textures per material are NOT possible",_
									"The driver is NOT able to render with a bilinear filter applied",_
									"The driver can NOT handle mip maps",_
									"The driver can NOT update mip maps automatically",_
									"Stencilbuffers are NOT switched on or are unsupported",_
									"Vertex Shader 1.1 is NOT supported",_
									"Vertex Shader 2.0 is NOT supported",_
									"Vertex Shader 3.0 is NOT supported",_
									"Vertex Shader 4.0 is NOT supported",_
									"Vertex Shader 4.2 is NOT supported",_
									"Pixel Shader 1.1 is NOT supported",_
									"Pixel Shader 1.2 is NOT supported",_
									"Pixel Shader 1.3 is NOT supported",_
									"Pixel Shader 1.4 is NOT supported",_
									"Pixel Shader 2.0 is NOT supported",_
									"Pixel Shader 3.0 is NOT supported",_
									"Pixel Shader 4.0 is NOT supported",_
									"Pixel Shader 4.2 is NOT supported",_
									"ARB vertex programs v1.0 are NOT supported",_
									"ARB fragment programs v1.0 are NOT supported",_
									"GLSL is NOT supported",_
									"HLSL is NOT supported",_
									"non-power-of-two textures are NOT supported",_
									"framebuffer objects are NOT supported",_
									"vertex buffer objects are NOT supported",_
									"alpha to coverage is NOT supported",_
									"color masks are NOT supported",_
									"multiple render targets are NOT supported",_
									"seperate blend settings for render targets are NOT supported",_
									"seperate color masks for render targets are NOT supported",_
									"seperate blend functions for render targets are NOT supported",_
									"geometry shaders are NOT supported",_
									"occlusion query are NOT supported",_
									"poligon offset are NOT supported",_
									"blend operations are NOT supported",_
									"separate blending for RGB and Alpha are NOT supported",_
									"texture coord transformation via texture matrix are NOT supported",_
									"DXTn compressed textures are NOT supported",_
									"PVRTC compressed textures are NOT supported",_
									"PVRTC2 compressed textures are NOT supported",_
									"ETC1 compressed textures are NOT supported",_
									"ETC2 compressed textures are NOT supported",_
									"cube map textures are NOT supported"}

print("Which render should be used?")
print("1 - OPENGL")
print("2 - DIRECT3D9")
print("3 - BURNINGS_VIDEO")
print("ANY - NULL DRIVER")

input(render)
driver_type=wDRT_NULL
	
select case render
    case 1
        driver_type=wDRT_OPENGL
    case 2
        driver_type=wDRT_DIRECT3D9
    case 3
        driver_type=wDRT_BURNINGS_VIDEO
end select
	
'///Start engine
Dim as Boolean init=wEngineStart(driver_type,wVECTOR2u_ZERO,32,false,true,true,false)
if not init then
   PrintWithColor("wEngineStart() failed!",wCFC_RED,true)
   end
endif

'/// Set the title of the display
wWindowSetCaption(wndCaption)


for i as Int32 =0 to wVDF_COUNT-1
    if wEngineIsQueryFeature(i) then
       PrintWithColor(wDF_YES(i),wCFC_GREEN,false)
       print("")
    else
       PrintWithColor(wDF_NO(i),wCFC_RED,false)
       print("")
    endif
next i

'/// Stop the WorldSim3D engine and release resources
wEngineStop()

print("Press a key to finish...")

wInputWaitKey()

end
