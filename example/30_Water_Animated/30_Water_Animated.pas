{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Vuvk
'' ----------------------------------------------------------------------------
'' Пример 30: Эффект анимированной воды
'' Пример создаёт эффект анимированной воды, применяемый к плоскому объекту
'' Hillplane. Эффект видоизменяет поверхность меша так, чтобы смоделировать
'' волны.
'' ----------------------------------------------------------------------------
}
program p30_Water_Animated;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  WaterMesh : wMesh;

  WaterTexture0,
  WaterTexture1 : wTexture;

  WaterNode,
  Camera : wNode;

  material : wMaterial;
  Font : wFont;

  vec1 : wVector3f;

  backColor : wColor4s = (alpha : 255; red : 240; green : 255; blue : 255);

  fromPos,
  toPos : wVector2i;

  tilesSize  : wVector2f = (x : 50; y: 50);
  tilesCount : wVector2i = (x : 128; y : 128);
  hillHeight : Single;
  hillCount  : wVector2f = (x : 4; y : 3);
  hillTexRepeat : wVector2f = (x : 4; y : 4);

  waveHeight : Single = 2;
  waveSpeed  : Single = 300;
  waveLength : Single = 90;

  texScale1  : wVector2f = (x : 15; y : 15);
  texScale2  : wVector2f = (x : 5;  y : 5);

  waterType : Int32;
  waterTranslate : wVector2f;

  texPath  : PChar = 'Assets/Textures/Water_2.jpg';
  texPath2 : PChar = 'Assets/Textures/stones.jpg';
  fontPath : PChar = 'Assets/Fonts/Cyr.xml';

  wndCaption : PWChar = 'Example 30: Animated Water Effect ';
  i : Integer;
  prevFPS : Int32=0;

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
  if (not CheckFilePath(texPath) or
      not CheckFilePath(texPath2) or
      not CheckFilePath(fontPath)) then
    exit;

  ///Load resources
  Font := wFontLoad(fontPath);
  WaterTexture0 := wTextureLoad(texPath);
  WaterTexture1 := wTextureLoad(texPath2);

  ///Create water mesh
  WaterMesh := wMeshCreateHillPlane('HillPlane',
                                    tilesSize,
                                    tilesCount,
                                    nil,
                                    hillHeight,
                                    hillCount,
                                    hillTexRepeat);

  ///Create water node
  WaterNode := wWaterSurfaceCreate(WaterMesh,
                                   waveHeight,
                                   waveSpeed,
                                   waveLength,
                                   wVECTOR3f_ZERO,
                                   wVECTOR3f_ZERO,
                                   wVECTOR3f_ONE);


  for i := 0 to wNodeGetMaterialsCount(WaterNode) - 1 do
    begin
      material := wNodeGetMaterial(WaterNode,i);
      wMaterialSetFlag(material,wMF_LIGHTING,false);
      wMaterialSetType(material,wMT_SPHERE_MAP);
      wMaterialSetTexture(material,0,WaterTexture0);
      wMaterialSetTexture(material,1,WaterTexture1);
      wMaterialSetTextureScale(material,1,texScale1);
    end;

  ///Create camera
  Camera := wFpsCameraCreate(100, 0.1, @wKeyMapDefault, Length(wKeyMapDefault));
  wNodeSetPosition(Camera, to_wVector3f(400,300,0));

  ///Hide mouse cursor
  wInputSetCursorVisible(false);

  fromPos := to_wVector2i(20,  550);
  toPos   := to_wVector2i(200, 600);

  // -----------------------------------------------------------------------------
  // while the WorldSim3D environment is still running
  while wEngineRunning do
    begin
      // clear the canvas to black to show the particles up better
      wSceneBegin(backColor);

      if (wInputIsKeyHit(wKC_SPACE)) then
        begin
          Inc(waterType);
          if (waterType > 2) then
            waterType := 0;

          case (waterType) of
            0:
              begin
                wMaterialSetType(material,wMT_SPHERE_MAP);
                wMaterialSetTexture(material,1,WaterTexture1);
                wMaterialSetTextureScale(material,1,texScale1);
              end;
            1:
              begin
                wMaterialSetType(material,wMT_REFLECTION_2_LAYER);
              end;
            2:
              begin
                wMaterialSetType(material,wMT_DETAIL_MAP);
                wMaterialSetTexture(material,1,WaterTexture0);
                wMaterialSetTextureScale(material,1,texScale2);
              end;
          end;
        end;

      if (waterType = 2) then
        begin
          waterTranslate.x += wTimerGetDelta()*0.1;
          waterTranslate.y += wTimerGetDelta()*0.1;
          wMaterialSetTextureTranslation(material,1,waterTranslate);
        end;

      // draw the scene
      wSceneDrawAll();

      wFontDraw(Font, 'Key SPACE- select water type', fromPos, toPos, wCOLOR4s_BLUE);

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


