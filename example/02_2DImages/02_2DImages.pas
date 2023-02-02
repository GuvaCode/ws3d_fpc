// ----------------------------------------------------------------------------
// Пример сделал Vuvk
// Адаптировал Nikolas (WorldSim3D developer)
// ----------------------------------------------------------------------------
// Пример 02: 2D изображения (спрайты)
// Пример загружает несколько 2D изображений и использует их для функций отрисовки
// графики (в данном примере спрайтов) на экране.
// ----------------------------------------------------------------------------
program p02_2DImages;

uses
  // Подключаем главную библиотеку движка
  SysUtils,
  WorldSim3D,
  SampleFunctions;

const
   GUI_SCROLLBAR_ALPHA  	         =101;
   GUI_SCROLLBAR_RED    	         =102;
   GUI_SCROLLBAR_GREEN  	         =103;
   GUI_SCROLLBAR_BLUE   	         =104;
var
  Planet:wTexture			;
  Alien_face:wTexture		        ;
  Crosshair:wTexture		        ;
  Power_icon:wTexture		        ;
  Teleport_icon:wTexture	        ;
  Worldsim3d_logo:wTexture	        ;

  myFont:wFont				;

  GUIEvent:PwGuiEvent	                ;
  skin:wGuiObject                       ;
  labelAlpha:wGuiObject                 ;
  labelRed:wGuiObject                   ;
  labelGreen:wGuiObject                 ;
  labelBlue:wGuiObject                  ;
  scroll_alpha:wGuiObject               ;
  scroll_red:wGuiObject                 ;
  scroll_green:wGuiObject               ;
  scroll_blue:wGuiObject                ;

  color1:wColor4s;
  fromPos,toPos,tempVec:wVector2i;

  rotation:Float32;

  wndCaption:PWChar='Example 02: 2D Images / Sprites fps: ';
  prevFPS:Int32=0;

  texPath:PChar='Assets/Sprites/planet_1.png';
  texPath2:PChar='Assets/Sprites/Face_alien.png';
  texPath3:PChar='Assets/Sprites/powered_by.png';
  texPath4:PChar='Assets/Sprites/power.png';
  texPath5:PChar='Assets/Sprites/teleport.png';
  texPath6:PChar='Assets/Sprites/WS3D_Logo.png';
  fontPath:PChar='Assets/Fonts/Cyr.xml';

begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(texPath);
  CheckFilePath(texPath2);
  CheckFilePath(texPath3);
  CheckFilePath(texPath4);
  CheckFilePath(texPath5);
  CheckFilePath(texPath6);
  CheckFilePath(fontPath);

  {Load resources}
  Planet:= wTextureLoad(texPath);
  Alien_face:= wTextureLoad(texPath2);
  Crosshair:= wTextureLoad(texPath3);
  Power_icon:= wTextureLoad(texPath4);
  Teleport_icon:= wTextureLoad(texPath5);
  Worldsim3d_logo:= wTextureLoad(texPath6);

  myFont:=wFontLoad(fontPath);
  skin:=wGuiGetSkin();
  {Gui skin configure}
  wGuiSkinSetFont(skin,myFont);
  color1.alpha:=255;
  color1.red:=100;
  color1.green:=0;
  color1.blue:=0;
  wGuiSkinSetColor(skin,wGDC_SCROLLBAR, color1);

  color1.alpha:=255;
  color1.red:=100;
  color1.green:=100;
  wGuiSkinSetColor(skin,wGDC_BUTTON_TEXT, color1);

  {Gui objects create}
  fromPos.x:=10;fromPos.y:=250; toPos.x:=50; toPos.y:=280;
  labelAlpha:=wGuiLabelCreate(PWStr('A'),fromPos,toPos);

  fromPos.x:=50; fromPos.y:=250; toPos.x:=300; toPos.y:=265;
  scroll_alpha:=wGuiScrollBarCreate(true,fromPos,toPos);
  wGuiScrollBarSetMaxValue(scroll_alpha,255);
  wGuiScrollBarSetValue(scroll_alpha,255);
  wGuiObjectSetId(scroll_alpha,GUI_SCROLLBAR_ALPHA);

  fromPos.x:=10; fromPos.y:=280; toPos.x:=50; toPos.y:=310;
  labelRed:=wGuiLabelCreate(PWStr('R'),fromPos,toPos);

  fromPos.x:=50; fromPos.y:=280; toPos.x:=300; toPos.y:=295;
  scroll_red:=wGuiScrollBarCreate(true,fromPos,toPos);
  wGuiScrollBarSetMaxValue(scroll_red,255);
  wGuiScrollBarSetValue(scroll_red,255);
  wGuiObjectSetId(scroll_red,GUI_SCROLLBAR_RED);

  fromPos.x:=10; fromPos.y:=310; toPos.x:=50; toPos.y:=340;
  labelGreen:=wGuiLabelCreate(PWStr('G'),fromPos,toPos);

  fromPos.x:=50; fromPos.y:=310; toPos.x:=300; toPos.y:=325;
  scroll_green:=wGuiScrollBarCreate(true,fromPos,toPos);
  wGuiScrollBarSetMaxValue(scroll_green,255);
  wGuiScrollBarSetValue(scroll_green,255);
  wGuiObjectSetId(scroll_green,GUI_SCROLLBAR_GREEN);

  fromPos.x:=10; fromPos.y:=340; toPos.x:=50; toPos.y:=370;
  labelBlue:=wGuiLabelCreate(PWStr('B'),fromPos,toPos);

  fromPos.x:=50; fromPos.y:=340; toPos.x:=300; toPos.y:=355;
  scroll_blue:=wGuiScrollBarCreate(true,fromPos,toPos);
  wGuiScrollBarSetMaxValue(scroll_blue,255);
  wGuiScrollBarSetValue(scroll_blue,255);
  wGuiObjectSetId(scroll_blue,GUI_SCROLLBAR_BLUE);

  color1.alpha:=255; color1.red:=255; color1.green:=255; color1.blue:=255;

  wEngineShowLogo(true);

  while wEngineRunning() do

  begin

    wSceneBegin(wCOLOR4s_BLACK);

    {Draw images}
    fromPos.x:=4; fromPos.y:=4;
    wTextureDraw(Alien_face,fromPos,true,color1);

    rotation-=0.1;
    fromPos.x:=640; fromPos.y:=140;
    toPos.x:=640+64; toPos.y:=140+64;
    wTextureDrawAdvanced(Planet,fromPos,toPos,rotation,wVECTOR2f_ONE,true,color1);

    tempVec.x:=370; tempVec.y:=270;
    fromPos.x:=0; fromPos.y:=0;
    toPos.x:=94; toPos.y:=94;
    wTextureDrawElement(Crosshair,tempVec,fromPos,toPos,true,color1);

    tempVec.x:=10; tempVec.y:=550;
    fromPos.x:=0; fromPos.y:=0;
    toPos.x:=192; toPos.y:=32;
    wTextureDrawElement(Power_icon,tempVec,fromPos,toPos,true,color1);

    tempVec.x:=690; tempVec.y:=548;
    fromPos.x:=0; fromPos.y:=0;
    toPos.x:=95; toPos.y:=32;
    wTextureDrawElement(Teleport_icon,tempVec,fromPos,toPos,true,color1);

    tempVec.x:=270; tempVec.y:=130;
    fromPos.x:=0; fromPos.y:=0;
    toPos.x:=400; toPos.y:=67;
    wTextureDrawElement(Worldsim3d_logo,tempVec,fromPos,toPos,true,color1);

    wGuiDrawAll();

    {Gui events}
    If wGuiIsEventAvailable() Then
       begin
       GUIEvent:=wGuiReadEvent();

       if GUIEvent^.event=wGCT_SCROLL_BAR_CHANGED then
          begin
          Case GUIEvent^.id of
          	GUI_SCROLLBAR_ALPHA:
                     color1.alpha:=wGuiScrollBarGetValue(scroll_alpha);
          	GUI_SCROLLBAR_BLUE:
                     color1.blue:=wGuiScrollBarGetValue(scroll_blue);
          	GUI_SCROLLBAR_GREEN:
                     color1.green:=wGuiScrollBarGetValue(scroll_green);
          	GUI_SCROLLBAR_RED:
                     color1.red:=wGuiScrollBarGetValue(scroll_red);
          end;
       end;
    end;

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

