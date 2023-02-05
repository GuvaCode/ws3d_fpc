// ----------------------------------------------------------------------------
// Пример сделал Vuvk
// Адаптировал Nikolas (WorldSim3D developer)
// ----------------------------------------------------------------------------
// Пример 01: Hello World
// Этот простой пример открывает окно WorldSim3D, показывает текст Hello World
// на экране и ожидает когда пользователь закроет приложение.
// ----------------------------------------------------------------------------

program p29_Skydome;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  SkyDome, Camera: wNode;
  SkyTexture: wTexture;
  prevFPS: Int32;
  backColor: wColor4s;
  wndCaption: wString 	= 'Example 29: Skydome FPS: ';
  texPath: PChar        = 'Assets/Textures/earthcloudmap.jpg';

begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(texPath);

  {Load resources}
  SkyTexture:=wTextureLoad(texPath);

  {Show engine logo}
  wEngineShowLogo(true);

  {Create sky}
  SkyDome:=wSkyDomeCreate(SkyTexture,16,16,1.0,2.0,1000.0);

  {Create camera}
  Camera:=wFpsCameraCreate(100,0.1,@wKeyMapDefault,8,false,0);

  {Hide mouse cursor}
  wInputSetCursorVisible(false);

  backColor:=wColor4sCreate(255,240, 255, 255);

  {Main loop}
  while wEngineRunning() do

  begin
    wSceneBegin(backColor);

    wSceneDrawAll();

    wSceneEnd();

    {Close by ESC}
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

