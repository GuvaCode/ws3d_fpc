'' ----------------------------------------------------------------------------
'' Пример сделал Nikolas (WorldSim3D developer)
'' ----------------------------------------------------------------------------
'' Пример 13 : Управление главным окном движка
'' ----------------------------------------------------------------------------'

'#define __STATIC__

#Include "../Include/WorldSim3D.bi"
#include "../Include/SampleFunctions.bi"

'///User defines
#define GUI_CHECKBOX_8BIT       51
#define GUI_CHECKBOX_16BIT      52
#define GUI_CHECKBOX_32BIT      53

#define GUI_CHECKBOX_54         301
#define GUI_CHECKBOX_43         302
#define GUI_CHECKBOX_169        303
#define GUI_CHECKBOX_1610       304
#define GUI_CHECKBOX_OTHER      305

#define GUI_CHECKBOX_CLOCK      401

#define GUI_CHECKBOX_FULL       61

#define GUI_COMBOBOX_RES        71

#define GUI_SCROLL_GAMMA        81

#define GUI_SCROLL_ALPHA        85

#define GUI_SCROLL_BRIGHTNESS   91

#define GUI_BUTTON_APPLY        101

#define GUI_BUTTON_EXIT         201

'///Declare custom procedures
declare function InitResources()as Boolean

declare sub FreeResources()

declare sub SetGuiTransparency(byval skin as wGuiObject, byval  alpha as Int16)

declare sub UpdateEvents()

declare sub UpdateListBoxModes(byval listBox as wGuiObject)

declare sub CreateClock()

declare sub DrawClock(byval position as wVector2i)

'///Variables
Dim shared as wVector2i fromPos,toPos

dim shared as wVector2u currentRes		=(0,0)
dim shared as wColor3f currentGamma		=(0,0,0)
dim shared as Float32 currentBrightness	=0
dim shared as Float32 currentContrast	=0
dim shared as UInt32 currentDepth		=0

dim shared as Boolean isExit			=false
dim shared as Boolean isClock1			=true

dim shared as wFont BitmapFont           =0
dim shared as wFont TTFont               =0
dim shared as wFont TTFont2              =0
dim shared as wGuiObject skin            =0

dim shared as wGuiObject check8          =0
dim shared as wGuiObject check16         =0
dim shared as wGuiObject check32         =0

dim shared as wGuiObject check54         =0
dim shared as wGuiObject check43         =0
dim shared as wGuiObject check169        =0
dim shared as wGuiObject check1610       =0
dim shared as wGuiObject checkOther      =0

dim shared as wGuiObject checkClock      =0

dim shared as wGuiObject listModes       =0
dim shared as wGuiObject _tab(3)         
dim shared as wGuiObject tabLabel(3)    
dim shared as wGuiObject lblPart1(8)    
dim shared as wGuiObject lblPart2(4)    
dim shared as wGuiObject lblPart3        =0

Dim shared as wGuiObject comboRes        =0
Dim shared as wGuiObject checkFullScreen =0
Dim shared as wGuiObject lblGamma        =0
Dim shared as wGuiObject scrollGamma     =0
Dim shared as wGuiObject lblAlpha        =0
Dim shared as wGuiObject scrollAlpha     =0
Dim shared as wGuiObject btnApply        =0
Dim shared as wGuiObject btnExit         =0

Dim shared as wTexture tClock_base       =0
Dim shared as wTexture tClock_h          =0
Dim shared as wTexture tClock_m          =0
Dim shared as wTexture tClock_s          =0

Dim shared as wTexture tClock_base2      =0
Dim shared as wTexture tClock_s2         =0

dim shared as wNode camera               =0
dim shared as wNode testNode             =0
Dim shared as wTexture texNode           =0

dim as wVector3f turnVector				=wVECTOR3f_ZERO

dim as string wndCaption 				="Example 13: Screen options "
Dim as Int32 prevFPS              		=0

'///Start engine
Dim as Boolean init=wEngineStart(wDRT_OPENGL,wDEFAULT_SCREENSIZE,32,false,true,true,false)
if Not init then
    PrintWithColor("wEngineStart() failed!",wCFC_RED,true)
    end
endif

if not InitResources() then
   FreeResources()
   wEngineStop()
   end
endif

'///Show logo WS3D
wEngineShowLogo(true)

