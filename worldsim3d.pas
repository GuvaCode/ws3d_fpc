unit WorldSim3D;

{$mode ObjFPC}{$H+}

interface
 {
 '######### PLATFORMS ###################################
#LibPath "./"
#Ifdef __FB_WIN32__
	#Ifdef __FB_64BIT__
		#Inclib "WS3DCoreLib64"
	#Else
		#Inclib "WS3DCoreLib"
	#EndIf
#Else
 	#Ifdef  __FB_LINUX__
		#Ifdef __FB_64BIT__
			#Inclib "WS3DCoreLib64"
			#Inclib "Irrlicht64"
		#Else
			#Inclib "WS3DCoreLib"
			#Inclib "Irrlicht"
		#EndIf
 	#Else
		#Error Build target must be Windows or Linux !
 	#EndIf
#EndIf
}
uses
  SysUtils, WorldSim3D_types,
  {$IFDEF FPC}
    {$IFDEF WINDOWS}
    {$ELSE}
      //glx provides functionality to set up an OpenGL window in an X Window system
      glx,
    {$ENDIF}
    GL
  {$ELSE}
    OpenGL
  {$ENDIF};

const
  {$IFDEF WINDOWS}
    {$IFDEF WIN32}
      WS3DCoreLib = 'WS3DCoreLib.dll';
    {$ELSE}
      WS3DCoreLib = 'WS3DCoreLib64.dll';
    {$ENDIF}
  {$ELSE}
    {$IFDEF LINUX}
      WS3DCoreLib = 'WS3DCoreLib.so';
    {$ENDIF}
  {$ENDIF}

const
  {$IFDEF WINDOWS}
    nullStr = '';
  {$ELSE}
    nullStr = nil;
  {$ENDIF}

type
  {$IFDEF WINDOWS}
  WChar   = WideChar;
  WString = WideString;
  {$ELSE}
  WChar   = UCS4Char;
  WString = UCS4String;
  {$ENDIF}
  PWChar   = ^WChar;
  PPWChar   = ^PWChar;
  PWString = ^WString;
//  wFile = PUInt32;
//  PwFile= ^wFile;

implementation

{ wConsole }
procedure wConsoleSetFontColor(c: wConsoleFontColor); cdecl; external WS3DCoreLib;

procedure wConsoleSetBackColor(c: wConsoleBackColor); cdecl; external WS3DCoreLib;

function wConsoleSaveDefaultColors: Int32; cdecl; external WS3DCoreLib;

procedure wConsoleResetColors(defValues: Int32); cdecl; external WS3DCoreLib;

{wTexture}
function wTextureLoad(const cptrFile: PChar): wTexture; cdecl; external WS3DCoreLib;

function wTextureCreateRenderTarget(size: wVector2i): wTexture; cdecl; external WS3DCoreLib;

function wTextureCreate(const name: PChar; size: wVector2i; format: wColorFormat): wTexture; cdecl; external WS3DCoreLib;

procedure wTextureDestroy(texture: wTexture); cdecl; external WS3DCoreLib;

function wTextureLock(texture: wTexture): PUInt32; cdecl; external WS3DCoreLib;

procedure wTextureUnlock(texture: wTexture); cdecl; external WS3DCoreLib;

procedure wTextureSave(texture: wTexture; const file_: PChar); cdecl; external WS3DCoreLib;

function wTextureConvertToImage(texture: wTexture): wImage; cdecl; external WS3DCoreLib;

procedure wTextureGetInformation(texture: wTexture; size: PwVector2u; pitch: PUInt32; format: PwColorFormat); cdecl; external WS3DCoreLib;

procedure wTextureMakeNormalMap(texture: wTexture; amplitude: Float32); cdecl; external WS3DCoreLib ;

function wTexturesSetBlendMode(texturedest: wTexture; texturesrc: wTexture;
          offset: wVector2i; operation: wBlendOperation):Int32; cdecl; external WS3DCoreLib ;

procedure wTextureSetColorKey(texture: wTexture; key: wColor4s); cdecl; external WS3DCoreLib;

procedure wTextureSetGray(texture:PwTexture); cdecl; external WS3DCoreLib ;

procedure wTextureSetAlpha(texture: PwTexture; value: UInt32); cdecl; external WS3DCoreLib;

procedure wTextureSetInverse(texture: PwTexture); cdecl; external WS3DCoreLib ;

procedure wTextureSetBrightness(texture: PwTexture; value: UInt32); cdecl; external WS3DCoreLib;

function wTextureCopy(texture: wTexture; const name: PChar): wTexture; cdecl; external WS3DCoreLib;

procedure wTextureSetContrast(texture: PwTexture; value: Float32); cdecl; external WS3DCoreLib;

function wTextureFlip(texture: PwTexture; mode: Int32 = 1): wTexture; cdecl; external WS3DCoreLib;

procedure wTextureSetBlur(texture: PwTexture; radius: Float32); cdecl; external WS3DCoreLib;

function wTextureGetFullName(texture: wTexture): PChar; cdecl; external WS3DCoreLib;

function wTextureGetInternalName(texture: wTexture): PChar; cdecl; external WS3DCoreLib;

procedure wTextureDraw(texture: wTexture; pos: wVector2i; useAlphaChannel: Boolean;
  color: wColor4s); cdecl; external WS3DCoreLib;

procedure wTextureDrawEx(texture: wTexture; pos: wVector2i; scale: wVector2f;
  useAlphaChannel: Boolean = true); cdecl; external WS3DCoreLib;

procedure wTextureDrawMouseCursor(texture: wTexture); cdecl; external WS3DCoreLib;

procedure wTextureDrawElement(texture: wTexture; pos: wVector2i; fromPos: wVector2i;
  toPos: wVector2i; useAlphaChannel: Boolean;color: wColor4s); cdecl; external WS3DCoreLib;

procedure wTextureDrawElementStretch(texture: wTexture; destFromPos: wVector2i;
  destToPos: wVector2i; sourceFromPos: wVector2i; sourceToPos: wVector2i;
  useAlphaChannel: Boolean = true); cdecl; external WS3DCoreLib ;

procedure wTextureDrawAdvanced(texture:wTexture; pos:wVector2i; rotPoint:wVector2i;
          rotation:Float32;scale:wVector2f; useAlphaChannel:Boolean; color:wColor4s;
          aliasMode:wAntiAliasingMode=wAAM_SIMPLE;
          bilinearFilter:Boolean=true; trilinearFilter:Boolean=true;
          anisotropFilter:Boolean=true); cdecl; external WS3DCoreLib ;

