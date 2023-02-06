{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Vuvk
'' ----------------------------------------------------------------------------
'' Пример 41: смешивание анимаций
'' Пример загружает модель с костной анимацией и переключается между 2 кадрами
'' анимации, смешивая при этом переход, так что вместо резкой смены положения
'' анимации она происходит гладко в течение установленного времени.
'' ----------------------------------------------------------------------------
}
program p41_Animation_Blending;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  Mesh : wMesh;

  TransitionNode,
  NormalNode,
  OurCamera : wNode;

  material : wMaterial;

  frame : Int32;

  fromPos : wVector2i = (x : 20;  y : 500);
  toPos   : wVector2i = (x : 200; y : 550);

  backColor : wColor4s = (alpha : 255; red : 240; green : 255; blue : 255);

  meshPath : PChar = 'Assets/Models/Cartoon_guy.x';

  wndCaption : PWChar = 'Example 41: Blending animation ';
  i : Integer;
  prevFPS : Int32=0;

begin
  // -----------------------------------------------------------------------------
  // start the WorldSim3D interface
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,false,true,false) then
    begin
      PrintWithColor('wEngineStart() failed!', wCFC_RED, true);
      Halt;
    end;

  ///Show logo WS3D
  wEngineShowLogo(true);
                
  ///Check resources
  if (not CheckFilePath(meshPath)) then
    exit;

  ///Load resources
  Mesh := wMeshLoad(meshPath);

  ///Create test nodes
  NormalNode := wNodeCreateFromMesh(Mesh);
  TransitionNode := wNodeCreateFromMesh(Mesh);            
  wNodeSetPosition(NormalNode, to_wVector3f(30,0,0));
  wNodeSetPosition(TransitionNode, to_wVector3f(-30,0,0));

  ///Configure nodes materials
  for i := 0 to wNodeGetMaterialsCount(NormalNode) - 1 do
    begin
      material := wNodeGetMaterial(NormalNode,i);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
      material := wNodeGetMaterial(TransitionNode,i);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
    end;

  ///Set the animation range and speed on the two nodes
  wNodeSetAnimationRange(TransitionNode, to_wVector2i(0,1600));
  wNodeSetAnimationSpeed(TransitionNode,250);
  wNodeSetAnimationRange(NormalNode, to_wVector2i(0,1600));
  wNodeSetAnimationSpeed(NormalNode,250);

  wNodeSetTransitionTime(TransitionNode,0.5);

  ///Create camera
  OurCamera := wCameraCreate(to_wVector3f(0,35,-75), to_wVector3f(0, 35, 0));

  ///Hide mouse cursor
  wInputSetCursorVisible(false);

  // -----------------------------------------------------------------------------
  // while the WorldSim3D environment is still running
  while wEngineRunning do
    begin
      // clear the canvas to black to show the particles up better
      wSceneBegin(backColor);

      ///When the animation reaches the 1000th frame
      frame := round(wNodeGetAnimationFrame(TransitionNode));
      if (frame = 1000) then
        begin
          ///set the current frame number being played in the animation
          wNodeSetAnimationFrame( TransitionNode, 0);
          wNodeSetAnimationFrame( NormalNode, 0) ;
        end;

      ///Animates the mesh based on the position of the joints, this should be used at
      ///the end of any manual joint operations including blending and joints animated
      ///using wJM_CONTROL and wNodeSetRotation on a bone node
      wNodeAnimateJoints( TransitionNode );

      // draw the scene
      wSceneDrawAll();

      wFontDraw(wFontGetDefault(),
                WStr('Transition Frame: ' + IntToStr(frame)),
                fromPos, toPos,
                wCOLOR4s_BLACK);

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


