{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' Адаптировал Vuvk
'' ----------------------------------------------------------------------------
'' Пример 37 : Шейдерные материалы
'' Пример показывает как применять к объектам в качестве материалов шейдеры, т.е.
'' программы выполняемые видеокартой(GPU). Этот материал просто подгоняет освещение
'' под объект так, как будто свет исходит от наблюдателя, а цвет меняется от белого
'' к лиловому. В данном примере используются ARB шейдеры.
'' ----------------------------------------------------------------------------
}
program p37_Materials_Shader;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  NodeTexture,
  MeshTexture : wTexture;
  SkyTextures : array [0..5] of wTexture;

  vert_shader : PwShader;

  ShaderNode,
  NoShaderNode,
  Light,
  SkyBox,
  Camera : wNode;

  material : wMaterial;

  vec1 : wVector3f;

  LightLevel : array [0..3] of Single = (1.0, 0.0, 1.0, 1.0);
  change : Single = 0.01;

  meshTexPath : PChar = 'Assets/Textures/Metal.jpg';
  shaderPath  : PChar = 'Assets/Shaders/ARB/arb_example_vert.txt';
  skyTexPath  : array[0..5] of PChar = ('Assets/SkyBoxes/Grandcanyon/skybox_up.jpg',
                                        'Assets/SkyBoxes/Grandcanyon/skybox_dn.jpg',
                                        'Assets/SkyBoxes/Grandcanyon/skybox_rt.jpg',
                                        'Assets/SkyBoxes/Grandcanyon/skybox_lf.jpg',
                                        'Assets/SkyBoxes/Grandcanyon/skybox_ft.jpg',
                                        'Assets/SkyBoxes/Grandcanyon/skybox_bk.jpg');

  wndCaption : PWChar = 'Example 37: Shader Materials (ARB) ';
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
  for i := Low(skyTexPath) to High(skyTexPath) do
    if (not CheckFilePath(skyTexPath[i])) then
      exit
    else 
      SkyTextures[i] := wTextureLoad(skyTexPath[i]);

  if (not CheckFilePath(meshTexPath) or
      not CheckFilePath(shaderPath)) then
    exit;

  ///Load resources
  MeshTexture := wTextureLoad(meshTexPath);

  ///Create nodes
  SkyBox := wSkyBoxCreate(SkyTextures[0],SkyTextures[1],SkyTextures[2],SkyTextures[3],SkyTextures[4],SkyTextures[5]);

  ShaderNode := wNodeCreateSphere(35, 64,false, wCOLOR4s_WHITE);
  wNodeSetPosition(ShaderNode, to_wVector3f(-40, 0, 0));

  NoShaderNode := wNodeCreateSphere(35.0,64,false,wCOLOR4s_WHITE);
  wNodeSetPosition(NoShaderNode, to_wVector3f(40, 0, 0));

  ///Load material shader
  vert_shader := wShaderAddMaterialFromFiles(shaderPath, nil, wMT_SOLID,0);

  if (vert_shader <> nil) then
    begin
      wShaderCreateAddressedVertexConstant(vert_shader,0,wSC_INVERSE_WORLD,nil,0);
      wShaderCreateAddressedVertexConstant(vert_shader,4,wSC_WORLD_VIEW_PROJECTION,nil,0);
      wShaderCreateAddressedVertexConstant(vert_shader,8,wSC_CAMERA_POSITION,nil,0);
      wShaderCreateAddressedVertexConstant(vert_shader,9,wSC_NO_PRESET,@LightLevel[0],4);
      wShaderCreateAddressedVertexConstant(vert_shader,10,wSC_TRANSPOSED_WORLD,nil,0);

      material := wNodeGetMaterial(ShaderNode,0);
      wMaterialSetType(material,ShaderGetMaterialType(vert_shader));
      wMaterialSetTexture(material,0,MeshTexture);
    end
  else
    PrintWithColor('No shader returned',wCFC_RED,false);

  material := wNodeGetMaterial(NoShaderNode,0);
  wMaterialSetType(material,wMT_SOLID);
  wMaterialSetTexture(material,0,MeshTexture);

  ///Create light
  Light := wLightCreate(to_wVector3f(-100,100,100),wCOLOR4f_WHITE,600);
  wSceneSetAmbientLight(to_wColor4f(1,0.15,0.15,0.15));

  ///Create camera
  Camera := wCameraCreate(to_wVector3f(0, 0, 100), wVECTOR3f_ZERO);
                           
  ///Hide mouse cursor
  wInputSetCursorVisible(false);

  // -----------------------------------------------------------------------------
  // while the WorldSim3D environment is still running
  while wEngineRunning do
    begin
      // clear the canvas to black to show the particles up better
      wSceneBegin(wCOLOR4s_BLACK);
                   
      LightLevel[1] += change;
      if (LightLevel[1] < 0.0) then
        begin
          LightLevel[1] := 0.0;
          change := 0.01;
        end
      else
        begin
          if (LightLevel[1] > 1.0) then
            begin
              LightLevel[1] := 1.0;
              change := -0.01;
            end;
        end;

      // draw the scene
      wSceneDrawAll();

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


