// ----------------------------------------------------------------------------
// Пример 24: Сохранение пользовательского меша в файл
// В примере показано, как сделать самому меш (3D модель). В данном случае создаётся
// простой меш пирамиды, причём готовым для наложения текстуры. Затем такой только что
// созданный меш добавляется на сцену как новый нод и к нему применяется материал.
// И наконец, происходит запись в текстовый файл (сохранение).
// ----------------------------------------------------------------------------

program p24_Mesh_Write_to_File;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  mesh: wMesh                  			= nil;
  MeshTexture: wTexture 	              	= nil;
  SceneNode: wNode                              = nil;
  OurCamera: wNode                              = nil;
  BitmapFont: wFont 	                        = nil;
  wndCaption: PwChar 		                = 'Example 24: Writing a custom mesh to a file FPS: ';
  prevFPS: Int32  			        = 0;
  fontPath: PChar                               ='Assets/Fonts/3.png';
  texPath: PChar                                ='Assets/Textures/Metal.jpg';
  fromPos, toPos: wVector2i;
  verts: array[0..4] of wVert;
  indices: array[0..17] of UInt16;
  MeshBuffer: wMeshBuffer;
  material: wmaterial;
  backColor: wColor4s;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(fontPath);
  CheckFilePath(texPath);

  {Load resources}
  BitmapFont := wFontLoad(fontPath);
  MeshTexture:= wTextureLoad(texPath);

  {Prepare meshbuffer}
  verts[0].vertPos.x := -10.0;
  verts[0].vertPos.y := 0.0;
  verts[0].vertPos.z := -10.0;

  verts[1].vertPos.x := -10.0;
  verts[1].vertPos.y := 0.0;
  verts[1].vertPos.z := 10.0;

  verts[2].vertPos.x := 10.0;
  verts[2].vertPos.y := 0.0;
  verts[2].vertPos.z := 10.0;

  verts[3].vertPos.x := 10.0;
  verts[3].vertPos.y := 0.0;
  verts[3].vertPos.z := -10.0;

  verts[4].vertPos.x := 0.0;
  verts[4].vertPos.y := 20.0;
  verts[4].vertPos.z := 0.0;

  verts[0].texCoords.x := 0.0;
  verts[0].texCoords.y := 0.0;

  verts[1].texCoords.x := 0.0;
  verts[1].texCoords.y := 1.0;

  verts[2].texCoords.x := 1.0;
  verts[2].texCoords.y := 1.0;

  verts[3].texCoords.x := 1.0;
  verts[3].texCoords.y := 0.0;

  verts[4].texCoords.x := 0.5;
  verts[4].texCoords.y := 0.5;

  verts[0].vertColor := wCOLOR4s_WHITE;
  verts[1].vertColor := wCOLOR4s_WHITE;
  verts[2].vertColor := wCOLOR4s_WHITE;
  verts[3].vertColor := wCOLOR4s_WHITE;
  verts[4].vertColor := wCOLOR4s_WHITE;

  indices[0] := 0;
  indices[1] := 1;
  indices[2] := 4;
  indices[3] := 1;
  indices[4] := 2;
  indices[5] := 4;
  indices[6] := 2;
  indices[7] := 3;
  indices[8] := 4;
  indices[9] := 3;
  indices[10] := 0;
  indices[11] := 4;
  indices[12] := 2;
  indices[13] := 1;
  indices[14] := 0;
  indices[15] := 0;
  indices[16] := 3;
  indices[17] := 2;

  {Create mesh}
  mesh := wMeshCreate('TestMesh');
  MeshBuffer:= wMeshBufferCreate(5, @verts[0], 18, @indices[0]);
  material:= wMeshBufferGetMaterial(MeshBuffer);
  wMaterialSetFlag(material,wMF_LIGHTING,false);
  wMaterialSetTexture(material,0,MeshTexture);
  wMeshAddMeshBuffer(mesh,MeshBuffer);

  {Add the mesh to the scene a couple of times}
  SceneNode := wNodeCreateFromMesh(mesh);

  {Write the first frame of the supplied animated mesh out to a file using
  the specified file format}
  wMeshSave(mesh,wMFF_WS_MESH, 'Assets/Models/myMesh.wsmesh');

  {Add a camera into the scene and resposition it to look at the pyramid}
  OurCamera:= wFpsCameraCreate( 100,0.1,@wKeyMapDefault,8,false,0);
  wNodeSetPosition(OurCamera,wVector3fCreate(30,50,25));
  wCameraSetTarget(OurCamera, wVECTOR3f_ZERO);
  wInputSetCursorVisible(false);
  backColor:= wColor4sCreate(255,64,96,96);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(backColor);
    wSceneDrawAll();

    wFontDraw (BitmapFont, 'The mesh is created and saved to the'+#13')'+'Assets/Models/ path as myMesh.wsmesh',
    fromPos, toPos, wCOLOR4s_WHITE );

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

