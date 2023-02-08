{// ----------------------------------------------------------------------------
'// Пример сделал Nikolas (WorldSim3D developer)
'// Адаптировал Tiranas
'// ----------------------------------------------------------------------------
'// Пример 44: Управление ресурсами тексур
'// Пример показывает как можно управлять ресурсом текстур. Когда загружено много
'// текстур, их можно удалить, если они больше не нужны. Это помогает освобождать
'// память.
'// ----------------------------------------------------------------------------}

program p44_Resources_Managing;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

{Declare variables}
var
  WS3D_Logo, default_texture, NewWS3D_Logo: wTexture;
  wndCaption: wString = 'Example 44: Managing texture resources ';

  texPath1: pChar = 'Assets/Textures/WS3D_Logo.png';
  texPath2: pChar = 'Assets/Textures/default_texture.png';
  texPath3: pChar = 'Assets/Textures/WS3D_Logo.png';

  oldConsoleColors: Int32;

begin
  {Start engine}
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
     Halt;

  wWindowSetCaption(wndCaption);

  {Check resources}
  CheckFilePath(texPath1);
  CheckFilePath(texPath2);
  CheckFilePath(texPath3);

  {Configure console colors}
  oldConsoleColors:=wConsoleSaveDefaultColors();
  wConsoleSetFontColor(wCFC_LIGHTGREEN);

  writeln('-----------------------------------------------------------------------');
  {Load resources}
  WS3D_Logo:=wTextureLoad(texPath1);
  writeln ('The address of the WorldSim3D Logo is ' , IntToStr(WS3D_Logo^));

  {Remove the texture}
  wConsoleSetFontColor(wCFC_LIGHTRED);
  writeln('-----------------------------------------------------------------------');
  wTextureDestroy(WS3D_Logo);
  writeln('The WS3D_Logo has been removed');

  {Load a new texture}
  wConsoleResetColors(oldConsoleColors);
  writeln('-----------------------------------------------------------------------');
  default_texture := wTextureLoad(texPath2);
  writeln('-----------------------------------------------------------------------');
  writeln( 'The address of the default texture is ', IntToStr(default_texture^));

  {If the two images were in the same memory space notify the user}
  if (WS3D_Logo = default_texture) Then
  begin
    writeln('-----------------------------------------------------------------------');
    writeln('NOTICE: The address of the WorldSim3D and default texture''s are the same');
    writeln('this is because WS3D_Logo was removed and the memory was reused for');
    writeln('the default_texture. If this was a large texture the saving could be huge');
  end;

  {Reload the first image again}
  writeln('-----------------------------------------------------------------------');
  NewWS3D_Logo := wTextureLoad(texPath3);
  writeln ('The new address of the WorldSim3D Logo is ', IntToStr(NewWS3D_Logo^));

  {If the image is in a different location to where it was before display a message}
  if (WS3D_Logo <> NewWS3D_Logo) Then
  begin
      writeln('-----------------------------------------------------------------------');
      writeln('NOTICE: The address of the two WorldSim3D logo''s are different');
      writeln('this is because WS3D_Logo was removed and the memory was reused for');
      writeln('the default_texture. Now we have loaded it again it is in a different place');
  End;

  {Stop the WorldSim3D engine and release resources}
  wEngineStop(true);

  {Suspend the application so that the user can monitor the results}
  writeln('-----------------------------------------------------------------------');
  writeln('Press any key to end');
  wInputWaitKey();
end.

