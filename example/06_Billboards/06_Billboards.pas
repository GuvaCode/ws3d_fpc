// ----------------------------------------------------------------------------
// Пример сделал Nikolas (WorldSim3D developer)
// Адаптировал Vuvk
// ----------------------------------------------------------------------------
// Пример 06: Билборды (Billboards)
// Пример демонстрирует использование билбордов. Билборд - это одиночный прямоугольный
// полигон, всегда обращённый к камере. Часто его ещё называют3D спрайтом.
// Используется для самых разных целей, например, хорошо подходит для использования
// в качестве сферических эффектов, к примеру, сияющих перемещающихся источников света.
// ----------------------------------------------------------------------------

program p06_Billboards;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  backColor : wColor4s = (alpha : 255; red : 240; green : 255; blue : 255);
  minPos, maxPos : wVector2i;

  wndCaption:PWChar='Example 06: Billboards ';
  prevFPS:Int32=0;

  Billboard : wNode;
  BillboardTexture : wTexture;
  param : wBillboardAxisParam;
  Camera : wNode;
  mat : wMaterial;

  position : wVector3f;
  size : wVector2f = (x : 120.0; y : 40.0);

  checkPitch, checkYaw, checkRoll : wGuiObject;
  i : Integer;

///Declare custom procedures
procedure CreateScene(_position : wVector3f);
var
  texFence, texTree, texGround : wTexture;
  uSize : wVector2u;
  fSize : wVector2f;
  format : wColorFormat;
  pitch : UInt32;
  b : wNode;
  pos : wVector3f;
  bParam : wBillboardAxisParam;
  i : Integer;

