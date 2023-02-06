// ----------------------------------------------------------------------------
// Пример 32 : 3D рисование
// Пример рисует красную 3d линию на сцене
// ----------------------------------------------------------------------------

program p32_Drawing_3D;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  Camera: wNode;

  vec1: wVector3f                        	= (x:  0.0; y:  0.0; z:  0.0);
  vec2: wVector3f                               = (x:  0.0; y:  0.0; z:  0.0);
  vec3: wVector3f                   	        = (x:  0.0; y:  0.0; z:  0.0);

  triangle: wTriangle ;
  triangle2: wTriangle;

  wndCaption: wString				= 'Example 32: 3D Drawing FPS: ';

  prevFPS: Int32;


begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Create camera}
  Camera:=wFpsCameraCreate(100,0.1,@wKeyMapDefault,8,false,0);
  vec1.x:=0; vec1.y:=10; vec1.z:=-10;
  wNodeSetPosition(Camera,vec1);

  vec3.x:=-80; vec3.y:=80; vec3.z:=-80;

  {Hide mouse cursor}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,240,255,255));

    vec1.x:=100; vec1.y:=0; vec1.z:=100;
    vec2.x:=-100; vec2.y:=0; vec2.z:=-100;

    w3dDrawLine(vec1,vec2,wCOLOR4s_RED);

    vec2.x:=-100; vec2.y:=-30; vec2.z:=-100;
    w3dDrawBox(vec1,vec2,wCOLOR4s_GREEN);

    vec1.x:=80; vec1.y:=20; vec1.z:=80;
    vec2.x:=-80; vec2.y:=20; vec2.z:=-80;
    triangle.pointA:=vec1;
    triangle.pointB:=vec2;
    triangle.pointC:=vec3;

    triangle2.pointA:=vec3;
    triangle2.pointB:=vec2;
    triangle2.pointC:=vec1;

    w3dDrawTriangle(triangle,wCOLOR4s_BLUE);
    w3dDrawTriangle(triangle2,wCOLOR4s_BLUE);

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

