{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 55: Управление зонами объектов
'' Пример демонстрирует управление зонами объектов. Фактически, это родительские
'' объекты, управляющие видимостью связанных с ними дочерних объектов. Это можно
'' использовать для того, чтобы удалять из зоны видимости те объекты, которые
'' вышли за пределы обзора камеры.
'' ----------------------------------------------------------------------------}
program p55_Zone_Management;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

var 
  Billboard, Camera, zone: wNode;
  BillboardTexture: wTexture;
  BillboardSize: wVector2f = (X:7; Y:7);
  vec1: wVector3f;
  material: wMaterial;
  prevFps: Int32;
  wndCaption: wString = 'Example 55: Zone Management  ';
  billTexPath: PChar = 'Assets/Textures/Metal.jpg';
  x, z, n: Integer;


begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(billTexPath);

  {Load resources}
  BillboardTexture := wTextureLoad(billTexPath);

  {Here we create 900 zones}
  for x := -15 to 14 do
  begin
    for z := -15 to 14 do
      begin
        // we add in a zone management object and set the near distance to 100
        // and the far distance to 300. the zone management object will only
        // be visible if the zone is more than 100 units from the active camera
        // and less than 300 units away, any child objects of this zone will be
        // completely unprocessed.
        // if you set your zone up in conjunction with fog you can have lots of
        // complex objects in the scene and when the zone they were in was out of
        // camera range the objects would be completely disabled and have no
        // impact on the processing of the scene
        // you could also place a large number of zone managers into another zone
        // if your environment was sufficiently complex
        // the near value also allows you to implement a simple level of detail
        // LOD effect by having a low and high resoloution zones overlapping one
        // another the high resoloution zone might display from 0 to 100 while
        // the low resoloution zone displays from 100 to 500
        zone := wZoneManagerCreate(100, 300);

        // here we create 6 billboards for each zone, this would make nearly 4600
        // billboards but as only a small set are displayed there is minimal
        // effect on the speed of the display
        for n := 0 To 4 do
        begin
          Billboard := wBillBoardCreate(wVECTOR3f_ZERO,BillboardSize);
          material := wNodeGetMaterial(Billboard,0);
          wMaterialSetTexture(material,0,BillboardTexture);
          wMaterialSetFlag(material, wMF_LIGHTING, false);
          vec1.x := wMathRandomRange(0,50);
          vec1.y := wMathRandomRange(0,50);
          vec1.z := wMathRandomRange(0,50);
          wNodeSetPosition(Billboard, vec1);

          // finally we attach the billboard to the zone as a child and the
          // billboard is thereafter automatically managed by the zone manager
          wNodeSetParent(Billboard,zone);
        end;
      vec1.x:=x*100; vec1.y:=0; vec1.z:=z*100;
      wNodeSetPosition(zone, vec1);
    end;
  end;

  {Create camera}
  Camera := wFpsCameraCreate(100, 0.1, @wKeyMapDefault, 8, FALSE, 0);

  {Hide mouse}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,215,205,200));

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

