// ----------------------------------------------------------------------------
// Пример сделал Vuvk
// Адаптировал Nikolas (WorldSim3D developer)
// ----------------------------------------------------------------------------
// Пример 01: Hello World
// Этот простой пример открывает окно WorldSim3D, показывает текст Hello World
// на экране и ожидает когда пользователь закроет приложение.
// ----------------------------------------------------------------------------

program p35_Scene_Saving;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  PlainNode, CubeNode, CharNode, ContainerNode, Camera, Light, SkyBox: wNode;
  Plain, CharMesh, ContainerMesh: wMesh;
  PlainTexture, CubeTexture, CharTexture, ContainerTexture: wTexture;
  skyTexture: array[0..5] of wTexture;
  material: wMaterial;

  wndCaption: wString = 'Example 35: Saving a scene ';
  prevFPS: Int32 = 0;

  plainPath:    PChar = 'Assets/Models/Sci-fi_floor2.obj';
  charPath:     PChar = 'Assets/Models/Characters/Blade/Blade.md2';
  conPath:      PChar = 'Assets/Models/Round_container.x';

  plainTexPath: PChar ='Assets/Textures/Floor_2.jpg';
  cubeTexPath:  PChar ='Assets/Textures/default_texture.png';
  charTexPath:  PChar ='Assets/Models/Characters/Blade/Blade.jpg';
  conTexPath:   PChar ='Assets/Textures/Round_container.png';

  skyTexPath: array[0..5] of PChar;
  i: Integer;
begin
  skyTexPath[0] := 'Assets/SkyBoxes/Deadmeat/skybox_up.jpg';
  skyTexPath[1] := 'Assets/SkyBoxes/Deadmeat/skybox_dn.jpg';
  skyTexPath[2] := 'Assets/SkyBoxes/Deadmeat/skybox_rt.jpg';
  skyTexPath[3] := 'Assets/SkyBoxes/Deadmeat/skybox_lf.jpg';
  skyTexPath[4] := 'Assets/SkyBoxes/Deadmeat/skybox_ft.jpg';
  skyTexPath[5] := 'Assets/SkyBoxes/Deadmeat/skybox_bk.jpg';

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(plainPath);
  CheckFilePath(charPath);
  CheckFilePath(conPath);
  CheckFilePath(plainTexPath);
  CheckFilePath(cubeTexPath);
  CheckFilePath(charTexPath);
  CheckFilePath(conTexPath);
  For i:= 0 to 5 do
  CheckFilePath(skyTexPath[i]);


  {Load resources}
  Plain:=wMeshLoad(plainPath);
  CharMesh:=wMeshLoad(charPath);
  ContainerMesh:=wMeshLoad(conPath);

  PlainTexture:=wTextureLoad(plainTexPath);
  CharTexture:=wTextureLoad(charTexPath);
  ContainerTexture:=wTextureLoad(conTexPath);
  CubeTexture:=wTextureLoad(cubeTexPath);
  For i := 0 to 5 do
  skyTexture[i]:=wTextureLoad(skyTexPath[i]);

  {Create nodes}
  PlainNode:=wNodeCreateFromMesh(Plain);
  CubeNode:=wNodeCreateCube(4,false,wColor4s_White);
  CharNode:=wNodeCreateFromMesh(CharMesh);
  ContainerNode:=wNodeCreateFromMesh(ContainerMesh);

  SkyBox:=wSkyBoxCreate(skyTexture[0],skyTexture[1],skyTexture[2], skyTexture[3],skyTexture[4],skyTexture[5]);

  {Configure nodes}
  For i:= 0 To wNodeGetMaterialsCount(PlainNode) - 1 do
  begin
      material:=wNodeGetMaterial(PlainNode,i);
      wMaterialSetTexture(material,0,PlainTexture);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
  end;

  For i:= 0 To wNodeGetMaterialsCount(CharNode) - 1 do
  begin
      material:=wNodeGetMaterial(CharNode,i);
      wMaterialSetTexture(material,0,CharTexture);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
  end;

  For i := 0 To wNodeGetMaterialsCount(ContainerNode) - 1 do
  begin
      material:=wNodeGetMaterial(ContainerNode,i);
      wMaterialSetTexture(material,0,ContainerTexture);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
  end;

  For i := 0 To wNodeGetMaterialsCount(CubeNode) - 1 do
  begin
      material:=wNodeGetMaterial(CubeNode,i);
      wMaterialSetTexture(material,0,CubeTexture);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
  end;

  wNodeSetPosition(CubeNode, wVector3fCreate(5,2,28));

  wNodeSetPosition( CharNode, wVector3fCreate(15,7,20));

  wNodeSetPosition(ContainerNode, wVector3fCreate(25,0,5));

  wNodeSetScale(CharNode, wVector3fCreate(0.3,0.3,0.3));

  wNodeSetScale(ContainerNode, wVector3fCreate(3,3,3));

  {Create camera}
  Camera:=wFpsCameraCreate(100, 0.1, @wKeyMapDefault, 8, FALSE, 0);

  wNodeSetPosition(Camera,wVector3fCreate(30,8,30));
  wCameraSetTarget(Camera,wVECTOR3f_ZERO);

  {Create light}
  Light:=wLightCreate(wVector3fCreate(100,100,100), wColor4fCreate(1.0,0.9,0.7,0.3),1000);
  wSceneSetAmbientLight(wCOLOR4f_WHITE);

  {Hide mouse cursor}
  wInputSetCursorVisible(false);

  wSceneSave('Assets/Scenes/Myscene2.irr');

  wSceneDestroyAllNodes();
  wSceneDestroyAllMeshes();

  wSceneLoad('Assets/Scenes/Myscene2.irr');

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

