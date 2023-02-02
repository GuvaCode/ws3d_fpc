{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas(WorldSim3D developer)
'' Адаптировал Vuvk
'' ----------------------------------------------------------------------------
'' Пример 08: Тени и свет
'' Пример загружает карту и модель на сцену, а затем применяет в реальном времени
'' тени к модели. Эти тени отбрасываются от света на сцене, который можно видеть
'' на поверхности других объектов.
'' ----------------------------------------------------------------------------
}
program p08_ShadowAndLights;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  material : wMaterial;
  vec1 : wVector3f;

  MD2Mesh,
  BSPMesh : wMesh;
  MeshTexture : wTexture;
  SceneNode,
  BSPNode,
  OurCamera,
  CameraNode,
  Light : wNode;
                               
  wndCaption : PWChar = 'Example 08: Shadows and Lights ';
  i : Integer;
  prevFPS : Int32=0;

  fPath : PChar = 'Assets/BSPmaps/ctfcomp02_hazard.pk3';
  mPath : PChar = 'Assets/Models/Characters/Lizard/Lizard.md2';
  tPath : PChar = 'Assets/Models/Characters/Lizard/Lizard.jpg';

begin
  // -----------------------------------------------------------------------------
  // start the WorldSim3D interface
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
    begin
      PrintWithColor('wEngineStart() failed!', wCFC_RED, true);
      Halt;
    end;

  ///Show logo WS3D
  wEngineShowLogo(true);

  ///Check resources
  if (not CheckFilePath(fPath) or
      not CheckFilePath(mPath) or
      not CheckFilePath(tPath)) then
    Halt;

  ///Load resources
  wFileAddZipArchive(fPath,true,true);
  BSPMesh := wMeshLoad('ctfcomp02_hazard.bsp');
  MeshTexture := wTextureLoad(tPath);
  MD2Mesh := wMeshLoad(mPath);

  ///Create nodes
  BSPNode := wNodeCreateFromMeshAsOctree(BSPMesh);

  SceneNode := wNodeCreateFromMesh(MD2Mesh);

  vec1 := to_wVector3f(3,3,3);
  wNodeSetScale(SceneNode,vec1);

  vec1 := to_wVector3f(258, 336, 2849);
  wNodeSetPosition(SceneNode,vec1);

  ///Setting node materials
  for i := 0 to wNodeGetMaterialsCount(SceneNode) - 1 do
    begin
      material := wNodeGetMaterial(SceneNode,i);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
      wMaterialSetTexture(material,0,MeshTexture);
    end;

  ///Configure node animations
  wNodePlayMD2Animation(SceneNode,wMAT_STAND);

  ///Add volume shadow to node
  wNodeAddShadowVolume(SceneNode,nil,true,10000,true);

  ///Create camera
  CameraNode := wFpsCameraCreate(100,0.1,@wKeyMapDefault[0],8,false,0);

  vec1 := to_wVector3f(470, 346, 2864);
  wNodeSetPosition(CameraNode,vec1);

  vec1 := to_wVector3f(-2504, 288, 2918);
  wCameraSetTarget(CameraNode,vec1);

  ///Create light
  vec1 := to_wVector3f(358, 346, 2749);
  Light := wLightCreate(vec1, to_wColor4f(1, 0.3, 0.3, 0.3), 600);

  ///Configure environment
  wSceneSetShadowColor(to_wColor4s(130,0,0,0));

  wSceneSetAmbientLight(to_wColor4f(1, 0.9, 0.9, 0.9));

  ///Hide mouse cursor
  wInputSetCursorVisible(false);

  // -----------------------------------------------------------------------------
  // while the WorldSim3D environment is still running
  while wEngineRunning do
    begin
      // clear the canvas to black to show the particles up better
      wSceneBegin(wCOLOR4s_BLACK);

      // draw the scene
      wSceneDrawAll();

      // end drawing the scene and display it
      wSceneEnd();
             
      ///Close by ESC
      wEngineCloseByEsc();

      {Update fps}
      if prevFPS<>wEngineGetFPS() then
         begin
           prevFPS:=wEngineGetFPS();
           wWindowSetCaption(wndCaption+WStr(FormatFloat('0',prevFPS)));
         end;
    end;

  // -----------------------------------------------------------------------------
  // Stop the WorldSim3D engine and release resources
  wEngineStop(true);
end.


