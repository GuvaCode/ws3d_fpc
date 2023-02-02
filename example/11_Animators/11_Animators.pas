{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas(WorldSim3D developer)
'' Адаптировал Vuvk
'' ----------------------------------------------------------------------------
'' Пример 11 : Аниматоры
'' В примере показана работа Аниматоров, которые являются по-сути механизмами для
'' нодов на сцене, которые в течение определённого времени анимируют объект
'' определённым образом. В WorldSim3D всего существует 6 таких аниматоров,
'' 5 из которых показаны в этом примере.
'' ----------------------------------------------------------------------------
}
program p11_Animators;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  material : wMaterial;
  vec1,
  vec2 : wVector3f;

  Anim_object : array [0..5] of wAnimator;
                               
  wndCaption : PWChar = 'Example 11: Animators ';
  i : Integer;
  prevFPS : Int32=0;

  Asteroid_tex,
  SpaceShip_tex,
  ScoutShip_tex : wTexture;

  ScoutShip_mesh,
  SpaceShip_mesh,
  Asteroid_mesh,
  Earth_mesh,
  Moon_mesh : wMesh;

  Camera,          
  light,
  ScoutShip_node,
  SpaceShip_node,
  Asteroid_node,
  Earth_node,
  Moon_node : wNode;

  points : array [0..4] of wVector3f;

  BitmapFont : wFont;

  fromPos,
  toPos : wVector2i;

  startTime,
  curTime : UInt32;
  dTime : Single;
  isDeleted : Boolean = false;

  resPath : array [0..8] of PChar = ('Assets/Fonts/3.png',
                                     'Assets/Models/Scifi/scoutship/scoutship.x',
                                     'Assets/Models/Scifi/scoutship/scoutship2.jpg',
                                     'Assets/Models/Space/Earth/earth.x',
                                     'Assets/Models/Space/Moon/moon.x',
                                     'Assets/Models/Scifi/fighter/fighter1.3ds',
                                     'Assets/Models/Scifi/fighter/jodomatis.jpg',
                                     'Assets/Models/Space/asteroid/asteroid1.obj',
                                     'Assets/Models/Space/asteroid/Asteroid.jpg');

