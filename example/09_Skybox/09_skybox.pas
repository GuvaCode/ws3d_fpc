
program p09_SkyBox;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  Position:wVector3f;
  SkyTextures : array [0..5] of wTexture;
  start,
  SkyBox,
  Camera : wNode;
  mat :wMaterial;
  wndCaption:PWChar='Example 9: SkyBox ';
  i : Integer;
  skyTexPath  : array[0..5] of PChar = ('Assets/SkyBoxes/Grandcanyon/skybox_up.jpg',
                                        'Assets/SkyBoxes/Grandcanyon/skybox_dn.jpg',
                                        'Assets/SkyBoxes/Grandcanyon/skybox_rt.jpg',
                                        'Assets/SkyBoxes/Grandcanyon/skybox_lf.jpg',
                                        'Assets/SkyBoxes/Grandcanyon/skybox_ft.jpg',
                                        'Assets/SkyBoxes/Grandcanyon/skybox_bk.jpg');


begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  for i := Low(skyTexPath) to High(skyTexPath) do
    if (not CheckFilePath(skyTexPath[i])) then
      exit
    else
      SkyTextures[i] := wTextureLoad(skyTexPath[i]);

  {Greate nodes}
  SkyBox := wSkyBoxCreate(SkyTextures[0],SkyTextures[1],SkyTextures[2],SkyTextures[3],SkyTextures[4],SkyTextures[5]);

  Camera:=wFpsCameraCreate(100,0.1,@wKeyMapDefault,8,false,0);

  Position.x:=0;
  Position.y:=0;
  Position.z:=-30;
  wNodeMove(Camera,Position);

   ///Create start position: sphere node
  start:=wNodeCreateSphere(2,8,false, wColor4s_DARKRED);
  mat:=wNodeGetMaterial(start,0);
  wMaterialSetFlag(mat,wMF_LIGHTING,false);
  wMaterialSetType(mat,wMT_TRANSPARENT_VERTEX_ALPHA);


  {Show engine logo}
  wEngineShowLogo(true);

  while wEngineRunning do
     begin
       wSceneBegin(wCOLOR4s_BLACK);
       wSceneDrawAll();
       wSceneEnd();
       wEngineCloseByEsc();
     end;
   wEngineStop(true);
end.

