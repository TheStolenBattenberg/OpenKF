///ItemDatabaseCreateDefault();

//Enum of ItemIDs
enum ItemID
{
    Dagger            = 0,
    ShortSword        = 1,
    KnightSword       = 2,
    MorningStar       = 3,
    BattleHammer      = 4,
    BastardSword      = 5,
    CrescentAxe       = 6,
    FlameSword        = 9,
    Shiden            = 10,
    Spider            = 11,
    IceBlade          = 12,
    SeathsSword       = 13,
    MoonlightSword    = 14,
    DarkSlayer        = 15,
    Bow               = 16,
    Arbalest          = 17,
    IronMask          = 21,
    KnightHelm        = 22,
    GreatHelm         = 23,
    BloodCrown        = 24,
    LightningHelm     = 25,
    SeathsHelm        = 26,
    BreastPlate       = 28,
    KnightPlate       = 29,
    IceArmour         = 30,
    DarkArmour        = 31,
    SeathsArmour      = 32,
    LeatherShield     = 34,
    LargeShield       = 35,
    MoonGuard         = 36,
    CrystalGuard      = 37,
    SkullShield       = 38,
    SeathsShield      = 39,
    IronGloves        = 41,
    StoneHands        = 42,
    SilverArms        = 43,
    DemonsHands       = 44,
    RuinousGloves     = 45,
    IronBoots         = 47,
    LegGuarders       = 48,
    SilverBoots       = 49,
    DeathWalkers      = 50,
    RuinousBoots      = 51,
    ScorpionsBracelet = 53,
    SeathsTear        = 54,
    SeathsBracelet    = 55,
    EarthRing         = 56,
    PsycprosCollar    = 57,
    AmuletOfMist      = 58,
    LightwaveRing     = 59,
    PiratesMap        = 67,
    MinersMap         = 68,
    NecronsMap        = 69,
    GoldCoin          = 70,
    BloodStone        = 71,
    MoonStone         = 72,
    Verdite           = 73,
    EarthHerb         = 74,
    Antidote          = 75,
    DragonCrystal     = 76,
    BluePotion        = 77,
    RedPotion         = 78,
    GreenPotion       = 79,
    GoldPotion        = 80,
    CrystalFlask      = 82,
    FigureOfSeath     = 83,
    PhantomRod        = 84,
    TruthGlass        = 85,
    SeathsPlume       = 86,
    DemonsPick        = 87,
    HarvinesFlute     = 88,
    GroundBell        = 89,
    FireCrystal       = 90,
    WaterCrystal      = 91,
    EarthCrystal      = 92,
    WindCrystal       = 93,
    LightCrystal      = 94,
    DarkCrystal       = 95,
    Crystal           = 96,
    CrystalShard      = 97,
    ElvesKey          = 99,
    PiratesKey        = 100,
    SkullKey          = 101,
    JailKey           = 102,
    RhombusKey        = 103,
    HarvinesKey       = 104,
    DragonStone       = 105,
    MagiciansKey      = 106,
    SilverKey         = 107,
    GoldKey           = 108,
    ShrineKey         = 109,
    MoonGate          = 111,
    StarGate          = 112,
    SunGate           = 113,
    MoonKey           = 114,
    StarKey           = 115,
    SunKey            = 116,
    Arrow             = 117,
    ElvesBolt         = 118,
}

//Enum of ItemTypes
enum ItemType
{
    Weapon,
    Helmet,
    Chest,
    Shield,
    Gloves,
    Boots,
    Accessory,
    
    Map,
    Recovery,
    Buff,
    SpecialItem,
    MagicCrystal,
    Key,
    Gate,
    Ammo
}

