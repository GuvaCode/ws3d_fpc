// ----------------------------------------------------------------------------
// Пример сделал Vuvk
// Адаптировал Nikolas (WorldSim3D developer)
// ----------------------------------------------------------------------------
// Пример 01: Hello World
// Этот простой пример открывает окно WorldSim3D, показывает текст Hello World
// на экране и ожидает когда пользователь закроет приложение.
// ----------------------------------------------------------------------------

program p01_HelloWorld;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  MyFont : wFont=0;
  sceneColor:wColor4s=(alpha:255;red:0;green:125;blue:0);
  fromPos:wVector2i=(x:120; y:80);
  toPos:wVector2i=(x:250; y:96);

  wndCaption:PWChar='Example 1: Hello World fps: ';
  prevFPS:Int32=0;

  fontPath:PChar='Assets/Fonts/Cyr.xml';

begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(fontPath);

  {Load resources}
  MyFont:=wFontLoad(fontPath);

  {Show engine logo}
  wEngineShowLogo(true);

  {Main loop}
  while wEngineRunning() do

  begin

    wSceneBegin(sceneColor);

    {Draw text}
    fromPos.y:=80; toPos.y:=96;
    wFontDraw(MyFont,'Hello, World!',fromPos,toPos,wCOLOR4s_WHITE);

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

