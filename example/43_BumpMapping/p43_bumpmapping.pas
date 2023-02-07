{'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Tiranas
   паскаль адаптация: guvacode
'' ----------------------------------------------------------------------------
'' Пример 43: Бамп мэппинг (Bump Mapping)
'' Пример загружает модель, а затем накладывает на неё текстуру, используя
'' технику бамп мэппинга, которую называют Нормал мэппинг (Normal Mapping).
'' Этот эффект будет виден, если видеокарта поддерживает пиксельные и вершинные
'' шейдеры версии 1.1
'' ----------------------------------------------------------------------------}

program p43_BumpMapping;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

const ID_COMBO_NORMAL  =   0;
      ID_COMBO_MATERIAL =  1;

{Declare variables}
var
  ModelMesh, StaticMesh: wMesh;
  DiffuseTexture, BumpTexture, BumpTexture2, currentBumpTexture: wTexture;
  material: wMaterial;
  SceneNodeNormal, OurCamera, Light, LightNode, LightNode2, light2, light3: wNode;
  animator, animator2: wAnimator;
  vec1: wVector3f;
  vect: wVector2f;
  vect1, vect2, minPos, maxPos: wVector2i;
  font: wFont;
  comboNormalSelect, comboMaterialSelect: wGuiObject;

  amplitude: Float32               	=19.0;
  blur: Float32                     	=2.5;

  wndCaption: wString 			= 'Example 43: Bump Mapping ';

  prevFPS, idx: Int32;
  item1,item2, item3: Uint32;
  fontPath: PChar = 'Assets/Fonts/Cyr.xml';
  meshPath: PChar = 'Assets/Models/Mid_Age/House/House.obj';
  meshTexPath: PChar = 'Assets/Models/Mid_Age/House/HouseTex.tga';
  bumpTexPath: PChar = 'Assets/Models/Mid_Age/House/HouseNormal.tga';
  cam: boolean;
  i: integer;
  skin: wGuiObject;
  gColor: wColor4s;
  gEvent:PwGuiEvent;

  screenSize: wVector2u = (x: 800; y: 600);

