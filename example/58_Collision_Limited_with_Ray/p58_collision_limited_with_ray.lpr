{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 58: Ограничение столкновения с помощью луча
'' Пример выделяет нод, выбранный с помощью луча для столкновения; набор объектов
'' ограничен только тестовыми объектами с определёнными ID. Это может значительно
'' сократить число объектов, которые нужно принимать во внимание. Таким образом
'' уменьшается количество обрабавтываемой процессором информации, освобождая
'' ресурсы для других действий, например, тех же столкновений.(Каждая проверка
'' столкновений на сцене занимает у процессора определённое количество времени).
'' ----------------------------------------------------------------------------
}
program p58_Collision_Limited_with_Ray;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;


var
  MeshTexture: wTexture;
  TestNode, SelectedNode, OurCamera: wNode;
  start_vector: wVector3f = (x:-200; y: 0; z:100);
  end_vector: wVector3f = (x:1000; y:0; z:100);
  vec1, vec2: wVector3f;
  material: wMaterial;
  findId: Int32 = 2;
  prevFps: Int32;
  wndCaption: wString = 'Example 58: Limited collision with a ray ';
  meshTexPath: PChar = 'Assets/Textures/Metal.jpg';

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(meshTexPath);

  {Load resources}
  MeshTexture := wTextureLoad(meshTexPath);

  {Create test node}
  TestNode := wNodeCreateCube(10.0, false, wColor4s_White);
  material := wNodeGetMaterial(TestNode,0);
  wMaterialSetFlag(material,wMF_LIGHTING,false);
  wMaterialSetTexture(material,0,MeshTexture);

  wNodeSetId(TestNode,1);

  wNodeSetPosition(TestNode, wVector3fCreate(-100,0,100));

  wNodeSetScale(TestNode,wVector3fCreate(2,2,2));

  TestNode := wNodeCreateCube(10.0, false, wColor4s_WHITE);
  material := wNodeGetMaterial(TestNode,0);
  wMaterialSetFlag(material,wMF_LIGHTING,false);
  wMaterialSetTexture(material,0,MeshTexture);

  wNodeSetPosition(TestNode, wVector3fCreate(0,0,100));

  TestNode := wNodeCreateCube(10.0, false, wColor4s_WHITE);
  material := wNodeGetMaterial(TestNode,0);
  wMaterialSetFlag(material,wMF_LIGHTING,false);
  wMaterialSetTexture(material,0,MeshTexture);

  wNodeSetPosition(TestNode, wVector3fCreate(100,0,100));

  TestNode := wNodeCreateCube(10.0, false, wColor4s_WHITE);
  material := wNodeGetMaterial(TestNode,0);
  wMaterialSetFlag(material,wMF_LIGHTING,false);
  wMaterialSetTexture(material,0,MeshTexture);


  wNodeSetPosition(TestNode, wVector3fCreate(200,0,100));


  {Create camera}
  OurCamera := wFpsCameraCreate(100,0.1, @wKeyMapDefault, 8, false, 0);
  wNodeSetPosition(OurCamera,wVector3fCreate(50,0,-200));

  {Hide mouse}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,128,128,128));

    wSceneDrawAll();

    if  SelectedNode = nil then
    begin
    TestNode := wSceneGetRootNode();
    //Get the nearest node that collides with the ray we defined earlier
    //the ID must also contain the bit pattern of '2'. this excludes the
    //first object we created as we gave that an ID of 1
    SelectedNode := wCollisionGetNodeChildFromRay(TestNode, findId, FALSE, @start_vector,@end_vector);
    if SelectedNode <> nil then wNodeSetDebugMode(SelectedNode,wDM_HALF_TRANSPARENCY);
    end;

    w3dDrawLine(start_vector,end_vector,wCOLOR4s_RED);

    vec1.x := start_vector.x;
    vec1.y := start_vector.y+5;
    vec1.z := start_vector.z-5;

    vec2.x := start_vector.x;
    vec2.y := start_vector.y-5;
    vec2.z := start_vector.z+5;

    w3dDrawLine(vec1, vec2, wCOLOR4s_RED);

    vec1.x := start_vector.x;
    vec1.y := start_vector.y-5;
    vec1.z := start_vector.z-5;

    vec2.x := start_vector.x;
    vec2.y := start_vector.y+5;
    vec2.z := start_vector.z+5;

    w3dDrawLine(vec1, vec2, wCOLOR4s_RED);

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

