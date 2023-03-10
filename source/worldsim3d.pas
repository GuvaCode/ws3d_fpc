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
      //WS3DCoreLib = 'WS3DCoreLib.so';
    {$ENDIF}
  {$ENDIF}


  {$IFDEF WINDOWS}
    nullStr = '';
  {$ELSE}
    nullStr = nil;
  {$ENDIF}

type
  UInt64 = dword;
  UInt32 = dword;
  UInt16 = word;
  UInt8 = byte;
  Int64 = longint;
  Int32 = longint;
  Int16 = smallint;
  Int8 = char;
  Float64 = double;
  Float32 = single;
  PUInt32 =^UInt32;
  PFloat32=^Float32;
  PBoolean=^Boolean;
  wImage 		= PUInt32; 	PwImage          = ^wImage;
  wTexture 		= PUInt32;	PwTexture        = ^wTexture;
  wFont 		= PUInt32;	PwFont           = ^wFont;
  wGuiObject 		= PUInt32;	PwGuiObject      = ^wGuiobject;
  wMesh 		= PUInt32;	PwMesh           = ^wMesh;
  wMeshBuffer 	        = PUInt32;	PwMeshBuffer     = ^wMeshBuffer;
  wNode 		= PUInt32;	PwNode           = ^wNode;
  wMaterial 		= PUInt32;	PwMaterial       = ^wMaterial;
  wSelector 		= PUInt32;	PwSelector       = ^wSelector;
  wEmitter 		= PUInt32;	PwEmitter        = ^wEmitter;
  wAffector 		= PUInt32;	PwAffector       = ^wAffector;
  wAnimator 		= PUInt32;	PwAnimator       = ^wAnimator;
  wXmlReader 		= PUInt32;	PwXmlReader      = ^wXmlReader;
  wXmlWriter 		= PUInt32;	PwXmlWriter      = ^wXmlWriter;
  wFile 		= PUInt32;	PwFile		 = ^wFile;
  wSoundEffect 	        = PUInt32;	PwSoundEffect	 = ^wSoundEffect;
  wSoundFilter 	        = PUInt32;	PwSoundFilter	 = ^wSoundFilter;
  wSound 		= PUInt32;	PwSound		 = ^wSound;
  wSoundBuffer 	        = PUInt32;	PwSoundBuffer	 = ^wSoundBuffer;
  wVideo 		= PUInt32;	PwVideo		 = ^wVideo;
  wPostEffect 	        = PUInt32;	PwPostEffect	 = ^wPostEffect;
  wPacket 		= PUInt32;	PwPacket	 = ^wPacket;
  wFileArchive          = PUInt32;      PwFileArchive =^wFileArchive;
  wFileList             = PUInt32;      PwFileList = ^wFileList;
  wMouseEventType       = Longint;      PwMouseEventType = ^wMouseEventType;


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
      wKC_LWIN                    = $5B; // Left Windows key (Microsoft?? Natural?? keyboard)
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
      animMeshNode : PwNode; ///?????? ???????????????? ?????????????????????????? ?????????? (??????-??????)
      animMeshName : Pchar;
      Mesh : PwMesh; ///?????? ???????????????? ?????????????????????? ?????????? (??????- ?????????????????? ??????)
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
    {! The Compressor can only be switched on and off ??? it cannot be adjusted. }

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
  WChar   = UCS4Char;
  WString = UCS4String;
  {$ENDIF}
  PWChar    = ^WChar;
  PPWChar   = ^PWChar;
  PWString  = ^WString;

{$IFDEF WINDOWS}  // ??????????????
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

procedure wFontDraw(font: wFont; const wcptrText: WString;  //PWString???????
                         fromPos: wVector2i; toPos: wVector2i;
                         color: wColor4s); cdecl; external WS3DCoreLib;

procedure wFontDestroy(font: wFont); cdecl; external WS3DCoreLib;

function wFontGetTextSize(font: wFont; const text: WString): wVector2u; cdecl; external WS3DCoreLib; ///////

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

{ ???????????????????? ?????????????????????????????? ???????????? }
function wMathVector3fNormalize(source: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ ???????????????????? ?????????? ?????????????? }
function wMathVector3fGetLength(vector: wVector3f): Float32; cdecl; external WS3DCoreLib ;
{ Get the rotations that would make a (0,0,1) direction vector point in the same direction as this direction vector. }
function wMathVector3fGetHorizontalAngle(vector: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ ???????????????????? ?????????????????????????????? ???????????? (?????? ???????????????????? ???????????? ????????) }
function wMathVector3fInvert(vector: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ ?????????????????? ?????? ?????????????? }
function wMathVector3fAdd(vector1, vector2: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ ???????????????? ???? ?????????????? 1 ???????????? 2 }
function wMathVector3fSubstract(vector1: wVector3f; vector2: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ ?????????????????? ???????????????????????? ???????????????? }
function wMathVector3fCrossProduct(vector1, vector2: wVector3f): wVector3f; cdecl; external WS3DCoreLib;
{ ?????????????????? ???????????????????????? ???????????????? }
function wMathVector3fDotProduct(vector1, vector2: wVector3f): Float32; cdecl; external WS3DCoreLib;
{ ???????????????????? ???????????????????? ???????????????????? ?????????? ?????????????????? }
function wMathVector3fGetDistanceFrom(vector1, vector2: wVector3f): Float32; cdecl; external WS3DCoreLib;
{ ???????????????????? ?????????????????????????????????? ???????????? }
function wMathVector3fInterpolate(vector1, vector2: wVector3f; d: Float64): wVector3f; cdecl; external WS3DCoreLib;
{ ???????????????????? ?????????????????? ?????????? ???? ?????????????????? (first, last) }
function wMathRandomRange(first, last: Float64): Float64; cdecl; external WS3DCoreLib;

{ ???? ????????????????- ?? ?????????????? }
function wMathDegToRad(degrees: Float32): Float32; cdecl; external WS3DCoreLib;
{ ???? ????????????- ?? ?????????????? }
function wMathRadToDeg(radians: Float32): Float32; cdecl; external WS3DCoreLib;
{ ?????????????????????????? ???????????????????? ???????????????????? }
function wMathRound(value: Float32): Float32; cdecl; external WS3DCoreLib;
{ ???????????????????? ?? ?????????????? ?????????????? }
function wMathCeil(value: Float32): Int32; cdecl; external WS3DCoreLib;
{ ???????????????????? ?? ?????????????? ?????????????? }
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
{ ???????????????????? ?????????????? Float32 ???? ???????? }
function wMathFloatMax2(value1, value2: Float32): Float32; cdecl; external WS3DCoreLib;
{ ???????????????????? ?????????????? Float32 ???? ???????? }
function wMathFloatMax3(value1, value2, value3: Float32): Float32; cdecl; external WS3DCoreLib;
{ ???????????????????? ?????????????? Int32 ???? ???????? }
function wMathIntMax2(value1, value2: Int32): Float32; cdecl; external WS3DCoreLib;
{ ???????????????????? ?????????????? Int32 ???? ???????? }
function wMathIntMax3(value1, value2, value3: Int32): Float32; cdecl; external WS3DCoreLib;
{ ???????????????????? ?????????????? Float32 ???? ???????? }
function wMathFloatMin2(value1, value2: Float32): Float32; cdecl; external WS3DCoreLib;
{ ???????????????????? ?????????????? Float32 ???? ???????? }
function wMathFloatMin3(value1, value2, value3: Float32): Float32; cdecl; external WS3DCoreLib;
{ ???????????????????? ?????????????? Int32 ???? ???????? }
function wMathIntMin2(value1, value2: Int32): Float32; cdecl; external WS3DCoreLib;
{ ???????????????????? ?????????????? Int32 ???? ???????? }
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

procedure wCustomRendererSwapMaterials(node: wNode = nil); cdecl; external WS3DCoreLib;

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
function wSceneLoad(const filename: PChar; parentNode: wNode = nil): Boolean; cdecl; external WS3DCoreLib;

function wSceneLoadFromFile(file_: wFile; parentNode: wNode = nil): Boolean; cdecl; external WS3DCoreLib;

function wSceneSave(filename: PChar; parentNode: wNode = nil): Boolean; cdecl; external WS3DCoreLib;

function wSceneSaveToFile(file_: wFile; parentNode: wNode = nil): Boolean; cdecl; external WS3DCoreLib;

function wSceneSaveToXml(writer: wXmlWriter; const relativePath: PChar;
                         parentNode: wNode=nil): Boolean; cdecl; external WS3DCoreLib;

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

procedure wFileClose(_file: wFile); cdecl; external WS3DCoreLib;

//wFileList//

function wFileListCreateEmpty(const fPath: PChar; ignoreCase, ignorePaths: Boolean): wFileList; cdecl; external WS3DCoreLib;

//Creates a list of files and directories in the current working directory and returns it
function wFileListCreate(): wFileList; cdecl; external WS3DCoreLib;

procedure wFileListRemove(flist: wFileList); cdecl; external WS3DCoreLib;

//Returns the base path of the file list.
function wFileListGetPath(flist: wFileList): PChar; cdecl; external WS3DCoreLib;

//Sorts the file list. You should call this after adding any items to the file list.
procedure wFileListSort(flist: wFileList); cdecl; external WS3DCoreLib;

//Add as a file or folder to the list.
function wFileListAddItem(flist: wFileList; const fullPath: PChar; offset,
          size: UInt32; isDirectory: Boolean; id: UInt32): Int32; cdecl; external WS3DCoreLib;

//Searches for a file or folder in the list.
function wFileListFindFile(flist: wFileList; const fileName: PChar;
          isFolder: Boolean = false): Int32; cdecl; external WS3DCoreLib;

//Get the number of files in the filelist.
function wFileListGetFilesCount(flist: wFileList): UInt32; cdecl; external WS3DCoreLib;

//Gets the name of a file in the list, based on an index.
function wFileListGetFileBaseName(flist: wFileList; idx: UInt32): PChar; cdecl; external WS3DCoreLib;

//Gets the full name of a file in the list including the path, based on an index.
function wFileListGetFileName(flist: wFileList; idx: UInt32): PChar; cdecl; external WS3DCoreLib;

//Returns the file offset of a file in the file list, based on an index
function wFileListGetFileOffset(flist: wFileList; idx: UInt32): UInt32; cdecl; external WS3DCoreLib;

//Returns the size of a file in the file list, based on an index.
function wFileListGetFileSize(flist: wFileList; idx: UInt32): UInt32; cdecl; external WS3DCoreLib;

//Returns the ID of a file in the file list, based on an index.
function wFileListGetFileId(flist: wFileList; idx: UInt32): UInt32; cdecl; external WS3DCoreLib;

//Check if the file is a directory.
function wFileListIsItemDirectory(flist: wFileList; idx: UInt32): Boolean; cdecl; external WS3DCoreLib;

//wXml
function wXmlReaderCreate(const cptrFile: PChar): wXmlReader; cdecl; external WS3DCoreLib ;

function wXMLReaderCreateUTF8(const cptrFile: PChar): wXmlReader; cdecl; external WS3DCoreLib ;

{Returns attribute count of the current XML node }
function wXmlGetAttributesCount(xml: wXmlReader): UInt32; cdecl; external WS3DCoreLib ;

{Returns the value of an attribute }
function wXmlGetAttributeNameByIdx(xml: wXmlReader; idx: Int32): PWString; cdecl; external WS3DCoreLib ;

{Returns the value of an attribute }
function wXmlGetAttributeValueByIdx(xml: wXmlReader; idx: Int32): PWString; cdecl; external WS3DCoreLib ;

{Returns the value of an attribute }
function wXmlGetAttributeValueByName(xml: wXmlReader; const name: PWString): PWString; cdecl; external WS3DCoreLib ;

{Returns the value of an attribute as float }
function wXmlGetAttributeValueFloatByIdx(xml: wXmlReader; idx: Int32): Float32; cdecl; external WS3DCoreLib ;

{Returns the value of an attribute as float }
function wXmlGetAttributeValueFloatByName(xml: wXmlReader; name: PWString): Float32; cdecl; external WS3DCoreLib ;

{Returns the value of an attribute as integer }
function wXmlGetAttributeValueIntByIdx(xml: wXmlReader; idx: Int32): Int32; cdecl; external WS3DCoreLib ;

{Returns the value of an attribute as integer }
function wXmlGetAttributeValueIntByName(xml: wXmlReader; name: PWString): Int32; cdecl; external WS3DCoreLib ;

{Returns the value of an attribute in a safe way }
function wXmlGetAttributeValueSafeByName(xml: wXmlReader; name: PWString): PWString; cdecl; external WS3DCoreLib ;

{Returns the name of the current node }
function wXmlGetNodeName(xml: wXmlReader): PWString; cdecl; external WS3DCoreLib ;

{Returns data of the current node }
function wXmlGetNodeData(xml: wXmlReader): PWString; cdecl; external WS3DCoreLib ;

{Returns format of the source xml file }
function wXmlGetSourceFormat(xml: wXmlReader): wTextFormat; cdecl; external WS3DCoreLib ;

{Returns format of the strings returned by the parser }
function wXmlGetParserFormat(xml: wXmlReader): wTextFormat; cdecl; external WS3DCoreLib ;

{Returns the type of the current XML node }
function wXmlGetNodeType(xml: wXmlReader): wXmlNodeType; cdecl; external WS3DCoreLib ;

{Returns if an element is an empty element, like <foo /> }
function wXmlIsEmptyElement(xml: wXmlReader): Boolean; cdecl; external WS3DCoreLib ;

{Reads forward to the next xml node }
function wXmlRead(xml: wXmlReader): Boolean; cdecl; external WS3DCoreLib ;

procedure wXmlReaderDestroy(xml: wXmlReader); cdecl; external WS3DCoreLib ;

//XmlWriter
function wXmlWriterCreate(const cptrFile: Pchar): wXmlWriter; cdecl; external WS3DCoreLib ;

{Writes the closing tag for an element. Like "</foo>" }
procedure wXmlWriteClosingTag(xml: wXmlWriter; const name: PWString); cdecl; external WS3DCoreLib ;

{Writes a comment into the xml file }
procedure wXmlWriteComment(xml: wXmlWriter; const comment: PWString); cdecl; external WS3DCoreLib ;

{Writes a line break }
procedure wXmlWriteLineBreak(xml: wXmlWriter); cdecl; external WS3DCoreLib ;

{Writes a text into the file }
procedure wXmlWriteText(xml: wXmlWriter; const _file: PWString); cdecl; external WS3DCoreLib ;

{Writes an xml 1.0 header }
procedure wXmlWriteHeader(xml: wXmlWriter); cdecl; external WS3DCoreLib ;

procedure wXmlWriteElement(xml: wXmlWriter; const name: Pwstring;empty: Boolean;
          attr1Name, attr1Value, attr2Name, attr2Value,
          attr3Name, attr3Value, attr4Name, attr4Value,
          attr5Name, attr5Value: PWString); cdecl; external WS3DCoreLib ;

procedure wXmlWriterDestroy(xml: wXmlWriter); cdecl; external WS3DCoreLib ;

//wInput
//Logger
function wInputIsLoggingEventAvailable(): Boolean; cdecl; external WS3DCoreLib ;

function wInputReadLoggingEvent(): PwLoggingEvent; cdecl; external WS3DCoreLib ;

//User
function wInputIsUserEventAvailable(): Boolean; cdecl; external WS3DCoreLib ;

function wInputReadUserEvent(): PwUserEvent; cdecl; external WS3DCoreLib ;

//Keyboard
function wInputWaitKey(): Boolean; cdecl; external WS3DCoreLib ;

function wInputIsKeyEventAvailable(): Boolean; cdecl; external WS3DCoreLib ;

function wInputReadKeyEvent(): PwKeyEvent; cdecl; external WS3DCoreLib ;

function wInputIsKeyUp(num: wKeyCode): Boolean; cdecl; external WS3DCoreLib ;

function wInputIsKeyHit(num: wKeyCode): Boolean; cdecl; external WS3DCoreLib ;

function wInputIsKeyPressed(num: wKeyCode): Boolean; cdecl; external WS3DCoreLib ;

function wInputIsMouseEventAvailable(): Boolean; cdecl; external WS3DCoreLib ;

function wInputReadMouseEvent(): PwMouseEvent; cdecl; external WS3DCoreLib ;

procedure wInputSetCursorVisible(boShow: Boolean); cdecl; external WS3DCoreLib ;

function wInputIsCursorVisible(): Boolean; cdecl; external WS3DCoreLib ;

//Mouse
procedure wInputSetMousePosition(position: PwVector2i); cdecl; external WS3DCoreLib ;

procedure wInputGetMousePosition(position: PwVector2i); cdecl; external WS3DCoreLib ;

procedure wInputSetMouseLogicalPosition(position: PwVector2f); cdecl; external WS3DCoreLib ;

procedure wInputGetMouseLogicalPosition(position: PwVector2f); cdecl; external WS3DCoreLib ;

function wInputGetMouseWheel(): Float32; cdecl; external WS3DCoreLib ;

procedure wInputGetMouseDelta(deltaPos: PwVector2i); cdecl; external WS3DCoreLib ;

function wInputIsMouseUp(num: wMouseButtons): Boolean; cdecl; external WS3DCoreLib ;

function wInputIsMouseHit(num: wMouseButtons): Boolean; cdecl; external WS3DCoreLib ;

function wInputIsMousePressed(num: wMouseButtons): Boolean; cdecl; external WS3DCoreLib ;

function wInputGetMouseX(): Int32; cdecl; external WS3DCoreLib ;

function wInputGetMouseY(): Int32; cdecl; external WS3DCoreLib ;

function wInputGetMouseDeltaX(): Int32; cdecl; external WS3DCoreLib ;

function wInputGetMouseDeltaY(): Int32; cdecl; external WS3DCoreLib ;

//Joystick
function wInputActivateJoystick: Boolean; cdecl; external WS3DCoreLib ;

function wInputGetJoysitcksCount(): UInt32; cdecl; external WS3DCoreLib ;

procedure wInputGetJoystickInfo(joyIndex: UInt32; joyInfo: PwJoystickInfo); cdecl; external WS3DCoreLib ;

function wInputIsJoystickEventAvailable(): Boolean; cdecl; external WS3DCoreLib ;

function wInputReadJoystickEvent(): PwJoystickEvent; cdecl; external WS3DCoreLib ;

//wLight
function wLightCreate(position: wVector3f; color: wColor4f; radius: Float32): wNode; cdecl; external WS3DCoreLib ;

procedure wLightSetAmbientColor(light: wNode; color: wColor4f); cdecl; external WS3DCoreLib ;

function wLightGetAmbientColor(light: wNode): wColor4f; cdecl; external WS3DCoreLib ;

procedure wLightSetSpecularColor(light: wNode; color: wColor4f); cdecl; external WS3DCoreLib ;

function wLightGetSpecularColor(light: wNode): wColor4f; cdecl; external WS3DCoreLib ;

procedure wLightSetAttenuation(light: wNode; attenuation: wVector3f); cdecl; external WS3DCoreLib ;

function wLightGetAttenuation(light: wNode): wVector3f; cdecl; external WS3DCoreLib ;

procedure wLightSetCastShadows(light: wNode; castShadows: Boolean); cdecl; external WS3DCoreLib ;

function wLightIsCastShadows(light: wNode): Boolean; cdecl; external WS3DCoreLib ;

procedure wLightSetDiffuseColor(light: wNode; color: wColor4f); cdecl; external WS3DCoreLib ;

function wLightGetDiffuseColor(light: wNode): wColor4f; cdecl; external WS3DCoreLib ;

procedure wLightSetFallOff(light: wNode; FallOff: Float32); cdecl; external WS3DCoreLib ;

