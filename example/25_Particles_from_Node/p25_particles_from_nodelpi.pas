program p25_Particles_from_Nodelpi;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  SpaceshipMesh: wMesh                          = nil;
  MeshTexture: wTexture                	        = nil;
  ParticleTexture: wTexture                     = nil;
  SceneNode: wNode                     	        = nil;
  material: wMaterial                  	        = nil;
  animator: wAnimator                  	        = nil;
  SmokeEmitter: wEmitter;
  SmokeEmitterInfo: wParticleEmitter;
  SmokeParticles: wNode                	        = nil;
  fadeAffector: wAffector              	        = nil;
  attrAffector: wAffector              	        = nil;
  Camera: wNode                        	        = nil;
  wndCaption: wString                           = 'Example 25: Particles emitted from a node ';
  prevFPS: Int32;
  i: integer;
  fPath: PChar                                  ='Assets/Particles/ParticleGrey.bmp';
  meshPath: PChar                               ='Assets/Models/Scifi/spaceship/ship.x';
  meshTexPath: PChar                            ='Assets/Models/Scifi/spaceship/ship.jpg';
  params1: wParticleMeshEmitter;
  params2:wParticleAttractionAffector;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(fPath);
  CheckFilePath(meshPath);
  CheckFilePath(meshTexPath);

  {Load resources}
  ParticleTexture:=wTextureLoad(fPath);
  MeshTexture:=wTextureLoad(meshTexPath);
  SpaceshipMesh:=wMeshLoad(meshPath);


  SceneNode:=wNodeCreateFromMesh(SpaceshipMesh);
  for i:=0 to wNodeGetMaterialsCount(SceneNode)-1 do
  begin
    material:=wNodeGetMaterial(SceneNode,i);
    wMaterialSetFlag(material,wMF_LIGHTING,false);
    wMaterialSetTexture(material,0,MeshTexture);
  end;

  animator:=wAnimatorRotationCreate(SceneNode,wVector3fCreate(0.01,0.1,0.0));

  {Create particle system}
  SmokeParticles:=wParticleSystemCreate(true, wVector3Zero, wVector3Zero, wVector3fCreate(1,1,1));
  writeln('Create particle system');

  {Configure particle node materials}
  for i:=0 to wNodeGetMaterialsCount(SmokeParticles)-1 do
  begin
    material:=wNodeGetMaterial(SmokeParticles,i);
    wMaterialSetTexture(material,0,ParticleTexture);
    wMaterialSetFlag(material,wMF_LIGHTING,false);
    wMaterialSetType(material,wMT_TRANSPARENT_ADD_COLOR);
  end;

  {create box particle emitter}
  SmokeEmitter:=wParticleMeshEmitterCreate(SmokeParticles,SpaceshipMesh);
  wParticleMeshEmitterGetParameters(SmokeEmitter,@params1);
  params1.useNormalDirection:=true;
  params1.normalDirectionModifier:=0.25;
  params1.everyMeshVertex:=false;
  wParticleMeshEmitterSetParameters(SmokeEmitter,params1);

  {Configure emitter settings}
  SmokeEmitterInfo.maxAnglesDegrees:=15;
  SmokeEmitterInfo.direction.x:=0.01;
  SmokeEmitterInfo.direction.y:=0.01;
  SmokeEmitterInfo.direction.z:=-0.01;
  SmokeEmitterInfo.lifeTimeMax:=1000;
  SmokeEmitterInfo.lifeTimeMin:=200;
  SmokeEmitterInfo.maxParticlesPerSecond:=500;
  SmokeEmitterInfo.minParticlesPerSecond:=200;
  SmokeEmitterInfo.maxStartSize.x:=10;
  SmokeEmitterInfo.maxStartSize.y:=10;
  SmokeEmitterInfo.minStartSize.x:=3;
  SmokeEmitterInfo.minStartSize.y:=3;
  SmokeEmitterInfo.minStartColor:=wCOLOR4s_ORANGE;
  SmokeEmitterInfo.maxStartColor:=wCOLOR4s_RED;

  wParticleEmitterSetParameters(SmokeEmitter,SmokeEmitterInfo);

  {Create fade out particle affector}
  fadeAffector:=wParticleFadeOutAffectorCreate(SmokeParticles);

  {Configure fade out particle affector}
  //Dim as wColor4s fColor=(255,16,8,0)
  wParticleFadeOutAffectorSetColor(fadeAffector,wColor4sCreate(255,16,8,0));
  wParticleFadeOutAffectorSetTime(fadeAffector,2000);

  {Create attraction particle affector}
  attrAffector:=wParticleAttractionAffectorCreate(SmokeParticles,wVector3f_ZERO,2);

  {Configure attraction particle affector}
  wParticleAttractionAffectorGetParameters(attrAffector,@params2);
  params2.attract:=false;
  params2.affectX:=true;
  params2.affectY:=true;
  params2.affectZ:=true;
  wParticleAttractionAffectorSetParameters(attrAffector,params2);

  {Create camera}
  //Dim as wVector3f position=(20,0,0)
  Camera:=wCameraCreate(wVector3fCreate(20,0,0),wVECTOR3f_ZERO);

  {Hide mouse cursor}
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
         wWindowSetCaption(wndCaption+WStr(FormatFloat('0',prevFPS)));
    end;
  end;

  {Stop engine}
  wEngineStop(true);
end.

