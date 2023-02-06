// ----------------------------------------------------------------------------
// Пример 38: Динамическое освещение
// Пример динамически  изменяет свойства освещения
// во время выполнения программы
// ----------------------------------------------------------------------------

program p38_Lighting_Dynamic;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  SphereNode, Light, LightAmbient, Camera: wNode;
  NodeTexture: wTexture;
  Material: wMaterial;
  attenuation: wVector3f             	= (x:1.0; y:0.0; z:0.0);
  ambientColor: wColor4f        	= (alpha:1.0; red:0.0; green:0.0; blue:0.0);
  diffuseColor: wColor4f        	= (alpha:1.0; red:1.0; green:0.0; blue:0.5);
  wndCaption: PChar        		= 'Example 38: Dynamic Lighting ';
  prevFPS: Int32;



begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Create nodes}
  SphereNode := wNodeCreateSphere(30.0, 64, false,wColor4s_White);

  Light := wLightCreate(wVector3fCreate(-100,100,100), wCOLOR4f_WHITE, 600.0);
  ambientColor.alpha:=1.0;
  LightAmbient := wLightCreate(wVECTOR3f_ZERO,ambientColor, 600.0);
  Camera := wCameraCreate(wVector3fCreate(0,0,75),wVECTOR3f_ZERO);

  {Hide mouse cursor}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wCOLOR4s_BLACK);

     wLightSetAttenuation(Light, attenuation);
     attenuation.x+= 0.0025;

     {change the diffuse color emitted by the light over time}
     wLightSetDiffuseColor(Light, diffuseColor);
     if (diffuseColor.red > 0.0) then  diffuseColor.red-= 0.0001;
     if (diffuseColor.green < 1.0) then  diffuseColor.green+= 0.0001;
     if (diffuseColor.blue< 1.0) then  diffuseColor.blue+= 0.0001;

     {slowly introduce ambient light}
     wLightSetAmbientColor(LightAmbient, ambientColor);
     if (ambientColor.red < 0.1) then  ambientColor.red+= 0.000001;
     if (ambientColor.green < 0.1) then  ambientColor.green+= 0.000001;
     if (ambientColor.blue< 0.1) then  ambientColor.blue+= 0.000001;

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

