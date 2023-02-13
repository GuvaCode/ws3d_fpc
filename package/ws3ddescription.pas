unit ws3dDescription;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazIDEIntf, ProjectIntf, Controls, Forms, ws3dScene;

type
  { TFileDescPascalUnitWithMyForm }
  TUnitFormWs3d = class(TFileDescPascalUnitWithResource)
  public
    constructor Create; override;
    function GetInterfaceUsesSection: string; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;

  { TApplicationDescriptorWs3d }

  TApplicationDescriptorWs3d = class(TProjectDescriptor)
  public
    constructor Create; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function InitProject(AProject: TLazProject): TModalResult; override;
    function CreateStartFiles(AProject: TLazProject): TModalResult; override;
  end;

  const LE = #10; // Line End

  resourcestring
  AboutProject = 'Lazy engine game application';
  AboutDescription ='Is a set of classes for helping in the creation of 2D and 3D games in pascal.';

procedure Register;

implementation

procedure Register;
begin
    RegisterProjectFileDescriptor(TUnitFormWs3d.Create,FileDescGroupName);
    RegisterProjectDescriptor(TApplicationDescriptorWs3d.Create);
end;

function FileDescriptorByName() : TProjectFileDescriptor;
begin
 Result:=ProjectFileDescriptors.FindByName('AboutDescription');
end;

{ TApplicationDescriptorWs3d }

constructor TApplicationDescriptorWs3d.Create;
begin
  inherited Create;
  Name:= 'AboutDescription';
end;

function TApplicationDescriptorWs3d.GetLocalizedName: string;
begin
  //Result:=inherited GetLocalizedName;
  Result:= 'AboutProject';
end;

function TApplicationDescriptorWs3d.GetLocalizedDescription: string;
begin
  //Result:=inherited GetLocalizedDescription;
  Result:= AboutDescription;
end;

function TApplicationDescriptorWs3d.InitProject(AProject: TLazProject): TModalResult;
var
  NewSource: String;
  MainFile: TLazProjectFile;
  un:TUnitFormWs3d;
begin
  Result:=inherited InitProject(AProject);
  MainFile:=AProject.CreateProjectFile('myGame.lpr');
  MainFile.IsPartOfProject:=true;
  AProject.AddFile(MainFile,false);
  AProject.MainFileID:=0;
  AProject.UseAppBundle:=true;

 NewSource:=
 'program Project1;' +Le+
' {$mode objfpc}{$H+}' +LE+LE+

'uses' +LE+
'  {$IFDEF UNIX}' +Le+
'  cthreads,' +Le+
'  {$ENDIF}' +Le+
'  Interfaces,' +Le+
'  ws3dScene, unit1;' +Le +Le+

'{$R *.res}' +Le+

'begin ' +Le+
'  RequireDerivedFormResource:=True; ' +Le+
'  Application.Scaled:=True;' +Le+
'  Application.Initialize;' +Le+
'  Application.CreateForm(TWS3dScene1, WS3dScene1);' +Le+
'  Application.Run;' +Le+
'end.' +Le;

  AProject.MainFile.SetSourceText(NewSource,true);
  AProject.AddPackageDependency('LCL');
  AProject.LazCompilerOptions.UnitOutputDirectory:='lib'+PathDelim+'$(TargetCPU)-$(TargetOS)';
  AProject.LazCompilerOptions.TargetFilename:='Game';
  un:=TUnitFormWs3d.Create;
end;

function TApplicationDescriptorWs3d.CreateStartFiles(AProject: TLazProject
  ): TModalResult;

begin
  //Result:=LazarusIDE.DoNewFile();
  //DoNewEditorFile(FileDescriptorByName,'','',[]);
  Result:=LazarusIDE.DoNewEditorFile(FileDescriptorByName,'ab.pas','NewSorce',[nfIsPartOfProject,nfOpenInEditor,nfCreateDefaultSrc]);
end;

{ TFileDescPascalUnitWithMyForm }

constructor TUnitFormWs3d.Create;
begin
  inherited Create;
  Name:='MyForm'; // do not translate this
  ResourceClass:=TWS3dScene;
  UseCreateFormStatements:=true;
end;

function TUnitFormWs3d.GetInterfaceUsesSection: string;
begin
    Result:='Classes, SysUtils';
end;

function TUnitFormWs3d.GetLocalizedName: string;
begin
    Result:='MyForm'; // replace this with a resourcestring
end;

function TUnitFormWs3d.GetLocalizedDescription: string;
begin
    Result:='Create a new MyForm from example package NotLCLDesigner';
end;

end.

