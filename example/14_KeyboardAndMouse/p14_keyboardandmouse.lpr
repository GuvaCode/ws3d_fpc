program p14_KeyboardAndMouse;
// ----------------------------------------------------------------------------
// Пример 14: Клавиатура и мышь
// В примере показано, как "отлавливать" события от мыши и клавиатуры. Клавиши
// W,A,S,D в данном примере используются для движения камеры вперёд-назад и
// влево-вправо, а мышь для вращения камеры.
// ----------------------------------------------------------------------------
{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  BSPMesh: wMesh                 = nil;
  BSPNode: wNode              	 = nil;
  CameraNode: wNode           	 = nil;
  Camera: wNode               	 = nil;
  BitmapFont: wFont           	 = nil;
  MapCollision: wSelector     	 = nil;
  Collision_anim: wAnimator      = nil;
  KeyEvent: PwKeyEvent      	 = nil;
  MouseEvent: PwMouseEvent 	 = nil;

  cameraPosition: wVector3f	 = (x:  0.0; y:  0.0; z:  0.0);
  cameraTarget: wVector3f        = (x:  0.0; y:  0.0; z:  0.0);
  cameraStrafe: wVector3f	 = (x:  0.0; y:  0.0; z:  0.0);
  cameraSpeed: Float32           = 100;
  mousePosition: wVector2f	 = (x: 0; y:0);
  upDir: wVector3f		 = (x:  0.0; y:  0.0; z:  0.0);
  forwardDir: wVector3f		 = (x:  0.0; y:  0.0; z:  0.0);
  rightDir: wVector3f		 = (x:  0.0; y:  0.0; z:  0.0);
  SPIN: Float32			 = 0;
  TILT: Float32			 = 0;
  fromPos: wVector2i		 = (x:0; y:0);
  toPos: wVector2i		 = (x:0; y:0);
  wndCaption:PChar 		 = 'Example 14: Keyboard and Mouse';
  prevFPS: Int32  		 = 0;
  fontPath: PChar                = 'Assets/Fonts/3.png';
  bspPath: PChar                 = 'Assets/BSPmaps/Lycanthrope.pk3';
  params: wAnimatorCollisionResponse;

begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(fontPath);
  CheckFilePath(bspPath);

  {Show engine logo}
  wEngineShowLogo(true);

  {Load resources}
  BitmapFont:= wFontLoad(fontPath);
  wFileAddZipArchive(bspPath,true,true);
  BSPMesh:= wMeshLoad('Lycanthrope.bsp');

  {Create nodes}
  BSPNode := wNodeCreateFromMeshAsOctree( BSPMesh );

  {Camera}
  Camera := wCameraCreate(wVector3f_ZERO,wVector3f_ZERO);
  wNodeSetPosition( Camera,wVector3f_UP);

  cameraPosition.x:=4; cameraPosition.y:=260; cameraPosition.z:=0;
  wNodeSetRotation( Camera, cameraPosition );
  wCameraSetClipDistance ( Camera, 6000,1);

  {Collision}
  MapCollision := wCollisionCreateFromOctreeMesh(BSPMesh,BSPNode);

  {Collision animator}
  Collision_anim:= wAnimatorCollisionResponseCreate(MapCollision,Camera);
  wAnimatorCollisionResponseGetParameters(Collision_anim,@params);
  params.ellipsoidRadius.x:=40; params.ellipsoidRadius.y:=40; params.ellipsoidRadius.z:=40;
  params.gravity.y:=-80;
  params.ellipsoidTranslation.y:=50;

  wAnimatorCollisionResponseSetParameters(Collision_anim,params);

  { Hide mouse }
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wCOLOR4s_WHITE);

    wSceneDrawAll();

    {Set mouse position and get cameras position}
    mousePosition.x:=0.5; mousePosition.y:=0.5;

    wInputSetMouseLogicalPosition(@mousePosition);

    cameraPosition := wNodeGetPosition(Camera);

    ///Read keyboard events
    if wInputIsKeyPressed(wKC_KEY_A) then cameraStrafe.x:=-5
    else  if cameraStrafe.x=-5 then cameraStrafe.x:=0;

    if wInputIsKeyPressed(wKC_KEY_D) then cameraStrafe.x:=5
    else if cameraStrafe.x=5  then cameraStrafe.x:=0;

    if wInputIsKeyPressed(wKC_KEY_W) then cameraStrafe.z:=5
    else  if cameraStrafe.z = 5 then cameraStrafe.z:=0;

    if wInputIsKeyPressed(wKC_KEY_S) then cameraStrafe.z:=-5
    else if cameraStrafe.z =-5 then cameraStrafe.z:=0;

    { Update camera position and orientation }
    wCameraGetOrientation(Camera,@upDir,@forwardDir,@rightDir);

    cameraPosition.x+=(forwardDir.x*cameraStrafe.z + forwardDir.z*cameraStrafe.x)*cameraSpeed*wTimerGetDelta();
    cameraPosition.z-=(forwardDir.x*cameraStrafe.x - forwardDir.z*cameraStrafe.z)*cameraSpeed*wTimerGetDelta();

    wNodeSetPosition(Camera,cameraPosition);
    wNodeTurn(Camera,wVector3f_ZERO);

    SPIN+=(mousePosition.x-0.5)*2.0;
    TILT+=(mousePosition.y-0.5)*2.0;

    if TILT >1.5 then TILT:= 1.5;
    if TILT<-1.5 then TILT:=-1.5;

    cameraTarget.x:=cameraPosition.x+sin(SPIN)*1000;
    cameraTarget.y:=-TILT*1500;
    cameraTarget.z:=cameraPosition.z+cos(SPIN)*1000;

    wCameraSetTarget(Camera,cameraTarget);

    { Draw text info }
    fromPos.x:=20; fromPos.y:=20; toPos.x:=300; toPos.y:=50;
    wFontDraw(BitmapFont,'Camera position :'+ FormatFloat('0.0',cameraPosition.x)+' '+
    FormatFloat('0.0',cameraPosition.y)+' '+FormatFloat('0.0',cameraPosition.z),
    fromPos,toPos,wCOLOR4s_WHITE);

    fromPos.y+=30; toPos.y+=30;
    wFontDraw(BitmapFont,'Camera target : '+ FormatFloat('0.0',cameraTarget.x)+' '+
    FormatFloat('0.0',cameraTarget.y)+' '+FormatFloat('0.0',cameraTarget.z),
    fromPos,toPos,wCOLOR4s_WHITE);

    fromPos.y+=30; toPos.y+=30;
    wFontDraw(BitmapFont,'X and Z strafe: '+ FormatFloat('0.0',cameraStrafe.x)+' '+
    FormatFloat('0.0',cameraStrafe.z), fromPos,toPos,wCOLOR4s_WHITE);

    fromPos.x:=200; fromPos.y:=570;  toPos.x:=450;  toPos.y:=590;
    wFontDraw(BitmapFont,'Press W,A,S,D to move around the map',fromPos,toPos,wCOLOR4s_WHITE);


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


