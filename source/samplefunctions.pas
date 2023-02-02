unit SampleFunctions;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,WorldSim3D;

function CheckFilePath(path:PChar) : Boolean;
procedure PrintWithColor(text : PChar; color : wConsoleFontColor; waitKey : Boolean);
                                          
function ShaderGetMaterialType(shader : wShader) : wMaterialTypes;

procedure OutlineNode(node:wNode; width:Float32; lineColor:wColor4s);

function CreateColorTexture(tColor : wColor4s) : wTexture; 
function CreateColorTexture(alpha, red, green, blue : UInt16) : wTexture;

function to_wColor4f(alpha, red, green, blue : Single) : wColor4f;
function to_wColor4s(alpha, red, green, blue : UInt16) : wColor4s;
                                          
function to_wVector2i(x, y : Integer) : wVector2i;
function to_wVector2f(x, y : Single) : wVector2f;
function to_wVector3f(x, y, z : Single) : wVector3f;

function wMeshLoadEx(path:PChar):wMesh;

{Для Q3-BSP}
{Вспомогательная процедура}
procedure FindAndSetEntity(entityList:PUInt32; entityName:PChar);
{Процедура парсинга BSP-карты}
procedure ParseQuakeMap(BSPMesh:wMesh);
{Вспомогательная процедура}
procedure SetEntityObject(name:PChar; _file:PChar; position:wVector3f);
procedure ParseQuakeMap2(BSPMesh:wMesh);
procedure SetQuakeShadersVisible(value:Boolean);

implementation

function CheckFilePath(path:PChar) : Boolean;
 var def:Int32;
 begin
   if not wFileIsExist(path) then
      begin
      wEngineStop(true);
      def:=wConsoleSaveDefaultColors();
      wConsoleSetFontColor(wCFC_RED);
      writeln();
      writeln('File << '+path+' >> not found!');
      writeln();
      wConsoleSetFontColor(wCFC_YELLOW);
      writeln('Warning! Check the paths to your resources!');
      wConsoleResetColors(def);
      writeln();
      writeln('Press any key to exit...');
      wInputWaitKey();
      Result := False;
   end;

   Result := True;
 end;

procedure PrintWithColor(text : PChar; color : wConsoleFontColor; waitKey : Boolean);
var
  def : Int32;
begin
  def := wConsoleSaveDefaultColors();
  wConsoleSetFontColor(color);
  writeln(text);
  wConsoleResetColors(def);
  if (waitKey) then
    begin
      writeln;
      writeln('Press any key...');
      wInputWaitKey();
    end;
end;

function ShaderGetMaterialType(shader : wShader) : wMaterialTypes;
begin
  Result := wMaterialTypes(shader.material_type);
 // Result := wMaterialTypes(shader^.material_type);