//Create Item Class Database
var arrItemDatabase = ItemDatabaseCreate();
    //
    // WEAPONS
    //
    arrItemDatabase[? ItemID.Dagger]         = ItemClass(ItemType.Weapon, "ITEM_0"  , 0  , null, 100);
    arrItemDatabase[? ItemID.ShortSword]     = ItemClass(ItemType.Weapon, "ITEM_1"  , 1  , null, 320);
    arrItemDatabase[? ItemID.KnightSword]    = ItemClass(ItemType.Weapon, "ITEM_2"  , 2  , null, 650);
    arrItemDatabase[? ItemID.MorningStar]    = ItemClass(ItemType.Weapon, "ITEM_3"  , 3  , null, 450);
    arrItemDatabase[? ItemID.BattleHammer]   = ItemClass(ItemType.Weapon, "ITEM_4"  , 4  , null, 1100);
    arrItemDatabase[? ItemID.BastardSword]   = ItemClass(ItemType.Weapon, "ITEM_5"  , 5  , null, 950);
    arrItemDatabase[? ItemID.CrescentAxe]    = ItemClass(ItemType.Weapon, "ITEM_6"  , 6  , null, 1450);
    arrItemDatabase[? ItemID.FlameSword]     = ItemClass(ItemType.Weapon, "ITEM_9"  , 7  , null, 2500);
    arrItemDatabase[? ItemID.Shiden]         = ItemClass(ItemType.Weapon, "ITEM_10" , 8  , null, 3000);
    arrItemDatabase[? ItemID.Spider]         = ItemClass(ItemType.Weapon, "ITEM_11" , 9  , null, 2500);
    arrItemDatabase[? ItemID.IceBlade]       = ItemClass(ItemType.Weapon, "ITEM_12" , 10 , null, 2500);
    arrItemDatabase[? ItemID.SeathsSword]    = ItemClass(ItemType.Weapon, "ITEM_13" , 11 , null, 5000);
    arrItemDatabase[? ItemID.MoonlightSword] = ItemClass(ItemType.Weapon, "ITEM_14" , 12 , null, 9000);
    arrItemDatabase[? ItemID.DarkSlayer]     = ItemClass(ItemType.Weapon, "ITEM_15" , 13 , null, 9000);
    arrItemDatabase[? ItemID.Bow]            = ItemClass(ItemType.Weapon, "ITEM_16" , 14 , null, 1250);
    arrItemDatabase[? ItemID.Arbalest]       = ItemClass(ItemType.Weapon, "ITEM_17" , 15 , null, 2000);
    
    //
    // HELMETS
    //
    arrItemDatabase[? ItemID.IronMask]      = ItemClass(ItemType.Helmet, "ITEM_21" , 16 , null, 150);
    arrItemDatabase[? ItemID.KnightHelm]    = ItemClass(ItemType.Helmet, "ITEM_22" , 17 , null, 600);
    arrItemDatabase[? ItemID.GreatHelm]     = ItemClass(ItemType.Helmet, "ITEM_23" , 18 , null, 1200);
    arrItemDatabase[? ItemID.BloodCrown]    = ItemClass(ItemType.Helmet, "ITEM_24" , 19 , null, 2500);
    arrItemDatabase[? ItemID.LightningHelm] = ItemClass(ItemType.Helmet, "ITEM_25" , 20 , null, 2500);
    arrItemDatabase[? ItemID.SeathsHelm]    = ItemClass(ItemType.Helmet, "ITEM_26" , 21 , null, 5000);

    //
    // ARMOURS
    //
    arrItemDatabase[? ItemID.BreastPlate]  = ItemClass(ItemType.Chest, "ITEM_28" , 22 , null, 300);
    arrItemDatabase[? ItemID.KnightPlate]  = ItemClass(ItemType.Chest, "ITEM_29" , 23 , null, 900);
    arrItemDatabase[? ItemID.IceArmour]    = ItemClass(ItemType.Chest, "ITEM_30" , 24 , null, 2500);
    arrItemDatabase[? ItemID.DarkArmour]   = ItemClass(ItemType.Chest, "ITEM_31" , 25 , null, 3000);
    arrItemDatabase[? ItemID.SeathsArmour] = ItemClass(ItemType.Chest, "ITEM_32" , 26 , null, 8000);

    //
    // SHIELDS
    //
    arrItemDatabase[? ItemID.LeatherShield] = ItemClass(ItemType.Shield, "ITEM_34" , 27 , null, 450);
    arrItemDatabase[? ItemID.LargeShield]   = ItemClass(ItemType.Shield, "ITEM_35" , 28 , null, 1200);
    arrItemDatabase[? ItemID.MoonGuard]     = ItemClass(ItemType.Shield, "ITEM_36" , 29 , null, 4000);
    arrItemDatabase[? ItemID.CrystalGuard]  = ItemClass(ItemType.Shield, "ITEM_37" , 30 , null, 3000);
    arrItemDatabase[? ItemID.SkullShield]   = ItemClass(ItemType.Shield, "ITEM_38" , 31 , null, 6500);
    arrItemDatabase[? ItemID.SeathsShield]  = ItemClass(ItemType.Shield, "ITEM_39" , 32 , null, 8500);

    //
    // GLOVES
    //
    arrItemDatabase[? ItemID.IronGloves]    = ItemClass(ItemType.Gloves, "ITEM_41" , 33 , null, 300);
    arrItemDatabase[? ItemID.StoneHands]    = ItemClass(ItemType.Gloves, "ITEM_42" , 34 , null, 1200);
    arrItemDatabase[? ItemID.SilverArms]    = ItemClass(ItemType.Gloves, "ITEM_43" , 35 , null, 2500);
    arrItemDatabase[? ItemID.DemonsHands]   = ItemClass(ItemType.Gloves, "ITEM_44" , 36 , null, 3200);
    arrItemDatabase[? ItemID.RuinousGloves] = ItemClass(ItemType.Gloves, "ITEM_45" , 37 , null, 8500);
    
    //
    // BOOTS
    //
    arrItemDatabase[? ItemID.IronBoots]    = ItemClass(ItemType.Boots, "ITEM_47" , 38 , null, 400);
    arrItemDatabase[? ItemID.LegGuarders]  = ItemClass(ItemType.Boots, "ITEM_48" , 39 , null, 1000);
    arrItemDatabase[? ItemID.SilverBoots]  = ItemClass(ItemType.Boots, "ITEM_49" , 40 , null, 2000);
    arrItemDatabase[? ItemID.DeathWalkers] = ItemClass(ItemType.Boots, "ITEM_50" , 41 , null, 3200);
    arrItemDatabase[? ItemID.RuinousBoots] = ItemClass(ItemType.Boots, "ITEM_51" , 42 , null, 8500);
    
    //
    // ACCESSORIES
    //
    arrItemDatabase[? ItemID.ScorpionsBracelet] = ItemClass(ItemType.Accessory, "ITEM_53" , 43 , null, 1250);
    arrItemDatabase[? ItemID.SeathsTear]        = ItemClass(ItemType.Accessory, "ITEM_54" , 44 , null, 3000);
    arrItemDatabase[? ItemID.SeathsBracelet]    = ItemClass(ItemType.Accessory, "ITEM_55" , 45 , null, 3000);
    arrItemDatabase[? ItemID.EarthRing]         = ItemClass(ItemType.Accessory, "ITEM_56" , 46 , null, 5000); 
    arrItemDatabase[? ItemID.PsycprosCollar]    = ItemClass(ItemType.Accessory, "ITEM_57" , 47 , null, 7500);
    arrItemDatabase[? ItemID.AmuletOfMist]      = ItemClass(ItemType.Accessory, "ITEM_58" , 48 , null, 1250);
    arrItemDatabase[? ItemID.LightwaveRing]     = ItemClass(ItemType.Accessory, "ITEM_59" , 49 , null, 5000);
    
    //
    // (ITEM) Maps
    //
    arrItemDatabase[? ItemID.PiratesMap] = ItemClass(ItemType.Map, "ITEM_67" , 50 , null, 1250);
    arrItemDatabase[? ItemID.MinersMap]  = ItemClass(ItemType.Map, "ITEM_68" , 51 , null, 2500);
    arrItemDatabase[? ItemID.NecronsMap] = ItemClass(ItemType.Map, "ITEM_69" , 52 , null, 5000);
    
    //
    // (ITEM) Recovery
    //
    arrItemDatabase[? ItemID.BloodStone]    = ItemClass(ItemType.Recovery, "ITEM_71" , 53 , null, 250);
    arrItemDatabase[? ItemID.MoonStone]     = ItemClass(ItemType.Recovery, "ITEM_72" , 54 , null, 650);    
    arrItemDatabase[? ItemID.EarthHerb]     = ItemClass(ItemType.Recovery, "ITEM_74" , 56 , null, 30);
    arrItemDatabase[? ItemID.Antidote]      = ItemClass(ItemType.Recovery, "ITEM_75" , 57 , null, 60);
    arrItemDatabase[? ItemID.DragonCrystal] = ItemClass(ItemType.Recovery, "ITEM_76" , 58 , null, 1200);
    arrItemDatabase[? ItemID.BluePotion]    = ItemClass(ItemType.Recovery, "ITEM_77" , 59 , null, 900);
    arrItemDatabase[? ItemID.RedPotion]     = ItemClass(ItemType.Recovery, "ITEM_78" , 60 , null, 900);
    arrItemDatabase[? ItemID.GreenPotion]   = ItemClass(ItemType.Recovery, "ITEM_79" , 61 , null, 900);
    arrItemDatabase[? ItemID.GoldPotion]    = ItemClass(ItemType.Recovery, "ITEM_80" , 62 , null, 900);
    
    //
    // (ITEM) Special Item
    //
    arrItemDatabase[? ItemID.CrystalFlask]  = ItemClass(ItemType.SpecialItem, "ITEM_82" , 63, null, 750);
    arrItemDatabase[? ItemID.FigureOfSeath] = ItemClass(ItemType.SpecialItem, "ITEM_83", 64, null, 1250);
    arrItemDatabase[? ItemID.TruthGlass]    = ItemClass(ItemType.SpecialItem, "ITEM_85" , 66, null, 4000);
    arrItemDatabase[? ItemID.HarvinesFlute] = ItemClass(ItemType.SpecialItem, "ITEM_88" , 69, null, 7500);
    arrItemDatabase[? ItemID.GroundBell]    = ItemClass(ItemType.SpecialItem, "ITEM_89" , 70, null, 3000);
    arrItemDatabase[? ItemID.DarkCrystal]   = ItemClass(ItemType.SpecialItem, "ITEM_95" , 76, null, 12000);
    arrItemDatabase[? ItemID.Crystal]       = ItemClass(ItemType.SpecialItem, "ITEM_96" , 77, null, 450);
    arrItemDatabase[? ItemID.CrystalShard]  = ItemClass(ItemType.SpecialItem, "ITEM_97" , 78, null, 70);
    arrItemDatabase[? ItemID.ElvesKey]      = ItemClass(ItemType.SpecialItem, "ITEM_99" , 79, null, 9000);
    arrItemDatabase[? ItemID.DragonStone]   = ItemClass(ItemType.SpecialItem, "ITEM_105", 85, null, 2500);
    arrItemDatabase[? ItemID.RhombusKey]    = ItemClass(ItemType.SpecialItem, "ITEM_103", 83, null, 450);
    arrItemDatabase[? ItemID.ShrineKey]     = ItemClass(ItemType.SpecialItem, "ITEM_109", 89, null, 450);
    
    //
    // (ITEM) Key
    //
    arrItemDatabase[? ItemID.PiratesKey]   = ItemClass(ItemType.Key, "ITEM_100", 80, null, 4500);
    arrItemDatabase[? ItemID.SkullKey]     = ItemClass(ItemType.Key, "ITEM_101", 81, null, 5500);
    arrItemDatabase[? ItemID.JailKey]      = ItemClass(ItemType.Key, "ITEM_102", 82, null, 800);
    arrItemDatabase[? ItemID.HarvinesKey]  = ItemClass(ItemType.Key, "ITEM_104", 84, null, 3500);
    arrItemDatabase[? ItemID.MagiciansKey] = ItemClass(ItemType.Key, "ITEM_106", 86, null, 7500);
    arrItemDatabase[? ItemID.SilverKey]    = ItemClass(ItemType.Key, "ITEM_107", 87, null, 1200);
    arrItemDatabase[? ItemID.GoldKey]      = ItemClass(ItemType.Key, "ITEM_108", 88, null, 12000);
    
    //
    // (ITEM) Buff 
    //
    arrItemDatabase[? ItemID.PhantomRod]  = ItemClass(ItemType.Buff, "ITEM_84" , 65 , null, 1500);
    arrItemDatabase[? ItemID.SeathsPlume] = ItemClass(ItemType.Buff, "ITEM_86" , 67 , null, 1500);
    arrItemDatabase[? ItemID.DemonsPick]  = ItemClass(ItemType.Buff, "ITEM_87" , 68 , null, 1500);
    
    //
    // (ITEM) Magic Crystal
    //
    arrItemDatabase[? ItemID.Verdite]      = ItemClass(ItemType.MagicCrystal, "ITEM_73" , 55, null, 4500);
    arrItemDatabase[? ItemID.FireCrystal]  = ItemClass(ItemType.MagicCrystal, "ITEM_90" , 71, null, 7500);
    arrItemDatabase[? ItemID.WaterCrystal] = ItemClass(ItemType.MagicCrystal, "ITEM_91" , 72, null, 7500);
    arrItemDatabase[? ItemID.EarthCrystal] = ItemClass(ItemType.MagicCrystal, "ITEM_92" , 73, null, 7500);
    arrItemDatabase[? ItemID.WindCrystal]  = ItemClass(ItemType.MagicCrystal, "ITEM_93" , 74, null, 7500);
    arrItemDatabase[? ItemID.LightCrystal] = ItemClass(ItemType.MagicCrystal, "ITEM_94" , 75, null, 9500);
    
    //
    // (ITEM) Gate
    //
    arrItemDatabase[? ItemID.MoonGate]     = ItemClass(ItemType.SpecialItem, "ITEM_111", 90, null, 2500);
    arrItemDatabase[? ItemID.StarGate]     = ItemClass(ItemType.SpecialItem, "ITEM_112", 91, null, 2500);
    arrItemDatabase[? ItemID.SunGate]      = ItemClass(ItemType.SpecialItem, "ITEM_113", 92, null, 2500);
    arrItemDatabase[? ItemID.MoonKey]      = ItemClass(ItemType.SpecialItem, "ITEM_114", 93, null, 1750);
    arrItemDatabase[? ItemID.StarKey]      = ItemClass(ItemType.SpecialItem, "ITEM_115", 94, null, 1750);
    arrItemDatabase[? ItemID.SunKey]       = ItemClass(ItemType.SpecialItem, "ITEM_116", 95, null, 1750);
    
    //
    // (ITEM) Ammo
    //
    arrItemDatabase[? ItemID.Arrow]     = ItemClass(ItemType.Ammo, "ITEM_117", 96, null, 30);
    arrItemDatabase[? ItemID.ElvesBolt] = ItemClass(ItemType.Ammo, "ITEM_118", 97, null, 60);
    
return arrItemDatabase;
    
