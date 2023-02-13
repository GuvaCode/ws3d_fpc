unit ws3dScene;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  { TWS3dScene }
  TWS3dScene = class(TDataModule)
  private
    FOldOrder: Boolean;
    property OldCreateOrder: Boolean read FOldOrder write FOldOrder;
  protected

  public
    Procedure DoCreate; override;

  published

  end;

implementation

{ TWS3dScene }

procedure TWS3dScene.DoCreate;
begin
  inherited DoCreate;



end;

end.