procedure wTextureDrawElementAdvanced(texture:wTexture; pos:wVector2i; fromPos:wVector2i;
          toPos: wVector2i; rotPoint: wVector2i; rotAngleDeg: Float32; scale: wVector2f;
          useAlphaChannel: Boolean; color: wColor4s;
          aliasMode: wAntiAliasingMode = wAAM_SIMPLE;bilinearFilter: Boolean = true;
          trilinearFilter: Boolean=true; anisotropFilter: Boolean=true); cdecl; external WS3DCoreLib;

{ W2 }
procedure w2dDrawRect(minPos: wVector2i; maxPos: wVector2i; color: wColor4s); cdecl; external WS3DCoreLib ;

procedure w2dDrawRectWithGradient(minPos: wVector2i; maxPos: wVector2i;
          colorLeftUp: wColor4s; colorRightUp: wColor4s;
          colorLeftDown: wColor4s; colorRightDown: wColor4s); cdecl; external WS3DCoreLib ;

procedure w2dDrawRectOutline(minPos: wVector2i; maxPos: wVector2i; color: wColor4s); cdecl; external WS3DCoreLib ;

procedure w2dDrawLine(fromPos: wVector2i; toPos: wVector2i; color: wColor4s); cdecl; external WS3DCoreLib ;

procedure w2dDrawPixel(pos: wVector2i; color: wColor4s); cdecl; external WS3DCoreLib ;

procedure w2dDrawPolygon(pos: wVector2i; Radius: Float32;
          color: wColor4s; vertexCount: Int32 = 12); cdecl; external WS3DCoreLib ;
{ W3D }
procedure w3dDrawLine(_start: wVector3f; _end: wVector3f; color: wColor4s); cdecl; external WS3DCoreLib;

procedure w3dDrawBox(minPoint: wVector3f; maxPoint: wVector3f; color: wColor4s); cdecl; external WS3DCoreLib;

procedure w3dDrawTriangle(triangle: wTriangle; color: wColor4s); cdecl; external WS3DCoreLib;

{ wFont }
function wFontLoad(const fontPath: PChar): wFont; cdecl; external WS3DCoreLib;

function wFontAddToFont(const fontPath: PChar; destFont: wFont): wFont; cdecl; external WS3DCoreLib;

function wFontGetDefault():wFont; cdecl; external WS3DCoreLib;

procedure wFontDraw(font:wFont; const wcptrText: PWString;   ////////
          fromPos: wVector2i; toPos: wVector2i; color: wColor4s); cdecl; external WS3DCoreLib;

procedure wFontDestroy(font: wFont); cdecl; external WS3DCoreLib;

function wFontGetTextSize(font: wFont; const text: PWString): wVector2u; cdecl; external WS3DCoreLib; ///////

procedure wFontSetKerningSize(font: wFont; kerning: wVector2u); cdecl; external WS3DCoreLib;

function wFontGetKerningSize(font: wFont): wVector2u; cdecl; external WS3DCoreLib;

function wFontGetCharacterFromPos(font: wFont; text: PWString; xPixel: Int32): Int32; cdecl; external WS3DCoreLib;

procedure wFontSetInvisibleCharacters(font: wFont; s: PWString); cdecl; external WS3DCoreLib;

function wFontLoadFromTTF(const fontPath: PChar; size: UInt32; antialias: Boolean = false;
          transparency: Boolean = false): wFont; cdecl; external WS3DCoreLib ;

procedure wFontDrawAsTTF(font: wFont; const wcptrText: PWString; fromPos: wVector2i;
          toPos: wVector2i; color: wColor4s; hcenter: Boolean = false; vcenter: Boolean = false); cdecl; external WS3DCoreLib;

{ wImage }
function wImageLoad(const cptrFile:PChar): wImage; cdecl; external WS3DCoreLib;

function wImageSave(img: wImage; const _file: PChar): Boolean; cdecl; external WS3DCoreLib;

function wImageCreate(size: wVector2i; format: wColorFormat): wImage; cdecl; external WS3DCoreLib;

procedure wImageDestroy(image: wImage); cdecl; external WS3DCoreLib;

function wImageLock(image: wImage): PUInt32; cdecl; external WS3DCoreLib;

procedure wImageUnlock(image: wImage); cdecl; external WS3DCoreLib;

function wImageConvertToTexture(img: wImage; const name: PChar): wTexture; cdecl; external WS3DCoreLib;

function wImageGetPixelColor(img: wImage; pos: wVector2u): wColor4s; cdecl; external WS3DCoreLib;

procedure wImageSetPixelColor(img: wImage; pos: wVector2u; color: wColor4s; blend: Boolean = false); cdecl; external WS3DCoreLib;

procedure wImageGetInformation(image: wImage; size: PwVector2u; pitch: PUInt32; format: PwColorFormat); cdecl; external WS3DCoreLib;

{ wTimer }
function wTimerGetDelta: Float32; cdecl; external WS3DCoreLib;

function wTimerGetTime: UInt32; cdecl; external WS3DCoreLib;

function wTimerGetRealTimeAndDate: wRealTimeDate; cdecl; external WS3DCoreLib;

function wTimerGetRealTime: UInt32; cdecl; external WS3DCoreLib;

procedure wTimerSetTime(newTime: UInt32); cdecl; external WS3DCoreLib;

function wTimerIsStopped():Boolean; cdecl; external WS3DCoreLib;

procedure wTimerSetSpeed(speed: Float32); cdecl; external WS3DCoreLib;

procedure wTimerStart(); cdecl; external WS3DCoreLib;

procedure wTimerStop(); cdecl; external WS3DCoreLib;

procedure wTimerTick(); cdecl; external WS3DCoreLib;

{ wLog }
procedure wLogSetLevel(level: wLoggingLevel = wLL_INFORMATION); cdecl; external WS3DCoreLib;

procedure wLogSetFile(const path: PChar); cdecl; external WS3DCoreLib;

procedure wLogClear(const path: PChar); cdecl; external WS3DCoreLib;

procedure wLogWrite( hint: PWString ; text: PWString; path: PChar = nil; mode: UInt32 = 1); cdecl; external WS3DCoreLib;

{ wSystem }
procedure wSystemSetClipboardText(const text:PChar); cdecl; external WS3DCoreLib;

function wSystemGetClipboardText(): PChar; cdecl; external WS3DCoreLib;

function wSystemGetProcessorSpeed(): UInt32; cdecl; external WS3DCoreLib;

function wSystemGetTotalMemory(): UInt32; cdecl; external WS3DCoreLib;

function wSystemGetAvailableMemory(): UInt32; cdecl; external WS3DCoreLib;

function wSystemGetMaxTextureSize(): wVector2i; cdecl; external WS3DCoreLib;

function wSystemIsTextureFormatSupported(format: wColorFormat): Boolean; cdecl; external WS3DCoreLib;

function wSystemIsTextureCreationFlag(flag: wTextureCreationFlag): Boolean; cdecl; external WS3DCoreLib;

