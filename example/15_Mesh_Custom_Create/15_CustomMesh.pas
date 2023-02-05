{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas(WorldSim3D developer)
'' Адаптировал Vuvk
'' ----------------------------------------------------------------------------
'' Пример 15: Пользовательский меш
'' В примере показано, как сделать самому меш (3D модель). В данном случае создаётся
'' простой меш пирамиды, причём готовым для наложения текстуры. Затем такой только что
'' созданный меш добавляется на сцену как новый нод и к нему применяется материал.
'' ----------------------------------------------------------------------------
}
program p15_CustomMesh;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  SceneNode1,
  SceneNode2,
  OurCamera : wNode;

  delta,
  turnVector : wVector3f;

  backColor : wColor4s = (alpha: 255; red : 64; green : 96; blue : 96);

  frameDelta : Single = 0;
  turnSpeed  : Single = 20;

  wndCaption : PWChar = 'Example 15: Create a custom mesh ';
  prevFPS : Int32=0;

          
///Declare custom procedures
procedure CreateNode1(position, scale : wVector3f);
var
  i : Integer;
  mesh : wMesh;
  MeshBuffer : wMeshBuffer;
  MeshTexture : wTexture;
  mat : wMaterial;
  verts : array[0..4] of wVert;
  indices : array[0..17] of UInt16;
  texPath : PChar = 'Assets/Textures/Metal.jpg';
begin
  ///Check resources
  if (not CheckFilePath(texPath)) then
    exit;

  ///Load resources
  MeshTexture := wTextureLoad(texPath);

  verts[0].vertPos.x := -10;
  verts[0].vertPos.y := 0;
  verts[0].vertPos.z := -10;

  verts[1].vertPos.x := -10;
  verts[1].vertPos.y := 0;
  verts[1].vertPos.z := 10;

  verts[2].vertPos.x := 10;
  verts[2].vertPos.y := 0;
  verts[2].vertPos.z := 10;

  verts[3].vertPos.x := 10;
  verts[3].vertPos.y := 0;
  verts[3].vertPos.z := -10;

  verts[4].vertPos.x := 0;
  verts[4].vertPos.y := 20;
  verts[4].vertPos.z := 0;

  verts[0].texCoords.x := 0;
  verts[0].texCoords.y := 0;

  verts[1].texCoords.x := 0;
  verts[1].texCoords.y := 1;

  verts[2].texCoords.x := 1;
  verts[2].texCoords.y := 1;

  verts[3].texCoords.x := 1;
  verts[3].texCoords.y := 0;

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


  ///Create mesh
  mesh := wMeshCreate('TestMesh');

  MeshBuffer := wMeshBufferCreate(5, @verts[0], 18, @indices[0]);
  wMeshAddMeshBuffer(mesh,MeshBuffer);

  for i := 0 to High(verts) do
    verts[i].vertPos.x += 20;

  MeshBuffer:=wMeshBufferCreate(5, @verts[0], 18, @indices[0]);
  wMeshAddMeshBuffer(mesh,MeshBuffer);

  for i := 0 to High(verts) do
    verts[i].vertPos.z += 20;

  MeshBuffer := wMeshBufferCreate(5, @verts[0], 18, @indices[0]);
  wMeshAddMeshBuffer(mesh,MeshBuffer);

  for i := 0 to High(verts) do
    verts[i].vertPos.x -= 20;

  MeshBuffer := wMeshBufferCreate(5, @verts[0], 18, @indices[0]);
  wMeshAddMeshBuffer(mesh,MeshBuffer);

  ///На всякий случай центрируем полученный меш относительно (0,0,0)
  wMeshFit(mesh, wVECTOR3f_ZERO, @delta);

  ///Create node
  SceneNode1 := wNodeCreateFromMesh(mesh);

  for i := 0 to wNodeGetMaterialsCount(SceneNode1) - 1 do
    begin
      mat := wNodeGetMaterial(SceneNode1, i);
      wMaterialSetFlag(mat, wMF_LIGHTING, false);
      wMaterialSetTexture(mat, 0, MeshTexture);
    end;

  wNodeSetPosition(SceneNode1,position);
  wNodeSetScale(SceneNode1,scale);
end;

procedure CreateNode2(position, scale : wVector3f);
  ///Сделаем куб, состоящий из 6 мешбуфферов
  ///(один мешбуффер = 1 грань куба)
  ///У каждого мешбуффера свой материал,
  ///т.е. появляется возможность задать
  ///индивидуальную текстуру для каждой грани
  ///Без использования этого приема достичь аналогичного результата возможно:
  ///а)Созданием модели во внешнем 3D-редакторе (напр., Blender)
  ///б)Написанием GLSL/HLSL-шейдера с соответствующими действиями
  ///Несмотря на то, что каждый материал нода поддерживает до 8 текстур,
  ///все стандартные материалы движка используют только одну/две текстуры с номерами 0/1
  ///соответственно (wMT_NORMAL..., wMT_PARALLAX..., wMT_DETAIL_MAP....)
  {
      0YZ         XYZ
        /  -------/        y
       /  |      / |        ^  z
      /   |     /  |        | /
  0Y0 ----|---- |  |        |/
      |  / - - - - - X0Z    *----->x
      | /       |  /
      |/        | /
      -----------/
     000       X00
  }

