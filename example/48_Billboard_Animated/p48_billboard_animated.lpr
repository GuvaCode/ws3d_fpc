{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas(WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 48: Анимированные билборды
'' Пример демонстрирует  анимированные билборды. Текстура на билборде меняется
'' с каждым кадром, генерируя таким образом анимацию.
'' ----------------------------------------------------------------------------}
program p48_Billboard_Animated;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

const
  LAST_FRAME = 5;

var
  Billboard, Camera: wNode;
  BillboardTexture: array [0..LAST_FRAME] of wTexture ;
  texPath: array [0..LAST_FRAME] of PChar;
  material: wMaterial;
  vec1: wVector3f;
  prevFps, frame, framesync: Int32;
  wndCaption: wString = 'Example 48: Animated Billboards';
  i: integer;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);
  texPath[0] := 'Assets/Sprites/matrix/1.png';
  texPath[1] := 'Assets/Sprites/matrix/2.png';
  texPath[2] := 'Assets/Sprites/matrix/3.png';
  texPath[3] := 'Assets/Sprites/matrix/4.png';
  texPath[4] := 'Assets/Sprites/matrix/5.png';
  texPath[5] := 'Assets/Sprites/matrix/6.png';

  {Check resources}
  For i := 0 To LAST_FRAME - 1 do
  CheckFilePath(texPath[i]);

  {Load resources}
  For i := 0 To LAST_FRAME - 1 do
  BillboardTexture[i] := wTextureLoad(texPath[i]);

  {Create billboard}
  Billboard := wBillBoardCreate(wVECTOR3f_ZERO,wVector2fCreate(10.0,10.0));
  material := wNodeGetMaterial(Billboard,0);
  wMaterialSetTexture(material,0,BillboardTexture[0]);
  wMaterialSetFlag(material,wMF_LIGHTING,false);
  wMaterialSetType(material,wMT_TRANSPARENT_ALPHA_CHANNEL);

  {Add a first person perspective camera into the scene so we can move around
  the billboard and see how it reacts}
  Camera := wFpsCameraCreate(100, 0.1, @wKeyMapDefault, 8, FALSE, 0);

  vec1.x:=0; vec1.y:=0; vec1.z:=-15;
  wNodeSetPosition(Camera,vec1);

  {Hide mouse}
  wInputSetCursorVisible(false);

  {Make a note of the time}
  framesync:=wTimerGetTime();

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,15,15,10));


    {Check to see if 0.1 seconds have advanced since we recorded the time}
    if(wTimerGetTime() - framesync > 200) Then
    begin
      {record the new time}
      framesync := wTimerGetTime();
      {advance to the next frame}
      frame +=1;
      {If we have passed the last frame rewind to the begining}
      if (frame >= LAST_FRAME) Then frame := 0;
      wMaterialSetTexture(material,0,BillboardTexture[frame])
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