function wSystemCreateScreenShot(minPos: wVector2u; maxPos: wVector2u): wTexture; cdecl; external WS3DCoreLib;

function wSystemSaveScreenShot(const _file:PChar):Boolean; cdecl; external WS3DCoreLib;

function wSystemGetVersion(): PChar; cdecl; external WS3DCoreLib;

function wSystemIsDriverSupported(testDriver: wDriverTypes): Boolean; cdecl; external WS3DCoreLib ;

{ wDisplay }
function wDisplayGetVendor(): PChar; cdecl; external WS3DCoreLib;

function wDisplayModesGetCount(): Int32; cdecl; external WS3DCoreLib;

function wDisplayModeGetDepth(modeNumber: Int32): Int32; cdecl; external WS3DCoreLib;

function wDisplayModeGetResolution(ModeNumber: Int32): wVector2u; cdecl; external WS3DCoreLib;

function wDisplayGetCurrentResolution(): wVector2u; cdecl; external WS3DCoreLib;

function wDisplayGetCurrentDepth(): Int32; cdecl; external WS3DCoreLib;

procedure wDisplaySetGammaRamp(gamma: wColor3f; brightness: Float32; contrast: Float32); cdecl; external WS3DCoreLib ;

procedure wDisplayGetGammaRamp(gamma: PwColor3f;
          brightness: PFloat32; contrast: PFloat32); cdecl; external WS3DCoreLib;

function wDisplaySetDepth(depth: UInt32): Boolean; cdecl; external WS3DCoreLib;

{ wMath }
const {%H-}wMathPI = 3.14159265359;
      {%H-}wMathPI64 = 3.1415926535897932384626433832795028841971693993751;

{ Возвращает нормализованный вектор }
function wMathVector3fNormalize(source: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ Возвращает длину вектора }
function wMathVector3fGetLength(vector: wVector3f): Float32; cdecl; external WS3DCoreLib ;
{ Get the rotations that would make a (0,0,1) direction vector point in the same direction as this direction vector. }
function wMathVector3fGetHorizontalAngle(vector: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ Возвращает инвертированный вектор (все координаты меняют знак) }
function wMathVector3fInvert(vector: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ Суммирует два вектора }
function wMathVector3fAdd(vector1, vector2: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ Вычитает из вектора 1 вектор 2 }
function wMathVector3fSubstract(vector1: wVector3f; vector2: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ Векторное произведение векторов }
function wMathVector3fCrossProduct(vector1, vector2: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ Скалярное произведение векторов }
function wMathVector3fDotProduct(vector1, vector2: wVector3f): Float32; cdecl; external WS3DCoreLib;
{ Определяет кратчайшее расстояние между векторами }
function wMathVector3fGetDistanceFrom(vector1, vector2: wVector3f): Float32; cdecl; external WS3DCoreLib;
{ Возвращает интерполированный вектор }
function wMathVector3fInterpolate(vector1, vector2: wVector3f; d: Float64): wVector3f; cdecl; external WS3DCoreLib;
{ Возвращает случайное число из интервала (first, last) }
function wMathRandomRange(first, last: Float64): Float64; cdecl; external WS3DCoreLib;

{ Из градусов- в радианы }
function wMathDegToRad(degrees: Float32): Float32; cdecl; external WS3DCoreLib;
{ Из радиан- в градусы }
function wMathRadToDeg(radians: Float32): Float32; cdecl; external WS3DCoreLib;
{ Математически правильное округление }
function wMathRound(value: Float32): Float32; cdecl; external WS3DCoreLib;
{ Округление в большую сторону }
function wMathCeil(value: Float32): Int32; cdecl; external WS3DCoreLib;
{ Округление в меньшую сторону }
function wMathFloor(value: Float32): Int32; cdecl; external WS3DCoreLib;
{ returns if a equals b, taking possible rounding errors into account }
function wMathFloatEquals(value1, value2: Float32; tolerance: Float32 = 0.000001):Boolean; cdecl; external WS3DCoreLib;
{ returns if a equals b, taking an explicit rounding tolerance into account }
function wMathIntEquals(value1, value2: Int32; tolerance: Int32 = 0): Boolean; cdecl; external WS3DCoreLib;
{ returns if a equals b, taking an explicit rounding tolerance into account }
function wMathUIntEquals(value1, value2: UInt32; tolerance:UInt32 = 0): Boolean; cdecl; external WS3DCoreLib;
{ returns if a equals zero, taking rounding errors into account }
function wMathFloatIsZero(value: Float32; tolerance:Float32 = 0.000001): Boolean; cdecl; external WS3DCoreLib;
{ returns if a equals zero, taking rounding errors into account }
function wMathIntIsZero(value: Int32; tolerance: Int32=0): Boolean; cdecl; external WS3DCoreLib;
{ returns if a equals zero, taking rounding errors into account }
function wMathUIntIsZero(value: UInt32; tolerance: UInt32 = 0):Boolean; cdecl; external WS3DCoreLib;
{ Возвращает больший Float32 из двух }
function wMathFloatMax2(value1, value2: Float32): Float32; cdecl; external WS3DCoreLib;
{ Возвращает больший Float32 из трех }
function wMathFloatMax3(value1, value2, value3: Float32): Float32; cdecl; external WS3DCoreLib;
{ Возвращает больший Int32 из двух }
function wMathIntMax2(value1, value2: Int32): Float32; cdecl; external WS3DCoreLib;
{ Возвращает больший Int32 из трех }
function wMathIntMax3(value1, value2, value3: Int32): Float32; cdecl; external WS3DCoreLib;
{ Возвращает меньший Float32 из двух }
function wMathFloatMin2(value1, value2: Float32): Float32; cdecl; external WS3DCoreLib;
{ Возвращает меньший Float32 из трех }
function wMathFloatMin3(value1, value2, value3: Float32): Float32; cdecl; external WS3DCoreLib;
{ Возвращает меньший Int32 из двух }
function wMathIntMin2(value1, value2: Int32): Float32; cdecl; external WS3DCoreLib;
{ Возвращает меньший Int32 из трех }
function wMathIntMin3(value1, value2, value3: Int32): Float32; cdecl; external WS3DCoreLib;

{ wUtil }
function wUtilVector3fToStr(vector: wVector3f; s: PChar = ';';
         addNullChar: Boolean = false): PChar; cdecl; external WS3DCoreLib;

function wUtilVector2fToStr(vector: wVector2f;
          s: PChar = ';'; addNullChar: Boolean = false): PChar; cdecl; external WS3DCoreLib;

function wUtilColor4sToStr(color: wColor4s;
          s: PChar; addNullChar: Boolean): PChar; cdecl; external WS3DCoreLib;

function wUtilColor4fToStr(color: wColor4f;
          s: PChar; addNullChar: Boolean): PChar; cdecl; external WS3DCoreLib;

