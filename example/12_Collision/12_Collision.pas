{
'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas(WorldSim3D developer)
'' Адаптировал Vuvk
'' ----------------------------------------------------------------------------
'' Пример 12 : Столкновение (collision)
'' Пример показывает работу аниматора столкновения, а также -
'' как сделать проверку столкновения между двумя Нодами. В этом примере мы сделали
'' так чтобы камера и карта (здание по которому перемещаемся) взаимодействовали друг с другом
'' как в реальном физическом мире, чтобы игрок, управляющий камерой, мог естественно
'' перемещаться по зданию.
'' ----------------------------------------------------------------------------'
}
program p12_Collision;

{Attach modules}
uses
  SysUtils,
  WorldSim3D,
  SampleFunctions;

var
  BSPMesh : wMesh;

  BSPNode,
  Camera : wNode;

  myFont,
  BitmapFont : wFont;

  MapCollision : wSelector;
  AnimCollision : wAnimator;
  params : wAnimatorCollisionResponse;

  fromPos,
  toPos : wVector2i;

  vec1,
  cameraPos : wVector3f;

  scrollGravityY,
  checkCollision : wGuiObject;
  callerType : wGuiCallerType;

  ///Для переключения режима FPS-камера/обычная камера
  isControl : Boolean = false;

  ///Это нам пригодится для организации
  ///прыжка камерой
  key_JUMP : wKeyCode = wKC_SPACE;
  ///Максимальный отрыв от "земли"
  jumpMax : Single = 150.0;
  dY : Single;
  ///Скорость прыжка
  jumpForce : Single = 1.5;
  ///Для запоминания стартовой позиции в момент  прыжка
  curCameraPosition : wVector3f;
  ///Флаг проерки нажатия на key_JUMP
  isJumping : Boolean = false;

  isHelp : Boolean = false;

  resPath : PChar = 'Assets/BSPmaps/ctfcomp02_hazard.pk3';
  fontPath : PChar = 'Assets/Fonts/Cyr.xml';
  text : PWChar = 'Press Right Mouse Button to set parameters';
                               
  wndCaption : PWChar = 'Example 12: Collision ';
  i : Integer;
  prevFPS : Int32=0;

