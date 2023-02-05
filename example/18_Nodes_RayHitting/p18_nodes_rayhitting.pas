// ----------------------------------------------------------------------------
// Пример 18: Выбор нода, задействуя виртуальный луч
// Пример показывает возможность выбора определённого нода на сцене через луч,
// который по-сути является линией в 3D пространстве.
// ----------------------------------------------------------------------------

program p18_Nodes_RayHitting;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
const TEST_NODES = 19;
var
  MeshTexture: wTexture                 	= nil;
  TestNode: array [0..TEST_NODES] of wNode;
  SelectedNode: wNode                    	= nil;
  OurCamera: wNode                       	= nil;
  BitmapFont: wFont                      	= nil;
  material: wMaterial                    	= nil;
  position: wVector3f;
  moveSpeed: Float32                    	= 20.0;
  start_vector, end_vector, deltaPos: wVector3f;
  fromPos, toPos: wVector2i;
  message: wString;
  message2: wString                             = 'MOVE RAY WITH W A S D TO DETECT COLLISION';
  wndCaption: wString 				= 'Example 18: Selecting Nodes with a Ray FPS: ';
  prevFPS: Int32;
  fontPath: PChar                               = 'Assets/Fonts/3.png';
  texPath: PChar                                = 'Assets/Textures/Metal.jpg';
  i: integer;
  backColor: wColor4s;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;
  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(fontPath);
  CheckFilePath(texPath);

  {Load resources}
  BitmapFont:= wFontLoad(fontPath);
  MeshTexture:= wTextureLoad(texPath);

  for i:=0 to TEST_NODES-1 do
  begin
    TestNode[i]:= wNodeCreateCube(10, false, wCOLOR4s_WHITE);
    wNodeSetId(TestNode[i],i);

    position.x:=0;
    position.y:=sin((i+1)/3)*50;
    position.z:=cos((i+1)/3)*50;
    wNodeSetPosition(TestNode[i],position);

    material:=wNodeGetMaterial(TestNode[i],0);
    wMaterialSetTexture(material,0,MeshTexture);
    wMaterialSetFlag(material,wMF_LIGHTING,false);
  end;

  position.x:=120;
  position.y:=50;
  position.z:=50;

  OurCamera := wCameraCreate(position,wVECTOR3f_ZERO);
  start_vector.x := 100;
  backColor:= wColor4sCreate(255,128,128,128);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(backColor);
    wSceneDrawAll();

    //Check keyboard events
    if wInputIsKeyPressed(wKC_KEY_W)or wInputIsKeyPressed(wKC_UP) then
        deltaPos.y :=-moveSpeed*wTimerGetDelta();


    if wInputIsKeyPressed(wKC_KEY_S) or wInputIsKeyPressed(wKC_DOWN) then
        deltaPos.y:=moveSpeed*wTimerGetDelta();


    if wInputIsKeyPressed(wKC_KEY_A) or wInputIsKeyPressed(wKC_LEFT)then
        deltaPos.z:=moveSpeed*wTimerGetDelta();


    if wInputIsKeyPressed(wKC_KEY_D) or wInputIsKeyPressed(wKC_RIGHT) then
        deltaPos.z:=-moveSpeed*wTimerGetDelta();


    //Find selected node
    SelectedNode := wCollisionGetNodeFromRay(@start_vector,@end_vector);

    //Reposition all of the objects
    for i:= 0 to TEST_NODES -1 do
    wNodeMove(TestNode[i],deltaPos);


    //Set debug mode for selected node
    if SelectedNode= nil then
    begin
      for i:=0 to TEST_NODES-1 do
      wNodeSetDebugMode(TestNode[i],wDM_OFF);
      message:='NOTHING SELECTED';
    end
    else
    begin
      wNodeSetDebugMode(SelectedNode,wDM_BBOX);
      message:='NODE('+IntToStr(wNodeGetId(SelectedNode))+') SELECTED';
    end;

    //Draw text info
    fromPos:=wVector2iCreate(300,10);
    toPos:= wVector2iCreate(500,20);
    wFontDraw( BitmapFont, message, fromPos,toPos, wCOLOR4s_WHITE);

    wFontDraw(BitmapFont, message2, wVector2iCreate(170,570),wVector2iCreate(500,586), wCOLOR4s_WHITE);

    //Draw ray
    w3dDrawLine(start_vector,end_vector,wCOLOR4s_RED);

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

