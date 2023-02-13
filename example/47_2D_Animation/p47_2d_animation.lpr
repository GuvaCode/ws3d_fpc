{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 47: Анимация с помощью 2D изображений
'' Пример поочерёдно отрисовывает на экрвне несколько 2D изображений, генерируя
'' таким образом анимацию
'' ----------------------------------------------------------------------------}
program p47_2D_Animation;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

const LAST_FRAME = 8;

var
  AnimationStrip, AnimationStrip_2: wTexture;
  vect1, vect2 ,vect3: wVector2i;
  prevFps, frame, framesync: Int32;
  wndCaption: wString = 'Example 47: 2D Animation';
  texPath1: PChar = 'Assets/Sprites/Flares.png';
  texPath2: PChar = 'Assets/Sprites/Effect_1.png';

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(texPath1);
  CheckFilePath(texPath2);

   {Load resources}
   AnimationStrip := wTextureLoad(texPath1);
   AnimationStrip_2 := wTextureLoad(texPath2);

   {Make a note of the time}
   framesync := wTimerGetTime();

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,15,15,10));

  vect1.x:=50; vect1.y:=50;
  vect2.x:=frame*178; vect2.y:=0;
  vect3.x:=(frame+1)*178-1; vect3.y:=177;
  wTextureDrawElement(AnimationStrip, vect1, vect2, vect3, true, wColor4s_White);

  vect1.x:=450; vect1.y:=50;
  vect2.x:=frame*128; vect2.y:=0;
  vect3.x:=(frame+1)*128-1; vect3.y:=512;
  wTextureDrawElement(AnimationStrip_2, vect1, vect2, vect3,true, wColor4s_White);

  {Check to see if 0.1 seconds have advanced since we recorded the time}
  if(wTimerGetTime() - framesync > 100) Then
  begin
  {record the new time}
  framesync := wTimerGetTime();
  {advance to the next frame}
  frame +=1;
  {If we have passed the last frame rewind to the begining}
  if (frame >= LAST_FRAME) Then frame := 0;
  end;
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