begin
  // -----------------------------------------------------------------------------
  // start the WorldSim3D interface
  if not wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false) then
    begin
      PrintWithColor('wEngineStart() failed!', wCFC_RED, true);
      Halt;
    end;

  ///Show logo WS3D
  wEngineShowLogo(true);

  ///Check resources
  if (not CheckFilePath(resPath) or
      not CheckFilePath(fontPath)) then
    Halt;

  ///Load resources
  wFileAddZipArchive(resPath,true,false);
  BSPMesh := wMeshLoad('maps/ctfcomp02_hazard.bsp');
  myFont := wFontLoad(fontPath);

  ///Create nodes             
  BSPNode := wNodeCreateFromMeshAsOctree(BSPMesh);

  ///Create camera
  Camera := wFpsCameraCreate(100.0, 0.2, @wKeyMapDefault, Length(wKeyMapDefault));

  wNodeSetPosition(Camera, to_wVector3f(386,366,2726));
  wCameraSetTarget(Camera, to_wVector3f(-534,299,5345));
  wFpsCameraSetVerticalMovement(Camera,false);

  ///Create collision
  MapCollision := wCollisionCreateFromOctreeMesh(BSPMesh,BSPNode);

  ///Create collision animator
  AnimCollision := wAnimatorCollisionResponseCreate(MapCollision,Camera);

  ///Get & Set collision animator parameters
  wAnimatorCollisionResponseGetParameters(AnimCollision, @params);
  params.gravity := to_wVector3f(0, -80.0, 0);
  params.ellipsoidRadius := to_wVector3f(15,50,15);
  params.ellipsoidTranslation := to_wVector3f(0, 25, 0);
  wAnimatorCollisionResponseSetParameters(AnimCollision, params);

  ///Create scroll for set gravityY
  scrollGravityY := wGuiScrollBarCreate(false,
                                        to_wVector2i(760,400),
                                        to_wVector2i(770, 550));

  wGuiScrollBarSetMinValue(scrollGravityY,-100);
  wGuiScrollBarSetMaxValue(scrollGravityY,100);
  wGuiScrollBarSetValue(scrollGravityY,80);
  wGuiScrollBarSetLargeStep(scrollGravityY,1);
  wGuiScrollBarSetSmallStep(scrollGravityY,1);

  ///Create checkBox for collision mode set
  checkCollision := wGuiCheckBoxCreate(Pwstr('Check collision'),
                                       to_wVector2i(580,550),
                                       to_wVector2i(780,600),
                                       true);

  wGuiSkinSetFont(wGuiGetSkin(), myFont);
  wGuiSkinSetColor(wGuiGetSkin(), wGDC_BUTTON_TEXT, wCOLOR4s_WHITE);

  ///Hide mouse cursor
  wInputSetCursorVisible(false);

  // -----------------------------------------------------------------------------
  // while the WorldSim3D environment is still running
  while wEngineRunning do
    begin
      // clear the canvas to black to show the particles up better
      wSceneBegin(wCOLOR4s_BLACK);

      // draw the scene
      wSceneDrawAll();

      ///Draw scrollbar and checkBox
      wGuiObjectDraw(scrollGravityY);
      wGuiObjectDraw(checkCollision);

      ///Считываем параметры аниматора
      wAnimatorCollisionResponseGetParameters(AnimCollision, @params);

      ///Draw collision triangle
      ///Чуть приподнимем/приопускаем треугольник коллизии для лучшей видимости

      if (params.gravity.y < 0) then
          dY :=  0.5
      else
          dY := -0.5;

      params.collisionTriangle.pointA.y += dY;
      params.collisionTriangle.pointB.y += dY;
      params.collisionTriangle.pointC.y += dY;

      w3dDrawTriangle(params.collisionTriangle, wCOLOR4s_DARKRED);

      ///Draw text info
      fromPos := to_wVector2i(50,  450);
      toPos   := to_wVector2i(300, 400);
      if(params.isFalling) then
        wFontDraw(myFont, 'Camera is falling: TRUE ', fromPos,toPos, wCOLOR4s_WHITE)
      else
        wFontDraw(myFont, 'Camera is falling: FALSE', fromPos,toPos, wCOLOR4s_WHITE);

      fromPos.y += 40; toPos.y += 40;
      if (params.animateTarget) then
        wFontDraw(myFont, 'Collision: ON', fromPos,toPos, wCOLOR4s_WHITE)
      else
        wFontDraw(myFont, 'Collision: OFF', fromPos,toPos, wCOLOR4s_WHITE);

      fromPos := to_wVector2i(630,450);
      toPos   := to_wVector2i(800,500);
      wFontDraw(myFont,
                PWChar('Gravity.Y : ' + WStr(IntToStr(-wGuiScrollBarGetValue(scrollGravityY)))),
                fromPos,toPos,
                wCOLOR4s_WHITE);

      ///Выводим подсказки
      if (not isHelp) then
        begin
          fromPos := to_wVector2i(10,10);
          toPos   := to_wVector2i(500,40);
          wFontDraw(myFont, 'Press F1 to Help', fromPos,toPos,wCOLOR4s_GREEN);
        end
      else
        begin
          fromPos := to_wVector2i(10,10);
          toPos   := to_wVector2i(500,40);
          wFontDraw(myFont,'Movement: (W,A,S,D) or (Up,Left,Down,Right)',fromPos,toPos,wCOLOR4s_GREEN);
          fromPos.y+=20; toPos.y+=20;
          wFontDraw(myFont,'Jumping: SPACE (if default value)',fromPos,toPos,wCOLOR4s_GREEN);
          fromPos.y+=20; toPos.y+=20;
          wFontDraw(myFont,'Exit: ESCAPE ',fromPos,toPos,wCOLOR4s_GREEN);

          ///Выводим подсказку внизу эекрана
          ///с горизонтальным центрированием
          fromPos := to_wVector2i(400 - wFontGetTextSize(myFont,PwStr(text)).x shr 1,570);
          toPos   := to_wVector2i(400 + wFontGetTextSize(myFont,PwStr(text)).x shr 1,600);
          wFontDraw(myFont,'Press Right Mouse Button to set parameters',fromPos,toPos,wCOLOR4s_GREEN);
        end;

      ///Gui (scrollBar and checkBox) events
      if (wGuiIsEventAvailable()) then
        begin
          callerType := wGuiReadEvent()^.event;
          if(callerType = wGCT_SCROLL_BAR_CHANGED) then
            begin
              params.gravity := to_wVector3f(params.gravity.x,
                                             -wGuiScrollBarGetValue(scrollGravityY),
                                             params.gravity.z);
              wAnimatorCollisionResponseSetParameters(AnimCollision,params);
            end;
          if(callerType = wGCT_CHECKBOX_CHANGED) then
            begin
              params.animateTarget := wGuiCheckBoxIsChecked(checkCollision);
              wAnimatorCollisionResponseSetParameters(AnimCollision,params);
              ///Если флажок убран, сразу переходим в автоматический
              ///режим обзора
              if(not params.animateTarget) then
                begin
                  wInputSetCursorVisible(false);
                  wCameraSetInputEnabled(Camera,true);
                  isControl := false;
                end;
            end;
        end;


      ///Попробуем организовать прыжок
      ///по нажатию на KEY_JUMP (по умолчанию wKC_SPACE)
      ///Все это будет доступно только в режиме FPS-камеры
      if(not isControl) then
        begin
          if (wInputIsKeyHit(key_JUMP) and not params.isFalling) then
            begin
              ///На всякий случай уберем фокус с ГУИ-объектов
              wGuiObjectRemoveFocus(scrollGravityY);
              wGuiObjectRemoveFocus(checkCollision);
              ///Запоминаем текущее положение камеры
              curCameraPosition := wNodeGetPosition(Camera);
              isJumping := true;
            end;

          ///Если активирован прыжок- перемещаем камеру вверх
          ///с учетом параметров прыжка и дельта тайминга
          if (isJumping) then
            begin
              cameraPos := wNodeGetPosition(Camera);
              if (cameraPos.y <= curCameraPosition.y + jumpMax) then
                begin
                  cameraPos.y += jumpForce*(-params.gravity.y)*wTimerGetDelta();
                  wNodeSetPosition(Camera,cameraPos);
                end
              else
                isJumping := false;
            end;

          ///Если камера на земле и не нажата клавиша прыжка,
          ///обнуляем флаг прыжка
          if(not params.isFalling and not wInputIsKeyHit(key_JUMP)) then
            isJumping := false;
        end;

      ///Keys events
      ///For Help
      if (wInputIsKeyHit(wKC_F1)) then
        isHelp := not isHelp;

      ///Mouse events
      ///For control mode
      if (wInputIsMouseHit(wMB_RIGHT)) then
        begin
          ///На всякий случай уберем фокус с ГУИ-объектов
          wGuiObjectRemoveFocus(scrollGravityY);
          wGuiObjectRemoveFocus(checkCollision);

          isControl := not isControl;

          wInputSetCursorVisible(isControl);
          wCameraSetInputEnabled(Camera, not isControl);
        end;

      ///В режиме отсутствия коллизии со сценой
      ///разрешаем камере вертикальные перемещения
      wFpsCameraSetVerticalMovement(Camera, not params.animateTarget);

      ///При отсутствии "ручного" контроля
      ///на всякий случай убираем фокус с ГУИ-объектов
      ///и рисуем нечто вроде прицела
      if (not isControl) then
        begin
          wGuiObjectRemoveFocus(scrollGravityY);
          wGuiObjectRemoveFocus(checkCollision);
          w2dDrawPolygon(to_wVector2i(396,296),8,wCOLOR4s_GREEN,12);
          w2dDrawPixel(to_wVector2i(396,296),wCOLOR4s_GREEN);
        end;

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


