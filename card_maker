using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Assets }


card_maker := class:


    # Saving an optional oject here, which stores the overlay and more (if i wanted to, but in this case, i only store an overlay.)
    var MaybeCardOverlay : ?ui_info = false

    # The title of the banner
    Title : string 

    # The description of the banner
    Description : string

    # The image of the banners
    BannerImg : texture


    # This logic makes sure that the button events dont get listened to multiple times. This happens when you recreate the canvas again and again.
    var Called : logic = false

    # Converts the string into a message
    S2M<localizes>(S : string):message = "{S}"

    # All messages
    DescriptionDefaultMsg<localizes>:message = "Banner description:"
    CloseMessage<localizes>:message = "❌"
    EquipMessage<localizes>:message = "EQUIP"
    PreviewMessage<localizes>:message = "PREVIEW"

    # All textblocks
    TitleTextBlock : text_block = text_block{DefaultTextColor := White}
    DescriptionTextBlock : text_block = text_block{DefaultTextColor := White}
    DescriptionDefaultTextBlock : text_block = text_block{DefaultTextColor := White}

    # Button for closing the card.
    CloseBtn : button_regular = button_regular{}


    # Constructor like function, needs to be called when creating an instance of a class.
    Init():void=
        TitleTextBlock.SetText(S2M(Title))
        DescriptionTextBlock.SetText(S2M(Description))
        DescriptionDefaultTextBlock.SetText(DescriptionDefaultMsg)
        CloseBtn.SetText(CloseMessage)

    # Collapsing the card UI. Hiding it instead of removing it makes it way more responsive, since removing UI is slow.
    CollapseCardUI(WM  : widget_message):void=
        if(CardOverlay :=MaybeCardOverlay?) then CardOverlay.Overlay.SetVisibility(widget_visibility.Collapsed)


    # Here we create the card overlay, while passing in the equipbtn and the previewbtn. I do this so i can listen to the events elsewhere, outside of the class. 
    GetCardOverlay(PreviewBtn : button_loud, EquipBtn : button_loud):overlay=
        PreviewBtn.SetText(PreviewMessage)
        EquipBtn.SetText(EquipMessage)
        UIInfo := ui_info{}
        if( not Called?):
            CloseBtn.OnClick().Subscribe(CollapseCardUI)
            set Called = true
        BannerOverlay := overlay:
            Slots := array:
                overlay_slot:
                    Widget := texture_block{DefaultImage := img.gray_bg, DefaultDesiredSize := vector2{X:= 376.106201, Y:= 327.6008}}
                overlay_slot:
                    Widget := TitleTextBlock
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top := 15.0}
                overlay_slot:
                    Widget :=  Widget := texture_block{DefaultImage := BannerImg, DefaultDesiredSize := vector2{X:= 306.828003, Y:= 206.740082}}
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Top := 15.0}
        DescriptionOverlay := overlay:
            Slots := array:
                overlay_slot:
                    Widget := texture_block{DefaultImage := img.gray_bg, DefaultDesiredSize := vector2{X:= 407.144928, Y:= 130.308502}}
                overlay_slot:
                    Widget := DescriptionDefaultTextBlock
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Bottom := 25.0}
                overlay_slot:
                    Widget := DescriptionTextBlock
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Bottom
                    Padding := margin{Bottom := 15.0}
        MyOverlay := overlay:
            Slots := array:
                overlay_slot:
                    Widget := texture_block:
                        DefaultImage := img.black_transparent_bg
                        DefaultDesiredSize := vector2{X:= 440.624298,Y:= 924.500549}
                overlay_slot:
                    Widget :=BannerOverlay
                    Padding := margin{Top := 100.0}
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Top
                overlay_slot:
                    Widget := DescriptionOverlay
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Top := 100.0}
                overlay_slot:
                    Widget := EquipBtn
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Bottom
                    Padding := margin{Bottom := 15.0}
                overlay_slot:
                    Widget := CloseBtn
                    HorizontalAlignment := horizontal_alignment.Right
                    VerticalAlignment := vertical_alignment.Top
                overlay_slot:
                    Widget := PreviewBtn
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Bottom
                    Padding := margin{Bottom := 120.0}

        set UIInfo.Overlay = MyOverlay
        set MaybeCardOverlay = option{UIInfo}
        return MyOverlay