function wUtilColor4sToUInt(color: wColor4s): UInt32; cdecl; external WS3DCoreLib;

function wUtilColor4fToUInt(color: wColor4f): UInt32; cdecl; external WS3DCoreLib;

function wUtilUIntToColor4s(color: UInt32): wColor4s;  cdecl; external WS3DCoreLib;

function wUtilUIntToColor4f(color: UInt32): wColor4f; cdecl; external WS3DCoreLib;

function wUtilStrToInt(const str: PChar): Int32; cdecl; external WS3DCoreLib;

function wUtilIntToStr(value: Int32; addNullChar: Boolean = false): PChar; cdecl; external WS3DCoreLib;

function wUtilStrToFloat(const str: PChar): Float32; cdecl; external WS3DCoreLib;

function wUtilFloatToStr(value: Float32; addNullChar: Boolean = false): PChar; cdecl; external WS3DCoreLib;

function wUtilStrToUInt(const str: PChar): UInt32; cdecl; external WS3DCoreLib;

function wUtilUIntToStr(value: UInt32; addNullChar: Boolean = false): PChar; cdecl; external WS3DCoreLib;

procedure wUtilSwapInt(value1, value2: PInt32); cdecl; external WS3DCoreLib;

procedure wUtilSwapUInt(value1, value2: PUInt32); cdecl; external WS3DCoreLib;

procedure wUtilSwapFloat(value1, value2: PFloat32); cdecl; external WS3DCoreLib;

function wUtilWideStrToStr(const str:PWstring): PChar; cdecl; external WS3DCoreLib;

function wUtilStrToWideStr(const str:PChar): PWstring; cdecl; external WS3DCoreLib;

procedure wUtilStrAddNullChar(str:PPChar); cdecl; external WS3DCoreLib;

procedure wUtilWideStrAddNullChar(str:PPWChar); cdecl; external WS3DCoreLib;

{ wEngine }
function wEngineSetClipPlaneByPoints(indexPlane: UInt32; point1, point2,
          point3: wVector3f; enable: boolean): Boolean; cdecl; external WS3DCoreLib;

function wEngineSetClipPlaneByPointAndNormal(indexPlane: UInt32;
          point, normal: wVector3f; enable: boolean): Boolean; cdecl; external WS3DCoreLib;

procedure  wEngineEnableClipPlane(indexPlane: UInt32; value: Boolean); cdecl; external WS3DCoreLib;

procedure wEngineSetClipboardText(text: PWString); cdecl; external WS3DCoreLib ;

function wEngineGetClipboardText():Pwstring; cdecl; external WS3DCoreLib ;

function wEngineStart(iDevice: wDriverTypes;
                      size: wVector2u;
                      iBPP:UInt32 = 32;
                      boFullscreen: Boolean = false;
                      boShadows: Boolean = true;
                      boCaptureEvents: Boolean = true;
                      vsync: Boolean = true ): Boolean; cdecl; external WS3DCoreLib;

procedure wEngineCloseByEsc(); cdecl; external WS3DCoreLib;

function wEngineStartAdvanced(params: wEngineCreationParameters): Boolean; cdecl; external WS3DCoreLib;

function wEngineLoadCreationParameters(outParameters: PwEngineCreationParameters;
                                       const xmlFilePath: PChar): Boolean; cdecl; external WS3DCoreLib;

function wEngineSaveCreationParameters(inParameters: PwEngineCreationParameters;
                                       const xmlFilePath: PChar): Boolean; cdecl; external WS3DCoreLib;

function wEngineStartWithGui(const captionText: Pwstring;
                                   fontPath: PChar = nil;
                                   logo: PChar = nil;
                                   language: wLanguage = wL_EN;
                                   outParams: PwEngineCreationParameters = nil;
                                   inXmlConfig: PChar = nil): Boolean; cdecl; external WS3DCoreLib;

procedure wEngineSetTransparentZWrite(value: Boolean); cdecl; external WS3DCoreLib;

function wEngineRunning(): Boolean; cdecl; external WS3DCoreLib;

procedure wEngineSleep(Ms: UInt32; pauseTimer: Boolean = false); cdecl; external WS3DCoreLib;

procedure wEngineYield(); cdecl; external WS3DCoreLib;

procedure wEngineSetViewPort(fromPos: wVector2i; toPos: wVector2i); cdecl; external WS3DCoreLib;

function wEngineIsQueryFeature(feature: wVideoFeatureQuery): Boolean; cdecl; external WS3DCoreLib;

procedure wEngineDisableFeature(feature: wVideoFeatureQuery; flag: Boolean); cdecl; external WS3DCoreLib;

function wEngineStop(closeDevice: Boolean): Boolean; cdecl; external WS3DCoreLib;

procedure wEngineSetFPS(limit: UInt32); cdecl; external WS3DCoreLib;

function wEngineGetFPS(): Int32; cdecl; external WS3DCoreLib;

function wEngineGetGlobalMaterial(): wMaterial; cdecl; external WS3DCoreLib;

function wEngineGet2dMaterial(): wMaterial; cdecl; external WS3DCoreLib;

procedure wEngineSet2dMaterial(value: Boolean); cdecl; external WS3DCoreLib;

procedure wEngineShowLogo(value: Boolean); cdecl; external WS3DCoreLib;

{ wCustomRenderer (only  OpenGL!   Experimental!!!) }
function wCustomRendererCreate(const shaderDirPath: PChar;
                               cFormat: wColorFormat = wCF_D16): Boolean; cdecl; external WS3DCoreLib;

function wCustomRendererDestroy(): Boolean; cdecl; external WS3DCoreLib;

procedure wCustomRendererSwapMaterials(node: wNode = 0); cdecl; external WS3DCoreLib;

procedure wCustomRendererUpdateMaterialEntry(swapFrom, swapTo: wMaterialTypes); cdecl; external WS3DCoreLib;

procedure wCustomRendererRemoveMaterialEntry(swapFrom: wMaterialTypes); cdecl; external WS3DCoreLib;

procedure wCustomRendererGetMaterialTypes(customMaterials: PwCustomMaterialTypes); cdecl; external WS3DCoreLib;

function wCustomRendererGetDepthBuffer(): wTexture; cdecl; external WS3DCoreLib;

function wCustomRendererGetFinalRenderTexture(): wTexture; cdecl; external WS3DCoreLib;

function wCustomRendererGetMRTCount(): UInt32; cdecl; external WS3DCoreLib;

function wCustomRendererGetMRT(index: UInt32): wTexture; cdecl; external WS3DCoreLib;

{ wScene }
function wSceneBegin(color:wColor4s):Boolean; cdecl; external WS3DCoreLib;

