{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas(WorldSim3D developer)
'' Адаптировал Vuvk
'' ----------------------------------------------------------------------------
'' Пример 10: Террейн (ландшафт местности), Скайбокс и Туман
'' Пример создаёт Террейн из битмап-файла карты высот и отображает его. Также
'' на сцену добавлен туман.
'' ----------------------------------------------------------------------------
}
program p10_TerrainAndFog;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  material : wMaterial;
  vec1 : wVector3f;

  TerrainTexture0,
  TerrainTexture1 : wTexture;

  sTextures : array [0..5] of wTexture;

  SkyBox,
  Camera,
  Terrain : wNode;
                               
  wndCaption : PWChar = 'Example 10: Terrain and Fog ';
  i : Integer;
  prevFPS : Int32=0;

  sPath : array [0..5] of PChar = ('Assets/SkyBoxes/Trivial/Skybox_up.jpg',
                                   'Assets/SkyBoxes/Trivial/Skybox_dn.jpg',
                                   'Assets/SkyBoxes/Trivial/Skybox_rt.jpg',
                                   'Assets/SkyBoxes/Trivial/Skybox_lf.jpg',
                                   'Assets/SkyBoxes/Trivial/Skybox_ft.jpg',
                                   'Assets/SkyBoxes/Trivial/Skybox_bk.jpg');
  tPath : array [0..2] of PChar = ('Assets/Heightmaps/terrain-heightmap.bmp',
                                   'Assets/Textures/terrain-texture.jpg',
                                   'Assets/Textures/detailmap3.jpg');

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
  for i := 0 to High(tPath) do
    if (not CheckFilePath(tPath[i])) then
      Halt;

  for i := 0 to High(sPath) do
    begin
      if (not CheckFilePath(sPath[i])) then
        Halt
      else
        sTextures[i] := wTextureLoad(sPath[i]);
    end;

  ///Load resources
  TerrainTexture0 := wTextureLoad(tPath[1]);
  TerrainTexture1 := wTextureLoad(tPath[2]);

  ///Create terrain
  Terrain := wTerrainCreate(tPath[0], wVECTOR3f_ZERO, wVECTOR3f_ZERO, wVECTOR3f_ONE,
                            wCOLOR4s_WHITE, 0, 5, wTPS_17);

  vec1 := to_wVector3f(40.0, 4.4, 40.0);
  wNodeSetScale(Terrain,vec1);

  material := wNodeGetMaterial(Terrain, 0);
  wMaterialSetTexture(material,0,TerrainTexture0);
  wMaterialSetTexture(material,1,TerrainTexture1);
  wMaterialSetFlag(material,wMF_LIGHTING,false);
  wMaterialSetType(material,wMT_DETAIL_MAP);
  wMaterialSetFlag(material,wMF_FOG_ENABLE,true);

  wTerrainScaleDetailTexture(Terrain, to_wVector2f(1.0, 60.0));

  ///Set scene fog
  wSceneSetFog(to_wColor4s(255,240,200,200), wFT_LINEAR, 0.0, 3000.0, 0.5,true,true);
                    
  ///Create sky box
  SkyBox := wSkyBoxCreate(sTextures[0],
                          sTextures[1],
                          sTextures[2],
                          sTextures[3],
                          sTextures[4],
                          sTextures[5]);

  ///Create camera
  Camera := wFpsCameraCreate(100,0.1,@wKeyMapDefault[0],8,false,0);

  vec1 := to_wVector3f(3950,1100,5114);
  wNodeSetPosition(Camera,vec1);
  wCameraSetClipDistance(Camera,12000,1);

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


