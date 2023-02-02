{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ws3d;

{$warn 5023 off : no warning about unused units}
interface

uses
  WorldSim3D, SampleFunctions, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('ws3d', @Register);
end.
