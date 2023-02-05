program p27_Particle_Emitters_Dynamic;
// Этот пример надо переписать
{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  ParticleTexture: wTexture;
  TowerTexture: wTexture;
  TowerMesh:wMesh;
  TowerNode: wNode;
  SmokeParticles: wNode;
  SmokeEmitter: wEmitter;
  SmokeEmitterInfo: wParticleEmitter;
  fadeAffector:wAffector;
  gravAffector:wAffector;
  vec1: wVector3f;
  gravity: wVector3f;
  material: wMaterial;
  Camera:wNode;
  frame: Int32;
  fade	:UInt32				                        =1000;
  min_red: UInt32						=255;
  min_blue:UInt32						=128;
  max_red:UInt32						=255;
  max_blue:UInt32						=192;
  burn:Int32							=1;
  gravZ:Float32				          	=0.02;
  BitmapFont: wFont;
  wndCaption: wString 			='Example 27: Dynamic Particle System Effects ';
  prevFPS:Int32;
  fPath:PChar='Assets/Particles/ParticleGrey.bmp';
  meshPath:PChar='Assets/Models/Mid_Age/Towers/tower02.x' ;
  texPath:PChar='Assets/Models/Mid_Age/Towers/tower 2.png';
  fontPath:PChar='Assets/Fonts/3.png';
  i: integer;

begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;
 {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(fPath);
  CheckFilePath(fontPath);
  CheckFilePath(meshPath);
  CheckFilePath(texPath);

  {Load resources}
  ParticleTexture:=wTextureLoad(fPath);
  TowerMesh:=wMeshLoad(meshPath);
  TowerTexture:=wTextureLoad(texPath);
  BitmapFont:=wFontLoad(fontPath);

   // Create test node
   TowerNode:=wNodeCreateFromMesh(TowerMesh);
   for i:=0 to wNodeGetMaterialsCount(TowerNode)-1 do
   begin
       material:=wNodeGetMaterial(TowerNode,i);
       wMaterialSetFlag(material,wMF_LIGHTING,false);
       wMaterialSetTexture(material,0,TowerTexture);
   end;

   vec1.x:=0.05; vec1.y:=0.05; vec1.z:=0.05;
   wNodeSetScale(TowerNode,vec1);

   // Create particle system
   SmokeParticles:=wParticleSystemCreate(false,wVECTOR3f_ZERO,wVECTOR3f_ZERO,wVECTOR3f_ONE);

   vec1.x:=0; vec1.y:=20; vec1.z:=0;
   wNodeSetPosition(SmokeParticles,vec1);

   // Configure particle node materials
    for i:=0 to wNodeGetMaterialsCount(SmokeParticles)-1 do
    begin
        material:=wNodeGetMaterial(SmokeParticles,i);
        wMaterialSetTexture(material,0,ParticleTexture);
        wMaterialSetFlag(material,wMF_LIGHTING,false);
        wMaterialSetType(material,wMT_TRANSPARENT_ADD_COLOR);
    end;

    // Configure emitter settings
    SmokeEmitterInfo.maxAnglesDegrees:=15;
    SmokeEmitterInfo.direction:=wVector3fCreate(0,0.06,0.01);

    SmokeEmitterInfo.lifeTimeMax:=1000;
    SmokeEmitterInfo.lifeTimeMin:=500;

    SmokeEmitterInfo.maxParticlesPerSecond:=500;
    SmokeEmitterInfo.minParticlesPerSecond:=250;

    SmokeEmitterInfo.maxStartSize:=wVector2fCreate(10,10);
    SmokeEmitterInfo.minStartSize:=wVector2fCreate(3,3);

    SmokeEmitterInfo.minStartColor:=wColor4sCreate(255,255,192,128);
    SmokeEmitterInfo.maxStartColor:=wColor4sCreate(255,255,192,192);

    // create box particle emitter
    SmokeEmitter:=wParticleBoxEmitterCreate(SmokeParticles);

    // Configure box particle emitter
    wParticleBoxEmitterSetBox(SmokeEmitter,wVector3fCreate(-7,0,-7),wVector3fCreate(7,1,7));
    wParticleEmitterSetParameters(SmokeEmitter,SmokeEmitterInfo);

    // Create fade out particle affector
    fadeAffector:=wParticleFadeOutAffectorCreate(SmokeParticles);

    // Configure fade out particle affector
    wParticleFadeOutAffectorSetColor(fadeAffector,wColor4sCreate(255,16,8,0));
    wParticleFadeOutAffectorSetTime(fadeAffector,1000);

    // Create gravity particle affector
    gravAffector:=wParticleGravityAffectorCreate(SmokeParticles);

    // Configure gravity particle affector
    gravity:= wVector3fCreate(0,0.1,0);
    wParticleGravityAffectorSetGravity(gravAffector,gravity);
    wParticleGravityAffectorSetTimeLost(gravAffector,1);

    // Create camera
    vec1:=wVector3fCreate(40,20,0);
    Camera:=wCameraCreate(vec1,wVECTOR3f_ZERO);

    vec1:=wVector3fCreate(0,23,0);
    wCameraSetTarget(Camera,vec1);

    // Hide mouse cursor
    wInputSetCursorVisible(false);

   frame:=0;
   prevFPS:=0;

  {Main loop}
  while wEngineRunning() do

  begin
       wSceneBegin(wCOLOR4s_BLACK);
      // count the frames
      frame += 1;
      // only perform this operation once every ten frames
      if frame = 10  then
      begin
          // reset our frame counter
          frame := 0;

          // if we are burning
          if burn = 1 then
          begin
              // make the flame more intense and blue
              min_red -= 1;
              min_blue += 1;
              max_red -= 1;
              max_blue += 1;
              fade += 100;
              gravZ += 0.001;

              // change the color range
              SmokeEmitterInfo.minStartColor.red:=min_red;
              SmokeEmitterInfo.minStartColor.blue:=min_blue;
              SmokeEmitterInfo.maxStartColor.red:=max_red;
              SmokeEmitterInfo.maxStartColor.blue:=max_blue;
              wParticleEmitterSetParameters(SmokeEmitter,SmokeEmitterInfo);

              // change the strength of the gravity effect
              gravity.x:=0;
              gravity.y:=0.1;
              gravity.z:=gravZ;
              wParticleGravityAffectorSetGravity(gravAffector,gravity);

      	      //change the time over which the particles fade out
      	      wParticleFadeOutAffectorSetTime(fadeAffector,fade);

            //if we are at maxiumum values then stop burning
            if max_blue > 254 then burn := 0;
          end
          else
          begin
              // we are not burning, make the flame smaller and more red
              min_red += 1;
              min_blue -= 1;
              max_red += 1;
              max_blue -= 1;
              fade -= 100;
              gravZ -= 0.001;

              // change the color range
              SmokeEmitterInfo.minStartColor.red:=min_red;
              SmokeEmitterInfo.minStartColor.blue:=min_blue;
              SmokeEmitterInfo.maxStartColor.red:=max_red;
              SmokeEmitterInfo.maxStartColor.blue:=max_blue;
              wParticleEmitterSetParameters(SmokeEmitter,SmokeEmitterInfo);

              // change the strength of the gravity effect
              gravity.x:=0;
              gravity.y:=0.1;
              gravity.z:=gravZ;
              wParticleGravityAffectorSetGravity(gravAffector,gravity);

      	      // change the time over which the particles fade out
      	      wParticleFadeOutAffectorSetTime(fadeAffector,fade);

              // if we are at minimum values then start burning again
              if max_blue < 193 then burn := 1;
          end;
       end;

      wFontDraw( BitmapFont, 'Note that the flames flare up at one moment, die out at the next',
      wVector2iCreate(70,20),wVector2iCreate(400,36), wCOLOR4s_WHITE);

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

