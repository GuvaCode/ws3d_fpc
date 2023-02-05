// ----------------------------------------------------------------------------
// Пример сделал Vuvk
// Адаптировал Nikolas (WorldSim3D developer)
// ----------------------------------------------------------------------------
// Пример 03: Шрифты Bitmap (.bmp)
// В этом примере для отображения текста на экране используется шрифт, основанный
// на bitmap. Также можно использовать для этой цели формат .png
// ----------------------------------------------------------------------------
program p03_BitmapFont;

uses
  // Подключаем главную библиотеку движка
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  BitmapFont:wFont			=nil;
  BitmapFont_2:wFont		        =nil;
  BitmapFont_3:wFont		        =nil;
  BitmapFont_Cyrillic:wFont             =nil;

  fromPos:wVector2i 		        =(x:120;y:0);
  toPos:wVector2i 			=(x:250;y:0);

  textColor:wColor4s 		        =(alpha:255; red:255; green:255; blue:255);

  wndCaption:PWChar 		        ='Example 03: Bitmap Fonts fps: ';

  prevFPS:Int32                         =0;

  fontPath:PChar                        ='Assets/Fonts/thunder16.png';
  fontPath2:PChar                       ='Assets/Fonts/myfont4.png';
  fontPath3:PChar                       ='Assets/Fonts/papyrus_bold.png';
  fontPath4:PChar                       ='Assets/Fonts/Cyr.xml';
  str:WideChar;
begin

  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  {Check resources}
  CheckFilePath(fontPath);
  CheckFilePath(fontPath2);
  CheckFilePath(fontPath3);
  CheckFilePath(fontPath4);

  {Load resources}
  BitmapFont:= wFontLoad(fontPath);
  BitmapFont_2:= wFontLoad(fontPath2);
  BitmapFont_3:= wFontLoad(fontPath3);
  BitmapFont_Cyrillic:= wFontLoad(fontPath4);

  wEngineShowLogo(true);

  while wEngineRunning() do

  begin

    wSceneBegin(wCOLOR4s_BLACK);

    fromPos.y:=70; toPos.y:=86;
    textColor.red:=255; textColor.green:=0; textColor.blue:=0;
    wFontDraw ( BitmapFont, ('I''ll be back!'), fromPos,toPos,textColor);

   fromPos.y:=100; toPos.y:=116;
    textColor.red:=0; textColor.green:=255; textColor.blue:=0;
    wFontDraw ( BitmapFont_2, ('WorldSim3D'), fromPos,toPos,textColor);

    fromPos.y:=130; toPos.y:=146;
    textColor.red:=0; textColor.green:=0; textColor.blue:=255;
    wFontDraw ( BitmapFont_3, ('Game Over'), fromPos,toPos,textColor);


    //Str:= Utf8ToAnsi('У меня получится сделать игру мечты!');

    fromPos.y:=170; toPos.y:=186;
    textColor.red:=0; textColor.green:=255; textColor.blue:=255;
    wFontDraw ( BitmapFont_Cyrillic, ('У меня получится сделать игру мечты!'), fromPos, toPos, textColor);

    wSceneEnd();

    wEngineCloseByEsc();

    if prevFPS<>wEngineGetFPS() then
       begin
         //prevFPS:=wEngineGetFPS();
        // wWindowSetCaption(wndCaption+WStr(FormatFloat('0',prevFPS)));
    end;

  end;

  wEngineStop(true);
end.

