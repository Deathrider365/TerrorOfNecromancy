///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Imports ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

// if issue with star.t / end, do:
// replace \r?\n with \r\n (must be in regex mode)

#option SHORT_CIRCUIT on
#option BINARY_32BIT off
#option HEADER_GUARD on

#include "std.zh"
#include "ffcscript.zh"
#include "Time.zh"
#include "std_zh/dmapgrid.zh"

#include "../ToN Main Quest/Scripts/Headers/LinkMovement.zh"
#include "../ToN Main Quest/Scripts/Headers/Ghost.zh"
#include "../ToN Main Quest/Scripts/Headers/NPCAnim.zh"
#include "../ToN Main Quest/Scripts/Headers/EmDebug.zs"

#include "../ToN Main Quest/Scripts/FFC/FFCScripts.zs"
#include "../ToN Main Quest/Scripts/FFC/FFCScriptsCutscenes.zs"
#include "../ToN Main Quest/Scripts/FFC/FFCScriptsStringsItems.zs"
#include "../ToN Main Quest/Scripts/FFC/FFCScriptsSwitchesSecrets.zs"

#include "../ToN Main Quest/Scripts/ComboData/ComboDataScripts.zs"

#include "../ToN Main Quest/Scripts/Foes/Enemies.zs"
#include "../ToN Main Quest/Scripts/Foes/Bosses.zs"

#include "../ToN Main Quest/Scripts/Subscreens/ActiveSubscreen.zs"
#include "../ToN Main Quest/Scripts/Subscreens/PassiveSubscreen.zs"

#include "../ToN Main Quest/Scripts/Utilities/EnumsTypedefs.zs"
#include "../ToN Main Quest/Scripts/Utilities/Difficulty.zs"
#include "../ToN Main Quest/Scripts/Utilities/HealthBars.zs"
#include "../ToN Main Quest/Scripts/Utilities/Hero.zs"
#include "../ToN Main Quest/Scripts/Utilities/MiscFunctions.zs"
#include "../ToN Main Quest/Scripts/Utilities/Namespaces.zs"

#include "../ToN Main Quest/Scripts/Weapons/Lweapons.zs"
#include "../ToN Main Quest/Scripts/Weapons/Eweapons.zs"
#include "../ToN Main Quest/Scripts/Weapons/ItemItemdata.zs"

#include "../ToN Main Quest/Scripts/Generic/GenericScripts.zs"

#include "../ToN Main Quest/Scripts/GlobalActive.zs"
#include "../ToN Main Quest/Scripts/ScreendataDMapdata.zs"

always using namespace Emily;




