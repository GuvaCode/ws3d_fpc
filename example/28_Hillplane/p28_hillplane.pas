// Пример 28: Равнина с холмами (Hillplane)
// Пример создаёт Террейн через объект Hillplane, который является генерируемым
// мешем с координатной сеткой и неровной поверхностью.
// ----------------------------------------------------------------------------

program p28_Hillplane;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  TerrainNode: wNode;// TerrainNode          	=0
  TerrainTexture0: wTexture;// TerrainTexture0   	=0
  TerrainTexture1: wTexture;//    	=0
  Camera: wNode;//                	=0
  Hillmesh: wMesh;//              	=0
  HillNode: wNode;//              	=0
  material: wMaterial;//          	=0
  tilesSize: wVector2f;//          	=(8.f,8.f)
  tilesCount: wVector2i;//         	=(32,32)
  hillHeight: Float32           	= 6;
  hillCount: wVector2f;//          	=(4.f,3.f)
  hillTexRepeat: wVector2f;//      	=(5.f,5.f)
  vec1: wVector3f;//               	=wVECTOR3f_ZERO
  wndCaption: wString 			= 'Example 28: Hill Planes FPS: ';
  prevFPS: Int32;//				=0
  texPath: Pchar                        = 'Assets/Textures/terrain-texture.jpg';
  texPath2: PChar                       = 'Assets/Textures/detailmap3.jpg';
  i: integer;
  backColor: wColor4s;
begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(texPath);
  CheckFilePath(texPath2);

  {Load resources}
  TerrainTexture0:=wTextureLoad(texPath);
  TerrainTexture1:=wTextureLoad(texPath2);

  {Create mesh}
  tilesSize:= wVector2fCreate(8,8);
  tilesCount:= wVector2iCreate(32,32);
  hillCount:= wVector2fCreate(4,3);
  hillTexRepeat:= wVector2fCreate(5,5);
  Hillmesh:=wMeshCreateHillPlane('HillPlane', tilesSize, tilesCount, nil, hillHeight, hillCount, hillTexRepeat);

  {Create node}
  HillNode:=wNodeCreateFromMesh(Hillmesh);

  for i:=0 to wNodeGetMaterialsCount(HillNode)-1 do
  begin
    material:=wNodeGetMaterial(HillNode,i);
    wMaterialSetFlag(material,wMF_LIGHTING,false);
    wMaterialSetType(material,wMT_DETAIL_MAP);
    wMaterialSetTexture(material,0,TerrainTexture0);
    wMaterialSetTexture(material,1,TerrainTexture1);
  end;

  {Create camera}
  Camera:=wFpsCameraCreate(100,0.1,@wKeyMapDefault,8,false,0);

  vec1.x:=0; vec1.y:=50; vec1.z:=0;
  wNodeSetPosition(Camera,vec1);

  {Hide mouse cursor}
  wInputSetCursorVisible(false);

  backColor:=wColor4sCreate(255,240, 255, 255);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(backColor);

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

