{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 52: Блики от солнца (Lens Flare)
'' Изображение оптического эффекта камеры, называемого блики от солнца
'' Блики могут быть и от других источников света.
'' ----------------------------------------------------------------------------}
program p52_LensFlare;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

var
  Camera: wNode;
  FlareTexture, FlareNode: wTexture;
  vec1: wVector3f;
  prevFps: Int32;
  wndCaption: wString = 'Example 52: Lens Flare - Camera Optics caught in the light ';
  flarePath: PChar = 'Assets/Sprites/flare2.png';

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(flarePath);

  {Load resources}
  FlareTexture := wTextureLoad(flarePath);

  {Create lens flare scene node}
  FlareNode := wLensFlareCreate(FlareTexture);

  wNodeSetPosition(FlareNode, wVector3fCreate(300,100,2000));

  {Create camera}
  Camera := wFpsCameraCreate(100, 0.1, @wKeyMapDefault, 8, FALSE, 0);
  wCameraSetClipDistance(Camera,10000.0,1);

  {Hide mouse}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,150,150,255));

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

