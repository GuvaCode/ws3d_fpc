{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ws3d_dsg;

{$warn 5023 off : no warning about unused units}
interface

uses
  ws3d_simplePrj, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ws3d_simplePrj', @ws3d_simplePrj.Register);
end;

initialization
  RegisterPackage('ws3d_dsg', @Register);
end.
