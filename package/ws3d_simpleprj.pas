unit ws3d_simplePrj;

{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, LazIDEIntf, ProjectIntf, MenuIntf, SrcEditorIntf;

type
  { TWs3dLazSimpleProjectDescriptor }
  TWs3dSimpleProjectDescriptor = class(TProjectDescriptor)
  public
    constructor Create; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function InitProject(AProject: TLazProject): TModalResult; override;
    function CreateStartFiles(AProject: TLazProject): TModalResult; override;
  end;

  procedure Register;

  resourcestring
  rsAboutSimplePrj = 'A simple and easy-to-use library to enjoy videogames programming';
  rsNameSimplePrj  = 'WorldSim3d Simple Project';

implementation

procedure Register;
begin
 RegisterProjectDescriptor(TWs3dSimpleProjectDescriptor.Create);
end;

{ TWs3dLazSimpleProjectDescriptor }
constructor TWs3dSimpleProjectDescriptor.Create;
begin
  inherited Create;
  Name := rsNameSimplePrj;
  Flags := Flags -[pfMainUnitHasCreateFormStatements,pfMainUnitHasTitleStatement] + [pfUseDefaultCompilerOptions];
end;

function TWs3dSimpleProjectDescriptor.GetLocalizedName: string;
begin
  Result:= rsNameSimplePrj;
end;

function TWs3dSimpleProjectDescriptor.GetLocalizedDescription: string;
begin
  Result:= rsAboutSimplePrj;
end;

function TWs3dSimpleProjectDescriptor.InitProject(AProject: TLazProject): TModalResult;
var
  Source: string;
  MainFile: TLazProjectFile;

begin
  Result := inherited InitProject(AProject);
  MainFile := AProject.CreateProjectFile('game.lpr');
  MainFile.IsPartOfProject := True;
  AProject.AddFile(MainFile, False);
  AProject.MainFileID := 0;
  Source:='program Game;' + LineEnding +
    LineEnding +
    '{$mode objfpc}{$H+}' + LineEnding +
    LineEnding +
    'uses ' + LineEnding +
    'cmem, SysUtils, WorldSim3D, SampleFunctions' + LineEnding +
     '  screenHeight = 450;'+ LineEnding  + LineEnding +
    'begin' + LineEnding +
    '  {Start engine}'+ LineEnding +
    '  if not wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false,true, true, false) then Halt;'+ LineEnding +  LineEnding +
    '  {Show engine logo}'+ LineEnding +
    '  wEngineShowLogo(true);'+ LineEnding +  LineEnding +
    '  {Main loop}'+ LineEnding +
    '  while wEngineRunning() do'+ LineEnding +
    '  begin' + LineEnding +
    '    wSceneBegin(wCOLOR4s_BLACK);'+ LineEnding + LineEnding +
    '    {your code here}'+ LineEnding + LineEnding +
    '    wSceneEnd();'+ LineEnding + LineEnding +
    '    wEngineCloseByEsc();'+ LineEnding + LineEnding +
    '    {Update fps}'+ LineEnding +
    '    if prevFPS<>wEngineGetFPS() then' + LineEnding +
    '    begin'+ LineEnding +
    '      prevFPS:=wEngineGetFPS();'+ LineEnding +
    '      wWindowSetCaption(wndCaption+WStr(FormatFloat(''0'',prevFPS)));'+ LineEnding +
    '    end;'+ LineEnding + LineEnding +
    'end; '+ LineEnding + LineEnding +
    '{Stop engine}' + LineEnding +
    'wEngineStop(true);' + LineEnding +
    'end.'+ LineEnding + LineEnding;

  AProject.MainFile.SetSourceText(Source);
  AProject.LazCompilerOptions.UnitOutputDirectory := 'lib' + PathDelim + '$(TargetCPU)-$(TargetOS)';
  AProject.LazCompilerOptions.TargetFilename:= 'game';
  AProject.AddPackageDependency('ws3d');
end;

function TWs3dSimpleProjectDescriptor.CreateStartFiles(AProject: TLazProject): TModalResult;
begin
  Result:=inherited CreateStartFiles(AProject);
end;

end.

