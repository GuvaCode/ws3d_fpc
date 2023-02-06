// Пример 31: Загружаем WorldSim3D Сцену
// Пример загружает сцену, созданную в Редакторе IrrEdit, что позволяет загружать
// в проект огромное число мешей, текстур и нодов всего одной командой. Сохраняется
// сцена в редакторе и загружается в проект с расширением .irr
// ----------------------------------------------------------------------------

program p31_Scene_Loading;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  Camera: wNode;
  prevFPS: Int32;
  vec1: wVector3f       = (x:  0.0; y:  0.0; z:  0.0);
  wndCaption: wString 	= 'Example 31: Loading a scene FPS: ';
  scenePath: PChar      = 'Assets/Scenes/Myscene.irr';

begin
  prevFPS:=0;
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(scenePath);

  {Load resources}
  wSceneLoad(scenePath);

  {Show engine logo}
  wEngineShowLogo(true);

  {Create camera}
  Camera:=wFpsCameraCreate(100,0.1,@wKeyMapDefault,8,false,0);
  vec1.x:=30; vec1.y:=10; vec1.z:=-35;
  wNodeSetPosition(Camera,vec1);

  vec1.x:=0; vec1.y:=-90; vec1.z:=0;
  wNodeSetRotation(Camera,vec1);

  ///Hide mouse cursor
  wInputSetCursorVisible(false);


  {Main loop}
  while wEngineRunning() do

  begin
    wSceneBegin(wCOLOR4s_WHITE);

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

