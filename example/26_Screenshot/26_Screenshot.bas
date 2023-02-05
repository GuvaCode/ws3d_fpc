'' ----------------------------------------------------------------------------
'' Пример сделал Frank Dodd
'' Изменил Alec (WorldSim3D developer)
'' Адаптировал Nikolas (WorldSim3D developer)
'' ----------------------------------------------------------------------------
'' Пример 26: Сделать скриншот
'' В примере показано, как сделать скриншот и сохранить его в файл.
'' В данном примере скриншот делается после 100 кадров (фреймов)
'' ----------------------------------------------------------------------------

'#define __STATIC__

#Include "../Include/WorldSim3D.bi"
#include "../Include/SampleFunctions.bi"

'///Variables
Dim as wMesh BeastMesh                	=0
Dim as wTexture MeshTexture           	=0
Dim as wNode SceneNode                	=0
Dim as wNode Camera                   	=0
Dim as wFont BitmapFont               	=0
Dim as wMaterial material             	=0
Dim as wVector3f vector1				=wVECTOR3f_ZERO

Dim as Int32 frame                     	=0
Dim as Boolean _screen                 	=false

Dim as wVector2i fromPos               	=(170, 0)
Dim as wVector2i toPos                 	=(400, 36)

Dim as string wndCaption 				="Example 26: Taking a screenshot FPS: "

Dim as Int32 prevFPS                   	=0

'///Start engine
Dim as Boolean init=wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,false,true,false)
if not init then
   PrintWithColor("wEngineStart() failed!",wCFC_RED,true)
   end
endif

'///Show logo WS3D
wEngineShowLogo(true)

dim as string fontPath="../../Assets/Fonts/3.png"
dim as string meshPath="../../Assets/Models/Psionic/freebeast/beast.x"
dim as string meshTexPath="../../Assets/Models/Psionic/freebeast/beast3.jpg"

'///Check resources
CheckFilePath(fontPath)

CheckFilePath(meshPath)

CheckFilePath(meshTexPath)

'///Load resources
MeshTexture=wTextureLoad(meshTexPath)
BitmapFont=wFontLoad(fontPath)
BeastMesh=wMeshLoad(meshPath)

'///Create nodes
SceneNode=wNodeCreateFromMesh(BeastMesh)

for i as Int32=0 to wNodeGetMaterialsCount(SceneNode)-1
     material=wNodeGetMaterial(SceneNode,i)
     wMaterialSetFlag(material,wMF_LIGHTING,false)
     wMaterialSetTexture(material,0,MeshTexture)
next i

vector1.x=0.2f : vector1.y=0.2f : vector1.z=0.2f
wNodeSetScale(SceneNode,vector1)

'///Create camera
vector1.x=0 : vector1.y=0 : vector1.z=-4
Camera=wCameraCreate(vector1,wVECTOR3f_ZERO)

'///Hide mouse cursor
wInputSetCursorVisible(false)

while wEngineRunning()
   wSceneBegin(wCOLOR4s_BLACK)

   wSceneDrawAll()

   frame+=1
   if (frame>500) then frame=0

    if frame=500 then
		if not _screen then 
			_screen=wSystemSaveScreenShot( "../../Assets/Sprites/myScreen.bmp" )
		endif
	endif
    
    if _screen then wFontDraw(BitmapFont, "Screenshot taken: ../../Assets/Sprites/myScreen.bmp",fromPos,toPos)

    wSceneEnd()

    '///Close by ESC
    wEngineCloseByEsc()

    '///Update FPS
    if prevFPS <> wEngineGetFPS() then
       prevFPS = wEngineGetFPS()
       wWindowSetCaption(wndCaption+str(prevFPS))
	endif
 wend

'///Stop engine
wEngineStop()

end
