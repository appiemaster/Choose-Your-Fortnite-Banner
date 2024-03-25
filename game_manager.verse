

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

game_manager := class(creative_device):

    var InventoryMap : [agent]Inventory = map{}

    @editable
    SpawnersArray : []player_spawner_device = array{}

    @editable
    ButtonUI : button_device = button_device{}

    @editable
    CustomizeUIBtn : button_device = button_device{}

    @editable:
        ToolTip := ColMessage
    var AmountOfCols : type{_X:int where 1 <= _X, _X <= 5} = 4

    @editable:
        ToolTip := RowMessage
    var AmountOfRows : type{_X:int where 1 <= _X, _X <= 5} = 3
    
    SomeMSg<localizes>:message = "With this you can choose where the items will be aligned. Recommended is left, most of the time."
    RowMessage<localizes>:message = "Select the amount of rows. 3 is recommended."
    ColMessage<localizes>:message = "Select the amount of columns. 4 is recommended."
    @editable:
        ToolTip := SomeMSg
    ItemsPos: horizontal_alignment = horizontal_alignment.Left

    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        InitSpawners()
        spawn{AwaitPlayerLeft()}
        spawn{AwaitUIButtonPress()}
        spawn{AwaitCustomizeUIBtnPress()}

    InitSpawners():void=
        for(Spawner : SpawnersArray):
            spawn{Spawner.AwaitPlayerSpawn()}

    AwaitPlayerLeft()<suspends>:void=
        loop:
            Player := GetPlayspace().PlayerRemovedEvent().Await()
            OnPlayerRemoved(Player)

    AwaitUIButtonPress()<suspends>:void=
        loop:
            Agent := ButtonUI.InteractedWithEvent.Await()
            if(InvPlayer := InventoryMap[Agent]):
                InvPlayer.AssignMainUI(Agent)

    AwaitCustomizeUIBtnPress()<suspends>:void=
        loop:
            Agent := CustomizeUIBtn.InteractedWithEvent.Await()
            if(InvPlayer := InventoryMap[Agent]):
                InvPlayer.UICustomizationCreate(Agent)

    (Spawner : player_spawner_device).AwaitPlayerSpawn()<suspends>:void=
        loop:
            Agent := Spawner.SpawnedEvent.Await()
            InitAgents(Agent)

    InitAgents(Agent : agent):void=
        if(not InventoryMap[Agent]):
            InventoryObj := Inventory{AmountOfCols := AmountOfCols,MainStackBoxAlignment := horizontal_alignment.Center, AmountOfRowsShown :=AmountOfRows}
            InventoryObj.Init()
            InventoryObj.MakeMainCanvas(Agent)
            InventoryObj.CreateBannerUI(Agent)
            if(set InventoryMap[Agent] = InventoryObj){} 
            Print("set")

    OnPlayerRemoved(Player : player): void=
        if(RemoveCustomPlayer:= InventoryMap[Player]):
                var TempAllPlayersMap: [agent] Inventory = map{}
                for (Key -> Value: InventoryMap, Key <> Player):
                    set  TempAllPlayersMap = ConcatenateMaps(TempAllPlayersMap, map{Key => Value})
                set InventoryMap = TempAllPlayersMap
