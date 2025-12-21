//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Main Script ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

#option SHORT_CIRCUIT on
#option BINARY_32BIT off
#option HEADER_GUARD on

#include "include/std.zh"

#include "EmilyMisc.zh"
#include "Time.zh"
#include "ffcscript.zh"
#include "std.zh"
#include "ghost.zh"
#include "std_zh/ghostBasedMovement.zh"

#includepath "../ToN Main Quest/Scripts/"

#include "Headers/EmDebug.zs"
#include "Headers/LinkMovement.zh"
#include "Headers/NPCAnim.zh"
#include "Headers/TempLinkState3.0.zh"

#include "FFC/FFCScripts.zs"
#include "FFC/FFCScriptsCutscenes.zs"
#include "FFC/FFCScriptsNPCs.zs"
#include "FFC/FFCScriptsStringsItems.zs"
#include "FFC/FFCScriptsSwitchesSecrets.zs"

#include "ComboData/ComboDataScripts.zs"

#include "Foes/Bosses.zs"
#include "Foes/Enemies.zs"

#include "Subscreen.zs"

#include "Utilities/Classes.zs"
#include "Utilities/Difficulty.zs"
#include "Utilities/EnumsTypedefs.zs"
#include "Utilities/Hero.zs"
#include "Utilities/MiscFunctions.zs"
#include "Utilities/Namespaces.zs"

#include "Weapons/Eweapons.zs"
#include "Weapons/ItemItemdata.zs"
#include "Weapons/Lweapons.zs"

#include "Generic/GenericScripts.zs"

#include "GlobalActive.zs"
#include "ScreendataDMapdata.zs"

always using namespace Emily;