while wEngineRunning()and (not isExit)
    wSceneBegin(wCOLOR4s_BLACK)

    turnVector.y=wTimerGetDelta()*30
    turnVector.z=wTimerGetDelta()*30

    wNodeTurn(testNode,turnVector)

    wSceneDrawAll()

    wGuiDrawAll()

    UpdateEvents()

    prevFPS = wEngineGetFPS()
    wWindowSetCaption(wndCaption+str(prevFPS))

    if wWindowIsFullscreen() then
		fromPos.x=currentRes.x/2-wFontGetTextSize(BitmapFont,wndCaption+str(prevFPS)).x/2
		fromPos.y=2
		toPos.x=800
		toPos.y=30
        wFontDraw(BitmapFont,wndCaption+str(prevFPS),fromPos,toPos)
	endif
    
    wSceneEnd()

    wEngineCloseByEsc()

wend

FreeResources()

'///Stop engine
wEngineStop()

end


function InitResources()as Boolean
    skin=wGuiGetSkin()

    Dim as string fontPath="../../Assets/Fonts/Cyr.xml"
    '///Check resources
    CheckFilePath(fontPath)

    '///Load resources
    BitmapFont=wFontLoad(fontPath)
    if BitmapFont=0 then BitmapFont=wFontGetDefault()

    '///Create CUSTOM gui tab-system
    fromPos.x=10: fromPos.y=10
    toPos.x=wDEFAULT_SCREENSIZE.x-10: toPos.y=wDEFAULT_SCREENSIZE.y-10
    _tab(0)=wGuiTabCreate(fromPos,toPos)
    wGuiTabSetDrawBackground(_tab(0),true)
    wGuiTabSetBackgroundColor(_tab(0),wCOLOR4s_SKYBLUE)
	
    _tab(1)=wGuiTabCreate(fromPos,toPos)
    wGuiTabSetDrawBackground(_tab(1),true)
    wGuiTabSetBackgroundColor(_tab(1),wCOLOR4s_SKYBLUE)
    wGuiObjectSetVisible(_tab(1),false)

    _tab(2)=wGuiTabCreate(fromPos,toPos)
    wGuiTabSetDrawBackground(_tab(2),true)
    wGuiTabSetBackgroundColor(_tab(2),wCOLOR4s_SKYBLUE)
    wGuiObjectSetVisible(_tab(2),false)

    '///Создадим текстовые метки. С их помощью будем управлять TAB-элементами
    fromPos.x=10 : fromPos.y=10 : toPos.x=200 : toPos.y=50
    tabLabel(0)=wGuiLabelCreate("System Information",fromPos,toPos)
    wGuiLabelSetOverrideColor(tabLabel(0),wCOLOR4s_WHITE)
    wGuiLabelSetBackgroundColor(tabLabel(0),wCOLOR4s_DARKBLUE)
    wGuiLabelSetDrawBackground(tabLabel(0),true)
    wGuiLabelSetDrawBorder(tabLabel(0),true)
    wGuiLabelSetTextAlignment(tabLabel(0),wGA_CENTER,wGA_CENTER)

    fromPos.x=200 : fromPos.y=10 : toPos.x=400 : toPos.y=50	
    tabLabel(1)=wGuiLabelCreate("Display Information",fromPos,toPos)
    wGuiLabelSetOverrideColor(tabLabel(1),wCOLOR4s_DARKBLUE)
    wGuiLabelSetBackgroundColor(tabLabel(1),wCOLOR4s_BLACK)
    wGuiLabelSetDrawBackground(tabLabel(1),false)
    wGuiLabelSetDrawBorder(tabLabel(1),true)
    wGuiLabelSetTextAlignment(tabLabel(1),wGA_CENTER,wGA_CENTER)

    fromPos.x=400 : fromPos.y=10 : toPos.x=600 : toPos.y=50
    tabLabel(2)=wGuiLabelCreate("Display Options change",fromPos,toPos)
    wGuiLabelSetOverrideColor(tabLabel(2),wCOLOR4s_DARKBLUE)
    wGuiLabelSetBackgroundColor(tabLabel(2),wCOLOR4s_BLACK)
    wGuiLabelSetDrawBackground(tabLabel(2),false)
    wGuiLabelSetDrawBorder(tabLabel(2),true)
    wGuiLabelSetTextAlignment(tabLabel(2),wGA_CENTER,wGA_CENTER)

    '///Для каждого TAB-элемента создаем и закрепляем контент
    '///согласно замыслу примера
    '///Заполняем первый TAB-слой

    Dim as string osVer=*wSystemGetVersion()
    fromPos.x=20 : fromPos.y=50 : toPos.x=600 : toPos.y=100
    lblPart1(0)=wGuiLabelCreate("Your OS: "+osVer,fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart1(0),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart1(0),_tab(0))

    Dim as UInt32 tMemory=wSystemGetTotalMemory()
    fromPos.x=20 : fromPos.y=100 : toPos.x=600 : toPos.y=150
    lblPart1(1)=wGuiLabelCreate("Total memory: "+str(CInt(tMemory/1024))+" Mb",fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart1(1),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart1(1),_tab(0))

    Dim as UInt32 aMemory=wSystemGetAvailableMemory()
    fromPos.x=20 : fromPos.y=150 : toPos.x=600 : toPos.y=200
    lblPart1(2)=wGuiLabelCreate("Available memory: "+str(CInt(aMemory/1024)),fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart1(2),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart1(2),_tab(0))

    Dim as UInt32 speed=wSystemGetProcessorSpeed()
    fromPos.x=20 : fromPos.y=200 : toPos.x=600 : toPos.y=250
    lblPart1(3)=wGuiLabelCreate("Processor speed: "+str(speed)+" MHz",fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart1(3),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart1(3),_tab(0))

    Dim as wRealTimeDate dInfo=wTimerGetRealTimeAndDate()
    fromPos.x=20 : fromPos.y=250 : toPos.x=600 : toPos.y=300
    lblPart1(4)=wGuiLabelCreate("Current date: ( "+str(dInfo._Day)+" / "+str(dInfo._Month)+" / "+str(dInfo._Year)+" )",fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart1(4),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart1(4),_tab(0))

    Dim as string _WeekDay
    select case dInfo._Weekday
		case wWD_MONDAY
			_WeekDay="Monday"
		case wWD_TUESDAY
			_WeekDay="Tuesday"
		case wWD_WEDNESDAY
			_WeekDay="Wendesday"
		case wWD_THURSDAY
			_WeekDay="Thursday"
		case wWD_FRIDAY
			_WeekDay="Friday"
		case wWD_SATURDAY
			_WeekDay="Saturday"
		case wWD_SUNDAY
			_WeekDay="Sunday"
    end select
    
    Dim as string isDST="NO"
    if dInfo._IsDST then isDST="YES"

    Dim as string temp="Weekday: "+str(_WeekDay)
    fromPos.x=20 : fromPos.y=300 : toPos.x=600 : toPos.y=350 
    lblPart1(5)=wGuiLabelCreate(temp,fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart1(5),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart1(5),_tab(0))
    
    temp=" Yearday: "+str(dInfo._Yearday)
    fromPos.x=20 : fromPos.y=350 : toPos.x=600 : toPos.y=400 
    lblPart1(6)=wGuiLabelCreate(temp,fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart1(6),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart1(6),_tab(0))  
    
    temp="Whether daylight saving is on?  "+isDST
    fromPos.x=20 : fromPos.y=400 : toPos.x=600 : toPos.y=450 
    lblPart1(7)=wGuiLabelCreate(temp,fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart1(7),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart1(7),_tab(0))  


    fromPos.x=600 : fromPos.y=530 : toPos.x=790 : toPos.y=590 
    checkClock=wGuiCheckBoxCreate("Clock mode 1",fromPos,toPos,true)
    wGuiObjectSetId(checkClock,GUI_CHECKBOX_CLOCK)
    wGuiCheckBoxSetFilled(checkClock,false)
    wGuiObjectSetParent(checkClock,_tab(0))

    '///Заполняем второй TAB-слой
    Dim as string vendor=*wDisplayGetVendor()
    fromPos.x=20 : fromPos.y=50 : toPos.x=600 : toPos.y=100
    lblPart2(0)=wGuiLabelCreate("Your display vendor: "+vendor,fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart2(0),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart2(0),_tab(1))

    currentRes=wDisplayGetCurrentResolution()
    fromPos.x=20 : fromPos.y=100 : toPos.x=600 : toPos.y=150
    lblPart2(1)=wGuiLabelCreate("Current display resolution: "+str(currentRes.x)+" x "+str(currentRes.y),fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart2(1),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart2(1),_tab(1))

    currentRes=wDEFAULT_SCREENSIZE

    currentDepth=wDisplayGetCurrentDepth()
    fromPos.x=20 : fromPos.y=150 : toPos.x=600 : toPos.y=200
    lblPart2(2)=wGuiLabelCreate("Current display depth: "+str(currentDepth),fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart2(2),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart2(2),_tab(1))

    Dim as Int32 displayModesCount=wDisplayModesGetCount()
    fromPos.x=20 : fromPos.y=200 : toPos.x=600 : toPos.y=250
    lblPart2(3)=wGuiLabelCreate("Display supported modes count: "+str(displayModesCount),fromPos,toPos)
    wGuiLabelSetOverrideColor(lblPart2(3),wCOLOR4s_DARKRED)
    wGuiObjectSetParent(lblPart2(3),_tab(1))

    fromPos.x=20 : fromPos.y=270 : toPos.x=550 : toPos.y=560
    listModes=wGuiListBoxCreate(fromPos,toPos,true)
    wGuiObjectSetParent(listModes,_tab(1))

    fromPos.x=570 : fromPos.y=300 : toPos.x=650 : toPos.y=350
    check8=wGuiCheckBoxCreate("8 bit",fromPos,toPos,false)
    wGuiObjectSetId(check8,GUI_CHECKBOX_8BIT)
    wGuiCheckBoxSetFilled(check8,false)
    wGuiObjectSetParent(check8,_tab(1))

    fromPos.x=570 : fromPos.y=350 : toPos.x=650 : toPos.y=400
    check16=wGuiCheckBoxCreate("16 bit",fromPos,toPos,false)
    wGuiObjectSetId(check16,GUI_CHECKBOX_16BIT)
    wGuiCheckBoxSetFilled(check16,false)
    wGuiObjectSetParent(check16,_tab(1))

    fromPos.x=570 : fromPos.y=400 : toPos.x=650 : toPos.y=450
    check32=wGuiCheckBoxCreate("32 bit",fromPos,toPos,true)
    wGuiObjectSetId(check32,GUI_CHECKBOX_32BIT)
    wGuiCheckBoxSetFilled(check32,false)
    wGuiObjectSetParent(check32,_tab(1))

    fromPos.x=670 : fromPos.y=300 : toPos.x=750 : toPos.y=340
    check54=wGuiCheckBoxCreate("5:4",fromPos,toPos,false)
    wGuiObjectSetId(check54,GUI_CHECKBOX_54)
    wGuiCheckBoxSetFilled(check54,false)
    wGuiObjectSetParent(check54,_tab(1))

    fromPos.x=670 : fromPos.y=340 : toPos.x=750 : toPos.y=380
    check43=wGuiCheckBoxCreate("4:3",fromPos,toPos,true)
    wGuiObjectSetId(check43,GUI_CHECKBOX_43)
    wGuiCheckBoxSetFilled(check43,false)
    wGuiObjectSetParent(check43,_tab(1))

    fromPos.x=670 : fromPos.y=380 : toPos.x=750 : toPos.y=420
    check169=wGuiCheckBoxCreate("16:9",fromPos,toPos,true)
    wGuiObjectSetId(check169,GUI_CHECKBOX_169)
    wGuiCheckBoxSetFilled(check169,false)
    wGuiObjectSetParent(check169,_tab(1))

    fromPos.x=670 : fromPos.y=420 : toPos.x=750 : toPos.y=460
    check1610=wGuiCheckBoxCreate("16:10",fromPos,toPos,true)
    wGuiObjectSetId(check1610,GUI_CHECKBOX_1610)
    wGuiCheckBoxSetFilled(check1610,false)
    wGuiObjectSetParent(check1610,_tab(1))

    fromPos.x=670 : fromPos.y=460 : toPos.x=750 : toPos.y=500
    checkOther=wGuiCheckBoxCreate("Other",fromPos,toPos,false)
    wGuiObjectSetId(checkOther,GUI_CHECKBOX_OTHER)
    wGuiCheckBoxSetFilled(checkOther,false)
    wGuiObjectSetParent(checkOther,_tab(1))

    UpdateListBoxModes(listModes)

    '///Заполняем третий TAB-слой
    fromPos.x=30 : fromPos.y=100 : toPos.x=300 : toPos.y=150
    lblPart3=wGuiLabelCreate("Choice engine windows size",fromPos,toPos)
    wGuiObjectSetParent(lblPart3,_tab(2))

    fromPos.x=30 : fromPos.y=150 : toPos.x=250 : toPos.y=180
    comboRes=wGuiComboBoxCreate(fromPos,toPos)
    wGuiObjectSetId(comboRes,GUI_COMBOBOX_RES)
    wGuiObjectSetParent(comboRes,_tab(2))

    for i as UInt32 =0 to wDisplayModesGetCount()-1
        Dim as Int32 bits=wDisplayModeGetDepth(i)
        Dim as wVector2u res=wDisplayModeGetResolution(i)
        if bits=32 then
            if res.x>=800 and res.y>=600 then
                Dim as UInt32 idx=wGuiComboBoxAddItem(comboRes,str(res.x)+" x "+str(res.y),i)
                if res.x=currentRes.x and res.y=currentRes.y then
                    wGuiComboBoxSetSelected(comboRes,idx)
                endif
            endif
        endif
    next i

    fromPos.x=300 : fromPos.y=150 : toPos.x=550 : toPos.y=180
    checkFullScreen=wGuiCheckBoxCreate("Fullscreen",fromPos,toPos,wWindowIsFullscreen())
    wGuiObjectSetId(checkFullScreen,GUI_CHECKBOX_FULL)
    wGuiCheckBoxSetFilled(checkFullScreen,false)
    wGuiObjectSetParent(checkFullScreen,_tab(2))

   fromPos.x=45 : fromPos.y=320 : toPos.x=500 : toPos.y=345
   wDisplayGetGammaRamp(@currentGamma,@currentBrightness,@currentContrast)

   lblGamma=wGuiLabelCreate("Display gamma: "+str(currentGamma.red),fromPos,toPos)
   wGuiObjectSetParent(lblGamma,_tab(2))

    fromPos.x=45 : fromPos.y=350 : toPos.x=300 : toPos.y=365
    scrollGamma=wGuiScrollBarCreate(true,fromPos,toPos)
    wGuiObjectSetId(scrollGamma,GUI_SCROLL_GAMMA)
    wGuiScrollBarSetMaxValue(scrollGamma,350)
    wGuiScrollBarSetMinValue(scrollGamma,20)
    wGuiScrollBarSetLargeStep(scrollGamma,10)
    wGuiScrollBarSetSmallStep(scrollGamma,1)
    wGuiScrollBarSetValue(scrollGamma,wMathFloor(currentGamma.red*100.0f))
    wGuiObjectSetParent(scrollGamma,_tab(2))

    fromPos.y+=30 : toPos.y+=40
    lblAlpha=wGuiLabelCreate("GUI alpha: 200",fromPos,toPos)
    wGuiObjectSetParent(lblAlpha,_tab(2))

    fromPos.y+=30 : toPos.y+=20
    scrollAlpha=wGuiScrollBarCreate(true,fromPos,toPos)
    wGuiObjectSetId(scrollAlpha,GUI_SCROLL_ALPHA)
    wGuiScrollBarSetMaxValue(scrollAlpha,255)
    wGuiScrollBarSetMinValue(scrollAlpha,10)
    wGuiScrollBarSetLargeStep(scrollAlpha,10)
    wGuiScrollBarSetSmallStep(scrollAlpha,1)
    wGuiScrollBarSetValue(scrollAlpha,200)
    wGuiObjectSetParent(scrollAlpha,_tab(2))
    SetGuiTransparency(skin,200)

    '///Create button apply changes
    fromPos.x=500 : fromPos.y=150 : toPos.x=700 : toPos.y=180
    btnApply=wGuiButtonCreate(fromPos,toPos,"Apply changes","Apply changes (window size & fullscreen)")
    wGuiObjectSetId(btnApply,GUI_BUTTON_APPLY)
    wGuiObjectSetParent(btnApply,_tab(2))

    '///Create button Exit
    fromPos.x=700 : fromPos.y=530 : toPos.x=770 : toPos.y=570
    btnExit=wGuiButtonCreate(fromPos,toPos,"EXIT","Press to exit")
    wGuiObjectSetId(btnExit,GUI_BUTTON_EXIT)
    wGuiObjectSetParent(btnExit,_tab(2))

    if not wWindowIsFullscreen() then wWindowPlaceToCenter()

    '///Настраиваем Gui-скин- можно менять внешний вид ВСЕХ элементов
    wGuiSkinSetFont(skin,BitmapFont)
    wGuiSkinSetColor(skin,wGDC_BUTTON_TEXT,wCOLOR4s_DARKBLUE)

    '///Create clock
    CreateClock()

    '///Create Scene
    Dim as wVector3f vector1
    vector1.x=0
    vector1.y=0
    vector1.z=-50

    camera=wCameraCreate(vector1,wVECTOR3f_ZERO)

    texNode=wTextureLoad("../../Assets/Textures/default_texture.png")

    testNode=wNodeCreateCube(10)
    wNodeSetPosition(testNode,wVECTOR3f_ZERO)

    for i as Int32 =0 to wNodeGetMaterialsCount(testNode)-1
        Dim as wMaterial mat=wNodeGetMaterial(testNode,i)
        wMaterialSetFlag(mat,wMF_LIGHTING,false)
        wMaterialSetTexture(mat,0,texNode)
    next i

    return true
