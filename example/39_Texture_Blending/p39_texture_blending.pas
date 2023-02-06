// ----------------------------------------------------------------------------
// Пример сделал Nikolas(WorldSim3D developer)
// Адаптировал Tiranas
// ----------------------------------------------------------------------------
// Пример 39: Смешивание текстур (похож на пример 70, чем отличается?)
// Пример загружает пару текстур, а затем использует функцию для смешивания
// изображений в одну поверхность текстуры. Также они использует вункции для
// закрытия текстуры, чтобы получить поверхность текстуры и записать цвет в
// её поверхность.
// ----------------------------------------------------------------------------

program p39_Texture_Blending;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  TextureA, TextureB, TextureC, TextureD: wTexture;
  pixels: PUInt32;
  textureSize: wVector2i       	= (x:128; y:128);
  texturePositionL: wVector2i   = (x:0; y:0);

  wndCaption: wString   	= 'Example 39: Texture Blending ';
  texBPath: PChar               = 'Assets/Textures/Diagonal.bmp';
  texCPath: PChar               = 'Assets/Textures/Cross.bmp';

  prevFPS: Int32;
  i: Integer;

begin
  prevFPS:=0;
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Show engine logo}
  wEngineShowLogo(true);

  {Check resources}
  CheckFilePath(texBPath);
  CheckFilePath(texCPath);

  {Load resources}
  TextureB := wTextureLoad(texBPath);
  TextureC := wTextureLoad(texCPath);

  {Create two new blank texture surface and load two pattern images from file}
  TextureA := wTextureCreate('stripes', textureSize, wCF_A8R8G8B8);
  TextureD := wTextureCreate('merged', textureSize, wCF_A8R8G8B8);

  {Get the pixels of one of the textures and write blocks of color into the image}
   pixels := wTextureLock(TextureA);
   For i :=  0 To Trunc(textureSize.x*textureSize.y/4-1) - 1 do
   begin
       pixels^ := wUtilColor4sToUInt(wCOLOR4s_RED);
       pixels += 1
   end;

   For i :=  0 To Trunc(textureSize.x*textureSize.y/4-1) - 1 do
   begin
       pixels^ := wUtilColor4sToUInt(wCOLOR4s_GREEN);
       pixels += 1
   end;

   For i :=  0 To Trunc(textureSize.x*textureSize.y/4-1) - 1 do
   begin
       pixels^ := wUtilColor4sToUInt(wCOLOR4s_BLUE);
       pixels += 1
   end;

   For i :=  0 To Trunc(textureSize.x*textureSize.y/4-1) - 1 do
   begin
       pixels^ := wUtilColor4sToUInt(wCOLOR4s_BLACK);
       pixels += 1
   end;

   wTextureUnlock(TextureA);

   {Blend the two loaded textures onto the created surface}
   wTexturesSetBlendMode(TextureD, TextureB,wVECTOR2i_ZERO, wBO_ADD);
   wTexturesSetBlendMode(TextureD, TextureC, wVECTOR2i_ZERO, wBO_ADD);

   {Hide mouse cursor}
   wInputSetCursorVisible(false);

  {Main loop}
  while wEngineRunning() do

  begin
    wSceneBegin(wCOLOR4s_BLACK);

    wSceneDrawAll();

   // texturePosition:=wVECTOR2i_ZERO;
    wTextureDraw(TextureA,wVECTOR2i_ZERO,true,wCOLOR4s_WHITE);
    wTextureDraw(TextureB,wVector2iCreate(128,0),true,wCOLOR4s_WHITE);
    wTextureDraw(TextureC,wVector2iCreate(0,128),true,wCOLOR4s_WHITE);
    wTextureDraw(TextureD,wVector2iCreate(128,128),true,wCOLOR4s_WHITE);

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

