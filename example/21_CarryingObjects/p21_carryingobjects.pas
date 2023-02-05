// Пример 21: Ношение предметов
// Пример показывает как присоединить дочернюю модель к родительской, в качестве
// которой здесь используется анимированная модель DirectX (.x), содержащая соединения
program p21_CarryingObjects;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  DirectXMesh: wMesh             	= nil;
  BoxTexture: wTexture         	        = nil;
  SceneNode: wNode             	        = nil;
  OurCamera: wNode             	        = nil;
  JointNode: wNode             	        = nil;
  TestNode: wNode              	        = nil;
  BitmapFont: wFont                     = nil;
  material: wMaterial          	        = nil;

  position, target: wVector3f;
  fromPos, toPos: wVector2i;

  wndCaption: PWchar 			= 'Example 21: Carrying Objects FPS: ';
  prevFPS: Int32                        = 0;
  i: Integer;
  fontPath: PChar                       = 'Assets/Fonts/3.png';
  meshPath: PChar                       = 'Assets/Models/Cartoon_guy.x';
  texPath: PChar                        = 'Assets/Textures/Metal.jpg';

  backColor: wColor4s;

begin

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
  DirectXMesh := wMeshLoad(meshPath);
  BoxTexture := wTextureLoad(texPath);

  {Create nodes}
  SceneNode := wNodeCreateFromMesh(DirectXMesh);

  for i:=0 to wNodeGetMaterialsCount(SceneNode) -1 do
  begin
    material:= wNodeGetMaterial(SceneNode,i);
    wMaterialSetFlag(material,wMF_LIGHTING,false);
  end;

  {Set the speed of playback for the animated Direct X model}
  wNodeSetAnimationSpeed(SceneNode, 400);

  {Add a camera into the scene pointing at the model}
  position:= wVector3fCreate(75,40,-50);
  target:= wVector3fCreate(0,40,0);
  OurCamera := wCameraCreate(position,target);

  {create a test node to represent the object that is being carried}
  TestNode := wNodeCreateCube(10, false, wCOLOR4s_WHITE);

  material := wNodeGetMaterial(TestNode,0);
  wMaterialSetTexture(material,0,BoxTexture);
  wMaterialSetFlag(material,wMF_LIGHTING,false);

  position:=wVector3fCreate(20,-15,-10);
  wNodeSetPosition(TestNode, position);

  JointNode := wNodeGetJointByName(SceneNode,'Joint16');

  wNodeSetParent(TestNode,JointNode);

  wInputSetCursorVisible(false);

  backColor:=wColor4sCreate(255,20,25,25);


  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(backColor);

    wSceneDrawAll();

    wFontDraw (BitmapFont,'The cube in the left hand is not a part of the model, it is attached to'+#13+
    'the specified joint on the animated node',fromPos,toPos, wCOLOR4s_WHITE);

    wSceneEnd();

    wEngineCloseByEsc();

    {Update fps}
    if prevFPS<>wEngineGetFPS() then
       begin
         prevFPS:=wEngineGetFPS();
         wWindowSetCaption(wndCaption+WStr(FormatFloat('0',prevFPS)));
    end;

  end;

  {Stop engine}
  wEngineStop(true);
end.

