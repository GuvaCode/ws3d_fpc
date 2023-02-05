program p19_Node_SelectedByCamera;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

const TEST_NODES = 125;

var
  MeshTexture : wTexture;

  TestNode : array [0..TEST_NODES - 1] of wNode;
  SelectedNode,
  OurCamera : wNode;

  BitmapFont : wFont;

  material : wMaterial;

  position : wVector3f;

  backColor : wColor4s = (alpha : 255; red : 128; green : 128; blue : 128);

  fromPos,
  toPos : wVector2i;

  text : String;

  fontPath : PChar = 'Assets/Fonts/4.png';
  texPath  : PChar = 'Assets/Textures/Metal.jpg';

  wndCaption : PWChar = 'Example 19: Node Selected By Camera FPS: ';
  i : Integer;
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
  if (not CheckFilePath(fontPath) or
      not CheckFilePath(texPath)) then
    exit;


  ///Load resources
  BitmapFont := wFontLoad(fontPath);

  MeshTexture := wTextureLoad(texPath);

  for i := 0 to TEST_NODES - 1 do
    begin
      TestNode[i] := wNodeCreateCube(10,false , wCOLOR4s_WHITE);

      wNodeSetId(TestNode[i],i);

      position.x := (i/25)*40;
      position.y := ((i div 5) mod 5)*40;
      position.z := (i mod 5)*40;
      wNodeSetPosition(TestNode[i],position);

      material:=wNodeGetMaterial(TestNode[i],0);
      wMaterialSetTexture(material,0,MeshTexture);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
    end;

  position.x:=250;
  position.y:=10;
  position.z:=0;

  OurCamera := wFpsCameraCreate(100, 0.1, @wKeyMapDefault[0], Length(wKeyMapDefault));
  wNodeSetPosition(OurCamera,position);

  ///Hide mouse cursor
  //wInputSetCursorVisible(false);

  // -----------------------------------------------------------------------------
  // while the WorldSim3D environment is still running
  while wEngineRunning do
    begin
      // clear the canvas to black to show the particles up better
      wSceneBegin(backColor);

      // draw the scene
      wSceneDrawAll();
                 
      ///Find selected node
      SelectedNode := wCollisionGetNodeFromCamera(OurCamera);
      for i := 0 to TEST_NODES - 1 do
        wNodeSetDebugMode(TestNode[i], wDM_OFF);

      ///Set debug mode for selected node
      if (SelectedNode = nil) then
        text := 'NOTHING SELECTED'
      else
        begin
          wNodeSetDebugMode(SelectedNode, wDM_BBOX);
          text := 'NODE[' + IntToStr(wNodeGetId(SelectedNode)+1) + '] SELECTED';
        end;
                   
      ///Draw text info
      fromPos := to_wVector2i(10,  10);
      toPos   := to_wVector2i(400, 25);
      wFontDraw (BitmapFont, WStr(text), fromPos,toPos, wCOLOR4s_WHITE);

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


