{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas(WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 54: Задать цвет небесному куполу (Skydome)
'' Пример создаёт небесный купол с определённым цветом, на который можно
'' наложить текстуру низкого цветового разрешения. Небесному куполу можно придать
'' другой цвет, чтобы смоделировать разное время дня без необходимости менять
'' сам фон небесного купола.
'' ----------------------------------------------------------------------------}
program p54_Skydome_Colored;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

var
  Terrain, Camera, TerrainNode, SkyDome: wNode;
  TerrainTexture0, TerrainTexture1, SkyDomeTexture: wTexture;
  Material: wMaterial;
  tH, vect: wVector2f;
  vec1: wVector3f;
  prevFps: Int32;
  wndCaption: wString = 'Example 54: Colored Skydomes ';
  terrainHeightMapPath: PChar = 'Assets/Heightmaps/terrain-heightmap.bmp';
  terrainTexturePath1: PChar = 'Assets/Textures/terrain-texture.jpg';
  terrainTexturePath2: PChar = 'Assets/Textures/detailmap3.jpg';
  skyTexturePath: PChar = 'Assets/Textures/skydome.jpg';


begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(terrainHeightMapPath);
  CheckFilePath(terrainTexturePath1);
  CheckFilePath(terrainTexturePath2);
  CheckFilePath(skyTexturePath);

  {Load resources}
  TerrainTexture0 := wTextureLoad(terrainTexturePath1);
  TerrainTexture1 := wTextureLoad(terrainTexturePath2);
  SkyDomeTexture := wTextureLoad(skyTexturePath);

  {Create terrain}
  Terrain := wTerrainCreate(terrainHeightMapPath, wVECTOR3f_ZERO, wVECTOR3f_ZERO,
                            wVECTOR3f_ONE, wColor4s_WHITE, 0,5, wTPS_17);
  vec1.x:=40; vec1.y:=4.4; vec1.z:=40;
  wNodeSetScale(Terrain,vec1);

  vect.x:=1; vect.y:=60;
  wTerrainScaleDetailTexture(Terrain,vect);
  Material := wNodeGetMaterial(Terrain,0);
  wMaterialSetTexture(Material,0,TerrainTexture0);
  wMaterialSetTexture(Material,1,TerrainTexture1);
  wMaterialSetType(Material,wMT_DETAIL_MAP);
  wMaterialSetFlag(Material,wMF_LIGHTING,false);
  wMaterialSetFlag(Material,wMF_FOG_ENABLE,true);

  {Create skyDome}
  //The skydome is a simple hollow sphere that surrounds the whole scene. a single
  //texture is applied to the entire surface of the sphere. Portions of the sphere
  //can be rendered to optimise the performance of the scene
  SkyDome := wSkyDomeCreate(SkyDomeTexture, 32, // horizontal resolution
                          16,                   //vertical resolution
                          1,                    //texture percentage
                          1.2,                  //sphere percentage
                          1000);                //sky dome radius

  // Here we color the dome the first 3 RGB values set the color of the horizon,
  // the second set of RGB values set the color of the zenith of the dome
  //                        horizonColor=(255,228,128,0)   zenithColor=(255,64,64,125)
  wSkyDomeSetColor(SkyDome,wColor4sCreate(255,228,128,0),wColor4sCreate(255,64,64,125));

  //Here we add an addition yellowed band of color onto the dome, the first three
  //parameters are the color, followed by the vertical vertex number of the center
  //of the band, next the amount the band will be faded 1.0 is not at all, and
  //the final <true> parameter means that the color will be added to the existing
  //color a value of <false> epecifies that the color will replace the existing color
  //horizonColor.red=240
  //horizonColor.green=12
  //horizonColor.blue=28

  wSkyDomeSetColorBand(SkyDome, wColor4sCreate(255,240,12,28),
                       24,    //position
                       0.25,  //fade factor
                       TRUE); //is additive

  //Here we add a point of light to the dome, this is useful for representing the
  //sun or the moon glaring in the atmosphere, the first three parameters are the
  //color of the light, the next three are the vector<x,y,z> position of the light, the
  //next parameter is the radius of the light effect, this is followed by how much
  //the effect is faded a value of 1.0 is not at all, finally <true> as above
  //means that the color effect will be added to the existing color on the dome
  vec1.x:=1000; vec1.y:=-250; vec1.z:=0;      //horizonColor
  wSkyDomeSetColorPoint(SkyDome, wColor4sCreate(255,255,220,96),
                        vec1,  //3d-position
                        1500,  //radius
                        0.75,  //fade factor
                        TRUE); //is additive


  {Create camera}
  Camera := wFpsCameraCreate(100, 0.5, @wKeyMapDefault, 8, FALSE, 0);
  wCameraSetClipDistance(Camera,12000,1);
  vec1.x:=3942; vec1.y:= 650; vec1.z:= 5113;
  wNodeSetPosition(Camera,vec1);

   vec1.x:=19; vec1.y:=-185.5; vec1.z:=0;
  wNodeSetRotation(Camera,vec1);

  {Set fog}
  //fogColor=(255,96,96,128)
  wSceneSetFog(wColor4sCreate(255,96,96,128),wFT_LINEAR, 0, 5000, 0.5);

  {Hide mouse}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,240,255,255));

    vec1 := wNodeGetPosition(Camera);
    tH.x := vec1.x;
    tH.y := vec1.z;
    vec1.y := wTerrainGetHeight(Terrain,tH)+80;
    wNodeSetPosition(Camera,vec1);

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

