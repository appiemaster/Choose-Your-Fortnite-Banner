using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Assets }
using { /Verse.org/Colors }


# All things related to the main banner UI + customization UI. (Was too lazy to put it in its own class 🤫)
banner_ui := class:

    # Banner image
    var CurrentBannerImg: texture = img.gray_bg


    # The actual banner texture block, that is always diplayed
    BannerTextureBlock : texture_block = texture_block{DefaultImage := img.gray_bg, DefaultDesiredSize := vector2{X:= 349.979126, Y:= 96.88649}}
    
    # The texture block of the Preview UI
    PreviewBannerTextureBlock : texture_block = texture_block{DefaultImage := img.gray_bg, DefaultDesiredSize := vector2{X:= 292.064453, Y := 149.198944}}

    # The texture block of the customization UI
    CustomizationBannerTextureBlock : texture_block = texture_block:
        DefaultImage := img.gray_bg
        DefaultDesiredSize := vector2{X:= 345.122589, Y:= 278.081512}

    # UI info of the main banner UI
    var BannerUIInfo : ?ui_info = false

    # UI info of the preview UI
    var PreviewUIInfo : ?ui_info = false

    # UI info of the customization UI
    var CustomizationUIPerPlayer : ?ui_info = false

    # So events dont get called multiple times
    var Called : logic = false

    # All sliders with the appropriate settings
    RSlider : slider_regular = slider_regular:
        DefaultMinValue := 0.0, 
        DefaultMaxValue := 255.0,
        DefaultStepSize := 1.0
    GSlider : slider_regular = slider_regular:
        DefaultMinValue := 0.0, 
        DefaultMaxValue := 255.0,
        DefaultStepSize := 1.0
    BSlider : slider_regular = slider_regular:
        DefaultMinValue := 0.0, 
        DefaultMaxValue := 255.0,
        DefaultStepSize := 1.0

    # Vars to track the RGB values.
    var CurrentRValue : int =  0
    var CurrentGValue : int =  0
    var CurrentBValue : int =  0

    # All messages
    CustomizeMsg<localizes>:message = "Customize your banner!"
    RMsg<localizes>:message = "R"
    GMsg<localizes>:message = "G"
    BMsg<localizes>:message = "B"
    CloseMsg<localizes>:message = "❌"
    SaveMsg<localizes>:message = "Save"
    ResetMsg<localizes>:message = "reset"
    ExitMsg<localizes>:message = "exit"

    # All buttons 
    var ExitBtn : button_loud = button_loud{}
    CloseBtn : button_loud = button_loud{}
    SaveBtn : button_loud = button_loud{}
    ResetBtn : button_loud = button_loud{}

    # Constructor like function, that needs to be run right when creating the object.
    Init():void=
        SaveBtn.SetText(SaveMsg)
        CloseBtn.SetText(CloseMsg)
        BannerTextureBlock.SetImage(CurrentBannerImg)
        ExitBtn.SetText(ExitMsg)
        ResetBtn.SetText(ResetMsg)
        RSlider.OnValueChanged().Subscribe(IncreaseR)
        GSlider.OnValueChanged().Subscribe(IncreaseG)
        BSlider.OnValueChanged().Subscribe(IncreaseB)
    
    
    # This function changes the image of the banner texture block, also checks if its a new img or not 
    ChangeImg(InTexture : texture, NewImg : logic):void=
        BannerTextureBlock.SetImage(InTexture)
        if(not NewImg?):
            BannerTextureBlock.SetTint(CustomizationBannerTextureBlock.GetTint())
        else:
            BannerTextureBlock.SetTint(White)
        BannerTextureBlock.SetDesiredSize(vector2{X:= 292.064453, Y := 175.198944})
        set CurrentBannerImg = InTexture

    # Creates the UI of the banner
    AssignMainBannerUI(Agent : agent):void=
        if(PlayerUI := GetPlayerUI[player[Agent]]) then PlayerUI.AddWidget(MakeMainBannerCanvas(Agent))

    # Hides the UI of the banner
    HideMainBannerUI(Agent : agent):void=
        if(PlayerCanvas := BannerUIInfo?.Canvas) then PlayerCanvas.SetVisibility(widget_visibility.Collapsed)

    # Shows (if hidden) the UI of the banner
    ShowMainBannerUI(Agent : agent):void=
        if(PlayerCanvas := BannerUIInfo?.Canvas) then PlayerCanvas.SetVisibility(widget_visibility.Visible)

    # Removing the preview UI
    RemovePreviewUI(Agent : agent):void=
        if(PlayerCanvas := PreviewUIInfo?.Canvas, PlayerUI := GetPlayerUI[player[Agent]]) then PlayerUI.RemoveWidget(PlayerCanvas)
        
    # Creates preview UI
    CreatePreviewUI(Agent : agent):void=
        if(PlayerUI := GetPlayerUI[player[Agent]]) then PlayerUI.AddWidget(MakePreviewCanvas(Agent), player_ui_slot{InputMode := ui_input_mode.All})


    # Creates customization UI
    CreateCustomizationUI(Agent : agent):void=
        if(PlayerUI := GetPlayerUI[player[Agent]]):
            PlayerUI.AddWidget(MakeCustomizationCanvas(Agent), player_ui_slot{InputMode := ui_input_mode.All})
            CustomizationBannerTextureBlock.SetImage(BannerTextureBlock.GetImage())
            CustomizationBannerTextureBlock.SetTint(BannerTextureBlock.GetTint())
            ResetSliderVals()
            HideMainBannerUI(Agent)
            Print("Asigned UI cuzomtion ui")

    # Removes customization UI
    RemoveCustomizationUI(WM : widget_message):void=
        if(PlayerCanvas := CustomizationUIPerPlayer?.Canvas, PlayerUI := GetPlayerUI[WM.Player]):
            PlayerUI.RemoveWidget(PlayerCanvas)
            AssignMainBannerUI(WM.Player)
    
    # Resets tint, RGB Vals and Slider vals.
    ResetTint(WM : widget_message):void=
        CustomizationBannerTextureBlock.SetTint(White)
        ResetSliderVals()
        set CurrentRValue = 0
        set CurrentGValue = 0
        set CurrentBValue = 0

    # Increase the RGB Values of the Image based off of the slider.
    IncreaseR(WM : widget_message):void=
        if(Slider := slider_regular[WM.Source]):
            Val := Slider.GetValue()
            if(SliderVal := Floor[Val]):
                set CurrentRValue = SliderVal
                CustomizationBannerTextureBlock.SetTint(MakeColorFromSRGBValues(CurrentRValue,  CurrentGValue, CurrentBValue))
                Print("slidin")
    IncreaseG(WM : widget_message):void=
        if(Slider := slider_regular[WM.Source]):
            Val := Slider.GetValue()
            if(SliderVal := Floor[Val]):
                set CurrentGValue = SliderVal
                CustomizationBannerTextureBlock.SetTint(MakeColorFromSRGBValues(CurrentRValue,  CurrentGValue, CurrentBValue))
                Print("slidin")
    IncreaseB(WM : widget_message):void=
        if(Slider := slider_regular[WM.Source]):
            Val := Slider.GetValue()
            if(SliderVal := Floor[Val]):
                set CurrentBValue = SliderVal
                CustomizationBannerTextureBlock.SetTint(MakeColorFromSRGBValues(CurrentRValue,  CurrentGValue, CurrentBValue))
                Print("slidin")

    # Sets slider values back to 1.0
    ResetSliderVals():void=
        RSlider.SetValue(1.0)
        GSlider.SetValue(1.0)
        BSlider.SetValue(1.0)

    # Saves current img
    SaveImg(WM : widget_message):void=
        ChangeImg(CustomizationBannerTextureBlock.GetImage(), false)
    
    # Creates the canvas for the banner UI.
    MakeMainBannerCanvas(Agent : agent) : canvas=
        UIInfo := ui_info{}
        MyOverlay := overlay:
            Slots := array:
                overlay_slot:
                    Widget := texture_block:
                        DefaultImage := img.gray_bg
                        DefaultDesiredSize := vector2{X := 381.271606, Y:= 221.395279}
                overlay_slot:
                    Widget := BannerTextureBlock
        MyCanvas := canvas:
            Slots := array:
                canvas_slot:
                    Widget := MyOverlay
                    Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.5}, Maximum := vector2{X:= 0.0, Y:= 0.5}}
                    Alignment := vector2{X := -0.138764, Y:= 0.446026}
        set UIInfo.Canvas = MyCanvas
        set BannerUIInfo = option{UIInfo}
        return MyCanvas
    

    # Creates canvas for the Preview UI
    MakePreviewCanvas(Agent : agent) : canvas=
        UIInfo := ui_info{}
        MyOverlay := overlay:
            Slots := array:
                overlay_slot:
                    Widget := texture_block:
                        DefaultImage := img.gray_bg
                        DefaultDesiredSize := vector2{X := 381.271606, Y:= 346.865784}
                overlay_slot:
                    Widget := PreviewBannerTextureBlock
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top := 35.0}
                overlay_slot:
                    Widget := ExitBtn
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Bottom
                    Padding := margin{Bottom := 35.0}
        MyCanvas := canvas:
            Slots := array:
                canvas_slot:
                    Widget := MyOverlay
                    Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.5}, Maximum := vector2{X:= 0.0, Y:= 0.5}}
                    Alignment := vector2{X := -0.138764, Y:= 0.446026}
        set UIInfo.Canvas = MyCanvas
        set PreviewUIInfo = option{UIInfo}
        return MyCanvas

    # Creates the canvas for the Customization UI.
    MakeCustomizationCanvas(Agent : agent):canvas=
        UIInfo := ui_info{}
        if(not Called?):
            ExitBtn.OnClick().Subscribe(RemoveCustomizationUI)
            SaveBtn.OnClick().Subscribe(SaveImg)
            ResetBtn.OnClick().Subscribe(ResetTint)
            set Called = true
        SliderStackBox := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot:
                    Widget := text_block:
                        DefaultText := RMsg
                        DefaultTextColor := White
                    Padding := margin{Top := 3.0}
                    HorizontalAlignment := horizontal_alignment.Center
                stack_box_slot:
                    Widget := RSlider
                    Padding := margin{Top := 3.0}
                stack_box_slot:
                    Widget := text_block:
                        DefaultText := GMsg
                        DefaultTextColor := White
                    Padding := margin{Top := 3.0}
                    HorizontalAlignment := horizontal_alignment.Center
                stack_box_slot:
                    Widget := GSlider
                    Padding := margin{Top := 3.0}
                stack_box_slot:
                    Widget := text_block:
                        DefaultText := BMsg
                        DefaultTextColor := White
                    Padding := margin{Top := 3.0}
                    HorizontalAlignment := horizontal_alignment.Center
                stack_box_slot:
                    Widget := BSlider
                    Padding := margin{Top := 3.0}
        MyOverlay := overlay:
            Slots := array:
                overlay_slot:
                    Widget := texture_block:
                        DefaultImage := img.gray_bg
                        DefaultDesiredSize := vector2{X:= 697.866699, Y := 745.888794}
                overlay_slot:
                    Widget := CustomizationBannerTextureBlock
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top := 60.0}
                overlay_slot:
                    Widget := SliderStackBox
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Top := 115.0}
                overlay_slot:
                    Widget := text_block:
                        DefaultText := CustomizeMsg
                        DefaultTextColor := White
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top := 10.0}
                overlay_slot:
                    Widget := ExitBtn
                    HorizontalAlignment := horizontal_alignment.Right
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top := 5.0, Right := 5.0}
                overlay_slot:
                    Widget := SaveBtn
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Bottom
                    Padding := margin{Bottom := 15.0, Right := 125.0}
                overlay_slot:
                    Widget := ResetBtn
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Bottom
                    Padding := margin{Bottom := 15.0, Left := 125.0}
        
        MyCanvas := canvas:
            Slots :=array:
                canvas_slot:
                    Widget := MyOverlay
                    Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}}
                    Alignment := vector2{X := 0.52, Y:= 0.4798}
        set UIInfo.Canvas = MyCanvas
        set CustomizationUIPerPlayer= option{UIInfo}
        return MyCanvas