end function


sub FreeResources()
    '///Fix calculate gamma (error ?)
    currentGamma.red/=1.0182803f
    currentGamma.green/=1.0182803f
    currentGamma.blue/=1.0182803f
    wDisplaySetGammaRamp(currentGamma,0,0)

    wGuiDestroyAll()
    wSceneDestroyAllNodes()
end sub


sub UpdateEvents()
    '///Из трех элементов (обычных текстовых МЕТОК) сделаем полноценный TAB-контрол
     for i as Int32 =0 to 2
        if wGuiObjectIsHovered(tabLabel(i)) and wInputIsMouseHit(wMB_LEFT) then
             wGuiLabelSetDrawBackground(tabLabel(i),true)
             wGuiLabelSetOverrideColor(tabLabel(i),wCOLOR4s_WHITE)
             wGuiLabelSetBackgroundColor(tabLabel(i),wCOLOR4s_DARKBLUE)
             wGuiObjectSetVisible(_tab(i),true)
             for k as Int32 =0 to i-1
                 wGuiLabelSetOverrideColor(tabLabel(k),wCOLOR4s_DARKBLUE)
                 wGuiLabelSetBackgroundColor(tabLabel(k),wCOLOR4s_BLACK)
                 wGuiLabelSetDrawBackground(tabLabel(k),false)
                 wGuiObjectSetVisible(_tab(k),false)
            next k
            for k as Int32 =i+1 to 2
                 wGuiLabelSetOverrideColor(tabLabel(k),wCOLOR4s_DARKBLUE)
                 wGuiLabelSetBackgroundColor(tabLabel(k),wCOLOR4s_BLACK)
                 wGuiLabelSetDrawBackground(tabLabel(k),false)
                 wGuiObjectSetVisible(_tab(k),false)
           next k
        endif
     next i

     '///Gui events (For call update listbox)
     if wGuiIsEventAvailable() then
        
        Dim as wGuiEvent ptr ev=wGuiReadEvent()
        if ev->event=wGCT_CHECKBOX_CHANGED then
           if ev->id=GUI_CHECKBOX_16BIT or GUI_CHECKBOX_32BIT or GUI_CHECKBOX_8BIT then
              UpdateListBoxModes(listModes)
           endif

           if ev->id=GUI_CHECKBOX_CLOCK then
              isClock1=wGuiCheckBoxIsChecked(checkClock)
           endif
        endif

        if ev->event=wGCT_SCROLL_BAR_CHANGED then
             if ev->id=GUI_SCROLL_GAMMA then
                Dim as wColor3f gammaColor
                Dim as Float32 gamma=Cast(Float32,wGuiScrollBarGetValue(scrollGamma)*0.01f)
                gammaColor.red=gamma
                gammaColor.blue=gamma
                gammaColor.green=gamma
                wDisplaySetGammaRamp(gammaColor,0,0)
                wGuiObjectSetText(lblGamma,"Display gamma: "+str(gammaColor.red))
             endif

             if ev->id=GUI_SCROLL_ALPHA then
                Dim as Int32 _alpha=wGuiScrollBarGetValue(scrollAlpha)
                SetGuiTransparency(skin,_alpha)
                wGuiObjectSetText(lblAlpha,"GUI alpha: "+str(_alpha))
             endif
         endif

         if ev->event=wGCT_BUTTON_CLICKED then
            
            if ev->id=GUI_BUTTON_EXIT then
               isExit=true
            endif

            if ev->id=GUI_BUTTON_APPLY then
               Dim as Boolean fullscreen=wGuiCheckBoxIsChecked(checkFullScreen)
               Dim as UInt32 idx2=wGuiComboBoxGetSelected(comboRes)
               Dim as UInt32 data2=wGuiComboBoxGetItemDataByIndex(comboRes,idx2)
               Dim as wVector2u dataRes=wDisplayModeGetResolution(data2)

               if(dataRes.x<>currentRes.x)  or (dataRes.y<>currentRes.y) then
                   if not wWindowIsFullscreen() then
                      currentRes=dataRes
                      wWindowResize(currentRes)
                      wWindowPlaceToCenter()
                   else
                      wWindowSetFullscreen(false)
                      wWindowResize(dataRes)
                      currentRes=dataRes
                      wWindowSetFullscreen(true)
                   endif
                   
                   Dim as wVector2i position
                   position.x=dataRes.x/2-(wDEFAULT_SCREENSIZE.x-20)/2
                   position.y=dataRes.y/2-(wDEFAULT_SCREENSIZE.y-20)/2
                   '///При смене разрешения обновляем положение Tab-группы
                   for i as Int32=0 to 2
                        wGuiObjectSetRelativePosition(_tab(i),position)
                   next i
                   '///и самодельного контрола управления Tab-группой
                   '///(набора из трех меток Label)
                   wGuiObjectSetRelativePosition(tabLabel(0),position)
                   position.x+=190
                   wGuiObjectSetRelativePosition(tabLabel(1),position)
                   position.x+=200
                   wGuiObjectSetRelativePosition(tabLabel(2),position)
                endif

                if fullscreen<>wWindowIsFullscreen() then
                   wWindowSetFullscreen(fullscreen)
                   if not fullscreen then wWindowPlaceToCenter()
                endif

                endif
             endif
         endif

         if wGuiObjectIsVisible(_tab(0)) then
             Dim as wVector2i clockPos
             clockPos.x=currentRes.x/2+100
             clockPos.y=currentRes.y/2+50
             DrawClock(clockPos)
         endif

