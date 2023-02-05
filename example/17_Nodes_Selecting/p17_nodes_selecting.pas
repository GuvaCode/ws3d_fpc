// Пример 17 : Выбор определённого нода мышкой
// В примере показана возможность выбирать определённый нод, двигая мышкой по
// экрану и наводя её на нужный нод.

program p17_Nodes_Selecting;
{$WARN 5027 off : Local variable "$1" is assigned but never used}
{$WARN 4104 off : Implicit string type conversion from "$1" to "$2"}
{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{user defines}
const
  TEST_NODES = 25;

{Declare variables}
var
  MeshTexture: wTexture            	= nil;
  TestNode: array [0..TEST_NODES] of wNode;
  SelectedNode: wNode              	= nil;
  OurCamera: wNode                 	= nil;
  BitmapFont: wFont                	= nil;
  MouseEvent: PwMouseEvent;
  position, target: wVector3f;//
  material: wMaterial              	= nil;
  textInfo: wString			= ' ';
  wndCaption: wString 			= 'Example 17: Selecting Nodes with the Mouse';
  prevFPS: Int32 			= 0;
  fontPath: PChar                       = 'Assets/Fonts/4.png';
  texPath: PChar                        = 'Assets/Textures/Metal.jpg';
  i: Integer;
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

    position:= wVector3fCreate(0,(i div 5) * 20,(i mod 5) * 20);

    wNodeSetPosition(TestNode[i],position);

    material:= wNodeGetMaterial(TestNode[i],0);
    wMaterialSetTexture(material,0,MeshTexture);
    wMaterialSetFlag(material,wMF_LIGHTING,false);
  end;

  position:= wVector3fCreate(120,40,40);
  target:= wVector3fCreate(0,40,40);
  OurCamera:= wCameraCreate(position,target);
  backColor:= wColor4sCreate(255,100,100,255);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(backColor);
    wSceneDrawAll();

    while wInputIsMouseEventAvailable() do
    begin
           MouseEvent := wInputReadMouseEvent();

           if MouseEvent^.action = wMET_MOUSE_MOVED then
               SelectedNode := wCollisionGetNodeFromScreen(MouseEvent^.position, 0, false, nil);
               if SelectedNode = nil then
                  for i:=0 to TEST_NODES-1 do
                       wNodeSetDebugMode(TestNode[i],wDM_OFF)
               else
                   for i:=0 to TEST_NODES-1 do
                       if SelectedNode=TestNode[i] then
                          wNodeSetDebugMode(TestNode[i],wDM_BBOX);
    end;


       if SelectedNode = nil then
         textInfo:= 'NOTHING SELECTED AT ' + IntToStr(MouseEvent^.position.x)+' '+IntToStr(MouseEvent^.position.y)
       else
         textInfo:= 'NODE('+IntToStr(wNodeGetId(SelectedNode))+') SELECTED AT '+
         IntToStr(MouseEvent^.position.x)+' ' +IntToStr(MouseEvent^.position.y);

       wFontDraw (BitmapFont, textInfo, wVector2iCreate(10,10) , wVector2iCreate(200,20), wCOLOR4s_WHITE);

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

