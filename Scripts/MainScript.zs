//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Main Script ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

#option SHORT_CIRCUIT on
#option BINARY_32BIT off
#option HEADER_GUARD on

#include "Time.zh"
#include "ffcscript.zh"
#include "std.zh"
#include "std_zh/dmapgrid.zh"
#include "std_zh/ghostBasedMovement.zh"

#include "../ToN Main Quest/Scripts/Headers/EmDebug.zs"
#include "../ToN Main Quest/Scripts/Headers/Ghost.zh"
#include "../ToN Main Quest/Scripts/Headers/LinkMovement.zh"
#include "../ToN Main Quest/Scripts/Headers/NPCAnim.zh"

#include "../ToN Main Quest/Scripts/FFC/FFCScripts.zs"
#include "../ToN Main Quest/Scripts/FFC/FFCScriptsCutscenes.zs"
#include "../ToN Main Quest/Scripts/FFC/FFCScriptsStringsItems.zs"
#include "../ToN Main Quest/Scripts/FFC/FFCScriptsSwitchesSecrets.zs"

#include "../ToN Main Quest/Scripts/ComboData/ComboDataScripts.zs"

#include "../ToN Main Quest/Scripts/Foes/Bosses.zs"
#include "../ToN Main Quest/Scripts/Foes/Enemies.zs"

#include "../ToN Main Quest/Scripts/Subscreen.zs"

#include "../ToN Main Quest/Scripts/Utilities/Classes.zs"
#include "../ToN Main Quest/Scripts/Utilities/Difficulty.zs"
#include "../ToN Main Quest/Scripts/Utilities/EnumsTypedefs.zs"
#include "../ToN Main Quest/Scripts/Utilities/Hero.zs"
#include "../ToN Main Quest/Scripts/Utilities/MiscFunctions.zs"
#include "../ToN Main Quest/Scripts/Utilities/Namespaces.zs"

#include "../ToN Main Quest/Scripts/Weapons/Eweapons.zs"
#include "../ToN Main Quest/Scripts/Weapons/ItemItemdata.zs"
#include "../ToN Main Quest/Scripts/Weapons/Lweapons.zs"

#include "../ToN Main Quest/Scripts/Generic/GenericScripts.zs"

#include "../ToN Main Quest/Scripts/GlobalActive.zs"
#include "../ToN Main Quest/Scripts/ScreendataDMapdata.zs"

always using namespace Emily;