function wSceneBeginAdvanced( backColor: wColor4s;
                              clearBackBuffer: Boolean = true;
                              clearZBuffer : Boolean = true): Boolean; cdecl; external WS3DCoreLib;

//procedure wSceneLoad(filename: Pchar); cdecl; external WS3DCoreLib;
function wSceneLoad(const filename: PChar; parentNode: wNode = 0): Boolean; cdecl; external WS3DCoreLib;

function wSceneLoadFromFile(file_: wFile; parentNode: wNode = 0): Boolean; cdecl; external WS3DCoreLib;

function wSceneSave(filename: PChar; parentNode: wNode = 0): Boolean; cdecl; external WS3DCoreLib;

function wSceneSaveToFile(file_: wFile; parentNode: wNode = 0): Boolean; cdecl; external WS3DCoreLib;

function wSceneSaveToXml(writer: wXmlWriter; const relativePath: PChar;
                         parentNode: wNode=0): Boolean; cdecl; external WS3DCoreLib;

procedure wSceneDrawAll(); cdecl; external WS3DCoreLib;

function wSceneEnd():Boolean; cdecl; external WS3DCoreLib;

procedure wSceneDrawToTexture(renderTarget: wTexture); cdecl; external WS3DCoreLib;

procedure wSceneSetRenderTarget(renderTarget:wTexture;
         backColor:wColor4s;clearBackBuffer:Boolean=true;
         clearZBuffer:Boolean=true); cdecl; external WS3DCoreLib;

procedure wSceneSetAmbientLight(color:wColor4f); cdecl; external WS3DCoreLib;

function wSceneGetAmbientLight():wColor4f; cdecl; external WS3DCoreLib;

procedure wSceneSetShadowColor(color:wColor4s); cdecl; external WS3DCoreLib;

function wSceneGetShadowColor():wColor4s; cdecl; external WS3DCoreLib;

procedure wSceneSetFog(color:wColor4s; fogtype:wFogType;
         start:Float32; _end:Float32; density:Float32;
         pixelFog:Boolean=false; rangeFog:Boolean=false); cdecl; external WS3DCoreLib ;

procedure wSceneGetFog(color:PwColor4s; fogtype:PwFogType;
         start:PFloat32;_end:PFloat32; density:PFloat32;
         pixelFog:PBoolean; rangeFog:PBoolean); cdecl; external WS3DCoreLib ;

function wSceneGetActiveCamera():wNode; cdecl; external WS3DCoreLib ;

function wSceneGetTextureByName(name:PChar):wTexture; cdecl; external WS3DCoreLib ;

procedure wSceneDestroyAllTextures(); cdecl; external WS3DCoreLib ;

procedure wSceneDestroyAllNodes(); cdecl; external WS3DCoreLib ;

function wSceneGetMeshByName(name:PChar):wMesh; cdecl; external WS3DCoreLib ;

function wSceneGetMeshByIndex(index:UInt32):wMesh; cdecl; external WS3DCoreLib ;

function wSceneGetMeshesCount():UInt32; cdecl; external WS3DCoreLib ;

procedure wSceneDestroyAllMeshes(); cdecl; external WS3DCoreLib ;

function wSceneIsMeshLoaded(filePath:PChar):Boolean; cdecl; external WS3DCoreLib ;

procedure wSceneDestroyAllUnusedMeshes(); cdecl; external WS3DCoreLib ;

function wSceneGetPrimitivesDrawn():UInt32; cdecl; external WS3DCoreLib ;

function wSceneGetNodesCount():UInt32; cdecl; external WS3DCoreLib ;

function wSceneGetNodeById(id:Int32):wNode; cdecl; external WS3DCoreLib ;

function wSceneGetNodeByName(name:PChar):wNode; cdecl; external WS3DCoreLib ;

function wSceneGetRootNode():wNode; cdecl; external WS3DCoreLib ;

{ wWindow }
procedure wWindowSetCaption(wcptrText:WString); cdecl; external WS3DCoreLib ;

procedure wWindowGetSize(size:PwVector2u); cdecl; external WS3DCoreLib ;

function wWindowIsFullscreen():Boolean; cdecl; external WS3DCoreLib ;

function wWindowIsResizable():Boolean; cdecl; external WS3DCoreLib ;

function wWindowIsActive():Boolean; cdecl; external WS3DCoreLib ;

function wWindowIsFocused():Boolean; cdecl; external WS3DCoreLib ;

function wWindowIsMinimized():Boolean; cdecl; external WS3DCoreLib ;

procedure wWindowMaximize(); cdecl; external WS3DCoreLib ;

procedure wWindowMinimize(); cdecl; external WS3DCoreLib ;

procedure wWindowRestore(); cdecl; external WS3DCoreLib ;

procedure wWindowSetResizable(resizable:Boolean); cdecl; external WS3DCoreLib ;

procedure wWindowMove(pos:wVector2u); cdecl; external WS3DCoreLib ;

procedure wWindowPlaceToCenter(); cdecl; external WS3DCoreLib ;

procedure wWindowResize(newSize:wVector2u); cdecl; external WS3DCoreLib ;

procedure wWindowSetFullscreen(value:Boolean); cdecl; external WS3DCoreLib ;

function wWindowSetDepth(depth:UInt32):Boolean; cdecl; external WS3DCoreLib ;

// PostEffects //
function wPostEffectCreate(effectnum: wPostEffectId; quality:wPostEffectQuality;
         value1, value2, value3, value4, value5, value6, value7, value8: Float32): PwPostEffect; cdecl; external WS3DCoreLib ;

procedure wPostEffectDestroy(ppEffect: PwPostEffect); cdecl; external WS3DCoreLib ;

procedure wPostEffectSetParameters(ppEffect: PwPostEffect; para1, para2, para3,
         para4, para5, para6, para7, para8: Float32); cdecl; external WS3DCoreLib ;

procedure wPostEffectsDestroyAll(); cdecl; external WS3DCoreLib ;


///wXEffects///
procedure wXEffectsStart(vsm: Boolean; softShadows: Boolean; bitDepth32: Boolean; color:wColor4s); cdecl; external WS3DCoreLib ;

procedure wXEffectsEnableDepthPass(enable:Boolean); cdecl; external WS3DCoreLib ;

procedure wXEffectsAddPostProcessingFromFile(name: PChar; effectType: Int32 = 1); cdecl; external WS3DCoreLib ;

procedure wXEffectsSetPostProcessingUserTexture(texture: wTexture); cdecl; external WS3DCoreLib ;

procedure wXEffectsAddShadowToNode(node: wNode; filterType: wFilterType; shadowType:wShadowMode); cdecl; external WS3DCoreLib ;

procedure wXEffectsRemoveShadowFromNode(node: wNode); cdecl; external WS3DCoreLib ;

