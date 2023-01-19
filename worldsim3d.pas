unit WorldSim3D;

{$mode ObjFPC}{$H+}

interface
uses
  SysUtils,
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
  PUInt64 = ^UInt64;
  UInt64 = dword;

  PUInt32 = ^UInt32;
  UInt32 = dword;

  PUInt16 = ^UInt16;
  UInt16 = word;

  PUInt8 = ^UInt8;
  UInt8 = byte;

  PInt64 = ^Int64;
  Int64 = longint;

  PInt32 = ^Int32;
  Int32 = longint;

  PInt16 = ^Int16;
  Int16 = smallint;

  PInt8 = ^Int8;
  Int8 = char;

  PFloat64 = ^Float64;
  Float64 = double;

  PFloat32 = ^Float32;
  Float32 = single;

  PwImage = ^wImage;
  wImage = UInt32;

  PwTexture = ^wTexture;
  wTexture = UInt32;

  PwFont = ^wFont;
  wFont = UInt32;

  PwGuiObject = ^wGuiObject;
  wGuiObject = UInt32;

  PwMesh = ^wMesh;
  wMesh = UInt32;

  PwMeshBuffer = ^wMeshBuffer;
  wMeshBuffer = UInt32;

  PwNode = ^wNode;
  wNode = UInt32;

  PwBody = ^wBody;
  wBody = UInt32;

  PwMaterial = ^wMaterial;
  wMaterial = UInt32;

  PwSelector = ^wSelector;
  wSelector = UInt32;

  PwEmitter = ^wEmitter;
  wEmitter = UInt32;

  PwAffector = ^wAffector;
  wAffector = UInt32;

  PwAnimator = ^wAnimator;
  wAnimator = UInt32;

  PwXmlReader = ^wXmlReader;
  wXmlReader = UInt32;

  PwXmlWriter = ^wXmlWriter;
  wXmlWriter = UInt32;

  PwFile = ^wFile;
  wFile = UInt32;

  PwFileArchive = ^wFileArchive;
  wFileArchive = UInt32;

  PwFileList = ^wFileList;
  wFileList = UInt32;

  PwAttribute = ^wAttribute;
  wAttribute = UInt32;

  PwSoundEffect = ^wSoundEffect;
  wSoundEffect = UInt32;

  PwSoundFilter = ^wSoundFilter;
  wSoundFilter = UInt32;

  PwSound = ^wSound;
  wSound = UInt32;

  PwSoundBuffer = ^wSoundBuffer;
  wSoundBuffer = UInt32;

  PwVideo = ^wVideo;
  wVideo = UInt32;

  PwPostEffect = ^wPostEffect;
  wPostEffect = UInt32;

  PwPacket = ^wPacket;
  wPacket = UInt32;

  PwMouseEventType = ^wMouseEventType;
  wMouseEventType =  Longint;
  const
    wMET_LMOUSE_PRESSED_DOWN = 0;
    wMET_RMOUSE_PRESSED_DOWN = 1;
    wMET_MMOUSE_PRESSED_DOWN = 2;
    wMET_LMOUSE_LEFT_UP = 3;
    wMET_RMOUSE_LEFT_UP = 4;
    wMET_MMOUSE_LEFT_UP = 5;
    wMET_MOUSE_MOVED = 6;
    wMET_MOUSE_WHEEL = 7;
    wMET_LMOUSE_DOUBLE_CLICK = 8;
    wMET_RMOUSE_DOUBLE_CLICK = 9;
    wMET_MMOUSE_DOUBLE_CLICK = 10;
    wMET_LMOUSE_TRIPLE_CLICK = 11;
    wMET_RMOUSE_TRIPLE_CLICK = 12;
    wMET_MMOUSE_TRIPLE_CLICK = 13;
    wMET_COUNT = 14;

  type
    PwMouseButtons = ^wMouseButtons;
    wMouseButtons =  Longint;
    const
      wMB_LEFT = $01;
      wMB_RIGHT = $02;
      wMB_MIDDLE = $04;
      wMB_EXTRA1 = $08; //not used
      wMB_EXTRA2 = $10; //not used
      wMB_FORCE_32_BIT = $7fffffff; //not for use!

  type
    PwVector2i = ^wVector2i;
    wVector2i = record
      x : Int32;
      y : Int32;
    end;
    const wVECTOR2i_ZERO: wVector2i = (x:0; y:0);
    const wVECTOR2i_ONE : wVector2i = (x:1; y:1);

  type
    PwMouseEvent = ^wMouseEvent;
    wMouseEvent = record
        action : wMouseEventType;
        delta : Float32;
        position : wVector2i;
        isShift : boolean;
        isControl : boolean;
      end;

    PwKeyCode = ^wKeyCode;
    wKeyCode =  Longint;
    Const
      wKC_UNKNOWN                 = $0;
      wKC_LBUTTON                 = $01; // Left mouse button
      wKC_RBUTTON                 = $02; // Right mouse button
      wKC_CANCEL                  = $03; // Control-break processing
      wKC_MBUTTON                 = $04; // Middle mouse button (three-button mouse)
      wKC_XBUTTON1                = $05; // Windows 2000/XP: X1 mouse button
      wKC_XBUTTON2                = $06; // Windows 2000/XP: X2 mouse button
      wKC_BACK                    = $08; // BACKSPACE key
      wKC_TAB                     = $09; // TAB key
      wKC_CLEAR                   = $0C; // CLEAR key
      wKC_RETURN                  = $0D; // ENTER key
      wKC_SHIFT                   = $10; // SHIFT key
      wKC_CONTROL                 = $11; // CTRL key
      wKC_MENU                    = $12; // ALT key
      wKC_PAUSE                   = $13; // PAUSE key
      wKC_CAPITAL                 = $14; // CAPS LOCK key
      wKC_KANA                    = $15; // IME Kana mode
      wKC_HANGUEL                 = $15; // IME Hanguel mode (maintained for compatibility use KEY_HANGUL)
      wKC_HANGUL                  = $15; // IME Hangul mode
      wKC_JUNJA                   = $17; // IME Junja mode
      wKC_FINAL                   = $18; // IME final mode
      wKC_HANJA                   = $19; // IME Hanja mode
      wKC_KANJI                   = $19; // IME Kanji mode
      wKC_ESCAPE                  = $1B; // ESC key
      wKC_CONVERT                 = $1C; // IME convert
      wKC_NONCONVERT              = $1D; // IME nonconvert
      wKC_ACCEPT                  = $1E; // IME accept
      wKC_MODECHANGE              = $1F; // IME mode change request
      wKC_SPACE                   = $20; // SPACEBAR
      wKC_PRIOR                   = $21; // PAGE UP key
      wKC_NEXT                    = $22; // PAGE DOWN key
      wKC_END                     = $23; // END key
      wKC_HOME                    = $24; // HOME key
      wKC_LEFT                    = $25; // LEFT ARROW key
      wKC_UP                      = $26; // UP ARROW key
      wKC_RIGHT                   = $27; // RIGHT ARROW key
      wKC_DOWN                    = $28; // DOWN ARROW key
      wKC_SELECT                  = $29; // SELECT key
      wKC_PRINT                   = $2A; // PRINT key
      wKC_EXECUT                  = $2B; // EXECUTE key
      wKC_SNAPSHOT                = $2C; // PRINT SCREEN key
      wKC_INSERT                  = $2D; // INS key
      wKC_DELETE                  = $2E; // DEL key
      wKC_HELP                    = $2F; // HELP key
      wKC_KEY_0                   = $30; // 0 key
      wKC_KEY_1                   = $31; // 1 key
      wKC_KEY_2                   = $32; // 2 key
      wKC_KEY_3                   = $33; // 3 key
      wKC_KEY_4                   = $34; // 4 key
      wKC_KEY_5                   = $35; // 5 key
      wKC_KEY_6                   = $36; // 6 key
      wKC_KEY_7                   = $37; // 7 key
      wKC_KEY_8                   = $38; // 8 key
      wKC_KEY_9                   = $39; // 9 key
      wKC_KEY_A                   = $41; // A key
      wKC_KEY_B                   = $42; // B key
      wKC_KEY_C                   = $43; // C key
      wKC_KEY_D                   = $44; // D key
      wKC_KEY_E                   = $45; // E key
      wKC_KEY_F                   = $46; // F key
      wKC_KEY_G                   = $47; // G key
      wKC_KEY_H                   = $48; // H key
      wKC_KEY_I                   = $49; // I key
      wKC_KEY_J                   = $4A; // J key
      wKC_KEY_K                   = $4B; // K key
      wKC_KEY_L                   = $4C; // L key
      wKC_KEY_M                   = $4D; // M key
      wKC_KEY_N                   = $4E; // N key
      wKC_KEY_O                   = $4F; // O key
      wKC_KEY_P                   = $50; // P key
      wKC_KEY_Q                   = $51; // Q key
      wKC_KEY_R                   = $52; // R key
      wKC_KEY_S                   = $53; // S key
      wKC_KEY_T                   = $54; // T key
      wKC_KEY_U                   = $55; // U key
      wKC_KEY_V                   = $56; // V key
      wKC_KEY_W                   = $57; // W key
      wKC_KEY_X                   = $58; // X key
      wKC_KEY_Y                   = $59; // Y key
      wKC_KEY_Z                   = $5A; // Z key
      wKC_LWIN                    = $5B; // Left Windows key (Microsoft® Natural® keyboard)
      wKC_RWIN                    = $5C; // Right Windows key (Natural keyboard)
      wKC_APPS                    = $5D; // Applications key (Natural keyboard)
      wKC_SLEEP                   = $5F; // Computer Sleep key
      wKC_NUMPAD0                 = $60; // Numeric keypad 0 key
      wKC_NUMPAD1                 = $61; // Numeric keypad 1 key
      wKC_NUMPAD2                 = $62; // Numeric keypad 2 key
      wKC_NUMPAD3                 = $63; // Numeric keypad 3 key
      wKC_NUMPAD4                 = $64; // Numeric keypad 4 key
      wKC_NUMPAD5                 = $65; // Numeric keypad 5 key
      wKC_NUMPAD6                 = $66; // Numeric keypad 6 key
      wKC_NUMPAD7                 = $67; // Numeric keypad 7 key
      wKC_NUMPAD8                 = $68; // Numeric keypad 8 key
      wKC_NUMPAD9                 = $69; // Numeric keypad 9 key
      wKC_MULTIPLY                = $6A; // Multiply key
      wKC_ADD                     = $6B; // Add key
      wKC_SEPARATOR               = $6C; // Separator key
      wKC_SUBTRACT                = $6D; // Subtract key
      wKC_DECIMAL                 = $6E; // Decimal key
      wKC_DIVIDE                  = $6F; // Divide key
      wKC_F1                      = $70; // F1 key
      wKC_F2                      = $71; // F2 key
      wKC_F3                      = $72; // F3 key
      wKC_F4                      = $73; // F4 key
      wKC_F5                      = $74; // F5 key
      wKC_F6                      = $75; // F6 key
      wKC_F7                      = $76; // F7 key
      wKC_F8                      = $77; // F8 key
      wKC_F9                      = $78; // F9 key
      wKC_F10                     = $79; // F10 key
      wKC_F11                     = $7A; // F11 key
      wKC_F12                     = $7B; // F12 key
      wKC_F13                     = $7C; // F13 key
      wKC_F14                     = $7D; // F14 key
      wKC_F15                     = $7E; // F15 key
      wKC_F16                     = $7F; // F16 key
      wKC_F17                     = $80; // F17 key
      wKC_F18                     = $81; // F18 key
      wKC_F19                     = $82; // F19 key
      wKC_F20                     = $83; // F20 key
      wKC_F21                     = $84; // F21 key
      wKC_F22                     = $85; // F22 key
      wKC_F23                     = $86; // F23 key
      wKC_F24                     = $87; // F24 key
      wKC_NUMLOCK                 = $90; // NUM LOCK key
      wKC_SCROLL                  = $91; // SCROLL LOCK key
      wKC_LSHIFT                  = $A0; // Left SHIFT key
      wKC_RSHIFT                  = $A1; // Right SHIFT key
      wKC_LCONTROL                = $A2; // Left CONTROL key
      wKC_RCONTROL                = $A3; // Right CONTROL key
      wKC_LMENU                   = $A4; // Left MENU key
      wKC_RMENU                   = $A5; // Right MENU key
      wKC_BROWSER_BACK            = $A6; // Browser Back key
      wKC_BROWSER_FORWARD         = $A7; // Browser Forward key
      wKC_BROWSER_REFRESH         = $A8; // Browser Refresh key
      wKC_BROWSER_STOP            = $A9; // Browser Stop key
      wKC_BROWSER_SEARCH          = $AA; // Browser Search key
      wKC_BROWSER_FAVORITES       = $AB; // Browser Favorites key
      wKC_BROWSER_HOME            = $AC; // Browser Start and Home key
      wKC_VOLUME_MUTE             = $AD; // Volume Mute key
      wKC_VOLUME_DOWN             = $AE; // Volume Down key
      wKC_VOLUME_UP               = $AF; // Volume Up key
      wKC_MEDIA_NEXT_TRACK        = $B0; // Next Track key
      wKC_MEDIA_PREV_TRACK        = $B1; // Previous Track key
      wKC_MEDIA_STOP              = $B2; // Stop Media key
      wKC_MEDIA_PLAY_PAUSE        = $B3; // Play/Pause Media key
      wKC_OEM_1                   = $BA; // for US    ";:"
      wKC_PLUS                    = $BB; // Plus Key   "+"
      wKC_COMMA                   = $BC; // Comma Key  ","
      wKC_MINUS                   = $BD; // Minus Key  "-"
      wKC_PERIOD                  = $BE; // Period Key "."
      wKC_OEM_2                   = $BF; // for US    "/?"
      wKC_OEM_3                   = $C0; // for US    "`~"
      wKC_OEM_4                   = $DB; // for US    "[{"
      wKC_OEM_5                   = $DC; // for US    "\|"
      wKC_OEM_6                   = $DD; // for US    "]}"
      wKC_OEM_7                   = $DE; // for US    "'""
      wKC_OEM_8                   = $DF; // None
      wKC_OEM_AX                  = $E1; // for Japan "AX"
      wKC_OEM_102                 = $E2; // "<>" or "\|"
      wKC_ATTN                    = $F6; // Attn key
      wKC_CRSEL                   = $F7; // CrSel key
      wKC_EXSEL                   = $F8; // ExSel key
      wKC_EREOF                   = $F9; // Erase EOF key
      wKC_PLAY                    = $FA; // Play key
      wKC_ZOOM                    = $FB; // Zoom key
      wKC_PA1                     = $FD; // PA1 key
      wKC_OEM_CLEAR               = $FE; // Clear key
      wKC_NONE                    = $FF; // usually no key mapping, but some laptops use it for fn key

      wKC_KEY_CODES_COUNT         = $100; // this is not a key, but the amount of keycodes there are.

  type
    PwKeyDirection = ^wKeyDirection;
    wKeyDirection =  Longint;
    const
      wKD_UP = 0;
      wKD_DOWN = 1;

  type
    PwKeyEvent = ^wKeyEvent;
    wKeyEvent = record
      key : wKeyCode;
      direction : wKeyDirection;
      isShift : boolean;
      isControl :boolean;
    end;

    PwKeyAction = ^wKeyAction;
    wKeyAction =  Longint;
    const
      wKA_MOVE_FORWARD = 0;
      wKA_MOVE_BACKWARD = 1;
      wKA_STRAFE_LEFT = 2;
      wKA_STRAFE_RIGHT = 3;
      wKA_JUMP_UP = 4;
      wKA_COUNT = 5;
      wKA_FORCE_32BIT = $7fffffff;

  type
    PwKeyMap = ^wKeyMap;
    wKeyMap = record
      Action : wKeyAction;
      KeyCode : wKeyCode;
    end;

  type
    wKeyMapArray=array[0..7] of wKeyMap;
    PwKeyMapArray=^wKeyMapArray;

  const wKeyMapDefault:wKeyMapArray=(
        (Action: wKA_MOVE_FORWARD; KeyCode: wKC_KEY_W),
        (Action: wKA_MOVE_FORWARD; keyCode: wKC_UP),
        (Action: wKA_MOVE_BACKWARD; keyCode: wKC_KEY_S),
        (Action: wKA_MOVE_BACKWARD; keyCode: wKC_DOWN),
        (Action: wKA_STRAFE_LEFT; keyCode: wKC_KEY_A),
        (Action: wKA_STRAFE_LEFT; keyCode: wKC_LEFT),
        (Action: wKA_STRAFE_RIGHT; keyCode: wKC_KEY_D),
        (Action: wKA_STRAFE_RIGHT; keyCode: wKC_RIGHT)
        );

  type
    PwJoystickPovHat = ^wJoystickPovHat;
    wJoystickPovHat =  Longint;
    const
      wJPH_PRESENT = 0;  //A hat is definitely present.
      wJPH_ABSENT  = 1;  //A hat is definitely not present.
      wJPH_UNKNOWN = 2;  //The presence or absence of a hat cannot be determined.


  type
    PwJoystickInfo = ^wJoystickInfo;
    wJoystickInfo = record
      //Note: with a Linux device, the POV hat (if any) will use two axes.
      //These will be included in this count.
      Axes : UInt32; //The number of axes that the joystick has, i.e. X, Y, Z, R, U, V.
      Buttons : UInt32; //The number of buttons that the joystick has.

      //This is an internal WS3D index; it does not map directly to any particular hardware joystick.
      joyId : UInt8; //The ID of the joystick.
      joyName : Pchar;

      //A Windows device will identify the presence or absence or the POV hat.
      //A Linux device cannot, and will always return wJPH_UNKNOWN.
      //Mac OSX not supported!
      PovHat : wJoystickPovHat;
    end;
   const wNUMBER_OF_BUTTONS =32;
         wAXIS_X =0;
         wAXIS_Y =1;
         wAXIS_Z =2;
         wAXIS_R =3;
         wAXIS_U =4;
         wAXIS_V =5;
         wNUMBER_OF_AXES =6;

  type
    PwJoystickEvent = ^wJoystickEvent;
    wJoystickEvent = record
        joyId : UInt8; //The ID of the joystick which generated this event.
        ButtonStates : array[0..(wNUMBER_OF_BUTTONS)-1] of boolean; //A helper function to check if a button is pressed
        Axis : array[0..(wNUMBER_OF_AXES)-1] of smallint;
        POV : UInt16;
      end;

    PwLoggingLevel = ^wLoggingLevel;
    wLoggingLevel =  Longint;
    const
      wLL_DEBUG = 0; // Used for printing information helpful in debugging.
      wLL_INFORMATION = 1; // Useful information to print. For example hardware infos or something started/stopped.
      wLL_WARNING = 2; // Warnings that something isn't as expected and can cause oddities.
      wLL_ERROR = 3; // Something did go wrong.
      wLL_NONE = 4; // Logs with wLL_NONE will never be filtered. And used as filter it will remove all logging except wLL_NONE messages.

  type
    PwLoggingEvent = ^wLoggingEvent;
    wLoggingEvent = record
      Level : wLoggingLevel;
      Text : Pchar;
    end;

    PwUserEvent = ^wUserEvent;
    wUserEvent = record
      UserData1 : Int32;
      UserData2 : Int32;
    end;

    PwEventType = ^wEventType;
    wEventType =  Longint;
    const
      wET_GUI_EVENT = 0;
      wET_MOUSE_INPUT_EVENT = 1;
      wET_KEY_INPUT_EVENT = 2;
      wET_JOYSTICK_INPUT_EVENT = 3;
      wET_LOG_TEXT_EVENT = 4;
      wET_USER_EVENT = 5;
      wET_FORCE_32_BIT = $7fffffff;

  type
    PwGuiCallerType = ^wGuiCallerType;
    wGuiCallerType =  Longint;
    const
      wGCT_ELEMENT_FOCUS_LOST = 0; //A gui element has lost its focus.GUIEvent.Caller is losing the focus to GUIEvent.Element. If the event is absorbed then the focus will not be changed.
      wGCT_ELEMENT_FOCUSED = 1; //A gui element has got the focus. If the event is absorbed then the focus will not be changed.
      wGCT_ELEMENT_HOVERED = 2; //The mouse cursor hovered over a gui element. If an element has sub-elements you also get this message for the subelements
      wGCT_ELEMENT_LEFT = 3; //The mouse cursor left the hovered element. If an element has sub-elements you also get this message for the subelements
      wGCT_ELEMENT_CLOSED = 4; //An element would like to close. Windows and context menus use this event when they would like to close, this can be cancelled by absorbing the event.
      wGCT_BUTTON_CLICKED = 5; //A button was clicked.
      wGCT_SCROLL_BAR_CHANGED = 6; //A scrollbar has changed its position.
      wGCT_CHECKBOX_CHANGED = 7; //A checkbox has changed its check state.
      wGCT_LISTBOX_CHANGED = 8; //A new item in a listbox was selected. NOTE: You also get this event currently when the same item was clicked again after more than 500 ms.
      wGCT_LISTBOX_SELECTED_AGAIN = 9; //An item in the listbox was selected, which was already selected. NOTE: You get the event currently only if the item was clicked again within 500 ms or selected by "enter" or "space".
      wGCT_FILE_SELECTED = 10; //A file has been selected in the file dialog.
      wGCT_DIRECTORY_SELECTED = 11; //A directory has been selected in the file dialog.
      wGCT_FILE_CHOOSE_DIALOG_CANCELLED = 12; //A file open dialog has been closed without choosing a file.
      wGCT_MESSAGEBOX_YES = 13; //'Yes' was clicked on a messagebox
      wGCT_MESSAGEBOX_NO = 14; //'No' was clicked on a messagebox
      wGCT_MESSAGEBOX_OK = 15; //'OK' was clicked on a messagebox
      wGCT_MESSAGEBOX_CANCEL = 16; //'Cancel' was clicked on a messagebox
      wGCT_EDITBOX_ENTER = 17; //In an editbox 'ENTER' was pressed.
      wGCT_EDITBOX_CHANGED = 18; //The text in an editbox was changed. This does not include automatic changes in text-breaking.
      wGCT_EDITBOX_MARKING_CHANGED = 19; //The marked area in an editbox was changed.
      wGCT_TAB_CHANGED = 20; //The tab was changed in an tab control.
      wGCT_MENU_ITEM_SELECTED = 21; //A menu item was selected in a (context) menu.
      wGCT_COMBO_BOX_CHANGED = 22; //The selection in a combo box has been changed.
      wGCT_SPINBOX_CHANGED = 23; //The value of a spin box has changed.
      wGCT_TABLE_CHANGED = 24; //A table has changed.
      wGCT_TABLE_HEADER_CHANGED = 25;
      wGCT_TABLE_SELECTED_AGAIN = 26;
      wGCT_TREEVIEW_NODE_DESELECT = 27; //A tree view node lost selection. See IGUITreeView::getLastEventNode().
      wGCT_TREEVIEW_NODE_SELECT = 28; //A tree view node was selected. See IGUITreeView::getLastEventNode().
      wGCT_TREEVIEW_NODE_EXPAND = 29; //A tree view node was expanded. See IGUITreeView::getLastEventNode().
      wGCT_TREEVIEW_NODE_COLLAPSE = 30; //A tree view node was collapsed. See IGUITreeView::getLastEventNode().
      wGCT_RADIOBUTTONGROUP_CHANGED = 31; //new
      wGCT_RADIOCHECKBOXGROUP_CHANGED = 32; //new
      wGCT_COUNT = 33; //No real event. Just for convenience to get number of events.

  type
    PwGuiEvent = ^wGuiEvent;
    wGuiEvent = record
      id : Int32;
      name : Pchar;
      event : wGuiCallerType;
      position : wVector2i;
      caller : PwGuiObject;
    end;

    PwGuiMessageBoxFlags = ^wGuiMessageBoxFlags;
    wGuiMessageBoxFlags =  Longint;
    const
      wGMBF_OK = $1; //Flag for the ok button.
      wGMBF_CANCEL = $2; //Flag for the cancel button.
      wGMBF_YES = $4; //Flag for the yes button.
      wGMBF_NO = $8; //Flag for the no button.
      wGMBF_FORCE_32BIT = $7fffffff; //This value is not used. It only forces this enumeration to compile in 32 bit.

  type
    PwFogType = ^wFogType;
    wFogType =  Longint;
    const
      wFT_EXP = 0;
      wFT_LINEAR = 1;
      wFT_EXP2 = 2;

  type
    PwVector2f = ^wVector2f;
    wVector2f = record
      x : Float32;
      y : Float32;
    end;
    const wVECTOR2f_ZERO : wVector2f = (x: 0; y:0);
          wVECTOR2f_ONE  : wVector2f = (x: 1; y:1);
  type
    PwVector2u = ^wVector2u;
    wVector2u = record
      x : UInt32;
      y : UInt32;
    end;
    const wVECTOR2u_ZERO : wVector2u = (x: 0; y: 0);
          wVECTOR2u_ONE  : wVector2u = (x: 1; y: 1);

          wDEFAULT_SCREENSIZE : wVector2u = (x: 800; y: 600);

  type
    PwVector3f = ^wVector3f;
    wVector3f = record
      x : Float32;
      y : Float32;
      z : Float32;
    end;
    const wVECTOR3f_ZERO     : wVector3f = (x:  0.0; y:  0.0; z:  0.0);
          wVECTOR3f_ONE      : wVector3f = (x:  1.0; y:  1.0; z:  1.0);
          wVECTOR3f_UP       : wVector3f = (x:  0.0; y:  1.0; z:  0.0);
          wVECTOR3f_DOWN     : wVector3f = (x:  0.0; y: -1.0; z:  0.0);
          wVECTOR3f_FORWARD  : wVector3f = (x:  0.0; y:  0.0; z: -1.0);
          wVECTOR3f_BACKWARD : wVector3f = (x:  0.0; y:  0.0; z:  1.0);
          wVECTOR3f_RIGHT    : wVector3f = (x:  1.0; y:  0.0; z:  0.0);
          wVECTOR3f_LEFT     : wVector3f = (x: -1.0; y:  0.0; z:  0.0);

  type
    PwVector3i = ^wVector3i;
    wVector3i = record
      x : Int32;
      y : Int32;
      z : Int32;
    end;
    const wVECTOR3i_ZERO     : wVector3i = (x:  0; y:  0; z:  0);
          wVECTOR3i_ONE      : wVector3i = (x:  1; y:  1; z:  1);
          wVECTOR3i_UP       : wVector3i = (x:  0; y:  1; z:  0);
          wVECTOR3i_DOWN     : wVector3i = (x:  0; y: -1; z:  0);
          wVECTOR3i_FORWARD  : wVector3i = (x:  0; y:  0; z: -1);
          wVECTOR3i_BACKWARD : wVector3i = (x:  0; y:  0; z:  1);
          wVECTOR3i_RIGHT    : wVector3i = (x:  1; y:  0; z:  0);
          wVECTOR3i_LEFT     : wVector3i = (x: -1; y:  0; z:  0);

  type
    PwVector3u = ^wVector3u;
    wVector3u = record
      x : UInt32;
      y : UInt32;
      z : UInt32;
    end;
    const wVECTOR3u_ZERO : wVector3u = (x:  0; y:  0; z:  0);
          wVECTOR3u_ONE  : wVector3u = (x:  1; y:  1; z:  1);

  type
    PwColor4s = ^wColor4s;
    wColor4s = record
      alpha : UInt8;
      red : UInt8;
      green : UInt8;
      blue : UInt8;
    end;
    const wCOLOR4s_ZERO       : wColor4s = (alpha:0;   red:0  ; green: 0  ; blue: 0);
          wCOLOR4s_WHITE      : wColor4s = (alpha:255; red:255; green: 255; blue: 255);
          wCOLOR4s_DARKGREY   : wColor4s = (alpha:255; red:64;	green:64;   blue:64);
          wCOLOR4s_GREY       : wColor4s = (alpha:255; red:128; green:128;  blue:128);
          wCOLOR4s_SILVER     : wColor4s = (alpha:255; red:192; green:192;  blue:192);
          wCOLOR4s_BLACK      : wColor4s = (alpha:255; red:0;	green:0;    blue:0);
          wCOLOR4s_RED        : wColor4s = (alpha:255; red:255; green:0;    blue:0);
          wCOLOR4s_DARKRED    : wColor4s = (alpha:255; red:140; green:0;    blue:0);
          wCOLOR4s_MAROON     : wColor4s = (alpha:255; red:128; green:0;    blue:0);
          wCOLOR4s_GREEN      : wColor4s = (alpha:255; red:0;	green:255;  blue:0);
          wCOLOR4s_LIME       : wColor4s = (alpha:255; red:250; green:128;  blue:114);
          wCOLOR4s_DARKGREEN  : wColor4s = (alpha:255; red:0;	green:100;  blue:0);
          wCOLOR4s_OLIVE      : wColor4s = (alpha:255; red:240; green:128;  blue:128);
          wCOLOR4s_BLUE       : wColor4s = (alpha:255; red:0;	green:0;    blue:255);
          wCOLOR4s_DARKBLUE   : wColor4s = (alpha:255; red:0;	green:0;    blue:139);
          wCOLOR4s_NAVY       : wColor4s = (alpha:255; red:0;	green:0;    blue:128);
          wCOLOR4s_SKYBLUE    : wColor4s = (alpha:255; red:135; green:206;  blue:235);
          wCOLOR4s_MAGENTA    : wColor4s = (alpha:255; red:255; green:0;    blue:255);
          wCOLOR4s_PINK       : wColor4s = (alpha:255; red:255; green:192;  blue:203);
          wCOLOR4s_DEEPPINK   : wColor4s = (alpha:255; red:255; green:20;   blue:147);
          wCOLOR4s_INDIGO     : wColor4s = (alpha:255; red:75 ; green:0;    blue:130);
          wCOLOR4s_YELLOW     : wColor4s = (alpha:255; red:255; green:255;  blue:0);
          wCOLOR4s_GOLD       : wColor4s = (alpha:255; red:255; green:215;  blue:0);
          wCOLOR4s_KHAKI      : wColor4s = (alpha:255; red:245; green:230;  blue:140);
          wCOLOR4s_ORANGE     : wColor4s = (alpha:255; red:255; green:68;   blue:0);
          wCOLOR4s_DARKORANGE : wColor4s = (alpha:255; red:255; green:140;  blue:0);
          wCOLOR4s_ORANGERED  : wColor4s = (alpha:255; red:255; green:69;   blue:0);

  type
    PwColor4f = ^wColor4f;
    wColor4f = record
      alpha : Float32;
      red : Float32;
      green : Float32;
      blue : Float32;
    end;
    const wCOLOR4f_WHITE : wColor4f = (alpha:1.0; red:1.0; green:1.0; blue:1.0);
          wCOLOR4f_BLACK : wColor4f = (alpha:1.0; red:0.0; green:0.0; blue:0.0);

  type
    PwColor3s = ^wColor3s;
    wColor3s = record
      red : UInt8;
      green : UInt8;
      blue : UInt8;
    end;
    const wCOLOR3s_WHITE : wColor3s = (red:255;	green:255; blue:255);
          wCOLOR3s_BLACK : wColor3s = (red:0;	green:0;   blue:0);

  type
    PwColor3f = ^wColor3f;
    wColor3f = record
      red : Float32;
      green : Float32;
      blue : Float32;
    end;
    const wCOLOR3f_WHITE:wColor3f = (red:1.0; green:1.0; blue:1.0);
          wCOLOR3f_BLACK:wColor3f = (red:0.0; green:0.0; blue:0.0);

  type
    PwVert = ^wVert;
    wVert = record
      vertPos : wVector3f;
      vertNormal : wVector3f;
      vertColor : wColor4s; // The 32bit ARGB color of the vertex
      texCoords : wVector2f;
    end;      PwParticleEmitter = ^wParticleEmitter;

    wParticleEmitter = record
      direction : wVector3f;
      minParticlesPerSecond : UInt32;
      maxParticlesPerSecond : UInt32;
      minStartColor : wColor4s;
      maxStartColor : wColor4s;
      lifeTimeMin : UInt32;
      lifeTimeMax : UInt32;
      maxAnglesDegrees : Int32;
      minStartSize : wVector2f;
      maxStartSize : wVector2f;
    end;

    PwParticleEmitterType = ^wParticleEmitterType;
    wParticleEmitterType =  Longint;
    const
      wPET_POINT = 0;
      wPET_ANIMATED_MESH = 1;
      wPET_BOX = 2;
      wPET_CYLINDER = 3;
      wPET_MESH = 4;
      wPET_RING = 5;
      wPET_SPHERE = 6;
      wPET_COUNT = 7;

  type
    PwParticleCylinderEmitter = ^wParticleCylinderEmitter;
    wParticleCylinderEmitter = record
      center : wVector3f;
      length : Float32;
      normal : wVector3f;
      getOutlineOnly : boolean;
      radius : Float32;
    end;

    PwParticleMeshEmitter = ^wParticleMeshEmitter;
    wParticleMeshEmitter = record
      animMeshNode : PwNode; ///Для эмиттера анимированных мешей (это-НОД)
      animMeshName : Pchar;
      Mesh : PwMesh; ///Для эмиттера статических мешей (Это- статичный МЕШ)
      MeshName : Pchar;
      nodeId : Int32;
      useNormalDirection : boolean;
      normalDirectionModifier : Float32;
      everyMeshVertex : boolean;
    end;

    PwParticleRingEmitter = ^wParticleRingEmitter;
    wParticleRingEmitter = record
      center : wVector3f;
      radius : Float32;
      ringThickness : Float32;
    end;

    PwParticleSphereEmitter = ^wParticleSphereEmitter;
    wParticleSphereEmitter = record
      center : wVector3f;
      radius : Float32;
    end;

    PwParticleAffectorType = ^wParticleAffectorType;
    wParticleAffectorType =  Longint;
    const
      wPAT_NONE = 0;
      wPAT_ATTRACT = 1;
      wPAT_FADE_OUT = 2;
      wPAT_GRAVITY = 3;
      wPAT_ROTATE = 4;
      wPAT_SCALE = 5;
      wPAT_STOP = 6;
      wPAT_PUSH = 7;
      wPAT_SPLINE = 8;
      wPAT_COLOR_MORPH = 9;
      wPAT_COUNT = 10;

    type
      PwParticleAttractionAffector = ^wParticleAttractionAffector;
      wParticleAttractionAffector = record
        point : wVector3f;
        speed : Float32;
        attract : boolean;
        affectX : boolean;
        affectY : boolean;
        affectZ : boolean;
      end;

      PwParticleColorMorphAffector = ^wParticleColorMorphAffector;
      wParticleColorMorphAffector = record
        colorsList : PwColor4s;
        colorsCount : UInt32;
        timesList : PUInt32;
        timesCount : UInt32;
        smooth : boolean;
      end;

      PwParticlePushAffector = ^wParticlePushAffector;
      wParticlePushAffector = record
        furthestDistance : Float32;
        nearestDistance : Float32;
        columnDistance : Float32;
        center : wVector3f;
        strength : wVector3f;
        distant : boolean;
      end;

      PwParticleSplineAffector = ^wParticleSplineAffector;
      wParticleSplineAffector = record
        points : PwVector3f;
        pointsCount : UInt32;
        speed : Float32;
        tightness : Float32;
        attraction : Float32;
        deleteAtFinalPoint : boolean;
      end;

      PwTriangle = ^wTriangle;
      wTriangle = record
        pointA : wVector3f;
        pointB : wVector3f;
        pointC : wVector3f;
      end;
      const wTRIANGLE3f_ZERO : wTriangle = (pointA: (x:0;y:0;z:0);
                                            pointB: (x:0;y:0;z:0);
                                            pointC: (x:0;y:0;z:0));

  type
    PwAnimatorCollisionResponse = ^wAnimatorCollisionResponse;
    wAnimatorCollisionResponse = record
      world : PwSelector;
      targetNode : PwNode;
      ellipsoidRadius : wVector3f;
      gravity : wVector3f;
      animateTarget : boolean;
      ellipsoidTranslation : wVector3f;
      collisionPoint : wVector3f;
      collisionResultPosition : wVector3f;
      collisionTriangle : wTriangle;
      collisionNode : PwNode;
      isFalling : boolean;
      collisionOccured : boolean;
    end;

    PwSceneNodeAnimatorType = ^wSceneNodeAnimatorType;
    wSceneNodeAnimatorType =  Longint;
    const
      wSNAT_FLY_CIRCLE = 0; //Fly circle scene node animator.
      wSNAT_FLY_STRAIGHT = 1; //Fly straight scene node animator.
      wSNAT_FOLLOW_SPLINE = 2; //Follow spline scene node animator.
      wSNAT_ROTATION = 3; //Rotation scene node animator.
      wSNAT_TEXTURE = 4; //Texture scene node animator.
      wSNAT_DELETION = 5; //Deletion scene node animator.
      wSNAT_COLLISION_RESPONSE = 6; //Collision respose scene node animator.
      wSNAT_CAMERA_FPS = 7; //FPS camera animator.
      ESNAT_CAMERA_RTS = 8; //RTS camera animator
      wSNAT_CAMERA_MAYA = 9; //Maya camera animator.
      wSNAT_FOLLOW_CAMERA = 10;
      wSNAT_FADE = 11;
      wSNAT_COUNT = 12; //Amount of built-in scene node animators.
      wSNAT_UNKNOWN = 13; //Unknown scene node animator.
      wSNAT_FORCE_32_BIT = 14; //This enum is never used, it only forces the compiler to compile this enumeration to 32 bit.


  type
    { FLY CIRCLE ANIMATOR }
    PwAnimatorFlyingCircle = ^wAnimatorFlyingCircle;
    wAnimatorFlyingCircle = record
      center : wVector3f;
      direction : wVector3f;
      radius : Float32;
      radiusEllipsoid : Float32;
      speed : Float32;
    end;


    { FLY STRAIGHT ANIMATOR }
    PwAnimatorFlyingStraight = ^wAnimatorFlyingStraight;
    wAnimatorFlyingStraight = record
      startPoint : wVector3f;
      endPoint : wVector3f;
      timeForWay : UInt32;
      loopMode : boolean;
      pingPongMode : boolean;
    end;

    { SPLINE ANIMATOR }
    PwAnimatorSpline = ^wAnimatorSpline;
    wAnimatorSpline = record
      points : PwVector3f;
      pointsCount : UInt32;
      speed : Float32;
      tightness : Float32;
      loopMode : boolean;
      pingPongMode : boolean;
    end;

    { ROTATION ANIMATOR }
    PwAnimatorRotation = ^wAnimatorRotation;
    wAnimatorRotation = record
      rotation : wVector3f;
    end;

    { FOLLOW CAMERA ANIMATOR }
    PwAnimatorFollowCamera = ^wAnimatorFollowCamera;
    wAnimatorFollowCamera = record
      startPosition : wVector3f;
      axisXEnable : boolean;
      axisYEnable : boolean;
      axisZEnable : boolean;
    end;

    Ptag_wConstant = ^tag_wConstant;
    tag_wConstant = record
      next : Ptag_wConstant;
      name : Pchar;
      address : Int32;
      preset : Int32;
      data : PFloat32;
      count : Int32;
    end;
    wConstant = tag_wConstant;
    PwConstant = ^wConstant;

    PwDriverTypes = ^wDriverTypes;
    wDriverTypes =  Longint;
    const
      wDRT_NULL = 0; // a NULL device with no display
      wDRT_SOFTWARE = 1; // WorldSim3Ds default software renderer
      wDRT_BURNINGS_VIDEO = 2; // An improved quality software renderer
      wDRT_OPENGL = 3; // hardware accelerated OpenGL renderer
      wDRT_DIRECT3D9 = 4; // hardware accelerated DirectX 9 renderer
      wDRT_CHOICE_CONSOLE = 6;

  type
    PwDeviceTypes = ^wDeviceTypes;
    wDeviceTypes =  Longint;
    const
      wDT_BEST = 0;// This selection allows Irrlicht to choose the best device from the ones available.
      //without opening a window. It can render the output of the software drivers to the console as ASCII.
      //It only supports mouse and keyboard in Windows operating systems.

      wDT_WIN32 = 1;// A device native to Microsoft Windows. This device uses the Win32 API and works in all versions of Windows.
      wDT_WINCE = 2;// A device native to Windows CE devices.This device works on Windows Mobile, Pocket PC and Microsoft SmartPhone devices
      wDT_X11 = 3;// A device native to Unix style operating systems. This device uses the X11 windowing system and works in Linux,
      // Solaris, FreeBSD, OSX and other operating systems which support X11.

      wDT_OSX = 4;// A device native to Mac OSX. This device uses Apple's Cocoa API and works in Mac OSX 10.2 and above.
      wDT_SDL = 5;// A device which uses Simple DirectMedia Layer. The SDL device works under all platforms supported by SDL
      wDT_FRAMEBUFFER = 6;// A device for raw framebuffer access.Best used with embedded devices and mobile systems.
      // Does not need X11 or other graphical subsystems. May support hw-acceleration via OpenGL-ES for FBDirect

      wDT_CONSOLE = 7;// A simple text only device supported by all platforms. This device allows applications to run from the command line

  type
    { Vertex shader program versions }
    PwVertexShaderVersion = ^wVertexShaderVersion;
    wVertexShaderVersion =  Longint;
    const
      wVSV_1_1 = 0;
      wVSV_2_0 = 1;
      wVSV_2_a = 2;
      wVSV_3_0 = 3;
      wVSV_4_0 = 4;
      wVSV_4_1 = 5;
      wVSV_5_0 = 6;
      wVSV_COUNT = 7;

  type
    { Pixel shader program versions }
    PwPixelShaderVersion = ^wPixelShaderVersion;
    wPixelShaderVersion =  Longint;
    const
      wPSV_1_1 = 0;
      wPSV_1_2 = 1;
      wPSV_1_3 = 2;
      wPSV_1_4 = 3;
      wPSV_2_0 = 4;
      wPSV_2_a = 5;
      wPSV_2_b = 6;
      wPSV_3_0 = 7;
      wPSV_4_0 = 8;
      wPSV_4_1 = 9;
      wPSV_5_0 = 10;
      wPSV_COUNT = 11;

  type
    PwGeometryShaderVersion = ^wGeometryShaderVersion;
    wGeometryShaderVersion =  Longint;
    const
      wGSV_4_0 = 0;
      wGSV_COUNT = 1;

  type
    PwPrimitiveType = ^wPrimitiveType;
    wPrimitiveType =  Longint;
    const
      wPT_POINTS = 0; //All vertices are non-connected points.
      wPT_LINE_STRIP = 1; //All vertices form a single connected line.
      wPT_LINE_LOOP = 2; //Just as LINE_STRIP, but the last and the first vertex is also connected.
      wPT_LINES = 3; //Every two vertices are connected creating n/2 lines.
      wPT_TRIANGLE_STRIP = 4; //After the first two vertices each vertex defines a new triangle. Always the two last and the new one form a new triangle.
      wPT_TRIANGLE_FAN = 5; //After the first two vertices each vertex defines a new triangle. All around the common first vertex.
      wPT_TRIANGLES = 6; //Explicitly set all vertices for each triangle.
      wPT_QUAD_STRIP = 7; //After the first two vertices each further tw vetices create a quad with the preceding two.
      wPT_QUADS = 8; //Every four vertices create a quad.
      wPT_POLYGON = 9; //Just as LINE_LOOP, but filled.
      wPT_POINT_SPRITES = 10;
      wPT_COUNT = 11; ////Not for use!!!

  type
    PwShaderConstants = ^wShaderConstants;
    wShaderConstants =  Longint;
    const
      wSC_NO_PRESET = 0;
      wSC_INVERSE_WORLD = 1;
      wSC_WORLD_VIEW_PROJECTION = 2;
      wSC_CAMERA_POSITION = 3;
      wSC_TRANSPOSED_WORLD = 4;
      wSC_WORLD_VIEW = 5;
      wSC_CAMERA_FAR = 6;
      wSC_CAMERA_FAR_LEFT_UP = 7;
      wSC_WORLD = 8;

  const wShaderConstZero   = 0;
        wShaderConstOne    = 1;
        wShaderConstTwo    = 2;
        wShaderConstThree  = 3;

  type
    PwVideoFeatureQuery = ^wVideoFeatureQuery;
    wVideoFeatureQuery =  Longint;
    const
      wVDF_RENDER_TO_TARGET = 0;
      wVDF_HARDWARE_TL = 1;
      wVDF_MULTITEXTURE = 2;
      wVDF_BILINEAR_FILTER = 3;
      wVDF_MIP_MAP = 4;
      wVDF_MIP_MAP_AUTO_UPDATE = 5;
      wVDF_STENCIL_BUFFER = 6;
      wVDF_VERTEX_SHADER_1_1 = 7;
      wVDF_VERTEX_SHADER_2_0 = 8;
      wVDF_VERTEX_SHADER_3_0 = 9;
      wVDF_VERTEX_SHADER_4_0 = 10;
      wVDF_VERTEX_SHADER_4_2 = 11;
      wVDF_PIXEL_SHADER_1_1 = 12;
      wVDF_PIXEL_SHADER_1_2 = 13;
      wVDF_PIXEL_SHADER_1_3 = 14;
      wVDF_PIXEL_SHADER_1_4 = 15;
      wVDF_PIXEL_SHADER_2_0 = 16;
      wVDF_PIXEL_SHADER_3_0 = 17;
      wVDF_PIXEL_SHADER_4_0 = 18;
      wVDF_PIXEL_SHADER_4_2 = 19;
      wVDF_ARB_VERTEX_PROGRAM_1 = 20;
      wVDF_ARB_FRAGMENT_PROGRAM_1 = 21;
      wVDF_ARB_GLSL = 22;
      wVDF_HLSL = 23;
      wVDF_TEXTURE_NSQUARE = 24;
      wVDF_TEXTURE_NPOT = 25;
      wVDF_FRAMEBUFFER_OBJECT = 26;
      wVDF_VERTEX_BUFFER_OBJECT = 27;
      wVDF_ALPHA_TO_COVERAGE = 28;
      wVDF_COLOR_MASK = 29;
      wVDF_MULTIPLE_RENDER_TARGETS = 30;
      wVDF_MRT_BLEND = 31;
      wVDF_MRT_COLOR_MASK = 32;
      wVDF_MRT_BLEND_FUNC = 33;
      wVDF_GEOMETRY_SHADER = 34;
      wVDF_OCCLUSION_QUERY = 35;
      wVDF_POLYGON_OFFSET = 36;
      wVDF_BLEND_OPERATIONS = 37;
      wVDF_BLEND_SEPARATE = 38;
      wVDF_TEXTURE_MATRIX = 39;
      wVDF_TEXTURE_COMPRESSED_DXT = 40;
      wVDF_TEXTURE_COMPRESSED_PVRTC = 41;
      wVDF_TEXTURE_COMPRESSED_PVRTC2 = 42;
      wVDF_TEXTURE_COMPRESSED_ETC1 = 43;
      wVDF_TEXTURE_COMPRESSED_ETC2 = 44;
      wVDF_TEXTURE_CUBEMAP = 45;
      wVDF_COUNT = 46;

  type
    PwMaterialFlags = ^wMaterialFlags;
    wMaterialFlags =  Longint;
    const
      wMF_WIREFRAME = 0;
      wMF_POINTCLOUD = 1;
      wMF_GOURAUD_SHADING = 2;
      wMF_LIGHTING = 3;
      wMF_ZBUFFER = 4;
      wMF_ZWRITE_ENABLE = 5;
      wMF_BACK_FACE_CULLING = 6;
      wMF_FRONT_FACE_CULLING = 7;
      wMF_BILINEAR_FILTER = 8;
      wMF_TRILINEAR_FILTER = 9;
      wMF_ANISOTROPIC_FILTER = 10;
      wMF_FOG_ENABLE = 11;
      wMF_NORMALIZE_NORMALS = 12;
      wMF_TEXTURE_WRAP = 13;
      wMF_ANTI_ALIASING = 14;
      wMF_COLOR_MASK = 15;
      wMF_COLOR_MATERIAL = 16;
      wMF_COUNT = 17;

  type
    PwMaterialTypes = ^wMaterialTypes;
    wMaterialTypes =  Longint;
    const
      wMT_SOLID = 0;
      wMT_SOLID_2_LAYER = 1;
      wMT_LIGHTMAP = 2;
      wMT_LIGHTMAP_ADD = 3;
      wMT_LIGHTMAP_M2 = 4;
      wMT_LIGHTMAP_M4 = 5;
      wMT_LIGHTMAP_LIGHTING = 6;
      wMT_LIGHTMAP_LIGHTING_M2 = 7;
      wMT_LIGHTMAP_LIGHTING_M4 = 8;
      wMT_DETAIL_MAP = 9;
      wMT_SPHERE_MAP = 10;
      wMT_REFLECTION_2_LAYER = 11;
      wMT_TRANSPARENT_ADD_COLOR = 12;
      wMT_TRANSPARENT_ALPHA_CHANNEL = 13;
      wMT_TRANSPARENT_ALPHA_CHANNEL_REF = 14;
      wMT_TRANSPARENT_VERTEX_ALPHA = 15;
      wMT_TRANSPARENT_REFLECTION_2_LAYER = 16;
      wMT_NORMAL_MAP_SOLID = 17;
      wMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR = 18;
      wMT_NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA = 19;
      wMT_PARALLAX_MAP_SOLID = 20;
      wMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR = 21;
      wMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA = 22;
      wMT_ONETEXTURE_BLEND = 23;
      wMT_FOUR_DETAIL_MAP = 24;
      wMT_TRANSPARENT_ADD_ALPHA_CHANNEL_REF = 25;
      wMT_TRANSPARENT_ADD_ALPHA_CHANNEL = 26;
      wMT_FORCE_32BIT = $7fffffff;

  type
    PwCustomMaterialTypes = ^wCustomMaterialTypes;
    wCustomMaterialTypes = record
      Solid : wMaterialTypes;
      TransparentRef : wMaterialTypes;
      Transparent : wMaterialTypes;
      TransparentSoft : wMaterialTypes;
      Normal : wMaterialTypes;
      NormalAnimated : wMaterialTypes;
      Parallax : wMaterialTypes;
      Detail : wMaterialTypes;
    end;

    PwColorMaterial = ^wColorMaterial;
    wColorMaterial =  Longint;
    const
      wCM_NONE = 0;
      wCM_DIFFUSE = 1;
      wCM_AMBIENT = 2;
      wCM_EMISSIVE = 3;
      wCM_SPECULAR = 4;
      wCM_DIFFUSE_AND_AMBIENT = 5;

  type
    PwBlendFactor = ^wBlendFactor;
    wBlendFactor =  Longint;
    const
      wBF_ZERO = 0;
      wBF_ONE = 1;
      wBF_DST_COLOR = 2;
      wBF_ONE_MINUS_DST_COLOR = 3;
      wBF_SRC_COLOR = 4;
      wBF_ONE_MINUS_SRC_COLOR = 5;
      wBF_SRC_ALPHA = 6;
      wBF_ONE_MINUS_SRC_ALPHA = 7;
      wBF_DST_ALPHA = 8;
      wBF_ONE_MINUS_DST_ALPHA = 9;
      wBF_SRC_ALPHA_SATURATE = 10;

  type
    PwBlendOperation = ^wBlendOperation;
    wBlendOperation =  Longint;
    const
      wBO_SCREEN = 0;
      wBO_ADD = 1;
      wBO_SUBTRACT = 2;
      wBO_MULTIPLY = 3;
      wBO_DIVIDE = 4;

  type
    PwBlendModulateFunc = ^wBlendModulateFunc;
    wBlendModulateFunc =  Longint;
    const
      wBMF_MODULATE_1X = 1;
      wBMF_MODULATE_2X = 2;
      wBMF_MODULATE_4X = 4;

  type
    PwBlendAlphaSource = ^wBlendAlphaSource;
    wBlendAlphaSource =  Longint;
    const
      wBAS_NONE = 0;
      wBAS_VERTEX_COLOR = 1;
      wBAS_TEXTURE = 2;

  type
    PwTextureCreationFlag = ^wTextureCreationFlag;
    wTextureCreationFlag =  Longint;
    const
      wTCF_ALWAYS_16_BIT = $00000001;
      wTCF_ALWAYS_32_BIT = $00000002;
      wTCF_OPTIMIZED_FOR_QUALITY = $00000004;
      wTCF_OPTIMIZED_FOR_SPEED = $00000008;
      wTCF_CREATE_MIP_MAPS = $00000010;
      wTCF_NO_ALPHA_CHANNEL = $00000020;
      wTCF_ALLOW_NON_POWER_2 = $00000040;

  type
    PwTextureClamp = ^wTextureClamp;
    wTextureClamp =  Longint;
    const
      wTC_REPEAT = 0;
      wTC_CLAMP = 1;
      wTC_CLAMP_TO_EDGE = 2;
      wTC_CLAMP_TO_BORDER = 3;
      wTC_MIRROR = 4;
      wTC_MIRROR_CLAMP = 5;
      wTC_MIRROR_CLAMP_TO_EDGE = 6;
      wTC_MIRROR_CLAMP_TO_BORDER = 7;

  type
    PwColorPlane = ^wColorPlane;
    wColorPlane =  Longint;
    const
      wCP_NONE = 0;
      wCP_ALPHA = 1;
      wCP_RED = 2;
      wCP_GREEN = 4;
      wCP_BLUE = 8;
      wCP_RGB = 14;
      wCP_ALL = 15;

  type
    PwAntiAliasingMode = ^wAntiAliasingMode;
    wAntiAliasingMode =  Longint;
    const
      wAAM_OFF = 0;
      wAAM_SIMPLE = 1;
      wAAM_QUALITY = 3;
      wAAM_LINE_SMOOTH = 4;
      wAAM_POINT_SMOOTH = 8;
      wAAM_FULL_BASIC = 15;
      wAAM_ALPHA_TO_COVERAGE = 16;

  type
    PwCullingState = ^wCullingState;
    wCullingState =  Longint;
    const
      wCS_OFF = 0;
      wCS_BOX = 1;
      wCS_FRUSTUM_BOX = 2;
      wCS_FRUSTUM_SPHERE = 4;
      wCS_OCC_QUERY = 8;

  type
    PwSceneNodeType = ^wSceneNodeType;
    wSceneNodeType =  Longint;
    const
      wSNT_CUBE = 1;
      wSNT_SPHERE = 2;
      wSNT_CYLINDER = 3;
      wSNT_CONE = 4;
      wSNT_PLANE = 5;
      wSNT_TEXT = 6;
      wSNT_WATER_SURFACE = 7;
      wSNT_TERRAIN = 8;
      wSNT_SKY_BOX = 9;
      wSNT_SKY_DOME = 10;
      wSNT_SHADOW_VOLUME = 11;
      wSNT_OCTREE = 12;
      wSNT_MESH = 13;
      wSNT_LIGHT = 14;
      wSNT_EMPTY = 15;
      wSNT_DUMMY_TRANSFORMATION = 16;
      wSNT_CAMERA = 17;
      wSNT_BILLBOARD = 18;
      wSNT_ANIMATED_MESH = 19;
      wSNT_PARTICLE_SYSTEM = 20;
      wSNT_VOLUME_LIGHT = 21;
      wSNT_CAMERA_MAYA = 22;
      wSNT_CAMERA_FPS = 23;
      wSNT_Q3SHADER_SCENE_NODE = 24;
      wSNT_UNKNOWN = 25;
      wSNT_ANY = 26;

  type
    PwOctreeVBOMode = ^wOctreeVBOMode;
    wOctreeVBOMode =  Longint;
    const
      wOVM_NO_VBO = 0;
      wOVM_USE_VBO = 1;
      wOVM_USE_VBO_WITH_VISIBITLY = 2;

  type
    PwOctreePolygonCheck = ^wOctreePolygonCheck;
    wOctreePolygonCheck =  Longint;
    const
      wOPC_BOX = 0;
      wOPC_FRUSTUM = 1;

  type
    PwOctreeParameters = ^wOctreeParameters;
    wOctreeParameters = record
      VBOmode : wOctreeVBOMode;
      checkMode : wOctreePolygonCheck;
      minimalPolysPerNode : Int32; //read only
      hasShadowVolume : boolean; //read only
    end;

    PwXmlNodeType = ^wXmlNodeType;
    wXmlNodeType =  Longint;
    const
      wXNT_NONE = 0;
      wXNT_ELEMENT = 1;
      wXNT_ELEMENT_END = 2;
      wXNT_TEXT = 3;
      wXNT_COMMENT = 4;
      wXNT_CDATA = 5;
      wXNT_UNKNOWN = 6;

  type
    PwTextFormat = ^wTextFormat;
    wTextFormat =  Longint;
    const
      wTF_ASCII = 0;
      wTF_UTF8 = 1;
      wTF_UTF16_BE = 2;
      wTF_UTF16_LE = 3;
      wTF_UTF32_BE = 4;
      wTF_UTF32_LE = 5;

  type
    PwFilterType = ^wFilterType;
    wFilterType =  Longint;
    const
      wFT_NONE = 0;
      wFT_4PCF = 1;
      wFT_8PCF = 2;
      wFT_12PCF = 3;
      wFT_16PCF = 4;
      wFT_COUNT = 5;

  type
    PwShadowMode = ^wShadowMode;
    wShadowMode =  Longint;
    const
      wSM_RECEIVE = 0;
      wSM_CAST = 1;
      wSM_BOTH = 2;
      wSM_EXCLUDE = 3;
      wSM_COUNT = 4;

  type
    PwColorFormat = ^wColorFormat;
    wColorFormat =  Longint;
    const
      wCF_A1R5G5B5 = 0;
      wCF_R5G6B5 = 1;
      wCF_R8G8B8 = 2;
      wCF_A8R8G8B8 = 3;
      wCF_DXT1 = 4;
      wCF_DXT2 = 5;
      wCF_DXT3 = 6;
      wCF_DXT4 = 7;
      wCF_DXT5 = 8;
      wCF_PVRTC_RGB2 = 9;
      wCF_PVRTC_ARGB2 = 10;
      wCF_PVRTC_RGB4 = 11;
      wCF_PVRTC_ARGB4 = 12;
      wCF_PVRTC2_ARGB2 = 13;
      wCF_PVRTC2_ARGB4 = 14;
      wCF_ETC1 = 15;
      wCF_ETC2_RGB = 16;
      wCF_ETC2_ARGB = 17;
      wCF_R16F = 18;
      wCF_G16R16F = 19;
      wCF_A16B16G16R16F = 20;
      wCF_R32F = 21;
      wCF_G32R32F = 22;
      wCF_A32B32G32R32F = 23;
      wCF_R8 = 24;
      wCF_R8G8 = 25;
      wCF_R16 = 26;
      wCF_R16G16 = 27;
      wCF_D16 = 28;
      wCF_D32 = 29;
      wCF_D24S8 = 30;
      wCF_UNKNOWN = 31;

  type
    PwMd2AnimationType = ^wMd2AnimationType;
    wMd2AnimationType =  Longint;
    const
      wMAT_STAND = 0;
      wMAT_RUN = 1;
      wMAT_ATTACK = 2;
      wMAT_PAIN_A = 3;
      wMAT_PAIN_B = 4;
      wMAT_PAIN_C = 5;
      wMAT_JUMP = 6;
      wMAT_FLIP = 7;
      wMAT_SALUTE = 8;
      wMAT_FALLBACK = 9;
      wMAT_WAVE = 10;
      wMAT_POINT = 11;
      wMAT_CROUCH_STAND = 12;
      wMAT_CROUCH_WALK = 13;
      wMAT_CROUCH_ATTACK = 14;
      wMAT_CROUCH_PAIN = 15;
      wMAT_CROUCH_DEATH = 16;
      wMAT_DEATH_FALLBACK = 17;
      wMAT_DEATH_FALLFORWARD = 18;
      wMAT_DEATH_FALLBACKSLOW = 19;
      wMAT_BOOM = 20;
      wMAT_COUNT = 21;
      wMAT_UNKNOWN = 22;

  type
    PwJointMode = ^wJointMode;
    wJointMode =  Longint;
    const
      wJM_NONE = 0;
      wJM_READ = 1;
      wJM_CONTROL = 2;

  type
    PwBoneSkinningSpace = ^wBoneSkinningSpace;
    wBoneSkinningSpace =  Longint;
    const
      wBSS_LOCAL = 0;
      wBSS_GLOBAL = 1;
      wBSS_COUNT = 2;

  type
    PwMeshFileFormat = ^wMeshFileFormat;
    wMeshFileFormat =  Longint;
    const
      wMFF_WS_MESH = 0;
      wMFF_COLLADA = 1;
      wMFF_STL = 2;

  type
    PwAnimatedMeshType = ^wAnimatedMeshType;
    wAnimatedMeshType =  Longint;
    const
      wAMT_UNKNOWN = 0;
      wAMT_MD2 = 1;
      wAMT_MD3 = 2;
      wAMT_OBJ = 3;
      wAMT_BSP = 4;
      wAMT_3DS = 5;
      wAMT_MY3D = 6;
      wAMT_LMTS = 7;
      wAMT_CSM = 8;
      wAMT_OCT = 9;
      wAMT_MDL_HALFLIFE = 10;
      wAMT_SKINNED = 11;

  type
    PwPhysSolverModel = ^wPhysSolverModel;
    wPhysSolverModel =  Longint;
    const
      wPSM_EXACT = 0;
      wPSM_ADAPTIVE = 1;
      wPSM_LINEAR = 2;
      wPSM_LINEAR2 = 4;

  type
    PwPhysFrictionModel = ^wPhysFrictionModel;
    wPhysFrictionModel =  Longint;
    const
      wPFM_ZERO = 0;
      wPFM_ONE = 1;

  type
    PwPhysVehicleType = ^wPhysVehicleType;
    wPhysVehicleType =  Longint;
    const
      wPVT_RAYCAST_WORLD = 0;
      wPVT_RAYCAST_CONVEX = 1;

  type
    PwPhysVehicleTireType = ^wPhysVehicleTireType;
    wPhysVehicleTireType =  Longint;
    const
      wPVTT_STEER = 0;
      wPVTT_ACCEL = 1;
      wPVTT_ACCEL_STEER = 2;
      wPVTT_ONLYWEEL = 3;

  type
    PwPhysRagDollBoneCollisionType = ^wPhysRagDollBoneCollisionType;
    wPhysRagDollBoneCollisionType =  Longint;
    const
      wPRBCT_BOX = 0;
      wPRBCT_SPHERE = 1;
      wPRBCT_CAPSULE = 2;
      wPRBCT_HULL = 3;

  type
    PwPhysRagDollBoneParameters = ^wPhysRagDollBoneParameters;
    wPhysRagDollBoneParameters = record
      boneName : Pchar;
      _type : wPhysRagDollBoneCollisionType;
      mass : Float32;
      coneAngle : Float32;
      minTwistAngle : Float32;
      maxTwistAngle : Float32;
      pitch : Float32;
      yaw : Float32;
      roll : Float32;
      collideWithNonImmidiateBodies : Int32;
    end;

    PwBulletDebugMode = ^wBulletDebugMode;
    wBulletDebugMode =  Longint;
    const
      wBDM_NoDebug = 0;
      wBDM_DrawWireframe = 1;
      wBDM_DrawAabb = 2;
      wBDM_DrawFeaturesText = 4;
      wBDM_DrawContactPoints = 8;
      wBDM_NoDeactivation = 16;
      wBDM_NoHelpText = 32;
      wBDM_DrawText = 64;
      wBDM_ProfileTimings = 128;
      wBDM_EnableSatComparison = 256;
      wBDM_DisableBulletLCP = 512;
      wBDM_EnableCCD = 1024;
      wBDM_DrawConstraints = 1 shl 11;
      wBDM_DrawConstraintLimits = 1 shl 12;
      wBDM_FastWireframe = 1 shl 13;
      wBDM_MAX_DEBUG_DRAW_MODE = (1 shl 13)+1;

  type
    PwBulletBodyState = ^wBulletBodyState;
    wBulletBodyState =  Longint;
    const
      wBBS_ACTIVE = 1;
      wBBS_SLEEPING = 2;
      wBBS_WANTS_DEACTIVATION = 3;
      wBBS_DISABLE_DEACTIVATION = 4;
      wBBS_DISABLE_SIMULATION = 5;

  type
    PwBulletCollisionType = ^wBulletCollisionType;
    wBulletCollisionType =  Longint;
    const
      wBCT_COLLISION_OBJECT = 1;
      wBCT_RIGID_BODY = 2;
      wBCT_GHOST_OBJECT = 3;
      wBCT_SOFT_BODY = 4;
      wBCT_HF_FLUID = 5;

  type
    PwBulletCollisionAffectorType = ^wBulletCollisionAffectorType;
    wBulletCollisionAffectorType =  Longint;
    const
      wBCAT_DELETE_AFFECTOR = 1;
      wBCAT_ATTRACT_AFFECTOR = 2;
      wBCAT_AFFECTOR_COUNT = 3;

  type
    PwBulletCollisionFlag = ^wBulletCollisionFlag;
    wBulletCollisionFlag =  Longint;
    const
      wBCF_OBJECT = 1;
      wBCF_KINEMATIC_OBJECT = 2;
      wBCF_NO_CONTACT_RESPONSE = 4;
      wBCF_CUSTOM_MATERIAL_CALLBACK = 8;
      wBCF_CHARACTER_OBJECT = 16;

  type
    PwBulletTransformSpace = ^wBulletTransformSpace;
    wBulletTransformSpace =  Longint;
    const
      wBTS_LOCAL = 0;
      wBTS_WORLD = 1;

  type
    PwBulletScalingPair = ^wBulletScalingPair;
    wBulletScalingPair =  Longint;
    const
      wBSP_BOTH = 0;
      wBSP_COLLISIONSHAPE = 1;
      wBSP_VISUAL = 2;

  type
    PwBulletSoftBodyFlag = ^wBulletSoftBodyFlag;
    wBulletSoftBodyFlag =  Longint;
    const
      wBSBF_RIGID_VERSUS_SOFT_MASK = $000f;
      wBSBF_SDF_RIGID_VERSUS_SOFT = $0001;
      wBSBF_CLUSTER_RIGID_VERSUS_SOFT = $0002;
      wBSBF_SOFT_VERSUS_SOFT_MASK = $0030;
      wBSBF_VERTEX_FACE_SOFT_VERSUS_SOFT = $0010;
      wBSBF_CLUSTER_SOFT_VERSUS_SOFT = $0020;
      wBSBF_CLUSTER_SELF_COLLISION = $0040;
      wBSBF_DEFAULT = wBSBF_SDF_RIGID_VERSUS_SOFT;
      wBSBF_END = (wBSBF_SDF_RIGID_VERSUS_SOFT)+1;

  type
    PwBulletSoftBodyAeroModel = ^wBulletSoftBodyAeroModel;
    wBulletSoftBodyAeroModel =  Longint;
    const
      wBSBAM_VERTEX_POINT = 0;
      wBSBAM_VERTEX_TWO_SIDED = 1;
      wBSBAM_VERTEX_ONE_SIDED = 2;
      wBSBAM_FACE_TWO_SIDED = 3;
      wBSBAM_FACE_ONE_SIDED = 4;
      wBSBAM_END = 5;

  type
    PwBulletSoftBodyConfig = ^wBulletSoftBodyConfig;
    wBulletSoftBodyConfig = record
      velocityCorrectionFactor : Float32;
      dampingCoefficient : Float32;
      dragCoefficient : Float32;
      liftCoefficient : Float32;
      pressureCoefficient : Float32;
      volumeConversationCoefficient : Float32;
      dynamicFrictionCoefficient : Float32;
      poseMatchingCoefficient : Float32;
      rigidContactsHardness : Float32;
      kineticContactsHardness : Float32;
      softContactsHardness : Float32;
      anchorsHardness : Float32;
      softRigidHardnessCL : Float32;
      softKineticHardnessCL : Float32;
      softSoftHardnessCL : Float32;
      kSR_SPLT_CL : Float32;
      kSK_SPLT_CL : Float32;
      kSS_SPLT_CL : Float32;
      maxVolume : Float32;
      timeScale : Float32;
      velocitiesSolverIterations : UInt32;
      positionsSolverIterations : UInt32;
      driftSolverIterations : UInt32;
      clusterSolverIterations : UInt32;
      collisionFlags : UInt32;
      aeroModel : wBulletSoftBodyAeroModel;
    end;

    PwBulletWheelCreateInfo = ^wBulletWheelCreateInfo;
    wBulletWheelCreateInfo = record
      chassisConnectionPointCS : wVector3f;
      wheelDirectionCS : wVector3f;
      wheelAxleCS : wVector3f;
      suspensionRestLength : Float32;
      wheelRadius : Float32;
      isFrontWheel : boolean;
    end;

    PwBulletRaycastInfo = ^wBulletRaycastInfo;
    wBulletRaycastInfo = record
      contactNormalWS : wVector3f;
      contactPointWS : wVector3f;
      suspensionLength : Float32;
      hardPointWS : wVector3f;
      wheelDirectionWS : wVector3f;
      wheelAxleWS : wVector3f;
      isInContact : boolean;
      groundObject : pointer;
    end;

    PwBulletWheelInfo = ^wBulletWheelInfo;
    wBulletWheelInfo = record
      chassisConnectionPointCS : wVector3f;
      wheelDirectionCS : wVector3f;
      wheelAxleCS : wVector3f;
      suspensionRestLength : Float32;
      maxSuspensionTravelCm : Float32;
      wheelRadius : Float32;
      suspensionStiffness : Float32;
      wheelDampingCompression : Float32;
      wheelDampingRelaxation : Float32;
      frictionSlip : Float32;
      steering : Float32;
      wheelRotation : Float32;
      deltaRotation : Float32;
      rollInfluence : Float32;
      engineForce : Float32;
      brake : Float32;
      isFrontWheel : boolean;
      clippedInvContactDotSuspension : Float32;
      suspensionRelativeVelocity : Float32;
      wheelSuspensionForce : Float32;
      skidInfo : Float32;
      rcInfo : wBulletRaycastInfo;
    end;

    PwGuiAlignment = ^wGuiAlignment;
    wGuiAlignment =  Longint;
    const
      wGA_UPPERLEFT = 0;
      wGA_LOWERRIGHT = 1;
      wGA_CENTER = 2;
      wGA_SCALE = 3;

  type
    PwGuiElementType = ^wGuiElementType;
    wGuiElementType =  Longint;
    const
      wGET_BUTTON =0;
      wGET_CHECK_BOX = 1;
      wGET_COMBO_BOX = 2;
      wGET_CONTEXT_MENU = 3;
      wGET_MENU = 4;
      wGET_EDIT_BOX = 5;
      wGET_FILE_OPEN_DIALOG = 6;
      wGET_COLOR_SELECT_DIALOG = 7;
      wGET_IN_OUT_FADER = 8;
      wGET_IMAGE = 9;
      wGET_LIST_BOX = 10;
      wGET_MESH_VIEWER = 11;
      wGET_MESSAGE_BOX = 12;
      wGET_MODAL_SCREEN = 13;
      wGET_SCROLL_BAR = 14;
      wGET_SPIN_BOX = 15;
      wGET_TEXT = 16;
      wGET_TAB = 17;
      wGET_TAB_CONTROL = 18;
      wGET_TABLE = 19;
      wGET_TOOL_BAR = 20;
      wGET_TREE_VIEW = 21;
      wGET_WINDOW = 22;
      wGET_ELEMENT = 23;
      wGET_ROOT = 24;
      wGET_COUNT = 25;
      wGET_FORCE_32_BIT = 26;

  type
    PwGuiColumnOrdering = ^wGuiColumnOrdering;
    wGuiColumnOrdering =  Longint;
    const
      wGCO_NONE = 0;
      wGCO_CUSTOM = 1;
      wGCO_ASCENDING = 2;
      wGCO_DESCENDING = 3;
      wGCO_FLIP_ASCENDING_DESCENDING = 4;
      wGCO_COUNT = 5;

  type
    PwGuiListboxColor = ^wGuiListboxColor;
    wGuiListboxColor =  Longint;
    const
      wGLC_TEXT = 0;
      wGLC_TEXT_HIGHLIGHT = 1;
      wGLC_ICON = 2;
      wGLC_ICON_HIGHLIGHT = 3;
      wGLC_COUNT = 4;

  type
    PwGuiDefaultColor = ^wGuiDefaultColor;
    wGuiDefaultColor =  Longint;
    const
      wGDC_3D_DARK_SHADOW = 0;
      wGDC_3D_SHADOW = 1;
      wGDC_3D_FACE = 2;
      wGDC_3D_HIGH_LIGHT = 3;
      wGDC_3D_LIGHT = 4;
      wGDC_ACTIVE_BORDER = 5;
      wGDC_ACTIVE_CAPTION = 6;
      wGDC_APP_WORKSPACE = 7;
      wGDC_BUTTON_TEXT = 8;
      wGDC_GRAY_TEXT = 9;
      wGDC_HIGH_LIGHT = 10;
      wGDC_HIGH_LIGHT_TEXT = 11;
      wGDC_INACTIVE_BORDER = 12;
      wGDC_INACTIVE_CAPTION = 13;
      wGDC_TOOLTIP = 14;
      wGDC_TOOLTIP_BACKGROUND = 15;
      wGDC_SCROLLBAR = 16;
      wGDC_WINDOW = 17;
      wGDC_WINDOW_SYMBOL = 18;
      wGDC_ICON = 19;
      wGDC_ICON_HIGH_LIGHT = 20;
      wGDC_COUNT = 21;

  type
    PwContextMenuClose = ^wContextMenuClose;
    wContextMenuClose =  Longint;
    const
      wCMC_IGNORE = 0;
      wCMC_REMOVE = 1;
      wCMC_HIDE = 2;

  type
    PwGuiOrderingMode = ^wGuiOrderingMode;
    wGuiOrderingMode =  Longint;
    const
      wGOM_NONE = 0;
      wGOM_ASCENDING = 1;
      wGOM_DESCENDING = 2;
      wGOM_COUNT = 3;

  type
    PwGuiTableDrawFlags = ^wGuiTableDrawFlags;
    wGuiTableDrawFlags =  Longint;
    const
      wGTDF_ROWS = 1;
      wGTDF_COLUMNS = 2;
      wGTDF_ACTIVE_ROW = 4;
      wGTDF_COUNT = 5;

  type
    PwGuiSkinSpace = ^wGuiSkinSpace;
    wGuiSkinSpace =  Longint;
    const
      wGSS_WINDOWS_CLASSIC = 0;
      wGSS_WINDOWS_METALLIC = 1;
      wGSS_BURNING_SKIN = 2;
      wGSS_UNKNOWN = 3;
      wGSS_COUNT = 4;

  type
    PwGuiDefaultSize = ^wGuiDefaultSize;
    wGuiDefaultSize =  Longint;
    const
      wGDS_SCROLLBAR_SIZE = 0;
      wGDS_MENU_HEIGHT = 1;
      wGDS_WINDOW_BUTTON_WIDTH = 2;
      wGDS_CHECK_BOX_WIDTH = 3;
      wGDS_MESSAGE_BOX_WIDTH = 4;
      wGDS_MESSAGE_BOX_HEIGHT = 5;
      wGDS_BUTTON_WIDTH = 6;
      wGDS_BUTTON_HEIGHT = 7;
      wGDS_TEXT_DISTANCE_X = 8;
      wGDS_TEXT_DISTANCE_Y = 9;
      wGDS_TITLEBARTEXT_DISTANCE_X = 10;
      wGDS_TITLEBARTEXT_DISTANCE_Y = 11;
      wGDS_MESSAGE_BOX_GAP_SPACE = 12;
      wGDS_MESSAGE_BOX_MIN_TEXT_WIDTH = 13;
      wGDS_MESSAGE_BOX_MAX_TEXT_WIDTH = 14;
      wGDS_MESSAGE_BOX_MIN_TEXT_HEIGHT = 15;
      wGDS_MESSAGE_BOX_MAX_TEXT_HEIGHT = 16;
      wGDS_BUTTON_PRESSED_IMAGE_OFFSET_X = 17;
      wGDS_BUTTON_PRESSED_IMAGE_OFFSET_Y = 18;
      wGDS_BUTTON_PRESSED_TEXT_OFFSET_X = 19;
      wGDS_BUTTON_PRESSED_TEXT_OFFSET_Y = 20;
      wGDS_BUTTON_PRESSED_SPRITE_OFFSET_X = 21;
      wGDS_BUTTON_PRESSED_SPRITE_OFFSET_Y = 22;
      wGDS_COUNT = 23;

  type
    PwGuiDefaultText = ^wGuiDefaultText;
    wGuiDefaultText =  Longint;
    const
      wGDT_MSG_BOX_OK = 0;
      wGDT_MSG_BOX_CANCEL = 1;
      wGDT_MSG_BOX_YES = 2;
      wGDT_MSG_BOX_NO = 3;
      wGDT_WINDOW_CLOSE = 4;
      wGDT_WINDOW_MAXIMIZE = 5;
      wGDT_WINDOW_MINIMIZE = 6;
      wGDT_WINDOW_RESTORE = 7;
      wGDT_COUNT = 8;

  type
    PwGuiDefaultFont = ^wGuiDefaultFont;
    wGuiDefaultFont =  Longint;
    const
      wGDF_DEFAULT = 0;
      wGDF_BUTTON = 1;
      wGDF_WINDOW = 2;
      wGDF_MENU = 3;
      wGDF_TOOLTIP = 4;
      wGDF_COUNT = 5;

  type
    PwGuiButtonState = ^wGuiButtonState;
    wGuiButtonState =  Longint;
    const
      wGBS_BUTTON_UP = 0;
      wGBS_BUTTON_DOWN = 1;
      wGBS_BUTTON_MOUSE_OVER = 2;
      wGBS_BUTTON_MOUSE_OFF = 3;
      wGBS_BUTTON_FOCUSED = 4;
      wGBS_BUTTON_NOT_FOCUSED = 5;
      wGBS_COUNT = 6;

  type
    PwGuiDefaultIcon = ^wGuiDefaultIcon;
    wGuiDefaultIcon =  Longint;
    const
      wGDI_WINDOW_MAXIMIZE = 0;
      wGDI_WINDOW_RESTORE = 1;
      wGDI_WINDOW_CLOSE = 2;
      wGDI_WINDOW_MINIMIZE = 3;
      wGDI_WINDOW_RESIZE = 4;
      wGDI_CURSOR_UP = 5;
      wGDI_CURSOR_DOWN = 6;
      wGDI_CURSOR_LEFT = 7;
      wGDI_CURSOR_RIGHT = 8;
      wGDI_MENU_MORE = 9;
      wGDI_CHECK_BOX_CHECKED = 10;
      wGDI_DROP_DOWN = 11;
      wGDI_SMALL_CURSOR_UP = 12;
      wGDI_SMALL_CURSOR_DOWN = 13;
      wGDI_RADIO_BUTTON_CHECKED = 14;
      wGDI_MORE_LEFT = 15;
      wGDI_MORE_RIGHT = 16;
      wGDI_MORE_UP = 17;
      wGDI_MORE_DOWN = 18;
      wGDI_EXPAND = 19;
      wGDI_COLLAPSE = 20;
      wGDI_FILE = 21;
      wGDI_DIRECTORY = 22;
      wGDI_COUNT = 23;

  type
    PwLightType = ^wLightType;
    wLightType =  Longint;
    const
      wLT_POINT = 0;
      wLT_SPOT = 1;
      wLT_DIRECTIONAL = 2;

  type
    PwDebugMode = ^wDebugMode;
    wDebugMode =  Longint;
    const
      wDM_OFF = 0;
      wDM_BBOX = 1;
      wDM_NORMALS = 2;
      wDM_SKELETON = 4;
      wDM_MESH_WIRE_OVERLAY = 8;
      wDM_HALF_TRANSPARENCY = 16;
      wDM_BBOX_BUFFERS = 32;
      wDM_FULL = $ffffffff;

  type
    PwTerrainPatchSize = ^wTerrainPatchSize;
    wTerrainPatchSize =  Longint;
    const
      wTPS_9 = 9;
      wTPS_17 = 17;
      wTPS_33 = 33;
      wTPS_65 = 65;
      wTPS_129 = 129;

  type
    PwTiledTerrainEdge = ^wTiledTerrainEdge;
    wTiledTerrainEdge =  Longint;
    const
      wTTE_TOP = 0;
      wTTE_BOTTOM = 1;
      wTTE_LEFT = 2;
      wTTE_RIGHT = 3;

  type
    PwPostEffectQuality = ^wPostEffectQuality;
    wPostEffectQuality =  Longint;
    const
      wPEQ_CRUDE = 0;
      wPEQ_FAST = 1;
      wPEQ_DEFAULT = 2;
      wPEQ_GOOD = 3;
      wPEQ_BEST = 4;

  type
    PwPostEffectId = ^wPostEffectId;
    wPostEffectId =  Longint;
    const
      wPEI_CUSTOM = 0;
      wPEI_DIRECT = 1;
      wPEI_PUNCH = 2;
      wPEI_PIXELATE = 3;
      wPEI_PIXELATEBANDS = 4;
      wPEI_DARKEN = 5;
      wPEI_LIGHTEN = 6;
      wPEI_RANGE = 7;
      wPEI_POSTERIZE = 8;
      wPEI_INVERT = 9;
      wPEI_TINT = 10;
      wPEI_CURVES = 11;
      wPEI_GREYSCALE = 12;
      wPEI_SEPIA = 13;
      wPEI_SATURATE = 14;
      wPEI_VIGNETTE = 15;
      wPEI_NOISE = 16;
      wPEI_COLORNOISE = 17;
      wPEI_PURENOISE = 18;
      wPEI_HBLUR = 19;
      wPEI_VBLUR = 20;
      wPEI_HSHARPEN = 21;
      wPEI_VSHARPEN = 22;
      wPEI_BIBLUR = 23;
      wPEI_HBLURDOFFAR = 24;
      wPEI_VBLURDOFFAR = 25;
      wPEI_HBLURDOFNEAR = 26;
      wPEI_VBLURDOFNEAR = 27;
      wPEI_LINEARBLUR = 28;
      wPEI_RADIALBLUR = 29;
      wPEI_RADIALBEAM = 30;
      wPEI_ROTATIONALBLUR = 31;
      wPEI_OVERLAY = 32;
      wPEI_OVERLAYNEG = 33;
      wPEI_MOTIONBLUR = 34;
      wPEI_HAZE = 35;
      wPEI_HAZEDEPTH = 36;
      wPEI_DEPTH = 37;
      wPEI_OCCLUSION = 38;
      wPEI_BLUR = 39;
      wPEI_SHARPEN = 40;
      wPEI_BLURDOFFAR = 41;
      wPEI_BLURDOFNEAR = 42;
      wPEI_BLURDOF = 43;
      wPEI_BLOOM = 44;
      wPEI_GLOOM = 45;
      wPEI_NIGHTVISION = 46;
      wPEI_MONITOR = 47;
      wPEI_WATERCOLOR = 48;
      wPEI_COUNT = 49;

  type
    Ptag_wBillboard = ^tag_wBillboard;
    tag_wBillboard = record
      Position : wVector3f;
      Size : wVector2f;
      Roll : Float32;
      Axis : wVector3f;
      HasAxis : Int32;
      sColor : Int32;
      alpha : UInt32;
      red : UInt32;
      green : UInt32;
      blue : UInt32;
      vertexIndex : UInt32;
      sprev : Ptag_wBillboard;
      snext : Ptag_wBillboard;
    end;
    wBillboard = tag_wBillboard;
    PwBillboard = ^wBillboard;

    PwConsoleFontColor = ^wConsoleFontColor;
    wConsoleFontColor =  Longint;
    const
      wCFC_BLACK = 0;
      wCFC_BLUE = 1;
      wCFC_GREEN = 2;
      wCFC_CYAN = 3;
      wCFC_RED = 4;
      wCFC_MAGENTA = 5;
      wCFC_BROWN = 6;
      wCFC_GREY = 7;
      wCFC_DARKGREY = 8;
      wCFC_LIGHTBLUE = 9;
      wCFC_LIGHTGREEN = 10;
      wCFC_LIGHTCYAN = 11;
      wCFC_LIGHTRED = 12;
      wCFC_LIGHTMAGENTA = 13;
      wCFC_YELLOW = 14;
      wCFC_WHITE = 15;
      wCFC_COUNT = 16;

  type
    PwConsoleBackColor = ^wConsoleBackColor;
    wConsoleBackColor =  Longint;
    const
      wCBC_BLACK = 0;
      wCBC_BLUE = 1;
      wCBC_GREEN = 2;
      wCBC_CYAN = 3;
      wCBC_RED = 4;
      wCBC_MAGENTA = 5;
      wCBC_YELLOW = 6;
      wCBC_WHITE = 7;
      wCBC_COUNT = 8;

  type
    PwWeekDay = ^wWeekDay;
    wWeekDay =  Longint;
    const
      wWD_SUNDAY = 0;
      wWD_MONDAY = 1;
      wWD_TUESDAY = 2;
      wWD_WEDNESDAY = 3;
      wWD_THURSDAY = 4;
      wWD_FRIDAY = 5;
      wWD_SATURDAY = 6;

  type
    PwRealTimeDate = ^wRealTimeDate;
    wRealTimeDate = record
      Day : UInt32;
      Hour : UInt32;
      IsDST : boolean;
      Minute : UInt32;
      Month : UInt32;
      Second : UInt32;
      Weekday : wWeekDay;
      Year : Int32;
      Yearday : UInt32;
    end;

    PwBillboardAxisParam = ^wBillboardAxisParam;
    wBillboardAxisParam = record
      isEnablePitch : boolean;
      isEnableYaw : boolean;
      isEnableRoll : boolean;
      notUse : boolean;
    end;

    PwFileArchiveType = ^wFileArchiveType;
    wFileArchiveType =  Longint;
    const
      wFAT_ZIP = 0;
      wFAT_GZIP = 1;
      wFAT_FOLDER = 2;
      wFAT_PAK = 3;
      wFAT_NPK = 4;
      wFAT_TAR = 5;
      wFAT_WAD = 6;
      wFAT_UNKNOWN = 7;

  type
    PwEngineCreationParameters = ^wEngineCreationParameters;
    wEngineCreationParameters = record
      DeviceType : wDeviceTypes;
      DriverType : wDriverTypes;
      WindowSize : wVector2u;
      WindowPosition : wVector2i;
      Bits : UInt8;
      ZBufferBits : UInt8;
      Fullscreen : boolean;
      Stencilbuffer : boolean;
      Vsync : boolean;
      AntiAlias : wAntiAliasingMode;
      HandleSRGB : boolean;
      WithAlphaChannel : boolean;
      Doublebuffer : boolean;
      IgnoreInput : boolean;
      Stereobuffer : boolean;
      HighPrecisionFPU : boolean;
      WindowId : pointer;
      LoggingLevel : wLoggingLevel;
      DisplayAdapter : UInt32;
      DriverMultithreaded : boolean;
      UsePerformanceTimer : boolean;
      PrivateData : pointer;
      OGLES2ShaderPath : Pchar;
    end;

    PwLanguage = ^wLanguage;
    wLanguage =  Longint;
    const
      wL_RU = 0;
      wL_EN = 1;

  type
    PwNodeCubeParameters = ^wNodeCubeParameters;
    wNodeCubeParameters = record
      size : Float32;
      tangent : boolean;
    end;

    PwNodeSphereParameters = ^wNodeSphereParameters;
    wNodeSphereParameters = record
      radius : Float32;
      polyCount : Int32;
      tangent : boolean;
    end;

    PwNodeCylinderParameters = ^wNodeCylinderParameters;
    wNodeCylinderParameters = record
      radius : Float32;
      length : Float32;
      tesselation : UInt32;
      closeTop : boolean;
      oblique : Float32;
      tangent : boolean;
    end;

    PwNodeConeParameters = ^wNodeConeParameters;
    wNodeConeParameters = record
      radius : Float32;
      length : Float32;
      tesselation : UInt32;
      tangent : boolean;
    end;

    PwNodePlaneParameters = ^wNodePlaneParameters;
    wNodePlaneParameters = record
      tileSize : wVector2f;
      tileCount : wVector2u;
      textureRepeatCount : wVector2f;
      tangent : boolean;
    end;

    PwSoundEffectType = ^wSoundEffectType;
    wSoundEffectType =  Longint;
    const
      wSET_NULL = 0;
      wSET_EAX_REVERB = 1;
      wSET_REVERB = 2;
      wSET_CHORUS = 3;
      wSET_DISTORTION = 4;
      wSET_ECHO = 5;
      wSET_FLANGER = 6;
      wSET_FREQUENCY_SHIFTER = 7;
      wSET_VOCAL_MORPHER = 8;
      wSET_PITCH_SHIFTER = 9;
      wSET_RING_MODULATOR = 10;
      wSET_AUTOWAH = 11;
      wSET_COMPRESSOR = 12;
      wSET_EQUALIZER = 13;
      wSET_COUNT = 14;

  type
    PwSoundFilterType = ^wSoundFilterType;
    wSoundFilterType =  Longint;
    const
      wSFT_NULL = 0;
      wSFT_LOWPASS = 1;
      wSFT_HIGHPASS = 2;
      wSFT_BANDPASS = 3;
      wSFT_COUNT = 4;

  type
    PwAudioFormats = ^wAudioFormats;
    wAudioFormats =  Longint;
    const
      wAF_8BIT_MONO = 0;
      wAF_8BIT_STEREO = 1;
      wAF_16BIT_MONO = 2;
      wAF_16BIT_STEREO = 3;


  type
    Ptag_wEaxReverbParameters = ^tag_wEaxReverbParameters;
    tag_wEaxReverbParameters = record
      Density : Float32;
      Diffusion : Float32;
      Gain : Float32;
      GainHF : Float32;
      GainLF : Float32;
      DecayTime : Float32;
      DecayHFRatio : Float32;
      DecayLFRatio : Float32;
      ReflectionsGain : Float32;
      ReflectionsDelay : Float32;
      ReflectionsPanX : Float32;
      ReflectionsPanY : Float32;
      ReflectionsPanZ : Float32;
      LateReverbGain : Float32;
      LateReverbDelay : Float32;
      LateReverbPanX : Float32;
      LateReverbPanY : Float32;
      LateReverbPanZ : Float32;
      EchoTime : Float32;
      EchoDepth : Float32;
      ModulationTime : Float32;
      ModulationDepth : Float32;
      AirAbsorptionGainHF : Float32;
      HFReference : Float32;
      LFReference : Float32;
      RoomRolloffFactor : Float32;
      DecayHFLimit : boolean;
    end;
    wEaxReverbParameters = tag_wEaxReverbParameters;
    PwEaxReverbParameters = ^wEaxReverbParameters;

    Ptag_wReverbParameters = ^tag_wReverbParameters;
    tag_wReverbParameters = record
      Density : Float32;
      Diffusion : Float32;
      Gain : Float32;
      GainHF : Float32;
      DecayTime : Float32;
      DecayHFRatio : Float32;
      ReflectionsGain : Float32;
      ReflectionsDelay : Float32;
      LateReverbGain : Float32;
      LateReverbDelay : Float32;
      AirAbsorptionGainHF : Float32;
      RoomRolloffFactor : Float32;
      DecayHFLimit : boolean;
    end;
    wReverbParameters = tag_wReverbParameters;
    PwReverbParameters = ^wReverbParameters;

    PChorusWaveform = ^ChorusWaveform;
    ChorusWaveform =  Longint;
    const
      wCWF_SINUSOID = 0;
      wCWF_TRIANGLE = 1;
      wCWF_COUNT = 2;

  type
    Ptag_wChorusParameters = ^tag_wChorusParameters;
    tag_wChorusParameters = record
      Waveform : ChorusWaveform;
      Phase : Int32;
      Rate : Float32;
      Depth : Float32;
      Feedback : Float32;
      Delay : Float32;
    end;
    wChorusParameters = tag_wChorusParameters;
    PwChorusParameters = ^wChorusParameters;

    Ptag_wDistortionParameters = ^tag_wDistortionParameters;
    tag_wDistortionParameters = record
      Edge : Float32;
      Gain : Float32;
      LowpassCutoff : Float32;
      EqCenter : Float32;
      EqBandwidth : Float32;
    end;
    wDistortionParameters = tag_wDistortionParameters;
    PwDistortionParameters = ^wDistortionParameters;

    Ptag_wEchoParameters = ^tag_wEchoParameters;
    tag_wEchoParameters = record
      Delay : Float32;
      LRDelay : Float32;
      Damping : Float32;
      Feedback : Float32;
      Spread : Float32;
    end;
    wEchoParameters = tag_wEchoParameters;
    PwEchoParameters = ^wEchoParameters;
    {! The flanger effect creates a "tearing" or "whooshing" sound (like a jet flying overhead). }

    PFlangerWaveform = ^FlangerWaveform;
    FlangerWaveform =  Longint;
    const
      wFWF_SINUSOID = 0;
      wFWF_TRIANGLE = 1;
      wFWF_COUNT = 2;

  type
    Ptag_wFlangerParameters = ^tag_wFlangerParameters;
    tag_wFlangerParameters = record
      Waveform : FlangerWaveform;
      Phase : Int32;
      Rate : Float32;
      Depth : Float32;
      Feedback : Float32;
      Delay : Float32;
    end;
    wFlangerParameters = tag_wFlangerParameters;
    PwFlangerParameters = ^wFlangerParameters;
    {! The frequency shifter is a single-sideband modulator, which translates all the component frequencies of the input signal by an equal amount. }

    PShiftDirection = ^ShiftDirection;
    ShiftDirection =  Longint;
    const
      wSD_DOWN = 0;
      wSD_UP = 1;
      wSD_OFF = 2;
      wSD_COUNT = 3;

  type
    Ptag_wFrequencyShiftParameters = ^tag_wFrequencyShiftParameters;
    tag_wFrequencyShiftParameters = record
      Frequency : Float32;
      Left : ShiftDirection;
      Right : ShiftDirection;
    end;
    wFrequencyShiftParameters = tag_wFrequencyShiftParameters;
    PwFrequencyShiftParameters = ^wFrequencyShiftParameters;
    {! The vocal morpher consists of a pair of 4-band formant filters, used to impose vocal tract effects upon the input signal. }

    PMorpherPhoneme = ^MorpherPhoneme;
    MorpherPhoneme =  Longint;
    const
      wMP_A = 0;
      wMP_E = 1;
      wMP_I = 2;
      wMP_O = 3;
      wMP_U = 4;
      wMP_AA = 5;
      wMP_AE = 6;
      wMP_AH = 7;
      wMP_AO = 8;
      wMP_EH = 9;
      wMP_ER = 10;
      wMP_IH = 11;
      wMP_IY = 12;
      wMP_UH = 13;
      wMP_UW = 14;
      wMP_B = 15;
      wMP_D = 16;
      wMP_F = 17;
      wMP_G = 18;
      wMP_J = 19;
      wMP_K = 20;
      wMP_L = 21;
      wMP_M = 22;
      wMP_N = 23;
      wMP_P = 24;
      wMP_R = 25;
      wMP_S = 26;
      wMP_T = 27;
      wMP_V = 28;
      wMP_Z = 29;
      wMP_COUNT = 30;

  type
    PMorpherWaveform = ^MorpherWaveform;
    MorpherWaveform =  Longint;
    const
      wMWF_SINUSOID = 0;
      wMWF_TRIANGLE = 1;
      wMWF_SAW = 2;
      wMWF_COUNT = 3;

  type
    Ptag_wVocalMorpherParameters = ^tag_wVocalMorpherParameters;
    tag_wVocalMorpherParameters = record
      PhonemeA : MorpherPhoneme;
      PhonemeB : MorpherPhoneme;
      PhonemeACoarseTune : Int32;
      PhonemeBCoarseTune : Int32;
      Waveform : MorpherWaveform;
      Rate : Float32;
    end;
    wVocalMorpherParameters = tag_wVocalMorpherParameters;
    PwVocalMorpherParameters = ^wVocalMorpherParameters;

    Ptag_wPitchShifterParameters = ^tag_wPitchShifterParameters;
    tag_wPitchShifterParameters = record
      CoarseTune : Int32;
      FineTune : Int32;
    end;
    wPitchShifterParameters = tag_wPitchShifterParameters;
    PwPitchShifterParameters = ^wPitchShifterParameters;
    {! The ring modulator multiplies an input signal by a carrier signal in the time domain, resulting in tremolo or inharmonic effects. }

    PModulatorWaveform = ^ModulatorWaveform;
    ModulatorWaveform =  Longint;
    Const
      wMDWF_SINUSOID = 0;
      wMDWF_SAW = 1;
      wMDWF_SQUARE = 2;
      wMDWF_COUNT = 3;

  type
    Ptag_wRingModulatorParameters = ^tag_wRingModulatorParameters;
    tag_wRingModulatorParameters = record
      Frequency : Float32;
      HighPassCutoff : Float32;
      Waveform : ModulatorWaveform;
    end;
    wRingModulatorParameters = tag_wRingModulatorParameters;
    PwRingModulatorParameters = ^wRingModulatorParameters;

    Ptag_wAutowahParameters = ^tag_wAutowahParameters;
    tag_wAutowahParameters = record
      AttackTime : Float32;
      ReleaseTime : Float32;
      Resonance : Float32;
      PeakGain : Float32;
    end;
    wAutowahParameters = tag_wAutowahParameters;
    PwAutowahParameters = ^wAutowahParameters;
    {! The Automatic Gain Control effect performs the same task as a studio compressor, evening out the audio dynamic range of an input sound. }
    {! The Compressor can only be switched on and off – it cannot be adjusted. }

    Ptag_wCompressorParameters = ^tag_wCompressorParameters;
    tag_wCompressorParameters = record
      Active : boolean;
    end;
    wCompressorParameters = tag_wCompressorParameters;
    PwCompressorParameters = ^wCompressorParameters;

    Ptag_wEqualizerParameters = ^tag_wEqualizerParameters;
    tag_wEqualizerParameters = record
      LowGain : Float32;
      LowCutoff : Float32;
      Mid1Gain : Float32;
      Mid1Center : Float32;
      Mid1Width : Float32;
      Mid2Gain : Float32;
      Mid2Center : Float32;
      Mid2Width : Float32;
      HighGain : Float32;
      HighCutoff : Float32;
    end;
    wEqualizerParameters = tag_wEqualizerParameters;
    PwEqualizerParameters = ^wEqualizerParameters;

    Ptag_wShader = ^tag_wShader;
    tag_wShader = record
      material_type : Int32;
      irrShaderCallBack : pointer;
      next_shader : Ptag_wShader;
    end;
    wShader = tag_wShader;
    PwShader = ^wShader;


