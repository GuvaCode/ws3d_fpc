// ----------------------------------------------------------------------------
// Пример сделал Vuvk
// ----------------------------------------------------------------------------
// Пример сделал Nikolas (WorldSim3D developer)
// Адаптировал для Паскаль GuvaCode
// ----------------------------------------------------------------------------
// Пример 36 : Простые материалы
// В примере динамически меняются свойства материалов во время выполнения
// программы.
// ----------------------------------------------------------------------------

program p36_Materials_Simple;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  SphereNode, Light, Camera: wNode;
  material: wMaterial;
  emissiveColor: wColor4s = (alpha:255; red:0; green:0; blue:0);
  EmittedDirection: Int32 = 1;
  wndCaption: wString = 'Example 36: Simple Materials ';
  prevFPS: Int32;


begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Create node}
  SphereNode:=wNodeCreateSphere(30.0,64,false,wColor4s_White);

  {Set material parameters}
  material:=wNodeGetMaterial(SphereNode,0);
  wMaterialSetVertexColoringMode(material,wCM_NONE);

  wMaterialSetShininess(material,25.0);

  wMaterialSetSpecularColor(material,wColor4sCreate(0,255,0,0)); //specularColor
  wMaterialSetDiffuseColor(material,wColor4sCreate(0,0,255,0)); //diffuseColor
  wMaterialSetAmbientColor(material,wColor4sCreate(0,0,0,255)); //ambientColor

  {Create camera}
  Camera:=wCameraCreate(wVector3fCreate(0,0,60),wVECTOR3f_ZERO);

  {Create light}
  Light:=wLightCreate(wVector3fCreate(-100,100,100),wColor4fCreate(1.0, 0.25,0.25,0.25),600.0);
  wSceneSetAmbientLight(wColor4fCreate(1.0,0.1,0.1,0.1));

  {Hide mouse cursor}
  wInputSetCursorVisible(false);
  emissiveColor.alpha:=255;

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wCOLOR4s_BLACK);
    wMaterialSetEmissiveColor (material, emissiveColor);

    emissiveColor.red+=EmittedDirection;
    emissiveColor.green+=EmittedDirection;
    emissiveColor.blue+=EmittedDirection;

    if emissiveColor.red = 255 Then
        EmittedDirection := -1
    else
        If emissiveColor.red=0 Then EmittedDirection := 1;

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