begin
  {Show engine logo}
  wEngineShowLogo(true);

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(fontPath);
  CheckFilePath(meshPath);
  CheckFilePath(meshTexPath);
  CheckFilePath(bumpTexPath);

  {Load resources}
  ModelMesh:=wMeshLoad(meshPath);
  wMeshSetScale(ModelMesh, 12.5);

  StaticMesh:=wMeshCreateStaticWithTangents(ModelMesh);

  wMeshDestroy(ModelMesh);

  DiffuseTexture:=wTextureLoad(meshTexPath);

  BumpTexture2:=wTextureLoad(bumpTexPath);
  font:=wFontLoad(fontPath);

  {Create new texture for bump-effects...}
  BumpTexture := wTextureCopy(DiffuseTexture, 'bump');

  wTextureSetBlur(@BumpTexture, blur);

  //Convert the grey scale image into a normal mapping texture. if you wish you
  //can create your own normal mapping texture but it is often simpler to create
  //a simple greyscale image as a bump map that defines the height of the surface
  wTextureMakeNormalMap(BumpTexture, amplitude);
  wTextureSave(BumpTexture,'bump.jpg');

  {Create test node}
  SceneNodeNormal:=wNodeCreateFromStaticMesh(StaticMesh);

  // vec1.x=-70: vec1.y=0: vec1.z=-50
  wNodeSetPosition(SceneNodeNormal,wVector3fCreate(-70,0,-50));

  {Apply a material to the node to give its surface color}
  For i := 0 To wNodeGetMaterialsCount(SceneNodeNormal) - 1 do
  begin
      material:=wNodeGetMaterial(SceneNodeNormal,i);
      wMaterialSetTexture(material,0,DiffuseTexture);
      wMaterialSetTexture(material,1,BumpTexture2);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
      wMaterialSetType(material,wMT_NORMAL_MAP_SOLID);
      wMaterialSetTypeParameter(material,0.015625);
      wMaterialSetSpecularColor(material,wCOLOR4s_BLACK);
      wMaterialSetShininess(material,0.0);
  end;
  currentBumpTexture:=BumpTexture2;
  {Create camera}
  OurCamera := wFpsCameraCreate(100, 0.1, @wKeyMapDefault, 8, FALSE, 0);
  wCameraSetTarget (OurCamera,wVector3fCreate(-90,0,-40));

  //Finally we need to add a light into the scene. bump mapping requires a
  //dynamic light to create the bump mapping effect. additionally the lights need
  //to be animated to show the changing light on the surface.
  LightNode := wNodeCreateSphere(2.0, 16,false,wCOLOR4s_YELLOW);
  LightNode2 := wNodeCreateSphere(2.0, 16,false,wCOLOR4s_SKYBLUE);

  vec1:=wVector3fCreate(-90,0,-35);
  wNodeSetPosition (LightNode,vec1);
  wNodeSetPosition (LightNode2,vec1);

  material:=wNodeGetMaterial(LightNode,0);
  wMaterialSetFlag(material, wMF_LIGHTING, false);

  material:=wNodeGetMaterial(LightNode2,0);
  wMaterialSetFlag(material, wMF_LIGHTING, false);

  //Dim as wColor4f light2Color=(1.f,0.9f,0.9f,0.0f)
  //Dim as wNode
  light2:=wLightCreate(wVECTOR3f_ZERO,wColor4fCreate(1.0,0.9,0.9,0.0),150.0);
  wNodeSetParent(light2,LightNode);

  //light2Color.red=0.53f
  //light2Color.green=0.81f
  //light2Color.blue=0.92f

  //Dim as wNode
  light3:=wLightCreate(wVECTOR3f_ZERO,wColor4fCreate(1.0,0.53,0.81,0.92),150.0);
  wNodeSetParent(light3,LightNode2);


  vec1:=wVector3fCreate(-90,0,-35);
  animator:=wAnimatorFlyingCircleCreate(LightNode, vec1, 150.0, 0.0005, wVECTOR3f_UP,0.5,0);

  animator2:=wAnimatorFlyingCircleCreate(LightNode2, vec1, 150.0, 0.0005, wVECTOR3f_UP,0.5,0);

  {Create gui controls}
  //Dim as wGuiObject
  skin:=wGuiGetSkin();
  For i:= 0 To wGDF_COUNT - 1 do
      wGuiSkinSetFont(skin,font,i);

  For i:= 0 To wGDC_COUNT - 1  do
  begin
      gColor:=wGuiSkinGetColor(skin,i);
      gColor.alpha:=255;
      if i=wGDC_BUTTON_TEXT Then
          wGuiSkinSetColor(skin,i,wCOLOR4s_BLUE)
      else
          wGuiSkinSetColor(skin,i,gColor);
  end;

  minPos.x:=10; minPos.y:=500;
  maxPos.x:=270; maxPos.y:=520;
  comboNormalSelect:=wGuiComboBoxCreate(minPos,maxPos);
  item1:=wGuiComboBoxAddItem(comboNormalSelect,'Use loaded normal texture',0);
  item2:=wGuiComboBoxAddItem(comboNormalSelect,'Use generated normal texture',0);
  wGuiComboBoxSetSelected(comboNormalSelect,item1);
  wGuiObjectSetId(comboNormalSelect,ID_COMBO_NORMAL);

  minPos.x+=350;
  maxPos.x+=350;
  comboMaterialSelect:=wGuiComboBoxCreate(minPos,maxPos);
  item1:=wGuiComboBoxAddItem(comboMaterialSelect,'wMT_SOLID',0);
  item2:=wGuiComboBoxAddItem(comboMaterialSelect,'wMT_NORMAL_MAP_SOLID',0);
  item3:=wGuiComboBoxAddItem(comboMaterialSelect,'wMT_PARALLAX_MAP_SOLID',0);

  wGuiComboBoxSetSelected(comboMaterialSelect,item2);
  wGuiObjectSetId(comboMaterialSelect,ID_COMBO_MATERIAL);

  {Hide mouse curso}
  wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do
  begin
    wSceneBegin(wColor4sCreate(255,100,120,120));

    if wInputIsMouseHit(wMB_RIGHT) Then
    begin
      wGuiObjectRemoveFocus(comboNormalSelect);
      cam:=wCameraIsInputEnabled(OurCamera);
      wCameraSetInputEnabled(OurCamera, Not cam);
      wInputSetCursorVisible(cam);
    end;

    if(wGuiIsEventAvailable()) Then gEvent:=wGuiReadEvent();

    if gEvent^.event = wGCT_COMBO_BOX_CHANGED then
    begin
      //Select Case (gEvent->id)
      Case gEvent^.id of
        ID_COMBO_NORMAL:
        begin
          idx:=wGuiComboBoxGetSelected(comboNormalSelect);
          For i:= 0 To wNodeGetMaterialsCount(SceneNodeNormal) - 1 do
          begin
            material:=wNodeGetMaterial(SceneNodeNormal,i);
            if idx=0 Then
            wMaterialSetTexture(material,1,BumpTexture2)
            else
            wMaterialSetTexture(material,1,BumpTexture);
          end;
          if idx=0 Then
          currentBumpTexture:=BumpTexture2
          else
          currentBumpTexture:=BumpTexture;
        end;
        ID_COMBO_MATERIAL:
        begin
          idx:=wGuiComboBoxGetSelected(comboMaterialSelect);
          Case idx of
          0://solid
            For i:= 0 To wNodeGetMaterialsCount(SceneNodeNormal) - 1 do
             begin
              material:=wNodeGetMaterial(SceneNodeNormal,i);
              wMaterialSetType(material,wMT_SOLID);
             end;

          1://normal map
            For i:= 0 To wNodeGetMaterialsCount(SceneNodeNormal) - 1 do
            begin
              material:=wNodeGetMaterial(SceneNodeNormal,i);
              wMaterialSetType(material,wMT_NORMAL_MAP_SOLID);
            end;

          2:
            For i:= 0 To wNodeGetMaterialsCount(SceneNodeNormal) - 1 do
            begin
              material:=wNodeGetMaterial(SceneNodeNormal,i);
              wMaterialSetType(material,wMT_PARALLAX_MAP_SOLID);
            end;
          end;
        end;
      end;
    end;

    wSceneDrawAll();
    wGuiDrawAll();

    vect.x:=0.1*1.5; vect.y:=0.1*1.5;
    wTextureDrawEx(currentBumpTexture,wVECTOR2i_ZERO,vect,true);


    vect1.x:=30;
    vect1.y:=screenSize.y-30;
    vect2.x:=screenSize.x div 2 +100;
    vect2.y:=screenSize.y-10;
    wFontDraw(font,'Click Right Mouse to control scene',vect1, vect2, wCOLOR4s_YELLOW);

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