end sub


sub UpdateListBoxModes(byval listBox as wGuiObject)

    wGuiListBoxRemoveAll(listBox)

    Dim as Boolean bits8=wGuiCheckBoxIsChecked(check8)
    Dim as Boolean bits16=wGuiCheckBoxIsChecked(check16)
    Dim as Boolean bits32=wGuiCheckBoxIsChecked(check32)

    Dim as Boolean aspect54=wGuiCheckBoxIsChecked(check54)
    Dim as Boolean aspect43=wGuiCheckBoxIsChecked(check43)
    Dim as Boolean aspect169=wGuiCheckBoxIsChecked(check169)
    Dim as Boolean aspect1610=wGuiCheckBoxIsChecked(check1610)
    Dim as Boolean aspectOther=wGuiCheckBoxIsChecked(checkOther)

    for i as Int32 =0 to wDisplayModesGetCount()-1
        Dim as wVector2u res=wDisplayModeGetResolution(i)
        Dim as Int32 bits=wDisplayModeGetDepth(i)
        Dim as Float32 aspect=Cast(Float32,res.x/res.y)
		
		Dim as Boolean flag1,flag2,flag3,flag4,flag5,flag6,flag7
		if(bits=8) then
			if bits8 then flag1=true
		endif
		
		if(bits=16) then
			if bits16 then flag2=true
		endif

		if(bits=32) then
			if bits32 then flag3=true
		endif
		
        if flag1 or flag2 or flag3 then
            Dim as string temp="Mode No "+str(i)+" ( "+str(res.x)+" x "+str(res.y)+" ) bits: "+str(bits)
            Dim as Int32 idx=-1

            if aspect43 then
               if wMathFloatEquals(aspect,1.33333f,0.00001f) then
                   idx=wGuiListBoxAddItem(listBox,temp)
                   flag4=true
               endif
            endif

            if aspect54 then
               if wMathFloatEquals(aspect,1.25000f,0.00001f) then
                   idx=wGuiListBoxAddItem(listBox,temp)
                   flag5=true
               endif
            endif

            if aspect169 then
               if wMathFloatEquals(aspect,1.77778f,0.00001f) then
                   idx=wGuiListBoxAddItem(listBox,temp)
                   flag6=true
               endif    
            endif

            if aspect1610 then
                if wMathFloatEquals(aspect,1.60000f,0.00001f) then
                    idx=wGuiListBoxAddItem(listBox,temp)
                    flag7=true
                endif    
            endif

            if aspectOther then
               if (not flag4) and (not flag5) and (not flag6) and (not flag7) then
                    idx=wGuiListBoxAddItem(listBox,temp)
               endif
            endif

            if idx mod 2 then
                wGuiListBoxSetElementColor(listBox,idx,wGLC_TEXT,wCOLOR4s_DARKBLUE)
            else
                wGuiListBoxSetElementColor(listBox,idx,wGLC_TEXT,wCOLOR4s_BLUE)
            endif
        endif

    next i
