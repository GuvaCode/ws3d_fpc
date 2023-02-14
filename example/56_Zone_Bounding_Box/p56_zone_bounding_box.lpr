{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 56: Управление зонами: контейнеры (Bounding Boxes)
'' Пример демонстрирует контейнеры, созданные путём добавлениz дочерних объектов
'' к родительским объектам для управления зонами.
'' ----------------------------------------------------------------------------}
program p56_Zone_Bounding_Box;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

var
  Billboard, Camera, zone: wNode;
  BillboardTexture: wTexture;
  BillboardSize: wVector2f = (x:7; y:7);
  vec1: wVector3f;
  material: wMaterial;
  prevFps: Int32;
  wndCaption: wString = 'Example 56: Zone Management Bounding Boxes ';
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

  //Add the billboard to the scene, the first two parameters are the size of the
  //billboard in this instance they match the pixel size of the bitmap to give
  //the correct aspect ratio. the last three parameters are the position of the
  //billboard object
  for x := -15 to 14 do
  begin
    for z := -15 To 14 do
    begin
      zone := wZoneManagerCreate(0, 600);
      wZoneManagerSetProperties(zone,0,600,true);
      wNodeSetDebugMode(zone,wDM_FULL);

      // here we create 6 billboards for each zone, this would make nearly 4600
      // billboards but as only a small set are displayed there is minimal
      // effect on the speed of the display
      for n := 0 to 4 do
      begin
        Billboard := wBillBoardCreate(wVECTOR3f_ZERO,BillboardSize);
        material := wNodeGetMaterial(Billboard,0);
        wMaterialSetTexture(material, 0,BillboardTexture);
        wMaterialSetFlag(material, wMF_LIGHTING, false);
        vec1.x := wMathRandomRange(0,50);
        vec1.y := wMathRandomRange(0,50);
        vec1.z := wMathRandomRange(0,50);
        wNodeSetPosition(Billboard, vec1);

        // finally we attach the billboard to the zone as a child and the
        // billboard is thereafter automatically managed by the zone manager
        wNodeSetParent(Billboard,zone);
      end;

      vec1.x:=x*100;
      vec1.y:=0;
      vec1.z:=z*100;
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
    wSceneBegin(wCOLOR4s_BLACK);

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