begin
    texFence  := wTextureLoad('Assets/Sprites/fence.png');
    texTree   := wTextureLoad('Assets/Sprites/tree.png');
    texGround := wTextureLoad('Assets/Textures/detailmap3.jpg');

    wTextureGetInformation(texFence, @uSize, @pitch, @format);

    fSize.x:=uSize.x;
    fSize.y:=uSize.y;
    pos.x := _position.x;
    pos.y := _position.y;
    pos.z := _position.z - fSize.x / 2;
    b := wBillboardCreate(pos, fSize);
    for i := 0 to wNodeGetMaterialsCount(b) - 1 do
      begin
        mat := wNodeGetMaterial(b,i);
        wMaterialSetTexture(mat,0,texFence);
        wMaterialSetFlag(mat,wMF_LIGHTING,false);
        wMaterialSetType(mat,wMT_TRANSPARENT_ALPHA_CHANNEL);
        wMaterialSetFlag(mat,wMF_BACK_FACE_CULLING,false);
      end;
    bParam := wBillboardGetEnabledAxis(b);
    bParam.isEnableRoll := false;
    wBillboardSetEnabledAxis(b, bParam);

    pos.x := _position.x;
    pos.y := _position.y;
    pos.z := _position.z + fSize.x / 2;
    b := wBillboardCreate(pos, fSize);
    for i := 0 to wNodeGetMaterialsCount(b) - 1 do
      begin
        mat := wNodeGetMaterial(b,i);
        wMaterialSetTexture(mat,0,texFence);
        wMaterialSetFlag(mat,wMF_LIGHTING,false);
        wMaterialSetType(mat,wMT_TRANSPARENT_ALPHA_CHANNEL);
        wMaterialSetFlag(mat,wMF_BACK_FACE_CULLING,false);
      end;
    bParam := wBillboardGetEnabledAxis(b);
    bParam.isEnableRoll := false;
    wBillboardSetEnabledAxis(b, bParam);

    pos.x := _position.x + fSize.x/2;
    pos.y := _position.y;
    pos.z := _position.z;
    b := wBillboardCreate(pos, fSize);
    for i := 0 to wNodeGetMaterialsCount(b) - 1 do
      begin
        mat := wNodeGetMaterial(b,i);
        wMaterialSetTexture(mat,0,texFence);
        wMaterialSetFlag(mat,wMF_LIGHTING,false);
        wMaterialSetType(mat,wMT_TRANSPARENT_ALPHA_CHANNEL);
        wMaterialSetFlag(mat,wMF_BACK_FACE_CULLING,false);
      end;
    bParam := wBillboardGetEnabledAxis(b);
    bParam.isEnablePitch := false;
    wBillboardSetEnabledAxis(b, bParam);

    pos.x := _position.x - fSize.x/2;
    pos.y := _position.y;
    pos.z := _position.z;
    b := wBillboardCreate(pos, fSize);
    for i := 0 to wNodeGetMaterialsCount(b) - 1 do
      begin
        mat := wNodeGetMaterial(b,i);
        wMaterialSetTexture(mat,0,texFence);
        wMaterialSetFlag(mat,wMF_LIGHTING,false);
        wMaterialSetType(mat,wMT_TRANSPARENT_ALPHA_CHANNEL);
        wMaterialSetFlag(mat,wMF_BACK_FACE_CULLING,false);
      end;
    bParam := wBillboardGetEnabledAxis(b);
    bParam.isEnablePitch := false;
    wBillboardSetEnabledAxis(b, bParam);

    ///ground
    pos.x := _position.x;
    pos.y := _position.y - fSize.y/2;
    pos.z := _position.z;
    fSize.x:=uSize.x;
    fSize.y:=uSize.x;
    b := wBillboardCreate(pos, fSize);
    for i := 0 to wNodeGetMaterialsCount(b) - 1 do
      begin
        mat := wNodeGetMaterial(b,i);
        wMaterialSetTexture(mat,0,texGround);
        wMaterialSetFlag(mat,wMF_LIGHTING,false);
        wMaterialSetType(mat,wMT_TRANSPARENT_ALPHA_CHANNEL);
        wMaterialSetFlag(mat,wMF_BACK_FACE_CULLING,false);
      end;
    bParam := wBillboardGetEnabledAxis(b);
    bParam.isEnableYaw := false;
    wBillboardSetEnabledAxis(b, bParam);

    pos.x := _position.x;
    pos.y := _position.y + 28;
    pos.z := _position.z;
    fSize.x := 48; fSize.y := 128;
    b := wBillboardCreate(pos, fSize);
    for i := 0 to wNodeGetMaterialsCount(b) - 1 do
      begin
        mat := wNodeGetMaterial(b,i);
        wMaterialSetTexture(mat,0,texTree);
        wMaterialSetFlag(mat,wMF_LIGHTING,false);
        wMaterialSetType(mat,wMT_TRANSPARENT_ALPHA_CHANNEL);
        wMaterialSetFlag(mat,wMF_ZWRITE_ENABLE,true);
        wMaterialSetFlag(mat,wMF_BACK_FACE_CULLING,false);
      end;
    bParam := wBillboardGetEnabledAxis(b);
    bParam.isEnablePitch := false;
    bParam.isEnableRoll := false;
    wBillboardSetEnabledAxis(b,bParam);
end;