function wLightGetFallOff(light: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wLightSetInnerCone(light: wNode; InnerCone: Float32); cdecl; external WS3DCoreLib ;

function wLightGetInnerCone(light: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wLightSetOuterCone(light: wNode; OuterCone: Float32); cdecl; external WS3DCoreLib ;

function wLightGetOuterCone(light: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wLightSetRadius(light: wNode; Radius: Float32); cdecl; external WS3DCoreLib ;

function wLightGetRadius(light: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wLightSetType(light: wNode; _Type: wLightType); cdecl; external WS3DCoreLib ;

function wLightGetType(light: wNode): wLightType; cdecl; external WS3DCoreLib ;

function wLightGetDirection(light: wNode): wVector3f; cdecl; external WS3DCoreLib ;

//wBillboardGroup
function wBillboardGroupCreate(position, rotation, scale: wVector3f): wNode; cdecl; external WS3DCoreLib ;

procedure wBillboardGroupSetShadows(node: wNode; direction: wVector3f; intensity, ambient: Float32); cdecl; external WS3DCoreLib ;

procedure wBillboardGroupResetShadows(node: wNode); cdecl; external WS3DCoreLib ;

function wBillboardGroupGetSize(node: wNode): UInt32; cdecl; external WS3DCoreLib ;

function wBillboardGroupGetMeshBuffer(node: wNode): wMeshBuffer; cdecl; external WS3DCoreLib ;

procedure wBillboardGroupUpdateForce(node: wNode); cdecl; external WS3DCoreLib ;

function wBillboardGroupGetFirstElement(node: wNode): wBillboard; cdecl; external WS3DCoreLib ;

function wBillboardGroupAddElement(node: wNode; position: wVector3f; size: wVector2f;
          roll: Float32; color: wColor4s): PwBillboard; cdecl; external WS3DCoreLib ;

function wBillboardGroupAddElementByAxis(node: wNode; position: wVector3f;
          size: wVector2f; roll: Float32; color: wColor4s;
          axis: wVector3f): PwBillboard; cdecl; external WS3DCoreLib ;

procedure wBillboardGroupRemoveElement(node: wNode; billboard: PwBillboard); cdecl; external WS3DCoreLib ;

//wBillBoard
function wBillboardCreate(position: wVector3f; size: wVector2f): wNode; cdecl; external WS3DCoreLib ;

procedure wBillboardSetEnabledAxis(billboard: wNode; param: wBillboardAxisParam); cdecl; external WS3DCoreLib ;

function wBillboardGetEnabledAxis(billboard:wNode): wBillboardAxisParam; cdecl; external WS3DCoreLib ;

procedure wBillboardSetColor(node: wNode; topColor, bottomColor: wColor4s); cdecl; external WS3DCoreLib ;

procedure wBillboardSetSize(node: wNode; size: wVector2f); cdecl; external WS3DCoreLib ;

function wBillboardCreateText(position: wVector3f; size: wVector2f; font: wFont;
          text: PWString; topColor, bottomColor: wColor4s): wNode; cdecl; external WS3DCoreLib ;

//wSkyBox
function wSkyBoxCreate(texture_up, texture_down, texture_left, texture_right,
          texture_front, texture_back: wTexture): wNode; cdecl; external WS3DCoreLib ;

//wSkyDome
function wSkyDomeCreate(texture_file: wTexture; horiRes, vertRes: UInt32;
          texturePercentage, spherePercentage: Float64; domeRadius: Float64 = 1000.0): wNode; cdecl; external WS3DCoreLib ;

procedure wSkyDomeSetColor(dome: wNode; horizonColor, zenithColor: wColor4s); cdecl; external WS3DCoreLib ;

procedure wSkyDomeSetColorBand(dome: wNode; horizonColor: wColor4s; position: Int32;
          fade: Float32; additive: Boolean); cdecl; external WS3DCoreLib ;

procedure wSkyDomeSetColorPoint(dome: wNode; horizonColor: wColor4s; position: wVector3f;
          radius, fade: Float32; additive: Boolean); cdecl; external WS3DCoreLib ;

//wLodManager
function wLodManagerCreate(fadeScale: UInt32; useAlpha: Boolean;
          callbackFuncPointer: PUInt32): wNode; cdecl; external WS3DCoreLib ;

procedure wLodManagerAddMesh(node: wNode; mesh: wMesh; distance: Float32); cdecl; external WS3DCoreLib ;

procedure wLodManagerSetMaterialMap(node: wNode; source, target: wMaterialTypes); cdecl; external WS3DCoreLib ;

//wZoneManager
function wZoneManagerCreate(initialNearDistance, initialFarDistance: Float32): wNode; cdecl; external WS3DCoreLib ;

procedure wZoneManagerSetProperties(node: wNode; newNearDistance, newFarDistance: Float32;
          accumulateChildBoxes: Boolean); cdecl; external WS3DCoreLib ;

procedure wZoneManagerSetBoundingBox(node: wNode; position, size: wVector3f); cdecl; external WS3DCoreLib ;

procedure wZoneManagerAddTerrain(node, terrainSource: wNode; structureMap, colorMap, detailMap: Pchar;
          pos: wVector2i; sliceSize: Int32); cdecl; external WS3DCoreLib ;

//wWater
function wWaterSurfaceCreate(mesh: wMesh; waveHeight, waveSpeed, waveLength:Float32;
          position, rotation, scale: wVector3f): wNode; cdecl; external WS3DCoreLib ;

procedure wWaterSurfaceSetWaveHeight(water: wNode; newWaveHeight: Float32); cdecl; external WS3DCoreLib ;

procedure wWaterSurfaceSetWaveLength(water: wNode; newWaveLength: Float32); cdecl; external WS3DCoreLib ;

procedure wWaterSurfaceSetWaveSpeed(water: wNode; newWaveSpeed: Float32); cdecl; external WS3DCoreLib ;

function wWaterSurfaceGetWaveHeight(water: wNode): Float32; cdecl; external WS3DCoreLib ;

function wWaterSurfaceGetWaveLength(water: wNode): Float32; cdecl; external WS3DCoreLib ;

function wWaterSurfaceGetWaveSpeed(water: wNode): Float32; cdecl; external WS3DCoreLib ;

//wRealWater
function wRealWaterSurfaceCreate(bumpTexture: wTexture; size: wVector2f;
          renderSize: wVector2u; otherMesh: wMesh): wNode; cdecl; external WS3DCoreLib ;

procedure wRealWaterSetWindForce(water: wNode; force: Float32); cdecl; external WS3DCoreLib ;

function wRealWaterGetWindForce(water: wNode): Float32; cdecl; external WS3DCoreLib;

procedure wRealWaterSetWindDirection(water: wNode; direction: wVector2f); cdecl; external WS3DCoreLib ;

function wRealWaterGetWindDirection(water: wNode): wVector2f; cdecl; external WS3DCoreLib ;

procedure wRealWaterSetWaveHeight(water: wNode; height: Float32); cdecl; external WS3DCoreLib ;

function wRealWaterGetWaveHeight(water: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wRealWaterSetColor(water: wNode; color: wColor4f); cdecl; external WS3DCoreLib ;

function wRealWaterGetColor(water: wNode): wColor4f; cdecl; external WS3DCoreLib ;

procedure wRealWaterSetColorBlendFactor(water: wNode; factor: Float32); cdecl; external WS3DCoreLib ;

function wRealWaterGetColorBlendFactor(water: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wRealWaterSetWaveRealHeight(water: wNode; height: Float32); cdecl; external WS3DCoreLib ;

function wRealWaterGetWaveRealHeight(water: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wRealWaterSetWaveSpeed(water: wNode; speed: Float32); cdecl; external WS3DCoreLib ;

function wRealWaterGetWaveSpeed(water: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wRealWaterSetWaveLength(water: wNode; length: Float32); cdecl; external WS3DCoreLib ;

function wRealWaterGetWaveLength(water: wNode): Float32; cdecl; external WS3DCoreLib ;

//wClouds
function wCloudsCreate(texture: wTexture; lod, depth, density: UInt32): wNode; cdecl; external WS3DCoreLib ;

//wRealClouds
function wRealCloudsCreate(txture: wTexture; height: wVector3f; speed: wVector2f;
          textureScale: Float32): wNode; cdecl; external WS3DCoreLib ;

procedure wRealCloudsSetTextureTranslation(cloud: wNode; speed: wVector2f); cdecl; external WS3DCoreLib ;

function wRealCloudsGetTextureTranslation(cloud: wNode): wVector2f; cdecl; external WS3DCoreLib ;

procedure wRealCloudsSetTextureScale(cloud: wNode; scale: Float32); cdecl; external WS3DCoreLib ;

function wRealCloudsGetTextureScale(cloud: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wRealCloudsSetCloudHeight(cloud: wNode; height: wVector3f); cdecl; external WS3DCoreLib ;

function wRealCloudsGetCloudHeight(cloud: wNode): wVector3f; cdecl; external WS3DCoreLib ;

procedure wRealCloudsSetCloudRadius(cloud: wNode; radius: wVector2f); cdecl; external WS3DCoreLib ;

function wRealCloudsGetCloudRadius(cloud: wNode): wVector2f; cdecl; external WS3DCoreLib ;

procedure wRealCloudsSetColors(cloud: wNode; centerColor, innerColor, outerColor: wColor4s); cdecl; external WS3DCoreLib ;

procedure wRealCloudsGetColors(cloud: wNode; centerColor, innerColor, outerColor: PwColor4s); cdecl; external WS3DCoreLib ;

//wLensFlare
function wLensFlareCreate(txture: wTexture): wNode; cdecl; external WS3DCoreLib ;

procedure wLensFlareSetStrength(flare: wNode; strength: Float32); cdecl; external WS3DCoreLib ;

function wLensFlareGetStrength(flare: wNode): Float32; cdecl; external WS3DCoreLib ;

//wGrass/
function wGrassCreate(terrain: wNode; position: wVector2i; patchSize: UInt32;
          fadeDistance: Float32; crossed: Boolean; grassScale: Float32; maxDensity: UInt32;
          dataPosition: wVector2u; heightMap: wImage; textureMap: wImage;
          grassMap: wImage; grassTexture: wTexture): wNode; cdecl; external WS3DCoreLib ;

procedure wGrassSetDensity(grass: wNode; density: UInt32; distance: Float32); cdecl; external WS3DCoreLib ;

procedure wGrassSetWind(grass: wNode; strength, res: Float32); cdecl; external WS3DCoreLib ;

function wGrassGetDrawingCount(grass: wNode): UInt32; cdecl; external WS3DCoreLib ;

//wTreeGenerator
function wTreeGeneratorCreate(xmlFilePath: Pchar): wNode; cdecl; external WS3DCoreLib ;

procedure wTreeGeneratorDestroy(generator: wNode); cdecl; external WS3DCoreLib ;

//wTree
function wTreeCreate(generator: wNode; seed: Int32; billboardTexture: wTexture): wNode; cdecl; external WS3DCoreLib ;

procedure wTreeSetDistances(tree: wNode; midRange, farRange: Float32); cdecl; external WS3DCoreLib ;

function wTreeGetLeafNode(tree: wNode): wNode; cdecl; external WS3DCoreLib ;

procedure wTreeSetLeafEnabled(tree: wNode; value: Boolean); cdecl; external WS3DCoreLib ;

function wTreeIsLeafEnabled(tree: wNode): Boolean; cdecl; external WS3DCoreLib ;

procedure wTreeSetBillboardVertexColor(tree: wNode; color: wColor4s); cdecl; external WS3DCoreLib ;

function wTreeGetBillboardVertexColor(tree: wNode): wColor4s; cdecl; external WS3DCoreLib ;
//idx 1 or 0
function wTreeGetMeshBuffer(tree: wNode; idx: UInt32): wMeshBuffer; cdecl; external WS3DCoreLib ;

//wWindGenerator
function wWindGeneratorCreate(): wNode; cdecl; external WS3DCoreLib ;

procedure wWindGeneratorDestroy(windGenerator: wNode); cdecl; external WS3DCoreLib ;

procedure wWindGeneratorSetStrength(windGenerator: wNode; strength: Float32); cdecl; external WS3DCoreLib ;

function wWindGeneratorGetStrength(windGenerator: wNode): Float32; cdecl; external WS3DCoreLib ;

procedure wWindGeneratorSetRegularity(windGenerator: wNode; regularity: Float32); cdecl; external WS3DCoreLib;

function wWindGeneratorGetRegularity(windGenerator: wNode): Float32; cdecl; external WS3DCoreLib ;

function wWindGeneratorGetWind(windGenerator: wNode;position: wVector3f; timeMs: UInt32): wVector2f; cdecl; external WS3DCoreLib ;

//wBolt
function wBoltCreate(): wNode; cdecl; external WS3DCoreLib ;

procedure wBoltSetProperties(bolt: wNode; start, _end: wVector3f;
          updateTime, height: UInt32; thickness: Float32; parts,
          bolts: UInt32; steddyend: Boolean; color: wColor4s); cdecl; external WS3DCoreLib ;
//wBeam
function wBeamCreate(): wNode; cdecl; external WS3DCoreLib ;

procedure wBeamSetSize(beam: wNode; size: Float32); cdecl; external WS3DCoreLib ;

procedure wBeamSetPosition(beam: wNode; start, _end: wVector3f);cdecl; external WS3DCoreLib ;

//wParticleSystem
function wParticleSystemCreate(defaultemitter: Boolean; position,
          rotation, scale: wVector3f): wNode; cdecl; external WS3DCoreLib ;

function wParticleSystemGetEmitter(ps: wNode): wEmitter; cdecl; external WS3DCoreLib ;

procedure wParticleSystemSetEmitter(ps: wNode; em: wEmitter); cdecl; external WS3DCoreLib ;

procedure wParticleSystemRemoveAllAffectors(ps: wNode); cdecl; external WS3DCoreLib ;

function wParticleSystemGetAffectorByIndex(ps: wNode; idx: UInt32):wAffector; cdecl; external WS3DCoreLib ;

procedure wParticleSystemSetGlobal(ps: wNode; value: Boolean); cdecl; external WS3DCoreLib ;

function wParticleSystemIsGlobal(ps: wNode): Boolean; cdecl; external WS3DCoreLib ;

procedure wParticleSystemSetParticleSize(ps: wNode; size: wVector2f); cdecl; external WS3DCoreLib ;

function wParticleSystemGetParticleSize(ps: wNode): wVector2f; cdecl; external WS3DCoreLib ;

procedure wParticleSystemClear(ps: wNode); cdecl; external WS3DCoreLib ;

//wParticleEmitter (for all)
procedure wParticleEmitterSetParameters(em: wEmitter; params: wParticleEmitter); cdecl; external WS3DCoreLib ;

procedure wParticleEmitterGetParameters(em: wEmitter; params: PwParticleEmitter); cdecl; external WS3DCoreLib ;

function wParticleEmitterGetType(em: wEmitter): wParticleEmitterType; cdecl; external WS3DCoreLib ;

//wParticleBoxEmitter
function wParticleBoxEmitterCreate(ps: wNode): wEmitter; cdecl; external WS3DCoreLib ;

procedure wParticleBoxEmitterSetBox(em: wEmitter; boxMin, boxMax: wVector3f); cdecl; external WS3DCoreLib ;

procedure wParticleBoxEmitterGetBox(em: wEmitter; boxMin, boxMax: PwVector3f); cdecl; external WS3DCoreLib ;

//wParticleCylinderEmitter
function wParticleCylinderEmitterCreate(ps: wNode; center: wVector3f;
          radius: Float32; normal: wVector3f; lenght: Float32): wEmitter; cdecl; external WS3DCoreLib ;

procedure wParticleCylinderEmitterSetParameters(em: wEmitter;
          params: wParticleCylinderEmitter); cdecl; external WS3DCoreLib ;

procedure wParticleCylinderEmitterGetParameters(em: wEmitter;
          params: PwParticleCylinderEmitter); cdecl; external WS3DCoreLib ;

//wParticleMeshEmitter
function wParticleMeshEmitterCreate(ps: wNode; staticMesh: wMesh): wEmitter; cdecl; external WS3DCoreLib ;

procedure wParticleMeshEmitterSetParameters(em: wEmitter;
          params: wParticleMeshEmitter); cdecl; external WS3DCoreLib ;

procedure wParticleMeshEmitterGetParameters(em: wEmitter;
          params: PwParticleMeshEmitter); cdecl; external WS3DCoreLib ;

//wParticleAnimatedMeshEmitter
function wParticleAnimatedMeshEmitterCreate(ps: wNode;
          animMeshNode: wNode): wEmitter; cdecl; external WS3DCoreLib ;

procedure wParticleAnimatedMeshEmitterSetParameters(em: wEmitter;
          params: wParticleMeshEmitter); cdecl; external WS3DCoreLib;

procedure wParticleAnimatedMeshEmitterGetParameters(em: wEmitter;
          params: wParticleMeshEmitter); cdecl; external WS3DCoreLib;

//wParticlePointEmitter
function wParticlePointEmitterCreate(ps: wNode): wEmitter; cdecl; external WS3DCoreLib ;

//wParticleRingEmitter
function wParticleRingEmitterCreate(ps: wNode; center: wVector3f; radius,
          ringThickness: Float32): wEmitter; cdecl; external WS3DCoreLib;

procedure wParticleRingEmitterSetParameters(em: wEmitter;
          params: wParticleRingEmitter); cdecl; external WS3DCoreLib ;

procedure wParticleRingEmitterGetParameters(em: wEmitter;
          params: PwParticleRingEmitter); cdecl; external WS3DCoreLib ;

//wParticleSphereEmitter
function wParticleSphereEmitterCreate(ps: wNode; center: wVector3f;
          radius: Float32): wEmitter; cdecl; external WS3DCoreLib;

procedure wParticleSphereEmitterSetParameters(em: wEmitter;
          params: wParticleSphereEmitter); cdecl; external WS3DCoreLib ;

procedure wParticleSphereEmitterGetParameters(em: wEmitter;
          params: PwParticleSphereEmitter); cdecl; external WS3DCoreLib ;

//wParticleAffector (for all)
procedure wParticleAffectorSetEnable(foa: wAffector;
          enable: Boolean); cdecl; external WS3DCoreLib ;

function wParticleAffectorIsEnable(foa: wAffector): Boolean; cdecl; external WS3DCoreLib ;

function wParticleAffectorGetType(foa: wAffector): wParticleAffectorType; cdecl; external WS3DCoreLib;

//wParticleFadeOutAffector
function wParticleFadeOutAffectorCreate(ps: wNode): wAffector; cdecl; external WS3DCoreLib;

procedure wParticleFadeOutAffectorSetTime(paf: wAffector;
          fadeOutTime: UInt32 =1000); cdecl; external WS3DCoreLib;

function wParticleFadeOutAffectorGetTime(paf: wAffector): UInt32; cdecl; external WS3DCoreLib ;

procedure wParticleFadeOutAffectorSetColor(paf: wAffector;
          targetColor: wColor4s); cdecl; external WS3DCoreLib;

function wParticleFadeOutAffectorGetColor(paf: wAffector): wColor4s; cdecl; external WS3DCoreLib;

//wParticleGravityAffector
function wParticleGravityAffectorCreate(ps: wNode): wAffector; cdecl; external WS3DCoreLib;

procedure wParticleGravityAffectorSetGravity(paf: wAffector;
          gravity: wVector3f); cdecl; external WS3DCoreLib;

function wParticleGravityAffectorGetGravity(paf: wAffector): wVector3f; cdecl; external WS3DCoreLib ;

procedure wParticleGravityAffectorSetTimeLost(paf: wAffector;
          timeForceLost: UInt32); cdecl; external WS3DCoreLib;

function wParticleGravityAffectorGetTimeLost(paf: wAffector): UInt32; cdecl; external WS3DCoreLib ;

//wParticleAttractionAffector
function wParticleAttractionAffectorCreate(ps: wNode; point: wVector3f;
          speed: Float32): wAffector; cdecl; external WS3DCoreLib;

procedure wParticleAttractionAffectorSetParameters(paf: wAffector;
          params: wParticleAttractionAffector); cdecl; external WS3DCoreLib;

procedure wParticleAttractionAffectorGetParameters(paf: wAffector;
          params: PwParticleAttractionAffector); cdecl; external WS3DCoreLib;

//wParticleRotationAffector
function wParticleRotationAffectorCreate(ps: wNode): wAffector; cdecl; external WS3DCoreLib;

procedure wParticleRotationAffectorSetSpeed(paf: wAffector;
          speed: wVector3f); cdecl; external WS3DCoreLib;

function wParticleRotationAffectorGetSpeed(paf: wAffector): wVector3f; cdecl; external WS3DCoreLib ;

procedure wParticleRotationAffectorSetPivot(paf: wAffector;
          pivotPoint: wVector3f); cdecl; external WS3DCoreLib;

function wParticleRotationAffectorGetPivot(paf: wAffector): wVector3f; cdecl; external WS3DCoreLib ;

//wParticleStopAffector
function wParticleStopAffectorCreate(ps: wNode; em: wEmitter;
          time: UInt32): wAffector; cdecl; external WS3DCoreLib;

procedure wParticleStopAffectorSetTime(paf: wAffector;
          time: UInt32); cdecl; external WS3DCoreLib;

function wParticleStopAffectorGetTime(paf: wAffector): UInt32; cdecl; external WS3DCoreLib ;

//wParticleColorMorphAffector
function wParticleColorMorphAffectorCreate(ps: wNode): wAffector; cdecl; external WS3DCoreLib;

procedure wParticleColorAffectorSetParameters(paf: wAffector;
          params: wParticleColorMorphAffector); cdecl; external WS3DCoreLib;

procedure wParticleColorAffectorGetParameters(paf: wAffector;
          params: PwParticleColorMorphAffector); cdecl; external WS3DCoreLib;

//wParticlePushAffector
function wParticlePushAffectorCreate(ps: wNode): wAffector; cdecl; external WS3DCoreLib;

procedure wParticlePushAffectorSetParameters(paf: wAffector;
          params: wParticlePushAffector); cdecl; external WS3DCoreLib;

procedure wParticlePushAffectorGetParameters(paf: wAffector;
          params: PwParticlePushAffector); cdecl; external WS3DCoreLib;

//wParticleSplineAffector
function wParticleSplineAffectorCreate(ps: wNode): wAffector; cdecl; external WS3DCoreLib ;

procedure wParticleSplineAffectorSetParameters(paf: wAffector;
          params:wParticleSplineAffector); cdecl; external WS3DCoreLib ;

procedure wParticleSplineAffectorGetParameters(paf: wAffector;
          params: PwParticleSplineAffector); cdecl; external WS3DCoreLib;

//wParticleScaleAffector
function wParticleScaleAffectorCreate(ps: wNode;
          scaleTo: wVector2f): wAffector; cdecl; external WS3DCoreLib ;

procedure wParticleScaleAffectorSetTargetScale(paf: wAffector;
          tScale: wVector2f); cdecl; external WS3DCoreLib ;

function wParticleScaleAffectorGetTargetScale(paf: wAffector): wVector2f; cdecl; external WS3DCoreLib ;

//wNode
function wNodeCreateEmpty(): wNode; cdecl; external WS3DCoreLib ;

function wNodeCreateCube(size: Float32; isTangent: Boolean;
         color: wColor4s): wNode; cdecl; external WS3DCoreLib ;

procedure wNodeSetCubeParameters(cube: wNode; params: wNodeCubeParameters); cdecl; external WS3DCoreLib ;

procedure wNodeGetCubeParameters(cube: wNode; params: PwNodeCubeParameters); cdecl; external WS3DCoreLib ;

function wNodeCreateSphere(radius: Float32; polyCount: Int32; isTangent: Boolean;
          color: wColor4s): wNode; cdecl; external WS3DCoreLib ;

procedure wNodeSetSphereParameters(sphere: wNode; params: wNodeSphereParameters); cdecl; external WS3DCoreLib ;

procedure wNodeGetSphereParameters(sphere: wNode; params: PwNodeSphereParameters); cdecl; external WS3DCoreLib ;

function wNodeCreateCylinder(radius: Float32; length: Float32; tesselation: UInt32;
          color: wColor4s; closeTop: Boolean; oblique: Float32; isTangent: Boolean): wNode; cdecl; external WS3DCoreLib ;

procedure wNodeSetCylinderParameters(cylinder: wNode;
           params: wNodeCylinderParameters); cdecl; external WS3DCoreLib ;

procedure wNodeGetCylinderParameters(cylinder: wNode;
           params: PwNodeCylinderParameters); cdecl; external WS3DCoreLib ;

function wNodeCreateCone(radius: Float32; length: Float32; tesselation: UInt32;
          colorTop, colorBottom: wColor4s; isTangent: Boolean): wNode; cdecl; external WS3DCoreLib;

procedure wNodeSetConeParameters(cone: wNode; params: wNodeConeParameters); cdecl; external WS3DCoreLib;

procedure wNodeGetConeParameters(cone: wNode; params: PwNodeConeParameters); cdecl; external WS3DCoreLib;

function wNodeCreatePlane(tileSize: wVector2f; tileCount: wVector2u;
          material: wMaterial; texRepeatCount: wVector2f; isTangent: Boolean): wNode; cdecl; external WS3DCoreLib;

procedure wNodeSetPlaneParameters(plane: wNode; params: wNodePlaneParameters); cdecl; external WS3DCoreLib;

procedure wNodeGetPlaneParameters(plane: wNode; params: PwNodePlaneParameters); cdecl; external WS3DCoreLib;

function wNodeCreateFromMesh(mesh: wMesh; isStatic: Boolean=false): wNode; cdecl; external WS3DCoreLib;

function wNodeCreateFromStaticMesh(mesh: wMesh; isTangent: Boolean = false): wNode; cdecl; external WS3DCoreLib;

function wNodeCreateFromMeshAsOctree(vptrMesh: wMesh; minimalPolysPerNode: Int32 = 512;
          alsoAddIfMeshPointerZero: Boolean = false; isTangent: Boolean = false): wNode; cdecl; external WS3DCoreLib;

function wNodeCreateFromBatchingMesh(batchMesh: wMesh): wNode; cdecl; external WS3DCoreLib;

function wNodeCreateFromBatchingMeshAsOctree(batchMesh: wMesh;
          minimalPolysPerNode: Int32; alsoAddIfMeshPointerZero: Boolean): wNode; cdecl; external WS3DCoreLib;

procedure wNodeSetDecalsEnabled(node: wNode); cdecl; external WS3DCoreLib;

procedure wNodeSetParent(node: wNode; parent: wNode); cdecl; external WS3DCoreLib;

function wNodeGetParent(node: wNode): wNode; cdecl; external WS3DCoreLib;

procedure wNodeSetReadOnlyMaterials(node: wNode; readonly: Boolean); cdecl; external WS3DCoreLib;

function wNodeIsReadOnlyMaterials(node: wNode): Boolean; cdecl; external WS3DCoreLib;

function wNodeGetFirstChild(node: wNode; iterator: PUInt32): wNode; cdecl; external WS3DCoreLib;

function wNodeGetChildsCount(node: wNode; iterator: PUInt32): UInt32; cdecl; external WS3DCoreLib;

function wNodeGetNextChild(node: wNode; iterator: PUInt32): wNode; cdecl; external WS3DCoreLib;

function wNodeIsLastChild(node: wNode; iterator: PUInt32): Boolean; cdecl; external WS3DCoreLib;

function wNodeDestroyChild(node: wNode; child: wNode): Boolean; cdecl; external WS3DCoreLib;

procedure wNodeSetId(node: wNode; id: Int32); cdecl; external WS3DCoreLib;

function wNodeGetId(node: wNode): Int32; cdecl; external WS3DCoreLib;

procedure wNodeSetName(node: wNode; const name: PChar); cdecl; external WS3DCoreLib;

function wNodeGetName(node: wNode): PChar; cdecl; external WS3DCoreLib;

procedure wNodeSetUserData(node: wNode; newData: Pointer); cdecl; external WS3DCoreLib;

function wNodeGetUserData(node: wNode): Pointer; cdecl; external WS3DCoreLib;

procedure wNodeSetDebugMode(node: wNode; visible: wDebugMode); cdecl; external WS3DCoreLib;

procedure wNodeSetDebugDataVisible(node: wNode; value: Boolean); cdecl; external WS3DCoreLib;

function wNodeGetMaterialsCount(node: wNode): UInt32; cdecl; external WS3DCoreLib;

function wNodeGetMaterial(node: wNode; matIndex: UInt32): wMaterial; cdecl; external WS3DCoreLib;

procedure wNodeSetPosition(node: wNode; position: wVector3f); cdecl; external WS3DCoreLib;

function wNodeGetPosition(node: wNode): wVector3f; cdecl; external WS3DCoreLib;

function wNodeGetAbsolutePosition(node: wNode): wVector3f; cdecl; external WS3DCoreLib;

procedure wNodeGetTransformMatrix(node: wNode; matrix4_4: PFloat32); cdecl; external WS3DCoreLib;

procedure wNodeSetRotation(node: wNode; rotation: wVector3f); cdecl; external WS3DCoreLib;

procedure wNodeSetAbsoluteRotation(node: wNode; rotation: wVector3f); cdecl; external WS3DCoreLib;

function wNodeGetRotation(node: wNode): wVector3f; cdecl; external WS3DCoreLib;

function wNodeGetAbsoluteRotation(node: wNode): wVector3f; cdecl; external WS3DCoreLib;

procedure wNodeTurn(Entity: wNode; turn: wVector3f); cdecl; external WS3DCoreLib;

procedure wNodeMove(Entity: wNode; direction: wVector3f); cdecl; external WS3DCoreLib;

procedure wNodeRotateToNode(Entity1, Entity2: wNode); cdecl; external WS3DCoreLib;

function wNodesGetBetweenDistance(nodeA, nodeB: wNode): Float32; cdecl; external WS3DCoreLib;

function wNodesAreIntersecting(nodeA, nodeB: wNode): Boolean; cdecl; external WS3DCoreLib;

function wNodeIsPointInside(node: wNode; pos: wVector3f): Boolean; cdecl; external WS3DCoreLib;

procedure wNodeDrawBoundingBox(node: wNode; color: wColor4s); cdecl; external WS3DCoreLib;

procedure wNodeGetBoundingBox(Node: wNode; min, max: PwVector3f); cdecl; external WS3DCoreLib;

procedure wNodeGetTransformedBoundingBox(Node: wNode; min, max: PwVector3f); cdecl; external WS3DCoreLib;

procedure wNodeSetScale(node: wNode; scale: wVector3f); cdecl; external WS3DCoreLib;

function wNodeGetScale(node: wNode): wVector3f; cdecl; external WS3DCoreLib;

function wNodeDuplicate(entity: wNode): wNode; cdecl; external WS3DCoreLib;

function wNodeGetJointByName(node: wNode; const node_name: PChar): wNode; cdecl; external WS3DCoreLib;

function wNodeGetJointById(node: wNode; id: Int32): wNode; cdecl; external WS3DCoreLib;

function wNodeGetJointsCount(node: wNode): Int32; cdecl; external WS3DCoreLib;

procedure wNodeSetJointSkinningSpace(bone: wNode; space: wBoneSkinningSpace); cdecl; external WS3DCoreLib;

function wNodeGetJointSkinningSpace(bone: wNode): wBoneSkinningSpace; cdecl; external WS3DCoreLib;

procedure wNodeSetRenderFromIdentity(animatedNode: wNode; value: Boolean); cdecl; external WS3DCoreLib;

function wNodeAddShadowVolume(node: wNode; mesh: wMesh; zfailMethod: Boolean;
          infinity: Float32; oldStyle: Boolean): wNode; cdecl; external WS3DCoreLib;

function wNodeAddShadowVolumeFromMeshBuffer(node: wNode; meshbuffer: wMeshBuffer;
          zfailMethod: Boolean; infinity: Float32; oldStyle: Boolean): wNode; cdecl; external WS3DCoreLib;

function wNodeGetShadowVolume(node: wNode): wNode; cdecl; external WS3DCoreLib;

procedure wNodeUpdateShadow(shadow: wNode); cdecl; external WS3DCoreLib;

{ for octree only }
procedure wNodeSetOctreeParameters(node: wNode; params: wOctreeParameters); cdecl; external WS3DCoreLib;

procedure wNodeGetOctreeParameters(node: wNode; params: PwOctreeParameters); cdecl; external WS3DCoreLib;

procedure wNodeSetVisibility(node: wNode; visible: Boolean); cdecl; external WS3DCoreLib;

function wNodeIsVisible(node: wNode): Boolean; cdecl; external WS3DCoreLib;

function wNodeIsInView(node: wNode): Boolean; cdecl; external WS3DCoreLib;

procedure wNodeDestroy(node: wNode); cdecl; external WS3DCoreLib;

procedure wNodeSetMesh(node: wNode; mesh: wMesh); cdecl; external WS3DCoreLib;

function wNodeGetMesh(node: wNode): wMesh; cdecl; external WS3DCoreLib;

procedure wNodeSetRotationPositionChange(node: wNode; angles, offset: wVector3f;
           forwardStore, upStore: PwVector3f; numOffsets: UInt32;
           offsetStore: PwVector3f); cdecl; external WS3DCoreLib;

procedure wNodeSetCullingState(node: wNode; state: wCullingState); cdecl; external WS3DCoreLib;

function wNodeGetType(node: wNode): wSceneNodeType; cdecl; external WS3DCoreLib;

procedure wNodeSetAnimationRange(node: wNode; range: wVector2i); cdecl; external WS3DCoreLib;

procedure wNodeGetAnimationRange(node: wNode; range: PwVector2i); cdecl; external WS3DCoreLib;

procedure wNodePlayMD2Animation(node: wNode; iAnimation: wMd2AnimationType); cdecl; external WS3DCoreLib;

function wNodeGetPlayedMD2Animation(node: wNode): wMd2AnimationType; cdecl; external WS3DCoreLib;

procedure wNodeSetAnimationSpeed(node: wNode; fSpeed: Float32); cdecl; external WS3DCoreLib;

function wNodeGetAnimationSpeed(node: wNode): Float32; cdecl; external WS3DCoreLib;

procedure wNodeSetAnimationFrame(node: wNode; fFrame: Float32); cdecl; external WS3DCoreLib;

function wNodeGetAnimationFrame(node: wNode): Float32; cdecl; external WS3DCoreLib;

function wNodeGetAnimationFramesCount(node: wNode): Int32; cdecl; external WS3DCoreLib;

procedure wNodeSetTransitionTime(node: wNode; fTime: Float32); cdecl; external WS3DCoreLib;

procedure wNodeAnimateJoints(node: wNode); cdecl; external WS3DCoreLib;

procedure wNodeSetJointMode(node: wNode; mode: wJointMode); cdecl; external WS3DCoreLib;

procedure wNodeSetAnimationLoopMode(node: wNode; value: Boolean); cdecl; external WS3DCoreLib;

function wNodeGetAnimationLoopMode(node: wNode): Boolean; cdecl; external WS3DCoreLib;

procedure wNodeDestroyAllAnimators(node: wNode); cdecl; external WS3DCoreLib;

function wNodeGetAnimatorsCount(node: wNode): UInt32; cdecl; external WS3DCoreLib;

function wNodeGetFirstAnimator(node: wNode): wAnimator; cdecl; external WS3DCoreLib;

function wNodeGetLastAnimator(node: wNode): wAnimator; cdecl; external WS3DCoreLib;

function wNodeGetAnimatorByIndex(node: wNode; index: UInt32): wAnimator; cdecl; external WS3DCoreLib;

procedure wNodeDestroyAnimator(node: wNode; anim: wAnimator); cdecl; external WS3DCoreLib;

procedure wNodeOnAnimate(node: wNode; timeMs: UInt32); cdecl; external WS3DCoreLib;

procedure wNodeDraw(node: wNode); cdecl; external WS3DCoreLib;

procedure wNodeUpdateAbsolutePosition(node: wNode); cdecl; external WS3DCoreLib;

procedure wNodeRemoveCollision(node: wNode; selector: wSelector); cdecl; external WS3DCoreLib;

procedure wNodeAddCollision(node: wNode; selector: wSelector); cdecl; external WS3DCoreLib;

(* ?????????????????? (wMaterial...)                                                   *)
(* ???????????????? ?? ???????????????????? ??????????????????????, ?????????????? ?????????? ???????? ?????????????????? ?? ????????,    *)
(* ?????????? ???????????????? ?? ???????????????????????????? ????????????.                                    *)
(* ???????????????? ?????????????????? ?????????????????????????? ?????????? ?? ???????????????????? ???????? ????????????????.         *)

// ???????????????????? ???????????????? ?????? ??????????????????
procedure wMaterialSetTexture(material: wMaterial;
          texIdx: UInt32; texture: wTexture); cdecl; external WS3DCoreLib ;

//???????????????????? ????????????????, ?????????????????????? ?? ?????????????????? ???????????????????? ?? ???????????????????? ???????? index
function wMaterialGetTexture(material: wMaterial;
          texIdx: UInt32): wTexture; cdecl; external WS3DCoreLib;

procedure wMaterialSetTextureScale(material: wMaterial;
          texIdx: UInt32; scale: wVector2f); cdecl; external WS3DCoreLib ;

function wMaterialGetTextureScale(material: wMaterial;
          texIdx: UInt32): wVector2f; cdecl; external WS3DCoreLib;

procedure wMaterialSetTextureScaleFromCenter(material: wMaterial;
           texIdx: UInt32; scale: wVector2f); cdecl; external WS3DCoreLib;

procedure wMaterialSetTextureTranslation(material: wMaterial; texIdx: UInt32;
           translate: wVector2f); cdecl; external WS3DCoreLib;

function wMaterialGetTextureTranslation(material: wMaterial;
           texIdx: UInt32): wVector2f; cdecl; external WS3DCoreLib;

procedure wMaterialSetTextureTranslationTransposed(material: wMaterial;
           texIdx: UInt32; translate: wVector2f); cdecl; external WS3DCoreLib;

procedure wMaterialSetTextureRotation(material: wMaterial;
           texIdx: UInt32; angle: Float32); cdecl; external WS3DCoreLib;

function wMaterialGetTextureRotation(material: wMaterial;
           texIdx: UInt32): Float32; cdecl; external WS3DCoreLib;

procedure wMaterialSaveTextureMatrix(material: wMaterial; texIdx: UInt32;
           array16Ptr: PFloat32); cdecl; external WS3DCoreLib;

procedure wMaterialRestoreTextureMatrix(material: wMaterial; texIdx: UInt32;
           array16Ptr: PFloat32); cdecl; external WS3DCoreLib;

procedure wMaterialSetTextureWrapUMode(material: wMaterial;
          texIdx: UInt32; value: wTextureClamp); cdecl; external WS3DCoreLib ;

function wMaterialGetTextureWrapUMode(material: wMaterial;
          texIdx: UInt32): wTextureClamp; cdecl; external WS3DCoreLib ;

procedure wMaterialSetTextureWrapVMode(material: wMaterial;
          texIdx: UInt32; value: wTextureClamp); cdecl; external WS3DCoreLib ;

 function wMaterialGetTextureWrapVMode(material: wMaterial;
          texIdx: UInt32): wTextureClamp; cdecl; external WS3DCoreLib ;

procedure wMaterialSetTextureLodBias(material: wMaterial;
          texIdx: UInt32; lodBias: UInt32); cdecl; external WS3DCoreLib ;

function wMaterialGetTextureLodBias(material: wMaterial;
          texIdx: UInt32): UInt32; cdecl; external WS3DCoreLib ;

procedure wMaterialSetFlag(material: wMaterial;
          Flag: wMaterialFlags; boValue: Boolean); cdecl; external WS3DCoreLib ;

function wMaterialGetFlag(material: wMaterial;
          matFlag: wMaterialFlags): Boolean; cdecl; external WS3DCoreLib ;

procedure wMaterialSetType(material: wMaterial;
          _type: wMaterialTypes); cdecl; external WS3DCoreLib ;

function wMaterialGetType(material: wMaterial): wMaterialTypes; cdecl; external WS3DCoreLib ;

procedure wMaterialSetShininess(material: wMaterial;
          shininess: Float32); cdecl; external WS3DCoreLib ;

function wMaterialGetShininess(material: wMaterial): Float32; cdecl; external WS3DCoreLib ;

procedure wMaterialSetVertexColoringMode(material: wMaterial;
          colorMaterial: wColorMaterial); cdecl; external WS3DCoreLib ;

function wMaterialGetVertexColoringMode(material: wMaterial): wColorMaterial; cdecl; external WS3DCoreLib ;

procedure wMaterialSetSpecularColor(material: wMaterial;
          color: wColor4s); cdecl; external WS3DCoreLib ;

function wMaterialGetSpecularColor(material: wMaterial): wColor4s; cdecl; external WS3DCoreLib ;

procedure wMaterialSetDiffuseColor(material: wMaterial;
          color: wColor4s); cdecl; external WS3DCoreLib ;

function wMaterialGetDiffuseColor(material: wMaterial): wColor4s; cdecl; external WS3DCoreLib ;

procedure wMaterialSetAmbientColor(material: wMaterial;
          color: wColor4s); cdecl; external WS3DCoreLib ;

function wMaterialGetAmbientColor(material: wMaterial): wColor4s; cdecl; external WS3DCoreLib ;

procedure wMaterialSetEmissiveColor(material: wMaterial;
          color: wColor4s); cdecl; external WS3DCoreLib ;

function wMaterialGetEmissiveColor(material: wMaterial): wColor4s; cdecl; external WS3DCoreLib ;

procedure wMaterialSetTypeParameter(material: wMaterial;
          param1: Float32); cdecl; external WS3DCoreLib ;

function wMaterialGetTypeParameter(material: wMaterial): Float32; cdecl; external WS3DCoreLib ;

procedure wMaterialSetTypeParameter2(material: wMaterial;
          param2: Float32); cdecl; external WS3DCoreLib ;

function wMaterialGetTypeParameter2(material: wMaterial): Float32; cdecl; external WS3DCoreLib ;

procedure wMaterialSetBlendingMode(material: wMaterial; paramNumber: UInt32;
           blendSrc, blendDest: wBlendFactor; modulate: wBlendModulateFunc;
           alphaSource: wBlendAlphaSource); cdecl; external WS3DCoreLib ;

procedure wMaterialGetBlendingMode(material: wMaterial; paramNumber: UInt32;
           blendSrc, blendDest: PwBlendFactor; modulate: PwBlendModulateFunc;
           alphaSource: PwBlendAlphaSource); cdecl; external WS3DCoreLib ;

procedure wMaterialSetLineThickness(material: wMaterial;
          lineThickness: Float32); cdecl; external WS3DCoreLib ;

function wMaterialGetLineThickness(material: wMaterial): Float32; cdecl; external WS3DCoreLib ;

procedure wMaterialSetColorMask(material: wMaterial;
          value: wColorPlane); cdecl; external WS3DCoreLib;

function wMaterialGetColorMask(material: wMaterial): wColorPlane; cdecl; external WS3DCoreLib ;

procedure wMaterialSetAntiAliasingMode(material: wMaterial; mode: wAntiAliasingMode); cdecl; external WS3DCoreLib;

function wMaterialGetAntiAliasingMode(material: wMaterial): wAntiAliasingMode; cdecl; external WS3DCoreLib;

(* ?????????????? (wShader...) *)

{ ?????????????? ?????? ???????????? ?? ??????????????????????, ???????????????????????????? ???? ???????????????????? GPU,
  ?? ???? ???? ?????????????????????? ????????????????????. }

function wShaderCreateNamedVertexConstant(shader: PwShader; name: Pchar; preset: Int32;
          floats: PFloat32; count:Int32): Boolean; cdecl; external WS3DCoreLib ;

function wShaderCreateNamedPixelConstant(shader: PwShader; const name: PChar;
          preset: Int32; floats: PFloat32; count: Int32): Boolean; cdecl; external WS3DCoreLib ;

function wShaderCreateAddressedVertexConstant(shader: PwShader; address, preset: Int32;
          floats: PFloat32; count: Int32): Boolean; cdecl; external WS3DCoreLib ;

function wShaderCreateAddressedPixelConstant(shader: PwShader; address, preset: Int32;
          floats: PFloat32; count: Int32): Boolean; cdecl; external WS3DCoreLib ;

function wShaderAddHighLevelMaterial(const vertexShaderProgram,
          vertexShaderEntryPointName: PChar; wVersion: wVertexShaderVersion;
          pixelShaderProgram, pixelShaderEntryPointName: PChar; pVersion: wPixelShaderVersion;
	  materialType: wMaterialTypes; userData: Int32): PwShader; cdecl; external WS3DCoreLib ;

function wShaderAddHighLevelMaterialFromFiles(vertexShaderProgramFileName: PChar;
          vertexShaderEntryPointName: Pchar; wVersion: wVertexShaderVersion;
          pixelShaderProgramFileName: PChar; pixelShaderEntryPointName: PChar;
	  pVersion: wPixelShaderVersion; materialType: wMaterialTypes;
	  userData: Int32): PwShader; cdecl; external WS3DCoreLib ;

function wShaderAddMaterial(vertexShaderProgram: PChar; pixelShaderProgram: PChar;
          materialType: wMaterialTypes; userData: Int32): PwShader; cdecl; external WS3DCoreLib ;

function wShaderAddMaterialFromFiles(vertexShaderProgramFileName: PChar;
          pixelShaderProgramFileName: PChar; materialType: wMaterialTypes;
	  userData: Int32): PwShader; cdecl; external WS3DCoreLib;

function wShaderAddHighLevelMaterialEx(vertexShaderProgram: PChar;
          vertexShaderEntryPointName: PChar; wVersion: wVertexShaderVersion;
          pixelShaderProgram: PChar; pixelShaderEntryPointName: Pchar;
	  pVersion: wPixelShaderVersion; geometryShaderProgram: PChar;
	  geometryShaderEntryPointName: PChar; gVersion: wGeometryShaderVersion;
	  inType: wPrimitiveType; outType: wPrimitiveType;
	  verticesOut: UInt32; materialType: wMaterialTypes;
	  userData: Int32): PwShader; cdecl; external WS3DCoreLib;

function wShaderAddHighLevelMaterialFromFilesEx(vertexShaderProgramFileName: PChar;
          vertexShaderEntryPointName: PChar; wVersion: wVertexShaderVersion;
	  pixelShaderProgramFileName: PChar; pixelShaderEntryPointName: PChar;
	  pVersion: wPixelShaderVersion; geometryShaderProgram: PChar;
	  geometryShaderEntryPointName: PChar; gVersion: wGeometryShaderVersion;
	  inType, outType: wPrimitiveType; verticesOut: UInt32;
	  materialType: wMaterialTypes; userData: Int32): PwShader; cdecl; external WS3DCoreLib;

//Mesh
procedure wMeshMakePlanarTextureMapping(mesh: wMesh; resolution: Float32); cdecl; external WS3DCoreLib;

procedure wMeshMakePlanarTextureMappingAdvanced(mesh: wMesh; resolutionH,
           resolutionV: Float32; axis: UInt8; offset: wVector3f); cdecl; external WS3DCoreLib;

function wMeshLoad(const cptrFile: PChar; ToTangents: Boolean=false): wMesh; cdecl; external WS3DCoreLib;

function wMeshCreate(const cptrMeshName: PChar): wMesh; cdecl; external WS3DCoreLib;

procedure wMeshAddMeshBuffer(mesh: wMesh; meshBuffer: wMeshBuffer); cdecl; external WS3DCoreLib;

function wMeshCreateSphere(const name: PChar; radius: Float32; polyCount: Int32;
          isTangent: Boolean=false): wMesh; cdecl; external WS3DCoreLib;

function wMeshCreateCube(const name: PChar; size: wVector3f; isTangent:
          Boolean=false): wMesh; cdecl; external WS3DCoreLib;

function wMeshCreateCylinder(const name: PChar; radius, length: Float32;
          tesselation: UInt32; closeTop: Boolean; oblique: Float32;
          isTangent: Boolean=false): wMesh; cdecl; external WS3DCoreLib;

function wMeshCreateCone(const name: PChar; radius, length: Float32;
          tesselation: UInt32; isTangent: Boolean=false): wMesh; cdecl; external WS3DCoreLib;

function wMeshSave(mesh: wMesh; type_: wMeshFileFormat; const filename: PChar): Int32; cdecl; external WS3DCoreLib;

procedure wMeshDestroy(mesh: wMesh); cdecl; external WS3DCoreLib;

function wMeshSetName(mesh: wMesh; const name: PChar): Boolean; cdecl; external WS3DCoreLib;

function wMeshGetName(mesh: wMesh): PChar; cdecl; external WS3DCoreLib;

function wMeshGetType(mesh: wMesh): wAnimatedMeshType; cdecl; external WS3DCoreLib;

{
 When animating a mesh by "Morphing" or "Skeletal Animation" such as "*.md3", "*.x" and "*.b3d" using "Shaders" for rendering we can improve the final render if we "Cyclically Update" the "Tangents" and "Binormals"..
 We presume that our meshes are, among others, textured with a "NORMAL MAP" used by the "Shader" (cg, hlsl, or glsl etc) in calculating diffuse and specular.
 We also have one or more lights used by the shader.

 Update TANGENTS & BINORMALS at every frame for a skinned animation..

 We dont want to do this for static meshes like levels etc..
 We also dont want to do it for Rotating, Scaled and translated meshes..(we can however, as a bonus, scale, rotate and translate these)
 Only for animated skinned and morph based meshes..
 This is loose code that works. If anyone can improve it for the engine itself that would be great..
 You'll probably ID possible improvements immediately!

 At every N'th Frame we loop through all the vertices..
 1. In the loop we Access the VERTEX of POINT A of the "INDEXED TRIANGLE"..
 2. We interrogate the "OTHER TWO" VERTICES (which thankfully do change at each frame) for their Positions, Normals, and UV Coords to
    Genertate a "BRAND NEW" (animated) TANGENT and BINORMAL. (We may want to calculate the the "Binormal" in the SHADER to save time)
 3. We REWRITE the Tangent and Binormal for our SELECTED TRIANGLE POINT.
 4. We DO THE SAME for POINTS B and C..


   GENERATE "LIVING" TANGENTS & BINBORMALS
   REMEMBER!
   WE NEED "LOOP THROUGH ALL ITS BUFFERS"
   WE NEED "LOOP THROUGH ALL THOSE BUFFER VERTICES"
  Possible types of (animated) meshes.
  Enumerator:
  1  EAMT_MD2            Quake 2 MD2 model file..
  2  EAMT_MD3            Quake 3 MD3 model file..
  10 EAMT_MDL_HALFLIFE   Halflife MDL model file..
  Below is what an item type must be for it to qualify for Tangent Updates..
  11 EAMT_SKINNED        generic skinned mesh "*.x" "*.b3d" etc.. (see Morphed too!)

  We want to change tangents for skinned meshes only so we must determine which ones are "Skinned"..
  This may change if we add and remove meshes during runtime..'}

function wMeshCreateStaticWithTangents(animMesh: wMesh): wMesh; cdecl; external WS3DCoreLib;

procedure wMeshRecalculateNormals(mesh: wMesh; smooth, angleWeighted: Boolean); cdecl; external WS3DCoreLib;

procedure wMeshRecalculateTangents(mesh: wMesh; recalculateNormals, smooth,
           angleWeighted: Boolean); cdecl; external WS3DCoreLib;

procedure wMeshUpdateTangentsAndBinormals(mesh: wMesh); cdecl; external WS3DCoreLib;

procedure wMeshFlipSurface(mesh: wMesh); cdecl; external WS3DCoreLib;

function wMeshCreateHillPlane(const meshname: PChar; tilesSize: wVector2f;
          tilesCount: wVector2i; material: wMaterial; hillHeight: Float32;
          countHills: wVector2f; texRepeatCount: wVector2f): wMesh; cdecl; external WS3DCoreLib;

function wMeshCreateArrow(const name: PChar; cylinderColor, coneColor: wColor4s;
          tesselationCylinder: UInt32; tesselationCone: UInt32; height: Float32;
          heightCylinder: Float32; widthCylinder: Float32; widthCone: Float32): wMesh; cdecl; external WS3DCoreLib;

function wMeshCreateBatching(): wMesh; cdecl; external WS3DCoreLib;

procedure wMeshAddToBatching(meshBatch: wMesh; mesh: wMesh; position: wVector3f;
           rotation: wVector3f; scale: wVector3f); cdecl; external WS3DCoreLib;

function wMeshFinalizeBatching(meshBatch: wMesh): wMesh; cdecl; external WS3DCoreLib;

procedure wMeshClearBatching(meshBatch: wMesh); cdecl; external WS3DCoreLib;

procedure wMeshDestroyBatching(meshBatch: wMesh); cdecl; external WS3DCoreLib;

procedure wMeshEnableBatchingHardwareAcceleration(meshBatch: wMesh); cdecl; external WS3DCoreLib;

procedure wMeshUpdateBatching(meshBatch: wMesh); cdecl; external WS3DCoreLib;

procedure wMeshEnableHardwareAcceleration(mesh: wMesh; iFrame: UInt32); cdecl; external WS3DCoreLib;

function wMeshGetFramesCount(mesh: wMesh): UInt32; cdecl; external WS3DCoreLib;

function wMeshGetIndicesCount(mesh: wMesh; iFrame: UInt32 = 0;
          iMeshBuffer: UInt32 = 0): UInt32; cdecl; external WS3DCoreLib;

function wMeshGetIndices(mesh: wMesh; iFrame: UInt32 = 0;
          iMeshBuffer: UInt32 = 0): PUInt16; cdecl; external WS3DCoreLib;

procedure wMeshSetIndices(mesh: wMesh; iFrame: UInt32; indicies: PUInt16;
           iMeshBuffer: UInt32); cdecl; external WS3DCoreLib;

function wMeshGetVerticesCount(mesh: wMesh; iFrame: UInt32 = 0;
           iMeshBuffer: UInt32 = 0): UInt32; cdecl; external WS3DCoreLib;

procedure wMeshGetVertices(mesh: wMesh; iFrame: UInt32; verts: PwVert;
           iMeshBuffer: UInt32); cdecl; external WS3DCoreLib;

function wMeshGetVerticesMemory(mesh: wMesh; iFrame,
           iMeshBuffer: UInt32): UInt32; cdecl; external WS3DCoreLib;

procedure wMeshSetVertices(mesh: wMesh; iFrame: UInt32; verts: PwVert;
           iMeshBuffer: UInt32 = 0); cdecl; external WS3DCoreLib;

procedure wMeshSetScale(mesh: wMesh; scale: Float32; iFrame: Uint32 = 0; iMeshBuffer: UInt32 = 0;
           sourceMesh: wMesh = nil); cdecl; external WS3DCoreLib;

procedure wMeshSetRotation(mesh: wMesh; rot: wVector3f); cdecl; external WS3DCoreLib;

procedure wMeshSetVerticesColors(mesh: wMesh; iFrame: UInt32; verticesColor: PwColor4s;
           groupCount: UInt32; startPos, endPos: PUInt32; iMeshBuffer: UInt32); cdecl; external WS3DCoreLib;

procedure wMeshSetVerticesAlpha(mesh: wMesh; iFrame: UInt32; value: UInt8); cdecl; external WS3DCoreLib;

procedure wMeshSetVerticesCoords(mesh: wMesh; iFrame: UInt32; vertexCoord: PwVector3f;
           groupCount: UInt32; startPos, endPos: PUInt32; iMeshBuffer: UInt32); cdecl; external WS3DCoreLib;

procedure wMeshSetVerticesSingleColor(mesh: wMesh; iFrame: UInt32; verticesColor: wColor4s;
           groupCount: UInt32; startPos, endPos: PUInt32; iMeshBuffer: UInt32); cdecl; external WS3DCoreLib;

procedure wMeshGetBoundingBox(mesh: wMesh; min, max: PwVector3f); cdecl; external WS3DCoreLib;

function wMeshDuplicate(src: wMesh): wMesh; cdecl; external WS3DCoreLib;

procedure wMeshFit(src: wMesh; pivot: wVector3f; delta: PwVector3f); cdecl; external WS3DCoreLib;

function wMeshIsEmpty(mesh: wMesh): Boolean; cdecl; external WS3DCoreLib;

function wMeshGetBuffersCount(mesh: wMesh; iFrame: UInt32): UInt32; cdecl; external WS3DCoreLib;

function wMeshGetBuffer(mesh: wMesh; iFrame, index: UInt32): wMeshBuffer; cdecl; external WS3DCoreLib;

// wMeshBuffer

function wMeshBufferCreate(iVertexCount: UInt32; vVertices: PwVert;
           iIndicesCount: UInt32; usIndices: PUInt16): wMeshBuffer; cdecl; external WS3DCoreLib;

procedure wMeshBufferDestroy(buffer: wMeshBuffer); cdecl; external WS3DCoreLib;

function wMeshBufferGetMaterial(buf: wMeshBuffer): wMaterial; cdecl; external WS3DCoreLib;

procedure wMeshBufferAddToBatching(meshBatch: wMesh; buffer: wMeshBuffer; position,
           rotation, scale: wVector3f); cdecl; external WS3DCoreLib;

// wBsp

function wBspGetEntityList(mesh: wMesh): PUInt32; cdecl; external WS3DCoreLib;

function wBspGetEntityListSize(entityList: PUInt32): Int32; cdecl; external WS3DCoreLib;

function wBspGetEntityIndexByName(entityList: PUInt32;
           const EntityName: PChar): wVector2i; cdecl; external WS3DCoreLib;

function wBspGetEntityNameByIndex(entityList: PUInt32;
           number: UInt32): PChar; cdecl; external WS3DCoreLib;

function wBspGetEntityMeshFromBrush(bspMesh: wMesh; entityList: PUInt32;
           index: Int32): wMesh; cdecl; external WS3DCoreLib;

function wBspGetVarGroupByIndex(entityList: PUInt32; index: Int32): PUInt32; cdecl; external WS3DCoreLib;

function wBspGetVarGroupSize(entityList: PUInt32; index: Int32): UInt32; cdecl; external WS3DCoreLib;

function wBspGetVarGroupValueAsVec(group: PUInt32; const strName: PChar;
          parsePos: UInt32): wVector3f; cdecl; external WS3DCoreLib;

function wBspGetVarGroupValueAsFloat(group: PUInt32; const strName: PChar;
          parsePos: UInt32): Float32; cdecl; external WS3DCoreLib;

function wBspGetVarGroupValueAsString(group: PUInt32; const strName: PChar): PChar; cdecl; external WS3DCoreLib;

function wBspCreateFromMesh(mesh: wMesh; isTangent, isOctree: Boolean;
          const fileEntity: PChar; isLoadShaders: Boolean = true; PolysPerNode: UInt32 = 512): wNode; cdecl; external WS3DCoreLib;

function wBspGetVariableFromVarGroup(group: PUInt32; index: Int32): PUInt32; cdecl; external WS3DCoreLib;

function wBspGetVarGroupVariableSize(group: PUInt32): UInt32; cdecl; external WS3DCoreLib;

function wBspGetVariableName(variable: PUInt32): PChar; cdecl; external WS3DCoreLib;

function wBspGetVariableContent(variable: PUInt32): PChar; cdecl; external WS3DCoreLib;

function wBspGetVariableValueAsVec(variable: PUInt32; parsePos: UInt32): wVector3f; cdecl; external WS3DCoreLib;

function wBspGetVariableValueAsFloat(variable: PUInt32; parsePos: UInt32): Float32; cdecl; external WS3DCoreLib;

// Occlusion Query

procedure wOcclusionQueryAddNode(node: wNode); cdecl; external WS3DCoreLib;

procedure wOcclusionQueryAddMesh(node: wNode; mesh: wMesh); cdecl; external WS3DCoreLib;

procedure wOcclusionQueryUpdate(node: wNode; block: Boolean); cdecl; external WS3DCoreLib;

procedure wOcclusionQueryRun(node: wNode; visible: Boolean); cdecl; external WS3DCoreLib;

procedure wOcclusionQueryUpdateAll(block: Boolean); cdecl; external WS3DCoreLib;

procedure wOcclusionQueryRunAll(visible: Boolean); cdecl; external WS3DCoreLib;

procedure wOcclusionQueryRemoveNode(node:wNode); cdecl; external WS3DCoreLib;

procedure wOcclusionQueryRemoveAll(); cdecl; external WS3DCoreLib;

function wOcclusionQueryGetResult(node: wNode): Uint32; cdecl; external WS3DCoreLib;

// wSphericalTerrain
function wSphericalTerrainCreate(const cptrFile0, cptrFile1, cptrFile2, cptrFile3,
          cptrFile4, cptrFile5: PChar; position, rotation, scale: wVector3f;
          color: wColor4s; smootFactor: Int32; spherical: Boolean;
          maxLOD: Int32; patchSize: wTerrainPatchSize): wNode; cdecl; external WS3DCoreLib;

procedure wSphericalTerrainSetTextures(terrain: wNode; textureTop, textureFront,
          textureBack, textureLeft, textureRight, textureBottom: wTexture;
          materialIndex: UInt32); cdecl; external WS3DCoreLib;

procedure wSphericalTerrainLoadVertexColor(terrain: wNode; imageTop, imageFront,
          imageBack, imageLeft, imageRight, imageBottom: wImage); cdecl; external WS3DCoreLib;

function wSphericalTerrainGetSurfacePosition(terrain: wNode; face: Int32;
          logicalPos: wVector2f): wVector3f; cdecl; external WS3DCoreLib;

function wSphericalTerrainGetSurfaceAngle(terrain: wNode; face: Int32;
          logicalPos: wVector2f): wVector3f; cdecl; external WS3DCoreLib;

function wSphericalTerrainGetSurfaceLogicalPosition(terrain: wNode;
          position: wVector3f; face: PInt32): wVector2f; cdecl; external WS3DCoreLib;

// wTerrain
function wTerrainCreate(const cptrFile: PChar; position, rotation,
          scale: wVector3f; color: wColor4s; smoothing: Int32; maxLOD: Int32;
	  patchSize: wTerrainPatchSize): wNode; cdecl; external WS3DCoreLib;

procedure wTerrainScaleDetailTexture(terrain: wNode; scale: wVector2f); cdecl; external WS3DCoreLib;

function wTerrainGetHeight(terrain: wNode; positionXZ: wVector2f): Float32; cdecl; external WS3DCoreLib;

// wTiledTerrain
function wTiledTerrainCreate(image: wImage; tileSize: Int32; dataSize: wVector2i;
          position, rotation, scale: wVector3f; color: wColor4s; smoothing: Int32;
          maxLOD: Int32; patchSize: wTerrainPatchSize): wNode; cdecl; external WS3DCoreLib;

procedure wTiledTerrainAddTile(terrain, neighbour: wNode;
          edge: wTiledTerrainEdge); cdecl; external WS3DCoreLib;

procedure wTiledTerrainSetTileStructure(terrain: wNode; image: wImage;
          data: wVector2i); cdecl; external WS3DCoreLib;

procedure wTiledTerrainSetTileColor(terrain: wNode; image: wImage;
          data: wVector2i); cdecl; external WS3DCoreLib;

// wSoundBuffer
function wSoundBufferLoad(const filePath: PChar): wSoundBuffer; cdecl; external WS3DCoreLib;

function wSoundBufferLoadFromMemory(const data: PChar; length: Int32;
          const extension: PChar): wSoundBuffer; cdecl; external WS3DCoreLib;

procedure wSoundBufferDestroy(buffer: wSoundBuffer); cdecl; external WS3DCoreLib;

// wSound
function wSoundLoad(const filePath: PChar; stream: Boolean): wSound; cdecl; external WS3DCoreLib;

function wSoundLoadFromMemory(const name, data: PChar; length: Int32;
          const extension: PChar): wSound; cdecl; external WS3DCoreLib;


function wSoundLoadFromRaw(const name, data: PChar; length: Int32; frequency: UInt32;
          format: wAudioFormats): wSound; cdecl; external WS3DCoreLib;

function wSoundCreateFromBuffer(buf: wSoundBuffer): wSound; cdecl; external WS3DCoreLib;

function wSoundIsPlaying(sound: wSound): Boolean; cdecl; external WS3DCoreLib;

function wSoundIsPaused(sound: wSound): Boolean; cdecl; external WS3DCoreLib;

function wSoundIsStopped(sound: wSound): Boolean; cdecl; external WS3DCoreLib;

procedure wSoundSetVelocity(sound: wSound; velocity: wVector3f); cdecl; external WS3DCoreLib;

function wSoundGetVelocity(sound: wSound): wVector3f; cdecl; external WS3DCoreLib;

procedure wSoundSetDirection(sound: wSound; direction: wVector3f); cdecl; external WS3DCoreLib;

function wSoundGetDirection(sound: wSound): wVector3f; cdecl; external WS3DCoreLib;

procedure wSoundSetVolume(sound: wSound; value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetVolume(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetMaxVolume(sound: wSound; value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetMaxVolume(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetMinVolume(sound: wSound; value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetMinVolume(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetPitch(sound: wSound; value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetPitch(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetRollOffFactor(sound: wSound; value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetRollOffFactor(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetStrength(sound: wSound; value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetStrength(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetMinDistance(sound: wSound; value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetMinDistance(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetMaxDistance(sound: wSound; Value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetMaxDistance(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetInnerConeAngle(sound: wSound; Value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetInnerConeAngle(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetOuterConeAngle(sound: wSound; Value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetOuterConeAngle(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetOuterConeVolume(sound: wSound; Value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetOuterConeVolume(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetDopplerStrength(sound: wSound; Value: Float32); cdecl; external WS3DCoreLib;

function wSoundGetDopplerStrength(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetDopplerVelocity(sound: wSound; velocity: wVector3f); cdecl; external WS3DCoreLib;

function wSoundGetDopplerVelocity(sound: wSound): wVector3f; cdecl; external WS3DCoreLib;

function wSoundCalculateGain(sound: wSound): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetRelative(sound: wSound; value: Boolean); cdecl; external WS3DCoreLib;

function wSoundIsRelative(sound: wSound): Boolean; cdecl; external WS3DCoreLib;

function wSoundPlay(sound: wSound; loop: Boolean): Boolean; cdecl; external WS3DCoreLib;

procedure wSoundStop(sound: wSound); cdecl; external WS3DCoreLib;

procedure wSoundPause(sound: wSound); cdecl; external WS3DCoreLib;

procedure wSoundSetLoopMode(sound: wSound; value: Boolean); cdecl; external WS3DCoreLib;

function wSoundIsLooping(sound: wSound): Boolean; cdecl; external WS3DCoreLib;

function wSoundIsValid(sound: wSound): Boolean; cdecl; external WS3DCoreLib;

function wSoundSeek(sound: wSound; seconds: Float32; relative: Boolean): Boolean; cdecl; external WS3DCoreLib;

procedure wSoundUpdate(sound: wSound); cdecl; external WS3DCoreLib;

function wSoundGetTotalAudioTime(sound: wSound): Float32; cdecl; external WS3DCoreLib;

function wSoundGetTotalAudioSize(sound: wSound): Int32; cdecl; external WS3DCoreLib;

function wSoundGetCompressedAudioSize(sound: wSound): Int32; cdecl; external WS3DCoreLib;

function wSoundGetCurrentAudioTime(sound: wSound): Float32; cdecl; external WS3DCoreLib;

function wSoundGetCurrentAudioPosition(sound: wSound): Int32; cdecl; external WS3DCoreLib;

function wSoundGetCurrentCompressedAudioPosition(sound: wSound): Int32; cdecl; external WS3DCoreLib;

function wSoundGetNumEffectSlotsAvailable(sound: wSound): UInt32; cdecl; external WS3DCoreLib;

function wSoundAddEffect(sound: wSound; slot: UInt32; effect: wSoundEffect): Boolean; cdecl; external WS3DCoreLib;

procedure wSoundRemoveEffect(sound: wSound; slot: UInt32); cdecl; external WS3DCoreLib;

procedure wSoundDestroyEffect(soundEffect: wSoundEffect); cdecl; external WS3DCoreLib;

function wSoundCreateEffect(): wSoundEffect; cdecl; external WS3DCoreLib;

function wSoundIsEffectValid(effect: wSoundEffect): Boolean; cdecl; external WS3DCoreLib;

function wSoundIsEffectSupported(type_ : wSoundEffectType): Boolean; cdecl; external WS3DCoreLib;

function wSoundGetMaxEffectsSupported(): UInt32; cdecl; external WS3DCoreLib;

procedure wSoundSetEffectType(effect: wSoundEffect; type_: wSoundEffectType); cdecl; external WS3DCoreLib;

function wSoundGetEffectType(effect: wSoundEffect): wSoundEffectType; cdecl; external WS3DCoreLib;

procedure wSoundSetEffectAutowahParameters(effect: wSoundEffect; param: wAutowahParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectChorusParameters(effect: wSoundEffect; param: wChorusParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectCompressorParameters(effect: wSoundEffect; param: wCompressorParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectDistortionParameters(effect: wSoundEffect; param: wDistortionParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectEaxReverbParameters(effect: wSoundEffect; param: wEaxReverbParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectEchoParameters(effect: wSoundEffect; param: wEchoParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectEqualizerParameters(effect: wSoundEffect; param: wEqualizerParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectFlangerParameters(effect: wSoundEffect; param: wFlangerParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectFrequencyShiftParameters(effect: wSoundEffect; param: wFrequencyShiftParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectPitchShifterParameters(effect: wSoundEffect; param: wPitchShifterParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectReverbParameters(effect: wSoundEffect; param: wReverbParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectRingModulatorParameters(effect: wSoundEffect; param: wRingModulatorParameters); cdecl; external WS3DCoreLib;

procedure wSoundSetEffectVocalMorpherParameters(effect: wSoundEffect; param: wVocalMorpherParameters); cdecl; external WS3DCoreLib;

function wSoundCreateFilter(): wSoundFilter; cdecl; external WS3DCoreLib;

function wSoundIsFilterValid(filter: wSoundFilter): Boolean; cdecl; external WS3DCoreLib;

function wSoundAddFilter(sound: wSound; filter: wSoundFilter): Boolean; cdecl; external WS3DCoreLib;

procedure wSoundRemoveFilter(sound: wSound); cdecl; external WS3DCoreLib;

procedure wSoundDestroyFilter(soundFilter: wSoundFilter); cdecl; external WS3DCoreLib;

function wSoundIsFilterSupported(type_: wSoundFilterType): Boolean; cdecl; external WS3DCoreLib;

procedure wSoundSetFilterType(filter: wSoundFilter; type_: wSoundFilterType); cdecl; external WS3DCoreLib;

function wSoundGetFilterType(filter: wSoundFilter): wSoundFilterType; cdecl; external WS3DCoreLib;

procedure wSoundSetFilterVolume(filter: wSoundFilter; volume: Float32); cdecl; external WS3DCoreLib;

function wSoundGetFilterVolume(filter: wSoundFilter): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetFilterHighFrequencyVolume(filter: wSoundFilter; volumeHF: Float32); cdecl; external WS3DCoreLib;

function wSoundGetFilterHighFrequencyVolume(filter: wSoundFilter): Float32; cdecl; external WS3DCoreLib;

procedure wSoundSetFilterLowFrequencyVolume(filter: wSoundFilter; volumeLF: Float32); cdecl; external WS3DCoreLib;

function wSoundGetFilterLowFrequencyVolume(filter: wSoundFilter): Float32; cdecl; external WS3DCoreLib;

// wVideo

function wVideoLoad(const fileName: PChar): wVideo; cdecl; external WS3DCoreLib;

procedure wVideoPlay(player: wVideo); cdecl; external WS3DCoreLib;

function wVideoIsPlaying(player: wVideo): Boolean; cdecl; external WS3DCoreLib;

procedure wVideoRewind(player: wVideo); cdecl; external WS3DCoreLib;

procedure wVideoSetLoopMode(player: wVideo; looping: Boolean); cdecl; external WS3DCoreLib;

function wVideoIsLooping(player: wVideo): Boolean; cdecl; external WS3DCoreLib;

function wVideoCreateTargetImage(player: wVideo; position: wVector2i): wGuiObject; cdecl; external WS3DCoreLib;

function wVideoGetTargetTexture(player: wVideo): wTexture; cdecl; external WS3DCoreLib;

function wVideoGetSoundNode(player: wVideo): wSound; cdecl; external WS3DCoreLib;

procedure wVideoUpdate(player: wVideo; timeMs: UInt32); cdecl; external WS3DCoreLib;

procedure wVideoPause(player: wVideo); cdecl; external WS3DCoreLib;

function wVideoIsPaused(player: wVideo): Boolean; cdecl; external WS3DCoreLib;

function wVideoIsAtEnd(player: wVideo): Boolean; cdecl; external WS3DCoreLib;

function wVideoIsEmpty(player: wVideo): Boolean; cdecl; external WS3DCoreLib;

function wVideoGetFramePosition(player: wVideo): Int64; cdecl; external WS3DCoreLib;

function wVideoGetTimePosition(player: wVideo): UInt32; cdecl; external WS3DCoreLib;

function wVideoGetFrameSize(player: wVideo): wVector2i; cdecl; external WS3DCoreLib;

function wVideoGetQuality(player: wVideo): Int32; cdecl; external WS3DCoreLib;

procedure wVideoDestroy(player: wVideo); cdecl; external WS3DCoreLib;

// wDecal

function wDecalCreateFromRay(texture: wTexture; startRay, endRay: wVector3f;
          dimension, textureRotation, lifeTime, visibleDistance: Float32): wNode; cdecl; external WS3DCoreLib;

function wDecalCreateFromPoint(texture: wTexture; position, normal: wVector3f;
          dimension, textureRotation, visibleDistance: Float32): wNode; cdecl; external WS3DCoreLib;

function wDecalGetLifeTime(node: wNode): Float32; cdecl; external WS3DCoreLib;

procedure wDecalSetLifeTime(node: wNode; lifeTime: Float32); cdecl; external WS3DCoreLib;

function wDecalGetMaxVisibleDistance(node: wNode): Float32; cdecl; external WS3DCoreLib;

procedure wDecalSetMaxVisibleDistance(node: wNode; distance: Float32); cdecl; external WS3DCoreLib;

procedure wDecalSetFadeOutParams(node: wNode; isfadeOut: Boolean; time: Float32); cdecl; external WS3DCoreLib;

procedure wDecalsClear(); cdecl; external WS3DCoreLib;

procedure wDecalsDestroyAll(); cdecl; external WS3DCoreLib;

procedure wDecalsCombineAll(); cdecl; external WS3DCoreLib;

function wDecalsGetCount(): Int32; cdecl; external WS3DCoreLib;


// wNetPacket
function wNetPacketCreate(id: UInt64; inOrder, reliable: Boolean;
          priority: UInt64): wPacket; cdecl; external WS3DCoreLib;

procedure wNetPacketWriteUInt(msg: wPacket; value: UInt32); cdecl; external WS3DCoreLib;

procedure wNetPacketWriteInt(msg: wPacket; value: Int32); cdecl; external WS3DCoreLib;

procedure wNetPacketWriteFloat(msg: wPacket; value: Float32); cdecl; external WS3DCoreLib;

procedure wNetPacketWriteString(msg: wPacket; const newString: PChar); cdecl; external WS3DCoreLib;

function wNetPacketReadUint(numPacket: Int32): UInt32; cdecl; external WS3DCoreLib;

function wNetPacketReadInt(numPacket: Int32): Int32; cdecl; external WS3DCoreLib;

function wNetPacketReadFloat(numPacket: Int32): Float32; cdecl; external WS3DCoreLib;

function wNetPacketReadString(numPacket: Int32): PChar; cdecl; external WS3DCoreLib;

function wNetPacketReadMessage(numPacket: Int32): PChar; cdecl; external WS3DCoreLib;

function wNetPacketGetId(numPacket: Int32): UInt64; cdecl; external WS3DCoreLib;

function wNetPacketGetClientIp(numPacket: Int32): PChar; cdecl; external WS3DCoreLib;

function wNetPacketGetClientPtr(numPacket: Int32): Pointer; cdecl; external WS3DCoreLib;

function wNetPacketGetClientPort(numPacket: Int32): UInt16; cdecl; external WS3DCoreLib;


// wNetManager
procedure wNetManagerSetVerbose(value: Boolean); cdecl; external WS3DCoreLib;

procedure wNetManagerSetMessageId(newId: UInt64); cdecl; external WS3DCoreLib;

function wNetManagerGetMessageId(): UInt64; cdecl; external WS3DCoreLib;

procedure wNetManagerDestroyAllPackets(); cdecl; external WS3DCoreLib;

function wNetManagerGetPacketsCount(): Int32; cdecl; external WS3DCoreLib;

// wNetServer
function wNetServerCreate(port: UInt16; mode: Int32; maxClientsCount: Int32 = -1): Boolean; cdecl; external WS3DCoreLib;

procedure wNetServerUpdate(sleepMs: Int32 = 100; countIteration: Int32 = 100;
          maxMSecsToWait: Int32 = -1); cdecl; external WS3DCoreLib;

procedure wNetServerClear(); cdecl; external WS3DCoreLib;

procedure wNetServerSendPacket(destPtr: Pointer; msg: wPacket); cdecl; external WS3DCoreLib;

procedure wNetServerBroadcastMessage(const text: PChar); cdecl; external WS3DCoreLib;

procedure wNetServerAcceptNewConnections(value: Boolean); cdecl; external WS3DCoreLib;

procedure wNetServerStop(msTime: Int32 = 100); cdecl; external WS3DCoreLib;

function wNetServerGetClientsCount(): Int32; cdecl; external WS3DCoreLib;

procedure wNetServerKickClient(clientPtr: Pointer); cdecl; external WS3DCoreLib;

procedure wNetServerUnKickClient(clientPtr: Pointer); cdecl; external WS3DCoreLib;

procedure wNetServerClearBannedList(); cdecl; external WS3DCoreLib;

// wNetClient
function wNetClientCreate(address: PChar; port: UInt16; mode: Int32;
          maxMSecsToWait: Int32 = 500): Boolean; cdecl; external WS3DCoreLib;

procedure wNetClientUpdate(maxMessagesToProcess: Int32 = 100;
           countIteration: Int32 = 100; maxMSecsToWait: Int32 = -1); cdecl; external WS3DCoreLib;

procedure wNetClientDisconnect(maxMSecsToWait: Int32 = 500); cdecl; external WS3DCoreLib;

procedure wNetClientStop(maxMSecsToWait: Int32 = 500); cdecl; external WS3DCoreLib;

function wNetClientIsConnected(): Boolean; cdecl; external WS3DCoreLib;

procedure wNetClientSendMessage(text: PChar); cdecl; external WS3DCoreLib;

procedure wNetClientSendPacket(msg: wPacket); cdecl; external WS3DCoreLib;


// wPhys
function wPhysStart(): Boolean; cdecl; external WS3DCoreLib;

procedure wPhysUpdate(timeStep: Float32); cdecl; external WS3DCoreLib;

procedure wPhysStop(); cdecl; external WS3DCoreLib;

procedure wPhysSetGravity(gravity: wVector3f); cdecl; external WS3DCoreLib;

procedure wPhysSetWorldSize(sizeMin: wVector3f; sizeMax: wVector3f); cdecl; external WS3DCoreLib;

procedure wPhysSetSolverModel(model: wPhysSolverModel); cdecl; external WS3DCoreLib;

procedure wPhysSetFrictionModel(model: wPhysFrictionModel); cdecl; external WS3DCoreLib;

procedure wPhysDestroyAllBodies(); cdecl; external WS3DCoreLib;

procedure wPhysDestroyAllJoints(); cdecl; external WS3DCoreLib;

function wPhysGetBodiesCount(): Int32; cdecl; external WS3DCoreLib;

function wPhysGetJointsCount(): Int32; cdecl; external WS3DCoreLib;

function wPhysGetBodyPicked(position: wVector2i; mouseLeftKey: Boolean): wNode; cdecl; external WS3DCoreLib;

function wPhysGetBodyFromRay(start, end_: wVector3f): wNode; cdecl; external WS3DCoreLib;

function wPhysGetBodyFromScreenCoords(position: wVector2i): wNode; cdecl; external WS3DCoreLib;

function wPhysGetBodyByName(const name: PChar): wNode; cdecl; external WS3DCoreLib;

function wPhysGetBodyById(Id: Int32): wNode; cdecl; external WS3DCoreLib;

function wPhysGetBodyByIndex(idx: Int32): wNode; cdecl; external WS3DCoreLib;

function wPhysGetJointByName(const name: PChar): wNode; cdecl; external WS3DCoreLib;

function wPhysGetJointById(Id: Int32): wNode; cdecl; external WS3DCoreLib;

function wPhysGetJointByIndex(idx: Int32): wNode; cdecl; external WS3DCoreLib;


// wPhysBody
function wPhysBodyCreateNull(): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateCube(size: wVector3f; Mass: Float32): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateSphere(radius: wVector3f; Mass: Float32): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateCone(radius, height, mass: Float32; Offset: Boolean): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateCylinder(radius, height, mass: Float32; Offset: Boolean): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateCapsule(radius, height, mass: Float32; Offset: Boolean = false): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateHull(mesh: wNode; mass: Float32): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateTree(mesh: wNode): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateTreeBsp(mesh: wMesh; node: wNode): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateTerrain(mesh: wNode; LOD: Int32): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateHeightField(mesh: wNode): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateWaterSurface(size: wVector3f; FluidDensity,
           LinearViscosity, AngulaViscosity: Float32): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyCreateCompound(nodes: PwNode; CountNodes: Int32; mass: Float32): wNode; cdecl; external WS3DCoreLib;

function wPhysBodyGetRotation(body: wNode): wVector3f; cdecl; external WS3DCoreLib;

procedure wPhysBodySetName(body: wNode; const name: PChar); cdecl; external WS3DCoreLib;

function wPhysBodyGetName(body: wNode): PChar; cdecl; external WS3DCoreLib;

procedure wPhysBodySetFreeze(body: wNode; freeze: Boolean); cdecl; external WS3DCoreLib;

function wPhysBodyIsFreeze(body: wNode): Boolean; cdecl; external WS3DCoreLib;

procedure wPhysBodySetMaterial(body: wNode; MatId: Int32); cdecl; external WS3DCoreLib;

function wPhysBodyGetMaterial(body: wNode): Int32; cdecl; external WS3DCoreLib;

procedure wPhysBodySetGravity(body: wNode; gravity: wVector3f); cdecl; external WS3DCoreLib;

function wPhysBodyGetGravity(body: wNode): wVector3f; cdecl; external WS3DCoreLib;

procedure wPhysBodySetMass(body: wNode; NewMass: Float32); cdecl; external WS3DCoreLib;

function wPhysBodyGetMass(body: wNode): Float32; cdecl; external WS3DCoreLib;

procedure wPhysBodySetCenterOfMass(body: wNode; center: wVector3f); cdecl; external WS3DCoreLib;

function wPhysBodyGetCenterOfMass(body: wNode): wVector3f; cdecl; external WS3DCoreLib;

procedure wPhysBodySetMomentOfInertia(body: wNode; value: wVector3f); cdecl; external WS3DCoreLib;

function wPhysBodyGetMomentOfInertia(body: wNode): wVector3f; cdecl; external WS3DCoreLib;

procedure wPhysBodySetAutoSleep(body: wNode; value: Boolean); cdecl; external WS3DCoreLib;

function wPhysBodyIsAutoSleep(body: wNode): Boolean; cdecl; external WS3DCoreLib;

procedure wPhysBodySetLinearVelocity(body: wNode; velocity: wVector3f); cdecl; external WS3DCoreLib;

function wPhysBodyGetLinearVelocity(body: wNode): wVector3f; cdecl; external WS3DCoreLib;

procedure wPhysBodySetAngularVelocity(body: wNode; velocity: wVector3f); cdecl; external WS3DCoreLib;

function wPhysBodyGetAngularVelocity(body: wNode): wVector3f; cdecl; external WS3DCoreLib;

procedure wPhysBodySetLinearDamping(body: wNode; linearDamp: Float32); cdecl; external WS3DCoreLib;

function wPhysBodyGetLinearDamping(body: wNode): Float32; cdecl; external WS3DCoreLib;

procedure wPhysBodySetAngularDamping(body: wNode; damping: wVector3f); cdecl; external WS3DCoreLib;

function wPhysBodyGetAngularDamping(body: wNode): wVector3f; cdecl; external WS3DCoreLib;

procedure wPhysBodyAddImpulse(body: wNode; velosity, position: wVector3f); cdecl; external WS3DCoreLib;

procedure wPhysBodyAddForce(body: wNode; force: wVector3f); cdecl; external WS3DCoreLib;

procedure wPhysBodyAddTorque(body: wNode; torque: wVector3f); cdecl; external WS3DCoreLib;

function wPhysBodiesIsCollide(body1, body2: wNode): Boolean; cdecl; external WS3DCoreLib;

function wPhysBodiesGetCollisionPoint(body1, body2: wNode): wVector3f; cdecl; external WS3DCoreLib;

function wPhysBodiesGetCollisionNormal(body1, body2: wNode): wVector3f; cdecl; external WS3DCoreLib;

procedure wPhysBodyDraw(body: wNode); cdecl; external WS3DCoreLib;

// wPhysJoint
function wPhysJointCreateBall(position, pinDir: wVector3f; body1, body2: wNode): wNode; cdecl; external WS3DCoreLib;

function wPhysJointCreateHinge(position, pinDir: wVector3f; body1, body2: wNode): wNode; cdecl; external WS3DCoreLib;

function wPhysJointCreateSlider(position, pinDir: wVector3f; body1, body2: wNode): wNode; cdecl; external WS3DCoreLib;

function wPhysJointCreateCorkScrew(position, pinDir: wVector3f; body1, body2: wNode): wNode; cdecl; external WS3DCoreLib;

function wPhysJointCreateUpVector(position: wVector3f; body: wNode): wNode; cdecl; external WS3DCoreLib;

procedure wPhysJointSetName(joint: wNode; const name: PChar); cdecl; external WS3DCoreLib;

function wPhysJointGetName(joint: wNode): PChar; cdecl; external WS3DCoreLib;

procedure wPhysJointSetCollisionState(joint: wNode; isCollision: Boolean); cdecl; external WS3DCoreLib;

function wPhysJointIsCollision(Joint: wNode): Boolean; cdecl; external WS3DCoreLib;

procedure wPhysJointSetBallLimits(joint: wNode; MaxConeAngle: Float32; twistAngles: wVector2f); cdecl; external WS3DCoreLib;

procedure wPhysJointSetHingeLimits(joint: wNode; anglesLimits: wVector2f); cdecl; external WS3DCoreLib;

procedure wPhysJointSetSliderLimits(joint: wNode; anglesLimits: wVector2f); cdecl; external WS3DCoreLib;

procedure wPhysJointSetCorkScrewLinearLimits(joint: wNode; distLimits: wVector2f); cdecl; external WS3DCoreLib;

procedure wPhysJointSetCorkScrewAngularLimits(joint: wNode; distLimits: wVector2f); cdecl; external WS3DCoreLib;

// wPhysPlayerController
function wPhysPlayerControllerCreate(position: wVector3f; body: wNode;
           maxStairStepFactor, cushion: Float32): wNode; cdecl; external WS3DCoreLib;

procedure wPhysPlayerControllerSetVelocity(joint: wNode; forwardSpeed,
           sideSpeed, heading: Float32); cdecl; external WS3DCoreLib;

// wPhysVehicle
function wPhysVehicleCreate(tiresCount: Int32; rayCastType: wPhysVehicleType;
          CarBody: wNode): wNode; cdecl; external WS3DCoreLib;



function wPhysVehicleAddTire(Car, UserData: wNode; tireType: wPhysVehicleTireType;
          position: wVector3f; Mass, Radius, Width, SLenght, SConst, SDamper: Float32): Int32; cdecl; external WS3DCoreLib;

function wPhysVehicleGetSpeed(Car: wNode): Float32; cdecl; external WS3DCoreLib;

function wPhysVehicleGetTiresCount(Car: wNode): Int32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetBrake(Car:wNode; value: Boolean); cdecl; external WS3DCoreLib;

function wPhysVehicleIsBrake(Car: wNode): Boolean; cdecl; external WS3DCoreLib;

function wPhysVehicleIsAllTiresCollided(Car: wNode): Boolean; cdecl; external WS3DCoreLib;

function wPhysVehicleIsTireOnAir(car: wNode; tireIndex: Int32): Boolean; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetSteering(Car: wNode; angle: Float32); cdecl; external WS3DCoreLib;// -1.......+1

function wPhysVehicleGetSteering(Car: wNode): Float32; cdecl; external WS3DCoreLib;  // return value: -1......+1

function wPhysVehicleGetBody(Car: wNode): wNode; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetMotorValue(Car: wNode; value: Float32); cdecl; external WS3DCoreLib; //-1....+1

function wPhysVehicleGetMotorValue(Car: wNode): Float32; cdecl; external WS3DCoreLib;

// Vehicle Tires
procedure wPhysVehicleSetTireMaxSteerAngle(Car: wNode; tireIndex: Int32; angleDeg: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireMaxSteerAngle(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireLocalPosition(Car: wNode; tireIndex: Int32): wVector3f; cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireUpDownPosition(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireAngularVelocity(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireSpeed(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireContactPoint(Car: wNode; tireIndex: Int32): wVector3f; cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireContactNormal(Car: wNode; tireIndex: Int32): wVector3f; cdecl; external WS3DCoreLib;

function wPhysVehicleIsTireBrake(Car: wNode; tireIndex: Int32): Boolean; cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireType(Car: wNode; tireIndex: Int32): wPhysVehicleTireType; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireType(Car: wNode; tireIndex: Int32; tireType: wPhysVehicleTireType); cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireBrakeForce(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireBrakeForce(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireBrakeLateralFriction(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireBrakeLateralFriction(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireBrakeLongitudinalFriction(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireBrakeLongitudinalFriction(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireLateralFriction(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireLateralFriction(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireLongitudinalFriction(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireLongitudinalFriction(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireMass(Car: wNode; tireIndex: Int32; mass: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireMass(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireRadius(Car: wNode; tireIndex: Int32; radius: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireRadius(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireWidth(Car: wNode; tireIndex: Int32; width: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireWidth(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireSpringConst(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireSpringConst(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireSpringDamper(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireSpringDamper(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireSuspensionLenght(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireSuspensionLenght(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireUserData(Car: wNode; tireIndex: Int32; userData: wNode); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireUserData(Car: wNode; tireIndex: Int32): wNode; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireMotorForce(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireMotorForce(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireTurnForceHelper(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireTurnForceHelper(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireSpinTorqueFactor(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireSpinTorqueFactor(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireTorquePosition(Car: wNode; tireIndex: Int32; position: wVector3f); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireTorquePosition(Car: wNode; tireIndex: Int32): wVector3f; cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireLoad(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

procedure wPhysVehicleSetTireSpinForce(Car: wNode; tireIndex: Int32; value: Float32); cdecl; external WS3DCoreLib;

function wPhysVehicleGetTireSpinForce(Car: wNode; tireIndex: Int32): Float32; cdecl; external WS3DCoreLib;

// wPhysMaterial
function wPhysMaterialCreate(): Int32; cdecl; external WS3DCoreLib;

procedure wPhysMaterialSetElasticity(matId1, matId2: Int32; Elasticity: Float32); cdecl; external WS3DCoreLib;

procedure wPhysMaterialSetFriction(matId1, matId2: Int32; StaticFriction, KineticFriction: Float32); cdecl; external WS3DCoreLib;

procedure wPhysMaterialSetContactSound(matId1, matId2: Int32; soundNode: wSound); cdecl; external WS3DCoreLib;

procedure wPhysMaterialSetSoftness(matId1, matId2: Int32; Softness: Float32); cdecl; external WS3DCoreLib;

procedure wPhysMaterialSetCollidable(matId1, matId2: Int32; isCollidable: Boolean); cdecl; external WS3DCoreLib;

// wGui
procedure wGuiDrawAll(); cdecl; external WS3DCoreLib;

procedure wGuiDestroyAll(); cdecl; external WS3DCoreLib;

function wGuiIsEventAvailable(): Boolean; cdecl; external WS3DCoreLib;

function wGuiReadEvent(): PwGuiEvent; cdecl; external WS3DCoreLib;

function wGuiLoad(const fileName: PChar; start: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiSave(const fileName: PChar; start: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiGetSkin(): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiSetSkin(skin: wGuiObject); cdecl; external WS3DCoreLib;

Function wGuiGetLastSelectedFile(): PWString; cdecl; external WS3DCoreLib;

function wGuiGetLastSelectedDirectory(): PChar; cdecl; external WS3DCoreLib;

function wGuiGetObjectFocused(): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiGetObjectHovered(): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiGetRootNode(): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiGetObjectById(id: Int32; searchchildren: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiGetObjectByName(const name: PChar; searchchildren: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

// wGuiObject
procedure wGuiObjectDestroy(element: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiObjectSetParent(element, parent: wGuiObject); cdecl; external WS3DCoreLib;

function wGuiObjectGetParent(element: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiObjectSetRelativePosition(element: wGuiObject; position: wVector2i); cdecl; external WS3DCoreLib;

procedure wGuiObjectSetRelativeSize(element: wGuiObject; size: wVector2i); cdecl; external WS3DCoreLib;

function wGuiObjectGetRelativePosition(element: wGuiObject): wVector2i; cdecl; external WS3DCoreLib;

function wGuiObjectGetRelativeSize(element: wGuiObject): wVector2i; cdecl; external WS3DCoreLib;

function wGuiObjectGetAbsolutePosition(element: wGuiObject): wVector2i; cdecl; external WS3DCoreLib;

function wGuiObjectGetAbsoluteClippedPosition(element: wGuiObject): wVector2i; cdecl; external WS3DCoreLib;

function wGuiObjectGetAbsoluteClippedSize(element: wGuiObject): wVector2i; cdecl; external WS3DCoreLib;

procedure wGuiObjectSetClippingMode(element: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiObjectIsClipped(element: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiObjectSetMaxSize(element: wGuiObject; size: wVector2i); cdecl; external WS3DCoreLib;

procedure wGuiObjectSetMinSize(element: wGuiObject; size: wVector2i); cdecl; external WS3DCoreLib;

procedure wGuiObjectSetAlignment(element: wGuiObject; left, right, top, bottom: wGuiAlignment); cdecl; external WS3DCoreLib;

procedure wGuiObjectUpdateAbsolutePosition(element: wGuiObject); cdecl; external WS3DCoreLib;

function wGuiObjectGetFromScreenPos(element: wGuiObject; position: wVector2i): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiObjectIsPointInside(element: wGuiObject; position: wVector2i): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiObjectDestroyChild(element: wGuiObject; child: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiObjectDraw(element: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiObjectMoveTo(element: wGuiObject; position: wVector2i); cdecl; external WS3DCoreLib;

procedure wGuiObjectSetVisible(element: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiObjectIsVisible(element: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiObjectSetSubObject(element: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiObjectIsSubObject(element: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiObjectSetTabStop(element: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiObjectIsTabStop(element: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiObjectSetTabOrder(element: wGuiObject; index: Int32); cdecl; external WS3DCoreLib;

function wGuiObjectGetTabOrder(element: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiObjectSetTabGroup(element: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiObjectIsTabGroup(element: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiObjectSetEnable(element: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiObjectIsEnabled(element: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiObjectSetText(element: wGuiObject; const text: Pwstring); cdecl; external WS3DCoreLib;

procedure wGuiObjectSetTextC(element: wGuiObject; const text: PChar); cdecl; external WS3DCoreLib;

function wGuiObjectGetText(element: wGuiObject): Pwstring; cdecl; external WS3DCoreLib;

function wGuiObjectGetTextC(element: wGuiObject): PChar;  cdecl; external WS3DCoreLib;

procedure wGuiObjectSetToolTipText(element: wGuiObject; const text: Pwstring); cdecl; external WS3DCoreLib;

function wGuiObjectGetToolTipText(element: wGuiObject): Pwstring; cdecl; external WS3DCoreLib;

procedure wGuiObjectSetId(element: wGuiObject; id: Int32); cdecl; external WS3DCoreLib;

function wGuiObjectGetId(element: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiObjectSetName(element: wGuiObject; const name: PChar); cdecl; external WS3DCoreLib;

function wGuiObjectIsHovered(element: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiObjectGetName(element: wGuiObject): PChar; cdecl; external WS3DCoreLib;

function wGuiObjectGetChildById(element: wGuiObject; id: Int32; searchchildren: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiObjectGetChildByName(element: wGuiObject; name: PChar; searchchildren: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiObjectIsChildOf(element: wGuiObject; child: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiObjectBringToFront(element: wGuiObject; subElement: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiObjectGetType(element: wGuiObject): wGuiElementType; cdecl; external WS3DCoreLib;

function wGuiObjectGetTypeName(element: wGuiObject): PChar; cdecl; external WS3DCoreLib;

function wGuiObjectHasType(element: wGuiObject; type_: wGuiElementType): Boolean; cdecl; external WS3DCoreLib;

function wGuiObjectSetFocus(element: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiObjectRemoveFocus(element: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiObjectIsFocused(element: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiObjectReadFromXml(node: wGuiObject; reader: wXmlReader); cdecl; external WS3DCoreLib;

procedure wGuiObjectWriteToXml(node: wGuiObject; writer: wXmlWriter); cdecl; external WS3DCoreLib;

// wGuiSkin
function wGuiSkinCreate(type_: wGuiSkinSpace): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiSkinGetColor(skin: wGuiObject; elementType: wGuiDefaultColor): wColor4s; cdecl; external WS3DCoreLib;

procedure wGuiSkinSetColor(skin: wGuiObject; elementType: wGuiDefaultColor; color: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiSkinSetSize(skin: wGuiObject; sizeType: wGuiDefaultSize; newSize: Int32); cdecl; external WS3DCoreLib;

function wGuiSkinGetSize(skin: wGuiObject; sizeType: wGuiDefaultSize): Int32; cdecl; external WS3DCoreLib;

function wGuiSkinGetDefaultText(skin: wGuiObject; txt: wGuiDefaultText): Pwstring; cdecl; external WS3DCoreLib;

procedure wGuiSkinSetDefaultText(skin: wGuiObject; txt: wGuiDefaultText; const newText: Pwstring); cdecl; external WS3DCoreLib;

procedure wGuiSkinSetFont(skin: wGuiObject; font: wFont; fntType: wGuiDefaultFont = wGDF_DEFAULT); cdecl; external WS3DCoreLib;

function wGuiSkinGetFont(skin: wGuiObject; fntType: wGuiDefaultFont = wGDF_DEFAULT): wFont; cdecl; external WS3DCoreLib;

procedure wGuiSkinSetSpriteBank(skin: wGuiObject; bank: wGuiObject); cdecl; external WS3DCoreLib;

function wGuiSkinGetSpriteBank(skin: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiSkinSetIcon(skin: wGuiObject; icn: wGuiDefaultIcon; index: UInt32); cdecl; external WS3DCoreLib;

function wGuiSkinGetIcon(skin: wGuiObject; icn: wGuiDefaultIcon): UInt32; cdecl; external WS3DCoreLib;

function wGuiSkinGetType(skin: wGuiObject): wGuiSkinSpace; cdecl; external WS3DCoreLib;

// wGuiWindow
function wGuiWindowCreate(const wcptrTitle: Pwstring; minPos, maxPos: wVector2i;
          modal: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiWindowGetButtonClose(win: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiWindowGetButtonMinimize(win: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiWindowGetButtonMaximize(win: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiWindowSetDraggable(win: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiWindowIsDraggable(win: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiWindowIsDrawBackground(win: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiWindowSetDrawTitleBar(win: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiWindowIsDrawTitleBar(win: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiWindowSetDrawBackground(win: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

// wGuiLabel
function wGuiLabelCreate(const wcptrText: Pwstring; minPos, maxPos: wVector2i;
          boBorder: Boolean = false; boWordWrap: Boolean = true): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiLabelGetTextSize(txt: wGuiObject): wVector2i; cdecl; external WS3DCoreLib;

procedure wGuiLabelSetOverrideFont(txt: wGuiObject; font: wFont); cdecl; external WS3DCoreLib;

function wGuiLabelGetOverrideFont(txt: wGuiObject): wFont; cdecl; external WS3DCoreLib;

function wGuiLabelGetActiveFont(txt: wGuiObject): wFont; cdecl; external WS3DCoreLib;

procedure wGuiLabelEnableOverrideColor(txt: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiLabelIsOverrideColor(txt: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiLabelSetOverrideColor(txt: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

function wGuiLabelGetOverrideColor(txt: wGuiObject): wColor4s; cdecl; external WS3DCoreLib;

procedure wGuiLabelSetDrawBackground(txt: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiLabelIsDrawBackGround(txt: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiLabelSetDrawBorder(txt: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiLabelIsDrawBorder(txt: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiLabelSetTextAlignment(txt: wGuiObject; Horizontalvalue, Verticalvalue: wGuiAlignment); cdecl; external WS3DCoreLib;

procedure wGuiLabelSetWordWrap(txt: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiLabelIsWordWrap(txt: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiLabelSetBackgroundColor(txt: wGuiObject; color1: wColor4s); cdecl; external WS3DCoreLib;

function wGuiLabelGetBackgroundColor(txt: wGuiObject): wColor4s; cdecl; external WS3DCoreLib;

// wGuiButton
function wGuiButtonCreate(minPos, maxPos: wVector2i; const wcptrLabel, wcptrTip: Pwstring): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiButtonSetImage(btn: wGuiObject; img: wTexture); cdecl; external WS3DCoreLib;

procedure wGuiButtonSetImageFromRect(btn: wGuiObject; img: wTexture; minRect, maxRect: PwVector2i); cdecl; external WS3DCoreLib;

procedure wGuiButtonSetPressedImage(btn: wGuiObject; img: wTexture); cdecl; external WS3DCoreLib;

procedure wGuiButtonSetPressedImageFromRect(btn: wGuiObject; img: wTexture;
          minRect, maxRect: PwVector2i); cdecl; external WS3DCoreLib;

procedure wGuiButtonSetSpriteBank(btn: wGuiObject; bank: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiButtonSetSprite(btn: wGuiObject; state: wGuiButtonState; index: Int32;
           color: wColor4s; loop: Boolean); cdecl; external WS3DCoreLib;

procedure wGuiButtonSetPush(btn: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiButtonIsPushed(btn: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiButtonSetPressed(btn: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiButtonIsPressed(btn: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiButtonUseAlphaChannel(btn: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiButtonIsUsedAlphaChannel(btn: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiButtonEnableScaleImage(btn: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiButtonIsScaledImage(btn: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiButtonSetOverrideFont(btn: wGuiObject; font: wFont); cdecl; external WS3DCoreLib;

function wGuiButtonGetOverrideFont(btn: wGuiObject): wFont; cdecl; external WS3DCoreLib;

function wGuiButtonGetActiveFont(btn: wGuiObject): wFont; cdecl; external WS3DCoreLib;

procedure wGuiButtonSetDrawBorder(btn: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiButtonIsDrawBorder(btn: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

// wGuiButtonGroup
function wGuiButtonGroupCreate(minPos, maxPos: wVector2i): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiButtonGroupAddButton(group, button: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiButtonGroupInsertButton(group, button: wGuiObject; index: UInt32): Int32; cdecl; external WS3DCoreLib;

function wGuiButtonGroupGetButton(group: wGuiObject; index: UInt32): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiButtonGroupRemoveButton(group: wGuiObject; index: UInt32): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiButtonGroupRemoveAll(group: wGuiObject); cdecl; external WS3DCoreLib;

function wGuiButtonGroupGetSize(group: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

function wGuiButtonGroupGetSelectedIndex(group: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiButtonGroupSetSelectedIndex(group: wGuiObject; index: Int32); cdecl; external WS3DCoreLib;

procedure wGuiButtonGroupClearSelection(group: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiButtonGroupSetBackgroundColor(group: wGuiObject; color1: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiButtonGroupDrawBackground(group: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

// wGuiListBox
function wGuiListBoxCreate(minPos, maxPos: wVector2i; background: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiListBoxGetItemsCount(lbox: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

function wGuiListBoxGetItemByIndex(lbox: wGuiObject; id: UInt32): Pwstring; cdecl; external WS3DCoreLib;

function wGuiListBoxAddItem(lbox: wGuiObject; const text: Pwstring): UInt32; cdecl; external WS3DCoreLib;

function wGuiListBoxAddItemWithIcon(lbox: wGuiObject; const text: Pwstring; icon: Int32): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiListBoxRemoveItem(lbox: wGuiObject; index: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiListBoxRemoveAll(lbox: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiListBoxSetItem(lbox: wGuiObject; index: UInt32; const text: Pwstring; icon: Int32); cdecl; external WS3DCoreLib;

procedure wGuiListBoxInsertItem(lbox: wGuiObject; index: UInt32; text: Pwstring; icon: Int32); cdecl; external WS3DCoreLib;

function wGuiListBoxGetItemIcon(lbox: wGuiObject; index: UInt32): Int32; cdecl; external WS3DCoreLib;

function wGuiListBoxGetSelectedIndex(lbox: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiListBoxSelectItemByIndex(lbox: wGuiObject; index: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiListBoxSelectItemByText(lbox: wGuiObject; const item: Pwstring); cdecl; external WS3DCoreLib;

procedure wGuiListBoxSwapItems(lbox: wGuiObject; index1, index2: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiListBoxSetItemsHeight(lbox: wGuiObject; height: Int32); cdecl; external WS3DCoreLib;

procedure wGuiListBoxSetAutoScrolling(lbox: wGuiObject; scroll: Boolean); cdecl; external WS3DCoreLib;

function wGuiListBoxIsAutoScrolling(lbox: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiListBoxSetItemColor(lbox: wGuiObject; index: UInt32; color: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiListBoxSetElementColor(lbox: wGuiObject; index: UInt32;
           colorType: wGuiListboxColor; color: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiListBoxClearItemColor(lbox: wGuiObject; index: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiListBoxClearElementColor(lbox: wGuiObject; index: UInt32;
           colorType: wGuiListboxColor); cdecl; external WS3DCoreLib;

function wGuiListBoxGetElementColor(lbox: wGuiObject; index: UInt32;
           colorType: wGuiListboxColor): wColor4s; cdecl; external WS3DCoreLib;

function wGuiListBoxHasElementColor(lbox: wGuiObject; index: UInt32;
           colorType: wGuiListboxColor): Boolean; cdecl; external WS3DCoreLib;

function wGuiListBoxGetDefaultColor(lbox: wGuiObject; colorType: wGuiListboxColor): wColor4s; cdecl; external WS3DCoreLib;

procedure wGuiListBoxSetDrawBackground(lbox: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

// wGuiScrollBar
function wGuiScrollBarCreate(Horizontal: Boolean; minPos, maxPos: wVector2i): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiScrollBarSetMaxValue(scroll: wGuiObject; max: Int32); cdecl; external WS3DCoreLib;

function wGuiScrollBarGetMaxValue(scroll: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiScrollBarSetMinValue(scroll: wGuiObject; min: Int32); cdecl; external WS3DCoreLib;

function wGuiScrollBarGetMinValue(scroll: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiScrollBarSetValue(scroll: wGuiObject; value: Int32); cdecl; external WS3DCoreLib;

function wGuiScrollBarGetValue(scroll: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiScrollBarSetSmallStep(scroll: wGuiObject; step: Int32); cdecl; external WS3DCoreLib;

function wGuiScrollBarGetSmallStep(scroll: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiScrollBarSetLargeStep(scroll: wGuiObject; step: Int32); cdecl; external WS3DCoreLib;

function wGuiScrollBarGetLargeStep(scroll: wGuiObject): Int32; cdecl; external WS3DCoreLib;

// wGuiEditBox
function wGuiEditBoxCreate(const wcptrText: Pwstring; minPos, maxPos: wVector2i): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiEditBoxSetMultiLine(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiEditBoxIsMultiLine(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiEditBoxSetAutoScrolling(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiEditBoxIsAutoScrolling(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiEditBoxSetPasswordMode(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiEditBoxIsPasswordMode(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiEditBoxGetTextSize(box: wGuiObject): wVector2i; cdecl; external WS3DCoreLib;

procedure wGuiEditBoxSetCharactersLimit(box: wGuiObject; max: UInt32); cdecl; external WS3DCoreLib;

function wGuiEditGetCharactersLimit(box: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiEditBoxSetOverrideFont(box: wGuiObject; font: wFont); cdecl; external WS3DCoreLib;

function wGuiEditBoxGetOverrideFont(box: wGuiObject): wFont; cdecl; external WS3DCoreLib;

function wGuiEditBoxGetActiveFont(box: wGuiObject): wFont; cdecl; external WS3DCoreLib;

procedure wGuiEditBoxEnableOverrideColor(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiEditBoxIsOverrideColor(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiEditBoxSetOverrideColor(box: wGuiObject; color1: wColor4s); cdecl; external WS3DCoreLib;

function wGuiEditBoxGetOverrideColor(box: wGuiObject): wColor4s; cdecl; external WS3DCoreLib;

procedure wGuiEditBoxSetDrawBackground(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

procedure wGuiEditBoxSetDrawBorder(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiEditBoxIsDrawBorder(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiEditBoxSetTextAlignment(box: wGuiObject; Horizontalvalue, Verticalvalue: wGuiAlignment); cdecl; external WS3DCoreLib;

procedure wGuiEditBoxSetWordWrap(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiEditBoxIsWordWrap(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

// wGuiTextArea
function wGuiTextAreaCreate(minPos, maxPos: wVector2i; maxLines: Int32 = 1024): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiTextAreaSetBorderSize(tarea: wGuiObject; size: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiTextAreaSetAutoScroll(tarea: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

procedure wGuiTextAreaSetPadding(tarea: wGuiObject; padding: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiTextAreaSetBackTexture(tarea: wGuiObject; tex: wTexture); cdecl; external WS3DCoreLib;

procedure wGuiTextAreaSetWrapping(tarea: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

procedure wGuiTextAreaSetFont(tarea: wGuiObject; font: wFont); cdecl; external WS3DCoreLib;

procedure wGuiTextAreaAddLine(tarea: wGuiObject; const text: Pwstring; lifeTime: UInt32;
           color: wColor4s; icon: wTexture; iconMode: Int32); cdecl; external WS3DCoreLib;

procedure wGuiTextAreaRemoveAll(tarea: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiTextAreaSetBackgroundColor(tarea: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiTextAreaSetBorderColor(tarea: wGuiObject; color1: wColor4s); cdecl; external WS3DCoreLib;

// wGuiImage
function wGuiImageCreate(texture: wTexture; size: wVector2i; useAlpha: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiImageSet(img: wGuiObject; tex: wTexture); cdecl; external WS3DCoreLib;

function wGuiImageGet(img: wGuiObject): wTexture; cdecl; external WS3DCoreLib;

procedure wGuiImageSetColor(img: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

function wGuiImageGetColor(img: wGuiObject): wColor4s; cdecl; external WS3DCoreLib;

procedure wGuiImageSetScaling(img: wGuiObject; scale: Boolean); cdecl; external WS3DCoreLib;

function wGuiImageIsScaled(img: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiImageUseAlphaChannel(img: wGuiObject; use: Boolean); cdecl; external WS3DCoreLib;

function wGuiImageIsUsedAlphaChannel(img: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

// wGuiFader
function wGuiFaderCreate(minPos, maxPos: wVector2i): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiFaderSetColor(fader: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

function wGuiFaderGetColor(fader: wGuiObject): wColor4s; cdecl; external WS3DCoreLib;

procedure wGuiFaderSetColorExt(fader: wGuiObject;colorSrc, colorDest: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiFaderFadeIn(fader: wGuiObject; timeMs: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiFaderFadeOut(fader: wGuiObject; timeMs: UInt32); cdecl; external WS3DCoreLib;

function wGuiFaderIsReady(fader: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

// wGuiFileOpenDialog
function wGuiFileOpenDialogCreate(const wcptrLabel: Pwstring; modal: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiFileOpenDialogGetFile(dialog: wGuiObject): Pwstring; cdecl; external WS3DCoreLib;

function wGuiFileOpenDialogGetDirectory(dialog: wGuiObject): PChar; cdecl; external WS3DCoreLib;

function wGuiFileOpenDialogGetDirectoryW(dialog: wGuiObject): Pwstring; cdecl; external WS3DCoreLib;

// wGuiComboBox
function wGuiComboBoxCreate(minPos, maxPos: wVector2i): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiComboBoxGetItemsCount(combo: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

function wGuiComboBoxGetItemByIndex(combo: wGuiObject; idx: UInt32): Pwstring; cdecl; external WS3DCoreLib;

function wGuiComboBoxGetItemDataByIndex(combo: wGuiObject; idx: UInt32): UInt32; cdecl; external WS3DCoreLib;

function wGuiComboBoxGetIndexByItemData(combo: wGuiObject; data: UInt32): Int32; cdecl; external WS3DCoreLib;

function wGuiComboBoxAddItem(combo: wGuiObject; const text: Wstring; data: UInt32): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiComboBoxRemoveItem(combo: wGuiObject; idx: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiComboBoxRemoveAll(combo: wGuiObject); cdecl; external WS3DCoreLib;

function wGuiComboBoxGetSelected(combo: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiComboBoxSetSelected(combo: wGuiObject; idx: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiComboBoxSetMaxSelectionRows(combo: wGuiObject; max: UInt32); cdecl; external WS3DCoreLib;

function wGuiComboBoxGetMaxSelectionRows(combo: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiComboBoxSetTextAlignment(combo: wGuiObject; Horizontalvalue, Verticalvalue: wGuiAlignment); cdecl; external WS3DCoreLib;

// wGuiContextMenu
function wGuiContextMenuCreate(minPos, maxPos: wVector2i): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiContextMenuSetCloseHandling(cmenu: wGuiObject; onClose: wContextMenuClose); cdecl; external WS3DCoreLib;

function wGuiContextMenuGetCloseHandling(cmenu: wGuiObject): wContextMenuClose; cdecl; external WS3DCoreLib;

function wGuiContextMenuGetItemsCount(cmenu: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

function wGuiContextMenuAddItem(cmenu: wGuiObject; const text: Pwstring;
           commandId: Int32 = -1; enabled: Boolean = true; hasSubMenu: Boolean = false;
           checked: Boolean = false; autoChecking: Boolean = false): UInt32; cdecl; external WS3DCoreLib;

function wGuiContextMenuInsertItem(cmenu: wGuiObject; idx: UInt32; const text: Pwstring;
           commandId: Int32 = -1; enabled: Boolean = true; hasSubMenu: Boolean = false;
           checked: Boolean = false; autoChecking: Boolean = false): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiContextMenuAddSeparator(cmenu: wGuiObject); cdecl; external WS3DCoreLib;

function wGuiContextMenuGetItemText(cmenu: wGuiObject; idx: UInt32): Pwstring; cdecl; external WS3DCoreLib;

procedure wGuiContextMenuSetItemText(cmenu: wGuiObject; idx: UInt32;
           const text: Pwstring); cdecl; external WS3DCoreLib;

procedure wGuiContextMenuSetItemEnabled(cmenu: wGuiObject; idx: UInt32; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiContextMenuIsItemEnabled(cmenu: wGuiObject; idx: UInt32): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiContextMenuSetItemChecked(cmenu: wGuiObject; idx: UInt32; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiContextMenuIsItemChecked(cmenu: wGuiObject; idx: UInt32): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiContextMenuRemoveItem(cmenu: wGuiObject; idx: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiContextMenuRemoveAll(cmenu: wGuiObject); cdecl; external WS3DCoreLib;

function wGuiContextMenuGetSelectedItem(cmenu: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiContextMenuGetItemCommandId(cmenu: wGuiObject; idx: UInt32): Int32; cdecl; external WS3DCoreLib;

function wGuiContextMenuFindItem(cmenu: wGuiObject; id: Int32; idx: UInt32): Int32; cdecl; external WS3DCoreLib;

procedure wGuiContextMenuSetItemCommandId(cmenu: wGuiObject; idx: UInt32; id: Int32); cdecl; external WS3DCoreLib;

function wGuiContextMenuGetSubMenu(cmenu: wGuiObject; idx: UInt32): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiContextMenuSetAutoChecking(cmenu: wGuiObject; idx: UInt32; autoChecking: Boolean); cdecl; external WS3DCoreLib;

function wGuiContextMenuIsAutoChecked(cmenu: wGuiObject; idx: UInt32): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiContextMenuSetEventParent(cmenu: wGuiObject; parent: wGuiObject); cdecl; external WS3DCoreLib;

// wGuiMenu
function wGuiMenuCreate(): wGuiObject; cdecl; external WS3DCoreLib;

// wGuiModalScreen
function wGuiModalScreenCreate(): wGuiObject; cdecl; external WS3DCoreLib;

// wGuiSpinBox
function wGuiSpinBoxCreate(const wcptrText: Pwstring; minPos, maxPos: wVector2i;
          border: Boolean = true): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiSpinBoxGetEditBox(box: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiSpinBoxSetValue(spin: wGuiObject; value: Float32); cdecl; external WS3DCoreLib;

function wGuiSpinBoxGetValue(spin: wGuiObject): Float32; cdecl; external WS3DCoreLib;

procedure wGuiSpinBoxSetRange(spin: wGuiObject; range: wVector2f); cdecl; external WS3DCoreLib;

function wGuiSpinBoxGetMin(spin: wGuiObject): Float32; cdecl; external WS3DCoreLib;

function wGuiSpinBoxGetMax(spin: wGuiObject): Float32; cdecl; external WS3DCoreLib;

procedure wGuiSpinBoxSetStepSize(spin: wGuiObject; step: Float32); cdecl; external WS3DCoreLib;

function wGuiSpinBoxGetStepSize(spin: wGuiObject): Float32; cdecl; external WS3DCoreLib;

procedure wGuiSpinBoxSetDecimalPlaces(spin: wGuiObject; places: Int32); cdecl; external WS3DCoreLib;

// wGuiTab
function wGuiTabCreate(minPos, maxPos: wVector2i): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTabGetNumber(tab: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiTabSetTextColor(tab: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

function wGuiTabGetTextColor(tab: wGuiObject): wColor4s; cdecl; external WS3DCoreLib;

procedure wGuiTabSetDrawBackground(tab: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiTabIsDrawBackground(tab: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiTabSetBackgroundColor(tab: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

function wGuiTabGetBackgroundColor(tab: wGuiObject): wColor4s; cdecl; external WS3DCoreLib;

// wGuiTabControl
function wGuiTabControlCreate(minPos, maxPos: wVector2i; background: Boolean = false;
          border: Boolean = true): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTabControlGetTabsCount(control: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiTabControlAddTab(control: wGuiObject; const caption: Pwstring;
          id: Int32 = -1): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTabControlInsertTab(control: wGuiObject; idx: UInt32;
          const caption: Pwstring; id: Int32 = -1): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTabControlGetTab(control: wGuiObject; idx: Int32): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTabControlSetActiveTabByIndex(control: wGuiObject; idx: Int32): Boolean; cdecl; external WS3DCoreLib;

function wGuiTabControlSetActiveTab(control: wGuiObject; tab: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiTabControlGetActiveTab(control: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiTabControlGetTabFromPos(control: wGuiObject; position: wVector2i): Int32; cdecl; external WS3DCoreLib;

procedure wGuiTabControlRemoveTab(control: wGuiObject; idx: Int32); cdecl; external WS3DCoreLib;

procedure wGuiTabControlRemoveAll(control: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiTabControlSetTabHeight(control: wGuiObject; height: Int32); cdecl; external WS3DCoreLib;

function wGuiTabControlGetTabHeight(control: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiTabControlSetTabMaxWidth(control: wGuiObject; width: Int32); cdecl; external WS3DCoreLib;

function wGuiTabControlGetTabMaxWidth(control: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiTabControlSetVerticalAlignment(control: wGuiObject; al: wGuiAlignment); cdecl; external WS3DCoreLib;

function wGuiTabControlGetVerticalAlignment(control: wGuiObject): wGuiAlignment; cdecl; external WS3DCoreLib;

procedure wGuiTabControlSetTabExtraWidth(control: wGuiObject; extraWidth: Int32); cdecl; external WS3DCoreLib;

function wGuiTabControlGetTabExtraWidth(control: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiTabControlAttachTab(control, tab: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiTabControlDetachTab(control, tab: wGuiObject); cdecl; external WS3DCoreLib;

// wGuiTable
function wGuiTableCreate(minPos, maxPos: wVector2i; background: Boolean = false): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiTableAddColumn(table: wGuiObject; const caption: Pwstring;
          columnIndex: Int32 = -1); cdecl; external WS3DCoreLib;

procedure wGuiTableRemoveColumn(table: wGuiObject; columnIndex: UInt32); cdecl; external WS3DCoreLib;

function wGuiTableGetColumnsCount(table: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiTableSetActiveColumn(table: wGuiObject; idx: Int32;
          doOrder: Boolean = false): Boolean; cdecl; external WS3DCoreLib;

function wGuiTableGetActiveColumn(table: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiTableGetActiveColumnOrdering(table: wGuiObject): wGuiOrderingMode; cdecl; external WS3DCoreLib;

procedure wGuiTableSetColumnWidth(table: wGuiObject; columnIndex, width: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiTableSetColumnsResizable(table: wGuiObject; resizible: Boolean); cdecl; external WS3DCoreLib;

function wGuiTableIsColumnsResizable(table: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiTableGetSelected(table: wGuiObject): Int32; cdecl; external WS3DCoreLib;

procedure wGuiTableSetSelectedByIndex(table: wGuiObject; index: Int32); cdecl; external WS3DCoreLib;

function wGuiTableGetRowsCount(table: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiTableAddRow(table: wGuiObject; rowIndex: UInt32): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiTableRemoveRow(table: wGuiObject; rowIndex: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiTableClearRows(table: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiTableSwapRows(table: wGuiObject; rowIndexA, rowIndexB: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiTableSetOrderRows(table: wGuiObject; columnIndex: Int32;
           mode: wGuiOrderingMode); cdecl; external WS3DCoreLib;

procedure wGuiTableSetCellText(table: wGuiObject; rowIndex, columnIndex: UInt32;
           const text: Pwstring; color: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiTableSetCellData(table: wGuiObject; rowIndex, columnIndex: UInt32;
           data: PUInt32); cdecl; external WS3DCoreLib;

procedure wGuiTableSetCellColor(table: wGuiObject; rowIndex, columnIndex: UInt32;
           color: wColor4s); cdecl; external WS3DCoreLib;

function wGuiTableGetCellText(table: wGuiObject; rowIndex, columnIndex: UInt32): Pwstring; cdecl; external WS3DCoreLib;

function wGuiTableGetCellData(table: wGuiObject; rowIndex, columnIndex: UInt32): PUInt32; cdecl; external WS3DCoreLib;

procedure wGuiTableSetDrawFlags(table: wGuiObject; flags: wGuiTableDrawFlags); cdecl; external WS3DCoreLib;

function wGuiTableGetDrawFlags(table: wGuiObject): wGuiTableDrawFlags; cdecl; external WS3DCoreLib;

procedure wGuiTableSetOverrideFont(table: wGuiObject; font: wFont); cdecl; external WS3DCoreLib;

function wGuiTableGetOverrideFont(table: wGuiObject): wFont; cdecl; external WS3DCoreLib;

function wGuiTableGetActiveFont(table: wGuiObject): wFont; cdecl; external WS3DCoreLib;

function wGuiTableGetItemHeight(table: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiTableGetVerticalScrollBar(table: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTableGetHorizontalScrollBar(table: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiTableSetDrawBackground(table: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiTableIsDrawBackground(table: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

// wGuiToolBar
function wGuiToolBarCreate(): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiToolBarAddButton(bar: wGuiObject; const text: Pwstring;
           const tooltiptext: Pwstring; img, pressedImg: wTexture;
           isPushButton: Boolean = false; useAlphaChannel: Boolean = true): wGuiObject;  cdecl; external WS3DCoreLib;

//wGuiMessageBox
function wGuiMessageBoxCreate(const wcptrTitle, wcptrTCaption: Pwstring; modal: Boolean;
           flags: wGuiMessageBoxFlags; image: wTexture): wGuiObject; cdecl; external WS3DCoreLib;

// wGuiTree
function wGuiTreeCreate(minPos, maxPos: wVector2i; background: Boolean;
           barvertical: Boolean; barhorizontal: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeGetRoot(tree: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeGetSelected(tree: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiTreeSetLinesVisible(tree: wGuiObject; visible: Boolean); cdecl; external WS3DCoreLib;

function wGuiTreeIsLinesVisible(tree: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiTreeSetIconFont(tree: wGuiObject; font: wFont); cdecl; external WS3DCoreLib;

procedure wGuiTreeSetImageList(tree: wGuiObject; list: wGuiObject); cdecl; external WS3DCoreLib;

function wGuiTreeGetImageList(tree: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiTreeSetImageLeftOfIcon(tree: wGuiObject; bLeftOf: Boolean); cdecl; external WS3DCoreLib;

function wGuiTreeIsImageLeftOfIcon(tree: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiTreeGetLastEventNode(tree: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

// wGuiTreeNode
function wGuiTreeNodeGetOwner(node: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetParent(node: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetText(node: wGuiObject): Pwstring; cdecl; external WS3DCoreLib;

procedure wGuiTreeNodeSetText(node: wGuiObject; const text: Pwstring); cdecl; external WS3DCoreLib;

procedure wGuiTreeNodeSetIcon(node: wGuiObject; const icon: Pwstring); cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetIcon(node: wGuiObject): Pwstring; cdecl; external WS3DCoreLib;

procedure wGuiTreeNodeSetImageIndex(node: wGuiObject; imageIndex: UInt32); cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetImageIndex(node: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiTreeNodeSetSelectedImageIndex(node: wGuiObject; imageIndex: UInt32); cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetSelectedImageIndex(node: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiTreeNodeSetData(node: wGuiObject; data: PUInt32); cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetData(node: wGuiObject): PUInt32; cdecl; external WS3DCoreLib;

procedure wGuiTreeNodeSetData2(node: wGuiObject; data2: PUInt32); cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetData2(node: wGuiObject): PUInt32; cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetChildsCount(node: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiTreeNodeRemoveChild(node: wGuiObject; child: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiTreeNodeRemoveChildren(node: wGuiObject); cdecl; external WS3DCoreLib;

function wGuiTreeNodeHasChildren(node: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiTreeNodeAddChildBack(node: wGuiObject; const text: Pwstring;
          const icon: Pwstring; imageIndex, selectedImageIndex: Int32;
          data: Pointer; data2: UInt32): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeNodeAddChildFront(node: wGuiObject; const text: Pwstring;
          const icon: Pwstring; imageIndex, selectedImageIndex: Int32;
          data: Pointer; data2: PUInt32): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeNodeInsertChildAfter(node, other: wGuiObject; const text: Pwstring;
          const icon: Pwstring; imageIndex, selectedImageIndex: Int32;
          data: Pointer; data2: PUInt32): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeNodeInsertChildBefore(node, other: wGuiObject; const text: Pwstring;
          const icon: Pwstring; imageIndex, selectedImageIndex: Int32;
          data: Pointer; data2: PUInt32): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetFirstChild(node: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetLastChild(node: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetPrevSibling(node: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetNextSibling(node: wGuiObject):wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetNextVisible(node: wGuiObject): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiTreeNodeMoveChildUp(node: wGuiObject; child: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiTreeNodeMoveChildDown(node: wGuiObject; child: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiTreeNodeSetExpanded(node: wGuiObject; expanded: Boolean); cdecl; external WS3DCoreLib;

function wGuiTreeNodeIsExpanded(node: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiTreeNodeSetSelected(node: wGuiObject; selected: Boolean); cdecl; external WS3DCoreLib;

function wGuiTreeNodeIsSelected(node: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiTreeNodeIsRoot(node: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

function wGuiTreeNodeGetLevel(node: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiTreeNodeIsVisible(node: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

// wGuiImageList
function wGuiImageListCreate(texture: wTexture; size: wVector2i; useAlphaChannel: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiImageListDraw(list: wGuiObject; index: Int32; pos, clipPos, clipSize: wVector2i); cdecl; external WS3DCoreLib;

function wGuiImageListGetCount(list: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiImageListGetSize(list: wGuiObject): wVector2i; cdecl; external WS3DCoreLib;

// wGuiColorSelectDialog
function wGuiColorSelectDialogCreate(const title: Pwstring; modal: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

// wGuiMeshViewer
function wGuiMeshViewerCreate(minPos, maxPos: wVector2i; const text: Pwstring): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiMeshViewerSetMesh(viewer: wGuiObject; mesh: wMesh); cdecl; external WS3DCoreLib;

function wGuiMeshViewerGetMesh(viewer: wGuiObject): wMesh; cdecl; external WS3DCoreLib;

procedure wGuiMeshViewerSetMaterial(viewer: wGuiObject; material: wMaterial); cdecl; external WS3DCoreLib;

function wGuiMeshViewerGetMaterial(viewer: wGuiObject): wMaterial; cdecl; external WS3DCoreLib;

// wGuiSpriteBank
function wGuiSpriteBankLoad(const file_: Pchar): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiSpriteBankCreate(const name: PChar): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiSpriteBankAddTexture(bank: wGuiObject; texture: wTexture); cdecl; external WS3DCoreLib;

procedure wGuiSpriteBankSetTexture(bank: wGuiObject; index: UInt32; texture: wTexture); cdecl; external WS3DCoreLib;

function wGuiSpriteBankAddSprite(bank: wGuiObject; texture: wTexture): Int32; cdecl; external WS3DCoreLib;

function wGuiSpriteBankGetTexture(bank: wGuiObject; index: UInt32): wTexture; cdecl; external WS3DCoreLib;

function wGuiSpriteBankGetTexturesCount(bank: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiSpriteBankRemoveAll(bank: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiSpriteBankDrawSprite(bank: wGuiObject; index: UInt32; position: wVector2i;
           clipPosition: pwVector2i; clipSize: PwVector2i; color: wColor4s;
           starttime: UInt32; currenttime: UInt32; loop: Boolean = true; center: Boolean = false); cdecl; external WS3DCoreLib;

procedure wGuiSpriteBankDrawSpriteBatch(bank: wGuiObject; indexArray: PUInt32;
           idxArrayCount: UInt32; positionArray: PwVector2i; posArrayCount: UInt32;
           clipPosition: PwVector2i; clipSize: PwVector2i; color: wColor4s;
           starttime: UInt32; currenttime: UInt32; loop: Boolean = true;
           center: Boolean = false); cdecl; external WS3DCoreLib;


// wGuiCheckBox
function wGuiCheckBoxCreate(const wcptrText: Wstring; minPos, maxPos: wVector2i;// ??Pwstring
          checked: Boolean): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiCheckBoxCheck(box: wGuiObject; checked: Boolean); cdecl; external WS3DCoreLib;

function wGuiCheckBoxIsChecked(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

// Sets whether to draw the background
procedure wGuiCheckBoxSetDrawBackground(checkbox: wGUIObject; value: Boolean); cdecl; external WS3DCoreLib;

// Checks if background drawing is enabled
//return true if background drawing is enabled, false otherwise
function wGuiCheckBoxIsDrawBackground(checkbox: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

// Sets whether to draw the border
procedure wGuiCheckBoxSetDrawBorder(checkbox: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

// Checks if border drawing is enabled
//return true if border drawing is enabled, false otherwise
function wGuiCheckBoxIsDrawBorder(checkbox: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiCheckBoxSetFilled(checkbox: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiCheckBoxIsFilled(checkbox: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

// wGuiCheckBoxGroup
function wGuiCheckBoxGroupCreate(minPos, maxPos: wVector2i): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiCheckBoxGroupAddCheckBox(group: wGuiObject; check: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiCheckBoxGroupInsertCheckBox(group: wGuiObject; check: wGuiObject;
          index: UInt32): Int32; cdecl; external WS3DCoreLib;

function wGuiCheckBoxGroupGetCheckBox(group: wGuiObject; index: UInt32): wGuiObject; cdecl; external WS3DCoreLib;

function wGuiCheckBoxGroupGetIndex(group: wGuiObject; check: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiCheckBoxGroupGetSelectedIndex(group: wGuiObject): Int32; cdecl; external WS3DCoreLib;

function wGuiCheckBoxGroupRemoveCheckBox(group: wGuiObject; index: UInt32): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiCheckBoxGroupRemoveAll(group: wGuiObject); cdecl; external WS3DCoreLib;

function wGuiCheckBoxGroupGetSize(group: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiCheckBoxGroupSelectCheckBox(group: wGuiObject; index: Int32); cdecl; external WS3DCoreLib;

procedure wGuiCheckBoxGroupClearSelection(group: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiCheckBoxGroupSetBackgroundColor(group: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiCheckBoxGroupDrawBackground(group: wGUIObject; isTrue: Int32); cdecl; external WS3DCoreLib;

// wGuiProgressBar
function wGuiProgressBarCreate(minPos, maxPos: wVector2i; isHorizontal: Boolean = true): wGuiObject; cdecl; external WS3DCoreLib;

procedure wGuiProgressBarSetPercentage(bar: wGuiObject; percent: UInt32); cdecl; external WS3DCoreLib;

function wGuiProgressBarGetPercentage(bar: wGuiObject): UInt32; cdecl; external WS3DCoreLib;

procedure wGuiProgressBarSetDirection(bar: wGuiObject; isHorizontal: Boolean); cdecl; external WS3DCoreLib;

function wGuiProgressBarIsHorizontal(bar: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiProgressBarSetBorderSize(bar: wGuiObject; size: UInt32); cdecl; external WS3DCoreLib;

procedure wGuiProgressBarSetSize(bar: wGuiObject; size: wVector2u); cdecl; external WS3DCoreLib;

procedure wGuiProgressBarSetFillColor(bar: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

function wGuiProgressBarGetFillColor(bar: wGuiObject): wColor4s; cdecl; external WS3DCoreLib;

procedure wGuiProgressBarSetTextColor(bar: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiProgressBarShowText(bar: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiProgressBarIsShowText(bar: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiProgressBarSetFillTexture(bar: wGuiObject; tex: wTexture); cdecl; external WS3DCoreLib;

procedure wGuiProgressBarSetBackTexture(bar: wGuiObject; tex: wTexture); cdecl; external WS3DCoreLib;

procedure wGuiProgressBarSetFont(bar: wGuiObject; font: wFont); cdecl; external WS3DCoreLib;

procedure wGuiProgressBarSetBackgroundColor(bar: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiProgressBarSetBorderColor(bar: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

// wGuiCEditor
function wGuiCEditorCreate(const wcptrText: Pwstring; minPos, maxPos: wVector2i;
          border: Boolean): Pointer; cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetHScrollVisible(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetText(box: wGuiObject; const text: Pwstring); cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetColors(box: wGuiObject; backColor, lineColor, textColor: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetLinesCountVisible(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiCEditorIsLinesCountVisible(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetElementText(box: wGuiObject; index: UInt32; const text: Pwstring); cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetSelectionColors(box: wGuiObject; backColor, textColor, back2Color: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiCEditorRemoveText(box: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiCEditorAddKeyword(box: wGuiObject; const word: PChar; color: wColor4s; matchCase: Boolean); cdecl; external WS3DCoreLib;

procedure wGuiCEditorAddLineKeyword(box: wGuiObject; const word: PChar;
          color: wColor4s; matchCase: Boolean); cdecl; external WS3DCoreLib;

procedure wGuiCEditorAddGroupKeyword(box: wGuiObject; word: PChar;
          const endKeyword: PChar; color: wColor4s; matchCase: Boolean); cdecl; external WS3DCoreLib;

procedure wGuiCEditorBoxAddKeywordInfo(box: wGuiObject; size, type_ : Int32); cdecl; external WS3DCoreLib;

procedure wGuiCEditorBoxRemoveAllKeywords(box: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiCEditorBoxAddCppKeywords(box: wGuiObject; key: wColor4s;
           string_: wColor4s; comment: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiCEditorAddLuaKeywords(box: wGuiObject; key, string_, comment: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiCEditorAddFbKeywords(box: wGuiObject; key, string_, comment: wColor4s); cdecl; external WS3DCoreLib;

procedure wGuiCEditorReplaceText(box: wGuiObject; start, end_: Int32; const text: Pwstring); cdecl; external WS3DCoreLib;

procedure wGuiCEditorPressReturn(box: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiCEditorAddText(box: wGuiObject; const addText: Pwstring); cdecl; external WS3DCoreLib;

function wGuiCEditorGetText(box: wGuiObject): Pwstring; cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetLineToggleVisible(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetContextMenuText(box: wGuiObject; const cut_text: Pwstring;
           const copy_text: Pwstring; const paste_text: Pwstring;
           const del_text: Pwstring; const redo_text: Pwstring; const undo_text: Pwstring;
           const btn_text: Pwstring); cdecl; external WS3DCoreLib;

procedure wGuiCEditorBoxCopy(box: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiCEditorCut(box: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiCEditorPaste(box: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiCEditorUndo(box: wGuiObject); cdecl; external WS3DCoreLib;

procedure wGuiCEditorRedo(box: wGuiObject); cdecl; external WS3DCoreLib;

function wGuiCEditorGetOverrideFont(box: wGuiObject): wFont; cdecl; external WS3DCoreLib;

function wGuiCEditorGetActiveFont(box: wGuiObject): wFont; cdecl; external WS3DCoreLib;

procedure wGuiCEditorEnableOverrideColor(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiCEditorIsOverrideColor(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetOverrideColor(box: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

function wGuiCEditorGetOverrideColor(box: wGuiObject): wColor4s; cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetDrawBackground(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiCEditorIsDrawBackGround(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetDrawBorder(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiCEditorIsDrawBorder(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetTextAlignment(box: wGuiObject; Horizontalvalue, Verticalvalue: wGuiAlignment); cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetWordWrap(box: wGuiObject; value: Boolean); cdecl; external WS3DCoreLib;

function wGuiCEditorIsWordWrap(box: wGuiObject): Boolean; cdecl; external WS3DCoreLib;

procedure wGuiCEditorSetBackgroundColor(box: wGuiObject; color: wColor4s); cdecl; external WS3DCoreLib;

function wMirrorCreate(camera: wNode; reflectSize: wVector2i; mirrorOverlay: wTexture): wNode; cdecl; external WS3DCoreLib;

// wMirror
procedure wMirrorReflect(mirrorNode: wNode; color: wColor4s); cdecl; external WS3DCoreLib;

procedure wMirrorSetScaleFactor(mirrorNode: wNode; factor: wVector2f); cdecl; external WS3DCoreLib;

// ???????????????????????????? ?????????? ?? WString
function WStr (text : PChar) : WString; overload;
function WStr (text : String) : WString; overload;
function WstrRu(txt: String): WString; overload;
function PWstrRu(txt: String): PWString; overload;
function PWStr (text : PChar) : PWString; overload;
function PWStr (text : AnsiString) : PWString; overload;
function WStrPas (text : PWChar) : UnicodeString;

// ???????????????????????????? ??????????????
function wVector3Zero(): wVector3f;

function wVector3fCreate(x,y,z: Float32): wVector3f;
procedure wVector3fSet(vec: PwVector3f; x,y,z: Float32);

function wColor4sCreate(a,r,g,b: UInt8): wColor4s;
procedure wColor4sSet(color: PwColor4s; a,r,g,b: UInt8);

function wColor4fCreate(a,r,g,b: Float32): wColor4f;
procedure wColor4fSet(color: PwColor4f; a,r,g,b: Float32);

function wVector2iCreate(x,y: Int32):wVector2i;
procedure wVector2iSet(vec: PwVector2i; x,y: Int32);

function wVector2fCreate(x,y: Float32):wVector2f;
procedure wVector2fSet(vec: PwVector2f; x,y: Float32);

{$ENDIF} //??????????????

implementation


{$IFDEF WINDOWS}
function WStr (text: PChar) : WString;
begin
  Result := WString(text);
end;
{$ELSE}
function WStr (text: PChar) : WString;
var
  i : Int32;
  Chars : array of WChar;
begin
  SetLength (Chars, Length (text) + 1);
  for i := 0 to Length (text) - 1 do
    Chars [i] := WChar (text [i]);
  Chars [Length (text)] := WChar(#0);
  Result := Chars;
  //Result := UCS4String (text);
end;
{$ENDIF}

function WStr(text: String) : WString;
begin
  Result := WStr(PChar(text));
end;

function WstrRu(txt: String): WString;
begin
  Result := WString(Utf8ToAnsi(txt));
end;

function PWstrRu(txt: String): PWString;
begin
 Result:=PWString(Utf8ToAnsi(txt));
end;

function PWStr(text: PChar): PWString;
const
  convertedStr : WString = nullStr;
begin
  convertedStr := WStr(text);
  Result := @convertedStr;
end;

function PWStr(text: AnsiString): PWString;
begin
  Result := PWStr(PChar(text));
end;

function WStrPas(text: PWChar): UnicodeString;
begin
{$IFDEF WINDOWS}
Result := StrPas (text);
{$ELSE}
//Result := UCS4StringToUnicodeString (text); todo
{$ENDIF}
end;

function wVector3fCreate(x, y, z: Float32): wVector3f;
begin
  Result.x := x;
  Result.y := y;
  Result.z := z;
end;

function wVector3Zero(): wVector3f;
begin
  Result.x := 0;
  Result.y := 0;
  Result.z := 0;
end;

procedure wVector3fSet(vec: PwVector3f; x, y, z: Float32);
begin
  Vec^.x := x;
  Vec^.y := y;
  Vec^.z := z;
end;

function wColor4sCreate(a, r, g, b: UInt8): wColor4s;
begin
  Result.alpha:=a;
  Result.red:=r;
  Result.green:=g;
  Result.blue:=b;
end;

procedure wColor4sSet(color: PwColor4s; a, r, g, b: UInt8);
begin
  Color^.alpha:=a;
  Color^.red:=r;
  Color^.green:=g;
  Color^.blue:=b;
end;

function wColor4fCreate(a, r, g, b: Float32): wColor4f;
begin
  Result.alpha:=a;
  Result.red:=r;
  Result.green:=g;
  Result.blue:=b;
end;

procedure wColor4fSet(color: PwColor4f; a, r, g, b: Float32);
begin
  Color^.alpha:=a;
  Color^.red:=r;
  Color^.green:=g;
  Color^.blue:=b;
end;

function wVector2iCreate(x, y: Int32): wVector2i;
begin
  Result.x:=x;
  Result.y:=y;
end;

procedure wVector2iSet(vec: PwVector2i; x, y: Int32);
begin
  vec^.x:=x;
  vec^.y:=y;
end;

function wVector2fCreate(x, y: Float32): wVector2f;
begin
  Result.x:=x;
  Result.y:=y;
end;

procedure wVector2fSet(vec: PwVector2f; x, y: Float32);
begin
  vec^.x:=x;
  vec^.y:=y;
end;





end.
