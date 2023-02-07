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

program p01_HelloWorld;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  ModelMesh, StaticMesh: wMesh;
  DiffuseTexture, BumpTexture, BumpTexture2, currentBumpTexture: wTexture;
  material: wMaterial;
  SceneNodeNormal, OurCamera, Light, LightNode, LightNode2: wNode;
  animator, animator2: wAnimator;
  vec1: wVector3f;
  vect: wVector2f;
  vect1, vect2: wVector2i;
  font: wFont;
  comboNormalSelect, comboMaterialSelect: wGuiObject;


begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(fontPath);

  {Load resources}
  MyFont:=wFontLoad(fontPath);

  {Show engine logo}
  wEngineShowLogo(true);

  {Main loop}
  while wEngineRunning() do

  begin

    wSceneBegin(sceneColor);

    {Draw text}
    fromPos.y:=80; toPos.y:=96;
    wFontDraw(MyFont,('Hello, World!'),fromPos,toPos,wCOLOR4s_WHITE);

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

