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

#include "../ToN Main Quest/Scripts/ToNFFC/ToNFFCScripts.zs"
#include "../ToN Main Quest/Scripts/ToNFFC/ToNFFCScriptsCutscenes.zs"
#include "../ToN Main Quest/Scripts/ToNFFC/ToNFFCScriptsStringsItems.zs"
#include "../ToN Main Quest/Scripts/ToNFFC/ToNFFCScriptsSwitchesSecrets.zs"

#include "../ToN Main Quest/Scripts/ToNFoes/ToNEnemies.zs"
#include "../ToN Main Quest/Scripts/ToNFoes/ToNBosses.zs"

#include "../ToN Main Quest/Scripts/ToNSubscreens/ToNActiveSubscreen.zs"
#include "../ToN Main Quest/Scripts/ToNSubscreens/ToNPassiveSubscreen.zs"

#include "../ToN Main Quest/Scripts/ToNUtilities/ToNEnumsTypedefs.zs"
#include "../ToN Main Quest/Scripts/ToNUtilities/ToNDifficulty.zs"
#include "../ToN Main Quest/Scripts/ToNUtilities/ToNHealthBars.zs"
#include "../ToN Main Quest/Scripts/ToNUtilities/ToNHero.zs"
#include "../ToN Main Quest/Scripts/ToNUtilities/ToNMiscFunctions.zs"
#include "../ToN Main Quest/Scripts/ToNUtilities/ToNNamespaces.zs"

#include "../ToN Main Quest/Scripts/ToNWeapons/ToNLweapons.zs"
#include "../ToN Main Quest/Scripts/ToNWeapons/ToNEweapons.zs"
#include "../ToN Main Quest/Scripts/ToNWeapons/ToNItemItemdata.zs"

#include "../ToN Main Quest/Scripts/ToNGeneric/ToNGenericScripts.zs"

#include "../ToN Main Quest/Scripts/ToNGlobalActive.zs"
#include "../ToN Main Quest/Scripts/ToNScreendataDMapdata.zs"

always using namespace Emily;