procedure wXEffectsExcludeNodeFromLightingCalculations(node:wNode); cdecl; external WS3DCoreLib ;

procedure wXEffectsAddNodeToDepthPass(node: wNode); cdecl; external WS3DCoreLib ;

procedure wXEffectsSetAmbientColor(color: wColor4s); cdecl; external WS3DCoreLib ;

procedure wXEffectsSetClearColor(color: wColor4s); cdecl; external WS3DCoreLib ;

procedure wXEffectsAddShadowLight(shadowDimen: UInt32; position, target: wVector3f;
         color: wColor4f; lightNearDist, lightFarDist, angleDeg: Float32); cdecl; external WS3DCoreLib ;

function wXEffectsGetShadowLightsCount(): UInt32; cdecl; external WS3DCoreLib ;

function wXEffectsGetShadowMapTexture(resolution: UInt32; secondary: Boolean): wTexture; cdecl; external WS3DCoreLib ;

function wXEffectsGetDepthMapTexture(): wTexture; cdecl; external WS3DCoreLib ;

procedure wXEffectsSetScreenRenderTargetResolution(size: wVector2u); cdecl; external WS3DCoreLib ;

procedure wXEffectsSetShadowLightPosition(index: UInt32; position: wVector3f); cdecl; external WS3DCoreLib ;

function wXEffectsGetShadowLightPosition(index: UInt32): wVector3f; cdecl; external WS3DCoreLib ;

procedure wXEffectsSetShadowLightTarget(index: UInt32; target: wVector3f); cdecl; external WS3DCoreLib ;

function wXEffectsGetShadowLightTarget(index: UInt32): wVector3f; cdecl; external WS3DCoreLib ;

procedure wXEffectsSetShadowLightColor(index: UInt32; color: wColor4f); cdecl; external WS3DCoreLib ;

function wXEffectsGetShadowLightColor(index: UInt32): wColor4f; cdecl; external WS3DCoreLib ;

procedure wXEffectsSetShadowLightMapResolution(index, resolution: UInt32); cdecl; external WS3DCoreLib ;

function wXEffectsGetShadowLightMapResolution(index:UInt32): UInt32; cdecl; external WS3DCoreLib ;

function wXEffectsGetShadowLightFarValue(index: UInt32): Float32; cdecl; external WS3DCoreLib ;

///wAnimator///

function wAnimatorFollowCameraCreate(node: wNode; position: wVector3f): wAnimator; cdecl; external WS3DCoreLib ;

procedure wAnimatorFollowCameraSetParameters(anim: wAnimator; params: wAnimatorFollowCamera); cdecl; external WS3DCoreLib ;

procedure wAnimatorFollowCameraGetParameters(anim: wAnimator; params: PwAnimatorFollowCamera); cdecl; external WS3DCoreLib ;

function wAnimatorCollisionResponseCreate(selector: wSelector; node: wNode; slidingValue: Float32 = 0.0005): wAnimator; cdecl; external WS3DCoreLib;

procedure wAnimatorCollisionResponseSetParameters(anim: wAnimator; params: wAnimatorCollisionResponse); cdecl; external WS3DCoreLib;

procedure wAnimatorCollisionResponseGetParameters(anim: wAnimator; params: PwAnimatorCollisionResponse); cdecl; external WS3DCoreLib ;

function wAnimatorDeletingCreate(node: wNode; delete_after: Int32): wAnimator; cdecl; external WS3DCoreLib ;

function wAnimatorFlyingCircleCreate(node: wNode; pos: wVector3f; radius, speed: Float32; direction: wVector3f;
         startPos, radiusEllipsoid: Float32): wAnimator; cdecl; external WS3DCoreLib ;

procedure wAnimatorFlyingCircleSetParameters(anim: wAnimator;
         params: wAnimatorFlyingCircle); cdecl; external WS3DCoreLib ;

procedure wAnimatorFlyingCircleGetParameters(anim: wAnimator;
         params: PwAnimatorFlyingCircle); cdecl; external WS3DCoreLib ;

function wAnimatorFlyingStraightCreate(node: wNode; startPoint, endPoint: wVector3f;
         time:UInt32; loop:Boolean): wAnimator; cdecl; external WS3DCoreLib ;

procedure wAnimatorFlyingStraightSetParameters(anim: wAnimator; param: wAnimatorFlyingStraight); cdecl; external WS3DCoreLib;

procedure wAnimatorFlyingStraightGetParameters(anim: wAnimator; params: PwAnimatorFlyingStraight); cdecl; external WS3DCoreLib;

function wAnimatorRotationCreate(node: wNode; pos: wVector3f): wAnimator; cdecl; external WS3DCoreLib;

procedure wAnimatorRotationSetParameters(anim: wAnimator; params: wAnimatorRotation); cdecl; external WS3DCoreLib;

procedure wAnimatorRotationGetParameters(anim: wAnimator; params: PwAnimatorRotation); cdecl; external WS3DCoreLib;

function wAnimatorSplineCreate(node: wNode; iPoints: Int32; points: PwVector3f;
         time: Int32; speed, tightness; Float32): wAnimator; cdecl; external WS3DCoreLib;

procedure wAnimatorSplineSetParameters(anim: wAnimator; params: wAnimatorSpline); cdecl; external WS3DCoreLib;

procedure wAnimatorSplineGetParameters(anim: wAnimator; params: PwAnimatorSpline); cdecl; external WS3DCoreLib;

function wAnimatorFadingCreate(node: wNode; delete_after: Int32; scale: Float32): wAnimator; cdecl; external WS3DCoreLib ;

//For all animators
procedure wAnimatorSetEnable(anim: wAnimator; enable: Boolean; timeNow: UInt32); cdecl; external WS3DCoreLib;

function wAnimatorIsEnable(anim: wAnimator): Boolean; cdecl; external WS3DCoreLib;

function wAnimatorIsFinished(anim: wAnimator): Boolean; cdecl; external WS3DCoreLib;

procedure wAnimatorSetStartTime(anim: wAnimator; time: UInt32; resetPauseTime: Boolean=true); cdecl; external WS3DCoreLib;

function wAnimatorGetStartTime(anim: wAnimator): UInt32; cdecl; external WS3DCoreLib;

function wAnimatorGetType(anim: wAnimator): wSceneNodeAnimatorType; cdecl; external WS3DCoreLib;

///wTpsCamera///

function wTpsCameraCreate(name: Pchar): wNode; cdecl; external WS3DCoreLib;

procedure wTpsCameraDestroy(ctrl: wNode); cdecl; external WS3DCoreLib;

procedure wTpsCameraUpdate(ctrl: wNode); cdecl; external WS3DCoreLib;

procedure wTpsCameraSetTarget(ctrl, node: wNode); cdecl; external WS3DCoreLib ;