const fPath = '../../Assets/Textures/WS3D_Logo.png';

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  wEngineSetTransparentZWrite(true);

  ///Load resources
  BillboardTexture := wTextureLoad(fPath);

  ///Create billboard
  position := wVECTOR3f_ZERO;
  Billboard := wBillboardCreate(position, size);
  param := wBillboardGetEnabledAxis(Billboard);

  for i := 0 to wNodeGetMaterialsCount(Billboard) - 1 do
    begin
      mat := wNodeGetMaterial(Billboard, i);
      wMaterialSetTexture(mat, 0, BillboardTexture);
      wMaterialSetFlag(mat, wMF_LIGHTING, false);
      wMaterialSetType(mat, wMT_TRANSPARENT_ALPHA_CHANNEL);
    end;

  Camera:=wFpsCameraCreate(100,0.1,@wKeyMapDefault[0],8,false,0);

  position.z -= 100;
  wNodeSetPosition(Camera, position);

  wInputSetCursorVisible(false);

  ///Hide mouse cursor
  wInputSetCursorVisible(false);

  minPos.x := wDEFAULT_SCREENSIZE.x - 100;
  minPos.y := wDEFAULT_SCREENSIZE.y shr 1;
  maxPos.x := wDEFAULT_SCREENSIZE.x - 10;
  maxPos.y := wDEFAULT_SCREENSIZE.y shr 1 + 30;
  checkPitch := wGuiCheckBoxCreate('P I T C H (X)', minPos, maxPos, true);

  minPos.y := wDEFAULT_SCREENSIZE.y shr 1 + 40;
  maxPos.y := wDEFAULT_SCREENSIZE.y shr 1 + 70;
  checkYaw := wGuiCheckBoxCreate('Y A W   (Y)', minPos, maxPos, true);

  minPos.y := wDEFAULT_SCREENSIZE.y shr 1 + 80;
  maxPos.y := wDEFAULT_SCREENSIZE.y shr 1 + 110;
  checkRoll := wGuiCheckBoxCreate('R O L L  (Z)', minPos, maxPos, true);

  CreateScene(to_wVector3f(0, 0, 200));

  {Main loop}
  while wEngineRunning() do
    begin
      wSceneBegin(backColor);

      wSceneDrawAll();

      w3dDrawLine(wVECTOR3f_ZERO, to_wVector3f(100, 0, 0), wCOLOR4s_RED);
      w3dDrawLine(wVECTOR3f_ZERO, to_wVector3f(0, 100, 0), wCOLOR4s_GREEN);
      w3dDrawLine(wVECTOR3f_ZERO, to_wVector3f(0, 0, 100), wCOLOR4s_BLUE);

      wGuiDrawAll();

      minPos.x := wDEFAULT_SCREENSIZE.x shr 1 - 150;
      minPos.y := wDEFAULT_SCREENSIZE.y - 50;
      maxPos.x := wDEFAULT_SCREENSIZE.x shr 1 + 150;
      maxPos.y := wDEFAULT_SCREENSIZE.y - 10;
      wFontDraw(wFontGetDefault(), 'P R E S S    S P A C E   T O  C O N T R O L   S C E N E',
                                    minPos, maxPos,
                                    wCOLOR4s_DARKRED);

      if(wInputIsKeyHit(wKC_SPACE)) then
        begin
          wGuiObjectRemoveFocus(checkPitch);
          wGuiObjectRemoveFocus(checkYaw);
          wGuiObjectRemoveFocus(checkRoll);
          wInputSetCursorVisible(not wInputIsCursorVisible());
          wCameraSetInputEnabled(Camera, not wCameraIsInputEnabled(Camera));
        end;


      if (wInputIsMouseUp(wMB_LEFT)) then
        begin
          if(wGuiObjectIsHovered(checkPitch)) then
            begin
              param.isEnablePitch := wGuiCheckBoxIsChecked(checkPitch);
              wBillboardSetEnabledAxis(Billboard, param);
            end;

          if(wGuiObjectIsHovered(checkYaw)) then
            begin
              param.isEnableYaw := wGuiCheckBoxIsChecked(checkYaw);
              wBillboardSetEnabledAxis(Billboard,param);
            end;

          if (wGuiObjectIsHovered(checkRoll)) then
            begin
              param.isEnableRoll := wGuiCheckBoxIsChecked(checkRoll);
              wBillboardSetEnabledAxis(Billboard,param);
            end;
        end;

      wSceneEnd();

      ///Close by ESC
      wEngineCloseByEsc();

      {Update fps}
      if prevFPS<>wEngineGetFPS() then
         begin
           prevFPS := wEngineGetFPS();
           wWindowSetCaption(wndCaption+WStr(FormatFloat('0',prevFPS)));
         end;
    end;

    ///Stop engine
    wEngineStop(true);
end.


