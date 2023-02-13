{''----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas. Подправил Deviant.
'' ----------------------------------------------------------------------------
'' Пример 53: Трава
'' Пример использования объекта Трава, который накладывается на террейн для
'' создания дополнительных элементов травы, чтобы улучшить реалистичность.
'' ----------------------------------------------------------------------------'}
program p53_Grass;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

var
  Terrain, Camera, grassNode: wNode;
  grassPosition: wVector2i;
  vect: wVector2f;
  terrainTexture0, terrainTexture1, grassTexture: wTexture;
  terrainHeightMap, terrainColorMap, terrainGrassMap: wImage;
  Material: wMaterial;
  vec1: wVector3f;
  prevFps: Int32;
  wndCaption: wString = 'Example 53: Grass ';
  terrainHeightMapPath: PChar ='Assets/Heightmaps/terrain-heightmap.bmp';
  terrainTexturePath1: PChar ='Assets/Textures/terrain-texture.jpg';
  terrainTexturePath2: PChar ='Assets/Textures/grass_b.jpg';
  terrainGrassMapPath: PChar ='Assets/Textures/terrain-grassmap.bmp';
  grassTexPath: PChar ='Assets/Textures/grass.png';
  x, y, i: Integer;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(terrainHeightMapPath);
  CheckFilePath(terrainTexturePath1);
  CheckFilePath(terrainTexturePath2);
  CheckFilePath(terrainGrassMapPath);
  CheckFilePath(grassTexPath);

  {Load resources}
  terrainHeightMap := wImageLoad(terrainHeightMapPath);
  terrainColorMap := wImageLoad(terrainTexturePath1);
  terrainGrassMap := wImageLoad(terrainGrassMapPath);
  grassTexture := wTextureLoad(grassTexPath);
  terrainTexture0 := wTextureLoad(terrainTexturePath1);
  terrainTexture1 := wTextureLoad(terrainTexturePath2);

  {Create terrain}
  Terrain := wTerrainCreate(terrainHeightMapPath, wVECTOR3f_ZERO,wVECTOR3f_ZERO,wVECTOR3f_ONE,wColor4s_WHITE,0,6,wTPS_17);
  wNodeSetScale(Terrain,wVector3fCreate(40,2.4,40));

  vect.x:=1; vect.y:=60;
  wTerrainScaleDetailTexture(Terrain,vect);
  Material := wNodeGetMaterial(Terrain,0);
  wMaterialSetTexture(Material,0,terrainTexture0);
  wMaterialSetTexture(Material,1,terrainTexture1);
  wMaterialSetType(Material,wMT_DETAIL_MAP);
  wMaterialSetFlag(Material,wMF_LIGHTING,false);
  wMaterialSetFlag(Material,wMF_FOG_ENABLE,true);

  {Create grass}
  // We add the grass in as 100 seperate patches, these could even be grouped
  // under a set of zone managers to make them more efficient.
  For x := 0 To 2 do begin
      For y := 0 To 2 do begin
          // here we add the grass object, it has the following parameters: -
          // a terrain onto which the grass layered, '/// an x and y tile coordinate for the patch (multiplied by the patch size)
          // a size for the patch
          // the distance in patches upto which all blades of grass are drawn
          // whether pairs of grass are aligned in a cross wON to enable
          // a scale for the grass height
          // the height map associated with the terrain used for setting grass height
          // the texture map associated with the terrain used for coloring the grass
          // a grass map defining the types of grass placed onto the terrain
          // a texture map containing the images of the grass
          grassPosition.x:=x; grassPosition.y:=y;
          grassNode := wGrassCreate(Terrain, grassPosition,    //position
                                 1100*3,                       //patch size
                                 2.0,                          //fade distance
                                 TRUE,                         //crossed
                                 1.0,                          //grass scale
                                 10000,                        //max Density
                                 wVECTOR2u_ZERO,               //data position
                                 terrainHeightMap, terrainColorMap, terrainGrassMap, grassTexture);
          // here we set how much grass is visible firstly the number of grass
          // particles that can be seen and secondly the distance upto which they
          // are drawn
          wGrassSetDensity(grassNode,5000,4000.0);

          // here we set the wind effect on the grass, first parameter sets the
          // strength of the wind and the second the resoloution
          wGrassSetWind(grassNode,1.0,2.0);

          For i := 0 To wNodeGetMaterialsCount(grassNode) - 1 do
          begin
              Material := wNodeGetMaterial(grassNode,i);
              wMaterialSetFlag(Material,wMF_LIGHTING,false);
              wMaterialSetFlag(Material,wMF_FOG_ENABLE,true);
          end;
      end;
  end;

  {Create camera}
  Camera := wFpsCameraCreate(100, 0.5, @wKeyMapDefault, 8, FALSE, 0);
  wCameraSetClipDistance(Camera,10000.0,1);
  vec1.x:=3942.0; vec1.y:= 650.0; vec1.z:= 5113.0;
  wNodeSetPosition(Camera,vec1);

  vec1.x:=19; vec1.y:=-185.5; vec1.z:=0;
  wNodeSetRotation(Camera,vec1);

  {Set fog}
  wSceneSetFog(wColor4sCreate(255,64,100,128),wFT_LINEAR, 0.0,4000.0, 0.5);

  {Hide mouse}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,64,64,125));

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

