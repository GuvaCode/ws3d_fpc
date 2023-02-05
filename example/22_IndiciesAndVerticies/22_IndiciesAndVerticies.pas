{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Vuvk
'' ----------------------------------------------------------------------------
'' Пример 22: Индексы и вершины
'' Пример загружает простой меш, статический объект directx. Затем получает список
'' индексов и вершин данного объекта и манипулирует ими, прежде чем снова отправить
'' (записать) их в меш. Используется для получения данных меша, чтобы дальше использовать
'' эти данные с какими-нибудь другими библиотеками или чтобы напрямую манипулировать
'' объектом.
'' ----------------------------------------------------------------------------
}
program p22_IndiciesAndVerticies;

{Attach modules}
uses
  SysUtils, WorldSim3D, SampleFunctions;

var
  DirectXMesh : wMesh;
  vertices : array of wVert;

  SceneNode,
  OurCamera : wNode;

  material : wMaterial;
  BitmapFont : wFont;

  index_count,
  vertex_count : Int32;

  vector1 : wVector3f;

  backColor : wColor4s = (alpha : 255; red : 20; green : 25; blue : 25);

  fromPos,
  toPos : wVector2i;

  meshPath : PChar = 'Assets/Models/cube.x';
  fontPath : PChar = 'Assets/Fonts/3.png';

  wndCaption : PWChar = 'Example 22: Indices and Vertices FPS: ';
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
  if (not CheckFilePath(meshPath) or
      not CheckFilePath(fontPath)) then
    exit;

  ///Load resources
  BitmapFont := wFontLoad(fontPath);
  // load a mesh
  DirectXMesh := wMeshLoad(meshPath);

  // display metric information on the mesh, the number of indices and vertices
  index_count := wMeshGetIndicesCount( DirectXMesh, 0 );
  vertex_count := wMeshGetVerticesCount( DirectXMesh, 0 );

  // dimention an array large enough to contain the list of vertices
  SetLength(vertices, vertex_count);

  // copy the vertex information into the array
  wMeshGetVertices(DirectXMesh,0,@vertices[0],0);

  // itterate through all of the vertices
  for i := 0 to vertex_count - 1 do
    begin
      // shrink the vertex X location by half its size
      vertices[i].vertPos.x *= 0.5;

      // change the color of the vertex to a random value
      vertices[i].vertColor.alpha := round(wMathRandomRange(0,255));
      vertices[i].vertColor.red   := round(wMathRandomRange(0,255));
      vertices[i].vertColor.green := round(wMathRandomRange(0,255));
      vertices[i].vertColor.blue  := round(wMathRandomRange(0,255));
    end;

  // copy the altered vertex infomation back to the mesh
  wMeshSetVertices( DirectXMesh, 0, @vertices[0]);

  // add the mesh to the scene
  SceneNode := wNodeCreateFromMesh( DirectXMesh );

  // scale the node size up as the origonal mesh is very small
  vector1 := to_wVector3f(20,20,20);
  wNodeSetScale( SceneNode,vector1);

  // switch on debugging information so that you can see the bounding box around
  // the node
  wNodeSetDebugMode( SceneNode,wDM_BBOX);

  // switch off lighting effects on this model
  material := wNodeGetMaterial(SceneNode,0);
  wMaterialSetFlag(material,wMF_LIGHTING,false);

  // add a controllable camera into the scene looking at the object
  vector1 := to_wVector3f(50,40,-50);
  OurCamera := wCameraCreate(vector1, wVECTOR3f_ZERO);

  // -----------------------------------------------------------------------------
  // while the WorldSim3D environment is still running
  while wEngineRunning do
    begin
      // clear the canvas to black to show the particles up better
      wSceneBegin(backColor);

      // draw the scene
      wSceneDrawAll();

      fromPos := to_wVector2i(30,10);
      toPos   := to_wVector2i(400,60);

      wFontDraw(BitmapFont,
                WStr('Index count ' + IntToStr(index_count) + '  ' +
                     'Vertex count ' + IntToStr(vertex_count)),
                fromPos, toPos,
                wCOLOR4s_WHITE);

      for i := 0 to vertex_count - 1 do
        begin
          fromPos.y += 17;
          toPos.y   += 17;

          wFontDraw(BitmapFont,
                    WStr('Vertex ' + IntToStr(i) + ' ' +
                         'Position: ' + FormatFloat('0.0', vertices[i].vertPos.x) + ', ' +
                                        FormatFloat('0.0', vertices[i].vertPos.y) + ', ' +
                                        FormatFloat('0.0', vertices[i].vertPos.z) + ' ' +    
                         'Normal: ' + FormatFloat('0.0', vertices[i].vertNormal.x) + ', ' +
                                      FormatFloat('0.0', vertices[i].vertNormal.y) + ', ' +
                                      FormatFloat('0.0', vertices[i].vertNormal.z) + #10#13),
                    fromPos, toPos,
                    wCOLOR4s_SKYBLUE);
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