procedure wTpsCameraRotateHorizontal(ctrl: wNode; rotVal: Float32); cdecl; external WS3DCoreLib ;

procedure wTpsCameraRotateVertical(ctrl: wNode; rotVal: Float32); cdecl; external WS3DCoreLib ;

procedure wTpsCameraSetHorizontalRotation(ctrl: wNode; rotVal: Float32); cdecl; external WS3DCoreLib;

procedure wTpsCameraSetVerticalRotation(ctrl: wNode; rotVal: Float32); cdecl; external WS3DCoreLib;

procedure wTpsCameraZoomIn(ctrl: wNode); cdecl; external WS3DCoreLib;

procedure wTpsCameraZoomOut(ctrl: wNode); cdecl; external WS3DCoreLib;

function wTpsCameraGetCamera(ctrl: wNode): wNode; cdecl; external WS3DCoreLib ;

procedure wTpsCameraSetCurrentDistance(ctrl:wNode; dist:Float32); cdecl; external WS3DCoreLib ;

procedure wTpsCameraSetRelativeTarget(ctrl: wNode; target: wVector3f); cdecl; external WS3DCoreLib ;

procedure wTpsCameraSetDefaultDistanceDirection(ctrl: wNode; dir: wVector3f); cdecl; external WS3DCoreLib ;

procedure wTpsCameraSetMaximalDistance(ctrl: wNode; value: Float32); cdecl; external WS3DCoreLib ;

procedure wTpsCameraSetMinimalDistance(ctrl: wNode; value: Float32); cdecl; external WS3DCoreLib ;

procedure wTpsCameraSetZoomStepSize(ctrl: wNode; value: Float32); cdecl; external WS3DCoreLib ;

procedure wTpsCameraSetHorizontalSpeed(ctrl: wNode; value: Float32); cdecl; external WS3DCoreLib ;

procedure wTpsCameraSetVerticalSpeed(ctrl: wNode; value: Float32); cdecl; external WS3DCoreLib ;


///wFpsCamera///

function wFpsCameraCreate(rotateSpeed: Float32 = 100.0;
           moveSpeed: Float32 = 0.1;
           keyMapArray: PwKeyMapArray = nil;
           keyMapSize: Int32 = 0;
           noVerticalMovement: Boolean = false;
           jumpSpeed: Float32 = 0): wNode; cdecl; external WS3DCoreLib;

function wFpsCameraGetSpeed(camera: wNode): Float32; cdecl; external WS3DCoreLib;

procedure wFpsCameraSetSpeed(camera: wNode; newSpeed: Float32); cdecl; external WS3DCoreLib;

