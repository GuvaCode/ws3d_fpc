{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 57: Чтение и запись (для сохранения) имён объектов
'' Пример демонстрирует чтение и запись имён объектов, что пригодится для определения
'' или сохранения информации внутри объекта.
'' ----------------------------------------------------------------------------}
program p57_Node_Name;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

var
  MD2Mesh: wMesh;
  MeshTexture: wTexture;
  SceneNode: wNode;
  OurCamera: wNode;
  vec1: wVector3f;
  material: wMaterial;
  prevFps, saveColors: Int32;
  wndCaption: wString = 'Example 57: Reading and Writing the Name of Objects ';
  meshPath: PChar ='Assets/Models/Characters/Blade/Blade.md2';
  meshTexPath: PChar = 'Assets/Models/Characters/Blade/Blade.jpg';
  NodeName: PChar;
  i: integer;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(meshPath);
  CheckFilePath(meshTexPath);

  {Load resources}
  MD2Mesh := wMeshLoad(meshPath);
  MeshTexture := wTextureLoad(meshTexPath);

  {Create test node}
  SceneNode := wNodeCreateFromMesh(MD2Mesh);

  for i := 0 to wNodeGetMaterialsCount(SceneNode) do
  begin
    material := wNodeGetMaterial(SceneNode,i);
    wMaterialSetFlag(material,wMF_LIGHTING,false);
    wMaterialSetTexture(material,0,MeshTexture);
  end;

  {Set the node name}
  wNodeSetName(SceneNode, 'Blade');

  {Read the name back}
  NodeName := wNodeGetName(SceneNode);

  saveColors := wConsoleSaveDefaultColors();
  wConsoleSetFontColor(wCFC_YELLOW);
  writeln('The name read back in is ' + NodeName^);
  wConsoleResetColors(saveColors);

  wNodePlayMD2Animation(SceneNode,wMAT_STAND);

  {Create camera}
  vec1.x:=50; vec1.y:=20; vec1.z:=0;
  OurCamera := wCameraCreate(vec1,wVECTOR3f_ZERO);

  {Hide mouse}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,0,10,5));

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

