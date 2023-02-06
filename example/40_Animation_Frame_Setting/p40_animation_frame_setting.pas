{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 40: Установить кадр анимации
'' Этот пример загружает 3D модель MD2 и анимирует её, устанавливая текущий
'' кадр анимации
'' ----------------------------------------------------------------------------}

program p40_Animation_Frame_Setting;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  MD2Mesh: wMesh;
  MeshTexture: wTexture;
  SceneNode, OurCamera: wNode;
  frame, prevFPS: Int32;
  material: wMaterial;
  wndCaption: wString ='Example 40: Setting the animation frame ';

  meshPath: Pchar = 'Assets/Models/Characters/Blade/Blade.md2';
  texMeshPath: PChar = 'Assets/Models/Characters/Blade/Blade.jpg';

  i: integer;

begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(meshPath);
  CheckFilePath(texMeshPath);

  {Load resources}
  MD2Mesh := wMeshLoad(meshPath);
  MeshTexture:=wTextureLoad(texMeshPath);

  {Show engine logo}
  wEngineShowLogo(true);

  {Create test node}
  SceneNode := wNodeCreateFromMesh(MD2Mesh);

  {Configure node materials}
  For i := 0 To wNodeGetMaterialsCount(SceneNode) - 1 do
  begin
    material:=wNodeGetMaterial(SceneNode,i);
    wMaterialSetFlag(material,wMF_LIGHTING,false);
    wMaterialSetTexture(material,0,MeshTexture);
  end;

  {Set the animation frame, for example, 300
  The animation is played from the 300th frame, not from the start}
  wNodeSetAnimationFrame(SceneNode,300.0);

  {Create camera}
  OurCamera := wCameraCreate(wVector3fCreate(55,0,0),wVECTOR3f_ZERO);

  {Hide mouse cursor}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,120,120,125));

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

