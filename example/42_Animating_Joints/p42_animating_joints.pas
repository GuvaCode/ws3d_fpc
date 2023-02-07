// ----------------------------------------------------------------------------
// Пример сделал Nikolas (WorldSim3D developer)
// Адаптировал Tiranas
// Адаптировал для паскаль GuvaCode
// ----------------------------------------------------------------------------
// Пример 42: Анимация отдельных костей вручную
// Пример загружает модель с костной анимацией, а затем программно управляет
// определённой костью.
// ----------------------------------------------------------------------------

program p42_Animating_Joints;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  CharMesh: wMesh;
  MeshTexture: wTexture;
  AnimatedNode, JointNode, OurCamera: wNode;
  material: wMaterial;
  rotation: wVector3f;

  wndCaption: wString = 'Example 42: Manually Animating Bones ';
  prevFPS: Int32;

  meshPath: PChar = 'Assets/Models/Cartoon_guy.x' ;
  meshTexPath: PChar = 'Assets/Models/Cartoon_guy.jpg';

  i: Integer;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(meshPath);
  CheckFilePath(meshTexPath);

  {Load resources}
  CharMesh := wMeshLoad(meshPath);
  MeshTexture := wTextureLoad(meshTexPath);

  {Create test nodes}
  AnimatedNode := wNodeCreateFromMesh(CharMesh);

  {Configure nodes materials}
   For i := 0 To wNodeGetMaterialsCount(AnimatedNode) - 1  do
   begin
       material:=wNodeGetMaterial(AnimatedNode,i);
       wMaterialSetFlag(material,wMF_LIGHTING,false);
   end;

   wNodeSetJointMode(AnimatedNode,wJM_CONTROL);
   JointNode:=wNodeGetJointByName(AnimatedNode,'Joint4');

   {Create camera}
   OurCamera := wCameraCreate(wVector3fCreate(75,30,0),wVector3fCreate(0,30,0));

   {Hide mouse cursor}
   wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,240,255,255));

     //Animates the mesh based on the position of the joints, this should be used at
     //the end of any manual joint operations including blending and joints animated
     //using wJM_CONTROL and wNodeSetRotation on a bone node
     wNodeAnimateJoints(AnimatedNode);

     //Rotate the node
     wNodeSetRotation(JointNode, rotation);
     rotation.x+= 0.02;

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