end sub


sub CreateClock()
    tClock_base=wTextureLoad("../../Assets/Textures/clock_base.png")
    tClock_h=wTextureLoad("../../Assets/Textures/arrow_h.png")
    tClock_m=wTextureLoad("../../Assets/Textures/arrow_m.png")
    tClock_s=wTextureLoad("../../Assets/Textures/arrow_s.png")

    TTFont=wFontLoadFromTTF("../../Assets/Fonts/LCDNOVA.ttf",64,false,true)
    TTFont2=wFontLoadFromTTF("../../Assets/Fonts/LCDNOVA.ttf",14,false,true)
    tClock_base2=wTextureLoad("../../Assets/Textures/clock_base2.png")
    tClock_s2=CreateColorTexture(wCOLOR4s_DARKBLUE)
end sub


sub DrawClock(byval position as wVector2i)

    Dim as wRealTimeDate dInfo=wTimerGetRealTimeAndDate()

    Dim as wColor4s clockColor=wCOLOR4s_WHITE
    Dim as wColor4s fontColor=wCOLOR4s_DARKBLUE

    clockColor.alpha=wGuiScrollBarGetValue(scrollAlpha)
    fontColor.alpha=wGuiScrollBarGetValue(scrollAlpha)

    if isClock1 then
        '///Draw clock
        wTextureDraw(tClock_base,position,true,clockColor)

        Dim as wVector2i rotPoint
        rotPoint.x=position.x+100
        rotPoint.y=position.y+100

        Dim as wVector2i arrowPos

        '///Draw hour arrow
        if dInfo._Hour>12 then dInfo._Hour-=12
        arrowPos.x=position.x+100-6
        arrowPos.y=position.y+100-38
        wTextureDrawAdvanced(tClock_h,arrowPos,rotPoint,-Cast(Float32,dInfo._Hour*30)-Cast(Float32,dInfo._Minute/2),wVECTOR2f_ONE,true,clockColor)

        '///Draw minute arrow
        arrowPos.x=position.x+100-4
        arrowPos.y=position.y+100-64
        wTextureDrawAdvanced(tClock_m,arrowPos,rotPoint,-Cast(Float32,dInfo._Minute*6)-Cast(Float32,dInfo._Second/10),wVECTOR2f_ONE,true,clockColor)

        '///Draw second arrow
        arrowPos.x=position.x+100-4
        arrowPos.y=position.y+100-61
        wTextureDrawAdvanced(tClock_s,arrowPos,rotPoint,-Cast(Float32,dInfo._Second*6),wVECTOR2f_ONE,true,clockColor)
    else
        '///Draw clock
        wTextureDraw(tClock_base2,position,true,clockColor)
        Dim as wVector2i p1,p2

        '///Draw hour
        p1.x=position.x+40
        p1.y=position.y+50
        p2.x=p1.x+200
        p2.y=p1.y+50
        
        if dInfo._Hour<10 then
            wFontDraw(TTFont,"0"+str(dInfo._Hour),p1,p2,fontColor)
        else
            wFontDraw(TTFont,str(dInfo._Hour),p1,p2,fontColor)
        endif    

        '///Draw minute
        p1.x+=80 : p2.x+=80
        if dInfo._Minute<10 then
            wFontDraw(TTFont,"0"+str(dInfo._Minute),p1,p2,fontColor)
        else
            wFontDraw(TTFont,str(dInfo._Minute),p1,p2,fontColor)
        endif

        '///Draw seconds
        p1.x+=80 : p2.x+=90
        p1.y=position.y+90
        p2.y=p1.y+40       
        if dInfo._Second<10 then
            wFontDraw(TTFont2,"0"+str(dInfo._Second),p1,p2,fontColor)
        else
            wFontDraw(TTFont2,str(dInfo._Second),p1,p2,fontColor)
		endif

        '///Draw AM/PM
        p1.x=position.x+200
        p1.y=position.y+50
        p2.x=p1.x+50
        p2.y=p1.y+50
        if dInfo._Hour<=12 then
            wFontDraw(TTFont2,"AM",p1,p2,fontColor)
        else
            wFontDraw(TTFont2,"PM",p1,p2,fontColor)
        endif

        '///Draw points (HH : MM)
        p1.x=position.x+107
        p2.x=p1.x+20
        p1.y=position.y+42
        p2.y=position.y+20
        if dInfo._Second mod 2 then
            wFontDraw(TTFont,":",p1,p2,fontColor)
        endif

    endif