end;

 procedure OutlineNode(node:wNode; width:Float32; lineColor:wColor4s);
   type wMaterialInfo=record
   	diffuseColor:wColor4s;
   	emissiveColor:wColor4s;
   	ambientColor:wColor4s;
   	specularColor:wColor4s;
   	backfaceCulling:Boolean;
   	frontfaceCulling:Boolean;
   	thickness:Float32;
   	lighting:Boolean;
   	wireframe:Boolean;
   end;
   var
   matInfo: array of wMaterialInfo;
   curMat: array of wMaterialInfo;
   vis:Boolean;
   mCount:Int32;
   mat: wMaterial;
   i:Int32;

   begin
   if node <> 0 then exit;

   vis:=wNodeIsVisible(node);
   wNodeSetVisibility(node,true);
   mCount:=wNodeGetMaterialsCount(node);
   SetLength(curMat,mCount);
   SetLength(matInfo,1);

   matInfo[0].diffuseColor:=lineColor;
   matInfo[0].specularColor:=lineColor;
   matInfo[0].ambientColor:= lineColor;
   matInfo[0].emissiveColor:= lineColor;
   matInfo[0].backfaceCulling:= false;
   matInfo[0].frontfaceCulling:= true;
   matInfo[0].lighting:= true;
   matInfo[0].thickness:= width;
   matInfo[0].wireframe:= true;

   for i:= 0 to mCount-1 do
        begin
   	mat:= wNodeGetMaterial(node,i);
   	curMat[i].diffuseColor:=wMaterialGetDiffuseColor(mat);
   	curMat[i].specularColor:=wMaterialGetSpecularColor(mat);
   	curMat[i].ambientColor:=wMaterialGetAmbientColor(mat);
   	curMat[i].emissiveColor:=wMaterialGetEmissiveColor(mat);
   	curMat[i].thickness:=wMaterialGetLineThickness(mat);
        curMat[i].wireframe:=wMaterialGetFlag(mat,wMF_WIREFRAME);
        curMat[i].backfaceCulling:=wMaterialGetFlag(mat,wMF_BACK_FACE_CULLING);
        curMat[i].frontfaceCulling:=wMaterialGetFlag(mat,wMF_FRONT_FACE_CULLING);
        curMat[i].lighting:=wMaterialGetFlag(mat,wMF_LIGHTING);

        wMaterialSetDiffuseColor(mat,matInfo[0].diffuseColor);
        wMaterialSetSpecularColor(mat,matInfo[0].specularColor);
        wMaterialSetAmbientColor(mat,matInfo[0].ambientColor);
        wMaterialSetEmissiveColor(mat,matInfo[0].emissiveColor);
        wMaterialSetLineThickness(mat,matInfo[0].thickness);
        wMaterialSetFlag(mat,wMF_WIREFRAME,matInfo[0].wireframe);
        wMaterialSetFlag(mat,wMF_LIGHTING,matInfo[0].lighting);
        wMaterialSetFlag(mat,wMF_FRONT_FACE_CULLING,matInfo[0].frontfaceCulling);
        wMaterialSetFlag(mat,wMF_BACK_FACE_CULLING,matInfo[0].backfaceCulling);
   end;

   wNodeDraw(node);

   for i:=0 to mCount-1 do
        begin
        mat:= wNodeGetMaterial(node,i);
        wMaterialSetDiffuseColor(mat,curMat[i].diffuseColor);
        wMaterialSetSpecularColor(mat,curMat[i].specularColor);
        wMaterialSetAmbientColor(mat,curMat[i].ambientColor);
        wMaterialSetEmissiveColor(mat,curMat[i].emissiveColor);
        wMaterialSetLineThickness(mat,curMat[i].thickness);
        wMaterialSetFlag(mat,wMF_WIREFRAME,curMat[i].wireframe);
        wMaterialSetFlag(mat,wMF_LIGHTING,curMat[i].lighting);
        wMaterialSetFlag(mat,wMF_FRONT_FACE_CULLING,curMat[i].frontfaceCulling);
        wMaterialSetFlag(mat,wMF_BACK_FACE_CULLING,curMat[i].backfaceCulling);
  end;

   wNodeSetVisibility(node,vis);
   SetLength(curMat,0);
   SetLength(matInfo,0);

 end;


function CreateColorTexture(tColor : wColor4s) : wTexture;
var
  t : wTexture;
  size : wVector2i = (x : 1; y : 1);
  lock : PUInt32;
begin
  t := wTextureCreate('colorTexture', size, wCF_A8R8G8B8);
  lock := wTextureLock(t);
  lock^ := wUtilColor4sToUInt(tColor);
  wTextureUnlock(t);
  Result := t;
end;

function CreateColorTexture(alpha, red, green, blue : UInt16) : wTexture;
begin
  Result := CreateColorTexture(to_wColor4s(alpha, red, green, blue));
end;

             
function to_wColor4f(alpha, red, green, blue : Single) : wColor4f;
begin
  Result.alpha := alpha;
  Result.red   := red;
  Result.green := green;
  Result.blue  := blue;
end;

function to_wColor4s(alpha, red, green, blue : UInt16) : wColor4s;
begin
  Result.alpha := alpha;
  Result.red   := red;
  Result.green := green;
  Result.blue  := blue;
end;
                   
function to_wVector2i(x, y : Integer) : wVector2i;
begin
  Result.x := x;
  Result.y := y;
end;

function to_wVector2f(x, y : Single) : wVector2f;
begin
  Result.x := x;
  Result.y := y;
