//Example LWeapons.zh global script

global script LW_Active{
	void run(){
		while(true){
			//Various commands here.
			//Call LWeapon handling, for before waitdraw stuff.
			UpdateLWZH1();
			Waitdraw();
			//Call LWeapon Handling.
			UpdateLWZH2();
			//TraceLWeapons();
			Waitframe();
		}
	}
}

void TraceLWeapons(){
	for(int i= Screen->NumLWeapons();i>0;i--){
		lweapon wpn = Screen->LoadLWeapon(i);
		if((wpn->Misc[LW_ZH_I_FLAGS]&__LWFI_IS_LWZH_LWPN)==0)
			continue;
		int buffer []= "Flags are ";
		TraceS(buffer);
		Trace(wpn->Misc[LW_ZH_I_FLAGS]);
		int buffer2 []= "Lifespan is ";
		TraceS(buffer2);
		Trace(wpn->Misc[LW_ZH_I_LIFESPAN_ARG]);
		int buffer3 []= "Movement is ";
		TraceS(buffer3);
		Trace(wpn->Misc[LW_ZH_I_MOVEMENT]);
		int buffer4[]= "Death effect is ";
		TraceS(buffer4);
		Trace(wpn->Misc[LW_ZH_I_ON_DEATH]);
	}
}