begin
  // -----------------------------------------------------------------------------
  // start the WorldSim3D interface
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
    begin
      PrintWithColor('wEngineStart() failed!', wCFC_RED, true);
      Halt;
    end;

  ///Show logo WS3D
  wEngineShowLogo(true);

  ///Check resources
  for i := 0 to High(resPath) do
    if (not CheckFilePath(resPath[i])) then
      Halt;

  ///Load resources
  BitmapFont := wFontLoad(resPath[0]);
  ScoutShip_mesh := wMeshLoad(resPath[1]);
  ScoutShip_tex := wTextureLoad(resPath[2]);
  Earth_mesh := wMeshLoad(resPath[3]);
  Moon_mesh := wMeshLoad(resPath[4]);
  SpaceShip_mesh := wMeshLoad(resPath[5]);
  SpaceShip_tex := wTextureLoad(resPath[6]);
  Asteroid_mesh := wMeshLoad(resPath[7]);
  Asteroid_tex := wTextureLoad(resPath[8]);

  ///Create nodes

  ///ScoutShip
  ScoutShip_node := wNodeCreateFromMesh( ScoutShip_mesh );

  vec1 := to_wVector3f(15,15,15);
  wNodeSetScale (ScoutShip_node,vec1);
  for i := 0 to wNodeGetMaterialsCount(ScoutShip_node) - 1 do
    begin
      material := wNodeGetMaterial(ScoutShip_node,i);
      wMaterialSetTexture(material,0,ScoutShip_tex);
      wMaterialSetFlag(material,wMF_LIGHTING,true);
    end;

  ///Earth
  Earth_node := wNodeCreateFromMesh( Earth_mesh );

  vec1 := to_wVector3f(10,10,10);
  wNodeSetScale (Earth_node,vec1);

  for i := 0 to wNodeGetMaterialsCount(Earth_node) - 1 do
    begin
      material := wNodeGetMaterial(Earth_node,i);
      wMaterialSetFlag(material,wMF_LIGHTING,true);
    end;

  ///Moon
  Moon_node := wNodeCreateFromMesh( Moon_mesh );

  vec1 := to_wVector3f(5,5,5);
  wNodeSetScale (Moon_node,vec1);

  for i := 0 to wNodeGetMaterialsCount(Moon_node) - 1 do
    begin
      material:=wNodeGetMaterial(Moon_node,i);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
    end;

  ///SpaceShip
  SpaceShip_node := wNodeCreateFromMesh( SpaceShip_mesh );

  vec1 := to_wVector3f(2,2,2);
  wNodeSetScale (SpaceShip_node,vec1);

  vec1 := to_wVector3f(-60.0, 90.0, 0.0);
  wNodeSetRotation (SpaceShip_node,vec1);

  for i:=0 to wNodeGetMaterialsCount(SpaceShip_node) - 1 do
    begin
      material:=wNodeGetMaterial(SpaceShip_node,i);
      wMaterialSetTexture(material,0,SpaceShip_tex);
      wMaterialSetFlag(material,wMF_LIGHTING,true);
    end;

  ///Asteroid
  Asteroid_node := wNodeCreateFromMesh( Asteroid_mesh );

  vec1 := to_wVector3f(0.1,0.1,0.1);
  wNodeSetScale (Asteroid_node,vec1);

  vec1 := to_wVector3f(-60.0, 90.0, 0.0);
  wNodeSetRotation (Asteroid_node,vec1);

  vec1 := to_wVector3f(-30.0, 0.0, -25.0);
  wNodeSetPosition ( Asteroid_node,vec1);

  for i := 0 to wNodeGetMaterialsCount(Asteroid_node) - 1 do
    begin
      material := wNodeGetMaterial(Asteroid_node,i);
      wMaterialSetTexture(material,0,Asteroid_tex);
      wMaterialSetFlag(material,wMF_LIGHTING,true);
    end;

  ///Create animators
  vec1 := to_wVector3f(0.0,0.1,0.0);
  Anim_object[0] := wAnimatorRotationCreate(Earth_node,vec1);
  Anim_object[1] := wAnimatorFlyingCircleCreate(Moon_node,wVECTOR3f_ZERO,25.0,0.001,
                                              to_wVector3f(0.0,1.0,0.0),0.0,0.0);

  vec1 := to_wVector3f(0,50,-120);
  vec2 := to_wVector3f(0,50,120);
  Anim_object[2] := wAnimatorFlyingStraightCreate(SpaceShip_node,vec1,vec2,15000,true);

  vec1 := to_wVector3f(0.1,0.2,0.1);
  Anim_object[3] := wAnimatorRotationCreate(Asteroid_node,vec1);
  Anim_object[4] := wAnimatorDeletingCreate(Asteroid_node,10000);

  points[0] := to_wVector3f(-40,5,0);
  points[1] := to_wVector3f(0,30,-30);
  points[2] := to_wVector3f(10,10,0);
  points[3] := to_wVector3f(-15,30,30);
  points[4] := to_wVector3f(15,10,30);
  Anim_object[5] := wAnimatorSplineCreate(ScoutShip_node,4,@points[0],0,0.5,1);

  ///Create light
  wSceneSetAmbientLight(to_wColor4f(1.0,0.1,0.1,0.1));

  vec1 := to_wVector3f(0,100,100);
  light := wLightCreate(vec1, to_wColor4f(1.0,0.9,0.9,0.9), 1750.0);

  ///Create camera
  vec1 := to_wVector3f(-67,20,0);
  vec2 := to_wVector3f(0,20,0);
  Camera := wCameraCreate(vec1,vec2);

  ///Hide mouse cursor
  wInputSetCursorVisible(false);

  // -----------------------------------------------------------------------------
  // while the WorldSim3D environment is still running
  while wEngineRunning do
    begin
      // clear the canvas to black to show the particles up better
      wSceneBegin(wCOLOR4s_BLACK);

      curTime := 0;
      if (not isDeleted) then
        begin
          curTime := wTimerGetTime();
          dTime := (curTime-startTime)/1000.0;
          curTime := round(11 - dTime);
          if (curTime <= 0) then
            isDeleted := true;
        end;

      // draw the scene
      wSceneDrawAll();

      ///Draw text info
      fromPos := to_wVector2i(220,20); toPos := to_wVector2i(400,36);
      wFontDraw(BitmapFont, 'The WorldSim3D animators in action:', fromPos,toPos, wCOLOR4s_WHITE);
      fromPos := to_wVector2i(25,40); toPos := to_wVector2i(300,56);
      wFontDraw(BitmapFont, '1. Rotation Animator (Earth)', fromPos,toPos, wCOLOR4s_WHITE);
      fromPos.y += 20; toPos.y += 20;
      wFontDraw(BitmapFont, '2. Circle Animator (Moon)', fromPos,toPos, wCOLOR4s_WHITE);
      fromPos.y += 20; toPos.y += 20;
      wFontDraw(BitmapFont, '3. Straight Animator (Space Ship)', fromPos,toPos, wCOLOR4s_WHITE);
      fromPos.y += 20; toPos.y += 20;
      wFontDraw(BitmapFont, '4. Spline Animator (Green Space Probe)', fromPos,toPos, wCOLOR4s_WHITE);
      fromPos.y += 20; toPos.y += 20;
      wFontDraw(BitmapFont, '5. Delete Animator (Asteroid) will be deleted in 10 sec.', fromPos,toPos, wCOLOR4s_WHITE);
      fromPos.y += 20; toPos.y += 20;
      wFontDraw(BitmapFont, '6. Spline Animator (Scout Ship)', fromPos,toPos, wCOLOR4s_WHITE);

      if (not isDeleted) then
        begin
          fromPos := to_wVector2i(660,550); toPos := to_wVector2i(800,600);
          if(curTime >= 4) then
            wFontDraw(BitmapFont, 'Time lost:' + WStr(FormatFloat('0', curTime)), fromPos,toPos, wCOLOR4s_WHITE)
          else                                  
            wFontDraw(BitmapFont, 'Time lost:' + WStr(FormatFloat('0', curTime)), fromPos,toPos, to_wColor4s(255, 255, 0, 0));
        end;

      // end drawing the scene and display it
      wSceneEnd();
             
      ///Close by ESC
      wEngineCloseByEsc();

      {Update fps}
      if prevFPS<>wEngineGetFPS() then
         begin
           prevFPS:=wEngineGetFPS();
           wWindowSetCaption(wndCaption+WStr(FormatFloat('0',prevFPS)));
         end;
    end;

  // -----------------------------------------------------------------------------
  // Stop the WorldSim3D engine and release resources
  wEngineStop(true);
end.


