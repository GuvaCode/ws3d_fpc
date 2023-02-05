{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Vuvk
'' ----------------------------------------------------------------------------
'' Пример 20: Определение точки столкновения
'' Пример определяет точку столкновения между Группой Столкновения (selector group)
'' и лучом, который мы выпускаем по сцене через центр камеры.
'' ----------------------------------------------------------------------------
}
program p20_Node_RayHittingSurface;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  MD2Mesh : wMesh;

  MeshTexture : wTexture;

  collisionNode,
  OurCamera : wNode;
  SceneNode : array [0..1] of wNode;

  Collision : array [0..1] of wSelector;
  CollisionGroup : wSelector;

  StartVector,
  EndVector,
  CollideAt,
  Normal : wVector3f;
  CollTriangle : wTriangle;

  backColor : wColor4s = (alpha : 255; red : 70; green : 75; blue : 75);

  fromPos,
  toPos,
  Coll2d : wVector2i;

  material : wMaterial;
  text : WString;

  meshPath : PChar = 'Assets/Models/Characters/Lizard/Lizard.md2';
  meshTexPath : PChar = 'Assets/Models/Characters/Lizard/Lizard.jpg';

  wndCaption : PWChar = 'Example 20: Getting the point of collision FPS: ';
  i, k : Integer;
  prevFPS : Int32=0;

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
  if (not CheckFilePath(meshPath) or
      not CheckFilePath(meshTexPath)) then
    exit;

  ///Load resources
  MD2Mesh := wMeshLoad(meshPath);
  MeshTexture := wTextureLoad(meshTexPath);

  for k := 0 to 1 do
    begin
      SceneNode[k] := wNodeCreateFromMesh( MD2Mesh );
      for i := 0 to wNodeGetMaterialsCount(SceneNode[k]) - 1 do
        begin
          material := wNodeGetMaterial(SceneNode[k],i);
          wMaterialSetFlag(material,wMF_LIGHTING,false);
          wMaterialSetTexture(material,0,MeshTexture);
        end;
    end;

  wNodeSetPosition(SceneNode[1], to_wVector3f(0, 0, 50));

  wNodeSetName(SceneNode[0], 'MONSTER #1');
  wNodeSetName(SceneNode[1], 'MONSTER #2');

  wNodeSetAnimationRange( SceneNode[0], wVECTOR2i_ZERO);
  wNodeSetAnimationRange( SceneNode[1], wVECTOR2i_ZERO);

  OurCamera := wFpsCameraCreate(100, 0.1, @wKeyMapDefault[0], Length(wKeyMapDefault));
  wNodeSetPosition(OurCamera, to_wVector3f(100,0,0));
  wCameraSetTarget(OurCamera,wVECTOR3f_ZERO);

  CollisionGroup := wCollisionGroupCreate();
  Collision[0] := wCollisionCreateFromMesh(MD2Mesh,SceneNode[0],0);
  Collision[1] := wCollisionCreateFromMesh(MD2Mesh,SceneNode[1],0);
  wCollisionGroupAddCollision(CollisionGroup,Collision[0]);
  wCollisionGroupAddCollision(CollisionGroup,Collision[1]);

  ///Hide mouse cursor
  wInputSetCursorVisible(false);

  // -----------------------------------------------------------------------------
  // while the WorldSim3D environment is still running
  while wEngineRunning do
    begin
      // clear the canvas to black to show the particles up better
      wSceneBegin(backColor);

      // draw the scene
      wSceneDrawAll();

      StartVector := wNodeGetPosition(OurCamera);

      EndVector := wCameraGetTarget(OurCamera);
      EndVector.x += ((EndVector.x - StartVector.x) * 5000);
      EndVector.y += ((EndVector.y - StartVector.y) * 5000);
      EndVector.z += ((EndVector.z - StartVector.z) * 5000);

      if (wCollisionGetPointFromRay(CollisionGroup, @StartVector, @EndVector, @CollideAt, @Normal, @CollTriangle, @collisionNode)) then
        begin
          w3dDrawTriangle(CollTriangle,wCOLOR4s_DARKRED);

          StartVector.y -= 3;
          w3dDrawLine(StartVector,CollideAt,wCOLOR4s_RED);

          Coll2d := wCollisionGetScreenCoordFrom3dPosition(CollideAt);
          w2dDrawPolygon(Coll2d,3,wCOLOR4s_GREEN,6);
          fromPos.x := Coll2d.x+100;
          fromPos.y := Coll2d.y;
          toPos.x := Coll2d.x+350;
          toPos.y := Coll2d.y+30;

          text := 'C O L L I S I O N  P O I N T : (' + WStr(FormatFloat('0.0', CollideAt.x)) + ', ' +
                                                       WStr(FormatFloat('0.0', CollideAt.y)) + ', ' +
                                                       WStr(FormatFloat('0.0', CollideAt.z)) + ')';
          wFontDraw(wFontGetDefault(),text,fromPos,toPos,wCOLOR4s_WHITE);
                                                       
          text := 'N O R M A L  V E C T O R : (' + WStr(FormatFloat('0.0', Normal.x)) + ', ' +
                                                   WStr(FormatFloat('0.0', Normal.y)) + ', ' +
                                                   WStr(FormatFloat('0.0', Normal.z)) + ')';
          fromPos.y += 30;
          toPos.y   += 30;
          wFontDraw(wFontGetDefault(),text,fromPos,toPos,wCOLOR4s_WHITE);

          ///Fix bug
          collisionNode := wCollisionGetNodeFromRay(@StartVector, @EndVector);
          ///

          if (collisionNode <> nil) then
            begin
              text := 'S E L E C T E D  N O D E: ' + WStr(wNodeGetName(collisionNode));
              fromPos.y += 30;
              toPos.y   += 30;
              wFontDraw(wFontGetDefault(),text,fromPos,toPos,wCOLOR4s_WHITE);
            end;
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


