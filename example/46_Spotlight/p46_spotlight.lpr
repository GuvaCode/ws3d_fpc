{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
'' ----------------------------------------------------------------------------
'' Пример 46 : Световое пятно (Spotlight)
'' Пример создаёт простую сцену, а затем перемещает по её поверхности световое
'' пятно.
'' ----------------------------------------------------------------------------}
program p46_Spotlight;

{$mode objfpc}{$H+}

uses 
cmem, SysUtils, WorldSim3D, SampleFunctions;

var 
  ObjectTexture, BeastTexture: wTexture;
  HillMesh, BeastMesh: wMesh;
  BeastNode, HillNode, OurCamera, Light: wNode;
  material: wMaterial;
  vec1: wVector3f;
  prevFps: Int32;
  wndCaption: wString = 'Example 46: Spotlight';

  meshPath: Pchar = 'Assets/Models/Psionic/freebeast/beast.x';
  texObjPath: Pchar = 'Assets/Textures/surface.jpg';
  texMeshPath: Pchar = 'Assets/Models/Psionic/freebeast/beast3.jpg';

  i: integer;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(meshPath);
  CheckFilePath(texObjPath);
  CheckFilePath(texMeshPath);

  {Load resources}
  ObjectTexture := wTextureLoad(texObjPath);
  BeastTexture := wTextureLoad(texMeshPath);
  BeastMesh := wMeshLoad(meshPath);

  HillMesh := wMeshCreateHillPlane('HillPlane',
                                    wVector2fCreate(5.0,5.0),
                                    wVector2iCreate(32,32),nil,0,wVECTOR2f_ZERO,wVECTOR2f_ONE);

  {Create scene nodes}
  BeastNode := wNodeCreateFromMesh(BeastMesh);
  For I := 0 to wNodeGetMaterialsCount(BeastNode) - 1 do
  begin
    material := wNodeGetMaterial(BeastNode,i);
    wMaterialSetTexture(material,0,BeastTexture);
  end;


  wNodeSetScale(BeastNode,wVector3fCreate(1.5,1.5,1.5));

  wNodeSetPosition(BeastNode, wVector3fCreate(10,0,0));

  wNodeSetRotation(BeastNode,wVector3fCreate(0,180,0));

  HillNode := wNodeCreateFromMesh(HillMesh);

  For i := 0 to wNodeGetMaterialsCount(HillNode) - 1 do
  begin
    material := wNodeGetMaterial(HillNode,i);
    wMaterialSetTexture(material,0,ObjectTexture);
  end;

  wNodeSetPosition(HillNode,wVector3fCreate(0,-20,0));

  {Add a simple point light}
  Light := wLightCreate(wVector3fCreate(30,200,0), wCOLOR4f_WHITE, 600.0);

  wLightSetType(Light,wLT_SPOT);
  wLightSetInnerCone(Light,10.0);
  wLightSetOuterCone(Light,20.0);
  wLightSetFallOff(Light,100.0);

  {Apply a low ambient lighting level to the light source}
  wLightSetAmbientColor(Light, wColor4fCreate(1,0.1,0.1,0.1));

  {Add a camera into the scene, the first co-ordinates represents the 3D
  location of our view point into the scene the second co-ordinates specify the
  target point that the camera is looking at}
  OurCamera := wCameraCreate(wVector3fCreate(0,50,50),wVECTOR3f_ZERO);

  vec1:=wVector3fCreate(40,0,0);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,0,0,16));

    wNodeSetRotation(Light,vec1);

     if vec1.x<120.0 then
         vec1.x+=0.04
     else
         vec1.x:=40;

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