function wFpsCameraGetRotationSpeed(camera: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wFpsCameraSetRotationSpeed(camera: wNode; rotSpeed: Float32); cdecl; external WS3DCoreLib;

procedure wFpsCameraSetMaxVerticalAngle(camera: wNode; newValue: Float32); cdecl; external WS3DCoreLib;

function wFpsCameraGetMaxVerticalAngle(camera: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wFpsCameraSetKeyMap(camera: wNode; map: PwKeyMap; count: UInt32); cdecl; external WS3DCoreLib ;

procedure wFpsCameraSetVerticalMovement(camera: wNode; value: Boolean); cdecl; external WS3DCoreLib ;

procedure wFpsCameraSetInvertMouse(camera: wNode; value: Boolean); cdecl; external WS3DCoreLib ;

///wMayaCamera///

function wMayaCameraCreate(rotateSpeed, zoomSpeed, moveSpeed: Float32): wNode; cdecl; external WS3DCoreLib ;

///wCamera///
function wCameraCreate(pos, target: wVector3f): wNode; cdecl; external WS3DCoreLib ;

procedure wCameraSetTarget(camera: wNode; target: wVector3f); cdecl; external WS3DCoreLib ;

function wCameraGetTarget(camera: wNode): wVector3f;  cdecl; external WS3DCoreLib ;

function wCameraGetUpDirection(camera: wNode): wVector3f;  cdecl; external WS3DCoreLib ;

procedure wCameraSetUpDirection(camera: wNode; upDir: wVector3f); cdecl; external WS3DCoreLib ;

procedure wCameraGetOrientation(camera: wNode; upDir, forwardDir, rightDir: PwVector3f); cdecl; external WS3DCoreLib ;

procedure wCameraSetClipDistance(camera: wNode; farDistance, nearDistance: Float32); cdecl; external WS3DCoreLib ;

procedure wCameraSetActive(camera: wNode); cdecl; external WS3DCoreLib ;

procedure wCameraSetFov(camera: wNode; fov: Float32); cdecl; external WS3DCoreLib ;

function wCameraGetFov(camera: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wCameraSetOrthogonal(camera: wNode; vec: wVector3f); cdecl; external WS3DCoreLib ;

procedure wCameraRevolve(camera: wNode; angleDeg, offset: wVector3f); cdecl; external WS3DCoreLib ;

procedure wCameraSetUpAtRightAngle(camera: wNode); cdecl; external WS3DCoreLib ;

procedure wCameraSetAspectRatio(camera: wNode; aspectRatio: Float32); cdecl; external WS3DCoreLib ;

procedure wCameraSetInputEnabled(camera: wNode; value: Boolean); cdecl; external WS3DCoreLib ;

function wCameraIsInputEnabled(camera: wNode): Boolean; cdecl; external WS3DCoreLib ;

procedure wCameraSetCollisionWithScene(camera: wNode;
           radius, gravity, offset: wVector3f;
           slidingValue:Float32= 0.0005); cdecl; external WS3DCoreLib ;


///wRtsCamera///
function wRtsCameraCreate(pos: wVector3f; offsetX,
                                          offsetZ,
                                          offsetDistance,
                                          offsetAngle: wVector2f;
                                          driftSpeed: Float32 = 100.0;
                                          scrollSpeed: Float32 = 5.0;
                                          mouseSpeedRelative: Float32 = 5.0;
                                          orbit: Float32 = 0.0;
                                          mouseButtonActive: wMouseButtons = wMB_RIGHT): wNode; cdecl; external WS3DCoreLib ;


///wCollision///

function wCollisionGroupCreate(): wSelector; cdecl; external WS3DCoreLib ;

procedure wCollisionGroupAddCollision(group, selector: wSelector); cdecl; external WS3DCoreLib ;

procedure wCollisionGroupRemoveAll(group: wSelector); cdecl; external WS3DCoreLib ;

procedure wCollisionGroupRemoveCollision(group, selector: wSelector); cdecl; external WS3DCoreLib ;

function wCollisionCreateFromMesh(mesh: wMesh; node: wNode; iframe: Int32):wSelector; cdecl; external WS3DCoreLib ;

function wCollisionCreateFromStaticMesh(staticMesh: wMesh; node: wNode): wSelector; cdecl; external WS3DCoreLib ;

function wCollisionCreateFromBatchingMesh(mesh: wMesh; node: wNode): wSelector; cdecl; external WS3DCoreLib ;

function wCollisionCreateFromMeshBuffer(meshbuffer: wMeshBuffer; node: wNode): wSelector; cdecl; external WS3DCoreLib ;

function wCollisionCreateFromOctreeMesh(mesh: wMesh; node: wNode; iframe: Int32 = 0): wSelector; cdecl; external WS3DCoreLib ;

function wCollisionCreateFromBox(node: wNode): wSelector; cdecl; external WS3DCoreLib ;

function wCollisionCreateFromTerrain(node: wNode; level_of_detail: Int32): wSelector; cdecl; external WS3DCoreLib ;

function wCollisionGetNodeFromCamera(camera: wNode): wNode; cdecl; external WS3DCoreLib ;

function wCollisionGetNodeFromRay(vectorStart, vectorEnd: PwVector3f): wNode; cdecl; external WS3DCoreLib ;

function wCollisionGetNodeChildFromRay(node: wNode; id: Int32; recurse: Boolean;
                                          vectorStart, vectorEnd: PwVector3f): wNode; cdecl; external WS3DCoreLib ;

function wCollisionGetNodeChildFromPoint(node: wNode;
                                           id: Int32;
					   recurse: Boolean;
					   vectorPoint: PwVector3f): wNode; cdecl; external WS3DCoreLib ;

function wCollisionGetNodeAndPointFromRay(vectorStart, vectorEnd, colPoint, normal: PwVector3f; id: Int32;
                                          rootNode: wNode): wNode; cdecl; external WS3DCoreLib ;

function wCollisionGetNodeFromScreen(screenPos: wVector2i; idBitMask: Int32 = 0;
                                     bNoDebugObjects: Boolean = false;
                                     root: wNode = nil): wNode; cdecl; external WS3DCoreLib ;

function wCollisionGetScreenCoordFrom3dPosition(pos: wVector3f): wVector2i; cdecl; external WS3DCoreLib ;

procedure wCollisionGetRayFromScreenCoord(camera: wNode; screenCoord: wVector2i;
                                     vectorStart, vectorEnd:PwVector3f); cdecl; external WS3DCoreLib;

function wCollisionGet3dPositionFromScreen(camera: wNode; screenPos: wVector2i;
           normal: wVector3f; distanceFromOrigin: Float32): wVector3f; cdecl; external WS3DCoreLib ;

function wCollisionGet2dPositionFromScreen(camera: wNode; screenPos: wVector2i): wVector2f; cdecl; external WS3DCoreLib ;

function wCollisionGetPointFromRay(ts: wSelector; vectorStart, vectorEnd, collisionPoint,
           vectorNormal: PwVector3f; collisionTriangle: PwTriangle;
           collNode: PwNode): Boolean; cdecl; external WS3DCoreLib ;

procedure wCollisionGetResultPosition(selector: wSelector;
           ellipsoidPosition, ellipsoidRadius, velocity, gravity: PwVector3f;
           slidingSpeed: Float32;
           outPosition, outHitPosition: PwVector3f;
           outFalling: PInt32); cdecl; external WS3DCoreLib ;

///wFile///

function wFileAddZipArchive(cptrFile: PChar; boIgnoreCase, boIgnorePaths: Boolean): Boolean; cdecl; external WS3DCoreLib ;

function wFileAddArchive(cptrFile: PChar; boIgnoreCase, boIgnorePaths: Boolean;
          aType: wFileArchiveType = wFAT_UNKNOWN; password: PChar): Boolean; cdecl; external WS3DCoreLib ;

function wFileAddPakArchive(cptrFile: PChar; boIgnoreCase, boIgnorePaths: Boolean): Boolean; cdecl; external WS3DCoreLib ;

function wFileAddDirectory(cptrFile: PChar; boIgnoreCase, boIgnorePaths: Boolean):Boolean; cdecl; external WS3DCoreLib ;

//Get the archive at a given index
function wFileGetArchiveByIndex(index: UInt32): wFileArchive; cdecl; external WS3DCoreLib ;

function wFileGetArchiveFileList(fArchive: wFileArchive): wFileList; cdecl; external WS3DCoreLib ;

function wFileGetArchiveType(fArchive: wFileArchive): wFileArchiveType; cdecl; external WS3DCoreLib ;

//Get the number of archives currently attached to the file system
function wFileGetArchivesCount(): UInt32; cdecl; external WS3DCoreLib ;

//Changes the search order of attached archives
procedure wFileMoveArchive(sourceIndex: UInt32; relative: Int32); cdecl; external WS3DCoreLib ;

//Removes an archive from the file system
procedure wFileRemoveArchiveByName(const fileName: PChar); cdecl; external WS3DCoreLib ;

procedure wFileRemoveArchiveByIndex(index: UInt32); cdecl; external WS3DCoreLib ;

procedure wFileRemoveArchive(fArchive: wFileArchive); cdecl; external WS3DCoreLib ;

//Opens a file based on its name   (from archive).
function wFileOpenForReadFromArchive(fArchive: wFileArchive; const cptrFile: PChar): wFile; cdecl; external WS3DCoreLib ;
//Opens a file based on its position in the file list.
function wFileOpenForReadByIndexFromArchive(fArchive: wFileArchive; fileIdx: UInt32): wFile; cdecl; external WS3DCoreLib;

///
procedure wFileSetWorkingDirectory(const cptrPath: PChar); cdecl; external WS3DCoreLib;

function wFileGetWorkingDirectory(): PChar; cdecl; external WS3DCoreLib;

function wFileIsExist(cptrFile: PChar): Boolean; cdecl; external WS3DCoreLib ;

function wFileGetAbsolutePath(cptrPath: PChar): PChar; cdecl; external WS3DCoreLib ;

//flatten a path and file name for example: "/you/me/../." becomes "/you"
function wFileGetFlattenPath(const directory, rootPath: PChar): PChar; cdecl; external WS3DCoreLib;

function wFileGetRelativePath(const cptrPath, directory: Pchar): PChar; cdecl; external WS3DCoreLib ;

function wFileGetBaseName(const cptrPath: PChar; keepExtension: Boolean): PChar; cdecl; external WS3DCoreLib ;

function wFileGetDirectory(const cptrPath: PChar): PChar; cdecl; external WS3DCoreLib ;

function wFileOpenForRead(const cptrFile: Pchar): wFile; cdecl; external WS3DCoreLib ;

function wFileRead(_file: wFile; buffer:Pointer; sizeToRead: UInt32): Int32; cdecl; external WS3DCoreLib ;

function wFileGetSize(_file:wFile): Int64; cdecl; external WS3DCoreLib ;





end.












