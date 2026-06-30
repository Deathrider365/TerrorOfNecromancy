const int I_ABILITY_A = 152;
const int I_ABILITY_B = 153;
const int I_ABILITY_C = 154;

const int I_SWORD_TORRIN = 156;
const int I_SWORD_TORRIN2 = 162;
const int I_SWORD_KAYLANI = 157;
const int I_SWORD_KAYLANI2 = 163;
const int I_SWORD_SOREN2 = 50;
const int I_SWORD_TERRY2 = 63;
const int I_SWORD_SIYED2 = 143;

const int I_ABILITY_A_ASHER = 170;
const int I_ABILITY_B_ASHER = 171;
const int I_ABILITY_C_ASHER = 172;

const int I_ABILITY_A_TORRIN = 164;
const int I_ABILITY_B_TORRIN = 165;
const int I_ABILITY_C_TORRIN = 166;

const int I_ABILITY_A_KAYLANI = 167;
const int I_ABILITY_B_KAYLANI = 168;
const int I_ABILITY_C_KAYLANI = 169;

const int I_ABILITY_A_SOREN = 215;
const int I_ABILITY_B_SOREN = 216;
const int I_ABILITY_C_SOREN = 108;

const int I_ABILITY_A_TERRY = 217;
const int I_ABILITY_B_TERRY = 55;
const int I_ABILITY_C_TERRY = 88;

const int I_ABILITY_A_SIYED = 218;
const int I_ABILITY_B_SIYED = 219;
const int I_ABILITY_C_SIYED = 226;

const int I_AUGMENT_CANDLE = 183;
const int I_AUGMENT_BOMB = 184;
const int I_AUGMENT_MAGNET = 185;
const int I_AUGMENT_WAND = 186;
const int I_AUGMENT_SPEED = 187;
const int I_AUGMENT_DASHDIST = 188;
const int I_AUGMENT_DASHCOUNTER = 189;
const int I_AUGMENT_STELLARSWORD = 190;
const int I_AUGMENT_MINIOR = 191;
const int I_AUGMENT_REFLECT = 192;
const int I_AUGMENT_THROWPUNCH = 193;
const int I_AUGMENT_AUTOLOCK = 194;
const int I_AUGMENT_ALTBATTERYSOLAR = 195;
const int I_AUGMENT_ALTBATTERYLUNAR = 196;
const int I_AUGMENT_ALTBATTERYSTELLAR = 197;
const int I_AUGMENT_RANGE = 198;
const int I_AUGMENT_CHARGE = 199;
const int I_AUGMENT_SPARK = 200;
const int I_AUGMENT_MIRAGE = 201;
const int I_AUGMENT_LASER = 202;
const int I_AUGMENT_FLASHCHARGE = 227;
const int I_AUGMENT_LINGERINGFLAME = 228;
const int I_AUGMENT_SPARKINGDASH = 229;
const int I_AUGMENT_RESPONSIBLERICOCHET = 230;
const int I_AUGMENT_CRITICALGRAPPLE = 231;
const int I_AUGMENT_HADOUKEN = 232;
const int I_AUGMENT_DIREDROPS = 233;
const int I_AUGMENT_ALTBATTERYSOLARTERRY = 234;
const int I_AUGMENT_ALTBATTERYLUNARTERRY = 235;
const int I_AUGMENT_ALTBATTERYSTELLARTERRY = 236;
const int I_AUGMENT_RANGESIYED = 237;
const int I_AUGMENT_DIAGONALHEAT = 238;
const int I_AUGMENT_UPDRAFT = 239;
const int I_AUGMENT_CONCENTRATION = 240;
const int I_AUGMENT_UNSTABLEORBIT = 241;

const int LW_SOLAR = LW_SCRIPT1;
const int LW_LUNAR = LW_SCRIPT2;
const int LW_STELLAR = LW_MAGIC;
const int LW_PHYSICAL = LW_SCRIPT3;
const int LW_STARWANDIMPACT = LW_SCRIPT4;
const int LW_LOBBOMB = LW_SCRIPT5;
const int LW_TIDALGAUNTLET = LW_SCRIPT6;
const int LW_SCRIPTFIRE = LW_SCRIPT7;
const int LW_MAGNETGEM = LW_SCRIPT8;
const int LW_LUNARANG = LW_SCRIPT9; //The physical hitbox of the lunarang


const int NPCD_SOLAR = NPCD_SCRIPT1;
const int NPCD_LUNAR = NPCD_SCRIPT2;
const int NPCD_STELLAR = NPCD_MAGIC;
const int NPCD_STARWANDIMPACT = NPCD_SCRIPT4;


const int TIL_LOBBOMB = 65040;

bool LobBomb_IsSolid(lweapon bomb, int x, int y, bool flying){
	int pos = ComboAt(x, y);
	mapdata l1 = Game->LoadTempScreen(1);
	mapdata l2 = Game->LoadTempScreen(2);
	int ct = Screen->ComboT[pos];
	int ct1 = l1->ComboT[pos];
	int ct2 = l2->ComboT[pos];
	if(x<0-32||x>255+32||y<0-32||y>175+32)
		return true;
	if(ct==CT_LADDERHOOKSHOT||ct==CT_LADDERONLY||ct==CT_HOOKSHOTONLY||ct==CT_WATER||ct==CT_SWITCHBLOCK)
		return false;
	if(ct1==CT_LADDERHOOKSHOT||ct1==CT_LADDERONLY||ct1==CT_HOOKSHOTONLY||ct1==CT_WATER||ct1==CT_SWITCHBLOCK)
		return false;
	if(ct2==CT_LADDERHOOKSHOT||ct2==CT_LADDERONLY||ct2==CT_HOOKSHOTONLY||ct2==CT_WATER||ct2==CT_SWITCHBLOCK)
		return false;
	
	int cd = Screen->ComboD[pos];
	switch(cd){
		case 38560:
		case 38568:
			return false;
	}
	//I'm sorry, Moosh
	//I'm so, so sorry     
	// @@@@@@@@@@@@@@@@###%#(#%%(##%#%##(##%#(###(#(####((###((#%#((###(#%#######%####%###%############%###%%(##%###%#%%###%####&#((#%###%##%@@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@###(%%(##%#######%#((#%((###((######(##(((###((###(######(######%##(####%########%%###&###%########%((###(############%@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@(%####%#######&#((%%((#%##(#(####((#%((###((#%#((#%####(%##(#%##(#%%#(#######(%#((#&##(%%###%%###@*    *@&#((#########%@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@%((%%#(##(#%#(/%%#((%#((#(((%//(#%((/%#//(%#((##((##((##/(#%%/#%&#(##%@@@@@@@@@@@@@@@@@@@@@@@&#@          @%((######(#%@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@#%#(#(/%%#(/%%&((###(((((%(/*%%(//&#(/((((((/(##//(%%(##&#/(#&#((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            &#((%#((#@##@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@((#((#%(/(%&*/#&#*((((/((*##%/(###*//#(/((((/((*##(*/&(/*#@#(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@             @((#*#%((*%&@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@((#%#(/%%/((&#(/(#((#(/((%/*(%%*//%#//(((/(//((#//###*(%#(*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    I'm      %#(#%#/(#&(/@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@(((/(#(((%##/(#%&@&@&@@&((#(///%(/*/((/(((*/((//((/((%(/(%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    sorry... ((#((#%(((##@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@#(((#(&(((##&&&@%%%(@#%/,/#(#   %(((*/(//////(((/(/((/(@@@@@@@@@%@@@@@@&@@@@&@@@@@@@,@@%@@@./#            &%#((((####(#@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@#(@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %///((*//(//((//((@@@@@@@@@@@@@@@@@@@&&@%*@#@/,@@&@/@@@(%&             @((#(((((((#@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ *%(///#///(//(//(@@@@@@@@@@@@*  */&@@@@*(&**/@&*@&@**,@@#@             @((/#((((#((@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,/&/..*((/,//(/*//#/@@@@@@@@@@@       ##@&@@@ @#@@@@%@(%.@@@*@            @/(##*//##/((@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@.@@@@@@## (.*/#/*//#***@@@@@@@@@@*%        #(@@@@@@@@@@@@@@@@@@@@@@          @@%**/&(//#%(/@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%. (#/*,/#(*,//&@@@@@@@@@*           ,*@@@@@@@@@@@@@@@@@@@@@@        @@@/&#/,/##(*((@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(##, ,///*,///**@@@@@@@@&#*            @%@@@@#@@@@@@@@@@@@@@@@@@  @@@@@@@(,/(%(*/#%/(@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#/*./*,//***//@@@@@@@&/*  ,       .@  # @(@&@@@@@@@@@@@@@@@@@@@@@@@@@@@(#/**(#//*(#@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%/** (***/****@@@@@@@%@#%(@/  &@@&(&%&*&&&@*%@@@@@@@@@@@@@@@((@@@@@@@&((*/(//*/((/(@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%&(/,*//****/%@@@@(@@@@@&&%(  #,,**%@@@@%#&@&@@@&@@@@@@@@@@&&/@@@@@@///(/*//(/*/(%@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&%@@@@#*//*,*@@@@@@@/ *%@@@@   /#,*@&@@*, @@@@@@%@@@@@@@@@@@@@@@@@@/*//////*/////%@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(@@@@@,*//*@/@@@@@& ,&@#%@    */&@.@//&.@&%@@@/@@&@@@@@@@(@@@@@@*/#***///*/*/(((@@@@@@@@@@@@@@@@         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*@@@@@@@@/*,**/**@@@(/%@/@%&@     ,/*&/(/,,,(,@@@@@@#@@@@@@&@@@@@@@(**//(*/***//,*/@@@@@@@@@@@@@@@&         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/,*(/*.*/@#@@(.*/%*.           .( .  @@,,@@@(@@@@@@@@@@%&/,,/(**//////**/**@@@@@@@@@@@@@@@%         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*@*@@@@@@@/*/*,**(*,,*&@/(// .(               #/ , %/ .@ @@@@@@@@@@,/(/**//***/**//*/#@@@@@@@@@@@@@@@#         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%/@(@@@@@,@*,**/***/*****%,*/.   @%,,             ( #  /&&/,@@@@@@@(#/,*//**//*//*/*//(@@@@@@@@@@@@@@@#         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@ %@#@@.&@@ @@,******/******/*@***///#///*                 /.&%@&@%@@@#***(***//***/******/@@@@@@@@@@@@@@@#         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@%(@*@@@&@@% #*/*,******//*,@***(*//(@&@@@%#*#*           .  @@@@.&*//@@&/**//***//***/****/@@@@@@@@@@@@@@@(         
	// @@@@@@@@@@@@@@@@*/@@@@@@@@@@@@@@@@%&#@&@%@@@##@&@@@@(/   ,,*/**,///,*//*,/(/&%/#@@@@@@@%@@  *        .#(&*( *%(///@/((//(@//,**(*,*/(**@@@@@@@@@@@@@@@(         
	// @@@@@@@@@@@@@@@@//**@@@@@@@@@@@@@@@#@@@@&@@(@@@*@@%(#    //,,**/,*///@/@(%@*/@&/**    *%@  ,@      %&*@( #  */%(/*/@&/*/(***//**&//*,((@@@@@@@@@@@@@@@(         
	// @@@@@@@@@@@@@@@@*,/#//*@@@@@@@@@@@@@@@@@@@@@@@@@@//(# * //@@@@#(,*/*/**@%**/**#@*/*/#*,         @%#@*##  * ( /*(((/*@((**//(***(/***@,,@@@@@@@@@@@@@@@(         
	// @@@@@@@@@@@@@@@@(/*,/((,/&@@@@@@@@@@@@@@@@@@@@@@/*(#,  @*,,/%***/&//*#@/**&##@%&,#*        @&*&/**  #%  *(  ,%@(( /((@.((*,*#//.*#/* (&@@@@@@@@@@@@@@@(         
	// @@@@@@@@@@@@@@@@*//(**/(#*,@@@@@@@@@@@@@@@@@@@*/*/*** &,(/#(*//**%(&@@*,(##@@&/#( *,*#@(@%*///*    ..      (/&*((%/**/&***((,**#/,*/#/#@@@@@@@@@@@@@@@(         
	// @@@@@@@@@@@@@@@@(/*,///**(/&&@@@@@@@@@@@@@#*******(**/(%((/(&(/@%%&@*##%@@@@&  (/.*/*(&/%(/(,,    ** (    ,@%(&#(//((/,/%/**(//,*(/*(/@@@@@@@@@@@@@@@@(         
	// @@@@@@@@@@@@@@@@/ @#/,///&&@((/#@@&%%%/***/****** (((######@%#(&#%%#@%@@#&@@%   /&/***/&&%**/*. ,(.      *%(@#/#(%(*/(@@%&//***(/@@/(/@@@@@@@@@@@@@@@@(         
	// @@@@@@@@@@@@@@@@(@%/(,(*((//*//(/,*(#%(///**///,  @#@%@@#(%@###@%&@@%@@@&&%&@   .**//**(((%@@*,       .,/*,%((#@@(%##&%%*/**//%@@#//*/@@@@@@@@@@@@@@@@/         
	// @@@@@@@@@@@@@@@@/(@((&(&((//((***(/**/(***//*.     (&#(@#%&#(%#@&%#/##%%#@#%@    */**/@@@@@@@@      ,,(, ,&(%#(//(/@@%#*/*/##&@%//&///@@@@@@@@@@@@@@@@/         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@#*@((/.*/#/*///***//,,  ,(@##&&@#(((&%@/%%&#%&%#(@%  ,,*%((@@@@@@@@#.,*/,(  ,*@#&((#%/*//#%**/%#%@&(/#*////@@@@@@@@@@@@@@@@/         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#*(#/**(#(*(@@%,  ,@@%%#((((//@@#((%&/(#&@,  ,//. *@@@@@@@,/@//   *.@#((/%##(*//#&(*/(&@@@%&#////,/#@@@@@@@@@@@@@@@/         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,(*@&*@&#/          @#%(/&&#/#@@/, ,&/.%@@@@@(#,. /#,,*(/@(#&(//#**%@&///%@@((@#(//*/@/@@@@@@@@@@@@@@@@/         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(/*,/(,#&     * /. &((#&%((@/  .(@@@@@@@#,(#/***(**(%(((%#/**@@@/*/(@@#&%//*/#(#@&@@@@@@@@@@@@@@@@/         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/**%@,**//,,*/#*@(#   %#((@#(,** *@@@@@@@@@#*.  ,/(&#/###(/(/%(&@@(/&@@&@///@@@@#(/@@@@@@@@@@@@@@@@/         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@**/(*@@@     .*      %#((#%#&@@@@@@@@@@*/////###(#%(((#(#@((@@@@*@@@@(@@@@@/(/(&@@@@@@@@@@@@@@@@/         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/(@@@#,**/&,@   *     @###(/#@@@@@@@@@#***(#((&###((%#@(%%#(@@@(@@@@@@@@(/%@@&(@@@@@@@@@@@@@@@@*         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/*(/(////***%&,,.   #%(##&(@@@@@@@@%#(#((#@#%###(&%%%%%%#@@@@@&&@@@&@@@@%#*/@@@@@@@@@@@@@@@@,         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/*//( , ***@   *@@&*#*  @(/(@@@@@@@@((%#(##%%#(#%%&%@&@#&&@@@@@@@@@@@@@@%/*/(/@@@@@@@@@@@@@@@@.         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@          @@@@@/*/(/,*(  ,,       #@//(/   &##(@@@@(###((#%%(##&@%@@@%&@&@#@@@@@@@@@@%@(**/((*/@@@@@@@@@@@@@@@@.         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           #@@@@@*#(,*(( ,,,,         @#//*    @%((&##/(#%%#(#&%@(%&%(*@%&@@@@@@@@@@@@&#**/(/**//@@@@@@@@@@@@@@@@.         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.            @@@@@/,(#**,#**           @%*//#    (@@@@###&(###&#@&@%#%%&%#%##**(@@@&@&*/@@@/%&////@@@@@@@@@@@@@@@@.         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@             .@@@%/@%*///***   ,       @@&*//*/   .. @@/**@#@@&@@@#&@&%%&&&(*((&@@@@&@@@@@@@&(/(//@@@@@@@@@@@@@@@@          
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,      I'm     @@@//*((**(//   *,       #(@//*///,,(  %&@/(///(&%&@@&%%&&%&%&#(##@@@@@@@@%(//////((@@@@@@@@@@@@@@@@          
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     sorry...  @@@#*&*//#&/*  **        %//*@@///////*%(@/*//(**//((%&&%%&&@#%%&@@@@&@////((///((//@@@@@@@@@@@@@@@@          
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@               @@@&/*///&//**%(,        &*/(#(@@#(//,(((@#%(**///*/(/*/(@@@&&@%%@@@@@@@@@/////(//#(@@@@@@@@@@@@@@@@,         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@               @@@@((//*///%&/*         &%%((@&/(@/@**//@#(#%%(/*(////(/////&@@@@@@&@&@@@&@@@(/(/(/@@@@@@@@@@@@@@@@*         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#              @@@@&/%&*///*(/          (@%&&@@@@((**(*@@%&((/%%#*/%(*/////////#(///(/@@@@##@@&/**#@@@@@@@@@@@@@@@@,         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@             @@@@@@/@**///&% .**,      @&@#(@@@(@%#%*%@%(/%&&(/%%%/(#%/**/(//*//((*/*#/#@%@//,#%(*@@@@@@@@@@@@@@@@,         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@             @@@@@@@@/*/%@/,*/@#/ *     @*#&@#@@@@&&%(((%&((/&%#(#@%((#&((((/(///((//*//(//@&&*//#@@@@@@@@@@@@@@@@*         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           @@@@@@@@(//(@(///&@((*.     (&##@&&(((&@/(#%((##%((%%%(#%%@#%%#((#####%(#(##/(((/@#&&(@@@@@@@@@@@@@@@@*         
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*        @@@@@@@@@(((((*(@@#(#(%&*    /(&%%%@@&%((%#(/(@@##&#@#%@@@@@@@&@@@&%%%%#%&&&&@&%(#@#@@@@@@@@@@@@@@@@@@@*    


	//It's okay, Russ. I forgive you
	// .                           ,*       /(((#.    ##((.     //##/..(/(//((//,*(((//((((((#(%##@@@@&@@@&@@@@@@@%************,*******///***/////(((///////////((((///
	// 							 /#       /(##((    &&%(,     /%%&// ((/#(((%/(,((/((((#(#(#(/(#@&&&@@@@@@&&@@@@*                                                   
	// 							 .%@ .     /(((#( * .&@%(%     /%%&(# (((//(#&#@.//((#(#/(((#&(&&&@@&&&&&@@&&@@@**                                                  
	// 							 ,.&@. .    ((#(/* ( (@@@(&    ./@&&/*//%#.//%@/&/(/((&@#(((%#&%%@@%@@@@&&@&&&@@%.,                                                 
	// 					  .(   .  ,%@@. .   ./(/,%..,,#@@@/#    ,(@%&/ (&@%,/*&//&/(*((@&@(((&(#@/#%&@@@@%&&&&&@@%#                                                 
	// 					   (#   * ,*@@@...   ,((((/ / /@@@@/.    /@@&(( /%% ((%@.&///((&@@(((%#&#@@%%@@@@@%&@%%%@,*.                                                
	// 	  .                (/(   **//@@@ /.   (#(&&,.,/#@@@/%    ,(@&&/.*&&./(/@@ @ *///%/@(((&#%##%&#@%%@@%%&%#@&#                                                 
	// 	  *                %#%#  /*//@&@@,(   .%@&%#..*/@@@@.*  . /@&%(,,%@(,*/#&,//  /#@&&#((%#%(&@&(&&##%%#@#%%%                                                  
	// 	  ,,     . ./      & ((. .((/%@@@(/,   /&#@& **/@@@@%(  . (#@&%*.(&% /(**@ @ ,*(%&(%/((#(%&@/##@@&#%%%%#%(                                                  
	// 	   #     / ,       %.%&%  *//#@@@@.(   /#@(&((/(&@@@@ *  .*/&&&( (@* //(%@.#, .(/&#@(#(&#&&%@@##&@%##%&###                                                  
	// 	   &     ( , #     /.#(((  ##/@@@@&//  *(@(@&//(#&@@@*(  .*/@@@( (@(.////#(*& .(/&(&#((##&@@@@%#(@&###@##%                                                  
	// 	   (.     . **.    ,#./%%  ((*&&@&@%/  .(&#@@/(*/&&&@&*  .//@&%& &@@@@@@@@@,% */(@(%#//&###(#&&(#(@%##&(##                                                  
	// 	  // #     %.(.&   .*@ #*(, /%#(&&%&@/,  /(@&@/(//@@@@@.., /(@@&%@@@&*   ,/@%( *#%&#&&(#(((((((%@##@@(%@@.                                                   
	// 	  ./@     % & &    ,(.(/%%  #((@##@&(#  //@#@(/((@@@@@,*,,#@@@#           .@@&%%%@%%&(*   ,%(((#&(@&&#@%@                                                   
	// 	.  %(     /## /#   .(*.(&( ./(/@&&&@%/  */@#@((/#@@@@@%@@&@@#      ... ,#*,%@@%%&&@(/.      (((((&#((#@@#.                                                  
	// 	 *  (&    ,@/(,@   .(& %##.*#@#@##%@%(  */&#&(/((@@@&@@@@@@#     /#@@@@@@@@@@@%%@/.          /((#(@##%@&&%                                                  
	// 	 .. %%%    %#@./   * *.#(#(/*&/@%##&&/, ,/%%&(#(/&%@@@&@@@@    .#@@@@@@@@@@@@#/%/             (((#(@%%( *.                                                  
	//  *    *, &/.   .@(*/#. ..(%//&&,(%(&#@@&%(/ ,/###&(/(#@@@&&@@@@@   #@@@@@@@@@@@@ ((( .            ((#(##(%%@                        ,/((/#/*/((,                
	//   ( , .*,(@@    %%%(%   ,.(,(&%**((&(%@@@(( ,/%(##((*#@@@%@&@@@@(.,#@@@@@@@@@# ((/*.              /(((((&@#(/           //*.                         .*(%*      
	//   @* / *&.(#&    ##(*.   .//%#(/(#(%@@@@@%* /((#(/((,*%#@(%#&&%#%&@@@@@@@@//(@@/**,               (#(((%@%(%&      %.  .* . .%@  %,    ...    ..,..,,.,.,..   .#
	//   #&. * *@(&.,   /@%(@   *.#%(//*((%@@@@@@%/@@@&////(/*//&&###&@@@@@@@@@@&//**,/.                 #(((((&&%%   #.,@(/%#.*(#%*.//&#*  *#.#.. *,****,,,,,,,,,...  
	//    #@. * /@&@#    ###/(   .*%&%((&@@@@@@@@@@&@@@@%(/////*. @&@&@&%##((**((,                     ./(((((/#&#/# #%*#%. #@@*(*/. %%%  /(#%*&/ ,,****,/**,***,,,....
	// /  */&, / (%@&&    //((. .**@@@@@@@@@@@@@@@&&@%((#%*((*    &(///%//,***.                       /*((///(/&* ,@%.%% */(& ,# # (%/@  *(#&/#/*./#/****%**,*,,,,,..,.
	// .   *%%, , %@@(/   ,@@#(*@@@@@@@@    , .&%*@@&&&##@#, .      *.   *    *                     *//**(/*&./ *@(.@, /&%*. , /..%%/&  *(#**/%*%,,#**/*//***,*,,,,. ..
	//  *,  %#// ./&&##,   &%&%&%@@@@,     *%&@@@@@@@@@%@@%@@@.     ,,.     .,  .  .          ,***/**//,*%  & .@. @  *@%/  %@ (. %(#@ * *&(&/(//%((*/*%/(%*,**,,,,,....
	//  (/.  %%(% ,/&%&#   ,/(#@@@@@       @@@@@@@@@@@%(@%*/&%@&             ,,,,,,,*,*/**********//,**% ,@  #& &.  &%&,   &/**.&/(@   ,#&((/%**%/%*/(#((@**(,*,#,,,...
	//   %((  ((#& (/&%@% *.@(@@@@@@%     #@@@@@@@@@,@%&/%/(*/*/#/             .,***,******/*/******/% ,%&  %#(&  #%&**   *,/& %#/,@ ,,*(%#//@,*&/%/**#/##**#,*,*,.( ..
	// ..*&#%  **/(#.&&(%@/(*&#(%%@@@@&(. ,@@@@@@@  @/@&.   ****//%            ***/*/****,**/*****/( ,@@@  &&((  @*%%&&#*(@@@./&%#*@(,/*&@#*/%//#/**,*(/(/(,**,,%,,/,. 
	//   ,*@%(. ./&// /#&@%@@/@&##&&@@@@@@@@&&#//*%#@&%*.*,,*,,**//%         /@@%**********/****,/% &,/%, *@*/% &*&#/%%&@@&&@/%/(&%#((*,/##//%/****&*//(*%&,*%,.&,,.,.,
	//    ,,/(*(, &&%%/,@%@@*%&@%/*.,,#/*(&@%(%%%%((***        ,//**.      ,&@/(/**,****,/%&@@@@#%*%*(/@  %#//(((@@%@%%#(/@@@&%**.* ..%,*@&@/(@/*@*%***@/&(&,**,/,../..
	// 	  #  ,#(*.#@#(&%@@,***&*.        ...*,.                /*(%%#/#(#@%/@/,, */#@#*,****%*((,&#*@/*((**%%/&(,/%#@@@@@@@%%(%, .,,*(/#%@/#%**@*&*/&(/*#%*&**&../  
	// 	   .      %( %%,%%@&(%*#/                                ,,,***/*,***  (,@/    *&&%**(%/.%/#*&*/*//@#/##,(/@&@@*   &@&&,&,*,,*,//(#/((/(&&&**@,&*&@&#,,,..,.
	// 				.(  .%%(#@&#*#@.                                     ./%(/@(     /@@,*@%/***#@@@@&%,  ,/%@(@@&/@&*@&.    (@@,/&(%/**********@&%/*&@,@/&**/,&..(.
	// 					/%/.****(/***&,                                 @@(      (@/(/%/%(/*,****,&@@@&    #%&%(@#(#&&,       @*/(*/,,********,*,****(#%*#,%(/(.&.,,
	// 						   (%*,*,*,,/#                           &@@*.   ,@@#/%%(//*,,*********@@@     #&%/(//*%.     . &#*&&/,   ,*,**,**,,******,,*.,%.*/(,&./
	// 							   .        #/                      @@@#,#&&#@@@@&(       .,,****,@.       @#/(#@@#.., .%(@/@,#%,        .(,**../*,***,,/,.*,,,,., .
	// ,                                           ,(                ,,*%**/**//***(        .*,,///*.(*       *%*#@@&(&#,**/**.(.          ., .***,,,,***,,*,,,,,,,.,.,
	// 												,&(                  ,/%  ,*,,    .,.&       .(,,(      *,,*&/,.,,,**,              .,*,,*,********,,,,,,,,,..,.
	// 													 *@&/             #**,**,/,,.*/**@                   ,,,,,.,,,.              ,.,,,,*,.,/,***,**,.*,,,,,,.,.#
	// 															.@%/, (&&@@&@@&@@@&/(**//(.     ,,****,**,                          *..,,,,*,..,,,*,*,*,,.,,*.,,..#.
	// 															  &.*.*,,(,/*,/.(,/*%,(%*/@&    ,,,/*,****                       .,.,*,,,,,**,.,,**,,,,,**,,,,,,,*,,
	// 															  ((../***,(/&/,,*/*#,((&%**@%(#@%*,****,                       .,,.,,,,*,,,**,*,*,,,,,,,,,,,,,,,.(/
	// 															  /#*/ .,./*,*,*.,,#*(*,(**/@%%(%#&/,/                         ,*********,,,*,,,,,,,,**,**,,,,,,*#&%
	// 															  ,@ . .,*,,(*..*...,**.*.#* .,..                            .,,*,*/.,***/*,,,***,,,,,,***,,,,,,*&%@
	// 															 .@*      ,,,@#,/,*,,,,,,,,@#(#,,,*,,*                      ,****,**,,*,******,*,,,,*,,,,*,,,,,.%%#/
	// 															& &*%      **,./*,*,.,,,,..*&@&&%&&@@@##/                  *******,,,,***,*,*,*,,,,,,,,*,.,,,,,#*,,,
	// 															@ @*/       ..(#,*,,,,,,,,.,(@@&&&%(,   .#.               ,,/**,,,,,**,***,,,*,,,*,,*,**,,,,,,**,,..
	// 														  ,%%/.@..  .     @.,*,,,,,,,,,*&#@%%*.  ..(@@@              *********,****,,*,,,,**,,,,,,,,,,,,,,,.,,,.
	// 													   .%@@/*/  %(   .,    .*/*,,.,,..,%*           .               *,,***********,*,,,,,,,,,,,,,,,,,,,,,,......
	// 													%, /@@( (%%    /@. %.   #,/*(,..,.,,&@&&&%#( .                *,*,*/,,****,***,*,,,*,*,.,,,,,,,,,,,,,,,,,,..
	// 												 &.#&@@@@@* ,.*(     ..,@*.. #&,(.....*.@@*/%&(/,..             .,,,*,/**,*,,,,**,**,*,,,**,,,,,,,,,,,,,,.,,,..,
	// 											   #.@@@@@@@@@*  #. #      ...%&,.//,..,. *,.....,.. ...           .,,,,*,/**,,*,,*,,,,,*,,,,**,,,,,,,,,,,,,,,.,,,..
	// 											 &.@@@@@@@@@#.%   /.         ....%/,.....#                       ,,,,,**,******,,,,,,,,,,,,,,,,,,.,,,,,,,.,,,,,...,,
	// 									  /#.  & @@@@@@@@@@#.,**            ....(@,%,...(                      ,,,,,,,,,,,*****,,,,*,,,,,,,,,,,,,,,,.,.(&#*/.%&....@
	// 								 ,@,.@@@@#.@@@@@@@@@@@@.,,,*.           .. #%@.&...,                   ..,.*,.**,,**,,**,,,****,,,,*,.,*,..,,,,,../( ,.....,....
	// 						  ,%@(   /@@@@@*@@@@@@@@@@@@@@,...../.        ...#,#%&.**..*                ..,,,,,,,,,,*,,,,,,*,,*,,,***,,,,,,,,,,,,,,,&*..,.,.,..,,..,
	// 					,@(   ,@%.,@@@@@*@@@@@@@@@@@@@@@@.   .,..*       ...(.%%%...#...(       ..... .,..,,,,.,,,.,,,,,,,,,*,,,*,,,,,,,,,,,,*,,,.(% .(,..,,........
	// 			.#&@/    . (&@&.&@@@@@.@@@@@@@@@@@@@@@@@.      .../    ....%, &,  .,/..,./,&,  . ......,,.,.,,,,,*,,,,,,,,,,*,,,,,,,,,,,,,,,,,(,,,(/,............,..
	//    (@#*/@.    .%@@@@#@@@@.@@@@@%.(*,%&@@@@@@@@@@@@@..       ..,(. .,./#( ..    ..%.........,#@%(%%%#%#(#(/@@@@@@@@@&@@(,/(*,*(/%%@%@%#.,.,,.*/(/,.,....,.,......
	// ,  ...*. .%@@@@@@@@@@@@*&@@@@@@@@@@@@@/.*@@@@@@@@%/.          ...,,.......     ..,#*  ....,...,,  %&*./(,#(/((#%,.*##,,((*##*%**#/*#,..,,.,, (#.,.,.. ..........
	//  @@@@@/@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@&&@@@@#%..            ....,...         .., @.......(,, .,,.,,,#@&,,...,,,,.,,,,,,,.,,*,%,/*,,..,.*(#......,...........
	// @@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*,%@@@@@@@#                .....,.           &.*......,.. ,..,,,,...(*@..,.,,,,,..,,,,,,,.,%.,*,.,../ ,.,.....,...........
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@# *@@@@@@@@@@@@@@#(.                 ...,./(        .., (.....%,,/@,..,,...,. ,@*..,,,.,.,.,,,,,, @/.,.,,..#/*,....... ,..........
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@#, .                 .......*       .* /...,,,.., ,.,....,,.,,,%   ..,,,,,,,,..,,,*...,..,.%..,.............. ...
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@..,@@@@@@@@@@@@@@@@&.                     ....,. ,.     ,& %...#,.,%.............,/     .....,,,..,,....,,,/,./............... ...  
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@&.,@@@@@@@@@@@@@@@@&%..                     ..,. .. .    ,*@.(../..,.............,,.,      ..,...,,,..,,..,,/./*.....................
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@.@@@@@@@@@@@@@@@@@%#                         .  ..  .,,..,.% &&*. ,*.,..........,,,,      .,..,,..,.*,............. .....,  ...  .  
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@##                         . ......,,* . .#.,.,/.  & ,.....,...*.&    ..,.,.,........,...,..  ,.. .....,....    ..
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@*@@@@@@@@@@@@@@@@@%%                            .....  .  ....@(,*(.,,.............#&  ...........,.......................... .    #
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@.@@@@@@@@@@@@@@@@@&                              .. ..   .  ,,&&/.,..........  .&.  .@  ...............  .......    .. .   .  .,*  
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@&.@@@@@@@@@@@@@@@@%                               . . ..  ..,%.&, . ......,,../    &,**/ .... ............     , .   . .  ..*,.    
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@@@@@@@@@@@@%,                                  .   .*.(,,  ..........*   &(**.(.@   ...............  .. . .  .   .(.        
	// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@%                                      ..&.# .. .......,.  @.,/*/, ,/    . . ........... .   ...   %            

	if(Game->GetCurDMap()!=21){
		for(int i=0; i<SOLIDOBJ_MAX; i++){ //Cycle through all possible objects
			int x2 = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_X];
			int y2 = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_Y];
			int width = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_WIDTH];
			int height = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_HEIGHT];
			//If one of them collides with the bomb, return true
			if(RectCollision(x2+4, y2+4, x2+width-1-4, y2+height-1-4, x, y, x+15, y+15)){
				return true;
			}
		}
	}
	//Okay so this actually wasn't bad at all but I thought it was going to be terrible and I spent like 15 minutes on the shitpost so I can't really go back now
	//This was a good use of time
 
	return IsSolidLayer(x, y, bomb->Misc[LWM_SOLIDITYLAYER]);
}

const int DAMAGE_LOBBOMB = 300;

itemdata script LobBombItem{
	void run(){
		if(Game->Counter[CR_BOMBS]==0)
			Quit();
		--Game->Counter[CR_BOMBS];
		Link->Action = LA_ATTACKING;
		int dir = Link->Dir;
		lweapon bomb = CreateLWeaponAt(LW_LOBBOMB, Link->X+DirX(Link->Dir, 8), Link->Y+DirY(Link->Dir, 8));
		if(G[G_OVERUNDERSCREEN])
			bomb->Misc[LWM_SOLIDITYLAYER] = G[G_OVERUNDERLAYER]+1;
		bomb->CollDetection = false;
		bomb->OriginalTile = TIL_LOBBOMB+2;
		bomb->Tile = bomb->OriginalTile;
		bomb->CSet = 11;
		bomb->NumFrames = 4;
		bomb->ASpeed = 0;
		bomb->Damage = DAMAGE_LOBBOMB;
		if(HasAugment(I_AUGMENT_BOMB))
			bomb->Damage += 50;
		int z = 8;
		bomb->Z = z;
		bomb->Script = Game->GetLWeaponScript("LobBombLW");
		int jump = 1;
		bomb->MoveFlags[WPNMV_CAN_PITFALL] = true;
		int step = 3;
		if(LobBomb_IsSolid(bomb, bomb->X+8+DirX(Link->Dir, 4), bomb->Y+8+DirY(Link->Dir, 4), false)){
			Game->PlaySound(SFX_PLACE);
			bomb->MoveFlags[WPNMV_CAN_PITFALL] = false;
			bomb->Z = 0;
		}
		else
			Game->PlaySound(SFX_JUMP);
		while(bomb->isValid()&&bomb->Z>0){
			switch(dir){
				case DIR_UP:
					bomb->Y -= step;
					break;
				case DIR_DOWN:
					bomb->Y += step;
					break;
				case DIR_LEFT:
					bomb->X -= step;
					break;
				case DIR_RIGHT:
					bomb->X += step;
					break;
			}
			if(LobBomb_IsSolid(bomb, bomb->X+8, bomb->Y+8, false)){
				Game->PlaySound(SFX_PLACE);
				dir = OppositeDir(dir);
				for(int i=0; i<8&&LobBomb_IsSolid(bomb, bomb->X+8, bomb->Y+8, false); ++i){
					bomb->X += DirX(dir, 1);
					bomb->Y += DirY(dir, 1);
				}
				// step = Max(step-1, 1);
			}
			z = Max(z+jump, 0);
			jump -= 0.25;
			bomb->Jump = 0;
			bomb->Z = z;
			Waitframe();
		}
		if(bomb->Misc[LWM_SOLIDITYLAYER]==2&&ScreenWalkFlags[ComboAt(bomb->X+8, bomb->Y+8)]==3)
			bomb->Misc[LWM_SOLIDITYLAYER] = 1;
	}
}

lweapon script LobBombLW{
	void MakeExplosion(int x, int y, int damage, int dir){
		lweapon explosion = CreateLWeaponAt(LW_BOMBBLAST, x, y);
		explosion->Dir = dir;
		explosion->Damage = damage;
		for(int i=0; i<4; ++i){
			lweapon l = CreateLWeaponAt(LW_SCRIPT10, x-8+(i%2)*16, y-8+Floor(i/2)*16);
			l->CollDetection = false;
			l->Script = LWS_ONEFRAME;
			l->Weapon = LW_BOMBBLAST;
			l->DrawYOffset = -1000;
		}
	}
	void run(){
		while(this->Z>0){
			Waitframe();
		}
		if(IsWater(ComboAt(this->X+8, this->Y+10))&&this->Z>=0){
			Game->PlaySound(SFX_SPLASH);
			ParticleAnim(this->X, this->Y, 118);
			this->DeadState = 0;
			Quit();
		}
		Game->PlaySound(SFX_PLACE);
		this->OriginalTile = TIL_LOBBOMB;
		this->Tile = this->OriginalTile;
		this->NumFrames = 0;
		this->ASpeed = 0;
		int fuse = 180;
		int state = 0;
		int bouncedir;
		if(HasAugment(I_AUGMENT_BOMB))
			fuse = 30;
		while(fuse>0){
			--fuse;
			if(state==0){
				for(int i=Screen->NumLWeapons(); i>0; --i){
					lweapon l = Screen->LoadLWeapon(i);
					if(l->ID==LW_BOMBBLAST){
						if(RectCollision(l->X-8, l->Y-8, l->X+15+8, l->Y+15+8, this->X, this->Y, this->X+15, this->Y+15)&&!(l->X==this->X&&l->Y==this->Y)){
							state = 1;
							bouncedir = AngleDir8(Angle(l->X, l->Y, this->X, this->Y));
							this->Damage = Min(this->Damage*3, 900);
						}
					}
				}
				if(state==1){
					this->OriginalTile = TIL_LOBBOMB+2;
					this->Tile = this->OriginalTile;
					this->NumFrames = 4;
					this->ASpeed = 0;
					fuse += 60;
				}
			}
			else{
				this->MoveFlags[WPNMV_CAN_PITFALL] = false;
				this->X += DirX(bouncedir, 3);
				this->Y += DirY(bouncedir, 3);
				if(LobBomb_IsSolid(this, this->X+8, this->Y+8, true)){
					this->DeadState = 0;
					MakeExplosion(this->X, this->Y, this->Damage, bouncedir);
					// lweapon explosion = CreateLWeaponAt(LW_BOMBBLAST, this->X, this->Y);
					// explosion->Dir = bouncedir;
					// explosion->Damage = this->Damage;
					// for(int i=0; i<4; ++i){
						// lweapon l = CreateLWeaponAt(LW_SCRIPT10, this->X-8+(i%2)*16, this->Y-8+Floor(i/2)*16);
						// l->CollDetection = false;
						// l->Script = LWS_ONEFRAME;
						// l->Weapon = LW_BOMBBLAST;
						// l->DrawYOffset = -1000;
					// }
					Quit();
				}
			}
			
			if(fuse==60){
				if(state==0){
					this->OriginalTile = TIL_LOBBOMB;
					this->Tile = this->OriginalTile;
					this->NumFrames = 2;
					this->ASpeed = 1;
				}
				else if(state==1){
					this->OriginalTile = TIL_LOBBOMB+6;
					this->Tile = this->OriginalTile;
					this->NumFrames = 4;
					this->ASpeed = 0;
				}
			}
			while(this->Falling>0){
				Waitframe();
			}
			if(this->Misc[LWM_INSTANTDETONATE])
				break;
			Waitframe();
		}
		this->DeadState = 0;
		lweapon explosion = CreateLWeaponAt(LW_BOMBBLAST, this->X, this->Y);
		explosion->Dir = bouncedir;
		explosion->Damage = this->Damage;
		for(int i=0; i<4; ++i){
			lweapon l = CreateLWeaponAt(LW_SCRIPT10, this->X-8+(i%2)*16, this->Y-8+Floor(i/2)*16);
			l->CollDetection = false;
			l->Script = LWS_ONEFRAME;
			l->Weapon = LW_BOMBBLAST;
			l->DrawYOffset = -1000;
		}
	}
}

const int I_TIDALGAUNTLETMOON = 145;
const int I_TIDALGAUNTLETSUN = 146;

const int CMB_TIDALGAUNTLETPARTICLES = 38400;

const int SFX_GLOVEMOON = 63;
const int SFX_GLOVESUN = 65;

const int CT_MOONSTONEBLOCK = 142;
const int CT_SUNSTONEBLOCK = 143;

const int STATE_TIDALGAUNTLET_SUN = 0;
const int STATE_TIDALGAUNTLET_MOON = 1;
const int STATE_TIDALGAUNTLET_EITHER = 2;

const int TIDALGAUNTLET_FLOATFRAMES = 40;

//Returns a 4-way direction when that's the only direction held, else -1
int GlobalInputOnlyDir(){
	if(G[G_UPINPUT]&&!G[G_DOWNINPUT]&&!G[G_LEFTINPUT]&&!G[G_RIGHTINPUT])
		return DIR_UP;
	if(!G[G_UPINPUT]&&G[G_DOWNINPUT]&&!G[G_LEFTINPUT]&&!G[G_RIGHTINPUT])
		return DIR_DOWN;
	if(!G[G_UPINPUT]&&!G[G_DOWNINPUT]&&G[G_LEFTINPUT]&&!G[G_RIGHTINPUT])
		return DIR_LEFT;
	if(!G[G_UPINPUT]&&!G[G_DOWNINPUT]&&!G[G_LEFTINPUT]&&G[G_RIGHTINPUT])
		return DIR_RIGHT;
	return -1;
}

itemdata script TidalGauntlet{
	void TryAlign(int dir, int sign){
		if(sign==-1)
			dir = OppositeDir(dir);
		if(CanWalk(Link->X, Link->Y, dir, 1, false))
			return;
		int tX = Link->X;
		int tY = Link->Y;
		int gX1 = Floor((Link->X)/8)*8;
		int gY1 = Floor((Link->Y)/8)*8;
		int gX2 = gX1+8;
		int gY2 = gY1+8;
		// Screen->FastTile(6, gX1, gY1, Link->Tile, Link->CSet, 64);
		// Screen->FastTile(6, gX2, gY2, Link->Tile, Link->CSet, 64);
		switch(dir){
			case DIR_UP:
			case DIR_DOWN:
				if(Abs(gX1-tX)<=6){
					if(CanWalk(gX1, tY, dir, 1, false)){
						--Link->X;
					}
				}
				if(Abs(gX2-tX)<=6){
					if(CanWalk(gX2, tY, dir, 1, false)){
						++Link->X;
					}
				}
				break;
			case DIR_LEFT:
			case DIR_RIGHT:
				if(Abs(gY1-tY)<=4){
					if(CanWalk(tX, gY1, dir, 1, false)){
						--Link->Y;
					}
				}
				if(Abs(gY2-tY)<=4){
					if(CanWalk(tX, gY2, dir, 1, false)){
						++Link->Y;
					}
				}
				break;
		}
	}
	int GetFacingPolarity(int linkDir, int misc){
		mapdata l1 = Game->LoadTempScreen(1);
		int x = Link->X+8;
		int y = Link->Y+12;
		while(x>=0&&x<=255&&y>=0&&y<=175){
			int pos = ComboAt(x, y);
			if(l1->ComboT[pos]==CT_MOONSTONEBLOCK){
				misc[2] = STATE_TIDALGAUNTLET_MOON;
				if(Link->Item[I_TIDALGAUNTLETSUN])
					return 1;
				else
					return -1;
			}
			else if(l1->ComboT[pos]==CT_SUNSTONEBLOCK){
				misc[2] = STATE_TIDALGAUNTLET_SUN;
				if(Link->Item[I_TIDALGAUNTLETSUN])
					return -1;
				else
					return 1;
			}
			x += DirX(linkDir, 16);
			y += DirY(linkDir, 16);
		}
		
		int w = linkDir<2?8:240;
		int h = linkDir<2?240:8;
		int collX = Link->X+8+DirX(linkDir, w/2)-w/2;
		int collY = Link->Y+8+DirY(linkDir, h/2)-h/2;
		int closestDist = 1000;
		int closestPolarity = -1;
		misc[0] = 0;
		misc[1] = 0;
		for(int i=1; i<=32; ++i){
			ffc f = Screen->LoadFFC(i);
			if(f->Script==FFCS_WALLGRAPPLE){
				//Screen->Rectangle(6, collX, collY, collX+w-1, collY+h-1, 0x08, 1, 0, 0, 0, true, 64);
				if(RectCollision(f->X, f->Y, f->X+15, f->Y+15, collX, collY, collX+w-1, collY+h-1)){
					if(Distance(f->X, f->Y, Link->X, Link->Y)<closestDist){
						bool superPull;
						int dir = f->Data%4;
						if(f->Data>=36740&&f->Data<=36747){
							dir += 4;
						}
						if(f->Data==38468||f->Data==38469){
							dir = linkDir;
							superPull = true;
						}
						int dir4 = Dir8ToDir4(dir, linkDir);
						if(dir4==linkDir){
							closestDist = Distance(f->X, f->Y, Link->X, Link->Y);
							if(f->Data>=36720&&f->Data<=36723){
								closestPolarity = STATE_TIDALGAUNTLET_SUN;
							}
							else if(f->Data>=36724&&f->Data<=36727){
								closestPolarity = STATE_TIDALGAUNTLET_MOON;
							}
							if(f->Data>=36740&&f->Data<=36743){
								closestPolarity = STATE_TIDALGAUNTLET_SUN;
							}
							else if(f->Data>=36744&&f->Data<=36747){
								closestPolarity = STATE_TIDALGAUNTLET_MOON;
							}
							if(f->Data==38468)
								closestPolarity = STATE_TIDALGAUNTLET_SUN;
							else if(f->Data==38469)
								closestPolarity = STATE_TIDALGAUNTLET_MOON;
							misc[0] = f->Vx;
							misc[1] = f->Vy;
							if(dir>3){
								if(dir4<2){
									if(f->Vx<0&&!CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false)&&(CanWalk(Link->X, Link->Y-8, DIR_LEFT, 1, false)||CanWalk(Link->X, Link->Y+8, DIR_LEFT, 1, false))){
										if(f->Vy<0)
											misc[1] -= 8;
										else if(f->Vy>0)
											misc[1] += 8;
									}
									if(f->Vx>0&&!CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false)&&(CanWalk(Link->X, Link->Y-8, DIR_RIGHT, 1, false)||CanWalk(Link->X, Link->Y+8, DIR_RIGHT, 1, false))){
										if(f->Vy<0)
											misc[1] -= 8;
										else if(f->Vy>0)
											misc[1] += 8;
									}
								}
								else{
									if(f->Vy<0&&!CanWalk(Link->X, Link->Y, DIR_UP, 1, false)&&(CanWalk(Link->X-8, Link->Y, DIR_UP, 1, false)||CanWalk(Link->X+8, Link->Y, DIR_UP, 1, false))){
										if(f->Vx<0)
											misc[0] -= 8;
										else if(f->Vx>0)
											misc[0] += 8;
									}
									if(f->Vy>0&&!CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false)&&(CanWalk(Link->X-8, Link->Y, DIR_DOWN, 1, false)||CanWalk(Link->X+8, Link->Y, DIR_DOWN, 1, false))){
										if(f->Vx<0)
											misc[0] -= 8;
										else if(f->Vx>0)
											misc[0] += 8;
									}
								}
							}
							
							
							if(dir4<2){
								int pixDist = Min(Abs(Link->X-Floor(f->X)), 4);
								if(Link->X<Floor(f->X)){
									misc[0] += pixDist;
								}
								if(Link->X>Floor(f->X)){
									misc[0] -= pixDist;
								}
								if(Link->Y>=f->Y-16&&Link->Y<=f->Y+8)
									misc[1] = 0;
							}
							else{
								int pixDist = Min(Abs(Link->Y-Floor(f->Y)), 4);
								if(Link->Y<Floor(f->Y)){
									misc[1] += pixDist;
								}
								if(Link->Y>Floor(f->Y)){
									misc[1] -= pixDist;
								}
								if(Abs(Link->X-Floor(f->X))<=16)
									misc[0] = 0;
							}
						}
					}
				}
			}
		}
		if(closestPolarity==STATE_TIDALGAUNTLET_MOON){
			misc[2] = STATE_TIDALGAUNTLET_MOON;
			if(Link->Item[I_TIDALGAUNTLETSUN])
				return 1;
			else
				return -1;
		}
		else if(closestPolarity==STATE_TIDALGAUNTLET_SUN){
			misc[2] = STATE_TIDALGAUNTLET_SUN;
			if(Link->Item[I_TIDALGAUNTLETSUN])
				return -1;
			else
				return 1;
		}
		return 0;
	}
	void run(){
		G[G_RERUNTIDALGAUNTLET] = 0;
		if(OnIce()){
			Game->PlaySound(SFX_ERROR);
			Quit();
		}
		
		int misc[3];
		int x; int y;
		int startDir = Link->Dir;
		itemdata tgm = Game->LoadItemData(I_TIDALGAUNTLETMOON);
		itemdata tgs = Game->LoadItemData(I_TIDALGAUNTLETSUN);
		
		bool solar = Link->Item[I_TIDALGAUNTLETSUN];
		int sfxTimer;
		while((ItemButtonHeld(tgm)||ItemButtonHeld(tgs))&&(Link->Action==LA_WALKING||Link->Action==LA_NONE)&&!OnIce()){
			x = Link->X+DirX(startDir, 16);
			y = Link->Y+DirY(startDir, 16);
			if(solar){
				if(sfxTimer==0)
					Game->PlaySound(SFX_GLOVESUN);
				if(sfxTimer==10)
					Game->PlaySound(SFX_GLOVESUN+1);
				Screen->DrawCombo(2, x, y, CMB_TIDALGAUNTLETPARTICLES+1, 1, 1, 8, -1, -1, x, y, DirAngle(startDir), -1, 0, true, 128);
			}
			else{
				if(sfxTimer==0)
					Game->PlaySound(SFX_GLOVEMOON);
				if(sfxTimer==10)
					Game->PlaySound(SFX_GLOVEMOON+1);
				Screen->DrawCombo(2, x, y, CMB_TIDALGAUNTLETPARTICLES, 1, 1, 7, -1, -1, x, y, DirAngle(startDir), -1, 0, true, 128);
			}
			if(GetFacingPolarity(startDir, misc)!=0&&!G[G_SPECIALMAGNETPULL]){
				int holdDir = GlobalInputOnlyDir();
				if(holdDir>-1){
					if(GetFacingPolarity(holdDir, misc)!=0){
						if(holdDir!=startDir){
							G[G_RERUNTIDALGAUNTLET] = 1;
							if(misc[2]==STATE_TIDALGAUNTLET_MOON)
								Link->Item[I_TIDALGAUNTLETSUN] = true;
							else
								Link->Item[I_TIDALGAUNTLETSUN] = false;
							startDir = holdDir;
							Link->Dir = holdDir;
							Quit();
						}
					}
				}
					
				int pullSpeed = 3*MagnetModifier2();
				G[G_MAGNETPULL] = GetFacingPolarity(startDir, misc);
				TryAlign(startDir, G[G_MAGNETPULL]);
				LinkMovement_Push2(DirX(startDir, pullSpeed)*G[G_MAGNETPULL], DirY(startDir, pullSpeed)*G[G_MAGNETPULL]);
				LinkMovement_Push2(misc[0], misc[1]);
				NoWalk();
				G[G_NOWALK] = 1;
				Link->Z = 2;
				Link->Jump = 0;
			}
			if(G[G_MAGNETPULL]==0){
				if(Link->Z==0)
					G[G_STEPMOD] -= 0.5;
				int w = startDir<2?16:240;
				int h = startDir<2?240:16;
				GLW[GL_MAGNETHITBOX] = MakeHitboxLW(LW_TIDALGAUNTLET, Link->X+8+DirX(startDir, 120)-w/2, Link->Y+8+DirY(startDir, 120)-h/2, w, h, 0, startDir);
				GLW[GL_MAGNETHITBOX]->CollDetection = false;
				GLW[GL_MAGNETHITBOX]->Damage = STATE_TIDALGAUNTLET_MOON;
				if(Link->Item[I_TIDALGAUNTLETSUN])
					GLW[GL_MAGNETHITBOX]->Damage = STATE_TIDALGAUNTLET_SUN;
			}
			sfxTimer = (sfxTimer+1)%20;
			if(G[G_SPECIALMAGNETPULL])
				startDir = Link->Dir;
			else
				G[G_FORCEDIR] = startDir;
			G[G_MAGNETACTIVE] = 2;
			Waitframe();
		}
		Link->Item[I_TIDALGAUNTLETSUN] = !Link->Item[I_TIDALGAUNTLETSUN];
		UpdateTidalGauntletButtons();
	}
}

void UpdateTidalGauntletButtons(){
	if(Link->Item[I_TIDALGAUNTLETSUN]){
		if(Link->ItemA==I_TIDALGAUNTLETSUN||Link->ItemA==I_TIDALGAUNTLETMOON)
			Link->ItemA = I_TIDALGAUNTLETSUN;
		if(Link->ItemB==I_TIDALGAUNTLETSUN||Link->ItemB==I_TIDALGAUNTLETMOON)
			Link->ItemB = I_TIDALGAUNTLETSUN;
		if(Link->ItemX==I_TIDALGAUNTLETSUN||Link->ItemX==I_TIDALGAUNTLETMOON)
			Link->ItemX = I_TIDALGAUNTLETSUN;
		if(Link->ItemY==I_TIDALGAUNTLETSUN||Link->ItemY==I_TIDALGAUNTLETMOON)
			Link->ItemY = I_TIDALGAUNTLETSUN;
	}
	else{
		if(Link->ItemA==I_TIDALGAUNTLETSUN||Link->ItemA==I_TIDALGAUNTLETMOON)
			Link->ItemA = I_TIDALGAUNTLETMOON;
		if(Link->ItemB==I_TIDALGAUNTLETSUN||Link->ItemB==I_TIDALGAUNTLETMOON)
			Link->ItemB = I_TIDALGAUNTLETMOON;
		if(Link->ItemX==I_TIDALGAUNTLETSUN||Link->ItemX==I_TIDALGAUNTLETMOON)
			Link->ItemX = I_TIDALGAUNTLETMOON;
		if(Link->ItemY==I_TIDALGAUNTLETSUN||Link->ItemY==I_TIDALGAUNTLETMOON)
			Link->ItemY = I_TIDALGAUNTLETMOON;
	}
}

const int I_STARWAND = I_WAND;
const int SFX_STARWAND = 32;
const int SFX_STARWANDEXPLOSION = 3;
const int SFX_STARWANDBLOCK_MOVE = 1;
const int SFX_STARWANDBLOCK_STOP = 1;

const int DAMAGE_STARWAND_BLOCK = 800;
const int STEP_STARWAND = 200;

const int LWS_STELLARWAND = 3;

lweapon script StarWand{
	void DrawExpandingRect(int layer, int x, int y, int angle, int rad, int c){
		int px[4];
		int py[4];
		for(int i=0; i<4; ++i){
			px[i] = x+VectorX(rad, angle+90*i);
			py[i] = y+VectorY(rad, angle+90*i);
		}
		Screen->Quad(layer, px[0], py[0], px[1], py[1], px[2], py[2], px[3], py[3], 1, 1, c, 0, -1, PT_FLAT);
	}
	bool StarWandIsSolid(int x, int y){
		int pos = ComboAt(x, y);
		mapdata l1 = Game->LoadTempScreen(1);
		return (Screen->isSolid(x, y) && !ComboFI(pos, CF_SCRIPT5) && !ComboFI(pos, CF_SCRIPT4)) || l1->ComboD[pos] == 38416;
	}
	bool StarWandCollision(int x, int y){
		return StarWandIsSolid(x+7, y+7) || StarWandIsSolid(x+8, y+7) || StarWandIsSolid(x+7, y+8) || StarWandIsSolid(x+8, y+8);
	}
	void run(){
		GLW[GL_WANDMAGIC] = this;
		this->UseSprite(SPR_STELLARSHOT);
		int reflections = 5;
		this->Step = STEP_STARWAND;
		if(HasAugment(I_AUGMENT_WAND)){
			this->Step += 150;
			this->Damage += 100;
		}
		bool held = true;
		mapdata l1 = Game->LoadTempScreen(1);
		bool noTurn = true; //Prevent turning on frame 1 due to collision bugs with star wand blocks
		while(true){
			if(held&&InputButtonItem(I_STARWAND)&&reflections>0){
				G[G_NOWALK] = 1;
				int oldVX = DirX(this->Dir, 1);
				int oldVY = DirY(this->Dir, 1);
				int vX = (G[G_LEFTINPUT]?-1:0) + (G[G_RIGHTINPUT]?1:0);
				int vY = (G[G_UPINPUT]?-1:0) + (G[G_DOWNINPUT]?1:0);
				if(!noTurn&&(vX!=0||vY!=0)){
					if(vX!=oldVX||vY!=oldVY){
						if(G[G_UPINPUT]==2||G[G_DOWNINPUT]==2||G[G_LEFTINPUT]==2||G[G_RIGHTINPUT]==2){
							this->UseSprite(SPR_STELLARRING);
							this->Rotation = 0;
							this->Step = 0;
							int tempVx; int tempVy;
							if(StarWandCollision(this->X, this->Y)){
								for(int i=0; i<8&&StarWandCollision(this->X, this->Y); ++i){
									this->X -= DirX(this->Dir, 1);
									this->Y -= DirY(this->Dir, 1);
								}
							}
							for(int i=0; i<16; ++i){
								if(InputButtonItem(I_STARWAND)){
									tempVx = (G[G_LEFTINPUT]?-1:0) + (G[G_RIGHTINPUT]?1:0);
									tempVy = (G[G_UPINPUT]?-1:0) + (G[G_DOWNINPUT]?1:0);
								}
								G[G_NOWALK] = 1;
								Waitframe();
							}
							if(tempVx!=0||tempVy!=0){
								vX = tempVx;
								vY = tempVy;
							}
							Game->PlaySound(SFX_STARWAND);
							this->UseSprite(SPR_STELLARSHOT);
							this->Dir = AngleDir8(Angle(0, 0, vX, vY));
							this->Step = STEP_STARWAND;
							if(HasAugment(I_AUGMENT_WAND))
								this->Step += 150;
							this->Damage += 40;
							--reflections;
						}
					}
				}
			}
			else
				held = false;
			this->Rotation = DirAngle(this->Dir);
			
			combodata cd = Game->LoadComboData(Screen->ComboD[ComboAt(this->X+8, this->Y+8)]);
			combodata cd1 = Game->LoadComboData(l1->ComboD[ComboAt(this->X+8, this->Y+8)]);
			if(cd->Type==CT_BLOCKALL&&(!Screen->isSolid(this->X+8, this->Y+8)||cd1->Script||Screen->ComboF[ComboAt(this->X+8, this->Y+8)]==CF_NOGROUNDENEMY)){
				this->CollDetection = false;
				this->DeadState = 0;
				Quit();
			}
			if(StarWandCollision(this->X, this->Y)||this->Misc[LWM_INSTANTDETONATE]){
				bool doExplode;
				if(this->Misc[LWM_INSTANTDETONATE])
					doExplode = true;
				if(this->Dir>=4){
					for(int i=0; i<4&&StarWandCollision(this->X, this->Y); ++i){
						this->X -= DirX(this->Dir, 1);
						this->Y -= DirY(this->Dir, 1);
					}
					int moveDir = this->Dir;
					switch(this->Dir){
						case DIR_LEFTUP:
							if(!StarWandCollision(this->X, this->Y-1))
								moveDir = DIR_UP;
							else if(!StarWandCollision(this->X-1, this->Y))
								moveDir = DIR_LEFT;	
							break;
						case DIR_RIGHTUP:
							if(!StarWandCollision(this->X, this->Y-1))
								moveDir = DIR_UP;
							else if(!StarWandCollision(this->X+1, this->Y))
								moveDir = DIR_RIGHT;
							break;
						case DIR_LEFTDOWN:
							if(!StarWandCollision(this->X, this->Y+1))
								moveDir = DIR_DOWN;
							else if(!StarWandCollision(this->X-1, this->Y))
								moveDir = DIR_LEFT;	
							break;
						case DIR_RIGHTDOWN:
							if(!StarWandCollision(this->X, this->Y+1))
								moveDir = DIR_DOWN;
							else if(!StarWandCollision(this->X+1, this->Y))
								moveDir = DIR_RIGHT;
							break;
					}
					if(moveDir<4){
						this->UseSprite(SPR_STELLARRING);
						this->Rotation = 0;
						this->Step = 0;
						for(int i=0; i<16; ++i){
							G[G_NOWALK] = 1;
							Waitframe();
						}
						Game->PlaySound(SFX_STARWAND);
						this->UseSprite(SPR_STELLARSHOT);
						this->Dir = moveDir;
						this->Step = STEP_STARWAND;
						if(HasAugment(I_AUGMENT_WAND))
							this->Step += 150;
					}
					else
						doExplode = true;
				}
				else
					doExplode = true;
				
				if(doExplode){
					int angle = DirAngle(this->Dir);
					this->DrawYOffset = -1000;
					this->CollDetection = false;
					this->Step = 0;
					this->DeadState = WDS_ALIVE;
					Game->PlaySound(SFX_BOMB);
					for(int i=8; i<48; ++i){
						int len = Min(i*1.5, 24);
						if(i<40||i%2==0){
							DrawExpandingRect(4, this->X+8+VectorX(i/3, angle), this->Y+8+VectorY(i/3, angle), angle+10*i, len, Choose(0x91, 0x96, 0x97));
							DrawExpandingRect(4, this->X+8+VectorX(i/3, angle), this->Y+8+VectorY(i/3, angle), angle+10*i+45, len, Choose(0x91, 0x96, 0x97));
						}
						MakeHitboxLW(LW_STARWANDIMPACT, this->X+8-len*0.7+VectorX(i/3, angle), this->Y+8-len*0.7+VectorY(i/3, angle), len*1.4, len*1.4, this->Damage, this->Dir);
						lweapon impactCenter = MakeHitboxLW(LW_STARWANDIMPACT, this->X+8-1+VectorX(i/3, angle), this->Y+8-1+VectorY(i/3, angle), 2, 2, 1, this->Dir);
						impactCenter->CollDetection = false;
						Waitframe();
					}
					this->DeadState = 0;
					Quit();
				}
			}
			
			noTurn = false;
			Waitframe();
		}
	}
}

itemdata script HeartPickup{
	void run(){
		if(Link->HP<Link->MaxHP){
			Link->HP = Min(Link->HP+16, Link->MaxHP);
		}
		else{
			int lowestID = GetCharID();
			int lowestCount = 1000;
			
			switch(lowestID){
				case CHAR_ASHER: G[G_ASHERHP] = Link->HP; break;
				case CHAR_TORRIN: G[G_TORRINHP] = Link->HP; break;
				case CHAR_KAYLANI: G[G_KAYLANIHP] = Link->HP; break;
				case CHAR_SOREN: G[G_SORENHP] = Link->HP; break;
				case CHAR_TERRY: G[G_TERRYHP] = Link->HP; break;
				case CHAR_SIYED: G[G_SIYEDHP] = Link->HP; break;
			}
			if(Link->Item[I_ASHER]&&G[G_ASHERHP]>0&&G[G_ASHERHP]<G[G_ASHERMAXHP]&&G[G_ASHERHP]<lowestCount){
				lowestID = CHAR_ASHER;
				lowestCount = G[G_ASHERHP];
			}
			if(Link->Item[I_TORRIN]&&G[G_TORRINHP]>0&&G[G_TORRINHP]<G[G_TORRINMAXHP]&&G[G_TORRINHP]<lowestCount){
				lowestID = CHAR_TORRIN;
				lowestCount = G[G_TORRINHP];
			}
			if(Link->Item[I_KAYLANI]&&G[G_KAYLANIHP]>0&&G[G_KAYLANIHP]<G[G_KAYLANIMAXHP]&&G[G_KAYLANIHP]<lowestCount){
				lowestID = CHAR_KAYLANI;
				lowestCount = G[G_KAYLANIHP];
			}
			if(Link->Item[I_SOREN]&&G[G_SORENHP]>0&&G[G_SORENHP]<G[G_SORENMAXHP]&&G[G_SORENHP]<lowestCount){
				lowestID = CHAR_SOREN;
				lowestCount = G[G_SORENHP];
			}
			if(Link->Item[I_TERRY]&&G[G_TERRYHP]>0&&G[G_TERRYHP]<G[G_TERRYMAXHP]&&G[G_TERRYHP]<lowestCount){
				lowestID = CHAR_TERRY;
				lowestCount = G[G_TERRYHP];
			}
			if(Link->Item[I_SIYED]&&G[G_SIYEDHP]>0&&G[G_SIYEDHP]<G[G_SIYEDMAXHP]&&G[G_SIYEDHP]<lowestCount){
				lowestID = CHAR_SIYED;
				lowestCount = G[G_SIYEDHP];
			}
			
			switch(lowestID){
				case CHAR_ASHER:
					G[G_ASHERHP] = Min(G[G_ASHERHP]+16, G[G_ASHERMAXHP]);
					break;
				case CHAR_TORRIN:
					G[G_TORRINHP] = Min(G[G_TORRINHP]+16, G[G_TORRINMAXHP]);
					break;
				case CHAR_KAYLANI:
					G[G_KAYLANIHP] = Min(G[G_KAYLANIHP]+16, G[G_KAYLANIMAXHP]);
					break;
				case CHAR_SOREN:
					G[G_SORENHP] = Min(G[G_SORENHP]+16, G[G_SORENMAXHP]);
					break;
				case CHAR_TERRY:
					G[G_TERRYHP] = Min(G[G_TERRYHP]+16, G[G_TERRYMAXHP]);
					break;
				case CHAR_SIYED:
					G[G_SIYEDHP] = Min(G[G_SIYEDHP]+16, G[G_SIYEDMAXHP]);
					break;
			}
		}
	}
}

itemdata script MagicPickup{
	void run(){
		if(Link->MP<Link->MaxMP&&GetCharID()!=CHAR_TORRIN&&!(GetCharID()==CHAR_ASHER&&Game->Counter[CR_STORYFLAG]<SFLAG_ASHERRESCUED)){
			Quit();
		}
		else{
			int fillAmount = 64;
			if(this->ID==60)
				fillAmount = 256;
			
			int lowestID = GetCharID();
			int lowestCount = 1000;
			
			switch(lowestID){
				case CHAR_ASHER: G[G_ASHERMP] = Link->MP; break;
				case CHAR_KAYLANI: G[G_KAYLANIMP] = Link->MP; break;
				case CHAR_SIYED: G[G_SIYEDMP] = Link->MP; break;
			}
			if(Link->Item[I_ASHER]&&G[G_ASHERHP]>0&&G[G_ASHERMP]<Link->MaxMP&&G[G_ASHERMP]<lowestCount){
				lowestID = CHAR_ASHER;
				lowestCount = G[G_ASHERMP];
			}
			if(Link->Item[I_KAYLANI]&&G[G_KAYLANIHP]>0&&G[G_KAYLANIMP]<Link->MaxMP&&G[G_KAYLANIMP]<lowestCount){
				lowestID = CHAR_KAYLANI;
				lowestCount = G[G_KAYLANIMP];
			}
			if(Link->Item[I_SIYED]&&G[G_SIYEDHP]>0&&G[G_SIYEDMP]<Link->MaxMP&&G[G_SIYEDMP]<lowestCount){
				lowestID = CHAR_SIYED;
				lowestCount = G[G_SIYEDMP];
			}
			
			switch(lowestID){
				case CHAR_ASHER:
					G[G_ASHERMP] = Min(G[G_ASHERMP]+fillAmount, Link->MaxMP);
					break;
				case CHAR_KAYLANI:
					G[G_KAYLANIMP] = Min(G[G_KAYLANIMP]+fillAmount, Link->MaxMP);
					break;
				case CHAR_SIYED:
					G[G_SIYEDMP] = Min(G[G_SIYEDMP]+fillAmount, Link->MaxMP);
					break;
			}
		}
	}
}

itemsprite script HeartSprite{
	void run(int til){
		if(Link->HP>=Link->MaxHP){
			int oldID = GetCharID();
			int newID = GetSwapCharID(oldID, 1, true);
			if(newID==oldID){
				this->Remove();
				Quit();
			}
		}
		this->OriginalTile = 63770;
		this->Tile = this->OriginalTile;
	}
}

itemsprite script MagicSprite{
	void run(int til){
		if(!Link->Item[I_KAYLANI]&&!G[G_RANDOMIZERENABLED]){
			this->Remove();
			Quit();
		}
		this->OriginalTile = til;
		this->Tile = til;
		// while(true){
			// bool noMagic;
			// if(GetCharID()==CHAR_TORRIN||(GetCharID()==CHAR_ASHER&&!Link->Item[I_ABILITY_B_ASHER]))
				// noMagic = true;
			// if(noMagic)
				// this->Pickup |= IP_DUMMY;
			// else
				// this->Pickup &= ~IP_DUMMY;
			// Waitframe();
		// }
	}
}

const int I_LOBBOMB = 144;

itemsprite script BombSprite{
	void run(int til){
		if(!FoundItems[I_LOBBOMB] && !FoundItems[I_ABILITY_B_SOREN]){
			if(Game->GetCurDMap() != 3){ //Don't remove useless bomb pickups in Pala shop
				this->Remove();
				Quit();
			}
		}
		this->OriginalTile = til;
		this->Tile = til;
	}
}

const int I_LANTERN = 155;

itemdata script CandleGivesLantern{
	void run(){
		Link->Item[I_LANTERN] = true;
		eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
		e->CollDetection = false;
		e->DrawYOffset = -1000;
		RunEWeaponScript(e, "ItemPopup", {this->ID});
		FoundItems[this->ID] = true;
	}
}

itemdata script ItemPopupPickup{
	void run(){
		eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
		e->CollDetection = false;
		e->DrawYOffset = -1000;
		RunEWeaponScript(e, "ItemPopup", {this->ID});
		// if(Game->GetCurMap() == 
		if(this->ID == 181){
			Game->Counter[CR_ASHERSIDEQUEST] = 3;
		}
		FoundItems[this->ID] = true;
	}
}

itemdata script ItemPopupHymnstone{
	void run(){
		++LevelHymnstonesFound[Game->GetCurLevel()];
		++Game->Counter[CR_TOTALHYMNSTONES];
		if(G[G_RANDOMIZERENABLED]){
			if(G[G_RANDOMIZERMODE]==1&&!G[G_WONHYMNSTONEHUNT]){
				if(Game->Counter[CR_TOTALHYMNSTONES]>=G[G_RANDOMIZERREQUIREDHYMNSTONES]){
					genericdata gd = Game->LoadGenericData(Game->GetGenericScript("LastHymnstoneGet"));
					gd->ReloadState[GENSCR_ST_RELOAD] = true;
					gd->ReloadState[GENSCR_ST_CONTINUE] = true;
					gd->Running = true;
				}
			}
		}
		eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
		e->CollDetection = false;
		e->DrawYOffset = -1000;
		RunEWeaponScript(e, "ItemPopup", {this->ID});
	}
}

const int SPR_TORRINPUNCH = 95;
const int I_FISTUPGRADE = 208;

itemdata script MikeTorrinsPunchout{
	void run(int enableLockon){
		if(!Link->Item[I_FISTUPGRADE])
			enableLockon = 0;
		if(Link->SwordJinx==0){
			Link->Action = LA_ATTACKING;
			Game->PlaySound(SFX_SWORD);
			lweapon l = CreateLWeaponAt(LW_SCRIPT10, Link->X, Link->Y);
			RunLWeaponScript(l, "TorrinPunchWeapon", {enableLockon, this->ID});
			l->UseSprite(SPR_TORRINPUNCH);
			l->Damage = this->Power*2;
			l->Dir = Link->Dir;
			l->CollDetection = false;
		}
	}
}

const int TIL_TORRINPUNCHPROJECTILE = 65177;

lweapon script TorrinPunchWeapon{
	void run(int enableLockon, int sourceID, int TerryProjectile){
		if(TerryProjectile){
			while(true){
				G[G_HADOUKENCOOLDOWN] = 8;
				if(this->Misc[LWM_HITBY]!=0){
					npc hit = Screen->LoadNPCByUID(this->Misc[LWM_HITBY]);
					G[G_TERRYSPEEDTIMER] = 90;
				}
				Waitframe();
			}
		}
		this->Rotation = DirAngle(this->Dir);
		lweapon hitbox = CreateLWeaponAt(LW_PHYSICAL, this->X, this->Y);
		hitbox->HitXOffset = DirX(Link->Dir, 16);
		hitbox->HitYOffset = DirY(Link->Dir, 16);
		hitbox->Dir = Link->Dir;
		hitbox->Damage = this->Damage;
		hitbox->DrawYOffset = -1000;
		npc target;
		lweapon projectile;
		bool terrySpeedBoosted;
		if(HasAugment(I_AUGMENT_THROWPUNCH)){
			projectile = CreateLWeaponAt(LW_PHYSICAL, hitbox->X, hitbox->Y);
			projectile->Y+=Link->DrawYOffset;
			projectile->OriginalTile = TIL_TORRINPUNCHPROJECTILE;
			projectile->Tile = projectile->OriginalTile;
			projectile->Damage = this->Damage;
			projectile->Step = 320;
			projectile->Dir = Link->Dir;
			projectile->Rotation = DirAngle(Link->Dir);
		}
		for(int i=0; i<10; ++i){
			this->X = Link->X;
			this->Y = Link->Y;
			this->DrawXOffset = DirX(Link->Dir, 16);
			this->DrawYOffset = DirY(Link->Dir, 16);
			this->HitXOffset = DirX(Link->Dir, 16);
			this->HitYOffset = DirY(Link->Dir, 16);
			if(!hitbox->isValid()){
				hitbox = CreateLWeaponAt(LW_PHYSICAL, this->X, this->Y);
				hitbox->HitXOffset = DirX(Link->Dir, 16);
				hitbox->HitYOffset = DirY(Link->Dir, 16);
				hitbox->Dir = Link->Dir;
				hitbox->Damage = this->Damage;
				hitbox->DrawYOffset = -1000;
			}
			if(projectile->isValid()){
				GrabItems(projectile);
				projectile->DeadState = -1;
				if(i>8){
					projectile->OriginalTile = TIL_TORRINPUNCHPROJECTILE+2;
					projectile->Tile = projectile->OriginalTile;
				}
				else if(i>6){
					projectile->OriginalTile = TIL_TORRINPUNCHPROJECTILE+1;
					projectile->Tile = projectile->OriginalTile;
				}
				if(projectile->Misc[LWM_HITBY]!=0){
					npc hit = Screen->LoadNPCByUID(projectile->Misc[LWM_HITBY]);
					if(hit->Misc[NPCM_STUNCOOLDOWN]<=0)
						hit->Stun = Max(20, hit->Stun);
					if(!target->isValid()&&(hit->HP>0||GetCharID()==CHAR_TERRY)&&enableLockon){
						target = hit;
						if(GetCharID()==CHAR_TERRY)
							G[G_TERRYSPEEDTIMER] = 90;
					}
					projectile->DeadState = 0;
				}
			}
			if(hitbox->Misc[LWM_HITBY]!=0){
				npc hit = Screen->LoadNPCByUID(hitbox->Misc[LWM_HITBY]);
				if(hit->Misc[NPCM_STUNCOOLDOWN]<=0)
					hit->Stun = Max(20, hit->Stun);
				if(!target->isValid()&&(hit->HP>0||GetCharID()==CHAR_TERRY)&&enableLockon){
					target = hit;
					if(GetCharID()==CHAR_TERRY)
						G[G_TERRYSPEEDTIMER] = 90;
				}
			}
			MakeSwordHitbox(this->X+this->HitXOffset, this->Y+this->HitYOffset);
			G[G_NOWALK] = 1;
			Waitframe();
		}
		if(projectile->isValid()){
			projectile->DeadState = 0;
		}
		if(GetCharID()==CHAR_TORRIN){
			if(enableLockon&&InputButtonItem(sourceID)){
				if(G[G_TORRINLOCKON]){
					G[G_TORRINLOCKON] = 0;
				}
				else{
					if(target->isValid()){
						G[G_TORRINLOCKON] = 1;
						G[G_TORRINLOCKONTARGET] = target->UID;
						G[G_TORRINLOCKONTARGETX] = HitboxCenterX(target)-8;
						G[G_TORRINLOCKONTARGETY] = HitboxCenterY(target)-8;
					}
					else if(HasAugment(I_AUGMENT_AUTOLOCK)){
						npc closest;
						int closestDist = 1000;
						for(int i=Screen->NumNPCs(); i>0; --i){
							npc n = Screen->LoadNPC(i);
							if(n->Defense[NPCD_SCRIPT3]!=NPCDT_IGNORE&&n->Defense[NPCD_SCRIPT3]!=NPCDT_BLOCK){
								int dist = Distance(CenterLinkX(), CenterLinkY(), CenterX(n), CenterY(n));
								dist *= 1+(Abs(AngDiff(Angle(CenterLinkX(), CenterLinkY(), CenterX(n), CenterY(n)), DirAngle(Link->Dir)))/90);
								if(dist<closestDist){
									closest = n;
									closestDist = dist;
								}
							}
						}
						if(closest->isValid()){
							G[G_TORRINLOCKON] = 1;
							G[G_TORRINLOCKONTARGET] = closest->UID;
							G[G_TORRINLOCKONTARGETX] = HitboxCenterX(closest)-8;
							G[G_TORRINLOCKONTARGETY] = HitboxCenterY(closest)-8;
						}
					}
				}
			}
		}
		else if(GetCharID()==CHAR_TERRY&&HasAugment(I_AUGMENT_HADOUKEN)&&Link->HP>=Link->MaxHP&&!G[G_HADOUKENCOOLDOWN]){
			lweapon hadouken = FireLWeapon(LW_PHYSICAL, this->X, this->Y, DirAngle(this->Dir), 250, Ceiling(this->Damage*0.75), 126, 93);
			hadouken->Rotation = DirAngle(this->Dir);
			RunLWeaponScript(hadouken, "TorrinPunchWeapon", {0, sourceID, 1});
		}
		if(hitbox->isValid())
			hitbox->DeadState = 0;
		this->DeadState = 0;
	}
}

const int DAMAGE_PHARAOHSHOT = 600;

const int SFX_PHARAOHSHOT_CHARGED = 35;
const int SFX_PHARAOHSHOT_CHARGED2 = 36;
const int SFX_PHARAOHSHOT_FIRE = 32;

itemdata script PharaohShot{
	void DrawRipples(int ripples){
		int layer = 2;
		if(ScreenFlag(1, 4)) //Layer -2
			layer = 1;
		int pAng = ripples[1];
		int pDist = ripples[2];
		++ripples[0];
		ripples[0]%=32;
		int r = Lerp(0, 12, ripples[0]/31);
		int c = 0x86;
		if(ripples[0]>=16)
			c = 0x88;
		if(ripples[0]>=8)
			c = 0x87;
		for(int i=0; i<2; ++i){
			Screen->Ellipse(layer, Link->X+8, Link->Y+15, r+i, r*0.6666+i, c, 1, 0, 0, 0, false, ripples[0]<24?128:64);
		}
		
		for(int i=0; i<6; ++i){
			++pDist[i];
			if(pDist[i]>40){
				pDist[i] = Rand(-8, 0);
				pAng[i] = Rand(360);
			}
			int dist = Lerp(0, 16, pDist[i]/40);
			if(pDist[i]>=0){
				int x = Link->X+8+VectorX(dist, pAng[i]);
				int y = Link->Y+15+0.6666*VectorY(dist, pAng[i]);
				Screen->PutPixel(layer, x, y, 0x01, 0, 0, 0, dist<8?128:64);
			}
		}
		for(int xi = 0; xi<3; ++xi){
			for(int yi = 0; yi<2; ++yi){
				int x = Link->X+Lerp(-1, 16, xi/2);
				int y = Link->Y+Lerp(7, 17, yi);
				int pos = ComboAt(x, y);
				int ct = Screen->ComboT[pos];
				switch(ct){
					case CT_SLASHNEXT:
					case CT_SLASHNEXTC:
					case CT_SLASHNEXTITEMC:
					case CT_BUSHNEXT:
					case CT_BUSHNEXTC:
					case CT_TALLGRASSNEXT:
						lweapon cutter = CreateLWeaponAt(LW_SCRIPT10, ComboX(pos), ComboY(pos));
						cutter->Weapon = LW_SWORD;
						cutter->DeadState = 1;
						cutter->DrawYOffset = -1000;
						cutter->CollDetection = false;
						break;
				}
			}
		}
	}
	lweapon DrawBigShot(int layer, int x, int y, int rad, int damage, int dir, int i, int flash){
		int r = rad+2*Sin(i);
		int clr[3] = {0x88, 0x86, 0x81};
		if(flash==0){
			clr[0] = 0x88;
			clr[1] = 0x87;
			clr[2] = 0x86;
		}
		if(flash==2){
			clr[0] = 0x86;
			clr[1] = 0x81;
			clr[2] = 0x81;
		}
		Screen->Circle(layer, x, y, rad+2*Sin(i), clr[0], 1, 0, 0, 0, true, 128);
		Screen->Circle(layer, x, y, rad*0.875+2*Sin(i), clr[1], 1, 0, 0, 0, true, 128);
		Screen->Circle(layer, x, y, rad*0.625+2*Sin(i), clr[2], 1, 0, 0, 0, true, 128);
		lweapon hitbox;
		if(damage){
			hitbox = MakeHitboxLW(LW_SOLAR, x-r*0.7071, y-r*0.7071, r*2*0.7071, r*2*0.7071, damage, dir);
		}
		lweapon glow = CreateLWeaponAt(LW_BAIT, x-8, y-8);
		glow->MoveFlags[WPNMV_CAN_PITFALL] = false;
		glow->DrawYOffset = -1000;
		glow->Script = LWS_ONEFRAME;
		glow->CollDetection = false;
		DarkRoom_AddLight(x, y, 0, rad+16, 1, 0, 0, 0);
		return hitbox;
	}
	void SetCastAnim(int frame, bool attackPhase){
		int walkUp = 104620;
		int walkDown = 104540;
		int walkSide = 104580;
		
		int casting = 104660;
		
		if(GetCharID()==CHAR_SIYED){
			walkUp = 101506;
			walkDown = 101500;
			walkSide = 101503;
			
			casting = 101509;
		}
		
		if(!attackPhase){
			switch(Link->Dir){
				case DIR_UP:
					SetLinkScriptTile(walkUp+frame, 0, 2);
					break;
				case DIR_DOWN:
					SetLinkScriptTile(walkDown+frame, 0, 2);
					break;
				case DIR_LEFT:
					SetLinkScriptTile(walkSide+frame, 0, 2);
					break;
				case DIR_RIGHT:
					SetLinkScriptTile(walkSide+frame, 1, 2);
					break;
			}
		}
		else{
			switch(Link->Dir){
				case DIR_UP:
					SetLinkScriptTile(casting+2, 0, 2);
					break;
				case DIR_DOWN:
					SetLinkScriptTile(casting, 0, 2);
					break;
				case DIR_LEFT:
					SetLinkScriptTile(casting+1, 0, 2);
					break;
				case DIR_RIGHT:
					SetLinkScriptTile(casting+1, 1, 2);
					break;
			}
		}
	}
	void run(int allowExtraCharge){
		// if(Link->MP==0)
			// Quit();
		
		int pAng[16];
		int pDist[16];
		int ripples[] = {0, pAng, pDist};
		
		for(int i=0; i<16; ++i){
			pAng[i] = Rand(360);
			pDist[i] = -Rand(16);
		}
		
		int chargeMax1 = 80;
		int chargeMax2 = 180;
		if(GetCharID()==CHAR_SIYED){
			chargeMax1 = 40;
			chargeMax2 = 80;
		}
		else{
			if(HasAugment(I_AUGMENT_CHARGE)){
				chargeMax1 = 60;
				chargeMax2 = 120;
			}
		}
		int damage = DAMAGE_PHARAOHSHOT;
		if(GetCharID()==CHAR_SIYED)
			damage = 450;
		int stepCounter;
		int chargeCounter;
		int ballX;
		int ballY;
		int maxSize = 6;
		while((GetCharID()==CHAR_KAYLANI||GetCharID()==CHAR_SIYED)&&InputButtonItem(this->ID)&&(CanAttack(true)||Link->Action==LA_GOTHURTLAND)){
			if(Link->Action==LA_WALKING)
				stepCounter = (stepCounter+1)%5040;
			if(chargeCounter<360)
				++chargeCounter;
			if(chargeCounter==chargeMax1)
				Game->PlaySound(SFX_PHARAOHSHOT_CHARGED);
			if(chargeCounter==chargeMax2&&allowExtraCharge){
				Game->PlaySound(SFX_PHARAOHSHOT_CHARGED2);
				maxSize = 10;
			}
			int chargePercent = Min(chargeCounter, chargeMax1)/chargeMax1;
			int frame = (Floor(stepCounter/7)%4);
			if(frame==2)
				frame = 0;
			if(frame==3)
				frame = 2;
			if(GetCharID()==CHAR_SIYED)
				G[G_STEPMOD] -= 0.5;
			else
				G[G_STEPMOD] -= 0.3;
			SetCastAnim(frame, false);
			ballX = Link->X+8;
			ballY = Link->Y-8-4*chargePercent;
			ballY+=Link->DrawYOffset;
			if(Link->Action!=LA_SCROLLING)
				DrawBigShot(4, ballX, ballY, 2+maxSize*chargePercent, 0, Link->Dir, G[G_ANIM]*4, G[G_ANIM]%4);
			if(chargeCounter>=chargeMax1&&G[G_RANDOMIZERENABLED])
				DrawRipples(ripples);
			Waitframe();
		}
		if(chargeCounter>=chargeMax1&&CanAttack()&&(GetCharID()==CHAR_KAYLANI||GetCharID()==CHAR_SIYED)){
			int ballCurveX = Link->X+8;
			int ballCurveY = Link->Y+8;
			int ballDestX = Link->X+8+DirX(Link->Dir, 16);
			int ballDestY = Link->Y+8+DirY(Link->Dir, 16);
			int dir = Link->Dir;
			int layer = 4;
			if(Link->Dir==DIR_UP)
				layer = 2;
			lweapon hitbox;
			bool siyedShotUpgrade;
			//Link->MP = Max(Link->MP-8, 0);
			Game->PlaySound(SFX_PHARAOHSHOT_FIRE);
			if(chargeCounter>=chargeMax2&&allowExtraCharge)
				damage += 200;
			for(int i=0; i<8&&Link->Action!=LA_SCROLLING; ++i){
				int xy[2];
				BezierQuadFrame(xy, i, 8, ballX, ballY, ballCurveX, ballCurveY, ballDestX, ballDestY);
				if(hitbox->isValid()){
					if(hitbox->Misc[LWM_HITBY]){
						npc hit = Screen->LoadNPCByUID(hitbox->Misc[LWM_HITBY]);
						if(hit->isValid()){
							if(hit->Misc[NPCM_FLAGS]&NPCMF_SIYEDMARKED)
								siyedShotUpgrade = true;
						}
					}
				}
				hitbox = DrawBigShot(layer, xy[0], xy[1], 2+maxSize, damage, dir, G[G_ANIM]*4, G[G_ANIM]%4);
				G[G_NOACTION] = 1;
				SetCastAnim(0, true);
				Waitframe();
			}
			int scale = 2+maxSize;
			int shotframes = 8;
			int scaleBoost = 0;
			if(HasAugment(I_AUGMENT_RANGESIYED)){
				scaleBoost = 1;
			}
			ballX = ballDestX;
			ballY = ballDestY;
			ballY+=Link->DrawYOffset;
			int pointFrames = 8;
			if(GetCharID()==CHAR_SIYED)
				shotframes = 4;
			int travelFrames;
			while(scale>0&&(ballX>0-scale&&ballX<255+scale&&ballY>0-scale&&ballY<175+scale)&&Link->Action!=LA_SCROLLING){
				if(shotframes)
					--shotframes;
				else{
					++travelFrames;
					if(chargeCounter>=chargeMax2&&allowExtraCharge){
						if(GetCharID()==CHAR_SIYED){
							if(siyedShotUpgrade){
								scale += 1.25+scaleBoost;
							}
							else{
								if(travelFrames<12)
									scale += 3+scaleBoost;
								else{
									if(HasAugment(I_AUGMENT_RANGESIYED))
										scale -= 1;
									else
										scale -= 1.5;
								}
							}
						}
						else{
							if(HasAugment(I_AUGMENT_RANGE))
								scale += 1.25;
							else 
								scale += 0.75;
						}
					}
					else{
						if(GetCharID()==CHAR_SIYED){
							if(siyedShotUpgrade){
								scale += 1.25+scaleBoost;
							}
							else{
								if(HasAugment(I_AUGMENT_RANGESIYED))
									scale -= 0.3333;
								else
									scale -= 2;
							}
						}
						else{
							if(HasAugment(I_AUGMENT_RANGE))
								scale -= 0.5;
							else
								scale -= 1;
						}
					}
				}
				ballX += DirX(dir, 4);
				ballY += DirY(dir, 4);
				if(hitbox->isValid()){
					if(hitbox->Misc[LWM_HITBY]){
						npc hit = Screen->LoadNPCByUID(hitbox->Misc[LWM_HITBY]);
						if(hit->isValid()){
							if(hit->Misc[NPCM_FLAGS]&NPCMF_SIYEDMARKED)
								siyedShotUpgrade = true;
						}
					}
				}
				hitbox = DrawBigShot(2, ballX, ballY, scale, damage, dir, G[G_ANIM]*4, G[G_ANIM]%4);
				if(pointFrames>0){
					--pointFrames;
					G[G_NOACTION] = 1;
					SetCastAnim(0, true);
				}
				MakeSwordHitbox(ballX-8, ballY-8);
				Waitframe();
			}
		}
	}
}

itemdata script ReflectorSword{
	void run(){
		while(NumLWeaponsOf(LW_SWORD)==0)
			Waitframe();
		lweapon sword = LoadLWeaponOf(LW_SWORD);
		while(sword->isValid()){
			for(int i=Screen->NumEWeapons(); i>0; --i){
				eweapon e = Screen->LoadEWeapon(i);
				if(e->CollDetection&&e->DeadState==WDS_ALIVE){
					if(Collision(e, sword)){
						if(IsBlockable(e)&&e->Type!=EW_BOMBBLAST&&!(e->Misc[EWM_FLAGS]&EWMF_NOREFLECT)){
							lweapon l = CreateLWeaponAt(LW_STELLAR, e->X, e->Y);
							l->Angular = true;
							l->Rotation = Angle(Link->X, Link->Y, e->X, e->Y);
							l->Angle = DegtoRad(l->Rotation);
							l->Step = 100;
							l->Damage = 400;
							l->OriginalTile = 65015;
							l->Tile = 65015;
							l->CSet = 10;
							e->DeadState = 0;
							e->Misc[EWM_FLAGS] |= EWMF_REFLECTED;
							RunLWeaponScript(l, "ReflectorSwordShot", {0});
							if(HasAugment(I_AUGMENT_REFLECT)){
								for(int j=-2; j<=2; ++j){
									if(j!=0){
										lweapon l = CreateLWeaponAt(LW_STELLAR, e->X, e->Y);
										l->Angular = true;
										l->Rotation = Angle(Link->X, Link->Y, e->X, e->Y)+15*j;
										l->Angle = DegtoRad(l->Rotation);
										l->Step = 100;
										l->Damage = 400;
										l->OriginalTile = 65015;
										l->Tile = 65015;
										l->CSet = 10;
										e->DeadState = 0;
										e->Misc[EWM_FLAGS] |= EWMF_REFLECTED;
										RunLWeaponScript(l, "ReflectorSwordShot", 0);
									}
								}
							}
						}
					}
				}
			}
			Waitframe();
		}
	}
}

lweapon script ReflectorSwordShot{
	void run(){
		for(int i=0; i<8; ++i){
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		++this->Tile;
		this->Step = 200;
		for(int i=0; i<8; ++i){
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		++this->Tile;
		this->Step = 400;
		while(true){
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
	}
}

const int SFX_ENGINECLEAVER_CHARGE = SFX_CHARGE1;
const int SFX_ENGINECLEAVER_CHARGE2 = SFX_CHARGE2;

itemdata script EngineCleaver{
	void run(){
		while(NumLWeaponsOf(LW_SWORD)==0)
			Waitframe();
		lweapon sword = LoadLWeaponOf(LW_SWORD);
		bool heldSword = true;
		bool enemyCollision;
		int oldCharges = G[G_SORENCHARGE];
		int chargeWindow = 6;
		if(HasAugment(I_AUGMENT_FLASHCHARGE))
			chargeWindow = 2;
		while(sword->isValid()){
			npc collided;
			for(int i=Screen->NumNPCs(); i>0; --i){
				npc n = Screen->LoadNPC(i);
				int hit = n->HitBy[2];
				if(hit>0){
					lweapon l = Screen->LoadLWeapon(hit);
					if(l==sword){
						collided = n;
						break;
					}
				}
			}
			if(!InputButtonItemGlobal(this->ID)||G[G_SORENCHARGE]==3){
				if(!InputButtonItemGlobal(this->ID))
					heldSword = false;
				if(collided->isValid()&&!enemyCollision&&G[G_SORENCHARGE]>0){
					int oldDamage = this->Damage*4;
					G[G_SORENCHARGE] = 0;
					CopyTile(67280+G[G_SORENCHARGE], 67320);
					this->Damage = 150+25*G[G_SORENCHARGE];
					enemyCollision = true;
					genericdata gd = Game->LoadGenericData(Game->GetGenericScript("EngineCleaverFreeze"));
					gd->InitD[0] = Link->X;
					gd->InitD[1] = Link->Y-8;
					gd->RunFrozen();
					int count = oldCharges;
					if(HasAugment(I_AUGMENT_LINGERINGFLAME))
						count *= 2;
					for(int i=0; i<count; ++i){
						int angle = DirAngle(Link->Dir)+Rand(-30, 30);
						int rotDir = -1;
						if(Link->Dir==DIR_RIGHT)
							rotDir = 1;
						Game->PlaySound(88);
						lweapon swipe = CreateLWeaponAt(LW_SCRIPT10, Link->X+VectorX(24, angle)+Rand(-8, 8), Link->Y+VectorY(24, angle)+Rand(-8, 8));
						swipe->CollDetection = false;
						swipe->DrawYOffset = -1000;
						swipe->Damage = oldDamage;
						RunLWeaponScript(swipe, "SwipeFire", {angle, rotDir});
						Waitframes(4);
					}
					heldSword = false;
				}
			}
			else{
				if(collided->isValid()&&!enemyCollision){
					if(G[G_SORENCHARGE])
						--G[G_SORENCHARGE];
					G[G_SORENCHARGE] = Clamp(G[G_SORENCHARGE], 0, 3);
					CopyTile(67280+G[G_SORENCHARGE], 67320);
					this->Damage = 150+25*G[G_SORENCHARGE];
					enemyCollision = true;
				}
			}
			Waitframe();
		}
		if(heldSword&&G[G_SORENCHARGE]<3){
			bool charged;
			for(int i=0; i<chargeWindow; ++i){
				if(!InputButtonItemGlobal(this->ID)){
					charged = true;
					break;
				}
				Waitframe();
			}
			if(charged){
				if(HasAugment(I_AUGMENT_FLASHCHARGE))
					Game->PlaySound(SFX_ENGINECLEAVER_CHARGE2);
				else
					Game->PlaySound(SFX_ENGINECLEAVER_CHARGE);
				if(enemyCollision&&oldCharges>0)
					++G[G_SORENCHARGE];
				++G[G_SORENCHARGE];
				G[G_SORENCHARGE] = Clamp(G[G_SORENCHARGE], 0, 3);
				if(HasAugment(I_AUGMENT_FLASHCHARGE))
					G[G_SORENCHARGE] = 3;
				CopyTile(67280+G[G_SORENCHARGE], 67320);
				this->Damage = 150+25*G[G_SORENCHARGE];
			}
		}
	}
}

lweapon script SwipeFire{
	void run(int angle, int rotDir){
		int flip = 0;
		if(rotDir==1)
			flip = 2;
		int frate = 4;
		if(HasAugment(I_AUGMENT_LINGERINGFLAME))
			frate = 8;
		for(int i=0; i<6; ++i){
			for(int j=0; j<frate; ++j){
				if(i<4){
					Hitboxes(this->X, this->Y, angle, rotDir, 4-i, this->Damage);
				}
				Screen->DrawTile(4, this->X-16, this->Y-16, 112840+3*i, 3, 3, 8, -1, -1, this->X-16, this->Y-16, angle, flip, true, 128);
				Waitframe();
			}
		}
		this->DeadState = 0;
	}
	void Hitboxes(int x, int y, int angle, int rotDir, int count, int damage){
		for(int i=0; i<count; ++i){
			int tmpX = x+VectorX(16, angle+rotDir*Lerp(45, -90, i/3));
			int tmpY = y+VectorY(16, angle+rotDir*Lerp(45, -90, i/3));
			lweapon l = CreateLWeaponAt(LW_FIRE, tmpX, tmpY);
			l->Damage = damage;
			l->Dir = Link->Dir;
			l->DrawYOffset = -1000;
			l->Script = LWS_ONEFRAME;
			//MakeHitboxLW(LW_FIRE, tmpX, tmpY, 16, 16, damage, Link->Dir);
		}
	}
}

generic script EngineCleaverFreeze{
	void run(int x, int y){
		Game->PlaySound(94);
		for(int i=0; i<4; ++i){
			Screen->DrawTile(6, x-8, y-9, 67318, 2, 2, 8, -1, -1, 0, 0, 0, 0, true, i<8?128:64);
			Waitframe();
		}
		for(int i=0; i<12; ++i){
			Screen->DrawTile(6, Lerp(x-8, x+8, i/12), Lerp(y-8, y+8, i/12), 67318, 2, 2, 8, Lerp(32, 0, i/12), Lerp(32, 0, i/12), 0, 0, 0, 0, true, i<8?128:64);
			Waitframe();
		}
	}
}

const int SFX_ASHERDASH = 72;
const int SFX_ASHERDASH_COLLIDE = 71;

const int I_STARSTONE = 178;
const int I_DASHUPGRADE = 182;

itemdata script AsherDasher{
	int DashTurnDir(int dirNew, int dirOld){
		switch(dirNew){
			case DIR_LEFTUP:
				if(dirOld==DIR_RIGHTUP)
					return -1;
				if(dirOld==DIR_LEFTDOWN)
					return 1;
				break;
			case DIR_RIGHTUP:
				if(dirOld==DIR_RIGHTDOWN)
					return -1;
				if(dirOld==DIR_LEFTUP)
					return 1;
				break;
			case DIR_LEFTDOWN:
				if(dirOld==DIR_LEFTUP)
					return -1;
				if(dirOld==DIR_RIGHTDOWN)
					return 1;
				break;
			case DIR_RIGHTDOWN:
				if(dirOld==DIR_LEFTDOWN)
					return -1;
				if(dirOld==DIR_RIGHTUP)
					return 1;
				break;
		}
		return 0;
	}
	bool DashGoesOffscreen(int vX, int vY){
		int x = Link->X+vX;
		int y = Link->Y+vY;
		if(x<0||x>240||y<0||y>160)
			return true;
		return false;
	}
	bool DashOnPit(int x, int y){
		int pos = ComboAt(x, y);
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata l2 = Game->LoadTempScreen(2);
		for(int i=1; i<=32; ++i){
			ffc f = Screen->LoadFFC(i);
			if(f->Script==FFCS_MOVINGPLATFORM&&FWCLinkCollision(f)){
				return false;
			}
		}
		int collPoints;
		for(int i=0; i<4; ++i){
			pos = ComboAt(x+(i%2)*15, y+8+Floor(i/2)*7);
			if(Screen->ComboT[pos]==CT_PITFALL && !(l1->ComboT[pos]==CT_BRIDGE||l2->ComboT[pos]==CT_BRIDGE)){
				//Screen->PutPixel(6, x+(i%2)*15, y+8+Floor(i/2)*7, 0x0D, 0, 0, 0, 128);
				++collPoints;
			}
		}
		return collPoints>3;
	}
	int WallCollideDir(int x, int y, int vX, int vY, int dir){
		switch(dir){
			case DIR_LEFTUP:
				if(vY<0&&!CanWalkNoEdge(x, y, DIR_UP, 1, false))
					return DIR_UP;
				if(vX<0&&!CanWalkNoEdge(x, y, DIR_LEFT, 1, false))
					return DIR_LEFT;
				return -1;
			case DIR_RIGHTUP:
				if(vY<0&&!CanWalkNoEdge(x, y, DIR_UP, 1, false))
					return DIR_UP;
				if(vX>0&&!CanWalkNoEdge(x, y, DIR_RIGHT, 1, false))
					return DIR_RIGHT;
				return -1;
			case DIR_LEFTDOWN:
				if(vY>0&&!CanWalkNoEdge(x, y, DIR_DOWN, 1, false))
					return DIR_DOWN;
				if(vX<0&&!CanWalkNoEdge(x, y, DIR_LEFT, 1, false))
					return DIR_LEFT;
				return -1;
			case DIR_RIGHTDOWN:
				if(vY>0&&!CanWalkNoEdge(x, y, DIR_DOWN, 1, false))
					return DIR_DOWN;
				if(vX>0&&!CanWalkNoEdge(x, y, DIR_RIGHT, 1, false))
					return DIR_RIGHT;
				return -1;
			default: 
				if(!CanWalkNoEdge(x, y, dir, 1, false)){
					if((dir==DIR_UP&&vY<0)||(dir==DIR_DOWN&&vY>0)||(dir==DIR_LEFT&&vX<0)||(dir==DIR_RIGHT&&vX>0)){
						return dir;
					}
				}
				return -1;
		}
	}
	void run(int force){
		if(!G[G_FORCEDASH]){
			if(OnIce()){
				Game->PlaySound(SFX_ERROR);
				Quit();
			}
			if(G[G_DASHINTERRUPT])
				Quit();
			if(!PressButtonItem(this->ID))
				Quit();
		}
		bool boostedDash;
		bool noPitfall;
		if(FoundItems[I_STARSTONE])
			noPitfall = true;
		if(Link->Item[I_STARSTONE])
			boostedDash = true;
		bool counterDash;
		if(Link->Item[I_DASHUPGRADE])
			counterDash = true;
		Waitframe();
		Game->PlaySound(SFX_ASHERDASH);
		int vX = (Link->InputLeft?-1:0) + (Link->InputRight?1:0);
		int vY = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
		if(vX==0&&vY==0){
			vX = DirX(Link->Dir, 1);
			vY = DirY(Link->Dir, 1);
		}
		if(G[G_FORCEDASH]){
			vX = DirX(G[G_FORCEDASH]-1, 1);
			vY = DirY(G[G_FORCEDASH]-1, 1);
		}
		G[G_FORCEDASH] = 0;
		int xMult = 1;
		int yMult = 1;
		if(vX!=0&&vY!=0){
			xMult = 0.7071;
			yMult = 0.7071;
		}
		int dir4 = AngleDir4(Angle(0, 0, vX, vY));
		int dir8 = AngleDir8(Angle(0, 0, vX, vY));
		dir4 = Dir8ToDir4(dir8, dir4);
		Link->Dir = dir4;
		bool giveIframes;
		bool doubledash;
		if(vX==0&&vY==0)
			dir8 = dir4;
		int iframeCounter = 4;
		if(HasAugment(I_AUGMENT_DASHCOUNTER)){
			iframeCounter += 2;
			if(HasAugment(I_AUGMENT_DASHDIST))
				iframeCounter += 2;
		}
		
		int particlescript = Game->GetLWeaponScript("DashParticle");
		
		int dashTime = 16;
		int dashStep = 4;
		if(boostedDash){
			dashTime = 8;
			dashStep = 8;
			iframeCounter /= 2;
		}
		if(HasAugment(I_AUGMENT_DASHDIST)){
			if(boostedDash)
				dashTime += 2;
			else
				dashTime += 4;
		}
		int dashWallBounceDelay = 8;
		bool wallDash;
		bool wallCollided;
		bool noDash;
		int wallDir;
		int dashBounceSafety = 2;
		int dashBounceLastDir = dir8;
		int dashBounceLastRotDir;
		int dashBounceCombo;
		int dashTotalFrames;
		bool offscreened;
		for(int i=0; i<dashTime&&CanAttack()&&!G[G_SCREENCHANGED]&&!offscreened; ++i){
			int speedMult = 1;
			if(G[G_BURN_ASHER]){
				speedMult = 0.5;
				giveIframes = false;
			}
			
			
			++dashTotalFrames;
			if(dashTotalFrames>300&&dashBounceCombo>100){
				genericdata gd = Game->LoadGenericData(Game->GetGenericScript("SonicCDWarp"));
				gd->RunFrozen();
				Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
				Quit();
			}
			if(G[G_DASHINTERRUPT])
				Quit();
			if(noPitfall&&CanAttack())
				SetLinkPitImmune(2);
			if(boostedDash&&CanAttack()){
				lweapon l = CreateLWeaponAt(LW_SCRIPT10, 120, 80);
				l->DrawYOffset = -1000;
				l->Script = particlescript;
				l->InitD[0] = Link->X;
				l->InitD[1] = Link->Y;
				l->CollDetection = false;
			}
			
			wallDir = WallCollideDir(Link->X, Link->Y, vX, vY, AngleDir8(Angle(0, 0, vX, vY)));
			if(!wallCollided){
				if(wallDir>-1){
					if(boostedDash&&InputButtonItemGlobal(this->ID)&&!wallCollided&&!noDash){
						Game->PlaySound(SFX_ASHERDASH);
						int tempVX = vX;
						int tempVY = vY;
						bool doDelay;
						switch(wallDir){
							case DIR_UP:
							case DIR_DOWN:
								if((wallDir==DIR_UP&&tempVY<0)||(wallDir==DIR_DOWN&&tempVY>0))
									tempVY = -Sign(vY);
									doDelay = true;
								break;
							case DIR_LEFT:
							case DIR_RIGHT:
								if((wallDir==DIR_LEFT&&tempVX<0)||(wallDir==DIR_RIGHT&&tempVX>0))
									tempVX = -Sign(vX);
									doDelay = true;
								break;
						}
						bool undoBounce;
						if(doDelay&&dashWallBounceDelay>0){
							int j = 0;
							for(j=0; j<dashWallBounceDelay&&CanAttack()&&InputButtonItemGlobal(this->ID); ++j){
								if(noPitfall&&CanAttack())
									SetLinkPitImmune(2);
								if(boostedDash&&CanAttack()){
									lweapon l = CreateLWeaponAt(LW_SCRIPT10, 120, 80);
									l->DrawYOffset = -1000;
									l->Script = particlescript;
									l->InitD[0] = Link->X;
									l->InitD[1] = Link->Y;
									l->CollDetection = false;
								}
			
								G[G_NOACTION] = 1;
								Waitframe();
							}
							if(j<dashWallBounceDelay)
								undoBounce = true;
							if(noPitfall&&CanAttack())
								SetLinkPitImmune(2);
							dashWallBounceDelay -= 2;
						}
						int tempWallDir = WallCollideDir(Link->X, Link->Y, tempVX, tempVY, AngleDir8(Angle(0, 0, tempVX, tempVY)));
						if((tempVX!=0||tempVY!=0)&&tempWallDir==-1&&!undoBounce){
							vX = tempVX;
							vY = tempVY;
							wallDash = true;
							dir4 = AngleDir4(Angle(0, 0, vX, vY));
							dir8 = AngleDir8(Angle(0, 0, vX, vY));
							dir4 = Dir8ToDir4(dir8, dir4);
							if(DashTurnDir(dir8, dashBounceLastDir)==dashBounceLastRotDir||dashBounceLastRotDir==0){
								++dashBounceCombo;
							}
							else{
								dashBounceCombo = 0;
							}
							dashBounceLastRotDir = DashTurnDir(dir8, dashBounceLastDir);
							dashBounceLastDir = dir8;
							//Trace(dashBounceCombo);
							Link->Dir = dir4;
							if(dir8<4)
								noDash = true;
							i = 0;
						}
						else
							wallCollided = true;
					}
					else
						wallCollided = true;
				}
			}
			else{
				vX = vX * 0.85;
				vY = vY * 0.85;
			}
			
			int setTile = 104543;
			if(iframeCounter&&counterDash&&!G[G_BURN_ASHER]){
				--iframeCounter;
				// if(i==0||i==3)
					// setTile += 40;
				// else{
				setTile += 80;
				// }
				TurnOffLinkCollision(2);
				bool collided;
				for(int i=Screen->NumEWeapons(); i>0; --i){
					eweapon e = Screen->LoadEWeapon(i);
					if(e->CollDetection&&e->DeadState==WDS_ALIVE&&e->Damage>0&&LinkCollision(e)&&!(e->Misc[EWM_FLAGS]&EWMF_NOCOUNTER)){
						collided = true;
						break;
					}
				}
				for(int i=Screen->NumNPCs(); i>0; --i){
					npc n = Screen->LoadNPC(i);
					if(n->CollDetection&&LinkCollision(n)){
						collided = true;
						break;
					}
				}
				if(collided&&!giveIframes&&counterDash&&!G[G_BURN_ASHER]){
					Game->PlaySound(SFX_ASHERDASH_COLLIDE);
					eweapon e = FireEWeapon(EW_SCRIPT10, Link->X, Link->Y, DegtoRad(DirAngle(dir8)), 0, 0, 0, 0, 0);
					e->DrawYOffset = -1000;
					e->CollDetection = false;
					RunEWeaponScript(e, "RingParticle", {4, 0x01, 12, 24, 12, 3});
					giveIframes = true;
				}
			}
			if(giveIframes&&!G[G_BURN_ASHER]){
				TurnOffLinkCollision(2);
				int tempVX = (G[G_LEFTINPUT]?-1:0) + (G[G_RIGHTINPUT]?1:0);
				int tempVY = (G[G_UPINPUT]?-1:0) + (G[G_DOWNINPUT]?1:0);
				if(tempVX!=0||tempVY!=0){
					vX = Clamp(vX+tempVX*0.1, -1, 1);
					vY = Clamp(vY+tempVY*0.1, -1, 1);
					if(vX!=0||vY!=0){
						xMult = Abs(VectorX(1, Angle(0, 0, vX, vY)));
						yMult = Abs(VectorY(1, Angle(0, 0, vX, vY)));
						dir8 = AngleDir8(Angle(0, 0, vX, vY));
						dir4 = Dir8ToDir4(dir8, dir4);
					}
				}
			}
			switch(Link->Dir){
				case DIR_UP:
					SetLinkScriptTile(setTile+2, 0, 2);
					break;
				case DIR_DOWN:
					SetLinkScriptTile(setTile, 0, 2);
					break;
				case DIR_LEFT:
					SetLinkScriptTile(setTile+1, 0, 2);
					break;
				case DIR_RIGHT:
					SetLinkScriptTile(setTile+1, 1, 2);
					break;
			}
			if(DashGoesOffscreen(vX*dashStep*xMult, vY*dashStep*yMult))
				offscreened = true;
			LinkMovement_Push2(vX*dashStep*xMult*speedMult, vY*dashStep*yMult*speedMult);
			G[G_NOACTION] = 1;
			Waitframe();
		}
		//Link->MoveFlags[HEROMV_CAN_PITFALL] = true;
		if(giveIframes){
			lweapon l = FireLWeapon(LW_SCRIPT10, Link->X, Link->Y, 0, 0, this->Power*2, 0, 0);
			RunLWeaponScript(l, "StellarImpact", {8, 0});
			l->CollDetection = false;
			for(int i=0; i<4; ++i){
				l = FireLWeapon(LW_SCRIPT10, Link->X+VectorX(12, 45+90*i), Link->Y+VectorY(12, 45+90*i), 0, 0, this->Power*2, 0, 0);
				RunLWeaponScript(l, "StellarImpact", {16, 0});
				l->CollDetection = false;
			}
			for(int i=0; i<8; ++i){
				l = FireLWeapon(LW_SCRIPT10, Link->X+VectorX(24, 45*i), Link->Y+VectorY(24, 45*i), 0, 0, this->Power*2, 0, 0);
				RunLWeaponScript(l, "StellarImpact", {24, 0});
				l->CollDetection = false;
			}
			for(int i=0; i<16; ++i){
				l = FireLWeapon(LW_SCRIPT10, Link->X+VectorX(36, 22.5*i), Link->Y+VectorY(36, 22.5*i), 0, 0, this->Power*2, 0, 0);
				RunLWeaponScript(l, "StellarImpact", {32, 0});
				l->CollDetection = false;
			}
			Link->Dir = DIR_DOWN;
			Link->Action = LA_ATTACKING;
			WaitNoAction(16);
		}
		for(int i=0; i<8; ++i){
			if(noPitfall&&CanAttack())
				SetLinkPitImmune(2);
			if(boostedDash&&CanAttack()){
				lweapon l = CreateLWeaponAt(LW_SCRIPT10, 120, 80);
				l->DrawYOffset = -1000;
				l->Script = particlescript;
				l->InitD[0] = Link->X;
				l->InitD[1] = Link->Y;
				l->CollDetection = false;
			}
			if(giveIframes)
				TurnOffLinkCollision(2);
			if(DashOnPit(Link->X, Link->Y))
				G[G_NOACTION] = 1;
			Waitframe();
		}
		for(int i=0; i<32&&DashOnPit(Link->X, Link->Y); ++i){
			G[G_NOACTION] = 1;
			Waitframe();
		}
	}
}

generic script SonicCDWarp{
	void run(){
		if(Game->GetCurDMap()!=47&&Game->GetCurDMap()!=75){
			G[G_CREATORSREALM_CONTINUEDMAP] = G[G_CONTINUEDMAP];
			G[G_CREATORSREALM_CONTINUESCREEN] = G[G_CONTINUESCREEN];
		}
		Game->PlayMIDI(0);
		Game->PlaySound(129);
		for(int i=0; i<12; ++i){
			if(i<4)
				Screen->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			else if(i<8){
				Screen->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
				Screen->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			}
			else
				Screen->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		
		bitmap bRed = Game->CreateBitmap(256+16, 176+16);
		bRed->Clear(0);
		bRed->Own();
		
		bRed->DrawLayer(0, 46, 0x82, 0, 0,  0, 0, 128);
		bRed->DrawLayer(0, 46, 0x82, 0, 16, 0, 0, 128);
		bRed->DrawLayer(0, 46, 0x82, 0, 0,  16, 0, 128);
		bRed->DrawLayer(0, 46, 0x82, 0, 16, 16, 0, 128);
		
		bitmap bBlue = Game->CreateBitmap(256+16, 176+16);
		bBlue->Clear(0);
		bBlue->Own();
		
		bBlue->DrawLayer(0, 46, 0x83, 0, 0,  0, 0, 128);
		bBlue->DrawLayer(0, 46, 0x83, 0, 16, 0, 0, 128);
		bBlue->DrawLayer(0, 46, 0x83, 0, 0,  16, 0, 128);
		bBlue->DrawLayer(0, 46, 0x83, 0, 16, 16, 0, 128);
		
		bitmap bPurple = Game->CreateBitmap(256+16, 176+16);
		bPurple->Clear(0);
		bPurple->Own();
		
		bPurple->DrawLayer(0, 46, 0x84, 0, 0,  0, 0, 128);
		bPurple->DrawLayer(0, 46, 0x84, 0, 16, 0, 0, 128);
		bPurple->DrawLayer(0, 46, 0x84, 0, 0,  16, 0, 128);
		bPurple->DrawLayer(0, 46, 0x84, 0, 16, 16, 0, 128);
		
		bitmap bGattai = Game->CreateBitmap(256, 176);
		bGattai->Clear(0);
		bGattai->Own();
		
		bitmap scrn = Game->CreateBitmap(256, 176);
		scrn->Own();
		
		int xRed = Rand(16);
		int yRed = Rand(16);
		int angRed = -45+Rand(-10, 10);
		int xBlue = Rand(16);
		int yBlue = Rand(16);
		int angBlue = -135+Rand(-10, 10);
		int y = 176;
		int state = 0;
		int accel;
		
		int sX[16];
		int sY[16];
		int sF[16];
		int sT[16];
		int sL[16];
		int sparkleCycle;
		for(int i=0; i<360; ++i){
			scrn->Clear(0);
			
			if(state==0){
				if(y>80)
					y -= 2;
				else
					state = 1;
			}
			else if(state==1){
				y += 0.25*Sin(i*4);
				if(i>=240&&Sin(i*4)<=-0.9){
					state = 2;
					accel = Sin(i*4);
				}
			}
			else if(state==2){
				if(y>-180){
					y += accel;
					accel -= 0.1;
				}
			}
			
			if(i%4==0){
				sX[sparkleCycle] = 120+Rand(-12, 12);
				sY[sparkleCycle] = y+16+Rand(-8, 8);
				sF[sparkleCycle] = 0;
				sT[sparkleCycle] = 0;
				sL[sparkleCycle] = Choose(0, 1);
				++sparkleCycle;
				sparkleCycle %= 16;
			}
			
			scrn->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
			
			bGattai->ClearToColor(0, 0x97);
			bPurple->Blit(0, bGattai, xRed, yRed, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			bPurple->Blit(0, bGattai, xBlue, yBlue, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			bGattai->ReplaceColors(0, 0x00, 0x01, 0x01);
			
			bRed->Blit(0, scrn, xRed, yRed, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			bBlue->Blit(0, scrn, xBlue, yBlue, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			bGattai->Blit(0, scrn, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			
			xRed += VectorX(1, angRed);
			yRed += VectorY(1, angRed);
			if(xRed<0)
				xRed += 16;
			if(xRed>16)
				xRed -= 16;
			if(yRed<0)
				yRed += 16;
			if(yRed>16)
				yRed -= 16;
			
			xBlue += VectorX(1, angBlue);
			yBlue += VectorY(1, angBlue);
			if(xBlue<0)
				xBlue += 16;
			if(xBlue>16)
				xBlue -= 16;
			if(yBlue<0)
				yBlue += 16;
			if(yBlue>16)
				yBlue -= 16;
			
			scrn->DrawCombo(1, 120, y, 51100+GetCharID(), 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
			
			for(int j=0; j<16; ++j){
				if(sX[j]>0){
					scrn->FastTile(sL[j], sX[j], sY[j], 1420+sF[j], 11, 128);
					sY[j] += 2;
					++sT[j];
					if(sT[j]>=2){
						++sF[j];
						sT[j] = 0;
						if(sF[j]==20)
							sX[j] = 0;
					}
				}
			}
			if(i<8||i>=360-8)
				scrn->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			else if(i<4||i>=360-4){
				scrn->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
				scrn->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			}
			
			scrn->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			
			Waitframe();
		}
		for(int i=0; i<12; ++i){
			Screen->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		if(Game->GetCurDMap()==47)
			Link->Warp(75, 0x73);
		else
			Link->Warp(47, 0x58);
	}
}

lweapon script DashParticle{
	void run(int drawx, int drawy){
		int atimer;
		int bitid = TempBitmap_Create(0, 16, 32);
		bitmap b = TempBMP[bitid];
		b->Clear(0);
		b->DrawTile(0, 0, 0, Link->Tile-20, 1, 2, 6, -1, -1, 0, 0, 0, Link->Flip, true, 128);
		b->ReplaceColors(0, 0x91, 0x01, 0xBF);
		int activeFrames;
		while(true){
			int c;
			int mode = BITDX_NORMAL;
			if(atimer<4)
				c = 0x91;
			else if(atimer<8)
				c = 0x96;
			else if(atimer<12)
				c = 0x97;
			else{
				c = 0x97;
				mode = BITDX_TRANS;
			}
			
			++atimer;
			int w = 16-activeFrames/2;
			int h = 32-activeFrames;
			int x = drawx+(16-w)/2;
			int y = drawy-16+(32-h)/2;
			b->ReplaceColors(0, c, 0x91, 0x97);
			b->Blit(2, RT_SCREEN, 0, 0, 16, 32, x, y, w, h, 0, 0, 0, mode, 0, true);
			
			++activeFrames;
			if(this->DeadState==1||activeFrames>16){
				TempBitmap_Free(2, bitid);
				this->DeadState = 1;
				Quit();
			}
			Waitframe();
		}
	}
}

const int SFX_STELLARIMPACT = 73;

const int TIL_STELLARIMPACT = 104700;

lweapon script StellarImpact{
	void run(int delay, int showAnim){
		for(int i=0; i<delay; ++i){
			if(showAnim){
				Screen->FastTile(2, this->X, this->Y, TIL_STELLARIMPACT+Floor(i/4)%3, 9, 128);
			}
			Waitframe();
		}
		Game->PlaySound(SFX_STELLARIMPACT);
		for(int i=0; i<9; ++i){
			Screen->FastTile(2, this->X, this->Y, TIL_STELLARIMPACT+3+Floor(i/3), 9, 128);
			Screen->FastTile(4, this->X, this->Y-16, TIL_STELLARIMPACT+3+Floor(i/3)-20, 9, 128);
			MakeHitboxLW(LW_STELLAR, this->X, this->Y, 16, 16, this->Damage, -1);
			Waitframe();
		}
		this->DeadState = 0;
	}
}

void DrawLightSwordSlashLW(int sx, int sy, int angle, int dist, int swordlength, int damage, int slashDir, int slashFrame){
	slashDir = -slashDir; //I got my math backwards and instead of fixing it I'm doing this
	int x = sx+8+VectorX(dist+24, angle)+VectorX(slashDir*32, angle+90)-40;
	int y = sy+8+VectorY(dist+24, angle)+VectorY(slashDir*32, angle+90)-48;
	if(slashDir!=0){
		angle += 45*slashDir;
		Screen->DrawTile(2, x, y, TIL_STELLARSLASH+5*slashFrame, 5, 6, 9, -1, -1, x, y, angle, slashDir==-1?0:2, true, 128);
		if(slashFrame==0){
			for(int j=0; j<=4; ++j){
				for(int k=1; k<6; ++k){
					x = sx+VectorX(k*14, angle-45*slashDir+j*10*slashDir);
					y = sy+VectorY(k*14, angle-45*slashDir+j*10*slashDir);
					MakeHitboxLW(LW_STELLAR, x, y, 16, 16, damage, Link->Dir);
				}
			}
		}
	}
	else
		DrawLightSwordLW(sx, sy, angle, dist, swordlength, damage);
}

void DrawLightSwordLW(int sx, int sy, int angle, int dist, int swordlength, int damage){
	int x = sx + VectorX(dist+(swordlength-1)*8, angle)-(swordlength-1)*8;
	int y = sy + VectorY(dist+(swordlength-1)*8, angle);
	Screen->DrawTile(2, x, y, TIL_STELLARSWORD+4-(swordlength-1)+(G[G_ANIM]%4*20), swordlength, 1, 9, -1, -1, x, y, angle, 0, true, 128);
	for(int i=0; i<swordlength; ++i){
		x = sx + VectorX(dist+16*i, angle);
		y = sy + VectorY(dist+16*i, angle);
		MakeHitboxLW(LW_STELLAR, x, y, 16, 16, damage, Link->Dir);
	}
}

itemdata script StellarSword{
	// void DrawLightSwordLW(int sx, int sy, int angle, int dist, int swordlength, int damage){
		// int x = sx + VectorX(dist+(swordlength-1)*8, angle)-(swordlength-1)*8;
		// int y = sy + VectorY(dist+(swordlength-1)*8, angle);
		// Screen->DrawTile(2, x, y, TIL_STELLARSWORD+4-(swordlength-1)+(G[G_ANIM]%4*20), swordlength, 1, 9, -1, -1, x, y, angle, 0, true, 128);
		// for(int i=0; i<swordlength; ++i){
			// x = sx + VectorX(dist+16*i, angle);
			// y = sy + VectorY(dist+16*i, angle);
			// MakeHitboxLW(LW_STELLAR, x, y, 16, 16, damage, Link->Dir);
		// }
	// }
	void run(){
		int i; int j;
		int angle;
		int damage = 350;
		int mpcost = 16;
		int mpcost2 = 24;
		if(HasAugment(I_AUGMENT_STELLARSWORD)){
			damage = 425;
			mpcost = 24;
			mpcost2 = 12;
		}
		if(Link->MP==0)
			Quit();
		Link->MP = Max(Link->MP-mpcost, 0);
		angle = DirAngle(Link->Dir);
		if(HasAugment(I_AUGMENT_STELLARSWORD)){
			Game->PlaySound(SFX_STELLARSWORD_APPEAR);
			for(i=1; i<6; ++i){
				for(j=0; j<3; ++j){
					DrawLightSwordSlashLW(Link->X, Link->Y, angle-90, 8, i, damage, 0, 0);
					G[G_NOACTION] = 1;
					Link->Action = LA_NONE;
					Waitframe();
				}
			}
			for(i=0; i<16; ++i){
				DrawLightSwordSlashLW(Link->X, Link->Y, angle-90, 8, 5, damage, 0, 0);
				G[G_NOACTION] = 1;
				Link->Action = LA_NONE;
				Waitframe();
			}
			Game->PlaySound(SFX_STELLARSWORD_SLASH);
			bool followupSlash;
			for(i=0; i<8; ++i){
				if(i>3){
					LinkMovement_Push2(DirX(Link->Dir, -2), DirY(Link->Dir, -2));
				}
				if(PressButtonItemGlobal(I_ABILITY_B_ASHER)&&Link->MP>0)
					followupSlash = true;
				DrawLightSwordSlashLW(Link->X, Link->Y, angle-90+Lerp(45, 180, i/12), 8, 5, damage, 1, 0);
				G[G_NOACTION] = 1;
				Link->Action = LA_NONE;
				Link->Action = LA_ATTACKING;
				Waitframe();
			}
			for(i=0; i<4; ++i){
				if(PressButtonItemGlobal(I_ABILITY_B_ASHER)&&Link->MP>0)
					followupSlash = true;
				LinkMovement_Push2(DirX(Link->Dir, -1), DirY(Link->Dir, -1));
				DrawLightSwordSlashLW(Link->X, Link->Y, angle+90, 8, 5, damage, 1, i);
				G[G_NOACTION] = 1;
				Link->Action = LA_NONE;
				Link->Action = LA_ATTACKING;
				Waitframe();
			}
			if(followupSlash){
				Link->MP = Max(Link->MP-mpcost2, 0);
				for(i=0; i<24; ++i){
					DrawLightSwordSlashLW(Link->X, Link->Y, angle+90, 8, 5, damage, 0, 0);
					G[G_NOACTION] = 1;
					Link->Action = LA_NONE;
					Waitframe();
				}
				Game->PlaySound(SFX_STELLARSWORD_SLASH);
				for(i=0; i<8; ++i){
					if(i>3)
						LinkMovement_Push2(DirX(Link->Dir, -2), DirY(Link->Dir, -2));
					DrawLightSwordSlashLW(Link->X, Link->Y, angle+90-Lerp(45, 180, i/12), 8, 5, damage, -1, 0);
					G[G_NOACTION] = 1;
					Link->Action = LA_NONE;
					Link->Action = LA_ATTACKING;
					Waitframe();
				}
				for(i=0; i<4; ++i){
					LinkMovement_Push2(DirX(Link->Dir, -1), DirY(Link->Dir, -1));
					DrawLightSwordSlashLW(Link->X, Link->Y, angle-90, 8, 5, damage, -1, i);
					G[G_NOACTION] = 1;
					Link->Action = LA_NONE;
					Link->Action = LA_ATTACKING;
					Waitframe();
				}
				for(i=5; i>=0; --i){
					DrawLightSwordSlashLW(Link->X, Link->Y, angle-90, 8, i, damage, 0, 0);
					G[G_NOACTION] = 1;
					Link->Action = LA_NONE;
					Waitframe();
				}
			}
			else{
				for(i=5; i>=0; --i){
					DrawLightSwordSlashLW(Link->X, Link->Y, angle+90, 8, i, damage, 0, 0);
					G[G_NOACTION] = 1;
					Link->Action = LA_NONE;
					Waitframe();
				}
			}
		}
		else{
			Game->PlaySound(SFX_STELLARSWORD_APPEAR);
			for(i=1; i<6; ++i){
				for(j=0; j<2; ++j){
					DrawLightSwordSlashLW(Link->X, Link->Y, angle-45, 8, i, damage, 0, 0);
					G[G_NOACTION] = 1;
					Link->Action = LA_NONE;
					Link->Action = LA_ATTACKING;
					Waitframe();
				}
			}
			for(i=0; i<8; ++i){
				DrawLightSwordSlashLW(Link->X, Link->Y, angle-45, 8, 5, damage, 0, 0);
				G[G_NOACTION] = 1;
				Link->Action = LA_NONE;
				Link->Action = LA_ATTACKING;
				Waitframe();
			}
			Game->PlaySound(SFX_STELLARSWORD_SLASH);
			for(i=0; i<8; ++i){
				if(i>3)
					LinkMovement_Push2(DirX(Link->Dir, -2), DirY(Link->Dir, -2));
				DrawLightSwordSlashLW(Link->X, Link->Y, angle+45, 8, 5, damage, 1, 0);
				G[G_NOACTION] = 1;
				Link->Action = LA_NONE;
				Link->Action = LA_ATTACKING;
				Waitframe();
			}
			for(i=0; i<4; ++i){
				LinkMovement_Push2(DirX(Link->Dir, -1), DirY(Link->Dir, -1));
				DrawLightSwordSlashLW(Link->X, Link->Y, angle+45, 8, 5, damage, 1, i);
				G[G_NOACTION] = 1;
				Link->Action = LA_NONE;
				Link->Action = LA_ATTACKING;
				Waitframe();
			}
			for(i=5; i>=0; --i){
				DrawLightSwordSlashLW(Link->X, Link->Y, angle+45, 8, i, damage, 0, 0);
				G[G_NOACTION] = 1;
				Link->Action = LA_NONE;
				Link->Action = LA_ATTACKING;
				Waitframe();
			}
		}
		// Game->PlaySound(SFX_STELLARSWORD_APPEAR);
		// for(int i=1; i<6; ++i){
			// for(int j=0; j<2; ++j){
				// DrawLightSwordLW(Link->X, Link->Y, angle-45, 16, i, this->Power*2);
				// G[G_NOACTION] = 1;
				// Waitframe();
			// }
		// }
		// for(int i=0; i<32; ++i){
			// DrawLightSwordLW(Link->X, Link->Y, angle-45, 16, 5, this->Power*2);
			// G[G_NOACTION] = 1;
			// Waitframe();
		// }
		// Game->PlaySound(SFX_STELLARSWORD_SLASH);
		// for(int i=0; i<13; ++i){
			// int til = TIL_STELLARSLASH;
			// if(i>11)
				// til += 15;
			// else if(i>9)
				// til += 10;
			// else if(i>7)
				// til += 5;
			// int x = Link->X+8+VectorX(16+40, angle)-40;
			// int y =  Link->Y+8+VectorY(16+40, angle)-48;
			// Screen->DrawTile(2, x, y, til, 5, 6, 9, -1, -1, x, y, angle, 0, true, 128);
			// if(i<7){
				// for(int j=0; j<=8; ++j){
					// for(int k=1; k<6; ++k){
						// x = Link->X+VectorX(-8+k*16, angle-40+j*10);
						// y = Link->Y+VectorY(-8+k*16, angle-40+j*10);
						// MakeHitboxLW(LW_STELLAR, x, y, 16, 16, this->Power*2, Link->Dir);
					// }
				// }
			// }
			// G[G_NOACTION] = 1;
			// Waitframe();
		// }
		// for(int i=4; i>0; --i){
			// for(int j=0; j<2; ++j){
				// DrawLightSwordLW(Link->X, Link->Y, angle+45, 16, i, this->Power*2);
				// G[G_NOACTION] = 1;
				// Waitframe();
			// }
		// }
	}
}

lweapon script MeteoriteLW{
	void DrawMeteoriteImpact(bitmap impact, int x, int y, int c1, int c2, int scale, bool trans, int removeTop, int damage){
		impact->Clear(0);
		impact->Circle(0, scale, scale, scale, c1, 1, 0, 0, 0, true, 128);
		impact->Rectangle(0, 0, scale, scale*2-1, scale*2-1, 0x00, 1, 0, 0, 0, true, 128);
		impact->Ellipse(0, scale, scale, scale, scale*0.3333, c2, 1, 0, 0, 0, true, 128);
		if(removeTop){
			impact->Ellipse(0, scale, Lerp(0, scale, removeTop), Lerp(0, scale*2, removeTop), Lerp(0, scale, removeTop), 0x00, 1, 0, 0, 0, true, 128);
		}
		int flag;
		if(trans)
			flag = BITDX_TRANS;
		impact->Blit(6, RT_SCREEN, 0, 0, scale*2, scale*1.3333, x-scale, y-scale, scale*2, scale*1.3333, 0, 0, 0, flag, 0, true);
	
	
		// impact->Circle(0, 48, 48, scale, c1, 1, 0, 0, 0, true, 128);
		// impact->Rectangle(0, 0, 48, 95, 63, 0x00, 1, 0, 0, 0, true, 128);
		// impact->Ellipse(0, 48, 48, scale, scale*0.3333, c2, 1, 0, 0, 0, true, 128);
		// if(removeTop){
			// impact->Ellipse(0, 48, Lerp(0, 48, removeTop), Lerp(0, 96, removeTop), Lerp(0, 48, removeTop), 0x00, 1, 0, 0, 0, true, 128);
		// }
		// int flag;
		// if(trans)
			// flag = BITDX_TRANS;
		// impact->Blit(6, RT_SCREEN, 0, 0, 96, 64, x-48, y-48, 96, 64, 0, 0, 0, flag, 0, true);
	
		if(damage)
			MakeHitboxLW(LW_STELLAR, x-scale, y-scale, scale*2, (scale/48)*64, damage, -1);
		impact->Clear(6);
	}
	void run(int drawBeacon, int skipfall, int size){
		if(size==0)
			size = 48;
		if(drawBeacon){
			for(int i=0; i<12; ++i){
				int j = 4*(i/12);
				Screen->Rectangle(4, this->X+8-j, 0, this->X+8+j, this->Y+8, 0x01, 1, 0, 0, 0, true, 128);
				Screen->Circle(4, this->X+8, this->Y+8, j, 0x01, 1, 0, 0, 0, true, 128);
				Waitframe();
			}
			for(int i=4; i>0; --i){
				int j = 4*(i/4);
				Screen->Rectangle(4, this->X+8-j, 0, this->X+8+j, this->Y+8, 0x01, 1, 0, 0, 0, true, 128);
				Screen->Circle(4, this->X+8, this->Y+8, j, 0x01, 1, 0, 0, 0, true, 128);
				Waitframe();
			}
		}
		int bitid = TempBitmap_Create(0, size*2, size*2);
		bitmap impact = TempBMP[bitid];
		if(!skipfall){
			Game->PlaySound(SFX_METEORITE_FALL);
			for(int i=64; i>0; --i){
				Screen->FastTile(2, this->X, this->Y, 832+Floor(G[G_ANIM]/4)%4, 7, 64);
				Screen->DrawTile(6, this->X+8*i, this->Y-48-16*i, TIL_METEORITE+2*(G[G_ANIM]%4), 2, 4, 9, -1, -1, 0, 0, 0, 0, true, 128);
				Waitframe();
			}
		}
		Game->PlaySound(SFX_BOMB);
		Screen->Quake = 10;
		for(int i=0; i<16; ++i){
			DrawMeteoriteImpact(impact, this->X+8, this->Y+8, 0x01, 0x96, size*(i/16), true, 0, this->Damage);
			Waitframe();
		}
		for(int i=0; i<16; ++i){
			DrawMeteoriteImpact(impact, this->X+8, this->Y+8, 0x01, 0x01, size, false, (i/16), 0);
			Waitframe();
		}
		TempBitmap_Free(0, bitid);
		this->DeadState = 0;
	}
}

const int TIL_ASTER_LUMINAIRE = 104546;
const int TIL_METEOR = 65172;

const int SFX_METEORSHAKE = 74;
const int SFX_METEORIMPACT = 37;
const int SFX_METEORWIPE = 75;
const int SFX_METEORGLOW = 76;
const int SFX_METEORFALL = 52;

itemdata script Meteor{
	bool CanCast(){
		if(Game->GetCurDMap()==36&&G[G_ASHERCOSTUME])
			return false;
		return !(G[G_METEOREFFECTSFRAMES]||!(Game->DMapFlags[Game->GetCurDMap()]&DMF_IS_OVERWORLD));
	}
	void DrawMeteorImpact(int x, int y, int c1, int c2, int scale, bool trans){
		GBMP[BMP_ASHERMETEOR]->Clear(0);
		GBMP[BMP_ASHERMETEOR]->Circle(0, x, y, scale, c1, 1, 0, 0, 0, true, 128);
		GBMP[BMP_ASHERMETEOR]->Rectangle(0, 0, y, 255, 175, 0x00, 1, 0, 0, 0, true, 128);
		GBMP[BMP_ASHERMETEOR]->Ellipse(0, x, y, scale, scale*0.25, c2, 1, 0, 0, 0, true, 128);
		int flag;
		if(trans)
			flag = BITDX_TRANS;
		GBMP[BMP_ASHERMETEOR]->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, flag, 0, true);
		GBMP[BMP_ASHERMETEOR]->Clear(6);
	}
	void run(){
		if(HasAugment(I_AUGMENT_MINIOR)){
			int mpcost = 40;
			int damage = 600;
			if(Link->MP==0)
				Quit();
			int tX = Link->X+DirX(Link->Dir, 16);
			int tY = Link->Y+DirY(Link->Dir, 16);
			int vX = DirX(Link->Dir, 1);
			int vY = DirY(Link->Dir, 1);
			int aX;
			int aY;
			for(int i=0; (i<16||(InputButtonItemGlobal(I_ABILITY_C_ASHER)&&i<80))&&(Link->Action!=LA_GOTHURTLAND); ++i){
				aX = StickX();
				aY = StickY();
				if(aX!=0&&aY!=0){
					aX *= 0.7071;
					aY *= 0.7071;
				}
				vX = Clamp(vX+aX*0.1, -1.5, 1.5);
				vY = Clamp(vY+aY*0.1, -1.5, 1.5);
				tX += vX;
				tY += vY;
				tX = Clamp(tX, 4, 236);
				tY = Clamp(tY, 4, 156);
				Screen->FastTile(6, tX, tY, TIL_TORRINLOCKON+Floor((G[G_ANIM]%4)/2), 8, 128);
				Link->Action = LA_NONE;
				Link->Action = LA_ATTACKING;
				WaitNoAction();
			}
			if(Link->Action!=LA_GOTHURTLAND){
				Link->MP = Max(Link->MP-mpcost, 0);
				lweapon l = CreateLWeaponAt(LW_STELLAR, tX, tY);
				l->Step = 0;
				l->CollDetection = false;
				l->DrawYOffset = -1000;
				l->Damage = damage;
				RunLWeaponScript(l, "MeteoriteLW", {1, 0, 0});
			}
			Quit();
		}
		if(Link->MP<=192||!CanCast())
			Quit();
		Link->MP -= 192;
		Waitframe();
		int z = 0;
		int hairFrame;
		int flashFrame;
		int impactY = 128;
		int quakeFrames[1];
		int glowFrames[1];
		for(int i=0; i<32; ++i){
			Link->Z = z;
			z += 1;
			Link->Jump = 0;
			SetLinkScriptTile(TIL_ASTER_LUMINAIRE, 0, 2);
			G[G_NOACTION] = 1;
			if(i>=24){
				LoopingSFX(glowFrames, 96, SFX_METEORGLOW);
				flashFrame = Floor(G[G_ANIM]/4)%4;
				if(flashFrame==3)
					flashFrame = 1;
				Screen->DrawTile(4, Link->X+Rand(-1, 1), Link->Y+Link->DrawYOffset+Rand(-1, 1)-Link->Z-16, TIL_ASTER_LUMINAIRE+40-20+40*flashFrame, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			}
			Waitframe();
		}
		for(int i=0; i<64; ++i){
			Link->Z = z+Sin(G[G_ANIM]*2);
			if(z<48)
				z += 0.5;
			Link->Jump = 0;
			hairFrame = Floor(G[G_ANIM]/4)%4;
			SetLinkScriptTile(TIL_ASTER_LUMINAIRE+1+hairFrame, 0, 2);
			G[G_NOACTION] = 1;
			flashFrame = Floor(G[G_ANIM]/4)%4;
			if(flashFrame==3)
				flashFrame = 1;
			LoopingSFX(glowFrames, 96, SFX_METEORGLOW);
			LoopingSFX(quakeFrames, 64, SFX_METEORSHAKE);
			Screen->DrawTile(4, Link->X+Rand(-1, 1), Link->Y+Link->DrawYOffset+Rand(-1, 1)-Link->Z-16, TIL_ASTER_LUMINAIRE+40-20+40*flashFrame+1+hairFrame, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			Waitframe();
		}
		for(int i=0; i<=192; ++i){
			Screen->Ellipse(4, 128, impactY, (i/192)*12, (i/192)*12*0.75, 0x0F, 1, 0, 0, 0, true, i%2?128:64);
			Link->Z = z+Sin(G[G_ANIM]*2);
			Link->Jump = 0;
			hairFrame = Floor(G[G_ANIM]/4)%4;
			SetLinkScriptTile(TIL_ASTER_LUMINAIRE+1+hairFrame, 0, 2);
			G[G_NOACTION] = 1;
			flashFrame = Floor(G[G_ANIM]/4)%4;
			if(flashFrame==3)
				flashFrame = 1;
			Screen->DrawTile(4, Link->X+Rand(-1, 1), Link->Y+Link->DrawYOffset+Rand(-1, 1)-Link->Z-16, TIL_ASTER_LUMINAIRE+40-20+40*flashFrame+1+hairFrame, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			LoopingSFX(glowFrames, 96, SFX_METEORGLOW);
			LoopingSFX(quakeFrames, 64, SFX_METEORSHAKE);
			Screen->Quake = 10;
			Waitframe();
		}
		Game->PlaySound(SFX_METEORFALL);
		for(int i=0; i<=256; i+=8){
			Screen->Ellipse(4, 128, impactY, 12, 12*0.66, 0x0F, 1, 0, 0, 0, true, i%16?128:64);
			Screen->FastTile(4, 120+VectorX(256-i, -60), impactY-8+VectorY(256-i, -60), TIL_METEOR, 11, 128);
			Link->Z = z+Sin(G[G_ANIM]*2);
			Link->Jump = 0;
			hairFrame = Floor(G[G_ANIM]/4)%4;
			SetLinkScriptTile(TIL_ASTER_LUMINAIRE+1+hairFrame, 0, 2);
			G[G_NOACTION] = 1;
			flashFrame = Floor(G[G_ANIM]/4)%4;
			if(flashFrame==3)
				flashFrame = 1;
			Screen->DrawTile(4, Link->X+Rand(-1, 1), Link->Y+Link->DrawYOffset+Rand(-1, 1)-Link->Z-16, TIL_ASTER_LUMINAIRE+40-20+40*flashFrame+1+hairFrame, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			LoopingSFX(quakeFrames, 64, SFX_METEORSHAKE);
			Screen->Quake = 10;
			Waitframe();
		}
		int c1; int c2;
		Game->PlaySound(SFX_METEORIMPACT);
		for(int i=16; i<128; i+=4){
			c1 = 0x97;
			c2 = 0x98;
			if(i>64){
				c1 = 0x91;
				c2 = 0x91;
			}
			else if(i>48){
				c1 = 0x91;
				c2 = 0x96;
			}
			else if(i>32){
				c1 = 0x96;
				c2 = 0x97;
			}
			Link->Z = z+Sin(G[G_ANIM]*2);
			Link->Jump = 0;
			hairFrame = Floor(G[G_ANIM]/4)%4;
			SetLinkScriptTile(TIL_ASTER_LUMINAIRE+1+hairFrame, 0, 2);
			G[G_NOACTION] = 1;
			flashFrame = Floor(G[G_ANIM]/4)%4;
			if(flashFrame==3)
				flashFrame = 1;
			DrawMeteorImpact(128, impactY, c1, c2, i, i<96);
			Screen->DrawTile(4, Link->X+Rand(-1, 1), Link->Y+Link->DrawYOffset+Rand(-1, 1)-Link->Z-16, TIL_ASTER_LUMINAIRE+40-20+40*flashFrame+1+hairFrame, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->Quake = 10;
			Waitframe();
		}
		Game->PlaySound(SFX_METEORWIPE);
		for(int i=0; i<24; ++i){
			DrawMeteorImpact(128, impactY, c1, c2, 128, false);
			if(i<16){
				if(i>=8)
					Screen->Rectangle(6, 0, -16, 255, 175+16, 0x01, 1, 0, 0, 0, true, 64);
				Screen->Rectangle(6, 0, -16, 255, 175+16, 0x01, 1, 0, 0, 0, true, 64);
			}
			else
				Screen->Rectangle(6, 0, -16, 255, 175+16, 0x01, 1, 0, 0, 0, true, 128);
			Link->Z = z+Sin(G[G_ANIM]*2);
			Link->Jump = 0;
			hairFrame = Floor(G[G_ANIM]/4)%4;
			SetLinkScriptTile(TIL_ASTER_LUMINAIRE+1+hairFrame, 0, 2);
			G[G_NOACTION] = 1;
			flashFrame = Floor(G[G_ANIM]/4)%4;
			if(flashFrame==3)
				flashFrame = 1;
			Screen->DrawTile(4, Link->X+Rand(-1, 1), Link->Y+Link->DrawYOffset+Rand(-1, 1)-Link->Z-16, TIL_ASTER_LUMINAIRE+40-20+40*flashFrame+1+hairFrame, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->Quake = 10;
			Waitframe();
		}
		for(int i=0; i<32; ++i){
			Screen->Rectangle(6, 0, -16, 255, 175+16, 0x83, 1, 0, 0, 0, true, 128);
			if(i<8){
				MakeHitboxLW(LW_STARWANDIMPACT, 0, 0, 256, 176, this->Power*2, -1);
			}
			if(i>=16){
				if(i<8)
					Screen->Rectangle(6, 0, -16, 255, 175+16, 0x01, 1, 0, 0, 0, true, 64);
				Screen->Rectangle(6, 0, -16, 255, 175+16, 0x01, 1, 0, 0, 0, true, 64);
			}
			else
				Screen->Rectangle(6, 0, -16, 255, 175+16, 0x01, 1, 0, 0, 0, true, 128);
			Link->Z = z+Sin(G[G_ANIM]*2);
			Link->Jump = 0;
			hairFrame = Floor(G[G_ANIM]/4)%4;
			SetLinkScriptTile(TIL_ASTER_LUMINAIRE+1+hairFrame, 0, 2);
			G[G_NOACTION] = 1;
			flashFrame = Floor(G[G_ANIM]/4)%4;
			if(flashFrame==3)
				flashFrame = 1;
			Screen->DrawTile(4, Link->X+Rand(-1, 1), Link->Y+Link->DrawYOffset+Rand(-1, 1)-Link->Z-16, TIL_ASTER_LUMINAIRE+40-20+40*flashFrame+1+hairFrame, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			Waitframe();
		}
		G[G_METEOREFFECTSFRAMES] = 30*60;
		eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
		e->CollDetection = false;
		e->DrawYOffset = -1000;
		RunEWeaponScript(e, "MeteorBurning", 0);
		for(int i=0; i<32; ++i){
			if(i>=16){
				if(i<8)
					Screen->Rectangle(6, 0, -16, 255, 175+16, 0x83, 1, 0, 0, 0, true, 64);
				Screen->Rectangle(6, 0, -16, 255, 175+16, 0x83, 1, 0, 0, 0, true, 64);
			}
			else
				Screen->Rectangle(6, 0, -16, 255, 175+16, 0x83, 1, 0, 0, 0, true, 128);
			G[G_NOACTION] = 1;
			Link->Z = z+Sin(G[G_ANIM]*2);
			Link->Jump = 0;
			Waitframe();
		}
	}
}

lweapon script MeteorFire{
	void DrawMeteorFire(lweapon this, int scale, int skewAng, int t){
		int x = this->X+VectorXSkew(8, 4, t*1.5, skewAng)+Rand(-1, 1);
		int y = this->Y+VectorYSkew(8, 4, t*1.5, skewAng)+Rand(-1, 1);
		
		Screen->DrawTile(4, x+8-(8*scale), y+8-(8*scale), this->Tile, 1, 1, this->CSet, 16*scale, 16*scale, 0, 0, 0, 0, true, 128);
	
		MakeHitboxLW(LW_FIRE, x+8-(8*scale), y+8-(8*scale), 16*scale, 16*scale, this->Damage, this->Dir);
	}
	void run(){
		int skewAng = Rand(360);
		int t;
		int scale = 0; 
		int timer = 0;
		while(scale<1){
			scale += 0.05;
			
			DrawMeteorFire(this, scale, skewAng, t);
			++t;
			
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		for(int i=0; i<96; ++i){
			DrawMeteorFire(this, scale, skewAng, t);
			++t;
			
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		while(scale>0){
			scale -= 0.05;
			
			DrawMeteorFire(this, scale, skewAng, t);
			++t;
			
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		this->DeadState = 0;
	}
}

const int TIL_FISHINGROD = 67101;

const int I_BATTERY_SOLAR = 173;
const int I_BATTERY_LUNAR = 174;
const int I_BATTERY_STELLAR = 175;

const int I_BOMBAMMO5 = 78;
const int I_BOMBAMMO10 = 79;

void DrawFishingRod(int dir, int linkX, int linkY, int frame, int tipXY, int hookX, int hookY, int hookZ, bool drawHook){
	//A map of the coordinates the fishing rod uses on each frame of the animation.
	//Up
	//Down
	//Left
	//Right
	int coordmap[] =
	{
		0,   0,         0, -7,         0, -14,
		0,  -7,         0,  0,         4,  14,
		0, -14,        -10, -10,        -14, -2,
		0, -14,         10, -10,         14, -2
	};
	int tipMap[] = 
	{
		11, 15,			09, 03,			09, 00,
		06, 03,			04, 15,			06, 15,
		13, 00,			02, 03,			00, 14,
		02, 00,			13, 03,			15, 14
	};
	int layerMap[] = 
	{
		2,				2,				2,
		2,				4,				4,
		2,				2,				2,
		2,				2,				2
	};
	int x = linkX;
	int y = linkY;
	int frame2 = frame;
	if(frame==3)
		frame2 = 1;
	if(frame==4)
		frame2 = 0;
	
	x += coordmap[dir*6+frame2*2+0];
	y += coordmap[dir*6+frame2*2+1];
	
	tipXY[0] = x+tipMap[dir*6+frame2*2+0];
	tipXY[1] = y+tipMap[dir*6+frame2*2+1];

	int x2 = (tipXY[0]+hookX+8)/2;
	int y2 = (tipXY[1]+hookY+8-hookZ)/2-hookZ;
	
	if(drawHook)
		DrawLineBezier(layerMap[dir*3+frame2], tipXY[0], tipXY[1], x2, y2, hookX+8, hookY+8-hookZ, 0x0F, 16);
	
	Screen->FastTile(layerMap[dir*3+frame2], x, y, TIL_FISHINGROD+dir*3+frame2, 8, 128);
	
	if(drawHook)
		Screen->FastTile(layerMap[dir*3+frame2], hookX, hookY-hookZ, TIL_FISHINGROD+12+dir, 8, 128);
	// int x;
	// int y;
	// int tile = TIL_FISHINGROD;
	// int flip;
	// switch(dir){
		// case DIR_UP:
			// if(reeling){
				// ++tile;
				// x = rodX+8;
				// y = rodY+2;
			// }
			// else{
				// x = rodX+8;
				// y = rodY;
			// }
			// break;
		// case DIR_DOWN:
			// flip = 2;
			// if(reeling){
				// ++tile;
				// x = rodX+8;
				// y = rodY+13;
			// }
			// else{
				// x = rodX+8;
				// y = rodY+15;
			// }
			// break;
		// case DIR_LEFT:
			// tile += 2;
			// flip = 1;
			// if(reeling){
				// ++tile;
				// x = rodX+2;
				// y = rodY+8;
			// }
			// else{
				// x = rodX;
				// y = rodY+6;
			// }
			// break;
		// case DIR_RIGHT:
			// tile += 2;
			// if(reeling){
				// ++tile;
				// x = rodX+13;
				// y = rodY+8;
			// }
			// else{
				// x = rodX+15;
				// y = rodY+6;
			// }
			// break;
	// }
	// int x2 = (x+hookX+8)/2;
	// int y2 = (y+hookY+8-hookZ)/2-hookZ;
	// DrawLineBezier(2, x, y, x2, y2, hookX+8, hookY+8-hookZ, 0x0F, 16);
	// hookY -= hookZ;
	// Screen->DrawTile(2, rodX, rodY, tile, 1, 1, 8, -1, -1, 0, 0, 0, flip, true, 128);
	// Screen->DrawTile(2, hookX, hookY, TIL_FISHINGROD+4+dir, 1, 1, 8, -1, -1, 0, 0, 0, 0, true, 128);
}

itemdata script FishingRod{
	int CanStun(npc n){
		switch(n->ID){
			//Solar Batteries
			case 186: //Solar Cultist
			case 206: //Solar Cultist (Battery)
				if(G[G_RANDOMIZERENABLED]||Link->Item[I_ABILITY_B_TORRIN])return 2; //Grabbed Battery
			//Lunar Batteries
			case 188: //Lunar Cultist
			case 193: //Pirate (Lunar)
			case 207: //Lunar Cultist (Battery)
				if(G[G_RANDOMIZERENABLED]||Link->Item[I_ABILITY_B_TORRIN])return 3; //Grabbed Battery
			case 211: //Stellar Cultist
			case 208: //Stellar Cultist (Battery)
				if(G[G_RANDOMIZERENABLED]||Link->Item[I_ABILITY_B_TORRIN])return 4; //Grabbed Battery
			//Ungrabbables
			case 195: //Piranha
			case 201: //Wall Chaser
			case 202: //Wall Chaser
			case 199: //Cannon
			case 200: //Cannon
				return 0;
			
		}
		
		if(!(n->Misc[NPCM_FLAGS]&NPCMF_HASROBBED))
			return n->ItemSet+100;
		
		return 1; //Stunned
	}
	int GetItemFromDropset(int dropset){
		int rupee10 = I_RUPEE5;
		int rupee20 = I_RUPEE5;
		switch(dropset){
			case 1: //Default
				return GetItemFromPool({I_RUPEE1,20,  rupee10,2, I_RUPEE5,5, I_HEART,15});
			case 2: //Bombs
				return GetItemFromPool({I_BOMBAMMO5,25,  I_RUPEE1,15,  I_HEART,5,  I_RUPEE5,5});
			case 3: //Rupees
				return GetItemFromPool({rupee20,1,  rupee10,4,  I_RUPEE5,20,  I_RUPEE1,30,  I_HEART,10});
			case 4: //Life
				return GetItemFromPool({I_HEART,40,  I_RUPEE5,10});
			case 5: //Bomb 100%
				return I_BOMBAMMO5;
			case 7: //Magic
				return GetItemFromPool({I_RUPEE1,20,  I_HEART,5});
			case 8: //Magic + Bombs
				return GetItemFromPool({I_BOMBAMMO5,20,  I_RUPEE5,5,  I_RUPEE1,15});
			case 9: //Magic + Rupees
				return GetItemFromPool({rupee10,5,  I_RUPEE1,20,  I_RUPEE5,10});
			case 10: //Magic + Life
				return I_HEART;
			case 13: //Trash
				return GetItemFromPool({I_RUPEE1,2,  I_HEART,2});
		}
		return -1;
	}
	int ReplaceHeartWithBattery(){
		if(!FoundItems[I_ABILITY_B_TORRIN]&&!G[G_RANDOMIZERENABLED])
			return I_HEART;
		
		int leastNum = 100;
		int least;
		if(Game->Counter[CR_SOLARBATTERY]<leastNum&&Game->Counter[CR_SOLARBATTERY]<Game->MCounter[CR_SOLARBATTERY]){
			leastNum = Game->Counter[CR_SOLARBATTERY];
			least = 1;
		}
		if(Game->Counter[CR_LUNARBATTERY]<leastNum&&Game->Counter[CR_LUNARBATTERY]<Game->MCounter[CR_LUNARBATTERY]){
			leastNum = Game->Counter[CR_LUNARBATTERY];
			least = 2;
		}
		
		switch(least){
			case 1:
				return I_BATTERY_SOLAR;
			case 2:
				return I_BATTERY_LUNAR;
		}
		return I_HEART;
	}
	void SpawnRobbedItems(npc target, int grabType, int dir, int angle, int count){
		if(grabType>100){
			target->Misc[NPCM_FLAGS] |= NPCMF_HASROBBED;
			npcdata nd = Game->LoadNPCData(target->ID);
			int numDrops = 1;
			if(Rand(5)==0||(target->HP<=200&&target->HP<nd->HP))
				numDrops = Rand(1, 3);
			if(Rand(100)==0)
				numDrops = 10;
			if((target->ID==217||target->ID==235)&&!G[G_ROBBEDSELET])
				numDrops = 10;
			for(int i=0; i<numDrops; ++i){
				int drop = GetItemFromDropset(grabType-100);
				if(target->ID==217||target->ID==235){
					G[G_ROBBEDSELET] = 1;
					drop = I_RUPEE5;
				}
				if(drop>-1){
					if(drop==I_HEART&&Rand(4)==0)
						drop = ReplaceHeartWithBattery();
					if(drop==I_HEART&&LifeMaxed())
						drop = I_RUPEE1;
					if((drop==I_BOMBAMMO5||drop==I_BOMBAMMO10)&&!Link->Item[I_LOBBOMB])
						drop = I_RUPEE1;
					itemsprite itm = CreateItemAt(drop, HitboxCenterX(target)-8, HitboxCenterY(target)-8);
					//itm->Pickup = IP_TIMEOUT;
					itm->Script = Game->GetItemSpriteScript("BounceAndAutoCollect");
					itm->InitD[0] = angle+180+Rand(-60, 60);
					itm->InitD[1] = i*8;
					itm->MoveFlags[WPNMV_CAN_PITFALL] = false;
				}
			}
		}
		else{
			for(int i=0; i<count; ++i){
				if(grabType==2){
					target->Misc[NPCM_FLAGS] |= NPCMF_HASROBBED;
					itemsprite itm = CreateItemAt(I_BATTERY_SOLAR, HitboxCenterX(target)-8, HitboxCenterY(target)-8);
					//itm->Pickup = IP_TIMEOUT;
					itm->Script = Game->GetItemSpriteScript("BounceAndAutoCollect");
					itm->InitD[0] = angle+180+Rand(-60, 60);
					itm->InitD[1] = i*8;
					// itm->Script = Game->GetItemSpriteScript("BounceOff");
					// itm->InitD[0] = OppositeDir(dir);
					// itm->InitD[1] = angle+Rand(-30, 30);
				}
				else if(grabType==3){
					target->Misc[NPCM_FLAGS] |= NPCMF_HASROBBED;
					itemsprite itm = CreateItemAt(I_BATTERY_LUNAR, HitboxCenterX(target)-8, HitboxCenterY(target)-8);
					//itm->Pickup = IP_TIMEOUT;
					itm->Script = Game->GetItemSpriteScript("BounceAndAutoCollect");
					itm->InitD[0] = angle+180+Rand(-60, 60);
					itm->InitD[1] = i*8;
					// itm->Script = Game->GetItemSpriteScript("BounceOff");
					// itm->InitD[0] = OppositeDir(dir);
					// itm->InitD[1] = angle+Rand(-30, 30);
				}
				else if(grabType==4){
					target->Misc[NPCM_FLAGS] |= NPCMF_HASROBBED;
					itemsprite itm = CreateItemAt(I_BATTERY_STELLAR, HitboxCenterX(target)-8, HitboxCenterY(target)-8);
					//itm->Pickup = IP_TIMEOUT;
					itm->Script = Game->GetItemSpriteScript("BounceAndAutoCollect");
					itm->InitD[0] = angle+180+Rand(-60, 60);
					itm->InitD[1] = i*8;
					// itm->Script = Game->GetItemSpriteScript("BounceOff");
					// itm->InitD[0] = OppositeDir(dir);
					// itm->InitD[1] = angle+Rand(-30, 30);
				}
			}
		}
	}
	
	void run(){
		Waitframe();
		int dir = Link->Dir;
		int rodX = Link->X+DirX(Link->Dir, 16);
		int rodY = Link->Y+DirY(Link->Dir, 16);
		int hookX = Link->X+DirX(Link->Dir, 16);
		int hookY = Link->Y+DirY(Link->Dir, 16);
		int hookJump = 2.4;
		int hookZ;
		int hookAngle = -1000;
		if(G[G_TORRINLOCKON]){
			hookAngle = Angle(rodX, rodY, G[G_TORRINLOCKONTARGETX], G[G_TORRINLOCKONTARGETY]);
		}
		int tipXY[2];
		for(int i=0; i<3; ++i){
			for(int j=0; j<4; ++j){
				DrawFishingRod(Link->Dir, Link->X, Link->Y+Link->DrawYOffset, i, tipXY, hookX, hookY+Link->DrawYOffset, hookZ, false);
				if(i==2){
					switch(Link->Dir){
						case DIR_UP:
							SetLinkScriptTile(104189+2, 0, 2);
							break;
						case DIR_DOWN:
							SetLinkScriptTile(104189, 0, 2);
							break;
						case DIR_LEFT:
							SetLinkScriptTile(104189+1, 0, 2);
							break;
						case DIR_RIGHT:
							SetLinkScriptTile(104189+1, 1, 2);
							break;
					}
				}
				G[G_NOACTION] = 1;
				Waitframe();
			}
		}
		hookX = tipXY[0]-8;
		hookY = tipXY[1]-8;
		Game->PlaySound(SFX_JUMP);
		while(hookJump>0||hookZ>0){
			rodX = Link->X+DirX(Link->Dir, 16);
			rodY = Link->Y+DirY(Link->Dir, 16);
			hookZ = Max(0, hookZ+hookJump);
			hookJump = Clamp(hookJump-0.24, -3.2, 3.2);
			if(hookAngle>-1000){
				hookX += VectorX(3, hookAngle);
				hookY += VectorY(3, hookAngle);
			}
			else{
				hookX += DirX(dir, 3);
				hookY += DirY(dir, 3);
			}
			DrawFishingRod(Link->Dir, Link->X, Link->Y+Link->DrawYOffset, 2, tipXY, hookX, hookY+Link->DrawYOffset, hookZ, true);
			//DrawFishingRod(dir, rodX, rodY+Link->DrawYOffset, hookX, hookY+Link->DrawYOffset, hookZ, false);
			switch(Link->Dir){
				case DIR_UP:
					SetLinkScriptTile(104189+2, 0, 2);
					break;
				case DIR_DOWN:
					SetLinkScriptTile(104189, 0, 2);
					break;
				case DIR_LEFT:
					SetLinkScriptTile(104189+1, 0, 2);
					break;
				case DIR_RIGHT:
					SetLinkScriptTile(104189+1, 1, 2);
					break;
			}
			G[G_NOACTION] = 1;
			Waitframe();
		}
		npc target;
		int grabType;
		lweapon hook = MakeHitboxLW(LW_SCRIPT10, hookX+(dir==DIR_RIGHT?-16:0), hookY+(dir==DIR_DOWN?-16:0), 16+Abs(DirX(dir, 16)), 16+Abs(DirY(dir, 16)), Link->Dir, 0);
		hook->CollDetection = false;
		GLW[GL_TORRINHOOK] = hook;
		for(int i=Screen->NumNPCs(); i>0; --i){
			npc n = Screen->LoadNPC(i);
			if(n->CollDetection&&n->HitWidth<=16&&n->HitHeight<=16&&Collision(n, hook)){ //RectCollision(n->X+n->HitXOffset, n->Y+n->HitYOffset, n->X+n->HitXOffset+n->HitWidth-1, n->Y+n->HitYOffset+n->HitHeight-1, hookX, hookY, hookX+15, hookY+15)){
				int type = CanStun(n);
				if(type>1&&n->Misc[NPCM_FLAGS]&NPCMF_HASROBBED)
					type = 1;
				if(type>grabType){
					target = n;
					grabType = type;
				}
			}
		}
		if(grabType>0&&target->isValid()){
			if(!(target->Misc[NPCM_FLAGS]&NPCMF_HASROBBED)&&target->Type!=NPCT_TRAP){
				Game->PlaySound(SFX_EHIT);
				if(target->Misc[NPCM_STUNCOOLDOWN]<=0){
					target->Stun = Max(target->Stun, 180);
				}
				Game->PlaySound(124);
				ParticleAnim(CenterX(target)-8+Rand(-4, 4), CenterY(target)-8+Rand(-4, 4), 65700, 8, 6, 2);
				SpawnRobbedItems(target, grabType, dir, Angle(HitboxCenterX(target)-8, HitboxCenterY(target)-8, Link->X, Link->Y), 3);
			}
			else{
				Game->PlaySound(SFX_EHIT);
				if(target->Misc[NPCM_STUNCOOLDOWN]<=0&&target->Type!=NPCT_TRAP){
					target->Stun = Max(target->Stun, 180);
				}
			}
		}
		while(Distance(hookX, hookY, rodX, rodY)>6){
			if(!target->isValid()){
				for(int i=Screen->NumNPCs(); i>0; --i){
					npc n = Screen->LoadNPC(i);
					if(n->CollDetection&&n->HitWidth<=16&&n->HitHeight<=16&&RectCollision(n->X+n->HitXOffset, n->Y+n->HitYOffset, n->X+n->HitXOffset+n->HitWidth-1, n->Y+n->HitYOffset+n->HitHeight-1, hookX, hookY, hookX+15, hookY+15)){
						int type = CanStun(n);
						if(type>0){
							if(!target->isValid())
								Game->PlaySound(SFX_EHIT);
							target = n;
							grabType = type;
						}
					}
				}
			}
			if(grabType>0&&target->isValid()){
				if(target->Misc[NPCM_STUNCOOLDOWN]<=0&&target->Type!=NPCT_TRAP){
					target->Stun = Max(target->Stun, 60);
				}
				// if(!(target->Misc[NPCM_FLAGS]&NPCMF_HASROBBED)){
					// Game->PlaySound(SFX_EHIT);
					// target->Stun = Max(target->Stun, 180);
					// SpawnBatteries(target, grabType, Link->Dir, Angle(HitboxCenterX(target)-8, HitboxCenterY(target)-8, Link->X, Link->Y), 3);
				// }
			}
			for(int i=0; i<3; ++i){
				if(target->isValid()&&(grabType!=0||target->Type==NPCT_TRAP)){
					if(CanWalkNPC(target->X, target->Y, OppositeDir(dir), 1, true)){
						SetEnemyProperty(target, ENPROP_X, target->X+DirX(OppositeDir(dir), 1));
						SetEnemyProperty(target, ENPROP_Y, target->Y+DirY(OppositeDir(dir), 1));
						npc lockonTarget = Screen->LoadNPCByUID(G[G_TORRINLOCKONTARGET]);
						if(lockonTarget->isValid()&&lockonTarget==target)
							G[G_TORRINLOCKONDISABLEMOVE] = 1;
					}
				}
			}
			rodX = Link->X+DirX(Link->Dir, 16);
			rodY = Link->Y+DirY(Link->Dir, 16);
			int angle = Angle(hookX, hookY, rodX, rodY);
			hookX += VectorX(6, angle);
			hookY += VectorY(6, angle);
			//G[G_NOACTION] = 1;
			DrawFishingRod(Link->Dir, Link->X, Link->Y+Link->DrawYOffset, 1, tipXY, hookX, hookY+Link->DrawYOffset, hookZ, true);
			// switch(Link->Dir){
				// case DIR_UP:
					// SetLinkScriptTile(104189+2, 0, 2);
					// break;
				// case DIR_DOWN:
					// SetLinkScriptTile(104189, 0, 2);
					// break;
				// case DIR_LEFT:
					// SetLinkScriptTile(104189+1, 0, 2);
					// break;
				// case DIR_RIGHT:
					// SetLinkScriptTile(104189+1, 1, 2);
					// break;
			// }
			//G[G_NOACTION] = 1;
			if(GLW[GL_TORRINHOOK]->isValid())
				GrabItems(GLW[GL_TORRINHOOK]);
			if(Link->Action==LA_SCROLLING)
				Quit();
			Waitframe();
		}
		for(int j=0; j<4; ++j){
			DrawFishingRod(Link->Dir, Link->X, Link->Y+Link->DrawYOffset, 0, tipXY, hookX, hookY+Link->DrawYOffset, hookZ, false);
			if(Link->Action==LA_SCROLLING)
				Quit();
			Waitframe();
		}
	}
}

bool LifeMaxed(){
	int oldID = GetCharID();
	int newID = GetSwapCharID(oldID, 1, true);
	return Link->HP>=Link->MaxHP&&newID==oldID;
}

itemsprite script BounceAndAutoCollect{
	void run(int angle, int delay){
		switch(this->ID){
			case I_HEART:
				if(Link->HP>=Link->MaxHP){
					int oldID = GetCharID();
					int newID = GetSwapCharID(oldID, 1, true);
					if(newID==oldID){
						this->Remove();
						Quit();
					}
				}
				this->OriginalTile = 63770;
				this->Tile = this->OriginalTile;
				break;
			case I_MAGICJAR1:
			case I_MAGICJAR2:
				// this->Remove();
				// Quit();
				break;
			case 78...79: //Bombs
				if(!Link->Item[I_LOBBOMB]){
					this->Remove();
					Quit();
				}
				this->OriginalTile = this->ID==78?64071:64073;
				this->Tile = this->OriginalTile;
				break;
		}
		
		int drawYOff = this->DrawYOffset;
		for(int i=0; i<delay; ++i){
			this->DrawYOffset = -1000;
			Waitframe();
		}
		this->DrawYOffset = drawYOff;
		
		this->Jump = Rand(12, 18)/10;
		int startJump = this->Jump;
		int x = this->X;
		int y = this->Y;
		int vX = VectorX(2, angle);
		int vY = VectorY(2, angle);
		int accel = 0.1;
		while(Abs(AngDiff(Angle(0, 0, vX, vY), Angle(x, y, Link->X, Link->Y)))>60){
			vX = LazyChase(vX, x, Link->X, 0.1, 2);
			vY = LazyChase(vY, y, Link->Y, 0.1, 2);
			x += vX;
			y += vY;
			this->X = x;
			this->Y = y;
			if(this->Z==0)
				this->Jump = startJump;
			Waitframe();
		}
		int step = Distance(0, 0, vX, vY);
		while(true){
			angle = Angle(x, y, Link->X, Link->Y);
			if(step<4)
				step += 0.1;
			x += VectorX(step, angle);
			y += VectorY(step, angle);
			this->X = x;
			this->Y = y;
			if(this->Z==0)
				this->Jump = startJump;
			Waitframe();
		}
	}
}

itemsprite script BounceOff{
	void run(int dir, int angle){
		this->Jump = 1.8;
		int x = this->X;
		int y = this->Y;
		if(angle>-1000){
			dir = AngleDir4(angle);
		}
		while(this->Jump>0||this->Z>0){
			if(!Screen->isSolid(x+8, y+8)){
				if(angle==-1000){
					x += DirX(dir, 1.5);
					y += DirY(dir, 1.5);
				}
				else{
					x += VectorX(1.5, angle);
					y += VectorY(1.5, angle);
				}
			}
			else{
				dir = OppositeDir(dir);
				angle = WrapDegrees(angle+180);
			}
			this->X = x;
			this->Y = y;
			Waitframe();
		}
	}
}	

const int TIL_SHOCKTRAP = 65133;
const int SFX_SHOCKTRAP = 77;

itemdata script ShockTrap{
	void DrawShock(int layer, int x, int y, int rad, int c, int lightning, bool resetLightning){
		Screen->Circle(layer, x, y, rad, c, 1, 0, 0, 0, true, 128);
		int angle = Rand(360);
		for(int i=0; i<6; ++i){
			int tempAng = angle+60*i+Rand(-20, 20);
			LightningBolt(lightning, i*20, 4, x+VectorX(rad-8, tempAng), y+VectorY(rad-8, tempAng), tempAng, 12, 12, 35, 4, c, resetLightning);
		}
	}
	void GetAbsorbData(int data, npc n){
		switch(n->ID){
			//Solar Elemental
			case 180:
				data[0] = 1;
				data[1] = 5;
				data[2] = 51200;
				data[3] = 0;
				data[4] = 1;
				data[5] = 1;
				break; //Grabbed Battery
			//Lunar Elemental
			case 181:
				data[0] = 2;
				data[1] = 5;
				data[2] = 51208;
				data[3] = 0;
				data[4] = 1;
				data[5] = 1;
				break; //Grabbed Battery
			//Stellar Elemental
			case 182:
				data[0] = 3;
				data[1] = 2;
				data[2] = 51216;
				data[3] = 0;
				data[4] = 1;
				data[5] = 1;
				break; //Grabbed Battery
			//Solar Golem
			case 183:
				data[0] = 1;
				data[1] = 10;
				data[2] = 51248;
				data[3] = 0;
				data[4] = 1;
				data[5] = 2;
				break; //Grabbed Battery
			//Lunar Golem
			case 184:
				data[0] = 2;
				data[1] = 10;
				data[2] = 51256;
				data[3] = 0;
				data[4] = 1;
				data[5] = 2;
				break; //Grabbed Battery
			//Stellar Golem
			case 185:
				data[0] = 3;
				data[1] = 5;
				data[2] = 51264;
				data[3] = 0;
				data[4] = 1;
				data[5] = 2;
				break; //Grabbed Battery
		}
	}
	void run(){
		int trapX = Link->X+DirX(Link->Dir, 16);
		int trapY = Link->Y+DirY(Link->Dir, 16);
		Game->PlaySound(SFX_PLACE);
		int type;
		int count;
		int nX; int nY;
		int combo;
		int cset;
		int w; int h;
		int xOff; int yOff;
		npc target;
		int lightning[256];
		while(true){
			if(Link->Action==LA_SCROLLING||G[G_SCREENCHANGED]){
				Quit();
			}
			for(int i=Screen->NumNPCs(); i>0; --i){
				npc n = Screen->LoadNPC(i);
				int data[6];
				GetAbsorbData(data, n);
				if(n->Stun>0&&n->Z==0&&data[0]>0&&RectCollision(n->X+n->HitXOffset, n->Y+n->HitYOffset, n->X+n->HitXOffset+n->HitWidth-1, n->Y+n->HitYOffset+n->HitHeight-1, trapX, trapY, trapX+15, trapY+15)){
					if(data[0]>type){
						target = n;
						type = data[0];
						count = data[1];
						nX = n->X+n->DrawXOffset;
						nY = n->Y+n->DrawYOffset;
						combo = data[2]+n->Dir;
						cset = data[3];
						w = data[4];
						h = data[5];
						xOff = n->HitXOffset;
						yOff = n->HitYOffset;
					}
				}
			}
			Screen->FastTile(2, trapX, trapY, TIL_SHOCKTRAP+Floor(G[G_ANIM]/2)%4, 11, 128);
			if(type>0)
				break;
			Waitframe();
		}
		combodata cdat = Game->LoadComboData(combo);
		int tile = cdat->Tile;
		int flip = cdat->Flip;
		GBMP[BMP_TORRINSHOCKTRAP]->Clear(0);
		GBMP[BMP_TORRINSHOCKTRAP]->DrawTile(0, 0, 0, tile, w, h, cset, -1, -1, 0, 0, 0, flip, true, 128);
		GBMP[BMP_TORRINSHOCKTRAP]->ReplaceColors(0, 0x0F, 1, 255);
		
		if(type>0){
			Game->PlaySound(SFX_SHOCKTRAP);
			SetEnemyProperty(target, ENPROP_HP, -1000);
			target->DrawYOffset = -1000;
			target->ItemSet = 0;
			for(int i=0; i<48; ++i){
				if(Link->Action==LA_SCROLLING||G[G_SCREENCHANGED]){
					Quit();
				}
				if(i%8<4){
					DrawShock(4, nX+w*8, nY+h*8, w*8+h*8, (i%16<8)?0x01:0xB2, lightning, true);
					GBMP[BMP_TORRINSHOCKTRAP]->Blit(4, RT_SCREEN, 0, 0, w*16, h*16, nX, nY, w*16, h*16, 0, 0, 0, 0, 0, true);
				}
				else{
					Screen->DrawTile(4, nX, nY, tile, w, h, cset, -1, -1, 0, 0, 0, flip, true, 128);
				}
				Screen->FastTile(2, trapX, trapY, TIL_SHOCKTRAP+Floor(G[G_ANIM]/2)%4, 11, 128);
					
				Waitframe();
			}
			for(int i=0; i<count; ++i){
				int id;
				if(type==1)
					id = I_BATTERY_SOLAR;
				else if(type==2)
					id = I_BATTERY_LUNAR;
				else if(type==3)
					id = I_BATTERY_STELLAR;
				item itm = CreateItemAt(id, nX+w*8-8, nY+h*8-8);
				itm->Pickup = IP_TIMEOUT;
				itm->Script = Game->GetItemSpriteScript("BounceOff");
				itm->InitD[0] = 0;
				itm->InitD[1] = Rand(360);
			}
		}
	}
}

const int TIL_BATTERYITEM = 65132;
const int TIL_BATTERYITEMTERRY = 65239;
const int TIL_BATTERYNUMBERS = 65480;

bool HoldingItem(){
	switch(Link->Action){
		case LA_HOLD1LAND:
		case LA_HOLD2LAND:
		case LA_HOLD1WATER:
		case LA_HOLD2WATER:
			return true;
	}
	return false;
}

void UpdateBatteryTiles(){
	//Torrin's batteries
	if(!FoundItems[I_ABILITY_B_TORRIN]){
		CopyTile(64616, TIL_BATTERYITEM);
	}
	else if(!HoldingItem()){
		switch(G[G_EQUIPPEDBATTERYTYPE]){
			case 0:
				CopyTile(65112, TIL_BATTERYITEM);
				int ones = Game->Counter[CR_SOLARBATTERY]%10;
				int tens = Floor(Game->Counter[CR_SOLARBATTERY]/10);
				OverlayTile(TIL_BATTERYITEM, TIL_BATTERYNUMBERS+20+ones);
				OverlayTile(TIL_BATTERYITEM, TIL_BATTERYNUMBERS+tens);
				break;
			case 1:
				CopyTile(65113, TIL_BATTERYITEM);
				int ones = Game->Counter[CR_LUNARBATTERY]%10;
				int tens = Floor(Game->Counter[CR_LUNARBATTERY]/10);
				OverlayTile(TIL_BATTERYITEM, TIL_BATTERYNUMBERS+20+ones);
				OverlayTile(TIL_BATTERYITEM, TIL_BATTERYNUMBERS+tens);
				break;
			case 2:
				CopyTile(65114, TIL_BATTERYITEM);
				int ones = Game->Counter[CR_STELLARBATTERY]%10;
				int tens = Floor(Game->Counter[CR_STELLARBATTERY]/10);
				OverlayTile(TIL_BATTERYITEM, TIL_BATTERYNUMBERS+20+ones);
				OverlayTile(TIL_BATTERYITEM, TIL_BATTERYNUMBERS+tens);
				break;
		}
	}
	
	//Terry's batteries
	if(!FoundItems[I_ABILITY_B_TERRY]){
		CopyTile(64617, TIL_BATTERYITEMTERRY);
	}
	else if(!HoldingItem()){
		switch(G[G_EQUIPPEDBATTERYTYPETERRY]){
			case 0:
				CopyTile(65112, TIL_BATTERYITEMTERRY);
				int ones = Game->Counter[CR_SOLARBATTERY]%10;
				int tens = Floor(Game->Counter[CR_SOLARBATTERY]/10);
				OverlayTile(TIL_BATTERYITEMTERRY, TIL_BATTERYNUMBERS+20+ones);
				OverlayTile(TIL_BATTERYITEMTERRY, TIL_BATTERYNUMBERS+tens);
				break;
			case 1:
				CopyTile(65113, TIL_BATTERYITEMTERRY);
				int ones = Game->Counter[CR_LUNARBATTERY]%10;
				int tens = Floor(Game->Counter[CR_LUNARBATTERY]/10);
				OverlayTile(TIL_BATTERYITEMTERRY, TIL_BATTERYNUMBERS+20+ones);
				OverlayTile(TIL_BATTERYITEMTERRY, TIL_BATTERYNUMBERS+tens);
				break;
			case 2:
				CopyTile(65114, TIL_BATTERYITEMTERRY);
				int ones = Game->Counter[CR_STELLARBATTERY]%10;
				int tens = Floor(Game->Counter[CR_STELLARBATTERY]/10);
				OverlayTile(TIL_BATTERYITEMTERRY, TIL_BATTERYNUMBERS+20+ones);
				OverlayTile(TIL_BATTERYITEMTERRY, TIL_BATTERYNUMBERS+tens);
				break;
		}
	}
	
	//Bloodmoon gauntlet
	if(!FoundItems[I_ABILITY_C_TERRY]){
		CopyTile(67309, 67329);
	}
	else if(!HoldingItem()){
		CopyTile(67309, 67329);
		int ones = Game->Counter[CR_LUNARBATTERY]%10;
		int tens = Floor(Game->Counter[CR_LUNARBATTERY]/10);
		OverlayTile(67329, TIL_BATTERYNUMBERS+20+ones);
		OverlayTile(67329, TIL_BATTERYNUMBERS+tens);
	}
}

itemdata script BatteryPickup{
	void run(int amount, int increasemax){
		if(increasemax){
			Game->MCounter[this->Counter] = Min(Game->MCounter[this->Counter]+10, 99);
			Game->Counter[this->Counter] += 10;
		}
		else if(amount)
			Game->Counter[this->Counter] += amount;
		else
			++Game->Counter[this->Counter];
		Game->Counter[this->Counter] = Clamp(Game->Counter[this->Counter], 0, Game->MCounter[this->Counter]);
		UpdateBatteryTiles();
	}
}

const int TIL_MAGICBATTERY_PROJECTILE = 66040;

itemdata script MagicBattery{
	void run(){
		int i;
		if(!(GetCharID()==CHAR_TERRY&&G[G_RANDOMIZERENABLED])){
			for(i=0; i<16&&InputButtonItem(this->ID); ++i){
				Waitframe();
			}
			if(i==16){
				while(InputButtonItem(this->ID)){
					int g_battery = G_EQUIPPEDBATTERYTYPE;
					if(GetCharID()==CHAR_TERRY&&G[G_RANDOMIZERENABLED])
						g_battery = G_EQUIPPEDBATTERYTYPETERRY;
					Screen->FastTile(6, Link->X, Link->Y-16, TIL_BATTERYITEM-20+3, 7, 128);
					Screen->FastTile(6, Link->X, Link->Y-17, TIL_BATTERYITEM-20+G[g_battery], 7, 128);
					if(G[G_LEFTINPUT]==2)
						--G[g_battery];
					if(G[G_RIGHTINPUT]==2)
						++G[g_battery];
					if(G[g_battery]<0){
						G[g_battery] = 2;
						if(Game->MCounter[CR_STELLARBATTERY] == 0)
							G[g_battery] = 1;
					}
					else{
						if(G[g_battery]>1 && Game->MCounter[CR_STELLARBATTERY] == 0)
							G[g_battery] = 0;
					}
					if(G[g_battery]>2)
						G[g_battery] = 0;
					UpdateBatteryTiles();
					G[G_NOWALK] = 1;
					Waitframe();
				}
				Quit();
			}
		}
		if(GetCharID()==CHAR_TERRY&&G[G_RANDOMIZERENABLED]){
			runTerry(this);
		}
		else{
			int cr = CR_SOLARBATTERY;
			if(G[G_EQUIPPEDBATTERYTYPE]==1)
				cr = CR_LUNARBATTERY;
			else if(G[G_EQUIPPEDBATTERYTYPE]==2)
				cr = CR_STELLARBATTERY;
			if(Game->Counter[cr]>0)
				--Game->Counter[cr];
			else
				Quit();
			Game->PlaySound(SFX_JUMP);
			Link->Action = LA_ATTACKING;
			int dir = Link->Dir;
			lweapon battery = CreateLWeaponAt(LW_SCRIPT10, Link->X+DirX(Link->Dir, 8), Link->Y+DirY(Link->Dir, 8));
			battery->CollDetection = false;
			battery->OriginalTile = TIL_MAGICBATTERY_PROJECTILE+20*G[G_EQUIPPEDBATTERYTYPE];
			battery->Tile = battery->OriginalTile;
			battery->NumFrames = 4;
			battery->ASpeed = 2;
			battery->Damage = 300;
			int z = 8;
			battery->Z = z;
			int angle = -1000;
			if(G[G_TORRINLOCKON]){
				angle = Angle(battery->X, battery->Y, G[G_TORRINLOCKONTARGETX], G[G_TORRINLOCKONTARGETY]);
			}
			battery->Script = Game->GetLWeaponScript("MagicBatteryLW");
			battery->InitD[0] = G[G_EQUIPPEDBATTERYTYPE];
			battery->InitD[1] = angle;
			battery->InitD[2] = 0;
			switch(G[G_EQUIPPEDBATTERYTYPE]){
				case 0:
					if(HasAugment(I_AUGMENT_ALTBATTERYSOLAR)||GetCharID()==CHAR_TERRY)
						battery->InitD[2] = 1;
					break;
				case 1:
					if(HasAugment(I_AUGMENT_ALTBATTERYLUNAR)||GetCharID()==CHAR_TERRY)
						battery->InitD[2] = 1;
					break;
				case 2:
					if(HasAugment(I_AUGMENT_ALTBATTERYSTELLAR)||GetCharID()==CHAR_TERRY)
						battery->InitD[2] = 1;
					break;
			}
			int jump = 1;
			int step = 4;
			if(G[G_EQUIPPEDBATTERYTYPE]==0&&!HasAugment(I_AUGMENT_ALTBATTERYSOLAR))
				step = 2;
			else if(G[G_EQUIPPEDBATTERYTYPE]==1&&HasAugment(I_AUGMENT_ALTBATTERYLUNAR))
				step = 1;
			Game->PlaySound(SFX_JUMP);
			int x = battery->X;
			int y = battery->Y;
			while(battery->isValid()&&battery->Z>0){
				battery->Dir = dir;
				if(angle>-1000){
					x += VectorX(step, angle);
					y += VectorY(step, angle);
				}
				else{
					switch(dir){
						case DIR_UP:
							y -= step;
							break;
						case DIR_DOWN:
							y += step;
							break;
						case DIR_LEFT:
							x -= step;
							break;
						case DIR_RIGHT:
							x += step;
							break;
					}
				}
				// if(LobBomb_IsSolid(battery, x+8, y+8, false)){
					// Game->PlaySound(SFX_PLACE);
					// if(angle>-1000){
						// angle = WrapDegrees(angle+180);
					// }
					// dir = OppositeDir(dir);
				// }
				battery->X = x;
				battery->Y = y;
				// z = Max(z+jump, 0);
				// jump -= 0.35;
				// battery->Jump = 0;
				// battery->Z = z;
				Waitframe();
			}
		}
	}
	void runTerry(itemdata this){
		int til = 65112;
		int cr = CR_SOLARBATTERY;
		if(G[G_EQUIPPEDBATTERYTYPETERRY]==1){
			cr = CR_LUNARBATTERY;
			til = 65113;
		}
		else if(G[G_EQUIPPEDBATTERYTYPETERRY]==2){
			cr = CR_STELLARBATTERY;
			til = 65114;
		}
		if(Game->Counter[cr]<=0)
			Quit();
		
		for(int i=0; i<16; ++i){
			Screen->FastTile(4, Link->X+5-8, Link->Y-3-8, til, 0, 128);
			SetLinkScriptTile(101599, 0, 2);
			G[G_NOACTION] = 1;
			Waitframe();
		}
		for(int i=0; i<8; ++i){
			int c = Choose(0x86, 0x87, 0x88);
			if(G[G_EQUIPPEDBATTERYTYPETERRY]==1)
				c = Choose(0x72, 0x73, 0x74);
			else if(G[G_EQUIPPEDBATTERYTYPETERRY]==2)
				c = Choose(0x97, 98, 99);
			Screen->Circle(4, Link->X+5, Link->Y-3, Lerp(6, 1, i/7), c, 1, 0, 0, 0, true, 128);
			SetLinkScriptTile(101599, 0, 2);
			G[G_NOACTION] = 1;
			Waitframe();
		}
		int chargeTimer;
		while(InputButtonItemGlobal(this->ID)){
			if(chargeTimer<120+16){
				if(chargeTimer==120)
					Game->PlaySound(SFX_CHARGE1);
				if(chargeTimer>=120){
					int c = Choose(0x86, 0x87, 0x88);
					if(G[G_EQUIPPEDBATTERYTYPETERRY]==1)
						c = Choose(0x72, 0x73, 0x74);
					else if(G[G_EQUIPPEDBATTERYTYPETERRY]==2)
						c = Choose(0x97, 98, 99);
					Screen->Circle(4, Link->X+8, Link->Y+8, Lerp(16, 1, (chargeTimer-120)/16), c, 1, 0, 0, 0, true, 64);
				}
				if(Game->Counter[cr]>=3)
					++chargeTimer;
			}
			Waitframe();
		}
		lweapon battery = CreateLWeaponAt(LW_SCRIPT10, Link->X+DirX(Link->Dir, 8), Link->Y+DirY(Link->Dir, 8));
		battery->CollDetection = false;
		battery->DrawYOffset = -1000;
		battery->Script = Game->GetLWeaponScript("MagicBatteryLWTerry");
		battery->InitD[0] = G[G_EQUIPPEDBATTERYTYPETERRY];
		battery->InitD[1] = 0;
		battery->InitD[2] = (chargeTimer>=120)?1:0;
		if(chargeTimer>=120&&Game->Counter[cr]>=3){
			Game->Counter[cr] -= 3;
		}
		else if(Game->Counter[cr]>0){
			--Game->Counter[cr];
		}
		switch(G[G_EQUIPPEDBATTERYTYPETERRY]){
			case 0:
				if(HasAugment(I_AUGMENT_ALTBATTERYSOLARTERRY))
					battery->InitD[1] = 1;
				break;
			case 1:
				if(HasAugment(I_AUGMENT_ALTBATTERYLUNARTERRY))
					battery->InitD[1] = 1;
				break;
			case 2:
				if(HasAugment(I_AUGMENT_ALTBATTERYSTELLARTERRY))
					battery->InitD[1] = 1;
				break;
		}
	}
}

const int TIL_MAGICBATTERY_SPARKLES = 65035;
const int SFX_TELEKINESIS = 78;

bool LunarBatteryException(npc n){
	if(n->Defense[NPCD_SCRIPT2]==NPCDT_IGNORE||n->Defense[NPCD_SCRIPT2]==NPCDT_BLOCK)
		return true;
	if(n->HitWidth>16||n->HitHeight>16)
		return true;
	if(!n->CollDetection)
		return true;
	switch(n->Type){
		case NPCT_PROJECTILE:
		case NPCT_TRAP:
			return true;
	}
	
	switch(n->ID){
		case 245: //Transformed Selet Hand
		case 246: //Transformed Selet Weak Point
		case 247: //Transformed Selet Egg
		case 248: //Transformed Selet Summon
			return true;
	}
	return false;
}

bool StellarBatteryException(npc n){
	if(n->Defense[NPCD_WAND]==NPCDT_IGNORE||n->Defense[NPCD_WAND]==NPCDT_BLOCK)
		return true;
	if(!n->CollDetection)
		return true;
	switch(n->Type){
		case NPCT_PROJECTILE:
		case NPCT_TRAP:
			return true;
	}
	return false;
}

lweapon script MagicBatteryLW{
	void run(int element, int angle, int subtype){
		Waitframe();
		
		int particleTimer;
		int jump = 1;
		int z = 8;
		while(this->Z>0){
			++particleTimer;
			if(particleTimer%3==0){
				ParticleAnim(this->X+Rand(-4, 4), this->Y+Rand(-4, 4)-this->Z, TIL_MAGICBATTERY_SPARKLES+20*element, 0, 3, 4);
			}
			z = Max(z+jump, 0);
			jump -= 0.35;
			this->Jump = 0;
			this->Z = z;
			Waitframe();
		}
		
		this->DrawYOffset = -1000;
		if(element==0){
			if(subtype==0){
				int damage = 300;
				for(int i=0; i<24; ++i){
					Screen->Circle(4, this->X+8, this->Y+8, 12-8*(i/24), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
					if(i%4==0){
						lweapon l = FireLWeapon(LW_SOLAR, this->X, this->Y, DirAngle(this->Dir), 400, damage, SPR_LIGHTSHOT, 32);
						l->Rotation = DirAngle(this->Dir);
						if(angle>-1000){
							l->Angle = DegtoRad(angle);
							l->Rotation = angle;
						}
						RunLWeaponScript(l, "GlowLW", {12});
					}
					Waitframe();
				}
			}
			else if(subtype==1){
				int damage = 250;
				for(int i=0; i<90; ++i){
					Screen->Circle(4, this->X+8, this->Y+8, 4+Rand(-2, 2), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
					Waitframe();
				}
				lweapon l = FireLWeapon(LW_SOLAR, this->X, this->Y, 0, 0, damage, 0, SFX_LIGHTSHOT);
				l->CollDetection = false;
				RunLWeaponScript(l, "SolarBigShotLW", {0, 16, 0.5, 0.2, 0, 32});
				this->DeadState = 0;
				Quit();
			}
		}
		else if(element==1){
			if(subtype==0){
				int damage = 400;
				Game->PlaySound(SFX_TELEKINESIS);
				int barrelscript = Game->GetComboScript("Barrel");
				mapdata l1 = Game->LoadTempScreen(1);
				for(int i=0; i<24; ++i){
					int c = Choose(0x72, 0x73, 0x74);
					for(int x=-3; x<=3; ++x){
						for(int y=-3; y<=3; ++y){
							//Screen->PutPixel(6, this->X+8+x*i*0.66, this->Y+8+y*i*0.66, 0x01, 0, 0, 0, 128);
							int pos = ComboAt(this->X+8+x*i*0.66, this->Y+8+y*i*0.66);
							if(Distance(this->X, this->Y, ComboX(pos), ComboY(pos))<=i+8){
								combodata cd = Game->LoadComboData(l1->ComboD[pos]);
								if(cd->Script==barrelscript){
									l1->ComboF[pos] = CF_BARRELFLAG;
								}
							}
						}
					}
					for(int j=0; j<6; ++j){
						Screen->Circle(4, this->X+8, this->Y+8, i*2+j*0.5, c, 1, 0, 0, 0, false, i>=20?64:128);
					}
					for(int j=Screen->NumNPCs(); j>0; --j){
						npc n = Screen->LoadNPC(j);
						if(n->CollDetection&&n->Z==0&&!(n->Misc[NPCM_FLAGS]&NPCMF_TELEKINESIS)&&Distance(HitboxCenterX(n), HitboxCenterY(n), this->X+8, this->Y+8)<i*2&&n->Misc[NPCM_CANSTUN]&&!LunarBatteryException(n)){
							lweapon l = FireLWeapon(LW_SCRIPT10, 120, 80, 0, 0, 0, 0, 0);
							l->DrawYOffset = -1000;
							RunLWeaponScript(l, "Telekinesis", {n->UID, damage});
							l->CollDetection = false;
							n->Misc[NPCM_FLAGS] |= NPCMF_TELEKINESIS;
						}
					}
					Waitframe();
				}
			}
			else if(subtype==1){
				int damage = 300;
				for(int i=0; i<16; ++i){
					Screen->Circle(4, this->X+8, this->Y+8, 12-8*(i/24), Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, true, 128);
					if(i%4==0){
						for(int j=-1; j<=1; j+=2){
							lweapon l = FireLWeapon(LW_LUNAR, this->X, this->Y, DirAngle(this->Dir), 0, damage, 98, 32);
							l->Rotation = DirAngle(this->Dir);
							if(angle>-1000){
								l->Angle = DegtoRad(angle);
								l->Rotation = angle;
							}
							RunLWeaponScript(l, "LunarPhaseCutterLW", {50, 150, 16, 0, 16*j, 4});
						}
					}
					Waitframe();
				}
			}
		}
		else if(element==2){
			if(subtype==0){
				int damage = 500;
				for(int i=0; i<8; ++i){
					int x = this->X;
					int y = this->Y;
					int angle = i*45;
					for(int j=0; j<8; ++j){
						lweapon l = FireLWeapon(LW_SCRIPT10, x, y, 0, 0, damage-50*j, 0, 0);
						RunLWeaponScript(l, "StellarImpact", {8+j*4, 0});
						l->CollDetection = false;
						x += VectorX(12, angle);
						y += VectorY(12, angle);
						angle += Rand(-30, 30);
					}
				}
			}
			else if(subtype==1){
				int damage = 200;
				Game->PlaySound(SFX_TELEKINESIS);
				for(int i=0; i<16; ++i){
					int c = Choose(0x96, 0x97, 0x98);
					for(int j=0; j<6; ++j){
						Screen->Circle(4, this->X+8, this->Y+8, i*2+j*0.5, c, 1, 0, 0, 0, false, i>=12?64:128);
					}
					for(int j=Screen->NumNPCs(); j>0; --j){
						npc n = Screen->LoadNPC(j);
						if(n->CollDetection&&n->Z==0&&!(n->Misc[NPCM_FLAGS]&NPCMF_TELEKINESIS)&&Distance(HitboxCenterX(n), HitboxCenterY(n), this->X+8, this->Y+8)<i*2&&!StellarBatteryException(n)){
							lweapon l = FireLWeapon(LW_SCRIPT10, 120, 80, 0, 0, 0, 0, 0);
							l->DrawYOffset = -1000;
							RunLWeaponScript(l, "StellarSpearTarget", {n->UID, damage, 3});
							l->CollDetection = false;
							l->Step = 0;
							n->Misc[NPCM_FLAGS] |= NPCMF_TELEKINESIS;
						}
					}
					Waitframe();
				}
			}
		}
		this->DeadState = 0;
	}
}

lweapon script MagicBatteryLWTerry{
	bool TerryClaw(lweapon lArr, int offset, int count, int clawX, int clawY, int angle, int angle2, int thickness, int spacing, int damage, int targetVertexCount, int vertexGrowth){
		int numWeapons = 0;
		for(int i=0; i<count; ++i){
			int i2 = i+offset;
			int dist = -spacing*(count-1)/2;
			int x = clawX+VectorX(dist+i*spacing, angle-90);
			int y = clawY+VectorY(dist+i*spacing, angle-90);
			if(lArr[i2]->isValid()){
				++numWeapons;
				
				lArr[i2]->Damage = damage;
				lArr[i2]->Angle = DegtoRad(angle2);
				lArr[i2]->InitD[1] = x;
				lArr[i2]->InitD[2] = y;
				
				if(lArr[i2]->InitD[0]<targetVertexCount){
					lArr[i2]->InitD[0] = Min(lArr[i2]->InitD[0]+vertexGrowth, targetVertexCount);
				}
				else if(lArr[i2]->InitD[0]>targetVertexCount){
					lArr[i2]->InitD[0] = Max(lArr[i2]->InitD[0]-vertexGrowth, 0);
					if(lArr[i2]->InitD[0]==0)
						lArr[i2]->DeadState = 0;
				}
			}
			else{
				if(targetVertexCount>0){
					lArr[i2] = CreateLWeaponAt(EW_SCRIPT10, 120, 80);
					lArr[i2]->Damage = damage;
					lArr[i2]->CollDetection = false;
					lArr[i2]->DrawYOffset = -1000;
					RunLWeaponScript(lArr[i2], "VunterSlaushLW", {1, x, y, 0, thickness});
					
					lArr[i2]->Damage = damage;
					lArr[i2]->Angle = DegtoRad(angle2);
				}
			}
		}
		return numWeapons>0;
	}
		
	void run(int type, int alt, int charged){
		switch(type){
			case 0:
				if(alt){
					int damage = 200;
					if(charged)
						damage = 250;
					if(charged){
						lweapon l = FireLWeapon(LW_SOLAR, Link->X+DirX(Link->Dir, 8), Link->Y+DirY(Link->Dir, 8), DirAngle(Link->Dir), 0, damage, SPR_FRIENDBALL, SFX_WAND);
						RunLWeaponScript(l, "SolarChaserLW", {0.1, 3, 300, 0.01});
					}
					else{
						lweapon l = FireLWeapon(LW_SOLAR, Link->X+DirX(Link->Dir, 8), Link->Y+DirY(Link->Dir, 8), DirAngle(Link->Dir), 0, damage, SPR_FRIENDBALL, SFX_WAND);
						RunLWeaponScript(l, "SolarChaserLW", {0.05, 1.5, 60, 0.01});
					}	
				}
				else{
					eweapon e = CreateEWeaponAt(EW_SOLAR, Link->X, Link->Y);
					e->CollDetection = false;
					e->DrawYOffset = -1000;
					RunEWeaponScript(e, "GenParticle", {GP_FLASH, charged?40:20});
					int damageCooldown = 40;
					while(e->isValid()){
						if(damageCooldown){
							--damageCooldown;
							if(damageCooldown<8&&charged){
								MakeHitboxLW(LW_SOLAR, 0, 0, 256, 176, 300, -1);
							}
						}
						for(int i=Screen->NumNPCs(); i>0; --i){
							npc n = Screen->LoadNPC(i);
							if(n->Misc[NPCM_CANSTUN]){
								if(damageCooldown==20)
									Game->PlaySound(SFX_EHIT);
								n->Stun = Max(n->Stun, charged?300:120);
							}
						}
						Waitframe();
					}
				}
				break;
			case 1:
				if(alt){
					int damage = 400;
					if(charged)
						damage = 500;
					
					lweapon lArr[16];
					int angle = DirAngle(Link->Dir);
					int clawX;
					int clawY;
					int clawAng;
					int xOff;
					int yOff;
					int xAccel;
					int yAccel;
					Game->PlaySound(SFX_SELETCLAW);
					if(charged){
						for(int i=0; i<16; ++i){
							xAccel = LazyChase(xAccel, 0, (G[G_LEFTINPUT]?-1:0)+(G[G_RIGHTINPUT]?1:0), 0.4, 3.6);
							yAccel = LazyChase(yAccel, 0, (G[G_UPINPUT]?-1:0)+(G[G_DOWNINPUT]?1:0), 0.4, 3.6);
							xOff += xAccel;
							yOff += yAccel;
							clawAng = angle+Lerp(-80, 120, i/15);
							clawX = Link->X+VectorX(80, clawAng);
							clawY = Link->Y+VectorY(80, clawAng);
							TerryClaw(lArr, 0, 4, clawX+xOff*3, clawY+yOff*3, clawAng+90, clawAng+90, 18, 32, damage, 16, 16);
							G[G_STEPMOD] -= 0.7;
							Waitframe();
						}
						bool clawActive = true;
						while(clawActive){ 
							xOff += xAccel;
							yOff += yAccel;
							clawX = Link->X+VectorX(80, clawAng);
							clawY = Link->Y+VectorY(80, clawAng);
							clawActive = TerryClaw(lArr, 0, 4, clawX+xOff*3, clawY+yOff*3, clawAng+90, clawAng+90, 18, 32, damage, 0, 1);
							G[G_STEPMOD] -= 0.7;
							Waitframe();
						}
					}
					else{
						for(int i=0; i<16; ++i){
							xAccel = LazyChase(xAccel, 0, (G[G_LEFTINPUT]?-1:0)+(G[G_RIGHTINPUT]?1:0), 0.4, 3.6);
							yAccel = LazyChase(yAccel, 0, (G[G_UPINPUT]?-1:0)+(G[G_DOWNINPUT]?1:0), 0.4, 3.6);
							xOff += xAccel;
							yOff += yAccel;
							clawAng = angle+Lerp(-80, 120, i/15);
							clawX = Link->X+VectorX(24, clawAng);
							clawY = Link->Y+VectorY(24, clawAng);
							TerryClaw(lArr, 0, 3, clawX+xOff, clawY+yOff, clawAng+90, clawAng+90, 9, 16, damage, 16, 16);
							G[G_STEPMOD] -= 0.7;
							Waitframe();
						}
						bool clawActive = true;
						while(clawActive){ 
							xOff += xAccel;
							yOff += yAccel;
							clawX = Link->X+VectorX(24, clawAng);
							clawY = Link->Y+VectorY(24, clawAng);
							clawActive = TerryClaw(lArr, 0, 3, clawX+xOff, clawY+yOff, clawAng+90, clawAng+90, 9, 16, damage, 0, 1);
							G[G_STEPMOD] -= 0.7;
							Waitframe();
						}
					}
				}
				else{
					this->X = Link->X+DirX(Link->Dir, 16);
					this->Y = Link->Y+DirY(Link->Dir, 16);
					int rad = 12;
					if(charged)
						rad = 40;
					int damage = 600;
					Game->PlaySound(SFX_TELEKINESIS);
					int barrelscript = Game->GetComboScript("Barrel");
					mapdata l1 = Game->LoadTempScreen(1);
					for(int i=0; i<8; ++i){
						int c = Choose(0x72, 0x73, 0x74);
						int irad = Lerp(0, rad, i/7);
						for(int x=-3; x<=3; ++x){
							for(int y=-3; y<=3; ++y){
								int pointx = this->X+8+x*(irad/3);
								int pointy = this->Y+8+y*(irad/3);
								int pos = ComboAt(pointx, pointy);
								if(Distance(this->X, this->Y, ComboX(pos), ComboY(pos))<=irad+8){
									combodata cd = Game->LoadComboData(l1->ComboD[pos]);
									if(cd->Script==barrelscript){
										l1->ComboF[pos] = CF_BARRELFLAGTERRY;
									}
								}
							}
						}
						for(int j=0; j<6; ++j){
							Screen->Circle(4, this->X+8, this->Y+8, Lerp(0, rad, i/7)+j*0.5, c, 1, 0, 0, 0, false, i>=6?64:128);
						}
						for(int j=Screen->NumNPCs(); j>0; --j){
							npc n = Screen->LoadNPC(j);
							if(n->CollDetection&&n->Z==0&&!(n->Misc[NPCM_FLAGS]&NPCMF_TELEKINESIS)&&Distance(HitboxCenterX(n), HitboxCenterY(n), this->X+8, this->Y+8)<irad+8&&n->Misc[NPCM_CANSTUN]&&!LunarBatteryException(n)){
								lweapon l = FireLWeapon(LW_SCRIPT10, 120, 80, 0, 0, 0, 0, 0);
								l->DrawYOffset = -1000;
								RunLWeaponScript(l, "TelekinesisTerry", {n->UID, damage, 0, 0, 0, Link->Dir});
								l->CollDetection = false;
								n->Misc[NPCM_FLAGS] |= NPCMF_TELEKINESIS;
							}
						}
						Link->Action = LA_NONE;
						Link->Action = LA_ATTACKING;
						Waitframe();
					}
				}
				break;
			case 2:
				if(alt){
					int damage = 400;
					if(charged){
						int angle = DirAngle(Link->Dir);
						for(int i=0; i<12; ++i){
							lweapon l = FireLWeapon(LW_STELLAR, Link->X+VectorX(8, angle), Link->Y+VectorY(8, angle), angle, 0, damage, SPRITE_INVISIBLE, 0);
							RunLWeaponScript(l, "StellarKnockbackBlastLW", {16, 400});
							l->DrawYOffset = -1000;
							for(int j=0; j<8; ++j){
								int iX = (G[G_LEFTINPUT]?-1:0)+(G[G_RIGHTINPUT]?1:0);
								int iY = (G[G_UPINPUT]?-1:0)+(G[G_DOWNINPUT]?1:0);
								if(iX!=0||iY!=0){
									angle = TurnToAngle(WrapDegrees(angle), Angle(0, 0, iX, iY), 1.5);
									Link->Dir = AngleDir4(WrapDegrees(angle));
								}
								Link->Action = LA_NONE;
								Link->Action = LA_ATTACKING;
								Waitframe();
							}
						}
					}
					else{
						lweapon l = FireLWeapon(LW_STELLAR, Link->X+DirX(Link->Dir, 8), Link->Y+DirY(Link->Dir, 8), DirAngle(Link->Dir), 0, damage, SPRITE_INVISIBLE, 0);
						RunLWeaponScript(l, "StellarKnockbackBlastLW", {16, 400});
						l->DrawYOffset = -1000;
						Link->Action = LA_ATTACKING;
					}
				}
				else{
					int damage = 500;
					if(charged)
						damage = 600;
					int dir = Link->Dir;
					for(int i=0; i<8; ++i){
						LinkMovement_Push2(DirX(dir, 2), DirY(dir, 2));
						Link->Action = LA_NONE;
						Link->Action = LA_ATTACKING;
						G[G_NOACTION];
						Waitframe();
					}
					lweapon thorn = FireLWeapon(LW_STELLAR, Link->X, Link->Y, 0, 0, damage, SPRITE_INVISIBLE, 0);
					thorn->CollDetection = false;
					RunLWeaponScript(thorn, "PlasmaThornLW", {DirAngle(dir)});
					if(charged){
						for(int i=0; i<3; ++i){
							for(int j=0; j<4; ++j){
								LinkMovement_Push2(DirX(dir, 0.5), DirY(dir, 0.5));
								Link->Action = LA_NONE;
								Link->Action = LA_ATTACKING;
								G[G_NOACTION];
								Waitframe();
							}
								
							thorn = FireLWeapon(LW_STELLAR, Link->X, Link->Y, 0, 0, damage, SPRITE_INVISIBLE, 0);
							thorn->CollDetection = false;
							RunLWeaponScript(thorn, "PlasmaThornLW", {DirAngle(dir)-35*i});
							
							thorn = FireLWeapon(LW_STELLAR, Link->X, Link->Y, 0, 0, damage, SPRITE_INVISIBLE, 0);
							thorn->CollDetection = false;
							RunLWeaponScript(thorn, "PlasmaThornLW", {DirAngle(dir)+35*i});
						}
					}
					for(int i=0; i<8; ++i){
						Link->Action = LA_NONE;
						Link->Action = LA_ATTACKING;
						G[G_NOACTION];
						Waitframe();
					}
				}
				break;
		}
		this->DeadState = 0;
	}
}

itemdata script BloodmoonGauntlet{
	void run(){
		if(Game->Counter[CR_LUNARBATTERY]>0){
			--Game->Counter[CR_LUNARBATTERY];
			Game->PlaySound(78);
			lweapon l = CreateLWeaponAt(LW_SCRIPT10, Link->X, Link->Y);
			l->CollDetection = false;
			l->Step = 0;
			l->DrawYOffset = -1000;
			RunLWeaponScript(l, "BloodMoonCageLW", {Link->X+DirX(Link->Dir, 64), Link->Y+DirY(Link->Dir, 64), 48, 12, 180, 0});
			for(int i=0; i<32; ++i){
				Link->Action = LA_NONE;
				Link->Action = LA_ATTACKING;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			while(l->isValid()){
				Waitframe();
			}
		}
	}
}

lweapon script Telekinesis{
	void DrawEnergyBorder(npc n, bitmap b, int w, int h){
		int x = GhostGet(n, GG_X)+n->DrawXOffset;
		int y = GhostGet(n, GG_Y)+n->DrawYOffset;
		int z = GhostGet(n, GG_Z);
		int gfx = n->Misc[NPCM_GFX];
		int tile;
		int flip;
		if(gfx!=0){
			if(gfx<0){
				tile = -gfx;
			}
			else{
				combodata cd = Game->LoadComboData(gfx);
				tile = cd->Tile;
				flip = cd->Flip;
			}
			b->Clear(0);
			b->DrawTile(0, 0, 0, tile, w, h, 7, -1, -1, 0, 0, 0, flip, true, 128);
			b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 1, 255);
			b->Blit(2, RT_SCREEN, 0, 0, w*16, h*16, x+Rand(-2, 2), y-z+Rand(-2, 2), w*16, h*16, 0, 0, 0, 0, 0, true);
		}
	}
	void DrawEnergyBorderCombo(bitmap b, int x, int y, int z, int cmb, int cs){
		b->Clear(0);
		b->FastCombo(0, 0, 0, cmb, cs, 128);
		b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 1, 255);
		b->Blit(2, RT_SCREEN, 0, 0, 16, 16, x+Rand(-2, 2), y-z+Rand(-2, 2), 16, 16, 0, 0, 0, 0, 0, true);
	}
	void runEnemyTelekinesis(lweapon this, int npcuid, int damage){
		npc n = Screen->LoadNPCByUID(npcuid);
		if(n->isValid()){
			int w = GhostGet(n, GG_TILEWIDTH);
			int h = GhostGet(n, GG_TILEHEIGHT);
			int bitid = TempBitmap_Create(0, w*16, h*16);
			bitmap b = TempBMP[bitid];
			for(int i=0; i<32&&n->isValid(); i+=0.5){
				GhostSet(n, GG_Z, i);
				n->Misc[NPCM_PITIMMUNITY] = 2;
				n->Stun = 30;
				n->Jump = 0;
				G[G_TORRINTELEKINESIS] = 1;
				DrawEnergyBorder(n, b, w, h);
				if(G[G_ANIM]%4==0)
					ParticleAnim(HitboxCenterX(n)-8+Rand(-4, 4), HitboxCenterY(n)-8+Rand(-4, 4)-n->Z, TIL_MAGICBATTERY_SPARKLES+20, 0, 3, 4);
				Waitframe();
			}
			int x = GhostGet(n, GG_X);
			int y = GhostGet(n, GG_Y);
			int inputX;
			int inputY;
			int vX = 0;
			int vY = 0;
			for(int i=0; i<120&&n->isValid(); ++i){
				inputX = (G[G_LEFTINPUT]?-1:0) + (G[G_RIGHTINPUT]?1:0);
				inputY = (G[G_UPINPUT]?-1:0) + (G[G_DOWNINPUT]?1:0);
				vX = Clamp(vX+0.05*inputX, -1, 1);
				vY = Clamp(vY+0.05*inputY, -1, 1);
				if(NPCCanWalkX(n, Sign(vX)))
					x += vX;
				if(NPCCanWalkY(n, Sign(vY)))
					y += vY;
				GhostSet(n, GG_X, x);
				GhostSet(n, GG_Y, y);
				
				GhostSet(n, GG_Z, 32);
				n->Misc[NPCM_PITIMMUNITY] = 2;
				n->Stun = 30;
				n->Jump = 0;
				G[G_TORRINTELEKINESIS] = 1;
				DrawEnergyBorder(n, b, w, h);
				if(G[G_ANIM]%4==0)
					ParticleAnim(HitboxCenterX(n)-8+Rand(-4, 4), HitboxCenterY(n)-8+Rand(-4, 4)-n->Z, TIL_MAGICBATTERY_SPARKLES+20, 0, 3, 4);
				Waitframe();
			}
			for(int i=32; i>0&&n->isValid(); i-=4){
				GhostSet(n, GG_Z, i);
				n->Stun = 30;
				n->Misc[NPCM_PITIMMUNITY] = 2;
				n->Jump = 0;
				G[G_TORRINTELEKINESIS] = 1;
				DrawEnergyBorder(n, b, w, h);
				if(G[G_ANIM]%4==0)
					ParticleAnim(HitboxCenterX(n)-8+Rand(-4, 4), HitboxCenterY(n)-8+Rand(-4, 4)-n->Z, TIL_MAGICBATTERY_SPARKLES+20, 0, 3, 4);
				Waitframe();
			}
			Game->PlaySound(3);
			Game->PlaySound(92);
			Screen->Quake = 10;
			TempBitmap_Free(0, bitid);
			int impactX = HitboxCenterX(n);
			int impactY = HitboxCenterY(n);
			for(int i=0; i<8; ++i){
				for(int j=0; j<3; ++j){
					Screen->Circle(4, impactX, impactY, i*4+j*0.5, Choose(0xB1, 0xB2, 0xB3), 1, 0, 0, 0, false, 128);
					int w = i*4*0.7071;
					MakeHitboxLW(LW_LUNAR, impactX-w/2, impactY-w/2, w, w, damage, n->Dir);
				}
				Waitframe();
			}
			n->Misc[NPCM_FLAGS] &= ~NPCMF_TELEKINESIS;
		}
		this->DeadState = 0;
	}
	void runComboTelekinesis(lweapon this, int cmb, int damage, int cs, int xpos, int ypos){
		int bitid = TempBitmap_Create(0, 16, 16);
		bitmap b = TempBMP[bitid];
		int z;
		for(int i=0; i<32; i+=0.5){
			z = i;
			G[G_TORRINTELEKINESIS] = 1;
			DrawEnergyBorderCombo(b, xpos, ypos, z, cmb, cs);
			Screen->FastCombo(4, xpos, ypos-z, cmb, cs, 128);
			if(G[G_ANIM]%4==0)
				ParticleAnim(xpos+Rand(-4, 4), ypos+Rand(-4, 4)-z, TIL_MAGICBATTERY_SPARKLES+20, 0, 3, 4);
			Waitframe();
		}
		int x = xpos;
		int y = ypos;
		int inputX;
		int inputY;
		int vX = 0;
		int vY = 0;
		for(int i=0; i<120; ++i){
			inputX = (G[G_LEFTINPUT]?-1:0) + (G[G_RIGHTINPUT]?1:0);
			inputY = (G[G_UPINPUT]?-1:0) + (G[G_DOWNINPUT]?1:0);
			vX = Clamp(vX+0.05*inputX, -1, 1);
			vY = Clamp(vY+0.05*inputY, -1, 1);
			if((vX<0&&CanWalk(x, y, DIR_LEFT, 1, true))||(vX>0&&CanWalk(x, y, DIR_RIGHT, 1, true)))//NPCCanWalkX(n, Sign(vX)))
				x += vX;
			if((vY<0&&CanWalk(x, y, DIR_UP, 1, true))||(vY>0&&CanWalk(x, y, DIR_DOWN, 1, true)))//NPCCanWalkY(n, Sign(vY)))
				y += vY;
			xpos = x;
			ypos = y;
			
			G[G_TORRINTELEKINESIS] = 1;
			DrawEnergyBorderCombo(b, xpos, ypos, z, cmb, cs);
			Screen->FastCombo(4, xpos, ypos-z, cmb, cs, 128);
			if(G[G_ANIM]%4==0)
				ParticleAnim(xpos+Rand(-4, 4), ypos+Rand(-4, 4)-z, TIL_MAGICBATTERY_SPARKLES+20, 0, 3, 4);
			Waitframe();
		}
		for(int i=32; i>0; i-=4){
			z = i;
			G[G_TORRINTELEKINESIS] = 1;
			DrawEnergyBorderCombo(b, xpos, ypos, z, cmb, cs);
			Screen->FastCombo(4, xpos, ypos-z, cmb, cs, 128);
			if(G[G_ANIM]%4==0)
				ParticleAnim(xpos+Rand(-4, 4), ypos+Rand(-4, 4)-z, TIL_MAGICBATTERY_SPARKLES+20, 0, 3, 4);
			Waitframe();
		}
		Game->PlaySound(3);
		Game->PlaySound(92);
		Screen->Quake = 10;
		
		Game->PlaySound(150);
		ParticleAnim(xpos, ypos, 23);
		
		TempBitmap_Free(0, bitid);
		int impactX = x+8;
		int impactY = y+8;
		for(int i=0; i<8; ++i){
			for(int j=0; j<3; ++j){
				Screen->Circle(4, impactX, impactY, i*4+j*0.5, Choose(0xB1, 0xB2, 0xB3), 1, 0, 0, 0, false, 128);
				int w = i*4*0.7071;
				MakeHitboxLW(LW_LUNAR, impactX-w/2, impactY-w/2, w, w, damage, Link->Dir);
			}
			Waitframe();
		}
		this->DeadState = 0;
	}
	void run(int id, int damage, int cset, int xpos, int ypos){
		if(id<0){
			runComboTelekinesis(this, Abs(id), damage, cset, xpos, ypos);
		}
		else{
			runEnemyTelekinesis(this, id, damage);
		}
	}
}

lweapon script TelekinesisTerry{
	void DrawEnergyBorder(npc n, bitmap b, int w, int h, int scale){
		int x = GhostGet(n, GG_X)+n->DrawXOffset;
		int y = GhostGet(n, GG_Y)+n->DrawYOffset;
		int z = GhostGet(n, GG_Z);
		int gfx = n->Misc[NPCM_GFX];
		int tile;
		int flip;
		if(gfx!=0){
			if(gfx<0){
				tile = -gfx;
			}
			else{
				combodata cd = Game->LoadComboData(gfx);
				tile = cd->Tile;
				flip = cd->Flip;
			}
			b->Clear(0);
			b->DrawTile(0, 0, 0, tile, w, h, 7, -1, -1, 0, 0, 0, flip, true, 128);
			b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 1, 255);
			b->Blit(2, RT_SCREEN, 0, 0, w*16, h*16, x+Rand(-2, 2)-(scale-1)*w*8, y-z+Rand(-2, 2)-(scale-1)*w*8, w*16*scale, h*16*scale, 0, 0, 0, 0, 0, true);
		}
	}
	void DrawEnergyBorderCombo(bitmap b, int x, int y, int z, int cmb, int cs){
		b->Clear(0);
		b->FastCombo(0, 0, 0, cmb, cs, 128);
		b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 1, 255);
		b->Blit(2, RT_SCREEN, 0, 0, 16, 16, x+Rand(-2, 2), y-z+Rand(-2, 2), 16, 16, 0, 0, 0, 0, 0, true);
	}
	void runEnemyTelekinesis(lweapon this, int npcuid, int damage, int dir){
		npc n = Screen->LoadNPCByUID(npcuid);
		if(n->isValid()){
			int w = GhostGet(n, GG_TILEWIDTH);
			int h = GhostGet(n, GG_TILEHEIGHT);
			bitmap b = Game->CreateBitmap(16*w, 16*h);
			b->Own();
		
			int step = 4;
			
			int xpos = n->X;
			int ypos = n->Y;
			
			while(CheckMove(xpos+n->HitXOffset, ypos+n->HitYOffset, n->HitWidth, n->HitHeight, dir)){
				n->Stun = Max(n->Stun, 60);
				for(int i=0; i<step&&CheckMove(xpos+n->HitXOffset, ypos+n->HitYOffset, n->HitWidth, n->HitHeight, dir); ++i){
					xpos += DirX(dir, 1);
					ypos += DirY(dir, 1);
				}
				SetEnemyProperty(n, ENPROP_X, xpos);
				SetEnemyProperty(n, ENPROP_Y, ypos);
				
				DrawEnergyBorder(n, b, w, h, 1);
				Waitframe();
			}
			
			Game->PlaySound(3);
			Game->PlaySound(92);
			Screen->Quake = 10;
			
			for(int i=0; i<8; ++i){
				if(n->isValid()&&n->HP>0){
					DrawEnergyBorder(n, b, w, h, 1+i/7);
				}
				Waitframe();
			}
			
			MakeHitboxLW(LW_LUNAR, xpos+n->HitXOffset,ypos+n->HitYOffset, n->HitWidth, n->HitHeight, damage, dir);
			
			if(n->isValid())
				n->Misc[NPCM_FLAGS] &= ~NPCMF_TELEKINESIS;
		}
		this->DeadState = 0;
	}
	void runComboTelekinesis(lweapon this, int cmb, int damage, int cs, int xpos, int ypos, int dir){
		bitmap b = Game->CreateBitmap(16, 16);
		b->Own();
		
		int step = 4;
		
		while(CheckMove(xpos, ypos, 16, 16, dir)){
			for(int i=0; i<step&&CheckMove(xpos, ypos, 16, 16, dir); ++i){
				xpos += DirX(dir, 1);
				ypos += DirY(dir, 1);
			}
			Screen->FastCombo(4, xpos, ypos, cmb, cs, 128);
			DrawEnergyBorderCombo(b, xpos, ypos, 0, cmb, cs);
			Waitframe();
		}
		
		MakeHitboxLW(LW_LUNAR, xpos, ypos, 16, 16, damage, dir);
					
		Game->PlaySound(3);
		Game->PlaySound(92);
		Screen->Quake = 10;
		
		Game->PlaySound(150);
		ParticleAnim(xpos, ypos, 23);
			
		this->DeadState = 0;
	}
	bool CheckMove(int nx, int ny, int hitw, int hith, int dir){
		switch(dir){
			case DIR_UP:
			case DIR_DOWN:
				for(int i=0; i<hitw-1; i=Min(i+8, hitw-1)){
					int x = nx+i;
					int y = ny-1;
					if(dir==DIR_DOWN)
						y = ny+hith;
					if(Screen->isSolid(x, y)||!InScreen(x, y, 1, 1))
						return false;
					if(i==hitw-1)
						break;
				}
				break;
			case DIR_LEFT:
			case DIR_RIGHT:
				for(int i=0; i<hith-1; i=Min(i+8, hith-1)){
					int x = nx-1;
					if(dir==DIR_RIGHT)
						x = nx+hitw;
					int y = ny+i;
					if(Screen->isSolid(x, y)||!InScreen(x, y, 1, 1))
						return false;
					if(i==hith-1)
						break;
				}
				break;
		}
		return true;
	}
	void run(int id, int damage, int cset, int xpos, int ypos, int dir){
		if(id<0){
			runComboTelekinesis(this, Abs(id), damage, cset, xpos, ypos, dir);
		}
		else{
			runEnemyTelekinesis(this, id, damage, dir);
		}
	}
}

lweapon script PlasmaThornLW{
	void run(int angle){
		Game->PlaySound(SFX_STELLARSWORD_APPEAR);
		for(int i=0; i<24; ++i){
			int m = 5;
			if(i<2||i>=22)
				m = 1;
			else if(i<4||i>=20)
				m = 2;
			else if(i<6||i>=18)
				m = 3;
			else if(i<8||i>=16)
				m = 4;
			
			DrawLightSwordLW(Link->X, Link->Y, angle, 16, m, this->Damage);
			Waitframe();
		}
		this->DeadState = 0;
	}
}

lweapon script SolarChaserLW{
	void run(int accel, int topspeed, int time, int topspeedFalloff){
		int x = this->X;
		int y = this->Y;
		int vX = VectorX(topspeed/2, RadtoDeg(this->Angle));
		int vY = VectorY(topspeed/2, RadtoDeg(this->Angle));
		int tX = Link->X;
		int tY = Link->Y;
		for(int i=0; i<time; ++i){
			tX = Link->X;
			tY = Link->Y;
			npc closest;
			int closestDist = 1000;
			int motionAngle = Angle(0, 0, vX, vY);
			for(int j=Screen->NumNPCs(); j>0; --j){
				npc n = Screen->LoadNPC(j);
				if(n->Defense[NPCD_SOLAR]!=NPCDT_BLOCK&&n->Defense[NPCD_SOLAR]!=NPCDT_IGNORE&&n->CollDetection){
					int dist = Distance(this->X, this->Y, HitboxCenterX(n)-8, HitboxCenterY(n)-8);
					int angleN = Angle(this->X, this->Y, HitboxCenterX(n)-8, HitboxCenterY(n)-8);
					dist += Lerp(0, dist, Abs(AngDiff(motionAngle, angleN))/180);
					if(dist<closestDist){
						closest = n;
						closestDist = dist;
					}
				}
			}
			if(closest->isValid()){
				tX = HitboxCenterX(closest)-8;
				tY = HitboxCenterY(closest)-8;
			}
			
			
			vX = LazyChase(vX, this->X, tX, accel, topspeed);
			vY = LazyChase(vY, this->Y, tY, accel, topspeed);
			topspeed = Decrement(topspeed, topspeedFalloff);
			x += vX;
			y += vY;
			this->X = x;
			this->Y = y;
			this->DeadState = WDS_ALIVE;
			DarkRoom_AddLight(this->X+8, this->Y+8, 0, 24, 1, 0, 0, 0);
			Waitframe();
		}
		for(int i=0; i<4; ++i){
			lweapon l = FireLWeapon(EW_SOLAR, this->X, this->Y, -45+90*i, 400, this->Damage, SPR_LIGHTSHOT, 32);
			l->Rotation = -45+90*i;
			RunLWeaponScript(l, "GlowLW", {12});
		}
		this->DeadState = 0;
	}
}

lweapon script VunterSlaushLW{
	void run(int _vertices, int _x, int _y, int special, int maxW){
		int i;
		
		int clrs[] = {0x73, 0x72, 0x71};
		if(maxW==0)
			maxW = 12;
		
		int pointX[16];
		int pointY[16];
		int pointScales[16];
		int pointAngle[16];
		int vertices = this->InitD[0];
		int x = this->InitD[1];
		int y = this->InitD[2];
		for(i=0; i<16; ++i){
			pointX[i] = x+8;
			pointY[i] = y+8;
			pointAngle[i] = RadtoDeg(this->Angle);
		}
		while(true){
			if(special==1){
				if(G[G_ANIM]%8<4){
					clrs[0] = 0x77;
					clrs[1] = 0x76;
					clrs[2] = 0x71;
				}
				else{
					clrs[0] = 0x78;
					clrs[1] = 0x77;
					clrs[2] = 0x76;
				}
			}
			
			vertices = this->InitD[0];
			x = this->InitD[1];
			y = this->InitD[2];
			if(vertices>1&&vertices<17){
				for(i=0; i<vertices; ++i){
					pointScales[i] = TrapezoidCurve(i, vertices-1, 0.3, 0.3, maxW);
					if(special==1&&i%2==0)
						pointScales[i] *= 0.25;
				}
				if(vertices==16){
					for(i=vertices-1; i>0; --i){
						pointX[i] = pointX[i-1];
						pointY[i] = pointY[i-1];
						pointAngle[i] = pointAngle[i-1];
					}
					pointX[0] = x+8;
					pointY[0] = y+8;
					pointAngle[0] = WrapDegrees(RadtoDeg(this->Angle));
				}
				
				DrawPolyTrail(4, vertices, pointX, pointY, pointScales, pointAngle, 0, clrs[0], -this->Damage);
				DrawPolyTrail(4, vertices, pointX, pointY, pointScales, pointAngle, 0.6, clrs[1], 0);
				DrawPolyTrail(4, vertices, pointX, pointY, pointScales, pointAngle, 0.9, clrs[2], 0);
			}
			Waitframe();
		}
	}
}

lweapon script StellarKnockbackBlastLW{
	void run(int delay, int step){
		Waitframe();
		if(delay){
			Game->PlaySound(SFX_CHARGE1);
			for(int i=0; i<delay&&Distance(this->X, this->Y, Link->X, Link->Y)>20; ++i){
				Screen->Circle(4, this->X+8+Rand(-1, 1), this->Y+8+Rand(-1, 1), Rand(10, 12), Choose(0x96, 0x97, 0x98), 1, 0, 0, 0, true, 128);
				Waitframe();
			}
		}
		this->Extend = 3;
		this->TileWidth = 2;
		this->DrawXOffset = -8;
		this->UseSprite(103);
		this->Step = step;
		lweapon hitbox[2];
		Game->PlaySound(93);
		bool gothit;
		npc target;
		while(this->X>-16&&this->X<256&&this->Y>-16&&this->Y<176&&!gothit){
			for(int i=0; i<2; ++i){
				if(!hitbox[i]->isValid()){
					hitbox[i] = FireLWeapon(LW_STELLAR, this->X+VectorX(-8+16*i, RadtoDeg(this->Angle)), this->Y+VectorY(-8+16*i, RadtoDeg(this->Angle)), RadtoDeg(this->Angle), 0, this->Damage, 0, 0);
					hitbox[i]->DrawYOffset = -1000;
				}
				hitbox[i]->X = this->X+VectorX(-8+16*i, RadtoDeg(this->Angle));
				hitbox[i]->Y = this->Y+VectorY(-8+16*i, RadtoDeg(this->Angle));
				hitbox[i]->Script = LWS_TIMEOUT;
				hitbox[i]->InitD[0] = 3;
				if(hitbox[i]->Misc[LWM_HITBY]){
					gothit = true;
					npc n = Screen->LoadNPCByUID(hitbox[i]->Misc[LWM_HITBY]);
					if(n->Misc[NPCM_CANSTUN]){
						target = n;
					}
				}
				if(Screen->isSolid(hitbox[i]->X+8, hitbox[i]->Y+8))
					gothit = true;
			}
			Screen->DrawTile(2, this->X-8, this->Y-2, this->Tile, 2, 1, this->CSet, -1, -1, this->X-8, this->Y-2, RadtoDeg(this->Angle), 0, true, 128);
			Waitframe();
		}
		Game->PlaySound(SFX_BOMB);
		int angle = RadtoDeg(this->Angle);
		this->Step = 0;
		int npcX;
		int npcY;
		if(target->isValid()){
			npcX = target->X;
			npcY = target->Y;
		}
		for(int i=0; i<16; ++i){
			if(target->isValid()){
				int stepX = VectorX(1, angle);
				int stepY = VectorY(1, angle);
				for(int j=0; j<4; ++j){
					if(CanPlaceOnscreen(npcX+target->HitXOffset+stepX, npcY+target->HitYOffset+stepY, target->HitHeight, target->HitWidth)){
						npcX += stepX;
						npcY += stepY;
						target->Stun = Max(target->Stun, 32);
						SetEnemyProperty(target, ENPROP_X, npcX);
						SetEnemyProperty(target, ENPROP_Y, npcY);
					}
					else
						break;
				}
			}
			DrawStarGlint(4, this->X+8, this->Y+8, Rand(360), i*3, Choose(0x91, 0x96, 0x97, 0x98));
			Waitframe();
		}
		this->DeadState = 0;
	}
}

lweapon script StellarSpearTarget{
	void run(int npcuid, int damage, int transfer){
		npc n = Screen->LoadNPCByUID(npcuid);
		for(int i=0; i<3; ++i){
			for(int j=0; j<180; ++j){
				for(int k=0; k<4; ++k){
					int x = n->X+n->HitXOffset+Rand(n->HitWidth);
					int y = n->Y+n->HitYOffset+Rand(n->HitHeight);
					int len = Rand(4, 8);
					Screen->Line(4, x, y-len, x, y, Choose(0x91, 0x96, 0x97), 1, 0, 0, 0, 128);
				}
				if(!n->isValid()){
					this->DeadState = 0;
					Quit();
				}
				else{
					if(n->HP<=0){
						int hit = n->HitBy[6];
						if(hit>0){
							lweapon l = Screen->LoadLWeaponByUID(hit);
							if(l->ID==LW_STELLAR)
								n->ItemSet = 7;
						}
					}
				}
				Waitframe();
			}
			lweapon spear = CreateLWeaponAt(LW_STELLAR, HitboxCenterX(n)-8+Rand(-8, 8), HitboxCenterY(n)-8+Rand(-8, 8));
			spear->Damage = 300;
			spear->CollDetection = false;
			spear->DrawYOffset = -1000;
			spear->Step = 0;
			RunLWeaponScript(spear, "StellarSpear", {transfer});
		}
		for(int j=0; j<40; ++j){
			for(int k=0; k<4; ++k){
				int x = n->X+n->HitXOffset+Rand(n->HitWidth);
				int y = n->Y+n->HitYOffset+Rand(n->HitHeight);
				int len = Rand(4, 8);
				Screen->Line(4, x, y-len, x, y, Choose(0x91, 0x96, 0x97), 1, 0, 0, 0, 128);
			}
			if(!n->isValid()){
				this->DeadState = 0;
				Quit();
			}
			else{
				if(n->HP<=0){
					int hit = n->HitBy[6];
					if(hit>0){
						lweapon l = Screen->LoadLWeaponByUID(hit);
						if(l->ID==LW_STELLAR)
							n->ItemSet = 7;
					}
				}
			}
			Waitframe();
		}
		n->Misc[NPCM_FLAGS] &= ~NPCMF_TELEKINESIS;
		this->DeadState = 0;
	}
}

lweapon script StellarSpear{
	void run(int transfer){
		Game->PlaySound(78);
		for(int i=80; i>0; i-=8){
			int til;
			til = 65015+Clamp(i/16, 0, 3);
			if(til==65018)
				Screen->DrawTile(4, this->X-8, this->Y-8-i, til, 2, 1, 10, -1, -1, this->X-8, this->Y-8-i, 90, 0, true, 128);
			else
				Screen->DrawTile(4, this->X, this->Y-i, til, 1, 1, 10, -1, -1, this->X, this->Y-i, 90, 0, true, 128);
			Waitframe();
		}
		int angle = Rand(360);
		for(int i=0; i<32; ++i){
			if(transfer>0){
				if(i<16){
					int c = Choose(0x96, 0x97, 0x98);
					for(int j=0; j<6; ++j){
						Screen->Circle(4, this->X+8, this->Y+8, i*2+j*0.5, c, 1, 0, 0, 0, false, i>=12?64:128);
					}
					for(int j=Screen->NumNPCs(); j>0; --j){
						npc n = Screen->LoadNPC(j);
						if(n->CollDetection&&n->Z==0&&!(n->Misc[NPCM_FLAGS]&NPCMF_TELEKINESIS)&&Distance(HitboxCenterX(n), HitboxCenterY(n), this->X+8, this->Y+8)<i*2&&n->Misc[NPCM_CANSTUN]&&!LunarBatteryException(n)){
							lweapon l = FireLWeapon(LW_SCRIPT10, 120, 80, 0, 0, 0, 0, 0);
							l->DrawYOffset = -1000;
							RunLWeaponScript(l, "StellarSpearTarget", {n->UID, this->Damage, transfer-1});
							l->CollDetection = false;
							l->Step = 0;
							n->Misc[NPCM_FLAGS] |= NPCMF_TELEKINESIS;
						}
					}
				}
			}
			int len = 8+Lerp(0, 24, i/32);
			if(i<24||i%2==0){
				StarWand.DrawExpandingRect(4, this->X+8, this->Y+8, angle+10*i, len, Choose(0x91, 0x96, 0x97));
				StarWand.DrawExpandingRect(4, this->X+8, this->Y+8, angle+10*i+45, len, Choose(0x91, 0x96, 0x97));
			}
			MakeHitboxLW(LW_STARWANDIMPACT, this->X+8-len*0.7, this->Y+8-len*0.7, len*1.4, len*1.4, this->Damage, this->Dir);
			Waitframe();
		}
		this->DeadState = 0;
	}
}

lweapon script LunarPhaseCutterLW{
	void run(int minstep, int maxstep, int sinespeed, int startSineCounter, int sideSine, int sideSineSpeed){
		int drawYOff = this->DrawYOffset;
		int sinecounter = startSineCounter;
		int sideSineCounter;
		while(true){
			sinecounter += sinespeed;
			sinecounter = sinecounter%360;
			int state = sinecounter/360;
			if(state>0.75){
				this->CollDetection = true;
				this->DrawYOffset = drawYOff;
				this->DrawStyle = DS_NORMAL;
			}
			else if(state>0.50||state<=0.25){
				this->CollDetection = false;
				this->DrawYOffset = G[G_ANIM]%4<2?drawYOff:-1000;
				this->DrawStyle = DS_PHANTOM;
			}
			else if(state>0.25){
				this->CollDetection = false;
				this->DrawYOffset = drawYOff;
			}
			this->Step = Lerp(minstep, maxstep, 0.5+0.5*Sin(sinecounter));
			sideSineCounter = (sideSineCounter+sideSineSpeed)%360;
			this->DrawXOffset = VectorX(sideSine*Sin(sideSineCounter), RadtoDeg(this->Angle)+90);
			this->DrawYOffset = VectorY(sideSine*Sin(sideSineCounter), RadtoDeg(this->Angle)+90)-2;
			this->HitXOffset = this->DrawXOffset;
			this->HitYOffset = this->DrawYOffset+2;
			Waitframe();
		}
	}
}

lweapon script SolarBigShotLW{
	void DrawBigShot(int x, int y, int rad, int damage, int i, int flash){
		int r = rad+2*Sin(i);
		int clr[3] = {0x88, 0x86, 0x81};
		if(flash==0){
			clr[0] = 0x88;
			clr[1] = 0x87;
			clr[2] = 0x86;
		}
		if(flash==2){
			clr[0] = 0x86;
			clr[1] = 0x81;
			clr[2] = 0x81;
		}
		Screen->Circle(2, x, y, rad+2*Sin(i), clr[0], 1, 0, 0, 0, true, 128);
		Screen->Circle(2, x, y, rad*0.875+2*Sin(i), clr[1], 1, 0, 0, 0, true, 128);
		Screen->Circle(2, x, y, rad*0.625+2*Sin(i), clr[2], 1, 0, 0, 0, true, 128);
		DarkRoom_AddLight(x, y, 0, rad+16, 1, 0, 0, 0);
		MakeHitboxLW(LW_SOLAR, x-r*0.7071, y-r*0.7071, r*2*0.7071, r*2*0.7071, damage, -1);
	}
	void run(int chargeTime, int growDelay, int growth, int accel, int angleturn, int maxradius){
		this->DrawYOffset = -1000;
		int rad = 0;
		this->CollDetection = false;
		int x = this->X+8;
		int y = this->Y+8;
		int step = 0;
		int anim;
		if(chargeTime==0)
			rad = 8;
		while(x>-rad&&x<255+rad&&y>-rad&&y<175+rad&&(maxradius==0 || (maxradius > 0 && rad < maxradius))){
			anim = (anim+4)%5040;
			if(chargeTime){
				--chargeTime;
				if(rad<8)
					rad = Min(rad+0.5, 8);
				if(chargeTime==0)
					step = 0;
			}
			else if(growDelay){
				step += accel;
				--growDelay;
				if(!growDelay)
					Game->PlaySound(SFX_SOLARBIGSHOT_FIRE);
			}
			else{
				step += accel;
				rad += growth*step;
			}
			if(maxradius == 0){
				if(this->Angular){
					this->Angle += DegtoRad(angleturn);
					x += VectorX(step, RadtoDeg(this->Angle));
					y += VectorY(step, RadtoDeg(this->Angle));
				}
				else{
					x += DirX(this->Dir, step);
					y += DirY(this->Dir, step);
				}
			}

			DrawBigShot(x, y, rad, this->Damage, anim, Floor(anim/4)%4);
			Waitframe();
		}
		if(maxradius > 0){
			int maxrad = rad+8;
			int minrad = rad-8;
			int dir;
			for(int i = 0; i<45; i++){
				if(dir == 0){
					rad++;
					if(rad == maxrad)
						dir = 1;
				}
				else if(dir == 1){
					rad--;
					if(rad == minrad)
						dir = 0;
				}
				DrawBigShot(x, y, rad, this->Damage, anim, Floor(anim/4)%4);
				Waitframe();
			}
			while(rad > 0){
				rad -= growth*step;
				DrawBigShot(x, y, rad, this->Damage, anim, Floor(anim/4)%4);
				Waitframe();
			}
		}
		this->DeadState = 0;
	}
}

lweapon script BloodMoonCageLW{
	//State 0 - Preview 
	//State 1 - Active Flashing
	//State 2 - Active Flickering
	void DrawBloodMoonCage(int state, int layer, int cx, int cy, int rad, int bmc){
		layer = 2;
		if(ScreenFlag(1, 4)) //Layer -2
			layer = 1;
		
		//bmc[0] = Anim timer
		//bmc[1] = Particle count
		//bmc[2] = Base angle
		int bmcX = bmc[3];
		int bmcY = bmc[4];
		int bmcF = bmc[5];
		int bmcT = bmc[6];
		
		++bmc[0];
		bmc[0] %= 360;
		bmc[2] = WrapDegrees(bmc[2]+4);
		
		int angSlice = 360/bmc[1];
		if(state==1&&bmc[0]%4<2||state==3)
			Screen->Circle(layer, cx+7, cy+7, rad, Choose(0x0E, 0x83, 0x84), 1, 0, 0, 0, true, 64);
		
		if(state==4)
			Screen->Circle(layer, cx+7, cy+7, rad, 0x01, 1, 0, 0, 0, true, 128);
		for(int i=0; i<bmc[1]; ++i){
			int x = cx+VectorX(rad, bmc[2]+angSlice*i);
			int y = cy+VectorY(rad, bmc[2]+angSlice*i);
			if(bmcF[i]>-1){
				if(state==0){
					int c = Choose(0x0E, 0x83, 0x84);
					int c2 = Choose(0x0E, 0x83, 0x84);
					Screen->PutPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7, c, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7-1, c2, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7+1, c2, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7-1, y+bmcY[i]+7, c2, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7+1, y+bmcY[i]+7, c2, 0, 0, 0, 128);
				
				}
				else{
					if((bmcF[i]<8||bmcF[i]%4<2)&&bmcF[i]<16)
						Screen->FastTile(layer, x+bmcX[i], y+bmcY[i], bmcT[i]+Floor((bmcF[i]%8)/2), 8, 128);
				}
			}
			++bmcF[i];
			if(bmcF[i]>=8){
				if(state<2||state==3)
					bmcF[i] = 0;
			}
			if(bmcF[i]==0){
				bmcX[i] = Rand(-3, 3);
				bmcY[i] = Rand(-3, 3);
				bmcT[i] = Choose(54600, 54620);
			}
		}
	}
	void UpdateBloodMoonCage(lweapon this, int distance){
		for(int i=Screen->NumNPCs(); i>0; --i){
			npc n = Screen->LoadNPC(i);
			if(n->Misc[NPCM_CANSTUN]){
				int extra = (n->HitWidth+n->HitHeight)/4;
				int oldX = HitboxCenterX(n);
				int oldY = HitboxCenterY(n);
				int newX = oldX;
				int newY = oldY;
				int shiftX; int shiftY;
				int distTo = Distance(HitboxCenterX(n), HitboxCenterY(n), this->X+8, this->Y+8);
				if(distTo<distance+extra){
					n->Stun = Max(n->Stun, 120);
					if(distTo>distance){
						int angle = Angle(this->X+8, this->Y+8, HitboxCenterX(n), HitboxCenterY(n));
						newX = this->X+8+VectorX(distance, angle);
						newY = this->Y+8+VectorY(distance, angle);
						shiftX = newX-oldX;
						shiftY = newY-oldY;
					}
				}
				if(shiftX!=0||shiftY!=0){
					SetEnemyProperty(n, ENPROP_X, GetEnemyProperty(n, ENPROP_X)+shiftX);
					SetEnemyProperty(n, ENPROP_Y, GetEnemyProperty(n, ENPROP_Y)+shiftY);
				}
			}
		}
		if(Distance(Link->X, Link->Y, this->X, this->Y)<distance+8){
			SetLinkPitImmune(2);
			int pos = ComboAt(Link->X+8, Link->Y+12);
			int ct = Screen->ComboT[pos];
			if(ct==CT_PITFALL){
				ClampLinkToScreen();
			}
		}
	}
	void run(int tX, int tY, int expandDist, int activateDelay, int activeTime, int fadeOut, int communication){
		int expandTime = 16;
		int shrinkTime = 8;
		if(fadeOut)
			shrinkTime = 0;
		
		int x = this->X;
		int y = this->Y;
		
		this->InitD[6] = 0;
		if(tX>-1000){
			int i = 0;
			while(Distance(x, y, Link->X, Link->Y)>8){
				++i;
				if(i%2==0)
					ParticleAnim(x+Rand(-3, 3), y+Rand(-3, 3), Choose(54600, 54620), 8, 4, 2);
				int ang = Angle(x, y, Link->X, Link->Y);
				x += VectorX(8, ang);
				y += VectorY(8, ang);
				Waitframe();
			}
			x = tX;
			y = tY;
		}
		this->X = x;
		this->Y = y;
		
		int bmcX[256];
		int bmcY[256];
		int bmcF[256];
		int bmcT[256];
		int count = Floor((2*PI*expandDist)/8);
		int bmc[] = {0, count, Rand(360), bmcX, bmcY, bmcF, bmcT};
		for(int i=0; i<count; ++i){
			bmcF[i] = Rand(-8, -1);
		}
		
		for(int i=0; i<expandTime; ++i){
			DrawBloodMoonCage(0, 4, this->X, this->Y, Lerp(0, expandDist, i/expandTime), bmc);
			Waitframe();
		}
		for(int i=0; i<activateDelay; ++i){
			DrawBloodMoonCage(0, 4, this->X, this->Y, expandDist, bmc);
			Waitframe();
		}
		Game->PlaySound(SFX_BLOODMOONCAGE_ACTIVATE);
		this->InitD[6] = 1;
		for(int i=0; i<activeTime&&this->InitD[6]<2; ++i){
			DrawBloodMoonCage(1, 4, this->X, this->Y, expandDist, bmc);
			Waitdraw();
			UpdateBloodMoonCage(this, expandDist);
			Waitframe();
		}
		if(shrinkTime){
			for(int i=0; i<shrinkTime; ++i){
				int tempRad = Lerp(expandDist, 0, i/shrinkTime);
				DrawBloodMoonCage(1, 4, this->X, this->Y, Lerp(expandDist, 0, i/shrinkTime), bmc);
				Waitdraw();
				UpdateBloodMoonCage(this, Lerp(expandDist, 0, i/shrinkTime));
				Waitframe();
			}
			for(int i=0; i<8; ++i){
				DrawBloodMoonCage(2, 4, this->X, this->Y, 0, bmc);
				Waitframe();
			}
		}
		else{
			for(int i=0; i<8; ++i){
				DrawBloodMoonCage(2, 4, this->X, this->Y, expandDist, bmc);
				Waitframe();
			}
		}
		this->DeadState = 0;
	}
}


const int DAMAGE_SOLARSYSTEM = 200;

const int SFX_FRIENDBALLCHARGED = 35;
const int SFX_FRIENDBALLBREAK = 79;
const int SFX_FRIENDBALLFIRE = 80;
const int SPR_FRIENDBALL = 96;

itemdata script FriendBall{
	void DrawCharge(int i, int max, int chargeTimes){
		int c1 = Choose(0x86, 0x87, 0x88);
		int c2 = c1+1;
		if(c2>0x88)
			c2 = 0x86;
		GBMP[BMP_PLAYEREFFECTS]->Clear(0);
		GBMP[BMP_PLAYEREFFECTS]->DrawTile(0, 0, 0, Link->Tile-20, 1, 2, 6, -1, -1, 0, 0, 0, Link->Flip, true, 128);
		GBMP[BMP_PLAYEREFFECTS]->ReplaceColors(0, c1, 1, 255);
		int intensity = 0;
		if(i>chargeTimes[0])
			intensity = 1;
		if(i>chargeTimes[1])
			intensity = 2;
		if(i>chargeTimes[2])
			intensity = 3;
		Screen->Circle(2, Link->X+8+Rand(-intensity, intensity), Link->Y+Link->DrawYOffset+4+Rand(-intensity, intensity), 16*(i/max), c2, 1, 0, 0, 0, true, 128);
		Screen->Circle(2, Link->X+8+Rand(-intensity, intensity), Link->Y+Link->DrawYOffset+4+Rand(-intensity, intensity), 16*(i/max), c2, 1, 0, 0, 0, true, 128);
		GBMP[BMP_PLAYEREFFECTS]->Blit(2, RT_SCREEN, 0, 0, 16, 32, Link->X+Rand(-intensity, intensity), Link->Y+Link->DrawYOffset-16+Rand(-intensity, intensity), 16, 32, 0, 0, 0, 0, 0, true);
		GBMP[BMP_PLAYEREFFECTS]->Blit(2, RT_SCREEN, 0, 0, 16, 32, Link->X+Rand(-intensity, intensity), Link->Y+Link->DrawYOffset-16+Rand(-intensity, intensity), 16, 32, 0, 0, 0, 0, 0, true);
	}
	void run(){
		int chargeTimes[4] = {64, 96, 112, 128};
		if(HasAugment(I_AUGMENT_CHARGE)){
			chargeTimes[0] = 32;
			chargeTimes[1] = 64;
			chargeTimes[2] = 80;
			chargeTimes[3] = 96;
		}
		if(Link->MP<=0)
			Quit();
		int i;
		for(i=0; i<chargeTimes[3]&&InputButtonItem(this->ID); ++i){
			if(G[G_SCREENCHANGED])
				Quit();
			DrawCharge(i, chargeTimes[3], chargeTimes);
			if(i==chargeTimes[0])
				Game->PlaySound(SFX_FRIENDBALLCHARGED);
			if(HasAugment(I_AUGMENT_SPARK)){
				i = Min(i, chargeTimes[3]-8);
			}
			Waitframe();
		}
		if(i>=128){
			Game->PlaySound(SFX_FRIENDBALLBREAK);
			for(int i=0; i<18; ++i){
				RunEWeaponEffect(Link->X, Link->Y+Link->DrawYOffset, "GenParticle", {GP_ARROW, 2, -1, i*20+Rand(-10, 10), Rand(40, 60)/10, 4, 1, 24});
			}
		}
		else if(i>=chargeTimes[0]){
			int damage = DAMAGE_SOLARSYSTEM;
			int level = 1;
			if(i>chargeTimes[1])
				level = 2;
			if(i>chargeTimes[2])
				level = 3;
			for(; i>0; i-=8){
				if(G[G_SCREENCHANGED])
					Quit();
				DrawCharge(i, chargeTimes[3], chargeTimes);
				Waitframe();
			}
			int distMult = 1;
			if(HasAugment(I_AUGMENT_RANGE))
				distMult = 1.5;
			
			int numOrbs = 1;
			int orbDist = 24*distMult;
			int orbSpeed = 4;
			int duration = 120;
			int mpcost = 32;
			if(level==2){
				numOrbs = 2;
				orbDist = 32*distMult;
				orbSpeed = 5;
				duration = 180;
				mpcost = 40;
			}
			else if(level==3){
				numOrbs = 4;
				orbDist = 48*distMult;
				orbSpeed = 6;
				duration = 240;
				mpcost = 48;
			}
			lweapon orbs[4];
			int rotAngle = DirAngle(Link->Dir);
			Link->MP = Max(Link->MP-mpcost, 0);
			for(int i=0; i<numOrbs; ++i){
				orbs[i] = FireLWeapon(LW_SOLAR, Link->X, Link->Y, WrapDegrees(rotAngle+(360/numOrbs)*i), 0, damage, SPR_FRIENDBALL, 0);
				orbs[i]->Script = LWS_TIMEOUT;
				orbs[i]->InitD[0] = 2;
			}
			Game->PlaySound(SFX_FRIENDBALLFIRE);
			int accelmult = 1;
			for(int j=0; j<duration; ++j){
				if(Link->Action==LA_WALKING)
					accelmult = Min(accelmult+0.05, 2);
				else
					accelmult = Max(accelmult-0.1, 1);
				rotAngle = WrapDegrees(rotAngle+orbSpeed*accelmult);
				if(G[G_SCREENCHANGED])
					Quit();
				for(int i=0; i<numOrbs; ++i){
					int orbX = Link->X+VectorX(orbDist*Sin(j*(180/duration)), rotAngle+(360/numOrbs)*i);
					int orbY = Link->Y+VectorY(orbDist*Sin(j*(180/duration)), rotAngle+(360/numOrbs)*i);
					if(G[G_ANIM]%5==0)
						ParticleAnim(orbX+Rand(-4, 4), orbY+Rand(-4, 4), 65242, 0, 4, 0);
					if(orbs[i]->isValid()){
						orbs[i]->X = orbX;
						orbs[i]->Y = orbY;
						orbs[i]->DeadState = WDS_ALIVE;
						orbs[i]->Dir = AngleDir4(WrapDegrees(rotAngle+(360/numOrbs)*i));
						orbs[i]->InitD[0] = 2;
					}
					else{
						orbs[i] = FireLWeapon(LW_SOLAR, orbX, orbY, WrapDegrees(DirAngle(Link->Dir)+(360/numOrbs)*i), 0, damage, SPR_FRIENDBALL, 0);
						orbs[i]->Script = LWS_TIMEOUT;
						orbs[i]->InitD[0] = 2;
					}
					DarkRoom_AddLight(orbX+8, orbY+8, 0, 24, 1, 0, 0, 0);
				}
				Waitframe();
			}
		}
	}
}

const int DAMAGE_SUNDOG = 300;

itemdata script CornerDracus{
	void run(){
		int i; int j; int k;
		int x; int y;
		if(Link->MP==0)
			Quit();
		int mpcost = 2;
		int damage = DAMAGE_SUNDOG;
		int turretX = Link->X;
		int turretY = Link->Y;
		Game->PlaySound(SFX_PLACE);
		bool doClones;
		int clonesAngle = DirAngle(Link->Dir);
		if(HasAugment(I_AUGMENT_MIRAGE)){
			doClones = true;
			mpcost = 4;
		}
		
		int numTurrets = 1;
		int tX[3];
		int tY[3];
		int tOrder[3];
		if(doClones)
			numTurrets = 3;
		int clonesTile = 105340;
		while(InputButtonItem(this->ID)){
			if(G[G_SCREENCHANGED])
				Quit();
			
			if(doClones){
				clonesAngle = TurnToAngle(clonesAngle, DirAngle(Link->Dir), 5);
			}
			tX[0] = turretX;
			tY[0] = turretY;
			for(i=0; i<2; ++i){
				tX[1+i] = turretX+VectorX(-16+i*32, clonesAngle-90);
				tY[1+i] = turretY+VectorY(-16+i*32, clonesAngle-90);
			}
			SortLowestToHighestAndReturnOrder(tY, numTurrets, tOrder);
			
			for(i=0; i<numTurrets; ++i){
				if(G[G_ANIM]%4<2){
					switch(Link->Dir){
						case DIR_UP:
							Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
							break;
						case DIR_DOWN:
							Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile+4, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
							break;
						case DIR_LEFT:
							Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile+8, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
							break;
						case DIR_RIGHT:
							Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile+8, 1, 2, 6, -1, -1, 0, 0, 0, 1, true, 128);
							break;
					}
				}
				DarkRoom_AddLight(tX[i]+8, tY[i]+8, 0, 24, 1, 0, 0, 0);
			}
			Waitframe();
		}
		while(Link->MP>0){
			if(G[G_SCREENCHANGED])
				Quit();
			if(PressButtonItem(this->ID)){
				if(Distance(Link->X, Link->Y, turretX, turretY)<8){
					Game->PlaySound(SFX_PLACE);
					Waitframes(8);
					Quit();
				}
				else{
					for(j=0; j<16; ++j){
						if(doClones){
							clonesAngle = TurnToAngle(clonesAngle, DirAngle(Link->Dir), 5);
						}
						tX[0] = turretX;
						tY[0] = turretY;
						for(i=0; i<2; ++i){
							tX[1+i] = turretX+VectorX(-16+i*32, clonesAngle-90);
							tY[1+i] = turretY+VectorY(-16+i*32, clonesAngle-90);
						}
						SortLowestToHighestAndReturnOrder(tY, numTurrets, tOrder);
						
						for(i=0; i<numTurrets; ++i){
							if(G[G_ANIM]%4<2){
								switch(Link->Dir){
									case DIR_UP:
										Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile+Floor((G[G_ANIM]%16)/4), 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
										break;
									case DIR_DOWN:
										Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile+4+Floor((G[G_ANIM]%16)/4), 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
										break;
									case DIR_LEFT:
										Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile+8+Floor((G[G_ANIM]%16)/4), 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
										break;
									case DIR_RIGHT:
										Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile+8+Floor((G[G_ANIM]%16)/4), 1, 2, 6, -1, -1, 0, 0, 0, 1, true, 128);
										break;
								}
							}
							if(j%4==0){
								if(doClones){
									lweapon l = FireLWeapon(LW_SOLAR, tX[i], tY[i], clonesAngle, 400, damage, SPR_LIGHTSHOT, 32);
									l->Rotation = clonesAngle;
									RunLWeaponScript(l, "GlowLW", {16});
								}
								else{
									lweapon l = FireLWeapon(LW_SOLAR, tX[i], tY[i], DirAngle(Link->Dir), 400, damage, SPR_LIGHTSHOT, 32);
									l->Rotation = DirAngle(Link->Dir);
									RunLWeaponScript(l, "GlowLW", {16});
								}
							}
							DarkRoom_AddLight(tX[i]+8, tY[i]+8, 0, 24, 1, 0, 0, 0);
						}
						
						if(j%4==0){
							Link->MP = Max(Link->MP-mpcost, 0);
						}
						Waitframe();
					}
				}
			}
			
			if(doClones){
				clonesAngle = TurnToAngle(clonesAngle, DirAngle(Link->Dir), 5);
			}
			tX[0] = turretX;
			tY[0] = turretY;
			for(i=0; i<2; ++i){
				tX[1+i] = turretX+VectorX(-16+i*32, clonesAngle-90);
				tY[1+i] = turretY+VectorY(-16+i*32, clonesAngle-90);
			}
			SortLowestToHighestAndReturnOrder(tY, numTurrets, tOrder);
			
			for(i=0; i<numTurrets; ++i){
				if(G[G_ANIM]%4<2){
					switch(Link->Dir){
						case DIR_UP:
							Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
							break;
						case DIR_DOWN:
							Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile+4, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
							break;
						case DIR_LEFT:
							Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile+8, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
							break;
						case DIR_RIGHT:
							Screen->DrawTile(2, tX[tOrder[i]], tY[tOrder[i]]-16, clonesTile+8, 1, 2, 6, -1, -1, 0, 0, 0, 1, true, 128);
							break;
					}
				}
				DarkRoom_AddLight(tX[i]+8, tY[i]+8, 0, 24, 1, 0, 0, 0);
			}
			Waitframe();
		}
	}
}

const int TIL_KAYLANILASER = 66100;
const int SFX_LASERBEAM = 81;
const int CMB_BURNEFFECT = 33280;

itemdata script MillionLasers{
	const int DAT_LENGTH = 0;
	const int DAT_HASCHANGED = 1;
	const int DAT_DAMAGE = 2;
		
	void DrawLaser(int layer, int x, int y, int angle, int thickness, int length, int palshift, int damage){
		GBMP[BMP_KAYLANILASER]->Clear(layer);
		int laserAFrame = G[G_ANIM]%8;
		GBMP[BMP_KAYLANILASER]->FastTile(layer, 0, 0, TIL_KAYLANILASER+20+laserAFrame, 8, 128);
		GBMP[BMP_KAYLANILASER]->FastTile(layer, 16, 0, TIL_KAYLANILASER+laserAFrame, 8, 128);
		GBMP[BMP_KAYLANILASER]->FastTile(layer, 32, 0, TIL_KAYLANILASER+laserAFrame, 8, 128);
		if((length+64)%16!=0)
			GBMP[BMP_KAYLANILASER]->Rectangle(layer, 32+((length+64)%16), 0, 47, 15, 0x00, 1, 0, 0, 0, true, 128);
		int numBlocks = Ceiling(length/16);
		if(length<0){
			numBlocks = 0;
			GBMP[BMP_KAYLANILASER]->Rectangle(layer, ((length+64)%16), 0, 15, 15, 0x00, 1, 0, 0, 0, true, 128);
		}
		if(palshift==1){
			GBMP[BMP_KAYLANILASER]->ReplaceColors(layer, 0x81, 0x88, 0x86);
			GBMP[BMP_KAYLANILASER]->ReplaceColors(layer, 0x86, 0x87, 0x87);
			GBMP[BMP_KAYLANILASER]->ReplaceColors(layer, 0x87, 0x88, 0x88);
		}
		else if(palshift==2){
			GBMP[BMP_KAYLANILASER]->ReplaceColors(layer, 0x81, 0x86, 0x87);
			GBMP[BMP_KAYLANILASER]->ReplaceColors(layer, 0x86, 0x88, 0x88);
		}
		GBMP[BMP_KAYLANILASER]->Blit(layer, GBMP[BMP_KAYLANILASER], 0, 0, 48, 16, 0, 16+(8-thickness), 48, thickness*2, 0, 0, 0, 0, 0, true);
		//GBMP[BMP_KAYLANILASER]->Blit(layer, RT_SCREEN, 0, 0, 48, 32, 0, 0, 48, 32, 0, 0, 0, 0, 0, true);
		int blockX = x;
		int blockY = y;
		int scaleOff = 8-thickness;
		int offX = 0;
		int offY = 0;
		for(int i=0; i<=numBlocks; ++i){
			if(i==0){
				GBMP[BMP_KAYLANILASER]->Blit(layer, GBMP[BMP_KAYLANILASER2], 0, 16, 16, 16, 0, 0, 16, 16, 0, 0, 0, 0, 0, true);
				GBMP[BMP_KAYLANILASER2]->Blit(layer, RT_SCREEN, 0, 0, 16, 16, blockX, blockY, 16, 16, angle, 0, 0, 0, 0, true);
			}
			else if(i==numBlocks){
				GBMP[BMP_KAYLANILASER]->Blit(layer, GBMP[BMP_KAYLANILASER2], 32, 16, 16, 16, 0, 0, 16, 16, 0, 0, 0, 0, 0, true);
				GBMP[BMP_KAYLANILASER2]->Blit(layer, RT_SCREEN, 0, 0, 16, 16, blockX, blockY, 16, 16, angle, 0, 0, 0, 0, true);
			}
			else{
				GBMP[BMP_KAYLANILASER]->Blit(layer, GBMP[BMP_KAYLANILASER2], 16, 16, 16, 16, 0, 0, 16, 16, 0, 0, 0, 0, 0, true);
				GBMP[BMP_KAYLANILASER2]->Blit(layer, RT_SCREEN, 0, 0, 16, 16, blockX, blockY, 16, 16, angle, 0, 0, 0, 0, true);
			}
			GBMP[BMP_KAYLANILASER2]->Clear(layer);
			MakeHitboxLW(LW_SOLAR, blockX, blockY, 16, 16, damage, AngleDir4(angle));
			blockX += VectorX(16, angle);
			blockY += VectorY(16, angle);
		}
		int tipX = x+VectorX(length+2, angle);
		int tipY = y+VectorY(length+2, angle)-8;
		Screen->DrawTile(layer, tipX, tipY, TIL_KAYLANILASER+40+Floor((G[G_ANIM]%12)/3), 1, 2, 8, -1, -1, tipX, tipY, angle, 0, true, 128);
		DarkRoom_AddLight(x+8, y+8, 1, length+48, 0.5, angle, 0.01, 4);
	}
	void GetLength(npc target, int data, int x, int y, int angle, int thickness){
		// int w = dir<2?thickness*2:240;
		// int h = dir<2?240:thickness*2;
		// lweapon l = MakeHitboxLW(LW_SOLAR, Link->X+8+DirX(dir, 120)-w/2, Link->Y+8+DirY(dir, 120)-h/2, w, h, 0, dir);
		// l->CollDetection = false;
		// l->DeadState = 0;
		npc oldTarget = target[0];
		int closestDist = 1000;
		int dist;
		for(int i=Screen->NumNPCs(); i>0; --i){
			npc n = Screen->LoadNPC(i);
			if(n->CollDetection&&n->Defense[NPCD_SOLAR]!=NPCDT_BLOCK&&n->Defense[NPCD_SOLAR]!=NPCDT_IGNORE){
				if(RotRectCollision(x+VectorX(128, angle), y+VectorY(128, angle), 256, 16, angle, HitboxCenterX(n), HitboxCenterY(n), n->HitWidth, n->HitHeight, 0, false)){ //Collision(l, n)){
					dist = Distance(HitboxCenterX(n), HitboxCenterY(n), x, y);
					if(dist<closestDist){
						target[0] = n;
						closestDist = dist;
					}
				}
			}
		}
		dist = 0;
		for(int i=0; i<240; ++i){
			dist += 8;
			x += VectorX(8, angle); //DirX(dir, 8);
			y += VectorY(8, angle); //DirY(dir, 8);
			if(IsSolidNoPit(x, y)||x<-8||x>264||y<-8||y>184){
				break;
			}
		}
		dist -= 8;
		x -= VectorX(8, angle); //DirX(dir, 8);
		y -= VectorY(8, angle); //DirY(dir, 8);
		for(int i=0; i<8; ++i){
			++dist;
			x += VectorX(1, angle); //DirX(dir, 1);
			y += VectorY(1, angle); //DirY(dir, 1);
			if(IsSolidNoPit(x, y)){
				break;
			}
		}
		if(dist<closestDist){
			closestDist = dist;
			npc nullnpc;
			target[0] = nullnpc;
		}
		data[DAT_LENGTH] = closestDist;
		data[DAT_HASCHANGED] = 0;
		if(!target[0]->isValid())
			data[DAT_HASCHANGED] = 2;
		else if(target[0]!=oldTarget)
			data[DAT_HASCHANGED] = 1;
	}
	void run(){
		if(Link->MP==0)
			Quit();
		
		int mpcost = 1;
		int mptimer;
		
		bool homingLaser;
		if(HasAugment(I_AUGMENT_LASER))
			homingLaser = true;
		
		Waitframe();
		Link->Action = LA_ATTACKING;
		int dir = Link->Dir;
		npc target[1];
		int data[2];
		int sfxTimer[1];
		int strength = 0;
		int decayFrames = 8;
		int tempLength;
		while(InputButtonItem(this->ID)&&Link->MP>0&&(CanAttack()||Link->Action==LA_ATTACKING)){
			if(G[G_SCREENCHANGED])
				Quit();
			if(mptimer)
				--mptimer;
			else{
				mpcost = 1;
				if(strength>75)
					mpcost = 2;
				Link->MP = Max(Link->MP-mpcost, 0);
				mptimer = 4;
			}
			int thickness = Min(4+(strength/75)*4, 8);
			int x = Link->X+8+DirX(dir, 16);
			int y = Link->Y+8+DirY(dir, 16);
			int palshift;
			if(decayFrames){
				--decayFrames;
				strength = Clamp(strength-2, 0, 100);
			}
			else{
				strength = Clamp(strength+0.75, 0, 100);
			}
			int damage = 50;
			int level = 0;
			if(strength>75){
				palshift = Floor(G[G_ANIM]/4)%4;
				if(palshift==3)
					palshift = 2;
				damage = 400;
				level = 2;
			}
			else if(strength>50){
				damage = 300;
				level = 2;
			}
			else if(strength>25){
				damage = 100;
				level = 1;
			}
			int laserAngle = DirAngle(dir);
			if(homingLaser&&target[0]->isValid()){
				if(Abs(AngDiff(Angle(CenterLinkX(), CenterLinkY(), CenterX(target[0]), CenterY(target[0])), DirAngle(Link->Dir)))<15){
					laserAngle = Angle(CenterLinkX(), CenterLinkY(), CenterX(target[0]), CenterY(target[0]));
				}
			}
			GetLength(target, data, x, y, laserAngle, thickness);
			if(tempLength>data[DAT_LENGTH])
				tempLength = data[DAT_LENGTH];
			else{
				tempLength = Min(tempLength+16, data[DAT_LENGTH]);
			}
			DrawLaser(2, x-8, y-8, laserAngle, thickness, tempLength-8, palshift, damage);
			if(level==2&&target[0]->isValid()){
				if(G[G_ANIM]%4<2||damage>400){
					Screen->FastCombo(4, HitboxCenterX(target[0])-8, HitboxCenterY(target[0])-8, CMB_BURNEFFECT, 8, 64);
				}
			}
			
			// int len = tempLength;
			// int w = dir<2?thickness*2:len;
			// int h = dir<2?len:thickness*2;
			// lweapon l = MakeHitboxLW(LW_SOLAR, x+DirX(dir, len/2)-w/2, y+DirY(dir, len/2)-h/2, w, h, damage, dir);
			
			if(data[DAT_HASCHANGED]==2)
				decayFrames = 16;
			else if(data[DAT_HASCHANGED]==1)
				decayFrames = 4;
			LoopingSFX(sfxTimer, 6, SFX_LASERBEAM+level);
			G[G_FORCEDIR] = dir;
			Waitframe();
		}
		// for(int i=32; i<120; ++i){
			// int flash = Floor((i%8)/2);
			// if(flash==3)
				// flash = 1;
			// DrawLaser(2, Link->X+DirX(Link->Dir, 16), Link->Y+DirY(Link->Dir, 16), DirAngle(Link->Dir), 8, i, flash);
			// Waitframe();
		// }
		//BMP_KAYLANILASER
	}
}

itemsprite script SmallKey{
	void run(){
		int jump = this->Jump;
		while(true){
			if(jump<0&&this->Jump>0){
				Game->PlaySound(91);
			}
			jump = this->Jump;
			Waitframe();
		}
	}
}

lweapon script ConfigOptionsWhatAreThose{
	void run(){
		this->MoveFlags[WPNMV_CAN_PITFALL] = false;
	}
}

itemdata script Lantern{
	void run(){
		int maxFire = 2;
		if(HasAugment(I_AUGMENT_CANDLE))
			maxFire = 4;
		if(NumLWeaponsOf(LW_FIRE)<maxFire){
			Game->PlaySound(SFX_FIRE);
			Link->Action = LA_ATTACKING;
			lweapon fire = CreateLWeaponAt(LW_FIRE, Link->X+DirX(Link->Dir, 16), Link->Y+DirY(Link->Dir, 16));
			fire->Dir = Link->Dir;
			fire->Step = 50;
			fire->UseSprite(12);
			fire->Damage = this->Power*2;
			fire->MoveFlags[WPNMV_CAN_PITFALL] = false;
			RunLWeaponScript(fire, "GlowLW", {24});
			if(HasAugment(I_AUGMENT_CANDLE)){
				for(int i=-1; i<=1; i+=2){
					lweapon fire = CreateLWeaponAt(LW_FIRE, Link->X+DirX(Link->Dir, 16)+DirY(Link->Dir, 16*i), Link->Y+DirY(Link->Dir, 16)+DirX(Link->Dir, 16*i));
					fire->Dir = Link->Dir;
					fire->Step = 50;
					fire->UseSprite(12);
					fire->Damage = this->Power*2;
					fire->MoveFlags[WPNMV_CAN_PITFALL] = false;
					RunLWeaponScript(fire, "GlowLW", {24});
				}
			}
		}
	}
}

const int LWS_GLOW = 12;

lweapon script GlowLW{
	void run(int scale){
		while(true){
			DarkRoom_AddLight(CenterX(this), CenterY(this), 0, scale, 1, 0, 0, 0);
			Waitframe();
		}
	}
}

void UpdateLunarangTiles(bool hideMeter){
	CopyTile(66168, 66268);
	if(!hideMeter&&G[G_LUNARANGCOOLDOWN]){
		int meter = Clamp((G[G_LUNARANGCOOLDOWN]/40)*12, 0, 12);
		OverlayTile(66268, 66540+meter);
	}
}

itemdata script Lunarang{
	void UpdateTrail(lweapon hitbox, int layer, int trail, int x, int y, int frame){
		for(int i=7; i>=1; --i){
			trail[i] = trail[i-1];
			trail[8+i] = trail[8+i-1];
		}
		trail[0] = x+hitbox->DrawXOffset;
		trail[8] = y+hitbox->DrawYOffset;
		int a = Floor((G[G_ANIM]%8)/2);
		if(a==3)
			a = 1;
		for(int i=1; i<8; i+=2){
			if(trail[i]>-1000){
				Screen->FastTile(layer, trail[i]+Rand(-1, 1), trail[8+i]+Rand(-1, 1), 66188+20*a+frame, 7, 128);
			}
		}
	}
	void SetHitboxPos(lweapon hitbox, int x, int y){
		hitbox->X = Clamp(x, 4, 236);
		hitbox->Y = Clamp(y, 4, 156);
		hitbox->HitXOffset = (x-hitbox->X);
		hitbox->HitYOffset = (y-hitbox->Y);
		hitbox->DrawXOffset = hitbox->HitXOffset;
		hitbox->DrawYOffset = hitbox->HitYOffset;
	}
	void run(){
		if(G[G_LUNARANGCOOLDOWN])
			Quit();
		int layer = 2;
		if(ScreenFlag(1, 4)) //Layer -2
			layer = 1;
		int trail[16];
		for(int i=0; i<16; ++i){
			trail[i] = -1000;
		}
		lweapon hitbox = CreateLWeaponAt(LW_LUNARANG, Link->X+DirX(Link->Dir, 16), Link->Y+DirY(Link->Dir, 16));
		int dir = Link->Dir;
		hitbox->Dir = dir;
		hitbox->DeadState = -1;
		hitbox->Step = 0;
		hitbox->Damage = 0;
		hitbox->Level = 100;
		int frame;
		switch(Link->Dir){
			case DIR_UP:
				frame = 2;
				break;
			case DIR_DOWN:
				frame = 6;
				break;
			case DIR_LEFT:
				frame = 0;
				break;
			case DIR_RIGHT:
				frame = 4;
				break;
		}
		hitbox->Tile = 66168+frame;
		hitbox->CSet = 7;
		int brangX = hitbox->X; int brangY = hitbox->Y;
		SetHitboxPos(hitbox, brangX, brangY);
		int throwSpeed = 0;
		Waitframe();
		if(G[G_SCREENCHANGED]){
			if(hitbox->isValid())
				hitbox->Remove();
			Quit();
		}
		if(StickX()!=0||StickY()!=0){
			dir = AngleDir8(Angle(0, 0, StickX(), StickY()));
			hitbox->Dir = dir;
		}
		throwSpeed = 300;
		int sfxTimer[1];
		if(hitbox->isValid()){
			bool blocked = false;
			bool noCharge = false;
			while(hitbox->isValid()&&hitbox->DeadState!=0&&throwSpeed>0&&!blocked&&!noCharge){
				GrabItems(hitbox);
				if(G[G_SCREENCHANGED]){
					if(hitbox->isValid())
						hitbox->Remove();
					Quit();
				}
				throwSpeed = Max(throwSpeed-8, 0);
				brangX += VectorX(throwSpeed/100, DirAngle(hitbox->Dir));
				brangY += VectorY(throwSpeed/100, DirAngle(hitbox->Dir));
				if(brangX<0||brangX>240||brangY<0||brangY>160)
					noCharge = true;
				SetHitboxPos(hitbox, brangX, brangY);
				LoopingSFX(sfxTimer, 8, SFX_BRANG);
				if(G[G_ANIM]%2==0)
					frame = (frame+1)%8;
				hitbox->Tile = 66168+frame;
				UpdateTrail(hitbox, layer, trail, hitbox->X, hitbox->Y+hitbox->DrawYOffset, frame);
				if(hitbox->Misc[LWM_FLAGS]&LWMF_DEFLECT)
					blocked = true;
				Waitframe();
			}
			if(InputButtonItemGlobal(this->ID)){
				int chargeTime;
				blocked = false;
				const int EDGEDIST = 0;
				if(!noCharge){
					brangX = Clamp(brangX, EDGEDIST, 240-EDGEDIST);
					brangY = Clamp(brangY, EDGEDIST, 160-EDGEDIST);
					SetHitboxPos(hitbox, brangX, brangY);
					while(InputButtonItemGlobal(this->ID)&&!blocked){
						if(G[G_SCREENCHANGED]){
							if(hitbox->isValid())
								hitbox->Remove();
							Quit();
						}
						if(chargeTime<60){
							++chargeTime;
							if(chargeTime==60)
								Game->PlaySound(SFX_CHARGE1);
						}
						if(!hitbox->isValid()){
							hitbox = CreateLWeaponAt(LW_LUNARANG, brangX, brangY);
							hitbox->Dir = dir;
							hitbox->DeadState = -1;
							hitbox->Step = 0;
							hitbox->Damage = 0;
							hitbox->Level = 100;
							hitbox->Tile = 66168+frame;
							hitbox->CSet = 7;
							SetHitboxPos(hitbox, brangX, brangY);
						}
						hitbox->Step = 0;
						LoopingSFX(sfxTimer, 8, SFX_BRANG);
						if(G[G_ANIM]%2==0)
							frame = (frame+1)%8;
						if(chargeTime>=60&&G[G_ANIM]%4<2)
							hitbox->Tile = 66248+frame;
						else
							hitbox->Tile = 66168+frame;
						hitbox->DeadState = -1;
						UpdateTrail(hitbox, layer, trail, hitbox->X, hitbox->Y+hitbox->DrawYOffset, frame);
						if(hitbox->Misc[LWM_FLAGS]&LWMF_DEFLECT)
							blocked = true;
						Waitframe();
					}
				}
				if(chargeTime>=60&&Link->Action!=LA_SCROLLING&&!G[G_SCREENCHANGED]){
					G[G_LUNARANGCOOLDOWN] = 40;
					lweapon moonflash = CreateLWeaponAt(LW_SCRIPT10, brangX, brangY);
					moonflash->DrawYOffset = -1000;
					moonflash->CollDetection = false;
					moonflash->Damage = this->Power*2;
					RunLWeaponScript(moonflash, "Moonflash", {40});
				}
			}
			throwSpeed = 0;
			while(Distance(brangX, brangY, Link->X, Link->Y)>3){
				if(G[G_SCREENCHANGED]){
					if(hitbox->isValid())
						hitbox->Remove();
					Quit();
				}
				if(!hitbox->isValid()){
					hitbox = CreateLWeaponAt(LW_LUNARANG, brangX, brangY);
					hitbox->Dir = dir;
					hitbox->DeadState = -1;
					hitbox->Step = 0;
					hitbox->Damage = 0;
					hitbox->Level = 100;
					hitbox->Tile = 66168+frame;
					hitbox->CSet = 7;
				}
				hitbox->Angular = true;
				hitbox->Angle = DegtoRad(Angle(brangX, brangY, Link->X, Link->Y));
				throwSpeed = Min(throwSpeed+8, 300);
				brangX += VectorX(throwSpeed/100, RadtoDeg(hitbox->Angle));
				brangY += VectorY(throwSpeed/100, RadtoDeg(hitbox->Angle));
				SetHitboxPos(hitbox, brangX, brangY);
				GrabItems(hitbox);
				LoopingSFX(sfxTimer, 8, SFX_BRANG);
				if(G[G_ANIM]%2==0)
					frame = (frame+1)%8;
				hitbox->Tile = 66168+frame;
				hitbox->DeadState = -1;
				UpdateTrail(hitbox, layer, trail, hitbox->X, hitbox->Y+hitbox->DrawYOffset, frame);
				Waitframe();
			}
			if(hitbox->isValid()){
				hitbox->DeadState = 0;
			}
			for(int i=0; i<8; ++i){
				if(G[G_SCREENCHANGED]){
					if(hitbox->isValid())
						hitbox->Remove();
					Quit();
				}
				UpdateTrail(hitbox, layer, trail, -1000, -1000, frame);
				Waitframe();
			}
		}
	}
}

lweapon script Moonflash{
	void run(int delay){
		int angle = Rand(360);
		for(int i=0; i<delay; ++i){
			angle += 4;
			int c = Choose(0x71, 0x72, 0x73);
			for(int j=0; j<18; ++j){
				Screen->PutPixel(6, this->X+8+VectorX(24, angle+20*j)+Rand(-2, 2), this->Y+8+VectorY(24, angle+20*j)+Rand(-2, 2), c, 0, 0, 0, 128);
			}
			Waitframe();
		}
		Game->PlaySound(SFX_SUMMON);
		for(int i=0; i<16; ++i){
			int til;
			int cs;
			bool draw;
			if(i<6||i>=13){
				til = 66196;
				cs = 11;
			}
			else{
				til = 66256;
				cs = 7;
			}
			if(i<4||i>=11){
				if(i%4<2)
					draw = true;
			}
			else
				draw = true;
			if(draw)
				Screen->DrawTile(6, this->X-16, this->Y-16, til, 3, 3, cs, -1, -1, 0, 0, 0, 0, true, 128);
			MakeHitboxLW(LW_LUNAR, this->X-12, this->Y-12, 40, 40, this->Damage, -1);
			Waitframe();
		}
		this->DeadState = 0;
	}
}

itemdata script Potion{
	void run(int type){
		int reviveCount;
		if(type==0){
			if(G[G_ASHERHP]<=0&&!G[G_ASHERINCINERATED])
				++reviveCount;
			if(G[G_TORRINHP]<=0&&!G[G_TORRININCINERATED])
				++reviveCount;
			if(G[G_KAYLANIHP]<=0&&!G[G_KAYLANIINCINERATED])
				++reviveCount;
			if(G[G_SORENHP]<=0)
				++reviveCount;
			if(G[G_TERRYHP]<=0)
				++reviveCount;
			if(G[G_SIYEDHP]<=0)
				++reviveCount;
			if(reviveCount==0){
				Game->PlaySound(69);
				Quit();
			}
		}
		else if(type==1){
			if(Link->HP>=Link->MaxHP){
				Game->PlaySound(69);
				Quit();
			}
		}
		int i;
		for(i=0; i<48&&InputButtonItem(this->ID); ++i){
			if(G[G_SCREENCHANGED])
				Quit();
			if(i%4==0){
				if(type==0)
					ParticleAnim(Link->X+Rand(-8, 8), Link->Y+Rand(-8, 8), 968, 8, 8, 5);
				else
					ParticleAnim(Link->X+Rand(-8, 8), Link->Y+Rand(-8, 8), 611, 8, 8, 5);
			}
			G[G_STEPMOD] -= 0.5;
			Waitframe();
		}
		if(i>=48){
			Game->PlaySound(112);
			int bitid = TempBitmap_Create(0, 16, 32);
			bitmap b = TempBMP[bitid];
			int healColor;
			if(type==0)
				healColor = 0x86;
			else if(type==1)
				healColor = 0x83;
			for(int i=0; i<16; ++i){
				b->Clear(0);
				if(SingleTileLinkAction())
					b->DrawTile(0, 0, 16, Link->Tile, 1, 1, 6, -1, -1, 0, 0, 0, Link->Flip, true, 128);
				else
					b->DrawTile(0, 0, 0, Link->Tile-20, 1, 2, 6, -1, -1, 0, 0, 0, Link->Flip, true, 128);
				if(i>3){
					b->Circle(0, 8, 20, (i-4), 0x00, 1, 0, 0, 0, true, 128);
				}
				b->ReplaceColors(0, healColor, 0x01, 0xBF);
				if(Link->Action!=LA_SCROLLING)
					b->Blit(4, RT_SCREEN, 0, 0, 16, 32, Link->X+Link->DrawXOffset, Link->Y+Link->DrawYOffset-16, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				G[G_NOACTION] = 1;
				Waitframe();
			}
			if(type==0){ //Revival
				if(G[G_ASHERHP]<=0&&!G[G_ASHERINCINERATED])
					G[G_ASHERHP] = 16;
				if(G[G_TORRINHP]<=0&&!G[G_TORRININCINERATED])
					G[G_TORRINHP] = 16;
				if(G[G_KAYLANIHP]<=0&&!G[G_KAYLANIINCINERATED])
					G[G_KAYLANIHP] = 16;
				RemoveButtonItem(this->ID);
				G[G_POTIONACTIVE] = 0;
				G[G_POTIONTIMER] = 48*reviveCount;
				Link->Item[this->ID] = false;
			}
			else if(type==1){ //Regen
				RemoveButtonItem(this->ID);
				G[G_POTIONACTIVE] = 1;
				G[G_POTIONCHAR] = GetCharID();
				G[G_POTIONTIMER] = 120*6;
				Link->Item[this->ID] = false;
			}
		}
	}
}

itemdata script PickupMessage{
	void run(int d0, int d1, int d2, int d3, int d4, int d5, int d6, int AintZCsMethodOfSharingArgumentsAmongMultipleScriptsForItemsFunny){
		eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
		e->CollDetection = false;
		e->DrawYOffset = -1000;
		RunEWeaponScript(e, "ItemPopup", {this->ID});
		if(!G[G_RANDOMIZERENABLED]){
			int Args[8] = {53, AintZCsMethodOfSharingArgumentsAmongMultipleScriptsForItemsFunny};
			RunFFCScript(64, Args);
		}
		FoundItems[this->ID] = true;
		if(this->ID==I_SWORD_TORRIN2||this->ID==I_SWORD_TERRY2){
			Link->Item[I_FISTUPGRADE] = true;
			FoundItems[I_FISTUPGRADE] = true;
		}
	}
}

itemdata script PickupMessageUpgrade{
	void run(int d0, int d1, int d2, int d3, int d4, int d5, int d6, int AintZCsMethodOfSharingArgumentsAmongMultipleScriptsForItemsFunny){
		if(G[G_RANDOMIZERENABLED]){
			int giveItem = Randomizer_ProgressiveItem(this->ID);
			if(giveItem!=this->ID){
				Link->Item[giveItem] = true;
			}
		}
		
		eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
		e->CollDetection = false;
		e->DrawYOffset = -1000;
		RunEWeaponScript(e, "ItemPopup", {this->ID});
		int Args[8] = {53, AintZCsMethodOfSharingArgumentsAmongMultipleScriptsForItemsFunny};
		RunFFCScript(64, Args);
		FoundItems[this->ID] = true;
	}
}

lweapon script BestiaryDropManager{
	void run(int id, int enemyID){
		item itm = SpawnRandomizerItem(IL_BES_REDOCTO+BestiaryListNum(enemyID), id, Link->X, Link->Y);
		itm->Z = Link->Z;
		while(itm->isValid()){
			itm->X = Link->X;
			itm->Y = Link->Y;
			itm->Z = Link->Z;
			itm->MoveFlags[ITEMMV_CAN_PITFALL] = false;
			Waitframe();
		}
		LoreTracking[LT_ENEMIESRANDO+enemyID] = 2;
		
		this->DeadState = 0;
		Quit();
	}
}

itemsprite script BestiaryEntry{
	void run(int entry, int loc){
		while(!AccurateLinkCollision(this)||(this->Misc[ITMM_FLAGS]&ITMMF_SUPERDUMMY)){
			Waitframe();
		}
		entry = this->InitD[0];
		loc = this->InitD[1];
		SendMultiworldItem(loc);
		//Trace(entry);
		eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
		e->CollDetection = false;
		e->DrawYOffset = -1000;
		if(entry>0){
			LoreTracking[LT_ENEMIES+entry] = 1;
			RunEWeaponScript(e, "ItemPopup", {1000+entry});
		}
		else{
			LoreTracking[LT_ENEMIES+G[G_BESTIARYPAGE]] = 1;
			RunEWeaponScript(e, "ItemPopup", {1000+G[G_BESTIARYPAGE]});
		}
		this->Pickup &= ~IP_DUMMY;
		while(true){
			this->X = Link->X;
			this->Y = Link->Y;
			Waitframe();
		}
	}
}

itemsprite script RandomizerItem{
	void run(int loc){
		while(!AccurateLinkCollision(this)||(this->Misc[ITMM_FLAGS]&ITMMF_SUPERDUMMY)){
			Waitframe();
		}
		loc = this->InitD[0];
		SendMultiworldItem(loc);
		this->Pickup &= ~IP_DUMMY;
		while(true){
			this->X = Link->X;
			this->Y = Link->Y;
			Waitframe();
		}
	}
}

const int DAMAGE_SOREN_DASH = 300;

const int SFX_SORENDASHSPARK = 101;

itemdata script SorenDash{
	void run(){
		int damage = DAMAGE_SOREN_DASH;
		if(FoundItems[I_SWORD_SOREN2]){
			itemdata id = Game->LoadItemData(I_SWORD_SOREN2);
			damage = id->Power*2+100;
		}
		Game->PlaySound(SFX_ASHERDASH);
		int vX = (Link->InputLeft?-1:0) + (Link->InputRight?1:0);
		int vY = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
		if(vX==0&&vY==0){
			vX = DirX(Link->Dir, 1);
			vY = DirY(Link->Dir, 1);
		}
		
		int slashOffX[8] = {0, 0, -14, 14, -12, 12, -12, 12};
		int slashOffY[8] = {-14, 14, 0, 0, -12, -12, 12, 12};
			
		int arcDir = 1;
		if(Link->Dir==DIR_RIGHT)
			arcDir = -1;
		bool dashInterrupted;
		int swordT;
		int swordAng;
		int swordDir;
		int swordTile;
		int swordFlip;
		int swordX;
		int swordY;
		int swordTilHV = 63862;
		int swordTilDiag = 101403;
		if(FoundItems[I_SWORD_SOREN2]){
			swordTilHV = 67321;
			swordTilDiag = 67284;
		}
		int Dir = Link->Dir;
		int sparkT;
		for(int i=0; i<16&&!dashInterrupted; ++i){
			Link->Dir = Dir;
			G[G_FORCEDIR] = Dir;
			if(!CanAttack())
				dashInterrupted = true;
			if(G[G_SCREENCHANGED])
				dashInterrupted = true;
			swordAng = WrapDegrees(DirAngle(Link->Dir)+180);
			if(Link->Dir==DIR_RIGHT)
				swordAng -= 30;
			else
				swordAng += 30;
			swordX = Link->X+VectorX(14, swordAng);
			swordY = Link->Y+VectorY(14, swordAng);
			if(i<8){
				Screen->DrawTile(Link->Dir==DIR_UP?2:4, swordX, swordY, swordTilHV+1, 1, 1, 0, -1, -1, swordX, swordY, swordAng, 0, true, 128);
				lweapon l = ParticleAnim(swordX+Rand(-2, 2), swordY+Rand(-2, 2), 101420, 7, 4, 2);
				l->Rotation = Angle(0, 0, vX, vY);
				if(Link->Dir==DIR_LEFT||Link->Dir==DIR_RIGHT)
					l->Y += 4;
			}
			else{
				if(i==8)
					Game->PlaySound(SFX_SWORD);
				swordAng = Lerp(DirAngle(Link->Dir)-arcDir*90, DirAngle(Link->Dir)+arcDir*90, swordT/16);
				swordDir = AngleDir8(WrapDegrees(swordAng));
				swordX = Link->X+slashOffX[swordDir];
				swordY = Link->Y+slashOffY[swordDir];
				switch(swordDir){
					case DIR_UP:
						swordTile = swordTilHV;
						swordFlip = 0;
						break;
					case DIR_DOWN:
						swordTile = swordTilHV;
						swordFlip = 2;
						break;
					case DIR_LEFT:
						swordTile = swordTilHV+1;
						swordFlip = 1;
						break;
					case DIR_RIGHT:
						swordTile = swordTilHV+1;
						swordFlip = 0;
						break;
					case DIR_LEFTUP:
						swordTile = swordTilDiag;
						swordFlip = 0;
						break;
					case DIR_RIGHTUP:
						swordTile = swordTilDiag+1;
						swordFlip = 0;
						break;
					case DIR_LEFTDOWN:
						swordTile = swordTilDiag+2;
						swordFlip = 0;
						break;
					case DIR_RIGHTDOWN:
						swordTile = swordTilDiag+3;
						swordFlip = 0;
						break;
				}
				Screen->DrawTile(DirY(swordDir, 1)<0?2:4, swordX, swordY, swordTile, 1, 1, 0, -1, -1, 0, 0, 0, swordFlip, true, 128);
				lweapon l = MakeHitboxLW(LW_PHYSICAL, swordX, swordY, 16, 16, damage, Link->Dir); 
				l->Weapon = LW_SWORD;
				GrabItems(l);
				++swordT;
				if(HasAugment(I_AUGMENT_SPARKINGDASH)){
					if(sparkT%2==0){
						lweapon spark = FireLWeapon(LW_PHYSICAL, l->X+l->HitXOffset, l->Y+l->HitYOffset, Angle(0, 0, vX, vY)+Rand(-40, 40), Rand(150, 200), Ceiling(damage*0.75), 1, SFX_SORENDASHSPARK);
						spark->OriginalTile = 1484;
						spark->Tile = spark->OriginalTile;
						spark->CSet = 0;
						spark->NumFrames = 4;
						spark->ASpeed = 1;
						spark->HitXOffset = 4;
						spark->HitYOffset = 4;
						spark->HitWidth = 8;
						spark->HitHeight = 8;
						RunLWeaponScript(spark, "Timeout", {24});
					}
					++sparkT;
				}
			}
			
			int mult = 1;
			if(vX!=0&&vY!=0)
				mult = 0.7071;
			LinkMovement_Push2(vX*2, vY*2);
			
			NoItem();
			if(i>=16)
				NoAction();
			Waitframe();
		}
		if(!dashInterrupted){
			while(swordT<16&&!G[G_SCREENCHANGED]){
				Link->Dir = Dir;
				G[G_FORCEDIR] = Dir;
				Link->Action = LA_NONE;
				Link->Action = LA_ATTACKING;
				swordAng = Lerp(DirAngle(Link->Dir)-arcDir*90, DirAngle(Link->Dir)+arcDir*90, swordT/16);
				swordDir = AngleDir8(WrapDegrees(swordAng));
				swordX = Link->X+slashOffX[swordDir];
				swordY = Link->Y+slashOffY[swordDir];
				switch(swordDir){
					case DIR_UP:
						swordTile = swordTilHV;
						swordFlip = 0;
						break;
					case DIR_DOWN:
						swordTile = swordTilHV;
						swordFlip = 2;
						break;
					case DIR_LEFT:
						swordTile = swordTilHV+1;
						swordFlip = 1;
						break;
					case DIR_RIGHT:
						swordTile = swordTilHV+1;
						swordFlip = 0;
						break;
					case DIR_LEFTUP:
						swordTile = swordTilDiag;
						swordFlip = 0;
						break;
					case DIR_RIGHTUP:
						swordTile = swordTilDiag+1;
						swordFlip = 0;
						break;
					case DIR_LEFTDOWN:
						swordTile = swordTilDiag+2;
						swordFlip = 0;
						break;
					case DIR_RIGHTDOWN:
						swordTile = swordTilDiag+3;
						swordFlip = 0;
						break;
				}
				Screen->DrawTile(DirY(swordDir, 1)<0?2:4, swordX, swordY, swordTile, 1, 1, 0, -1, -1, 0, 0, 0, swordFlip, true, 128);
				lweapon l = MakeHitboxLW(LW_PHYSICAL, swordX, swordY, 16, 16, damage, Link->Dir); 
				l->Weapon = LW_SWORD;
				GrabItems(l);
				++swordT;
				if(HasAugment(I_AUGMENT_SPARKINGDASH)){
					if(sparkT%2==0){
						lweapon spark = FireLWeapon(LW_PHYSICAL, l->X+l->HitXOffset, l->Y+l->HitYOffset, Angle(0, 0, vX, vY)+Rand(-40, 40), Rand(150, 200), Ceiling(damage*0.75), 1, SFX_SORENDASHSPARK);
						spark->OriginalTile = 1484;
						spark->Tile = spark->OriginalTile;
						spark->CSet = 0;
						spark->NumFrames = 4;
						spark->ASpeed = 1;
						spark->HitXOffset = 4;
						spark->HitYOffset = 4;
						spark->HitWidth = 8;
						spark->HitHeight = 8;
						RunLWeaponScript(spark, "Timeout", {24});
					}
					++sparkT;
				}
				Waitframe();
			}
		}
	}
}

const int DAMAGE_RECKLESSRICOCHET = 800;
const int LWS_RECKLESSRICOCHET = 21;

item script RecklessRicochet{
	void DrawReticle(int x, int y, int angle, int mult){
		mult = 1-mult;
		for(int i=0; i<5; ++i){
			if(i<4){
				Screen->FastTile(4, x, y, 101440+(((G[G_ANIM]%8)<4)?0:1), 8, 128);
			}
			else{
				Screen->FastTile(4, x, y, 101442+(((G[G_ANIM]%8)<4)?0:1), 8, 128);
			}
			x += VectorX(8*mult, angle);
			y += VectorY(8*mult, angle);
		}
	}
	void run(){
		if(Game->Counter[CR_BOMBS]<=0)
			Quit();
		int timer = 120;
		int faceAngle = WrapDegrees(DirAngle(Link->Dir));
		int fuse;
		int drawX;
		int drawY;
		for(fuse=0; fuse<120&&!(fuse>16&&!InputButtonItem(this->ID)); ++fuse){
			if(G[G_SCREENCHANGED])
				Quit();
			
			int vX = (Link->InputLeft?-1:0) + (Link->InputRight?1:0);
			int vY = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
			if(vX!=0||vY!=0){
				faceAngle = WrapDegrees(TurnToAngle(faceAngle, Angle(0, 0, vX, vY), 2));
			}
			int til = 101401;
			if(fuse>90){
				if(G[G_ANIM]%4<2)
					++til;
			}
			
			Link->Dir = AngleDir4(faceAngle);
			DrawReticle(Link->X+DirX(Link->Dir, 8), Link->Y+DirY(Link->Dir, 8), faceAngle, fuse/120);
			
			switch(Link->Dir){
				case DIR_UP:
					drawX = Link->X+11-8;
					drawY = Link->Y+3-10;
					SetLinkScriptTile(101555, 0, 2);
					break;
				case DIR_DOWN:
					drawX = Link->X+3-8;
					drawY = Link->Y+3-10;
					SetLinkScriptTile(101553, 0, 2);
					break;
				case DIR_LEFT:
					drawX = Link->X+10-12;
					drawY = Link->Y+3-8;
					SetLinkScriptTile(101554, 0, 2);
					break;
				case DIR_RIGHT:
					drawX = Link->X+5-4;
					drawY = Link->Y+3-8;
					SetLinkScriptTile(101554, 1, 2);
					break;
			}
			Screen->DrawTile(4, drawX, drawY, til, 1, 1, 11, -1, -1, drawX, drawY, Link->Dir<DIR_LEFT?90:0, 0, true, 128);
			
			Link->Action = LA_NONE;
			Link->Action = LA_ATTACKING;
			Waitframe();
		}
		int bombX = Link->X+DirX(Link->Dir, 8);
		int bombY = Link->Y+DirY(Link->Dir, 8);
		--Game->Counter[CR_BOMBS];
		if(fuse==120){
			RecklessRicochetLW.MakeExplosion(drawX, drawY, DAMAGE_RECKLESSRICOCHET, Link->Dir);
		}
		else{
			fuse = Clamp(Floor((120-fuse)/2), 8, 32);
			lweapon l = CreateLWeaponAt(LW_PHYSICAL, bombX, bombY);
			l->CollDetection = false;
			l->OriginalTile = 101401;
			l->Tile = l->OriginalTile;
			l->CSet = 11;
			l->NumFrames = 2;
			l->ASpeed = 2;
			l->Damage = DAMAGE_RECKLESSRICOCHET;
			RunLWeaponScript(l, "RecklessRicochetLW", {faceAngle, 4, fuse});
			Game->PlaySound(SFX_JUMP);
		}
	}
}

lweapon script RecklessRicochetLW{
	void MakeExplosion(int x, int y, int damage, int dir){
		if(!HasAugment(I_AUGMENT_RESPONSIBLERICOCHET)){
			eweapon e = CreateEWeaponAt(EW_BOMBBLAST, x, y);
			e->Damage = damage/100;
		}
		lweapon l = CreateLWeaponAt(LW_BOMBBLAST, x, y);
		l->Dir = dir;
		l->Damage = damage;
		for(int i=0; i<12; ++i){
			lweapon poof = ParticleAnim(x, y, 364, 11, 6, 2);
			poof->Step = 250;
			poof->Angular = true;
			poof->Angle = DegtoRad(i*30);
		}
		for(int i=0; i<9; ++i){
			lweapon l = CreateLWeaponAt(LW_SCRIPT10, x-16+(i%3)*16, y-16+Floor(i/3)*16);
			l->CollDetection = false;
			l->Script = LWS_ONEFRAME;
			l->Weapon = LW_BOMBBLAST;
			l->DrawYOffset = -1000;
		}
	}
	void run(int angle, int step, int frames){
		int x = this->X;
		int y = this->Y;
		bool bounced;
		for(int i=0; i<frames; ++i){
			x += VectorX(step, angle);
			y += VectorY(step, angle);
			this->X = x;
			this->Y = y;
			if(LobBomb_IsSolid(this, x+8, y+8, true)){
				for(int i=0; i<8&&Screen->isSolid(x+8, y+8); ++i){
					x -= VectorX(1, angle);
					y -= VectorY(1, angle);
				}
				int vX = VectorX(1, angle);
				int vY = VectorY(1, angle);
				if((vY<0&&LobBomb_IsSolid(this, x+8, y+8-1, true))||(vY>0&&LobBomb_IsSolid(this, x+8, y+8+1, true))){
					vY = -vY;
					bounced = true;
					Game->PlaySound(6);
					angle = Angle(0, 0, vX, vY);
				}
				if((vX<0&&LobBomb_IsSolid(this, x+8-1, y+8, true))||(vX>0&&LobBomb_IsSolid(this, x+8+1, y+8, true))){
					vX = -vX;
					bounced = true;
					Game->PlaySound(6);
					angle = Angle(0, 0, vX, vY);
				}
			}
			if(bounced&&LinkCollision(this))
				break;
			this->Dir = AngleDir4(WrapDegrees(angle));
			this->Rotation = WrapDegrees(this->Rotation+30);
			Waitframe();
		}
		MakeExplosion(this->X, this->Y, this->Damage, this->Dir);
		this->DeadState = 0;
	}
}

const int DAMAGE_TERRYSWIPE = 100;

item script JustStraightUpRobbery{
	void run(){
		int angle;
		bool hasRobbed;
		int robbedItem;
		int robbedCount;
		npc robbed;
		lweapon swipehitbox = CreateLWeaponAt(LW_PHYSICAL, Link->X, Link->Y);
		swipehitbox->Damage = DAMAGE_TERRYSWIPE;
		swipehitbox->Dir = Link->Dir;
		swipehitbox->UseSprite(SPRITE_INVISIBLE);
		
		int robbedList[512];
		npc robbedListN[512];
		int robbedListLength;
		Game->PlaySound(SFX_SWORD);
		for(int i=0; i<9; ++i){
			if(G[G_SCREENCHANGED])
				Quit();
			angle = Lerp(DirAngle(Link->Dir)-45, DirAngle(Link->Dir)+90, i/8);
			int swipeX = Link->X+VectorX(10, angle);
			int swipeY = Link->Y+VectorY(10, angle);
			Screen->DrawTile(VectorY(1, angle)<0?2:4, swipeX, swipeY, 101460, 1, 1, 11, -1, -1, swipeX, swipeY, angle+90, 0, true, 128);
			swipehitbox->X = swipeX;
			swipehitbox->Y = swipeY;
			swipehitbox->DeadState = WDS_ALIVE;
			if(swipehitbox->Misc[LWM_HITBY]){
				npc hit = Screen->LoadNPCByUID(swipehitbox->Misc[LWM_HITBY]);
				if(hit->Misc[NPCM_STUNCOOLDOWN]<=0)
					hit->Stun = Max(20, hit->Stun);
				if(!(hit->Misc[NPCM_FLAGS]&NPCMF_HASROBBED)){
					int type = FishingRod.CanStun(hit);
					if(HasAugment(I_AUGMENT_DIREDROPS)&&type>100){
						if(Game->Counter[CR_SOLARBATTERY]<10)
							type = 2;
						else if(Game->Counter[CR_LUNARBATTERY]<10)
							type = 3;
						else if(Game->Counter[CR_STELLARBATTERY]<10)
							type = 4;
					}
					if(type==2){
						//hasRobbed = true;
						// robbedItem = 173;
						// robbedCount = 3;
						// robbed = hit;
						hasRobbed = true;
						for(int i=0; i<3; ++i){
							robbedList[robbedListLength] = 173;
							robbedListN[robbedListLength] = hit;
							++robbedListLength;
						}
						hit->Misc[NPCM_FLAGS] |= NPCMF_HASROBBED;
					}
					else if(type==3){
						//hasRobbed = true;
						// robbedItem = 174;
						// robbedCount = 3;
						// robbed = hit;
						hasRobbed = true;
						for(int i=0; i<3; ++i){
							robbedList[robbedListLength] = 174;
							robbedListN[robbedListLength] = hit;
							++robbedListLength;
						}
						hit->Misc[NPCM_FLAGS] |= NPCMF_HASROBBED;
					}
					else if(type==4){
						//hasRobbed = true;
						// robbedItem = 175;
						// robbedCount = 3;
						// robbed = hit;
						hasRobbed = true;
						for(int i=0; i<3; ++i){
							robbedList[robbedListLength] = 175;
							robbedListN[robbedListLength] = hit;
							++robbedListLength;
						}
						hit->Misc[NPCM_FLAGS] |= NPCMF_HASROBBED;
					}
					else if(type>100){
						// hasRobbed = true;
						// robbedItem = FishingRod.GetItemFromDropset(type-100);
						// robbedCount = 1;
						// robbed = hit;
						hasRobbed = true;
						robbedList[robbedListLength] = FishingRod.GetItemFromDropset(type-100);
						robbedListN[robbedListLength] = hit;
						++robbedListLength;
						hit->Misc[NPCM_FLAGS] |= NPCMF_HASROBBED;
					}
				}
			}
			Link->Action = LA_NONE;
			Link->Action = LA_ATTACKING;
			G[G_NOACTION] = 1;
			Waitframe();
		}
		if(swipehitbox->isValid())
			swipehitbox->DeadState = 0;
		if(hasRobbed){
			for(int i=0; i<robbedListLength; ++i){
				if(robbedListN[i]->isValid()){
					robbedListN[i]->Stun = Max(120, robbedListN[i]->Stun);
					robbedListN[i]->Misc[NPCM_FLAGS] |= NPCMF_HASROBBED;
				}
			}
			for(int i=0; i<2; ++i){
				for(int j=0; j<4; ++j){
					if(G[G_SCREENCHANGED])
						Quit();
					Screen->FastTile(4, Link->X+13-7, Link->Y+8-10, 101595, 8, 128);
					SetLinkScriptTile(101593, 0, 2);
					G[G_NOACTION] = 1;
					Waitframe();
				}
				for(int j=0; j<24; ++j){
					if(G[G_SCREENCHANGED])
						Quit();
					Screen->FastTile(4, Link->X+13-7, Link->Y+8-10-16*Sin(j*(180/24)), 101595+(Sin(j*(180/24))>0.5?1:0), 8, 128);
					SetLinkScriptTile(101593+(j<16?1:0), 0, 2);
					G[G_NOACTION] = 1;
					Waitframe();
				}
			}
			for(int j=0; j<32; ++j){
				if(G[G_SCREENCHANGED])
					Quit();
				Screen->FastTile(4, Link->X+13-7, Link->Y+8-10, 101595, 8, 128);
				SetLinkScriptTile(101593, 0, 2);
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(int i=0; i<robbedListLength; ++i){
				itemsprite itm = CreateItemAt(robbedList[i], Link->X, Link->Y-32);
				itm->MoveFlags[WPNMV_CAN_PITFALL] = false;
				itm->Script = Game->GetItemSpriteScript("FallOntoLink");
				for(int j=0; j<8; ++j){
					if(G[G_SCREENCHANGED])
						Quit();
					Waitframe();
				}
			}
		}
		else{
			Link->Action = LA_NONE;
			WaitNoAction(16);
		}
	}
}

itemsprite script FallOntoLink{
	void run(){
		switch(this->ID){
			case I_HEART:
				this->OriginalTile = 63770;
				this->Tile = this->OriginalTile;
				break;
			case 78...79: //Bombs
				this->OriginalTile = this->ID==78?64071:64073;
				this->Tile = this->OriginalTile;
				break;
		}
		int y = 32;
		for(int i=0; i<16; ++i){
			this->X = Link->X;
			this->Y = Link->Y-y;
			Waitframe();
		}
		while(y>0){
			y -= 2;
			this->X = Link->X;
			this->Y = Link->Y-y;
			Waitframe();
		}
		while(true){
			this->X = Link->X;
			this->Y = Link->Y;
			Waitframe();
		}
	}
}

const int DAMAGE_HEATWAVE = 350;

item script Heatwave{
	void run(){
		int mpCost = 16;
		if(Game->Counter[CR_MAGIC]<=0){
			Quit();
		}
		Game->Counter[CR_MAGIC] = Max(Game->Counter[CR_MAGIC]-16, 0);
		Game->PlaySound(SFX_WAND);
		
		int dir = Link->Dir;
		if(HasAugment(I_AUGMENT_DIAGONALHEAT)){
			int vX = (G[G_LEFTINPUT]?-1:0) + (G[G_RIGHTINPUT]?1:0);
			int vY = (G[G_UPINPUT]?-1:0) + (G[G_DOWNINPUT]?1:0);
			if(vX!=0||vY!=0){
				dir = AngleDir8(Angle(0, 0, vX, vY));
			}
		}
			
		for(int i=0; i<2; ++i){
			lweapon beam = CreateLWeaponAt(LW_SOLAR, Link->X+DirX(dir, 8), Link->Y+DirY(dir, 8));
			beam->UseSprite(89);
			beam->Dir = dir;
			beam->Step = 400;
			beam->Damage = DAMAGE_HEATWAVE;
			beam->Rotation = DirAngle(beam->Dir);
			beam->HitXOffset = 4;
			beam->HitYOffset = 4;
			beam->HitWidth = 8;
			beam->HitHeight = 8;
			RunLWeaponScript(beam, "HeatwaveLW", {0});
			if(i==0&&HasAugment(I_AUGMENT_UPDRAFT)){
				lweapon updraft = CreateLWeaponAt(LW_SCRIPT10, 120, 80);
				updraft->DrawYOffset = -1000;
				updraft->CollDetection = false;
				RunLWeaponScript(updraft, "HeatwaveUpdraftLW", {beam->UID, beam->X, beam->Y});
			}
			for(int j=0; j<4; ++j){
				Link->Action = LA_NONE;
				Link->Action = LA_ATTACKING;
				G[G_NOACTION] = 1;
				Waitframe();
			}
		}
		for(int j=0; j<8; ++j){
			Link->Action = LA_NONE;
			Link->Action = LA_ATTACKING;
			G[G_NOACTION] = 1;
			Waitframe();
		}
		Link->Action = LA_NONE;
	}
}

lweapon script HeatwaveLW{
	void run(int type, untyped d1){
		if(type==0){ //Projectile
			while(true){
				if(this->Misc[LWM_HITBY]){
					npc hit = Screen->LoadNPCByUID(this->Misc[LWM_HITBY]);
					if(hit->isValid()){
						if(hit->Misc[NPCM_FLAGS]&NPCMF_SIYEDMARKED){
							hit->Misc[NPCM_FLAGS] &= ~NPCMF_SIYEDMARKED;
							lweapon controller = CreateLWeaponAt(LW_SCRIPT10, HitboxCenterX(hit)-8, HitboxCenterY(hit)-8);
							controller->UseSprite(SPRITE_INVISIBLE);
							controller->CollDetection = false;
							RunLWeaponScript(controller, "HeatwaveLW", {1, hit->UID});
						}
					}
				}
				Waitframe();
			}
		}
		else if(type==1){ //Controller
			npc parent = Screen->LoadNPCByUID(d1);
			Game->PlaySound(79);
			lweapon orbit[8];
			int orbitAngle = Rand(360);
			for(int i=0; i<8; ++i){
				orbit[i] = CreateLWeaponAt(LW_SOLAR, this->X, this->Y);
				orbit[i]->UseSprite(89);
				orbit[i]->Angular = true;
				orbit[i]->Damage = DAMAGE_HEATWAVE;
				orbit[i]->HitXOffset = 4;
				orbit[i]->HitYOffset = 4;
				orbit[i]->HitWidth = 8;
				orbit[i]->HitHeight = 8;
				RunLWeaponScript(orbit[i], "HeatwaveLW", {0});
			}
			for(int j=0; j<180; ++j){
				if(j<8){
					if(j<4)
						Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
					else
						Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
				}
				if(parent->isValid()){
					this->X = Clamp(HitboxCenterX(parent)-8, 4, 236);
					this->Y = Clamp(HitboxCenterY(parent)-8, 4, 156);
				}
				orbitAngle = WrapDegrees(orbitAngle+10);
				int orbitDist = 20;
				if(j>170){
					orbitDist = Lerp(20, 10, (j-170)/9);
				}
				for(int i=0; i<8; ++i){
					if(orbit[i]->isValid()){
						orbit[i]->X = this->X+VectorX(orbitDist, orbitAngle+45*i);
						orbit[i]->Y = this->Y+VectorY(orbitDist, orbitAngle+45*i);
						orbit[i]->Angle = DegtoRad(orbitAngle+45*i+90);
						orbit[i]->Rotation = orbitAngle+45*i+90;
						orbit[i]->DeadState = WDS_ALIVE;
					}
				}
				Waitframe();
			}
			for(int i=0; i<8; ++i){
				orbit[i]->Step = 400;
			}
			this->DeadState = 0;
		}
		else if(type==2){ //Reticle
			npc target = Screen->LoadNPCByUID(d1);
			if(target->isValid()){
				for(int i=0; i<16&&target->isValid(); ++i){
					int w = Lerp(64, 16, i/15);
					Screen->DrawTile(6, HitboxCenterX(target)-w/2, HitboxCenterY(target)-w/2, 101451, 1, 1, 8, w, w, 0, 0, 0, 0, true, i<4?64:128);
					Waitframe();
				}
				if(target->isValid())
					Game->PlaySound(135);
				for(int i=0; i<8; ++i){
					Screen->FastTile(6, HitboxCenterX(target)-8, HitboxCenterY(target)-8, 101451+(G[G_ANIM]%4<2?0:1), 8, 128);
					Waitframe();
				}
			}
			this->DeadState = 0;
		}
	}
}

lweapon script HeatwaveUpdraftLW{
	bool Draw(bitmap b, bitmap b2, int startX, int startY, int endX, int endY, int startLength){
		startY -= 2;
		endY -= 2;
		
		b->Clear(0);
		b2->Clear(0);
			
		int length = Distance(startX, startY, endX, endY);
		int angle = Round(Angle(startX, startY, endX, endY));
			
		for(int i=0; i<16; ++i){
			b->FastTile(0, 16*i, 0, 8320+(G[G_ANIM]%4), 0, 128);
		}
		b->FastTile(0, startLength-8, 0, 8340, 0, 128);
		b->FastTile(0, length-8, 0, 8341, 0, 128);
		if(length>0)
			b->Rectangle(0, length, 0, 256, 15, 0x00, 1, 0, 0, 0, true, 128);
		if(startLength>0)
			b->Rectangle(0, 0, 0, startLength, 15, 0x00, 1, 0, 0, 0, true, 128);
		b->ReplaceColors(0, 0x00, 0x02, 0x02);
		
		int x = startX+8-128+VectorX(128, angle);
		int y = startY+VectorY(128, angle);
		b->Blit(0, b2, 0, 0, 256, 16, x, y, 256, 16, angle, 0, 0, 0, 0, true);
		b2->Blit(2, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
	
		return RotRectCollision((startX+endX)/2+8, (startY+endY)/2+8, length+16, 16, angle, Link->X+8, Link->Y+8, 16, 16, 0, false);
	}
	void run(untyped parentuid, int startX, int startY){
		lweapon parent = Screen->LoadLWeaponByUID(parentuid);
		
		bitmap b = Game->CreateBitmap(256, 16);
		b->Own();
		bitmap b2 = Game->CreateBitmap(256, 176);
		b2->Own();
		
		int parentX = parent->X; int parentY = parent->Y;
		while(parent->isValid()){
			parentX = parent->X;
			parentY = parent->Y;
			
			if(Draw(b, b2, startX, startY, parent->X, parent->Y, 0))
				G[G_SIYEDUPDRAFT] = 1;
			
			Waitframe();
		}
		for(int i=0; i<128; ++i){
			if(Draw(b, b2, startX, startY, parentX, parentY, 0))
				G[G_SIYEDUPDRAFT] = 1;
			
			Waitframe();
		}
		int length = Distance(startX, startY, parentX, parentY);
		int startLength = 0;
		while(startLength<length){
			startLength = Min(startLength+4, length);
			
			if(Draw(b, b2, startX, startY, parentX, parentY, startLength)){
				G[G_SIYEDUPDRAFT] = 1;
			}
			
			Waitframe();
		}
	}
}

item script SiyedConcentration{
	void run(){
		if(Link->MP<=0)
			Quit();
		int mpCost = 40;
		int dir = Link->Dir;
		int angle = DirAngle(dir);
		for(int i=0; i<16; ++i){
			if(G[G_SCREENCHANGED])
				Quit();
			SetLinkScriptTile(101633, 0, 2);
			G[G_NOACTION] = 1;
			Waitframe();
		}
		Game->PlaySound(78);
		Link->MP -= mpCost;
		for(int i=0; i<32; ++i){
			if(G[G_SCREENCHANGED])
				Quit();
			SetLinkScriptTile(101633, 0, 2);
			for(int j=0; j<3; ++j){
				Screen->Ellipse(6, Link->X+8, Link->Y, i*8+j, i*6+j, Choose(0x81, 0x86, 0x87, 0x88), 1, 0, 0, 0, false, 128);
			}
			G[G_NOACTION] = 1;
			Waitframe();
		}
		for(int i=0; i<16; ++i){
			if(G[G_SCREENCHANGED])
				Quit();
			if(HasAugment(I_AUGMENT_CONCENTRATION))
				angle = TurnToAngle(angle, DirAngle(Link->Dir), 5);
			for(int j=0; j<3; ++j){
				Screen->Circle(6, Link->X+8+VectorX(80, angle), Link->Y+8+VectorY(80, angle), Lerp(256, 32, i/15)+j, Choose(0x81, 0x86, 0x87, 0x88), 1, 0, 0, 0, false, 128);
			}
			Waitframe();
		}
		for(int i=0; i<200; ++i){
			while(Link->Action==LA_SCROLLING)Waitframe();
			int rad = Lerp(32, 4, i/199);
			if(HasAugment(I_AUGMENT_CONCENTRATION))
				angle = TurnToAngle(angle, DirAngle(Link->Dir), 5);
			int posX = Link->X+8+VectorX(Lerp(80, 24, i/199), angle); //DirX(dir, Lerp(80, 24, i/199));
			int posY = Link->Y+8+VectorY(Lerp(80, 24, i/199), angle); //DirY(dir, Lerp(80, 24, i/199));
			if(i%4<2)
				Screen->Circle(6, posX, posY, rad, 0x01, 1, 0, 0, 0, true, 64);
			for(int j=Screen->NumNPCs(); j>0; --j){
				npc n = Screen->LoadNPC(j);
				if(n->Defense[NPCD_SOLAR]!=NPCDT_BLOCK&&n->Defense[NPCD_SOLAR]!=NPCDT_IGNORE&&n->Defense[NPCD_SOLAR]!=NPCDT_HEAL){
					if(!StellarBatteryException(n)&&!(n->Misc[NPCM_FLAGS]&NPCMF_SIYEDMARKED)){
						if(Distance(HitboxCenterX(n), HitboxCenterY(n), posX, posY)<rad+8){
							n->Misc[NPCM_FLAGS] |= NPCMF_SIYEDMARKED;
							lweapon marker = CreateLWeaponAt(LW_SCRIPT10, HitboxCenterX(n)-8, HitboxCenterY(n)-8);
							marker->UseSprite(SPRITE_INVISIBLE);
							marker->CollDetection = false;
							RunLWeaponScript(marker, "HeatwaveLW", {2, n->UID});
						}
					}
				}
			}
			Waitframe();
		}
	}
}

itemdata script CharacterSpecificHC{
	void run(int whichChar){
		switch(whichChar){
			case CHAR_ASHER:
				G[G_ASHERMAXHP] += 16;
				G[G_ASHERHP] += 16;
				break;
			case CHAR_TORRIN:
				G[G_TORRINMAXHP] += 16;
				G[G_TORRINHP] += 16;
				break;
			case CHAR_KAYLANI:
				G[G_KAYLANIMAXHP] += 16;
				G[G_KAYLANIHP] += 16;
				break;
			case CHAR_SOREN:
				G[G_SORENMAXHP] += 16;
				G[G_SORENHP] += 16;
				break;
			case CHAR_TERRY:
				G[G_TERRYMAXHP] += 16;
				G[G_TERRYHP] += 16;
				break;
			case CHAR_SIYED:
				G[G_SIYEDMAXHP] += 16;
				G[G_SIYEDHP] += 16;
				break;
		}
		if(GetCharID()==whichChar){
			Link->MaxHP += 16;
			Link->HP += 16;
		}
		eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
		e->CollDetection = false;
		e->DrawYOffset = -1000;
		RunEWeaponScript(e, "ItemPopup", {this->ID});
	}
}

itemdata script AugmentSlotUpgrade{
	void run(int whichChar){
		switch(whichChar){
			case CHAR_ASHER:
				++Game->Counter[CR_ASHERAUGMENTSLOTS];
				break;
			case CHAR_TORRIN:
				++Game->Counter[CR_TORRINAUGMENTSLOTS];
				break;
			case CHAR_KAYLANI:
				++Game->Counter[CR_KAYLANIAUGMENTSLOTS];
				break;
			case CHAR_SOREN:
				++Game->Counter[CR_SORENAUGMENTSLOTS];
				break;
			case CHAR_TERRY:
				++Game->Counter[CR_TERRYAUGMENTSLOTS];
				break;
			case CHAR_SIYED:
				++Game->Counter[CR_SIYEDAUGMENTSLOTS];
				break;
		}
		
		eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
		e->CollDetection = false;
		e->DrawYOffset = -1000;
		RunEWeaponScript(e, "ItemPopup", {this->ID});
	}
}

itemsprite script DrawOver{
	void run(int offX, int offY){
		while(true){
			Screen->DrawTile(6, this->X+offX, this->Y+offY, this->Tile, this->TileWidth, this->TileHeight, this->CSet, -1, -1, 0, 0, 0, 0, true, 128);
			Waitframe();
		}
	}
}

const int DAMAGE_UNSTABLEORBIT = 350;

itemdata script SiyedWilyShot{
	void DrawCharge(int i, int max, int chargeTimes){
		int c1 = Choose(0x86, 0x87, 0x88);
		int c2 = c1+1;
		if(c2>0x88)
			c2 = 0x86;
		GBMP[BMP_PLAYEREFFECTS]->Clear(0);
		GBMP[BMP_PLAYEREFFECTS]->DrawTile(0, 0, 0, Link->Tile-20, 1, 2, 6, -1, -1, 0, 0, 0, Link->Flip, true, 128);
		GBMP[BMP_PLAYEREFFECTS]->ReplaceColors(0, c1, 1, 255);
		int intensity = 0;
		if(i>chargeTimes[0])
			intensity = 1;
		if(i>chargeTimes[1])
			intensity = 2;
		if(i>chargeTimes[2])
			intensity = 3;
		Screen->Circle(2, Link->X+8+Rand(-intensity, intensity), Link->Y+Link->DrawYOffset+4+Rand(-intensity, intensity), 16*(i/max), c2, 1, 0, 0, 0, true, 128);
		Screen->Circle(2, Link->X+8+Rand(-intensity, intensity), Link->Y+Link->DrawYOffset+4+Rand(-intensity, intensity), 16*(i/max), c2, 1, 0, 0, 0, true, 128);
		GBMP[BMP_PLAYEREFFECTS]->Blit(2, RT_SCREEN, 0, 0, 16, 32, Link->X+Rand(-intensity, intensity), Link->Y+Link->DrawYOffset-16+Rand(-intensity, intensity), 16, 32, 0, 0, 0, 0, 0, true);
		GBMP[BMP_PLAYEREFFECTS]->Blit(2, RT_SCREEN, 0, 0, 16, 32, Link->X+Rand(-intensity, intensity), Link->Y+Link->DrawYOffset-16+Rand(-intensity, intensity), 16, 32, 0, 0, 0, 0, 0, true);
	}
	void run(){
		int chargeTimes[4] = {64, 96, 112, 128};
		if(HasAugment(I_AUGMENT_CHARGE)){
			chargeTimes[0] = 32;
			chargeTimes[1] = 64;
			chargeTimes[2] = 80;
			chargeTimes[3] = 96;
		}
		if(Link->MP<=0)
			Quit();
		int i;
		for(i=0; i<45; ++i){
			if(G[G_SCREENCHANGED])
				Quit();
			DrawCharge(i, 45, chargeTimes);
			Waitframe();
		}
		int damage = DAMAGE_UNSTABLEORBIT;
		int level = 1;
		if(HasAugment(I_AUGMENT_UNSTABLEORBIT))
			level = 2;
		for(; i>0; i-=8){
			if(G[G_SCREENCHANGED])
				Quit();
			DrawCharge(i, 45, chargeTimes);
			Waitframe();
		}
		int distMult = 1;
		// if(HasAugment(I_AUGMENT_RANGE))
			// distMult = 1.5;
		
		int numOrbs = 2;
		int orbDist = 16*distMult;
		int orbSpeed = 6;
		int duration = 60;
		int mpcost = 32;
		if(level==2){
			numOrbs = 4;
			orbDist = 24*distMult;
			orbSpeed = 6;
			duration = 60;
			mpcost = 40;
		}
		lweapon orbs[4];
		int rotAngle = DirAngle(Link->Dir);
		Link->MP = Max(Link->MP-mpcost, 0);
		for(int i=0; i<numOrbs; ++i){
			orbs[i] = FireLWeapon(LW_SOLAR, Link->X, Link->Y, WrapDegrees(rotAngle+(360/numOrbs)*i), 0, damage, SPR_FRIENDBALL, 0);
			orbs[i]->Script = LWS_TIMEOUT;
			orbs[i]->InitD[0] = 2;
		}
		Game->PlaySound(SFX_FRIENDBALLFIRE);
		int accelmult = 1;
		bool maxed;
		int orbX;
		int orbY;
		for(int j=0; j<duration; ++j){
			// if(Link->Action==LA_WALKING)
				// accelmult = Min(accelmult+0.05, 2);
			// else
				accelmult = Max(accelmult-0.1, 1);
			rotAngle = WrapDegrees(rotAngle+orbSpeed*accelmult);
			if(G[G_SCREENCHANGED])
				Quit();
			for(int i=0; i<numOrbs; ++i){
				orbX = Link->X+VectorX(orbDist*Sin(j*(180/duration)), rotAngle+(360/numOrbs)*i);
				orbY = Link->Y+VectorY(orbDist*Sin(j*(180/duration)), rotAngle+(360/numOrbs)*i);
				if(maxed){
					orbX = Link->X+VectorX(orbDist, rotAngle+(360/numOrbs)*i);
					orbY = Link->Y+VectorY(orbDist, rotAngle+(360/numOrbs)*i);
				}
				if(Sin(j*(180/duration)) == 1)
					maxed = true;
				if(G[G_ANIM]%5==0)
					ParticleAnim(orbX+Rand(-4, 4), orbY+Rand(-4, 4), 65242, 0, 4, 0);
				if(orbs[i]->isValid()){
					orbs[i]->X = orbX;
					orbs[i]->Y = orbY;
					orbs[i]->DeadState = WDS_ALIVE;
					orbs[i]->Dir = AngleDir4(WrapDegrees(rotAngle+(360/numOrbs)*i));
					orbs[i]->InitD[0] = 2;
				}
				else{
					orbs[i] = FireLWeapon(LW_SOLAR, orbX, orbY, WrapDegrees(DirAngle(Link->Dir)+(360/numOrbs)*i), 0, damage, SPR_FRIENDBALL, 0);
					orbs[i]->Script = LWS_TIMEOUT;
					orbs[i]->InitD[0] = 2;
				}
				DarkRoom_AddLight(orbX+8, orbY+8, 0, 24, 1, 0, 0, 0);
			}
			Waitframe();
		}
		int cenX = Link->X;
		int cenY = Link->Y;
		for(int j = 0; j<30; ++j){
			for(int i=0; i<numOrbs; ++i){
				orbX = cenX+VectorX(orbDist, rotAngle+(360/numOrbs)*i);
				orbY = cenY+VectorY(orbDist, rotAngle+(360/numOrbs)*i);
				if(orbs[i]->isValid()){
					orbs[i]->X = orbX;
					orbs[i]->Y = orbY;
					orbs[i]->DeadState = WDS_ALIVE;
					orbs[i]->Dir = AngleDir4(WrapDegrees(rotAngle+(360/numOrbs)*i));
					orbs[i]->InitD[0] = 2;
				}
				else{
					orbs[i] = FireLWeapon(LW_SOLAR, orbX, orbY, WrapDegrees(DirAngle(Link->Dir)+(360/numOrbs)*i), 0, damage, SPR_FRIENDBALL, 0);
					orbs[i]->Script = LWS_TIMEOUT;
					orbs[i]->InitD[0] = 2;
				}
				DarkRoom_AddLight(orbX+8, orbY+8, 0, 24, 1, 0, 0, 0);
			}
			Waitframe();
		}
		npc marked[10];
		int index;
		for(int i = Screen->NumNPCs(); i>0; i--){
			npc n = Screen->LoadNPC(i);
			//Trace(n->Misc[NPCM_FLAGS]);
			if(n->Misc[NPCM_FLAGS] & NPCMF_SIYEDMARKED){
				marked[index] = n;
				index++;
			}
		}
		//Trace(index);
		if(index == 0){
			for(int i=0; i<numOrbs; ++i){
				orbX = cenX+VectorX(orbDist, rotAngle+(360/numOrbs)*i);
				orbY = cenY+VectorY(orbDist, rotAngle+(360/numOrbs)*i);
				if(orbs[i]->isValid()){
					orbs[i]->X = orbX;
					orbs[i]->Y = orbY;
					orbs[i]->DeadState = WDS_ALIVE;
					orbs[i]->Angle = DegtoRad(Angle(cenX, cenY, orbs[i]->X, orbs[i]->Y));
					orbs[i]->Step = 400;
					orbs[i]->Script = 0;
					// orbs[i]->InitD[0] = 2;
				}
				else{
					orbs[i] = FireLWeapon(LW_SOLAR, orbX, orbY, DegtoRad(Angle(cenX, cenY, orbs[i]->X, orbs[i]->Y)), 200, damage, SPR_FRIENDBALL, 0);
					// orbs[i]->Script = LWS_TIMEOUT;
					// orbs[i]->InitD[0] = 2;
				}
			}
		}
		else{
			for(int i=0; i<numOrbs; ++i){
				npc n = marked[Rand(0, index-1)];
				orbX = cenX+VectorX(orbDist, rotAngle+(360/numOrbs)*i);
				orbY = cenY+VectorY(orbDist, rotAngle+(360/numOrbs)*i);
				if(orbs[i]->isValid()){
					orbs[i]->X = orbX;
					orbs[i]->Y = orbY;
					orbs[i]->DeadState = WDS_ALIVE;
					orbs[i]->Angle = DegtoRad(Angle(orbs[i]->X, orbs[i]->Y, n->X, n->Y));
					orbs[i]->Step = 400;
					orbs[i]->Script = 0;
					// orbs[i]->InitD[0] = 2;
				}
				else{
					orbs[i] = FireLWeapon(LW_SOLAR, orbX, orbY, DegtoRad(Angle(orbs[i]->X, orbs[i]->Y, n->X, n->Y)), 200, damage, SPR_FRIENDBALL, 0);
					// orbs[i]->Script = LWS_TIMEOUT;
					// orbs[i]->InitD[0] = 2;
				}
			}
		}
	}
}

const int SFX_GRAPPLETHROW = 168;
const int SFX_GRAPPLEROPE = 169;
const int SFX_GRAPPLEPULL = 170;

itemdata script GrapplingHook{
	void run(){
		int endX = Link->X;
		int endY = Link->Y;
		int inputX = (Link->InputLeft?-1:0) + (Link->InputRight?1:0);
		int inputY = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
		int angle = DirAngle(Link->Dir);
		if(inputX!=0||inputY!=0){
			angle = Angle(0, 0, inputX, inputY);
		}
		int t[1]; 
		int amp = 0;
		int period = 1080;
		
		npc targetNPC;
		ffc targetFFC;
		int grabType = 0;
		
		Game->PlaySound(SFX_GRAPPLETHROW);
		for(int i=0; i<32; ++i){
			if(!CanHook())
				Quit();
			amp = Lerp(0, 8, i/31);
			period = Lerp(1080, 360, i/31);
			endX += VectorX(4, angle);
			endY += VectorY(4, angle);
			if(Screen->isSolid(endX+8, endY+8)){
				int whichFFC = CheckStarBlockCollision(endX+8, endY+8);
				grabType = 1; //Solids
				if(whichFFC>0){
					targetFFC = Screen->LoadFFC(whichFFC);
					grabType = 3; //Block
				}
				break;
			}
			for(int i=Screen->NumNPCs(); i>0; --i){
				npc n = Screen->LoadNPC(i);
				if(n->Defense[NPCD_SWORD]!=NPCDT_BLOCK&&n->Defense[NPCD_SWORD]!=NPCDT_IGNORE){
					int canStun = CanStun(n);
					if(canStun==1||canStun==2){
						if(RectCollision(n, endX, endY, 16, 16)){
							targetNPC = n;
							grabType = 2; //Enemy
							Game->PlaySound(SFX_EHIT);
							break;
						}
					}
				}
			}
			if(grabType==2) //Grabbed an enemy, break out
				break;
			DrawGrapple(2, Link->X, Link->Y, endX, endY, amp, period, 10, t);
			Waitframe();
		}
		switch(grabType){
			case 0: //None
				while(Distance(endX, endY, Link->X, Link->Y)>4){
					if(!CanHook())
						Quit();
					if(amp>0)
						--amp;
					int retAngle = Angle(endX, endY, Link->X, Link->Y);
					endX += VectorX(4, retAngle);
					endY += VectorY(4, retAngle);
					DrawGrapple(2, Link->X, Link->Y, endX, endY, amp, period, 10, t);
					Waitframe();
				}
				break;
			case 1: //Wall grab
				Game->PlaySound(SFX_GRAPPLEPULL);
				for(int i=0; i<32; ++i){
					if(!CanHook())
						Quit();
					if(Distance(endX, endY, Link->X, Link->Y)<=10)
						break;
					amp = 12;
					period = 720;
					int pullAngle = Angle(Link->X, Link->Y, endX, endY);
					int pullSpeed = Lerp(4, 0, i/31);
					LinkMovement_Push2(VectorX(pullSpeed, pullAngle), VectorY(pullSpeed, pullAngle));
					SetLinkPitImmune(2);
					DrawGrapple(2, Link->X, Link->Y, endX, endY, amp, period, 20, t);
					Waitframe();
				}
				amp = 8;
				int pitframes = 4;
				while(Distance(endX, endY, Link->X, Link->Y)>4){
					if(!CanHook())
						Quit();
					if(pitframes){
						--pitframes;
						SetLinkPitImmune(2);
					}
					if(amp>0)
						--amp;
					int retAngle = Angle(endX, endY, Link->X, Link->Y);
					endX += VectorX(4, retAngle);
					endY += VectorY(4, retAngle);
					DrawGrapple(2, Link->X, Link->Y, endX, endY, amp, period, 10, t);
					Waitframe();
				}
				break;
			case 2: //Enemy grab
				int canStun = CanStun(targetNPC);
				if(canStun==1){ //Pull enemy to Link
					endX = HitboxCenterX(targetNPC)-8;
					endY = HitboxCenterY(targetNPC)-8;
					
					int nX = targetNPC->X;
					int nY = targetNPC->Y;
					int nOffX = nX-endX;
					int nOffY = nY-endY;
					Game->PlaySound(SFX_GRAPPLEPULL);
					while(Distance(endX, endY, Link->X, Link->Y)>16){
						if(!CanHook())
							Quit();
						if(!targetNPC->isValid())
							break;
						targetNPC->Stun = Max(targetNPC->Stun, 60);
						if(HasAugment(I_AUGMENT_CRITICALGRAPPLE))
							targetNPC->Misc[NPCM_DAMAGEBONUSFRAMES] = 20;
						if(amp<8)
							++amp;
						int retAngle = Angle(endX, endY, Link->X, Link->Y);
						nX += VectorX(4, retAngle);
						nY += VectorY(4, retAngle);
						SetEnemyProperty(targetNPC, ENPROP_X, nX+nOffX);
						SetEnemyProperty(targetNPC, ENPROP_Y, nY+nOffY);
						endX = HitboxCenterX(targetNPC)-8;
						endY = HitboxCenterY(targetNPC)-8;
						DrawGrapple(2, Link->X, Link->Y, endX, endY, amp, period, 20, t);
						Waitframe();
					}
				}
				else{ //Pull Link to enemy
					endX = HitboxCenterX(targetNPC)-8;
					endY = HitboxCenterY(targetNPC)-8;
					
					Game->PlaySound(SFX_GRAPPLEPULL);
					for(int i=0; i<60&&Distance(endX, endY, Link->X, Link->Y)>16; ++i){
						if(!CanHook())
							Quit();
						if(!targetNPC->isValid())
							break;
						targetNPC->Stun = Max(targetNPC->Stun, 60);
						if(HasAugment(I_AUGMENT_CRITICALGRAPPLE))
							targetNPC->Misc[NPCM_DAMAGEBONUSFRAMES] = 20;
						if(amp<8)
							++amp;
						int pullAngle = Angle(Link->X, Link->Y, endX, endY);
						int pullSpeed = Lerp(4, 2, i/59);
						LinkMovement_Push2(VectorX(pullSpeed, pullAngle), VectorY(pullSpeed, pullAngle));
						DrawGrapple(2, Link->X, Link->Y, endX, endY, amp, period, 20, t);
						Waitframe();
					}
				}
				while(Distance(endX, endY, Link->X, Link->Y)>4){
					if(!CanHook())
						Quit();
					if(amp>0)
						--amp;
					int retAngle = Angle(endX, endY, Link->X, Link->Y);
					endX += VectorX(4, retAngle);
					endY += VectorY(4, retAngle);
					DrawGrapple(2, Link->X, Link->Y, endX, endY, amp, period, 10, t);
					Waitframe();
				}
				break;
			case 3: //Block grab
				Game->PlaySound(SFX_GRAPPLEROPE);
				for(int i=0; i<32; ++i){
					if(!CanHook())
						Quit();
					if(Distance(endX, endY, Link->X, Link->Y)<=10)
						break;
					if(amp>0)
						--amp;
					period = 720;
					int pullAngle = Angle(Link->X, Link->Y, endX, endY);
					int pullSpeed = Lerp(4, 0, i/31);
					SetLinkPitImmune(2);
					DrawGrapple(2, Link->X, Link->Y, endX, endY, amp, period, 20, t);
					Waitframe();
				}
				Game->PlaySound(SFX_GRAPPLEPULL);
				targetFFC->InitD[2] = AngleDir4(Angle(CenterX(targetFFC), CenterY(targetFFC), Link->X+8, Link->Y+8));
				while(Distance(endX, endY, Link->X, Link->Y)>4){
					if(!CanHook())
						Quit();
					if(amp<8)
						++amp;
					int retAngle = Angle(endX, endY, Link->X, Link->Y);
					endX += VectorX(4, retAngle);
					endY += VectorY(4, retAngle);
					DrawGrapple(2, Link->X, Link->Y, endX, endY, amp, period, 20, t);
					Waitframe();
				}
				break;
		}
		// while(true){
			// if(G[G_SCREENCHANGED])
				// Quit();
			// if(amp>0)
				// --amp;
			// DrawGrapple(2, Link->X, Link->Y, endX, endY, amp, period, 10, t);
			// Waitframe();
		// }
	}
	bool CanHook(){
		if(Link->Action==LA_SWIMMING||Link->Action==LA_DIVING)
			return false;
		return !G[G_SCREENCHANGED]&&!Link->Falling;
	}
	int CanStun(npc n){
		if(n->CollDetection){
			if(n->Misc[NPCM_CANSTUN]){
				if(n->HitWidth>16||n->HitHeight>16)
					return 2;
				return 1;
			}
		}
		return 0;
	}
	int CheckStarBlockCollision(int x, int y){
		for(int i=1; i<=32; ++i){
			ffc f = Screen->LoadFFC(i);
			if(f->Script==FFCS_STARWANDBLOCK){
				if(x>=f->X&&x<=f->X+f->TileWidth*16-1&&y>=f->Y&&y<=f->Y+f->TileHeight*16-1){
					return i;
				}
			}
		}
		return 0;
	}
	void DrawRopeSegment(int layer, int sX, int sY, int eX, int eY){
		int ang = Angle(sX, sY, eX, eY);
		sX -= VectorX(1, ang);
		sY -= VectorY(1, ang);
		eX += VectorX(1, ang);
		eY += VectorY(1, ang);
		int w = Distance(sX, sY, eX, eY);
		int h = 16;
		int x = sX-w/2+VectorX(w/2, ang);
		int y = sY-h/2+VectorY(w/2, ang);
		Screen->DrawTile(layer, x, y, 67332, 1, 1, 8, w, h, x, y, ang, 0, true, 128);
	}
	void DrawGrapple(int layer, int startX, int startY, int endX, int endY, int amp, int period, int speed, int t){
		if(layer==2&&ScreenFlag(1, 4)) //Layer -2
			layer = 1;
		
		t[0] = (t[0]+speed)%360;
		
		int pointX[512];
		int pointY[512];
		
		int distance = Floor(Distance(startX, startY, endX, endY))+1;
		int angle = Angle(startX, startY, endX, endY);
		
		endX -= VectorX(8, angle);
		endY -= VectorY(8, angle);
		for(int i=0; i<distance+16; ++i){
			int t_amp = amp*Sin(Lerp(0, period, i/distance)+t[0])*Sin(Clamp(Lerp(0, 360, i/distance), 0, 360));
			if(i<distance){
				pointX[i] = startX+VectorX(i, angle)+VectorX(t_amp, angle+90);
				pointY[i] = startY+VectorY(i, angle)+VectorY(t_amp, angle+90);
			}
			else{
				pointX[i] = startX+VectorX(distance-1, angle);
				pointY[i] = startY+VectorY(distance-1, angle);
			}
		}
		
		int numPoints = Ceiling(distance/4);
		for(int i=0; i<numPoints; ++i){
			DrawRopeSegment(layer, pointX[i*4]+8, pointY[i*4]+8, pointX[i*4+4]+8, pointY[i*4+4]+8);
		}
		endX += VectorX(8, angle);
		endY += VectorY(8, angle);
		Screen->DrawTile(layer, endX, endY, 67330, 1, 1, 11, -1, -1, endX, endY, angle, 0, true, 128);
	}
}