end;

function to_wVector3f(x, y, z : Single) : wVector3f;
begin
  Result.x := x;
  Result.y := y;
  Result.z := z;
end;

function wMeshLoadEx(path:PChar):wMesh;
var
   mesh:wMesh;
begin
     if wSceneIsMeshLoaded(path) then
        begin
             mesh:=wSceneGetMeshByName(path);
             if mesh<>0 then Result:= mesh;
        end;

     if wFileIsExist(path) then mesh:=wMeshLoad(path);

     Result:=mesh;
end;

{Вспомогательная процедура}
procedure FindAndSetEntity(entityList:PUInt32; entityName:PChar);
const
  {скорость работы сплайн-аниматора}
  splineSpeed=1.0;
  {смещение модели по вертикали}
  splineDelta=4;
  tightness=0.5;
  rotSpeed=1.5;
  scale:wVector3f=(x:5;y:5;z:5);
 var
 varGroup:PUInt32=nil;
 entityIndex:wVector2i;

 {Для сплайн-аниматора по двум точкам}
 points:array[0..2] of wVector3f;

 mesh:wMesh=0;
 node:wNode=0;
 camera:wNode=0;

 {позиция установки объекта}
 position:wVector3f;
 {горизонтальный угол поворота}
 angle:Float32;
 {вектор поворота}
 rotation:wVector3f;
 {имя модели}
 modelName:PChar=nil;
 parsePos:UInt32=0;
 count:Int32=0;
 i:Int32=0;
 isModel:Boolean=true;
 isWeapon:Boolean=false;
 {для биллборда старта/респавна}
 BillBoard:wNode=0;
 bSize:wVector2f=(x:128;y:12);
 bTopColor:wColor4s=(alpha:255;red:255;green:0;blue:0);
 bBottomColor:wColor4s=(alpha:255;red:64;green:0;blue:0);
 {для позиции старта}
 radians:Float32=0;

 begin

 entityIndex:=wBspGetEntityIndexByName(entityList,entityName);

 if entityIndex.x=-1 then exit;

 writeln('Find and set entity: ');
 writeln(entityName);
 writeln('firstIndex= '+FormatFloat('0',entityIndex.x));
 writeln('lastIndex= '+FormatFloat('0',entityIndex.y));

 for i:=entityIndex.x  to entityIndex.y do
    begin

    varGroup:=wBspGetVarGroupByIndex(entityList,i);
    parsePos:=0;
    position:=wBspGetVarGroupValueAsVec(varGroup,'origin',parsePos);

    if entityName='info_player_start' then
       begin
        isModel:=false;
        bTopColor.alpha:=255; bTopColor.red:=255; bTopColor.green:=0; bTopColor.blue:=0;
        bBottomColor.alpha:=255; bBottomColor.red:=64; bBottomColor.green:=0; bBottomColor.blue:=0;

        BillBoard:=wBillboardCreateText(position,bSize,wFontGetDefault(), PWStr('PLAYER START'),
        bTopColor,bBottomColor);
    end;

    if entityName='info_player_deathmatch' then
       begin
	isModel:=false;
	parsePos:=0;
	angle:=wBspGetVarGroupValueAsFloat(varGroup,'angle',parsePos);

       bTopColor.alpha:=255; bTopColor.red:=64; bTopColor.green:=64; bTopColor.blue:=0;
       bBottomColor.alpha:=255; bBottomColor.red:=255; bBottomColor.green:=255; bBottomColor.blue:=0;
       BillBoard:=wBillboardCreateText(position,bSize,wFontGetDefault(),PwStr('PLAYER DEATHMATCH No '+FormatFloat('0',count)),bTopColor,bBottomColor);
    	if i=entityIndex.y then
           begin
           radians:=wMathDegToRad(angle);
    	    camera:=wSceneGetActiveCamera();
    	    position.y+=10;
    	    wNodeSetPosition(camera,position);
    	    position.x+=100*sin(radians);
    	    position.z+=100*cos(radians);
    	    wCameraSetTarget(camera,position);
    	    position.x:=0;
    	    position.y:=0;
    	    position.z:=-50;
    	    wNodeMove(camera,position);
    	end;
         count+=1;
    end;

    if entityName='misc_model' then
        begin
        isModel:=true;
        modelName:=wBspGetVarGroupValueAsString(varGroup,'model');
    end;

    if entityName='weapon_railgun' then
        begin
        isModel:=true;
    	 mesh:=wMeshLoadEx('models/weapons2/railgun/railgun.md3');
    	 modelName:=entityName;
    end;

    if entityName='weapon_plasmagun' then
        begin
        isModel:=true;
    	 mesh:=wMeshLoadEx('models/weapons2/plasma/plasma.md3');
    	 modelName:=entityName;
    end;

    if entityName='weapon_rocketlauncher' then
        begin
        isModel:=true;
    	 mesh:=wMeshLoadEx('models/weapons2/rocketl/rocketl.md3');
    	 modelName:=entityName;
    end;

    if entityName='weapon_shotgun' then
        begin
        isModel:=true;
    	 mesh:=wMeshLoadEx('models/weapons2/shotgun/shotgun.md3');
    	 modelName:=entityName;
    end;

    if entityName='ammo_rockets' then
        begin
        isModel:=true;
    	 mesh:=wMeshLoadEx('models/powerups/ammo/rocketam.md3');
    	 modelName:=entityName;
    end;

    if entityName='ammo_shells' then
        begin
        isModel:=true;
    	 mesh:=wMeshLoadEx('models/weapons2/shells/m_shell.md3');
    	 modelName:=entityName;
    end;

    if mesh<> 0 then node:= wNodeCreateFromMesh(mesh);
    if node<> 0 then
       begin
       wNodeSetPosition(node,position);
       rotation.x:=0; rotation.y:=rotSpeed; rotation.z:=0;
       wAnimatorRotationCreate(node,rotation);

       points[0].x:=position.x;
       points[0].y:=position.y+splineDelta;
       points[0].z:=position.z;
       points[1].x:=position.x;
       points[1].y:=position.y-splineDelta;
       points[1].z:=position.z;
       wAnimatorSplineCreate(node,2,@points[0],1,splineSpeed,Tightness);
       wNodeSetName(node,modelName);
       if entityName='ammo_shells' then wNodeSetScale(node,scale);
    end;//end if

    if isModel then Writeln(modelName);

    writeln();
    writeln('Position: '+FormatFloat('0.0',position.x)+' , '+FormatFloat('0.0',position.y)+' , '+FormatFloat('0.0',position.z));
    writeln('Angle: '+FormatFloat('0.0',angle));

