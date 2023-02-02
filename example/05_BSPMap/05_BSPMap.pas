
program p05_BSPMap;

uses
  // Подключаем главную библиотеку движка
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  BSPMesh:wMesh		                 ;
  BSPNode:wNode                          ;
  CameraNode:wNode                       ;
  BitmapFont:wFont                       ;

  fromPos:wVector2i;
  toPos:wVector2i;

  i:Int32;
  mat:wMaterial                          ;

  vec:wVector3f;
  backColor:wColor4s                     =(alpha:255; red:0;green:0;blue:50);
  wndCaption:PWChar 		         ='Example 05: BSP Map with Q3-shaders and Entity reading fps: ';

  prevFPS:Int32 			 ;

  fontPath:PChar                         ='Assets/Fonts/Cyr.xml';
  mapPath:PChar                          ='Assets/BSPmaps/map-20kdm2.pk3';

begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(fontPath);
  CheckFilePath(mapPath);

  {Load resources}
  BitmapFont:=wFontLoad(fontPath);
  wFileAddZipArchive(mapPath,true,true);
  BSPMesh:= wMeshLoad('20kdm2.bsp');

  {Create bsp level}
  BSPNode:=wBspCreateFromMesh(BSPMesh,false,true,Pchar(''),True,512);

  {Show engine logo}
  wEngineShowLogo(true);

  {Create FPS-camera}
  CameraNode:=wFpsCameraCreate(100,0.1,@wKeyMapDefault[0],8,false,0);

  vec.x:=896; vec.y:=216; vec.z:=960;
  wNodeSetPosition(CameraNode,vec);

  {Parse Quake3 map}
  ParseQuakeMap(BSPMesh);

  {Другой вариант парсинга BSP-карты}
  //ParseQuakeMap2(BSPMesh)

  {Hide mouse cursor}
  wInputSetCursorVisible(false);

  while wEngineRunning() do

  begin

    wSceneBegin(backColor);

    wSceneDrawAll();

    {Key events}
    if wInputIsKeyHit(wKC_F1) then
       begin
        SetQuakeShadersVisible(false);
    end;

    if wInputIsKeyHit(wKC_F2) then
       begin
    	SetQuakeShadersVisible(true);
       end;

    if wInputIsKeyHit(wKC_F3) then
       begin
    	for i:= 0 to wNodeGetMaterialsCount(BSPNode)-1 do
          begin
            mat:=wNodeGetMaterial(BSPNode,i);
            wMaterialSetFlag(mat,wMF_WIREFRAME,true);
       end;
    end;

    if wInputIsKeyHit(wKC_F4) then
       begin
    	for i:=0 to wNodeGetMaterialsCount(BSPNode)-1 do
          begin
            mat:=wNodeGetMaterial(BSPNode,i);
    	    wMaterialSetFlag(mat,wMF_WIREFRAME,false)
        end;
    end;

    if wInputIsKeyHit(wKC_F5) then
       begin
    	wNodeSetVisibility(BSPNode,false);
    end;

    if wInputIsKeyHit(wKC_F6) then
       begin
    	wNodeSetVisibility(BSPNode,true);
    end;

    {Draw text info}
    fromPos.x:=250; fromPos.y:=510; toPos.x:=450; toPos.y:=530;
    wFontDraw ( BitmapFont, 'F1/F2 - Hide/show Q3-shaders', fromPos,toPos,wCOLOR4s_WHITE);

    fromPos.x:=250; fromPos.y:=540; toPos.x:=450; toPos.y:=560;
    wFontDraw ( BitmapFont, 'F3/F4 - Wireframe/Solid',fromPos,toPos,wCOLOR4s_WHITE);

    fromPos.x:=250; fromPos.y:=570; toPos.x:=450; toPos.y:=590;
    wFontDraw ( BitmapFont, 'F5/F6 - Hide/show map', fromPos,toPos,wCOLOR4s_WHITE);

    wSceneEnd();

    wEngineCloseByEsc();

    if prevFPS<>wEngineGetFPS() then
       begin
         prevFPS:=wEngineGetFPS();
         wWindowSetCaption(wndCaption+WStr(FormatFloat('0',prevFPS)));
    end;

  end;

  wEngineStop(true);
end.

