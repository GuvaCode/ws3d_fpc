{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas(WorldSim3D developer)
'' Адаптировал Vuvk
'' ----------------------------------------------------------------------------
'' Пример 07: Частицы
'' В примере создаётся система частиц, используя которую можно создвать самые
'' разные эффекты.
'' ----------------------------------------------------------------------------
}
program p07_ParticleSystem;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  ParticleTexture : wTexture;
  SmokeParticles : wNode;
  SmokeEmitter : wEmitter;
  SmokeEmitterInfo : wParticleEmitter;  
  params : wParticleAttractionAffector;

  fadeAffector,
  gravAffector,
  attrAffector,
  rotAffector : wAffector;

  material : wMaterial;

  vec1 : wVector3f;

  TestNode : wNode;
  Camera : wNode;
  colors : wColor4s = (alpha: 255; red: 200; green: 0; blue: 0);
                               
  wndCaption : PWChar = 'Example 07: Particle Systems ';
  i : Integer;
  prevFPS : Int32=0;

  fPath : PChar = 'Assets/Particles/ParticleGrey.bmp';

  minBox : wVector3f = (x : -7; y : 0; z : -7); 
  maxBox : wVector3f = (x :  7; y : 1; z :  7);

begin
  // -----------------------------------------------------------------------------
  // start the WorldSim3D interface
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,false,true,false) then
    begin
      PrintWithColor('wEngineStart() failed!', wCFC_RED, true);
      Halt;
    end;

  ///Show logo WS3D
  wEngineShowLogo(true);

  ///Check resources
  if (not CheckFilePath(fPath)) then
    Halt;

  ///Load resources
  ParticleTexture := wTextureLoad(fPath);

  ///Create test node
  testNode := wNodeCreateCube(10,false, colors);
  material := wNodeGetMaterial(testNode,0);
  wMaterialSetFlag(material,wMF_LIGHTING,false);
  wMaterialSetTexture(material,0,CreateColorTexture(255,50,0,0));

  ///Create particle system
  SmokeParticles := wParticleSystemCreate(false, wVECTOR3f_ZERO, wVECTOR3f_ZERO, wVECTOR3f_ONE);

  ///Configure particle node materials
  for i := 0 to wNodeGetMaterialsCount(SmokeParticles) - 1 do
    begin
      material := wNodeGetMaterial(SmokeParticles,i);
      wMaterialSetTexture(material,0,ParticleTexture);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
      wMaterialSetType(material,wMT_TRANSPARENT_ADD_COLOR);
    end;

  ///Configure emitter settings
  SmokeEmitterInfo.maxAnglesDegrees := 15;
  SmokeEmitterInfo.direction := to_wVector3f(0, 0.04, 0);
  SmokeEmitterInfo.lifeTimeMax := 2000;
  SmokeEmitterInfo.lifeTimeMin := 800;
  SmokeEmitterInfo.maxParticlesPerSecond := 200;
  SmokeEmitterInfo.minParticlesPerSecond := 80;
  SmokeEmitterInfo.maxStartSize.x := 15;       
  SmokeEmitterInfo.maxStartSize.y := 15;
  SmokeEmitterInfo.minStartSize.x := 5;
  SmokeEmitterInfo.minStartSize.y := 5;
  SmokeEmitterInfo.minStartColor := wCOLOR4s_WHITE;
  SmokeEmitterInfo.maxStartColor := wCOLOR4s_WHITE;

  ///create box particle emitter
  SmokeEmitter := wParticleBoxEmitterCreate(SmokeParticles);

  ///Configure box particle emitter
  wParticleBoxEmitterSetBox(SmokeEmitter,minBox,maxBox);
  wParticleEmitterSetParameters(SmokeEmitter,SmokeEmitterInfo);    

  ///Create fade out particle affector
  fadeAffector := wParticleFadeOutAffectorCreate(SmokeParticles);

  ///Configure fade out particle affector
  colors := to_wColor4s(255, 16, 8, 0);
  wParticleFadeOutAffectorSetColor(fadeAffector,colors);
  wParticleFadeOutAffectorSetTime(fadeAffector,2000);

  ///Create gravity particle affector
  gravAffector := wParticleGravityAffectorCreate(SmokeParticles);

  ///Configure gravity particle affector
  vec1 := to_wVector3f(0.05, 0.05, 0);
  wParticleGravityAffectorSetGravity(gravAffector,vec1);
  wParticleGravityAffectorSetTimeLost(gravAffector,1);

  ///Create attraction particle affector
  vec1 := to_wVector3f(10,0,0);
  attrAffector := wParticleAttractionAffectorCreate(SmokeParticles,vec1,20);

  ///Configure attraction particle affector
  wParticleAttractionAffectorGetParameters(attrAffector, @params);
  params.attract := false;
  params.affectX := true;
  params.affectY := true;
  params.affectZ := true;
  wParticleAttractionAffectorSetParameters(attrAffector,params);

  ///Create rotation particle affector
  rotAffector := wParticleRotationAffectorCreate(SmokeParticles);

  ///Configure rotation particle affector
  vec1 := to_wVector3f(0,-120,0);
  wParticleRotationAffectorSetSpeed(rotAffector,vec1);
  wParticleRotationAffectorSetPivot(rotAffector,wVECTOR3f_ZERO);

  ///Create camera
  Camera := wCameraCreate(to_wVector3f(100.0, 40.0, 0.0),
                          to_wVector3f(0.0,   40.0, 0.0));

  ///Hide mouse cursor
  wInputSetCursorVisible(false);

  // -----------------------------------------------------------------------------
  // while the WorldSim3D environment is still running
  while wEngineRunning do
    begin
      // clear the canvas to black to show the particles up better
      wSceneBegin(wCOLOR4s_BLACK);

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