end sub


sub SetGuiTransparency(byval skin as wGuiObject,byval _alpha as Int16)

	for i as Int32 =0  to wGDC_COUNT-1
		Dim as wColor4s col =wGuiSkinGetColor(skin,i)
		col.alpha=_alpha
		wGuiSkinSetColor(skin,i,col)
	next i

    for i as Int32 =0 to 2
        Dim as wColor4s col=wGuiTabGetBackgroundColor(_tab(i))
        col.alpha=_alpha
        wGuiTabSetBackgroundColor(_tab(i),col)
        col=wGuiTabGetTextColor(_tab(i))
        col.alpha=_alpha
        wGuiTabSetTextColor(_tab(i),col)
    next i

    for i as Int32=0 to 7
        Dim as wColor4s c=wGuiLabelGetOverrideColor(lblPart1(i))
        c.alpha=_alpha
        wGuiLabelSetOverrideColor(lblPart1(i),c)
    next i

    for i as Int32=0 to 3
        Dim as wColor4s c=wGuiLabelGetOverrideColor(lblPart2(i))
        c.alpha=_alpha
        wGuiLabelSetOverrideColor(lblPart2(i),c)
    next i

    Dim as UInt32 count=wGuiListBoxGetItemsCount(listModes)
    
    for i as Int32 =0 to count-1
        Dim as wColor4s clr=wGuiListBoxGetElementColor(listModes,i,wGLC_TEXT)
        clr.alpha=_alpha
        wGuiListBoxSetElementColor(listModes,i,wGLC_TEXT,clr)
    next i
    
end sub

