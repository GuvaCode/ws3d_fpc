program p51_Clouds;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

var 
  Terrain, Camera, CloudNode: wNode;
  TerrainTexture0, TerrainTexture1, CloudTexture: wTexture;
  Material: wMaterial;
  TerrainHeight: Float32;
  tPos, vect: wVector2f;
  prevFps: Int32;
  wndCaption: wString = 'Example 51: Billboard Clouds ';
  cPath: PChar = 'Assets/Textures/cloud4.png';
  hPath: PChar = 'Assets/Heightmaps/terrain-heightmap.bmp';
  tPath: PChar = 'Assets/Textures/terrain-texture.jpg';
  dPath: PChar = 'Assets/Textures/detailmap3.jpg';
  vec1: wVector3f;
  i: integer;
begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(cPath);
  CheckFilePath(hPath);
  CheckFilePath(tPath);
  CheckFilePath(dPath);

  {Load resources}
  CloudTexture := wTextureLoad(cPath);
  TerrainTexture0 := wTextureLoad(tPath);
  TerrainTexture1 := wTextureLoad(dPath);

  {Add the clouds to the scene
  the first parameter is the level of detail, higher values add more structure
  to the cloud when it is closer to the camera
  the second parameter sets the number of child clouds created higher values
  create more structure
  the third parameter defines how many clouds are created}
  CloudNode := wCloudsCreate(CloudTexture,3,1,500);
  for i := 0 To wNodeGetMaterialsCount(CloudNode) - 1 do
  begin
    Material := wNodeGetMaterial(CloudNode,i);
    wMaterialSetFlag(Material,wMF_FOG_ENABLE,false);
  end;

  wNodeSetPosition(CloudNode,wVector3fCreate(0,2700,0));

  wAnimatorRotationCreate(CloudNode, wVector3fCreate(0,0.01,0));

  {Create terrain}
  Terrain := wTerrainCreate(hPath,wVECTOR3f_ZERO,wVECTOR3f_ZERO, wVECTOR3f_ONE, wColor4s_WHITE, 0, 5, wTPS_17);

//  vec1.x=40.f: vec1.y=4.4f: vec1.z=40.f
  wNodeSetScale(Terrain,wVector3fCreate(40,4.4,40));

  Material := wNodeGetMaterial(Terrain,0);
  wMaterialSetFlag(Material,wMF_LIGHTING,false);
  wMaterialSetFlag(Material,wMF_FOG_ENABLE,true);
  wMaterialSetType(Material,wMT_DETAIL_MAP);
  wMaterialSetTexture(Material,0,TerrainTexture0);
  wMaterialSetTexture(Material,1,TerrainTexture1);

  vect.x:=1.0; vect.y:=60.0;
  wTerrainScaleDetailTexture(Terrain,vect);

  {Set fog}
  wSceneSetFog(wColor4sCreate(255,128,128,255),wFT_LINEAR,0.0,4000.0,0.5);

  {Create camera}
  Camera := wFpsCameraCreate(100, 0.5, @wKeyMapDefault, 8, FALSE, 0);
  wNodeSetPosition(Camera,wVector3fCreate(3942.8,1102.7,5113.9 ));
  wCameraSetClipDistance(Camera,12000,1);

  {Hide mouse}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,128,128,255));
    vec1 := wNodeGetPosition(Camera);
    tPos.x := vec1.x;
    tPos.y := vec1.z;
    TerrainHeight := wTerrainGetHeight(Terrain,tPos)+50;

    if (vec1.y< TerrainHeight) Then
    begin
       vec1.y := TerrainHeight;
       wNodeSetPosition(Camera, vec1);
    end;

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

