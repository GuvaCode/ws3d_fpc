// ----------------------------------------------------------------------------
// Пример сделал Vuvk
// Адаптировал Nikolas (WorldSim3D developer)
// ----------------------------------------------------------------------------
// Пример 01: Hello World
// Этот простой пример открывает окно WorldSim3D, показывает текст Hello World
// на экране и ожидает когда пользователь закроет приложение.
// ----------------------------------------------------------------------------

program p33_Render_to_Texture;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  MD2Mesh: wMesh;
  MeshTexture: wTexture;
  RenderTexture: wTexture;
  TextureB: wTexture;
  SceneNode: wNode;
  CubeNode: wNode;
  StaticCamera: wNode;
  FPSCamera: wNode;
  RotationAnimator: wAnimator;
  material: wMaterial;
  vec1: wVector3f;
  textureSize: wVector2i;

  wndCaption: wString = 'Example 33: Rendering to a texture FPS: ';
  meshPath: PChar = 'Assets/Models/Characters/Blade/Blade.md2';
  meshTexPath: PChar = 'Assets/Models/Characters/Blade/Blade.jpg';

  prevFPS: Int32;
  i: Integer;

begin
  prevFPS:= 0;
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(meshPath);
  CheckFilePath(meshTexPath);

  {Load resources}
  MD2Mesh:=wMeshLoad(meshPath);
  MeshTexture:=wTextureLoad(meshTexPath);

  {Show engine logo}
  wEngineShowLogo(true);

  {Create nodes}
  SceneNode:=wNodeCreateFromMesh(MD2Mesh);

  for i:=0 to wNodeGetMaterialsCount(SceneNode)-1 do
  begin
    material:=wNodeGetMaterial(SceneNode,i);
    wMaterialSetFlag(material,wMF_LIGHTING,false);
    wMaterialSetTexture(material,0,MeshTexture);
  end;

  CubeNode:=wNodeCreateCube(10, false, wCOLOR4s_WHITE);
  material:=wNodeGetMaterial(CubeNode,0);
  wMaterialSetFlag(material,wMF_LIGHTING,false);

  {Create RTT}
  textureSize.x:=512; textureSize.y:=512;
  RenderTexture:=wTextureCreateRenderTarget(textureSize);
  wMaterialSetTexture(material,0,RenderTexture);

  vec1.x:=3; vec1.y:=2; vec1.z:=3;
  wNodeSetScale(CubeNode, vec1);

  vec1.x:=0; vec1.y:=0; vec1.z:=95;
  wNodeSetPosition(CubeNode,vec1);

  vec1.x:=0; vec1.y:=0.1; vec1.z:=0;

  {Create rotation animator}
  RotationAnimator:=wAnimatorRotationCreate(CubeNode,vec1);

  {Create cameras}
  vec1.x:=50; vec1.y:=0; vec1.z:=0;
  StaticCamera:=wCameraCreate(vec1,wVECTOR3f_ZERO);

  FPSCamera:=wFpsCameraCreate(100,0.1,@wKeyMapDefault,8,false,0);

  vec1.x:=40; vec1.y:=0; vec1.z:=110;
  wNodeSetPosition(FPSCamera,vec1);

  vec1.x:=0; vec1.y:=0; vec1.z:=80;
  wCameraSetTarget(FPSCamera,vec1);

  {Hide mouse cursor}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wCameraSetActive(StaticCamera);

    wSceneDrawToTexture(RenderTexture);

    wSceneBegin(wColor4sCreate(255,120,125,125));

    wCameraSetActive(FPSCamera);

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