var
  i : Integer;          
  mesh : wMesh;
  meshBuffer : wMeshBuffer;
  material : wMaterial;
  texture : array [0..5] of wTexture;
  texPath : array [0..5] of PChar = (
          'Assets/Textures/default_texture.png',
          'Assets/Textures/lava0005.png',
          'Assets/Textures/detailmap3.jpg',
          'Assets/Textures/rockwall.bmp',
          'Assets/Textures/Metal.jpg',
          'Assets/Textures/water.png'
          );
  delta : wVector3f;

  ///Набор для одной грани: 4 вершины,
  ///2 треугольника-полигона в каждой грани,
  ///6 индексов для "обхода" вершин.
  verts : array [0..3] of wVert;
  indices : array [0..5] of UInt16;

  X : Single = 1.0;
  Y : Single = 1.0;
  Z : Single = 1.0;
begin

  ///Check resources
  for i := 0 to High(texPath) do
    if (not CheckFilePath(texPath[i])) then
      exit;

  ///Load resources
  texture[0] := wTextureLoad(texPath[0]);
  texture[1] := wTextureLoad(texPath[1]);
  texture[2] := wTextureLoad(texPath[2]);
  texture[3] := wTextureLoad(texPath[3]);
  texture[4] := wTextureLoad(texPath[4]);
  texture[5] := wTextureLoad(texPath[5]);

  ///Create empty mesh
  mesh := wMeshCreate('Test cube mesh');

  ///ГРАНЬ №1///
  ///Позиция вертексов
  verts[0].vertPos.x := 0;
  verts[0].vertPos.y := 0;
  verts[0].vertPos.z := 0;

  verts[1].vertPos.x := X;
  verts[1].vertPos.y := 0;
  verts[1].vertPos.z := 0;

  verts[2].vertPos.x := X;
  verts[2].vertPos.y := Y;
  verts[2].vertPos.z := 0;

  verts[3].vertPos.x := 0;
  verts[3].vertPos.y := Y;
  verts[3].vertPos.z := 0;

  ///Нормали
  verts[0].vertNormal.x := -1;
  verts[0].vertNormal.y := -1;
  verts[0].vertNormal.z := -1;

  verts[1].vertNormal.x := 1;
  verts[1].vertNormal.y := -1;
  verts[1].vertNormal.z := -1;

  verts[2].vertNormal.x := 1;
  verts[2].vertNormal.y := 1;
  verts[2].vertNormal.z := -1;

  verts[3].vertNormal.x := -1;
  verts[3].vertNormal.y := 1;
  verts[3].vertNormal.z := -1;

  ///Цвета вершин
  verts[0].vertColor := wCOLOR4s_WHITE;
  verts[1].vertColor := wCOLOR4s_WHITE;
  verts[2].vertColor := wCOLOR4s_WHITE;
  verts[3].vertColor := wCOLOR4s_WHITE;

  ///Текстурные координаты
  verts[0].texCoords.x := 0;
  verts[0].texCoords.y := 1;

  verts[1].texCoords.x := 1;
  verts[1].texCoords.y := 1;

  verts[2].texCoords.x := 1;
  verts[2].texCoords.y := 0;

  verts[3].texCoords.x := 0;
  verts[3].texCoords.y := 0;

  ///Индексы
  indices[0] := 0;
  indices[1] := 2;
  indices[2] := 1;
  indices[3] := 0;
  indices[4] := 3;
  indices[5] := 2;

  meshBuffer := wMeshBufferCreate(4, @verts[0], 6, @indices[0]);

  material := wMeshBufferGetMaterial(meshBuffer);
  wMaterialSetFlag(material,wMF_LIGHTING,false);

  wMaterialSetTexture(material,0,texture[0]);

  wMeshAddMeshBuffer(mesh,meshBuffer);

  ///ГРАНЬ №2///
  ///Позиция вертексов
  verts[0].vertPos.x := X;
  verts[0].vertPos.y := 0;
  verts[0].vertPos.z := Z;

  verts[1].vertPos.x := X;
  verts[1].vertPos.y := Y;
  verts[1].vertPos.z := Z;

  verts[2].vertPos.x := 0;
  verts[2].vertPos.y := Y;
  verts[2].vertPos.z := Z;

  verts[3].vertPos.x := 0;
  verts[3].vertPos.y := 0;
  verts[3].vertPos.z := Z;

  ///Нормали
  verts[0].vertNormal.x := 1;
  verts[0].vertNormal.y := -1;
  verts[0].vertNormal.z := 1;

  verts[1].vertNormal.x := 1;
  verts[1].vertNormal.y := 1;
  verts[1].vertNormal.z := 1;

  verts[2].vertNormal.x := -1;
  verts[2].vertNormal.y := 1;
  verts[2].vertNormal.z := 1;

  verts[3].vertNormal.x := -1;
  verts[3].vertNormal.y := -1;
  verts[3].vertNormal.z := 1;

  ///Текстурные координаты
  verts[0].texCoords.x := 0;
  verts[0].texCoords.y := 1;

  verts[1].texCoords.x := 0;
  verts[1].texCoords.y := 0;

  verts[2].texCoords.x := 1;
  verts[2].texCoords.y := 0;

  verts[3].texCoords.x := 1;
  verts[3].texCoords.y := 1;

  ///Индексы
  indices[0] := 0;
  indices[1] := 1;
  indices[2] := 2;
  indices[3] := 0;
  indices[4] := 2;
  indices[5] := 3;

  meshBuffer := wMeshBufferCreate(4, @verts[0], 6, @indices[0]);

  material := wMeshBufferGetMaterial(meshBuffer);
  wMaterialSetFlag(material,wMF_LIGHTING,false);

  wMaterialSetTexture(material,0,texture[1]);

  wMeshAddMeshBuffer(mesh,meshBuffer);

  ///ГРАНЬ №3///
  ///Позиция вертексов
  verts[0].vertPos.x := 0;
  verts[0].vertPos.y := Y;
  verts[0].vertPos.z := Z;

  verts[1].vertPos.x := 0;
  verts[1].vertPos.y := Y;
  verts[1].vertPos.z := 0;

  verts[2].vertPos.x := 0;
  verts[2].vertPos.y := 0;
  verts[2].vertPos.z := 0;

  verts[3].vertPos.x := 0;
  verts[3].vertPos.y := 0;
  verts[3].vertPos.z := Z;

  ///Нормали
  verts[0].vertNormal.x := -1;
  verts[0].vertNormal.y := 1;
  verts[0].vertNormal.z := 1;

  verts[1].vertNormal.x := -1;
  verts[1].vertNormal.y := 1;
  verts[1].vertNormal.z := -1;

  verts[2].vertNormal.x := -1;
  verts[2].vertNormal.y := -1;
  verts[2].vertNormal.z := -1;

  verts[3].vertNormal.x := -1;
  verts[3].vertNormal.y := -1;
  verts[3].vertNormal.z := 1;

  ///Текстурные координаты
  verts[0].texCoords.x := 0;
  verts[0].texCoords.y := 1;

  verts[1].texCoords.x := 1;
  verts[1].texCoords.y := 1;

  verts[2].texCoords.x := 1;
  verts[2].texCoords.y := 0;

  verts[3].texCoords.x := 0;
  verts[3].texCoords.y := 0;

  ///Индексы
  indices[0] := 0;
  indices[1] := 1;
  indices[2] := 2;
  indices[3] := 0;
  indices[4] := 2;
  indices[5] := 3;

  meshBuffer := wMeshBufferCreate(4, @verts[0], 6, @indices[0]);

  material := wMeshBufferGetMaterial(meshBuffer);
  wMaterialSetFlag(material,wMF_LIGHTING,false);

  wMaterialSetTexture(material,0,texture[2]);

  wMeshAddMeshBuffer(mesh,meshBuffer);


  ///ГРАНЬ №4///
  for i := 0 to 3 do
      verts[i].vertPos.x += X;

  ///Нормали
  verts[0].vertNormal.x := 1;
  verts[0].vertNormal.y := 1;
  verts[0].vertNormal.z := 1;

  verts[1].vertNormal.x := 1;
  verts[1].vertNormal.y := 1;
  verts[1].vertNormal.z := -1;

  verts[2].vertNormal.x := 1;
  verts[2].vertNormal.y := -1;
  verts[2].vertNormal.z := -1;

  verts[3].vertNormal.x := 1;
  verts[3].vertNormal.y := -1;
  verts[3].vertNormal.z := 1;

  ///Индексы
  indices[0] := 0;
  indices[1] := 2;
  indices[2] := 1;
  indices[3] := 0;
  indices[4] := 3;
  indices[5] := 2;

  meshBuffer := wMeshBufferCreate(4, @verts[0], 6, @indices[0]);

  material := wMeshBufferGetMaterial(meshBuffer);
  wMaterialSetFlag(material,wMF_LIGHTING,false);

  wMaterialSetTexture(material,0,texture[3]);

  wMeshAddMeshBuffer(mesh,meshBuffer);

   ///ГРАНЬ №5///
  ///Позиция вертексов
  verts[0].vertPos.x := 0;
  verts[0].vertPos.y := Y;
  verts[0].vertPos.z := 0;

  verts[1].vertPos.x := X;
  verts[1].vertPos.y := Y;
  verts[1].vertPos.z := 0;

  verts[2].vertPos.x := X;
  verts[2].vertPos.y := Y;
  verts[2].vertPos.z := Z;

  verts[3].vertPos.x := 0;
  verts[3].vertPos.y := Y;
  verts[3].vertPos.z := Z;

  ///Нормали
  verts[0].vertNormal.x := -1;
  verts[0].vertNormal.y := 1;
  verts[0].vertNormal.z := -1;

  verts[1].vertNormal.x := 1;
  verts[1].vertNormal.y := 1;
  verts[1].vertNormal.z := -1;

  verts[2].vertNormal.x := 1;
  verts[2].vertNormal.y := 1;
  verts[2].vertNormal.z := 1;

  verts[3].vertNormal.x := -1;
  verts[3].vertNormal.y := 1;
  verts[3].vertNormal.z := 1;

  ///Текстурные координаты
  verts[0].texCoords.x := 0;
  verts[0].texCoords.y := 1;

  verts[1].texCoords.x := 1;
  verts[1].texCoords.y := 1;

  verts[2].texCoords.x := 1;
  verts[2].texCoords.y := 0;

  verts[3].texCoords.x := 0;
  verts[3].texCoords.y := 0;

  ///Индексы
  indices[0] := 0;
  indices[1] := 2;
  indices[2] := 1;
  indices[3] := 0;
  indices[4] := 3;
  indices[5] := 2;

  meshBuffer := wMeshBufferCreate(4, @verts[0], 6, @indices[0]);

  material := wMeshBufferGetMaterial(meshBuffer);
  wMaterialSetFlag(material,wMF_LIGHTING,false);

  wMaterialSetTexture(material,0,texture[4]);

  wMeshAddMeshBuffer(mesh,meshBuffer);


  ///ГРАНЬ №6///
  for i := 0 to 3 do
    verts[i].vertPos.y-=Y;

  verts[0].vertNormal.x := -1;
  verts[0].vertNormal.y := -1;
  verts[0].vertNormal.z := -1;

  verts[1].vertNormal.x := 1;
  verts[1].vertNormal.y := -1;
  verts[1].vertNormal.z := -1;

  verts[2].vertNormal.x := 1;
  verts[2].vertNormal.y := -1;
  verts[2].vertNormal.z := 1;

  verts[3].vertNormal.x := -1;
  verts[3].vertNormal.y := -1;
  verts[3].vertNormal.z := 1;

  ///Индексы
  indices[0] := 0;
  indices[1] := 1;
  indices[2] := 2;
  indices[3] := 0;
  indices[4] := 2;
  indices[5] := 3;

  meshBuffer := wMeshBufferCreate(4, @verts[0], 6, @indices[0]);

  material := wMeshBufferGetMaterial(meshBuffer);
  wMaterialSetFlag(material,wMF_LIGHTING,false);

  wMaterialSetTexture(material,0,texture[5]);

  wMeshAddMeshBuffer(mesh,meshBuffer);

  ///На всякий случай центрируем полученный меш относительно (0,0,0)
  wMeshFit(mesh,wVECTOR3f_ZERO,@delta);

  ///Create test node
  SceneNode2 := wNodeCreateFromMesh(mesh);
  wNodeSetPosition(SceneNode2,position);
  wNodeSetScale(SceneNode2,scale);

  //wNodeSetDebugMode(SceneNode2,wDM_NORMALS);
end;

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
                  
  CreateNode1(wVECTOR3f_ZERO, wVECTOR3f_ONE);
  CreateNode2(to_wVector3f(0,40,0), to_wVector3f(20,20,20));

  ///Create camera
  OurCamera := wFpsCameraCreate(100, 0.1, @wKeyMapDefault[0], Length(wKeyMapDefault));

  wNodeSetPosition(OurCamera, to_wVector3f(30,30,-80));

  wCameraSetTarget(OurCamera,wVECTOR3f_ZERO);

  ///Hide mouse cursor
  wInputSetCursorVisible(false);

  // -----------------------------------------------------------------------------
  // while the WorldSim3D environment is still running
  while wEngineRunning do
    begin
      // clear the canvas to black to show the particles up better
      wSceneBegin(backColor);
                              
      frameDelta := wTimerGetDelta();
      turnVector.x := frameDelta*turnSpeed;
      turnVector.y := frameDelta*turnSpeed;
      turnVector.z := frameDelta*turnSpeed;
      wNodeTurn(SceneNode2,turnVector);

      // draw the scene
      wSceneDrawAll();

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


