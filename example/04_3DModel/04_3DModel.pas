// ----------------------------------------------------------------------------
// Пример сделал Vuvk
// Адаптировал Nikolas (WorldSim3D developer)
// ----------------------------------------------------------------------------
// Пример 04: 3D модели - Меши и Ноды (узлы)
// Пример загружает модель в формате .x (directX) и добавляет её на сцену как Нод.
// Нод - это физический объект для добавления на сцену моделей, камер, света и т.д.
// ----------------------------------------------------------------------------
program p04_3DModel;

uses
  // Подключаем главную библиотеку движка
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  CharacterMesh:wMesh 		         =nil;
  MeshTexture:wTexture 		         =nil;
  FloorMesh:wMesh			 =nil;
  FloorTexture:wTexture	                 =nil;
  SceneNode:wNode			 =nil;
  FloorNode:wNode			 =nil;
  OurCamera:wNode			 =nil;
  BitmapFont:wFont			 =nil;

  vec:wVector3f;
  vec2:wVector3f;
  fromPos:wVector2i;
  toPos:wVector2i;

  mat:wMaterial 			 =nil;

  isOutline:Boolean		         =false;

  testColor:wColor4s;
  backColor:wColor4s                     =(alpha:255; red:15; green:25; blue:15);

  wndCaption:PWChar 		         ='Example 04: 3D Models - Meshes and Nodes fps: ';

  prevFPS:Int32 			 =0;

  i:Int32;

  fontPath:PChar                         ='Assets/Fonts/3.png';
  cMeshPath:PChar                        ='Assets/Models/Characters/Bioshock_dude/Bioshock dude.x';
  fMeshPath:PChar                        ='Assets/Models/Sci-fi_floor2.x';
  fTexPath:PChar                         ='Assets/Textures/Floor_2.jpg';
  mTexPath:PChar                         ='Assets/Models/Characters/Bioshock_dude/bioshock dude.png';

begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  testColor.alpha:=255;

  {Check resources}
  CheckFilePath(fontPath);
  CheckFilePath(cMeshPath);
  CheckFilePath(fMeshPath);
  CheckFilePath(fTexPath);
  CheckFilePath(mTexPath);

  {Load resources}
  BitmapFont:=wFontLoad(fontPath);
  CharacterMesh:=wMeshLoad(cMeshPath);
  MeshTexture:=wTextureLoad(mTexPath);
  FloorMesh:=wMeshLoad(fMeshPath);
  FloorTexture:=wTextureLoad(fTexPath);

  {Show engine logo}
  wEngineShowLogo(true);

  {Scene node}
  SceneNode:=wNodeCreateFromMesh( CharacterMesh );

  vec.x:=0.1; vec.y:=0.1; vec.z:=0.1;
  wNodeSetScale(SceneNode, vec);

  wNodeSetAnimationSpeed(SceneNode, 20 );

  mat:=wNodeGetMaterial(SceneNode,0);
  wMaterialSetTexture(mat,0,MeshTexture);
  wMaterialSetFlag(mat,wMF_LIGHTING,false);

  {Floor node}
  FloorNode:=wNodeCreateFromMesh( FloorMesh );
  vec.x:=0; vec.y:=-0.2; vec.z:=0;
  wNodeSetPosition( FloorNode, vec);

  for i:=0 To wNodeGetMaterialsCount(FloorNode)-1 do
      begin
      mat:=wNodeGetMaterial(FloorNode,i);
      wMaterialSetTexture(mat,0,FloorTexture);
      wMaterialSetType(mat,wMT_LIGHTMAP);
  end;

  {Camera}
  vec.x:=0; vec.y:=10; vec.z:=-10;
  vec2.x:=0; vec2.y:=5; vec2.z:=0;
  OurCamera:=wCameraCreate(vec,vec2);

  {Ambient scene color}
  wSceneSetAmbientLight(wCOLOR4f_WHITE);

  while wEngineRunning() do

  begin

    wSceneBegin(backColor);

    wSceneDrawAll();

    {Draw text info}
     fromPos.x:=270; fromPos.y:=20;
     toPos.x:=400; toPos.y:=36;
     wFontDraw ( BitmapFont, ('3D model with animation'), fromPos,toPos,wCOLOR4s_WHITE);

     fromPos.x:=100; fromPos.y:=40; toPos.x:=600; toPos.y:=70;
     wFontDraw ( BitmapFont, ('SPACE: ON/OFF outline mode  1...0: select color lines'),fromPos,toPos,wCOLOR4s_WHITE);

     fromPos.x:=190; fromPos.y:=520; toPos.x:=300; toPos.y:=536;
     wFontDraw ( BitmapFont, ('WorldSim3D supports the following formats:'),fromPos,toPos,wCOLOR4s_WHITE);

     fromPos.x:=25; fromPos.y:=540; toPos.x:=100; toPos.y:=556;
     wFontDraw ( BitmapFont, ('with bone-based (sceletal) or morph animations- x,ms3d,b3d,md2,md3,mdl'), fromPos,toPos,wCOLOR4s_WHITE);

     fromPos.x:=25; fromPos.y:=560; toPos.x:=400; toPos.y:=576;
     wFontDraw ( BitmapFont, ('without bone-based or morph animations - 3ds,obj,lwo,dae,stl and other'), fromPos,toPos,wCOLOR4s_WHITE);


     if(wInputIsKeyHit(wKC_SPACE)) then  isOutline:=not isOutline;

     if(isOutline) then OutlineNode(SceneNode,4,testColor);

     if(wInputIsKeyHit(wKC_KEY_1)) then testColor:=wCOLOR4s_RED;

     if(wInputIsKeyHit(wKC_KEY_2)) then testColor:=wCOLOR4s_GREEN;

     if(wInputIsKeyHit(wKC_KEY_3)) then testColor:=wCOLOR4s_BLUE;

     if(wInputIsKeyHit(wKC_KEY_4)) then testColor:=wCOLOR4s_WHITE;

     if(wInputIsKeyHit(wKC_KEY_5)) then testColor:=wCOLOR4s_BLACK;

     if(wInputIsKeyHit(wKC_KEY_6)) then testColor:=wCOLOR4s_YELLOW;

     if(wInputIsKeyHit(wKC_KEY_7)) then testColor:=wCOLOR4s_MAGENTA;

     if(wInputIsKeyHit(wKC_KEY_8)) then testColor:=wCOLOR4s_INDIGO;

     if(wInputIsKeyHit(wKC_KEY_9)) then testColor:=wCOLOR4s_GOLD;

     if(wInputIsKeyHit(wKC_KEY_0)) then testColor:=wCOLOR4s_SILVER;

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

