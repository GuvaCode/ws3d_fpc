{ ----------------------------------------------------------------------------
 Пример сделал Nikolas(WorldSim3D developer)
 Адаптировал Tiranas
 ----------------------------------------------------------------------------
 Пример 45: Управление ресурсами сцены
 Пример загружает и создаёт несколько моделей, а затем, через несколько секунд
 удаляет их все, чтобы (и перед тем как) создать другую сцену. Этими приёмами
 можно менять объекты на сцене, например, для создания разных уровней (локаций)
 в игре или отдельных анимаций, таким образом освобождая память для других ресурсов.
 ----------------------------------------------------------------------------'}

program p45_Scene_Resources;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  MD2Mesh, BarrelMesh, CrateMesh, BeastMesh: wMesh;
  MeshTexture, BeastTexture, BarrelTexture, CrateTexture: wTexture;
  SceneNode, BeastNode, OurCamera, Light: wNode;
  BarrelNode, CrateNode: array[0..2] of wNode;
  BitmapFont: wFont;
  vec1: wVector3f;
  material: wMaterial;
  frame, prevFPS: Int32;
  endFrame: Boolean = false;
  fromPos: wVector2i = (x:350; y:15);
  toPos: wVector2i = (x:450; y:30);

  wndCaption:wString 	='Example 45: Managing Scene Resources ';
  fontPath: PChar ='Assets/Fonts/2.png';

  texturePath, meshPath: array [0..1] of PChar;
  i: integer;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  meshPath[0] := 'Assets/Models/Characters/Blade/Blade.md2';
  meshPath[1] := 'Assets/Models/Psionic/cratesbarrels/barrel.3ds';
  texturePath[0] := 'Assets/Models/Characters/Blade/Blade.jpg';
  texturePath[1] := 'Assets/Models/Psionic/cratesbarrels/jonb1.jpg';

  {Check resources}
  CheckFilePath(fontPath);
  CheckFilePath(meshPath[0]);
  CheckFilePath(meshPath[1]);
  CheckFilePath(texturePath[0]);
  CheckFilePath(texturePath[1]);

  {Load resources}
  BitmapFont := wFontLoad(fontPath);
  MD2Mesh := wMeshLoad(meshPath[0]);
  MeshTexture := wTextureLoad(texturePath[0]);
  BarrelMesh := wMeshLoad(meshPath[1]);
  BarrelTexture := wTextureLoad(texturePath[1]);

  {Create scene nodes}
  SceneNode := wNodeCreateFromMesh(MD2Mesh);
    For i:= 0 To wNodeGetMaterialsCount(SceneNode) - 1 do
    begin
      material:=wNodeGetMaterial(SceneNode,i);
      wMaterialSetTexture(material,0,MeshTexture);
    end;

    wNodePlayMD2Animation(SceneNode,wMAT_STAND);

     //vec1.x=0.2f: vec1.y=0.2f: vec1.z=0.2f
     For i :=  0 To 2 do
     begin
       BarrelNode[i] := wNodeCreateFromMesh(BarrelMesh);
       wNodeSetScale(BarrelNode[i],wVector3fCreate(0.2,0.2,0.2));
       material:=wNodeGetMaterial(BarrelNode[i],0);
       wMaterialSetTexture(material,0,BarrelTexture);
     end;

     wNodeSetPosition(BarrelNode[0], wVector3fCreate(0,-25,-30));

     wNodeSetPosition(BarrelNode[1], wVector3fCreate(0,-25,30));

     wNodeSetPosition(BarrelNode[2], wVector3fCreate(-25,-25,0));

     {Add a simple point light}
     Light := wLightCreate(wVector3fCreate(-100,100,100), wColor4fCreate(1,0.9,0.9,0.9), 600);

     {Apply a low ambient lighting level to the light source}
     wLightSetAmbientColor(Light, wColor4fCreate(1,0.1,0.7,0.5));

     {Add a camera into the scene, the first co-ordinates represents the 3D
     location of our view point into the scene the second co-ordinates specify the
     target point that the camera is looking at}
     OurCamera := wCameraCreate(wVector3fCreate(50,25,25),wVECTOR3f_ZERO);

  {====== Rendering LEVEL 1 ======== }
  // Display the scene for 180 frames (that is 6 seconds)
  while wEngineRunning() and not endFrame do
  begin
    wSceneBegin(wColor4sCreate(255,30,25,25));

    wSceneDrawAll();

    wFontDraw(BitmapFont, 'LEVEL 1', fromPos,toPos, wColor4s_White);

    wSceneEnd();

    Inc(frame);

    if (frame >= 3600) Then
    begin
    frame := 0;
    endFrame := true;
    end;
    wEngineCloseByEsc();

    {Update fps}
    if prevFPS<>wEngineGetFPS() then
       begin
         prevFPS:=wEngineGetFPS();
         wWindowSetCaption(wndCaption+WStr(FormatFloat('0',prevFPS)));
    end;

  end;

  {Clear the scene removing all nodes and then all meshes}
  wSceneDestroyAllNodes();
  wSceneDestroyAllUnusedMeshes();

  meshPath[0] := 'Assets/Models/Psionic/freebeast/beast.ms3d';
  meshPath[1] := 'Assets/Models/Psionic/cratesbarrels/crate01.3ds';

  texturePath[0] := 'Assets/Models/Psionic/freebeast/beast4.jpg';
  texturePath[1] := 'Assets/Models/Psionic/cratesbarrels/crate01.jpg';

  {Check resources}
  CheckFilePath(fontPath);
  CheckFilePath(meshPath[0]);
  CheckFilePath(meshPath[1]);
  CheckFilePath(texturePath[0]);
  CheckFilePath(texturePath[1]);

  BeastMesh := wMeshLoad(meshPath[0]);
  BeastTexture := wTextureLoad(texturePath[0]);
  CrateMesh := wMeshLoad(meshPath[1]);
  CrateTexture := wTextureLoad(texturePath[1]);

  {Create scene nodes}
  BeastNode := wNodeCreateFromMesh(BeastMesh);
  For i := 0 To wNodeGetMaterialsCount(BeastNode) - 1 do
  begin
    material:=wNodeGetMaterial(BeastNode,i);
    wMaterialSetTexture(material,0,BeastTexture);
  end;
  wNodeSetScale(BeastNode, wVector3fCreate(0.2,0.2,0.2));

  wNodeSetRotation(BeastNode, wVector3fCreate(0,-140,0));

  wNodeSetPosition(BeastNode,wVector3fCreate(15,-25,0));

  For i := 0 To 2 do
  begin
  CrateNode[i] := wNodeCreateFromMesh(CrateMesh);
  wNodeSetScale(CrateNode[i],wVector3fCreate(0.2,0.2,0.2));
  material:=wNodeGetMaterial(CrateNode[i],0);
  wMaterialSetTexture(material,0,CrateTexture);
  end;

  wNodeSetPosition(CrateNode[0], wVector3fCreate(0,-25,-40));
  wNodeSetPosition(CrateNode[1], wVector3fCreate(0,-25,40));
  wNodeSetPosition(CrateNode[2], wVector3fCreate(-25,-25,0));

  Light := wLightCreate(wVector3fCreate(-100,100,100), wColor4fCreate(1,0.1,0.1,0.1), 600);

  wLightSetAmbientColor(Light, wColor4fCreate(1,0.9,0.25,1));

  OurCamera := wCameraCreate(wVector3fCreate(70,15,45),wVECTOR3f_ZERO);

  {====== Rendering LEVEL 2 ========}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,30,25,25));

    wSceneDrawAll();

    wFontDraw(BitmapFont, 'LEVEL 2', fromPos,toPos, wColor4s_White);

    wSceneEnd();

    {Close by ESC}
    wEngineCloseByEsc();

    {Update FPS}
    if (prevFPS <> wEngineGetFPS()) Then
    begin
      prevFPS := wEngineGetFPS();
      wWindowSetCaption(wndCaption+IntToStr(prevFPS));
    end;

  end;
  {Stop engine}
  wEngineStop(true);
end.

