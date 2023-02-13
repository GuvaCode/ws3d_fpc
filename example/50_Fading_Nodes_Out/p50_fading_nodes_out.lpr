{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 50: Постепенное исчезновение нодов
'' Пример показывает, как сделать так, чтобы нод постепенно исчез со сцены через
'' использование свойств материала.
'' ----------------------------------------------------------------------------}
program p50_Fading_Nodes_Out;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

var
  MD2Mesh: wMesh;
  MeshTexture, SphereTexture: wTexture;
  Material: wMaterial;
  SceneNode, Light, SphereNode, OurCamera: wNode;
  prevFps: Int32;
  wndCaption: wString = 'Example 50: Fading Nodes Out ';
  meshPath: PChar = 'Assets/Models/Characters/Blade/Blade.md2';
  meshTexPath: PChar = 'Assets/Models/Characters/Blade/Blade.jpg';
  earthTexPath: PChar = 'Assets/Models/earth.jpg';
  i: integer;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(meshPath);
  CheckFilePath(meshTexPath);
  CheckFilePath(earthTexPath);

   {Load resources}
   MD2Mesh := wMeshLoad(meshPath);
   MeshTexture := wTextureLoad(meshTexPath);
   SphereTexture := wTextureLoad(earthTexPath);

   {Create a simple sphere object in the background so that the transparency of
   the nodes can be seen}
   SphereNode := wNodeCreateSphere(30.0,16, false, wCOLOR4s_WHITE);

   wNodeSetPosition(SphereNode,wVector3fCreate(-50,0,50));

   Material := wNodeGetMaterial(SphereNode,0);
   wMaterialSetAmbientColor(Material,wCOLOR4s_BLACK);
   wMaterialSetDiffuseColor(Material,wCOLOR4s_WHITE);
   wMaterialSetTexture(Material,0,SphereTexture);

   {Create a simple sphere object in the background so that the transparency of
   the nodes can be seen}
   SphereNode := wNodeCreateSphere(30.0,16, false, wColor4s_White);

   wNodeSetPosition(SphereNode,wVector3fCreate(-50,0,-50));

   Material:=wNodeGetMaterial(SphereNode,0);
   wMaterialSetAmbientColor(Material,wCOLOR4s_BLACK);
   wMaterialSetDiffuseColor(Material,wCOLOR4s_WHITE);
   wMaterialSetTexture(Material,0,SphereTexture);

   {Add a copy of the model to the scene to use as a reference, paint it and
   move it into position}
   SceneNode := wNodeCreateFromMesh(MD2Mesh);

   wNodeSetPosition(SceneNode,wVector3fCreate(0,0,-25));

   for i := 0 to wNodeGetMaterialsCount(SceneNode) - 1 do
   begin
     Material := wNodeGetMaterial(SceneNode,i);
     wMaterialSetTexture(Material,0,MeshTexture);
   end;


   {Add a second copy of the model to the scene this is the model that will be
   faded out}
   SceneNode := wNodeCreateFromMesh(MD2Mesh);

  // Dim as wColor4s clr=(255,32,32,32)
  for i := 0 to wNodeGetMaterialsCount(SceneNode) - 1 do
  begin
       Material := wNodeGetMaterial(SceneNode,i);
       wMaterialSetTexture(Material,0,MeshTexture);
       wMaterialSetType(Material,wMT_TRANSPARENT_ADD_COLOR);
       wMaterialSetVertexColoringMode(Material,wCM_NONE);
       wMaterialSetAmbientColor(Material,wColor4sCreate(255,32,32,32));
       wMaterialSetDiffuseColor(Material,wColor4sCreate(255,32,32,32));
   end;

   wNodePlayMD2Animation(SceneNode,wMAT_STAND);

   {Create camera}
   OurCamera := wCameraCreate(wVector3fCreate(50,0,0),wVECTOR3f_ZERO);

   {Create light}
   Light := wLightCreate(wVector3fCreate(-100,100,100), wCOLOR4f_WHITE,600.0);

   wSceneSetAmbientLight(wCOLOR4f_WHITE);

   {Hide mouse}
   wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,100,100,100));

    wSceneDrawAll();

    wSceneEnd();

    wEngineCloseByEsc();

    {Update fps}
    if prevFPS<>wEngineGetFPS() then
    begin
      prevFPS:=wEngineGetFPS();
      wWindowSetCaption(wndCaption + WStr(FormatFloat('0',prevFPS)));
    end;

end; 

{Stop engine}
wEngineStop(true);
end.

