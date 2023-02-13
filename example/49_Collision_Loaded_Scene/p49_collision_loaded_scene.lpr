{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 49: Проверка столкновения в загруженной из файла сцене WorldSim3D (.irr)
'' Пример показывает столкновение на сцене, созданной с помощью редактора IrrEdit.
'' Создание нодов и выбор объектов для столкновения друг с другом происходит таким
'' же образом, как на сцене, созданной программно, непосредственно в проекте.
'' ----------------------------------------------------------------------------'*/}
program p49_Collision_Loaded_Scene;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

var
  Camera, CameraNode, NodeGround, NodeBox: wNode;
  SelectorGround, SelectorBox, CombinedCollision: wSelector;
  CollisionAnimator: wAnimator;
  prevFps: Int32;
  wndCaption: wString = 'Example 49: Collision in a Loaded Scene';
  scenePath: PChar = ('Assets/Scenes/CollisionScene.irr');
  param: wAnimatorCollisionResponse;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(scenePath);

   {Load scene}
   wSceneLoad(scenePath);

   {Create camera}
   Camera := wFpsCameraCreate(100, 0.1, @wKeyMapDefault, 8, FALSE, 0);
   wFpsCameraSetSpeed(Camera,2*wFpsCameraGetSpeed(Camera));

   wNodeSetPosition(Camera,wVector3fCreate(200,120,0));

   wNodeSetRotation(Camera,wVector3fCreate(0,-90,0));

   {First we need to get references to the objects in the scene that the viewer
   can collide with}
   NodeGround := wSceneGetNodeByName('Ground');
   NodeBox := wSceneGetNodeByName('Pillar');

   {Next we need to create collision objects from the nodes}
   if NodeGround <> nil Then SelectorGround := wCollisionCreateFromBox(NodeGround);
   if NodeBox <> nil Then SelectorBox := wCollisionCreateFromBox(NodeBox);

   {Now that we have collision objects for each of the nodes we need to combine
   them into a collision group}
   CombinedCollision := wCollisionGroupCreate();

   {Creates a meta-selector that is a group of selector objects}
      if CombinedCollision <> nil Then
      begin
        if SelectorGround <> nil Then wCollisionGroupAddCollision(CombinedCollision,SelectorGround);
        if SelectorBox <> nil Then wCollisionGroupAddCollision(CombinedCollision,SelectorBox);

        CollisionAnimator := wAnimatorCollisionResponseCreate(CombinedCollision,Camera,0.0005);
        if CollisionAnimator <> nil Then
        begin
          wAnimatorCollisionResponseGetParameters(CollisionAnimator,@param);
          param.ellipsoidRadius.x:=30.0;
          param.ellipsoidRadius.y:=15.0;
          param.ellipsoidRadius.z:=30.0;
          param.ellipsoidTranslation.x:=0.0;
          param.ellipsoidTranslation.y:=50.0;
          param.ellipsoidTranslation.z:=0.0;
          param.gravity.x:=0.0;
          param.gravity.y:=-30.0;
          param.gravity.z:=0.0;
          wAnimatorCollisionResponseSetParameters(CollisionAnimator,param);
        end;
      end;

   {Hide mouse}
   wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,200,200,255));

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

