{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 59: Ограниченное столкновение с помощью точек
'' Пример показывает использование проверки столкновений между какой-либо точкой
'' и объектом на сцене, ограниченных через ID этих объектов.
'' ----------------------------------------------------------------------------
}
program p59_Collision_Limited_With_Point;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

var
  BillboardTexture: wTexture;
  Camera, Billboard, zone, SelectedNode, RootNode: wNode;
  BitmapFont: wFont;
  vec1: wVector3f;
  material: wMaterial;
  fromPos: wVector2i = (X:230; Y:10);
  toPos: wVector2i = (X:450; Y:25);
  nodelabel, nodename: wString;
  prevFps, saveColors: Int32;
  wndCaption: wString = 'Example 59: Limited Collision with a Point ';
  fontPath: PChar = 'Assets/Fonts/3.png';
  x,z: Integer;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(fontPath);

  {Load resources}
  BitmapFont := wFontLoad(fontPath);
  saveColors := wConsoleSaveDefaultColors();
  wConsoleSetFontColor(wCFC_LIGHTGREEN);
  for x :=-3 to 3 do
  begin
    for z :=-3 to 3 do
    begin
    zone := wZoneManagerCreate(0.0,9999.0);
    //vec1.x=100.f: vec1.y=100.f: vec1.z=100.f
    wZoneManagerSetBoundingBox(zone,wVECTOR3f_ZERO, wVector3fCreate(100,100,100));
    //vec1.x=x*100: vec1.y=0: vec1.z=z*100
    wNodeSetPosition(zone,wVector3fCreate(x*100,0,z*100));
    wNodeSetDebugMode(zone,wDM_FULL);
    nodename := WStr('SELECTED NODE IS: ZONE - ' + IntToStr(x + 3) + ' , ' +  IntToStr(z + 3));
    wNodeSetName(zone, 'nodelabel');
    end;
  end;
  wConsoleResetColors(saveColors);

  {Create camera}
  Camera := wFpsCameraCreate(100, 0.1, @wKeyMapDefault, 8, false, 0);

  {Hide mouse}
  wInputSetCursorVisible(false);

  RootNode := wSceneGetRootNode();

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wCOLOR4s_BLACK);

    wSceneDrawAll();

    //Get the position of the camera
    vec1 := wNodeGetPosition(Camera);

    //Get the first object that is the subject of a collision with the specified
    //point, the call is supplied with the Parent node to test, a bitmask to
    //tlimit the ID of the nodes included into the test a flag to declare
    //whether the entire tree of nodes is tested and finally the point to be
    //tested against
    SelectedNode := wCollisionGetNodeChildFromPoint(RootNode, 0, false, @vec1);

    //If a node was selected
    if SelectedNode <> nil then
    begin
      //Get the name of the zone
      nodelabel := wideString(wNodeGetName(SelectedNode));
      //Draw this position information to the screen
      wFontDraw(BitmapFont, nodelabel, fromPos, toPos, wColor4s_WHITE);
    end;


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

