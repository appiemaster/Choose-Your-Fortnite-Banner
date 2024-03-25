
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
Inventory := class():
    # ------------------------------
    # ------------ MAPS ------------
    # ------------------------------

    # Map containing all the Titles, descriptions and image of the banners. Title and description must be seperated with a comma
    var BannerMap : [string]texture = map:
        "Bee,A flying bee." => icons.bee,
        "Bone,A bone." => icons.bone,
        "Explosion,A large explosion."=> icons.explosion,
        "Cat,Scared cat!"=> icons.cat,
        "Compass,Cool compass."=> icons.compass,
        "Fncs,FNCS Logo."=> icons.fncs,
        "Geralt,Geralt of rivia."=> icons.geralt,
        "Gingy,Gingerbread!"=> icons.gingy,
        "Grenade,The old grenade icon."=> icons.grenade,
        "Gwen,Gwen from spider."=> icons.gwen,
        "Khaby,Khaby Lame from tiktok."=> icons.khaby,
        "Meteor,Falling meteor."=> icons.meteor_face,
        "Peanut,A nice peanut!"=> icons.peanut,
        "Pewdiepie,Pewdiepie logo!"=> icons.pewdiepie,
        "Pizza,A nice pizza!"=> icons.pizza,
        "Prowler,Prowler from spiderman."=> icons.prowler,
        "Slapjuice,A nice cold slapjuice."=> icons.slapjuice,
        "Snail, Slimey snail."=> icons.snail,
        "Snake,Slithery Snake."=> icons.snake,
        "Spiderman,Spiderman from spiderman"=> icons.spiderman,
        "Tank,Large tank."=> icons.tank,
        "Tomato, Healthy tomato."=> icons.tomato,
        "Trophy,Shiny trophy."=> icons.trophy,
        "Unreal engine,A cool game engine!"=> icons.ue,
        "Whirl,Beatiful whirl!"=> icons.whirl,
        "War helmet,Cool war helmet!"=> icons.war_helmet

    var PeopleBanner :[string]texture = map:
        "Geralt,Geralt of rivia."=> icons.geralt,
        "Gingy,Gingerbread!"=> icons.gingy,
        "Gwen,Gwen from spider."=> icons.gwen,
        "Khaby,Khaby Lame from tiktok."=> icons.khaby,
        "Pewdiepie,Pewdiepie logo!"=> icons.pewdiepie,
        "Prowler,Prowler from spiderman."=> icons.prowler,
        "Spiderman,Spiderman from spiderman"=> icons.spiderman

    var FoodBanners :[string]texture = map:
        "Peanut,A nice peanut!"=> icons.peanut,
        "Pizza,A nice pizza!"=> icons.pizza,
        "Slapjuice,A nice cold slapjuice."=> icons.slapjuice,
        "Tomato, Healthy tomato."=> icons.tomato

    var OtherBanners :[string]texture = map:
        "Explosion,A large explosion."=> icons.explosion,
        "Compass,Cool compass."=> icons.compass,
        "Fncs,FNCS Logo."=> icons.fncs,
        "Grenade,The old grenade icon."=> icons.grenade,
        "Tank,Large tank."=> icons.tank,
        "Trophy,Shiny trophy."=> icons.trophy,
        "Unreal engine,A cool game engine!"=> icons.ue,
        "Whirl,Beatiful whirl!"=> icons.whirl,
        "War helmet,Cool war helmet!"=> icons.war_helmet,
        "Bee,A flying bee." => icons.bee,
        "Cat,Scared cat!"=> icons.cat,
        "Snail, Slimey snail."=> icons.snail,
        "Snake,Slithery Snake."=> icons.snake

    var RowsAndColsWithBtn : [button_quiet]tuple([]stack_box, string) = map{}



    # Map that contains all the 'equip' buttons & and the banner assigned to it.
    var EquipMap : [button_loud]texture = map{}
    
    # Map that contains all the 'preview' buttons & and the banner assigned to it.
    var PreviewMap : [button_loud]texture = map{}

    # Map that contains all the 'select' buttons & and the card assigned to it.
    var CardMap : [button_quiet]overlay = map{}

    # Useless map, too lazy to remove it though + it doesnt work without it....
    var OverlayDescMap : [string]overlay = map{}
    # ------------------------------
    # ------------ ARRAY -----------
    # ------------------------------
    var AllStackBoxes : []stack_box = array{}
    var CurrentDislayedStackboxes : []stack_box = array{}
    var AllSections : []tuple([string]texture, string) = array{}

    # This is for the amount of rows and makes the scroll sytem even more dynamic (hard to explain)
    var AllIndexes : []int = array{}

    # ------------------------------
    # ------------ LOGIC -----------
    # ------------------------------

    var Called : logic = false
    var NeedToBreak : logic = false
    var PlayerUIInfo : ?ui_info = false

    # -----------------------
    # --------- INT ---------
    # -----------------------

    var AmountOfCols : int = 4
    var AmountOfRowsShown : int = 3
    # ---------------------------------
    # --------- OBJECTS --------------
    # ---------------------------------
    
    BannerUIObj : banner_ui = banner_ui{CurrentBannerImg := img.NO_BANNER, ExitBtn := button_loud{}}

    # ---------------------------------
    # --------- UI COMPONENTS ---------
    # ---------------------------------

    UpBtn : button_loud = button_loud{}
    DownBtn : button_loud = button_loud{}

    CloseUIBtn : button_loud= button_loud{}

    var CurrentCard : overlay = overlay{}

    var ExitBtn : button_loud = button_loud{}

    var MainStackBoxAlignment : horizontal_alignment = horizontal_alignment.Center

    PageTitleBlock : text_block = text_block{DefaultTextColor := White}

    LineTextureBlock : texture_block = texture_block:
        DefaultImage := img.gray_line
        DefaultDesiredSize := vector2{X:= 978.299683, Y:= 2.0}

    # ----------------------------
    # --------- MESSAGES ---------
    # ----------------------------

    CloseButtonMsg<localizes>:message= "❌" 
    UpButtonMsg<localizes>:message = "↑"
    DownButtonMsg<localizes>:message = "↓"
    EnterButtonMsg<localizes>:message = "enter"

    S2M<localizes>(S : string) : message = "{S}"

    #        functions below
    # -----------------------------
    
    # Constructor like function, needs to get fired when object is created of this class.
    Init():void=
        CloseUIBtn.SetText(CloseButtonMsg)
        UpBtn.SetText(UpButtonMsg)
        DownBtn.SetText(DownButtonMsg)
        set BannerUIObj.ExitBtn = ExitBtn
        BannerUIObj.Init()
        set AllSections = array:
            (BannerMap, "All banners")
            (PeopleBanner, "People banners")
            (FoodBanners, "Food banners")
            (OtherBanners, "Other")
        Print("Initialized.")


    # Creates banner UI
    CreateBannerUI(Agent : agent):void=
        BannerUIObj.AssignMainBannerUI(Agent)

    # Creates the customization UI
    UICustomizationCreate(Agent : agent)<suspends>:void=
        BannerUIObj.CreateCustomizationUI(Agent)
        BannerUIObj.RemovePreviewUI(Agent)

    # Through this function you enter preview mode
    EnterPreviewMode(WM : widget_message):void=
        if(ClickedBannerImg := PreviewMap[WM.Source]):
            BannerUIObj.PreviewBannerTextureBlock.SetImage(ClickedBannerImg)
            if(PlayerCanvas := PlayerUIInfo?.Canvas):
                PlayerCanvas.SetVisibility(widget_visibility.Collapsed)
            BannerUIObj.CreatePreviewUI(WM.Player)

    # Fires when you click the equip button on a banner card.
    EquipImg(WM : widget_message):void=
        # Get the image through the button associated to it and then set that as the banner.
        if(ClickedBannerImg := EquipMap[WM.Source]):
            BannerUIObj.ChangeImg(ClickedBannerImg, true)

    # Exits the preview mode
    ExitPreviewMode(WM : widget_message):void=
        BannerUIObj.RemovePreviewUI(WM.Player)
        if(PlayerCanvas := PlayerUIInfo?.Canvas):
            PlayerCanvas.SetVisibility(widget_visibility.Visible)
            

    # Adding main UI
    AssignMainUI(Agent : agent):void=
        if(PlayerUI := GetPlayerUI[player[Agent]], MainInventoryCanvas := PlayerUIInfo?.Canvas):
            PlayerUI.AddWidget(MainInventoryCanvas, player_ui_slot{InputMode := ui_input_mode.All})
            BannerUIObj.HideMainBannerUI(Agent)

    # Removing main UI
    RemoveMainUI(WM : widget_message):void=
        if(PlayerUI := GetPlayerUI[player[WM.Player]], PlayerCanvas := PlayerUIInfo?):
            PlayerUI.RemoveWidget(PlayerCanvas.Canvas)
            BannerUIObj.ShowMainBannerUI(WM.Player)

    # Seperates a string into 2 strings, with the seperator being a comma.
    (InString : string).SeperateString():tuple(string,string)=
        var CommaReached : logic = false
        var Word1 : string = ""
        var Word2 : string = ""
        for(Letter : InString):
            if("{Letter}" = ","):
                set CommaReached = true
                Print("Comma reached")
            else:
                if(not CommaReached?):
                    set Word1 += "{Letter}"
                else:
                    set Word2 += "{Letter}" 
        return (Word1, Word2)
        
    CreateTopImgButtons():stack_box=
        # Stackboxes I'm adding to do
        MyStackBox := stack_box{Orientation := orientation.Horizontal}
        # Looping through the sections and assigning a button to each section and then button those buttons in the stackbox
        for(ImgBlock -> SingularBannerMap : AllSections):
            Print("Loopin'")
            InRowsAndCols := CreateColsAndRows(SingularBannerMap(0))
            MyButton := button_quiet{}
            MyButton.SetText(S2M("{SingularBannerMap(1)}"))
                MyStackBoxSlot := stack_box_slot:
                    Widget := MyButton, Padding := margin{Left := 15.0, Right := 15.0}
                MyStackBox.AddWidget(MyStackBoxSlot)
            MyButton.OnClick().Subscribe(OnTopButtonClicked)
            if(set RowsAndColsWithBtn[MyButton] = (InRowsAndCols, SingularBannerMap(1))){}
        return MyStackBox


    OnTopButtonClicked(WM : widget_message):void=
        if(InStackBoxAndTitle := RowsAndColsWithBtn[WM.Source]):
            Print("Top button Clicked.")
            if:
                MainStackBox := PlayerUIInfo?.MainStackBox
            then:
                # Collapsing the previous stackboxes
                for(StackBoxIndex : AllStackBoxes):
                    StackBoxIndex.SetVisibility(widget_visibility.Collapsed)
                    Print("Collapsing all")
                # Getting the stackbox in the tuple
                set AllStackBoxes = InStackBoxAndTitle(0)
                PageTitleBlock.SetText(S2M("{InStackBoxAndTitle(1)}")) # Getting the title in the tuple
                # Resetting the currently displayed stackboxes
                set CurrentDislayedStackboxes = array{}
                # Looping through the new ones, making them visible and then adding them to the currently displayed stackboxes array and creating stackbox slots and adding them to the main stackbox.
                for(ArrayIndex -> StackBoxIndex : InStackBoxAndTitle(0)):
                    if(ArrayIndex < AmountOfRowsShown):
                        Print("Adding stackboxes to thje screen!")
                        set CurrentDislayedStackboxes += array{StackBoxIndex}
                        StackBoxIndex.SetVisibility(widget_visibility.Visible)
                        MySlot := stack_box_slot:
                            Widget := StackBoxIndex
                            Padding := margin{Top := 5.0}
                            HorizontalAlignment := horizontal_alignment.Fill
                        MainStackBox.AddWidget(MySlot)
                ResetIndexes()
                CurrentCard.SetVisibility(widget_visibility.Collapsed)
                CheckScrollbar()

    # This function creates the first 3 rows and columns and sets everything up for the scrolling system
    CreateColsAndRows(InMap : [string]texture):[]stack_box=
                set OverlayDescMap = map{}
        var StackBoxes : []stack_box = array{} # adding all the stackboxes in here
        var RowNumber : int = 1
        if(AmountOfRows := Ceil(InMap.Length / AmountOfCols)): # getting the amount of rows by dividing the banner map length by the amount of cols and then ceiling it
            Print("Amount of rows {AmountOfRows}")
            var Iterations : int  = 0  # just a var to track the iterations of the outer for loop
            for(I := 1..AmountOfRows):
                set Iterations += 1
                MyStackBox := stack_box . Orientation := orientation.Horizontal # setting up a stackbox so we can add stuff to it later

                # This stack box slot is basically for the row numbers
                RowNumberSlot := stack_box_slot:
                    Widget := text_block: 
                        DefaultText := S2M("{RowNumber} ·") # I i do +1 because i havent added the current stack box yet, so i need to add 1 so it is right on the same amount
                        DefaultTextColor := White
                    VerticalAlignment := vertical_alignment.Center
                    # Padding := margin{Left := 15.0}
                MyStackBox.AddWidget(RowNumberSlot)
                var OverlayCreatorObjs : []single_inventory_item_maker = array{} #an array full of overlay creator objects

                for(Desc -> Banner : InMap): # looping through all the banners and descriptions
                    if(not OverlayDescMap[Desc]): # checks if the overlay already exists.
                        if(not NeedToBreak?): # checking if we need to be break with a logic, since theres no break keyword in verse
                            OverlayObj := single_inventory_item_maker{BannerImage := Banner, BannerDesc := Desc} #creating an instnace of the class
                            set OverlayCreatorObjs += array{OverlayObj} # pushing it in the array
                            if(OverlayCreatorObjs.Length = AmountOfCols) then set NeedToBreak = true
                set NeedToBreak = false # resetting the value
                for(Instance : OverlayCreatorObjs): # loopinh through all the objects i created in the previous loop
                    BannerDescAndTitle := Instance.BannerDesc # getting the description of the obj / overlay
                    # Buttons
                    SelectButton := button_quiet{}
                    PreviewBtn := button_loud{}
                    EquipBtn := button_loud{}
                    InventoryItem := Instance.MakeInventoryItem(SelectButton) # getting the InventoryItem of the obj 
                    # Seperating the title and the description and saving them in seperate variables
                    SeperatedStrings := BannerDescAndTitle.SeperateString() 
                    Title := SeperatedStrings(0)
                    BannerDesc := SeperatedStrings(1)
                    PreviewBtn.OnClick().Subscribe(EnterPreviewMode)
                    ExitBtn.OnClick().Subscribe(ExitPreviewMode)
                    # this function will basically display the card of the banner
                    SelectButton.OnClick().Subscribe(ShowCard) 
                    CardObj := card_maker{Title := Title, Description := BannerDesc, BannerImg := Instance.BannerImage}
                    EquipBtn.OnClick().Subscribe(EquipImg)
                    CardObj.Init()
                    CardOverlay := CardObj.GetCardOverlay(PreviewBtn,EquipBtn)
                    MyStackBoxSlot := stack_box_slot: # creating a stack box slot
                        Widget := InventoryItem
                        Padding := margin{Right := 10.0, Left := 10.0}
                        HorizontalAlignment := horizontal_alignment.Left
                    MyStackBox.AddWidget(MyStackBoxSlot) # adding the slot to the created stackbox on to
                    # Saving each EquipBtn & PreviewBtn in a map as key, and img as value
                    if(set EquipMap[EquipBtn] = Instance.BannerImage){}
                    if(set PreviewMap[PreviewBtn] = Instance.BannerImage){}
                    # putting it in my map (I dont use this map anywhere, it is just good for checking if things already exist.)
                    if(set OverlayDescMap[BannerDescAndTitle] = InventoryItem){}
                    # Putting my card in the map and putting it in a map with the Select button as key of this iteration
                    if(set CardMap[SelectButton] = CardOverlay){} # putting it in my map
                set RowNumber += 1
                set StackBoxes += array{MyStackBox}
        return StackBoxes

    # This shows the card / hides the card
    ShowCard(WM : widget_message):void=
        # Hide current card so theres not multiple cards being displayed
        CurrentCard.SetVisibility(widget_visibility.Collapsed)
        # Get the card through the map by getting the button associated with it and then making it visible
        if(CardOverlay := CardMap[WM.Source]):
            CardOverlay.SetVisibility(widget_visibility.Visible)
            set CurrentCard = CardOverlay

    MoveUp(WM : widget_message):void=
        # calls the Scroll function and gives 'false', because we don't want to scroll down.
        Scroll(WM.Player, false)

    MoveDown(WM : widget_message):void=
        # calls the Scroll function and gives 'true', because we do want to scroll down.
        Scroll(WM.Player, true)
        


    # Scrolls down the overlays.
    Scroll(Agent : agent, Down : logic):void=
        if:
            MainStackBox := PlayerUIInfo?.MainStackBox
        then:
            # Collapsing the previous stackboxes
            for(StackBoxIndex : AllIndexes):
                if(AnOldStackBox := AllStackBoxes[StackBoxIndex]):
                    AnOldStackBox.SetVisibility(widget_visibility.Collapsed)
            # If the user wants to scroll down, we increment all the items, otherwise, we decrement it.
            if(Down?):
                for(ArrayIndex -> StackBoxIndex : AllIndexes):
                    if(set AllIndexes[ArrayIndex] = StackBoxIndex + 1){}
            else:
                for(ArrayIndex -> StackBoxIndex : AllIndexes):
                    if(set AllIndexes[ArrayIndex] = StackBoxIndex - 1){}
            # Resetting the currently displayed stackboxes array by emptying it
            set CurrentDislayedStackboxes = array{}
            # Looping through the new ones, making them visible and then adding them to the currently displayed stackboxes array and creating stackbox slots and adding them to the main stackbox.
            for(ArrayIndex -> StackBoxIndex : AllIndexes):
                if(CurrentStackBox := AllStackBoxes[StackBoxIndex]):
                    set CurrentDislayedStackboxes += array{CurrentStackBox}
                    CurrentStackBox.SetVisibility(widget_visibility.Visible)
                    MySlot := stack_box_slot:
                        Widget := CurrentStackBox
                        Padding := margin{Top := 5.0}
                        HorizontalAlignment := horizontal_alignment.Fill
                    MainStackBox.AddWidget(MySlot)
            CheckScrollbar()

    # Checks scrollbar status
    CheckScrollbar():void=
        # This means theres nothing above it, so we disable it
        if(AllIndexes[0] = 0):
            UpBtn.SetEnabled(false)
        # This means theres something above it, so we enable it
        if(AllIndexes[0] > 0):
            UpBtn.SetEnabled(true)
        # This means theres nothing below it, so we disable it
        if(AllIndexes[AllIndexes.Length - 1]  >= AllStackBoxes.Length - 1):
            DownBtn.SetEnabled(false)
        # This means theres something below it, so we enable it
        if(AllIndexes[AllIndexes.Length - 1] < AllStackBoxes.Length - 1):
            DownBtn.SetEnabled(true)


    # Resetting the indexes of the AllIndexes array
    ResetIndexes():void=
        set AllIndexes
        for(I := 0..AmountOfRowsShown - 1):
            set AllIndexes += array{I}

    # Making the main canvas
    MakeMainCanvas(Agent : agent):canvas=
        ResetIndexes()
        CheckScrollbar()
        UIInfo := ui_info{} # Create object.
        # Listening for button click events
        CloseUIBtn.OnClick().Subscribe(RemoveMainUI)
        UpBtn.OnClick().Subscribe(MoveUp)
        DownBtn.OnClick().Subscribe(MoveDown)

        RowsAndColsStackBox := stack_box:
            Orientation := orientation.Vertical
        ChildOverlay := overlay:
            Slots := array:
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := Black
                        DefaultDesiredSize := vector2{X:= 1151.01001, Y:= 926.663147}
                overlay_slot:
                    Widget := UpBtn
                    HorizontalAlignment := horizontal_alignment.Right
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Bottom := 90.0, Right := 25.0}
                overlay_slot:
                    Widget := DownBtn
                    HorizontalAlignment := horizontal_alignment.Right
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Top := 15.0, Right := 25.0}
                overlay_slot:
                    Widget := RowsAndColsStackBox
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Left := 50.0, Top := 195.0}
                overlay_slot:
                    Widget:= CreateTopImgButtons()
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top := 25.0, Left := 50.0}
                overlay_slot:
                    Widget:= PageTitleBlock
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top := 115.0, Left := 85.0}
                overlay_slot:
                    Widget := LineTextureBlock
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top := 105.0, Left := 50.0}
                overlay_slot:
                    Widget := texture_block:
                        DefaultImage := img.gray_line
                        DefaultDesiredSize := vector2{X:= 978.299683, Y:= 2.0}
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top := 165.0, Left := 50.0}
        # Stackboxes := CreateColsAndRows(BannerMap) # Getting all the Cols And rows (Only the first 3)
        var Iterations : int = 0 # For debugging purposes
        var InStackBox : []stack_box =array{}

        for(SingularStackBox : RowsAndColsWithBtn):
            if(Iterations = 0):
                set InStackBox = SingularStackBox(0)
                PageTitleBlock.SetText(S2M("{SingularStackBox(1)}"))
                set Iterations += 1
                Print("Hey~!")
        set AllStackBoxes = InStackBox
        for(Index -> Stackbox : InStackBox):
            if(Index < AmountOfRowsShown):
                set Iterations += 1
                MyOverlaySlot := stack_box_slot:
                    Widget := Stackbox
                    Padding := margin{Top := 5.0}
                    HorizontalAlignment := horizontal_alignment.Fill
                RowsAndColsStackBox.AddWidget(MyOverlaySlot)
                Print("Adding to the overlay, Iteration: {Iterations}")

        MainOverlay := overlay:
            Slots := array:
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := Gray
                        DefaultOpacity := 0.9
                    HorizontalAlignment := horizontal_alignment.Fill
                    VerticalAlignment := vertical_alignment.Fill
                    
                overlay_slot:
                    Widget := ChildOverlay
                    HorizontalAlignment := horizontal_alignment.Left
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Left := 200.0, Top := 25.0}
                overlay_slot:
                    Widget := CloseUIBtn
                    HorizontalAlignment := horizontal_alignment.Right
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top := 10.0, Right := 10.0}
        MyCanvas := canvas:
            Slots := array:
                canvas_slot:
                    Widget := MainOverlay
                    Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 1.0, Y:= 1.0}}
        # Here i create all the cards, but then collapse them, so you wont see them. That way, all we have to do is hide them / make them visible again which in turn makes the UI much more responsive.
        for(Button -> Overlay : CardMap):
            Overlay.SetVisibility(widget_visibility.Collapsed)
            MyCanvasSlot := canvas_slot:
                Widget := Overlay
                Anchors := anchors{Minimum := vector2{X:= 1.0, Y:= 0.5}, Maximum := vector2{X:= 1.0, Y:= 0.5}}
                Alignment := vector2{X := 1.215596, Y:= 0.495496}
            MyCanvas.AddWidget(MyCanvasSlot)
        set UIInfo.Canvas = MyCanvas
        set UIInfo.MainStackBox = RowsAndColsStackBox
        set PlayerUIInfo = option{UIInfo}
        CheckScrollbar()
        return MyCanvas