type
  {$IFDEF WINDOWS}
  WChar   = WideChar;
  WString = WideString;
  {$ELSE}
  WChar   = WideChar;//UCS4Char;
  WString = WideString;//UCS4String;
  {$ENDIF}
  PWChar   = ^WChar;
  PPWChar   = ^PWChar;
  PWString = ^WString;
//  wFile = PUInt32;
//  PwFile= ^wFile;

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

procedure wFontDraw(font:wFont; const wcptrText: PWChar;   ////////
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
         time: Int32; speed, tightness: Float32): wAnimator; cdecl; external WS3DCoreLib;

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

function wCollisionGetNodeFromScreen(screenPos: wVector2i; idBitMask: Int32;
                                     bNoDebugObjects: Boolean;
                                     root_: wNode): wNode; cdecl; external WS3DCoreLib ;

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
          aType: wFileArchiveType; password: PChar): Boolean; cdecl; external WS3DCoreLib ;

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

function wFileCreateForWrite(const cptrFile: PChar; append: Boolean): wFile; cdecl; external WS3DCoreLib ;

function wFileWrite(_file: wFile; buffer: Pointer; sizeToWrite: UInt32): Int32; cdecl; external WS3DCoreLib ;

function wFileGetName(_file: wFile): PChar; cdecl; external WS3DCoreLib ;

function wFileGetPos(_file: wFile): Int64; cdecl; external WS3DCoreLib;

function wFileSeek(_file: wFile; finalPos: Int64; relativeMovement: Boolean): Boolean; cdecl; external WS3DCoreLib;


implementation



end.