end;//end for

end;

{Процедура парсинга BSP-карты}
procedure ParseQuakeMap(BSPMesh:wMesh);
var
  list:PUInt32=nil;
begin
   list:=wBspGetEntityList(BSPMesh);

   FindAndSetEntity(list, 'info_player_start');
   FindAndSetEntity(list, 'info_player_deathmatch');
   FindAndSetEntity(list, 'misc_model');
   FindAndSetEntity(list, 'weapon_plasmagun');
   FindAndSetEntity(list, 'weapon_railgun');
   FindAndSetEntity(list, 'weapon_rocketlauncher');
   FindAndSetEntity(list, 'weapon_shotgun');
   FindAndSetEntity(list, 'ammo_rockets');
   FindAndSetEntity(list, 'ammo_shells');
end;

{Вспомогательная процедура}
procedure SetEntityObject(name:PChar; _file:PChar; position:wVector3f);
begin
end;

procedure ParseQuakeMap2(BSPMesh:wMesh);
begin
end;

procedure SetQuakeShadersVisible(value:Boolean);
var
  root:wNode=0;
  iter:UInt32=0;
  node:wNode=0;
begin
root:=wSceneGetRootNode();
node:=wNodeGetFirstChild(root,@iter);

while not wNodeIsLastChild(root,@iter) do
begin
   node:=wNodeGetNextChild(root,@iter);
   if node<>0 then
      begin
       if wNodeGetType(node)=wSNT_Q3SHADER_SCENE_NODE then wNodeSetVisibility(node,value);
   end;
end;

end;

end.

