// ----------------------------------------------------------------------------
// Пример сделал Vuvk
// Адаптировал Nikolas (WorldSim3D developer)
// ----------------------------------------------------------------------------
// Пример 01: Hello World
// Этот простой пример открывает окно WorldSim3D, показывает текст Hello World
// на экране и ожидает когда пользователь закроет приложение.
// ----------------------------------------------------------------------------

program p16_2DTextOn3DModel;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;


{ Declare custom procedure }
procedure Get3DTextPosition(font: wFont; const text: WString; target: wNode; p1, p2: PwVector2i);
var minSize,maxSize: wVector3f;
    position: wVector3f;
    textSize: wVector2u;
    textPosition: wVector2i;
    targetHeight: Float32;

begin
  position := wNodeGetAbsolutePosition(target);
  wNodeGetTransformedBoundingBox(target,@minSize,@maxSize);
  targetHeight := (maxSize.y-minSize.y);

  position.y += targetHeight;
  textPosition := wCollisionGetScreenCoordFrom3dPosition(position);
  textSize := wFontGetTextSize(font,text);

  p1^.x := textPosition.x-textSize.x div 2;
  p2^.x := textPosition.x+textSize.x div 2;

  p1^.y := textPosition.y-textSize.y;
  p2^.y := textPosition.y;
end;

{Declare variables}
var
 Alex_model: wMesh               	= nil;
 MeshTexture: wTexture            	= nil;
 CharacterNode: wNode            	= nil;
 OurCamera: wNode                 	= nil;
 BitmapFont: wFont                	= nil;
 anim1: wAnimator 	        	= nil;
 wndCaption: WString 			= 'Example 16: 2D Text at a 3D Location FPS: ';
 modelCaption: WString			= 'ALEX';
 fromPos, toPos: wVector2i;
 textColor, backColor: wColor4s;
 dTime: Float32;
 prevFPS: Int32                        = 0;
 fontPath: PChar                       = 'Assets/Fonts/3.png';
 meshPath: PChar                       = 'Assets/Models/Characters/Alex/Alex.ms3d';
 texPath: PChar                        = 'Assets/Models/Characters/Alex/body.jpg';
 vec1: wVector3f;
 i: integer;
 material: wMaterial;

begin
  fromPos:= wVECTOR2i_ZERO;
  toPos:= wVECTOR2i_ZERO;
  textColor:= wCOLOR4s_WHITE;
  dTime:= 0.0;
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(fontPath);
  CheckFilePath(meshPath);
  CheckFilePath(texPath);

  {Load resources}
  BitmapFont := wFontLoad(fontPath);
  Alex_model := wMeshLoad(meshPath);
  MeshTexture := wTextureLoad(texPath);

  {Create test node}
  CharacterNode := wNodeCreateFromMesh(Alex_model);

  vec1:= wVector3fCreate(5,5,5);
  wNodeSetScale(CharacterNode,vec1);

  vec1:= wVector3fCreate(0,180,0);
  wNodeSetRotation(CharacterNode,vec1);

  {Configure node materials}
  for i:=0 to wNodeGetMaterialsCount (CharacterNode)-1 do
  begin
    material:= wNodeGetMaterial(CharacterNode, i);
    wMaterialSetFlag(material ,wMF_LIGHTING, false);
    wMaterialSetTexture(material, 0, MeshTexture);
  end;

  {Create animator}
  anim1 := wAnimatorFlyingCircleCreate(CharacterNode,wVECTOR3f_ZERO,30,0.0004,wVECTOR3f_UP,0,0);

  OurCamera := wFpsCameraCreate(100,0.1,@wKeyMapDefault[1],8,false,0);

  vec1:= wVector3fCreate(0,5,-45);
  wNodeSetPosition(OurCamera, vec1);

  vec1:= wVector3fCreate(0,5,0);
  wCameraSetTarget(OurCamera,vec1);

  wInputSetCursorVisible(false);
  backColor:= wColor4sCreate(255,64,96,96);

  {Main loop}
  while wEngineRunning() do
  begin
  wSceneBegin(backColor);

  wSceneDrawAll();

  Get3DTextPosition(BitmapFont, modelCaption, CharacterNode, @fromPos, @toPos);

  dTime:= dTime + wTimerGetDelta();

    If dTime > 0.1 Then
       begin
         textColor.alpha -=1;
         dTime :=0;
       end;

  wFontDraw(BitmapFont, modelCaption, fromPos, toPos, textColor);

  wSceneEnd();

  {Close by ESC}
  wEngineCloseByEsc();

  {Update fps}
    if prevFPS <> wEngineGetFPS() then
       begin
         prevFPS:=wEngineGetFPS();
         wWindowSetCaption(wndCaption+WStr(FormatFloat('0',prevFPS)));
    end;
  end;

  {Stop engine}
  wEngineStop(true);
end.

