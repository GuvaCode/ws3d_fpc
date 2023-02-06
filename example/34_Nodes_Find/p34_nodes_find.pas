// ----------------------------------------------------------------------------
// Пример 34: Найти ноды
// Пример создаёт и помечает ноды на сцене, а затем находит их.
// Это особенно полезно, когда сцена загружается из файла сцены.
// ----------------------------------------------------------------------------
program p34_Nodes_Find;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  CreatedNode: wNode;
  FoundNode: wNode;
  NodeTexture: wTexture;
  Camera: wNode;
  position: array[0..9] of wVector3f;
  vec1: wVector3f;
  material: wMaterial;

  wndCaption: wString 	= 'Example 34: Finding nodes FPS: ';
  texPath: PChar        = 'Assets/Textures/Metal.jpg';
  prevFPS: Int32;
  i: Integer;

begin

  Position[0]:=wVector3fCreate(-30,-30, 0);
  Position[1]:=wVector3fCreate(-30,0,0);
  Position[2]:=wVector3fCreate(-30,30,0);
  Position[3]:=wVector3fCreate(0,-30,0);
  Position[4]:=wVector3fCreate(0,0,0);
  Position[5]:=wVector3fCreate(0,30,0);
  Position[6]:=wVector3fCreate(30,-30,0);
  Position[7]:=wVector3fCreate(30,0,0);
  Position[8]:=wVector3fCreate(30,30,0);

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(texPath);

  {Load resources}
  NodeTexture:=wTextureLoad(texPath);

  {Create nodes}
  for i:=0 to 8 do
    begin
      if (i+1) mod 2=0 then
      CreatedNode:=wNodeCreateCube(20,false,wCOLOR4s_WHITE)
      else
      CreatedNode:=wNodeCreateSphere(10,16,false,wCOLOR4s_WHITE);

      material:=wNodeGetMaterial(CreatedNode,0);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
      wMaterialSetTexture(material,0,NodeTexture);
      wNodeSetId(CreatedNode,i+1);
    end;

  {Create camera}
  vec1.x:=0; vec1.y:=0; vec1.z:=75;
  Camera:=wCameraCreate(vec1,wVECTOR3f_ZERO);

  PrintWithColor('*********************************************************',wCFC_YELLOW,false);
  PrintWithColor('If this works correctly we should not find nodes 0 and 10',wCFC_YELLOW,false);
  PrintWithColor('*********************************************************',wCFC_YELLOW,false);

  //now search for the nodes through their ID's and position them into a grid
  //we are deliberately looking for the unknown ID's 0 and 10 to generate an error
  for i:=0 to 10 do
  begin
  FoundNode:=wSceneGetNodeById(i);
  if FoundNode<> nil then
  wNodeSetPosition(FoundNode,position[i-1])
  else
  PrintWithColor(PChar('Could not find the node ID '+IntToStr(i)),wCFC_LIGHTGREEN,false);
  end;

  {Hide mouse cursor}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,120,125,125));

    wSceneDrawAll();

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

