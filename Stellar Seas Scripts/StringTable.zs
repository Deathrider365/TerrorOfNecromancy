enum {STMD_EMOTE, STMD_EMOTETIME, STMD_CHAR};

int LoadString(int buf, int whichString, int cmb, int til, int cs, int flags, int flip, ffc this){
	LoadString(buf, whichString, 0, cmb, til, cs, flags, flip, this);
}

int LoadString(int buf, int whichString, int metadata, int cmb, int til, int cs, int flags, int flip, ffc this){
	switch(whichString){
		case 0:
			if(GetCharID()==0){
				CopyStringToBuffer(buf, "My own clone! @pressa()@26@26...Yeah I've made this joke enough.");
				metadata[STMD_EMOTE] = 2;
				metadata[STMD_EMOTETIME] = 60;
			}
			else
				CopyStringToBuffer(buf, "You seen Asher anywhere?");
			break;
		case 1:
			CopyStringToBuffer(buf, "I just have too much energy. Like, you don't understand, overflowing with energy right now. No I'm not going to direct it towards anything productive. I'm gonna pace back and forth between these two spots over and over again. Then I'm gonna sit down, accomplish nothing, and go to bed feeling like shit.", SCHAR_TORRIN, 0, metadata);
			CopyStringToBuffer(buf, "...That's rough buddy.", SCHAR_ASHER, 8, metadata);
			CopyStringToBuffer(buf, "Indeed.", SCHAR_KAYLANI, 0, metadata);
			CopyStringToBuffer(buf, "Also this is a test of NPCs that can move around. And now also NPCs who have conversations.", SCHAR_TORRIN, 0, metadata);
			break;
		case 2:
			CopyStringToBuffer(buf, "I heard there's spooks around here. I swear if I think that fucking spook ONE MORE TIME I'LL- Sorry. Got carried away.");
			break;
		case 3:
			CopyStringToBuffer(buf, "They didn't give me a name. They didn't give me a naaaaame! The day I was born, my momma just said \"Yup, this one looks like a henchman.\" So here I am. @delay(60)@26@26...Anything I can hench for ya?");
			break;
		case 4:
			CopyStringToBuffer(buf, "I'll tell you the whole truth this time. I swear. Scout's honor.@delay(180)@26@26@26@26@26@26@26@26@26@26@26@26Okay hi, Moosh here. I don't actually have anything more to test. Just writing dumb strings to put off screen design at this point.");
			break;
		case 5:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "Iris says you're some kind of hero now, Asher. Is that true?", SCHAR_TIM, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "I don't know if I'd go THAT far, but I guess sorta?", SCHAR_ASHER, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "That's so cool! Think you could help me out then? I may owe Iris a whole lot of chocolate...", SCHAR_TIM, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Sorry, but that's beyond what even I can do.", SCHAR_ASHER, EMOTE_NORMAL, metadata);
			}
			else if(Game->GetScreenState(2, 0x70, ST_SPECIALITEM))
				CopyStringToBuffer(buf, "They were fighting over that green rock? Huh. I wonder what it is.");
			else
				CopyStringToBuffer(buf, "I saw something shiny fall into the pond. I think the fish are fighting over it now.");
			break;
		case 6:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR)
				CopyStringToBuffer(buf, "Jeff brought me one of the crab rocks that he caught the other day. They may look like crabs, but they definitely don't taste like them. I do think I can grind the shell down into salt and spices though, so it's something.");
			else
				CopyStringToBuffer(buf, "With the trading ships gone for the foreseeable future, Jeff's been hunting game out in the woods. He came home yesterday telling me rocks were coming to life and chasing him. Surely he's just pulling my leg.");
			break;
		case 7:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "Gina still hasn't let you move the bed back?", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "No, she bought some lunar magic canister in a back alley in Pala, and now she's convinced she can move it back telepathically. So far it hasn't been working out the best...", SCHAR_DRAKE, 0, metadata);
			}
			else
				CopyStringToBuffer(buf, "Gina's been doing nothing but reading about magic recently. She's always going on and on about the subtle differences between solar and lunar magic. I think she's just jealous she's not a mage. @delay(120)@26@26Don't say that to her face though. I did, and she still won't let me move my bed back to her side of the room.");
			break;
		case 8:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "Hey, Bobby. How's life treating you?", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "Oh, you know, same old same old. With the pirates gone, shipments are coming back regularly, so that's nice at least. Take a look at this. It's wine infused with fir cone extract. Some woman named Laverne invented it by accident a few weeks back, and it's incredible!", SCHAR_BOBBY, 0, metadata);
				CopyStringToBuffer(buf, "Uh huh... knowing her, I'm not actually surprised...", SCHAR_KAYLANI, 0, metadata);
			}
			else{
				CopyStringToBuffer(buf, "There was supposed to be some taro wine from Malka on today's ship. Damned pirates nicked it all though. I'm so upset, the only thing I've managed to do today is drink.", SCHAR_BOBBY, 0, metadata);
				if(CanUseChar(CHAR_TORRIN) > 0)
					CopyStringToBuffer(buf, "Trust me man, you're not missing anything. Taro's good for a lot of things, but alcohol is NOT one of them.", SCHAR_TORRIN, 0, metadata);
			}
			break;
		case 9:
			if(Game->Counter[CR_STORYFLAG] < SFLAG_WAREHOUSE){
				CopyStringToBuffer(buf, "So about those muffins...", SCHAR_IRIS, 0, metadata);
				CopyStringToBuffer(buf, "Are you gonna keep asking til I say yes?", SCHAR_ASHER, 8, metadata);
				CopyStringToBuffer(buf, "Depends. Is it working?", SCHAR_IRIS, 0, metadata);
			}
			else if(Game->Counter[CR_STORYFLAG] == SFLAG_WAREHOUSE){
				CopyStringToBuffer(buf, "Oh hey, you finally made some friends.", SCHAR_IRIS, 0, metadata);
				CopyStringToBuffer(buf, "Oh hey, you still have no tact.", SCHAR_ASHER, 8, metadata);
				CopyStringToBuffer(buf, "Tact takes effort. What's in it for me?", SCHAR_IRIS, 0, metadata);
				CopyStringToBuffer(buf, "A brother who looks forward to talking to you?", SCHAR_ASHER, 8, metadata);
				CopyStringToBuffer(buf, "Eh, sweeten the pot a little and I'll consider.", SCHAR_IRIS, 0, metadata);
			}
			else if(Game->Counter[CR_STORYFLAG] >= SFLAG_ASHERKIDNAPPED && Game->Counter[CR_STORYFLAG] < SFLAG_ASHERRESCUED){
				CopyStringToBuffer(buf, "You're Asher's friend, right? What happened to him?", SCHAR_IRIS, 0, metadata);
				CopyStringToBuffer(buf, "Uh... it's complicated...", SCHAR_TORRIN, 8, metadata);
			}
			else if(Game->Counter[CR_ASHERSIDEQUEST] == 4 && Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				PlayStringAndWaitForNPCs("Aw, you're leaving again already? It's not the same without you around.", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Cuz you can't manipulate other people into doing stuff for you?", SCHAR_ASHER, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Oh no, Tim's great for that. But you have a naive earnestness that brings some energy to town. It's boring without you around.", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Uh... I'm not sure if that was kind or mean.", SCHAR_ASHER, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			else{
				if(Game->Counter[CR_ASHERSIDEQUEST] == 0){
					PlayStringAndWaitForNPCs("There you are. Mom was getting worried about you. No need to worry though, I made a very convincing cover story, and it only KINDA makes you seem like a moody teen.", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Thanks Iris. I've been going through a lot, and it means-", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Hold on, I'm not finished. We haven't discussed my payment yet.", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("... What if I told you I WAS trying to pick up those muffins for you before getting pulled into an espionage mission?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I'd say that's kind, but you'll have to do better than that if you want me to keep covering for you.", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Alright, what do you want?", SCHAR_ASHER, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("There's a sea cave called Kawaihae south of here. Tim tells me some beautiful gems grow in there, but everyone's scared away by a monster hiding inside.", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("You're kidding, right?", SCHAR_ASHER, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("What, I thought you wanted to be a hero? Braving caves and finding treasures seems like pretty basic hero stuff to me. Tell ya what, I'll sweeten the pot a bit too. Find me a gem and I'll toss in an augment I have. What d'ya say?", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("... I say I shouldn't be encouraging this, but deal.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("It's a pleasure doing business with you, Asher.", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					Game->Counter[CR_ASHERSIDEQUEST] = 1;
					PopupNotify(3); //New Quest
				}
				else if(Game->Counter[CR_ASHERSIDEQUEST] < 3){
					PlayStringAndWaitForNPCs("Got my gem yet, big brother?", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I'm working on it.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Better hurry. It'd be a shame if I were to let something slip to Mom about what you're REALLY up to.", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("You don't even know what I'm up to.", SCHAR_ASHER, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("No, but I know she won't be happy to find out either way.", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				}
				else if(Game->Counter[CR_ASHERSIDEQUEST] == 3){
					PlayStringAndWaitForNPCs("Here you go, Iris. One Kawaihae gem.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Ooh, it's even prettier than I imagined. You've just bought yourself a few more weeks of silence.", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("And that augment?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Darn, I was hoping you'd forgotten. Here you go.", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					AugmentGet(188);
					Game->Counter[CR_ASHERSIDEQUEST] = 4;
				}
				else if(Game->Counter[CR_ASHERSIDEQUEST] == 4){
					PlayStringAndWaitForNPCs("You're not getting up to any trouble while I'm gone, are you?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("What would make you ask something as silly as that?", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I saw Tim in Pala Bay, and it looked like he was buying up sweets.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("And you think this has anything to do with me? Are you implying that I'm blackmailing a friend? Where on earth would you get an idea like that?", SCHAR_IRIS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("You really scare me sometimes, sis...", SCHAR_ASHER, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
				}
				return 1;
			}
			break;
		case 10:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "I heard some beautiful young solar mage showed up and taught you how to use magic. Figures you'd get to live out my fantasies while I'm stuck here.", SCHAR_GINA, 0, metadata);
				CopyStringToBuffer(buf, "Okay first, that's not at all what happened. Second, and I hate that I have to keep bringing this up, you're MARRIED.", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "I know... Drake's a nice guy, too, so long as he thinks before he talks. But can you blame me for wanting an escape from the mundanity?", SCHAR_GINA, 0, metadata);
				CopyStringToBuffer(buf, "No, but maybe you should make your fantasies sound a little less... affair-ish?", SCHAR_ASHER, EMOTE_SWEAT, metadata);
			}
			else{
				CopyStringToBuffer(buf, "Wouldn't it be amazing to know how to do magic? Sometimes I dream about a beautiful solar mage from Wahiokala sailing up to the dock and sweeping me off my feet, teaching me all the secrets of the heavens and how to harness solar energy myself.", SCHAR_GINA, 0, metadata);
				if(Game->Counter[CR_STORYFLAG] < SFLAG_METKAYLANI){
					CopyStringToBuffer(buf, "... Aren't you happily married?", SCHAR_ASHER, 1, metadata);
					CopyStringToBuffer(buf, "Married, yes. Happily, depends on how far up his mouth Drake shoves his foot on any given day.", SCHAR_GINA, 4, metadata);
				}
				else{
					CopyStringToBuffer(buf, "That's... not exactly how we operate.", SCHAR_KAYLANI, 1, metadata);
				}
			}
			break;
		case 11:
			// CopyStringToBuffer(buf, "Huh? Oh, I recognize you. You're from Puna Village, right?", SCHAR_MANBOOK, 0, metadata);
			// CopyStringToBuffer(buf, "Yeah. Do I know you?", SCHAR_ASHER, 0, metadata);
			// CopyStringToBuffer(buf, "No, but I've got a message for you. Tell Gina to stop grabbing every library book on magic! I'm trying to research it myself, but she snatches up everything she can get her hands on.", SCHAR_MANBOOK, 4, metadata);
			// CopyStringToBuffer(buf, "It looks like you've got a lot of library books yourself...", SCHAR_ASHER, 0, metadata);
			if(Game->Counter[CR_MISCSIDEQUEST] < 3 || !CanUseChar(CHAR_ASHER)){
				CopyStringToBuffer(buf, "It's a conspiracy! A conspiracy, I tell you! Look at this! What do you make of it?", SCHAR_MANBOOK, 0, metadata);
				if(CanUseChar(CHAR_ASHER) > 0)
					CopyStringToBuffer(buf, "It... looks like a very large book?", SCHAR_ASHER, 0, metadata);
				if(CanUseChar(CHAR_KAYLANI) > 0)
					CopyStringToBuffer(buf, "Those are some... fascinating scribbles you've made in the margins there.", SCHAR_KAYLANI, 0, metadata);
				CopyStringToBuffer(buf, "Don't you see? The merchants have sold us out! Using powers they stole from outer space, they plan on conquering us all! It's all here! I had to spend my life savings to move to the upper tier, but it's worth it to spy on their comings and goings. I'm on to them. Oh they better beware.", SCHAR_MANBOOK, 0, metadata);
				if(CanUseChar(CHAR_TORRIN) > 0)
					CopyStringToBuffer(buf, "Good for you takin' the 'nitiative. Now, uh... we're just gonna dip out.", SCHAR_TORRIN, 0, metadata);
			}
			else if(Game->Counter[CR_MISCSIDEQUEST] >= 3 || Game->Counter[CR_MISCSIDEQUEST] <= 10){
				PlayStringAndWaitForNPCs("It's happening! The merchants have started seizing people!", SCHAR_MANBOOK, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("What are you talking about?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I heard a scuffle in the house next door. Peeped through the window and saw it with my own eyes! That Tulane woman was shoving a girl into a sack! She had her bodyguards carry the girl out with the trash and head down to the docks!", SCHAR_MANBOOK, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("What!? Why would she do that?", SCHAR_ASHER, EMOTE_EXCLAMATION, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Isn't it obvious? Tulane owns a private villa on an island south of here. Clearly, she wants to take the girl there and consume her entrails to fuel her blood magic! This is the start of the end!", SCHAR_MANBOOK, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I, uh... don't know about the blood magic, but thanks for the tip about the villa!", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				if(Game->Counter[CR_MISCSIDEQUEST] == 3)
					Game->Counter[CR_MISCSIDEQUEST] = 4;
				return 1;
			}
			break;
		case 12:
			CopyStringToBuffer(buf, "I had this lovely fireplace installed, but whenever I use it, the house becomes dreadfully hot, and I have to open all the doors and windows for it to air out. Perhaps it wasn't the wisest purchase, but it matches the decor so wonderfully.");
			break;
		case 13:
			CopyStringToBuffer(buf, "I moved here from abroad after hearing that Pala Bay was the largest city of this archipelago. But to find such a small town... how am I supposed to properly demonstrate my opulent wealth in such a quaint place?", SCHAR_BIF, 0, metadata);
			if(CanUseChar(CHAR_ASHER) > 0)
				CopyStringToBuffer(buf, "Maybe you shouldn't have moved here just to impress people?", SCHAR_ASHER, 0, metadata);
			if(CanUseChar(CHAR_TORRIN) > 0){
				CopyStringToBuffer(buf, "Could probably start by not lookin' like a clown. That hat looks like a stovetop.", SCHAR_TORRIN, 0, metadata);
				CopyStringToBuffer(buf, "Alas, the refined fashions of my people are like pearls before swine with you lot.", SCHAR_BIF, 0, metadata);
			}
			break;
		case 14:
			CopyStringToBuffer(buf, "I already told you, I don't want you hanging around Torrin anymore.", SCHAR_WOMANGREENSKIRTOUTFIT2, 0, metadata);
			CopyStringToBuffer(buf, "What!? Why not? He's awesome!", SCHAR_BOYGREENSHORTS, 5, metadata);
			CopyStringToBuffer(buf, "He's trouble.", SCHAR_WOMANGREENSKIRTOUTFIT2, 0, metadata);
			CopyStringToBuffer(buf, "He's not trouble! He's making the world a better place! Righting wrongs and helping the...@delay(60)@26@26down rod? No...@delay(60)@26@26the dowt nod? ...@delay(120)@26@26He's helping people is the point!", SCHAR_BOYGREENSHORTS, 4, metadata);
			if(CanUseChar(CHAR_TORRIN)){
				CopyStringToBuffer(buf, "\"Downtrodden\" is the word I used.", SCHAR_TORRIN, 0, metadata);
				CopyStringToBuffer(buf, "Yeah, that's the one!", SCHAR_BOYGREENSHORTS, 0, metadata);
				CopyStringToBuffer(buf, "Wait, when'd you get here!?", SCHAR_BOYGREENSHORTS, 2, metadata);
				CopyStringToBuffer(buf, "This is what I meant. Any boy who walks into other people's houses uninvited is not the kind of person you should associate with.", SCHAR_WOMANGREENSKIRTOUTFIT2, 0, metadata);
				CopyStringToBuffer(buf, "Geez, I only popped my head in cuz I heard my name bein' mentioned...", SCHAR_TORRIN, 8, metadata);
			}
			else{
				CopyStringToBuffer(buf, "Yes, well he has a very confrontational way of helping, and I don't want you around when he winds up causing commotion because of it.", SCHAR_WOMANGREENSKIRTOUTFIT2, 0, metadata);
				CopyStringToBuffer(buf, "That goes for you too, Asher. I don't want either of you disappearing on me, too.", SCHAR_WOMANGREENSKIRTOUTFIT2, 0, metadata);
				CopyStringToBuffer(buf, "Still no word from Soren, then?", SCHAR_ASHER, EMOTE_SAD, metadata);
				CopyStringToBuffer(buf, "Nothing yet. But I'm still hopeful...", SCHAR_WOMANGREENSKIRTOUTFIT2, EMOTE_ELLIPSES, metadata);
			}
			break;
		case 15:
			if(Game->Counter[CR_MISCSIDEQUEST] == 3 && CanUseChar(CHAR_ASHER)){	
				CopyStringToBuffer(buf, "Hey, this is a weird question, but have you seen a young girl with black hair in a ponytail sneak in to play the piano?", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "I... can't say I have. Though I did hear some music coming from Madame Tulane's house down the street. I thought that was odd, since she never had time for music before.", SCHAR_WOMANREDSKIRTOUTFIT1, 0, metadata);
			}
			else
				CopyStringToBuffer(buf, "I'm grateful my husband makes enough for us to afford a home on the upper tier, but some of our neighbors are a bit... eccentric. A lot of them try to flaunt their wealth with fancy clothes, but they just look like heatstroke waiting to happen to me.");
			break;
		case 16:
			CopyStringToBuffer(buf, "Life's nice here, but kind of boring. I hear the lower tiers of the city get a little more exciting, but I'm not sure that's the kind of excitement I want in my life.");
			break;
		case 17:
			CopyStringToBuffer(buf, "As Portmaster, I've been receiving all manner of reports of stolen and smuggled goods recently. But so far, my investigations have turned up nothing.");
			break;
		case 18:
			CopyStringToBuffer(buf, "Twice now I've been robbed by a ship flyin' Pala Bay's colors. But the Portmaster says he ain't seen a ship matchin' the description a' the one I ran into. And now this shack's full of unlabeled cargo, but there's no record of who owns it. All seems mighty suspicious to me.", SCHAR_KENJA, 0, metadata);
			G[G_KENJACONVO] = 1;
			if(CanUseChar(CHAR_ASHER) > 0 && CanUseChar(CHAR_TORRIN) > 0){
				CopyStringToBuffer(buf, "Hey, Kenja, long time no see!", SCHAR_TORRIN, 7, metadata);
				CopyStringToBuffer(buf, "Huh, so this is where you've run off to, Torrin. Hope you're not plannin' on heading back home anytime soon. Your mom's fixin' to kill you after you made off with that boat and didn't tell anyone where to.", SCHAR_KENJA, 0, metadata);
				CopyStringToBuffer(buf, "Wait, you STOLE that boat?", SCHAR_ASHER, 2, metadata);
				CopyStringToBuffer(buf, "\"Stole\" ain't the right word. It's my family's boat. All I did was take it out. Without tellin' Mom.", SCHAR_TORRIN, 0, metadata);
				CopyStringToBuffer(buf, "Call it what ya like, but don't say I didn't warn ya if she greets you with a knife.", SCHAR_KENJA, 0, metadata);
				G[G_KENJACONVO] = 2;
			}
			break;
		case 19:
			CopyStringToBuffer(buf, "This section of road was damaged in an earthquake recently and is still being repaired. Sorry for the inconvenience.");
			break;
		case 20:
			CopyStringToBuffer(buf, "Ah! You're not supposed to be home already!", SCHAR_MISTY, 2, metadata);
			CopyStringToBuffer(buf, "Oh... you're not Mr. Garson. Please don't tell anyone I sneak next door to play the piano. My mom would be so mad if she knew.", SCHAR_MISTY, 0, metadata);
			break;
		case 21:
			CopyStringToBuffer(buf, "It's a bit of a slow day today. Not that I'm complaining. Does mean I don't get to pick up as much gossip as usual though.");
			break;
		case 22:
			CopyStringToBuffer(buf, "I think my date stood me up...");
			break;
		case 23:
			CopyStringToBuffer(buf, "I heard the astronomers on Wahiokala have an observatory way up on top of Mauna Ali'i. Can you imagine what the view from up there must be like? They don't let any outsiders up there though. Such a shame.");
			break;
		case 24:
			CopyStringToBuffer(buf, "Huh? What are you doing in the chapel today?", SCHAR_WOMANBLACKHAIRYELLOWSKIRT, 0, metadata);
			if(CanUseChar(CHAR_ASHER) > 0)
				CopyStringToBuffer(buf, "What are YOU doing in the chapel today?", SCHAR_ASHER, 0, metadata);
			else if(CanUseChar(CHAR_TORRIN) > 0)
				CopyStringToBuffer(buf, "What are YOU doing in the chapel today?", SCHAR_TORRIN, 0, metadata);
			CopyStringToBuffer(buf, "I have... confession! Yes, that's it! I scheduled confession with the priest today! He should be here any minute now, so scram!", SCHAR_WOMANBLACKHAIRYELLOWSKIRT, 0, metadata);
			CopyStringToBuffer(buf, "Sorry daddy, I've been naughty...@delay(120)@26@26Eh!? What are you still doing here? Scram!", SCHAR_WOMANBLACKHAIRYELLOWSKIRT, 0, metadata);
			break;
		case 25:
			if(Game->Counter[CR_STORYFLAG]<4)
				CopyStringToBuffer(buf, "Welcome to the library. Feel free to peruse our titles. We also sell augments, though we're a bit low on stock at the moment.");
			else
				CopyStringToBuffer(buf, "Welcome to the library. We're receiving shipments of augments again, so please stop by from time to time to check out our inventory.");
			break;
		case 26:
			if(Game->Counter[CR_STORYFLAG]<5)
				CopyStringToBuffer(buf, "Welcome to the ammo shop. We're running a bit low on stock right now, but come back soon, and we'll be able to supply you with any ammunition type you might need.");
			else
				CopyStringToBuffer(buf, "Welcome to the ammo shop. Here, we're able to supply you with any ammunition type you might need.");
			break;
		case 27:
			if(Game->Counter[CR_STORYFLAG]<5)
				CopyStringToBuffer(buf, "Welcome to the weapons shop. I'm low on stock right now, but I promise you I've got two fantastic weapons coming in on the next ship that doesn't get pirated.");
			else if(Game->Counter[CR_STORYFLAG]<10)
				CopyStringToBuffer(buf, "Welcome to the weapons shop. I've got some new goods for sell now that are bound to help you on any adventures.");
			else
				CopyStringToBuffer(buf, "Welcome to the weapons shop. We've got a new item based on technology I found around the manor up on the hill. Sneaking around those weird mask guys was a pain, but you'll find this item well worth the effort!");
			break;
		case 28:
			CopyStringToBuffer(buf, "Step right up folks! Rare and exotic fruits from distant lands available here!", SCHAR_MERCHANT, 0, metadata);
			if(CanUseChar(CHAR_ASHER) > 0){
				CopyStringToBuffer(buf, "I've never seen someone dressed like you before.", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "I imagine you haven't. I hail from a faraway continent, peddling goods from home wherever I land. And this outfit travels with me, bringing me luck wherever I go.", SCHAR_MERCHANT, 0, metadata);
				CopyStringToBuffer(buf, "How's that work?", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "Easy. It grabs people's attentions. You noticed me amongst all these others stalls, didn't you?", SCHAR_MERCHANT, 0, metadata);
				CopyStringToBuffer(buf, "Oh... that's smart.", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "When you make a living of trade, you learn a few tricks. Now, can I interest you in a dragon fruit?", SCHAR_MERCHANT, 0, metadata);
			}
			break;
		case 29:
			CopyStringToBuffer(buf, "I got all manner of fancy tarps for sell here! Stay out of the sun, enjoy the shade! Think of how many more customers you'll attract!", SCHAR_MANORANGEPANTS, 0, metadata);
			if(CanUseChar(CHAR_ASHER) > 0){
				CopyStringToBuffer(buf, "You're selling to other merchants?", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "Second order retail is where the real money is. I also sell tent-poles, decorative barrels, and business permits.", SCHAR_MANORANGEPANTS, 0, metadata);
				if(CanUseChar(CHAR_TORRIN) > 0){
					CopyStringToBuffer(buf, "... so basically you sell permits to merchants, then convince them to buy more stuff they don't need.", SCHAR_TORRIN, 0, metadata);
					CopyStringToBuffer(buf, "Get in the business of advertising and you start thinking you're immune to it yourself. And that's where I strike.", SCHAR_MANORANGEPANTS, 0, metadata);
				}
			}
			break;
		case 30:
			CopyStringToBuffer(buf, "I hear all sorts of weird noises coming from the warehouse over there. Seems real suspicious, but the Portmaster insists they've got all their paperwork in order.");
			break;
		case 31:
			CopyStringToBuffer(buf, "I was playing north of town when I tripped and fell THROUGH a tree. Like it wasn't even there! It led to a secret beach. I don't remember exactly where it was, but there was something orange on either side of the fake tree.");
			break;
		case 32:
			CopyStringToBuffer(buf, "Pala Bay's the biggest port around. Almost any cargo coming from abroad comes through here. That's great for job security, but really bad for my back.");
			break;
		case 33:
			CopyStringToBuffer(buf, "Sometimes I hide behind the boxes down by the water. It's like a maze back there! I've seen some weird green rocks behind those boxes. I also saw a weird floating flame back there once, but I was kinda hungry and decided to get a snack instead of following it.");
			break;
		case 34:
			CopyStringToBuffer(buf, "I can't stand some of the rich folk living on the upper tier. They move from afar for the climate, then look down on the rest of us. That merchant with the manor up on the hill above town is the absolute worst. You can feel how little he thinks of you when he walks by.");
			break;
		case 35:
			if(Game->Counter[CR_TORRINSIDEQUEST] == 0 || Game->Counter[CR_TORRINSIDEQUEST] == 10){
				if(Game->Counter[CR_STORYFLAG] < SFLAG_SHOALSOPEN){
					PlayStringAndWaitForNPCs("When Mom's done chewin' Torrin out, send him my way, please. He an' I need to talk.", SCHAR_TERRY, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					Game->Counter[CR_TORRINSIDEQUEST] = 10;
					return 1;
				}
				else{
					PlayStringAndWaitForNPCs("Torrin, there you are!", SCHAR_TERRY, EMOTE_ANGRY, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Hey sis. If you're here to chew me out too, don't bother. Mom got that out of the way already, an' then some.", SCHAR_TORRIN, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Well too bad, cuz there's more coming. The hell were you thinkin'!?", SCHAR_TERRY, EMOTE_FURIOUS, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I was thinkin' nobody else was doin' anything about the pirates, and I'd be damned if I sat aroun' waitin' for things to get worse.", SCHAR_TORRIN, EMOTE_ANGRY, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("And so you slipped away without tellin' anyone? Did you even think about what Caiman might do?", SCHAR_TERRY, EMOTE_ANGRY, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("What's Caiman got to do with anything?", SCHAR_TORRIN, EMOTE_QUESTION, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("He idolizes you, Torrin! When you disappeared, all he could talk about was what kind of big adventures you must be up too. An' now he and Zeke are both missin', along with another boat.", SCHAR_TERRY, EMOTE_FURIOUS, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("What!? You're kiddin', right?", SCHAR_TORRIN, EMOTE_SURPRISED, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("They've been gone since I woke up this mornin'. I've already checked all around the island. There's no sign of 'em anywhere.", SCHAR_TERRY, EMOTE_SAD, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Okay, don't worry. I'll find 'em and bring 'em back safe. ", SCHAR_TORRIN, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("You'd better...", SCHAR_TERRY, EMOTE_SAD, 68, 24, cmb, til, cs, flags, flip, this);
					Game->Counter[CR_TORRINSIDEQUEST] = 1;
					PopupNotify(3); //New Quest
					return 1;
				}
			}
			if(Game->Counter[CR_TORRINSIDEQUEST] == 1){
				PlayStringAndWaitForNPCs("Well? Found 'em yet?", SCHAR_TERRY, EMOTE_ANGRY, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I'm workin' on it. Don't worry, I'll find 'em! Got any leads on where they might've headed?", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("No... but maybe if you talk to some of the folks on the outlying islands, you'll pick up their trail.", SCHAR_TERRY, EMOTE_SAD, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			if(Game->Counter[CR_TORRINSIDEQUEST] == 6){
				CopyStringToBuffer(buf, "You're bein' careful out there, aren't ya?", SCHAR_TERRY, 0, metadata);
				CopyStringToBuffer(buf, "Ya don't need to worry 'bout me, sis. I can handle myself.", SCHAR_TORRIN, 0, metadata);
				CopyStringToBuffer(buf, "That's what you've always said. And I've always had to bail you out.", SCHAR_TERRY, 4, metadata);
				CopyStringToBuffer(buf, "Don't worry, I got friends to bail me out now.", SCHAR_TORRIN, EMOTE_HAPPY, metadata);
				CopyStringToBuffer(buf, "That's not makin' me feel reassured.", SCHAR_TERRY, EMOTE_SWEAT, metadata);
			}
			break;
		case 36:
			if(Game->Counter[CR_STORYFLAG] < SFLAG_SHOALSOPEN){
				if(G[G_KENJACONVO] == 0){
					CopyStringToBuffer(buf, "You look like you're from Pala Bay, or thereabouts. Happen to know anything suspicious goin' on down by the docks?", SCHAR_KENJA, 0, metadata);
					CopyStringToBuffer(buf, "Actually, I do. There was some smuggling going on in one of the warehouses.", SCHAR_ASHER, 0, metadata);
					CopyStringToBuffer(buf, "I knew it! Damned Portmaster swore up and down it was squeaky clean. He must be in on it too.", SCHAR_KENJA, 0, metadata);
				}
				else if(G[G_KENJACONVO] == 1){
					CopyStringToBuffer(buf, "Hey, I recognize you, from back in Pala.", SCHAR_KENJA, 0, metadata);
					CopyStringToBuffer(buf, "Oh, it's you! You were right about that warehouse. Turns out smuggled goods were being stored there.", SCHAR_ASHER, 0, metadata);
					CopyStringToBuffer(buf, "I knew it! Damned Portmaster swore up and down it was squeaky clean. He must be in on it too.", SCHAR_KENJA, 0, metadata);
				}
				else if(G[G_KENJACONVO] == 2){
					CopyStringToBuffer(buf, "Hey, I recognize you, from back in Pala.", SCHAR_KENJA, 0, metadata);
					CopyStringToBuffer(buf, "Oh, it's you! Kenja, right?", SCHAR_ASHER, 0, metadata);
					CopyStringToBuffer(buf, "That's me. I take it if you're here, Torrin finally decided to face the music.", SCHAR_KENJA, 0, metadata);
					CopyStringToBuffer(buf, "Yeah... it wasn't a pretty sight. Is he gonna be alright?", SCHAR_ASHER, EMOTE_SWEAT, metadata);
					CopyStringToBuffer(buf, "Talcay talks a big game, but the worst she'll do is leave 'is ears ringin' for a while. She can't control Torrin anymore an' she knows it. No one can when he puts his mind to somethin'.", SCHAR_KENJA, 0, metadata);
					CopyStringToBuffer(buf, "Speaking from experience?", SCHAR_ASHER, 0, metadata);
					CopyStringToBuffer(buf, "He'd get into trouble all the time back in the day. His sister Terry'd bail him out when she could, but more often than not, I'd have to help him out of whatever mess he got himself into. He's capable of sortin' out his own problems now though.", SCHAR_KENJA, 0, metadata);
					CopyStringToBuffer(buf, "Or so we'd hope...", SCHAR_ASHER, EMOTE_SWEAT, metadata);
				}
				if(Game->Counter[CR_STORYFLAG] < SFLAG_SENTTODARI){
					CopyStringToBuffer(buf, "As an aside, are you able to read sea charts?", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
					CopyStringToBuffer(buf, "Well, sort of... But I'm probably not the best guy to ask. I got a little turned around headin' to Pala Bay last time. Don't tell Torrin though. Gotta maintain an image.", SCHAR_KENJA, EMOTE_SWEAT, metadata);
				}
			}
			else if(Game->Counter[CR_STORYFLAG] >= SFLAG_ALIIOPEN){
				CopyStringToBuffer(buf, "How's the leg treatin' ya?", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Still don't quite feel steady on it, but it's comin' along. Makes keepin' your brother and Zeke outta trouble a real pain though.", SCHAR_KENJA, EMOTE_NORMAL, metadata);
			}
			else{
				CopyStringToBuffer(buf, "Well, how'd it go with your mom?", SCHAR_KENJA, 0, metadata);
				CopyStringToBuffer(buf, "I'll hear her voice ringin' in my ears for weeks.", SCHAR_TORRIN, EMOTE_SAD, metadata);
				if(G[G_KENJACONVO] == 2){
					CopyStringToBuffer(buf, "I tried to warn ya...", SCHAR_KENJA, 0, metadata);
				}
				else
					CopyStringToBuffer(buf, "Yeah, I coulda told ya as much.", SCHAR_KENJA, 0, metadata);
			}
			break;
		case 37:
			CopyStringToBuffer(buf, "An' what kinda trouble are you two gettin' up to now?", SCHAR_TORRIN, 0, metadata);
			CopyStringToBuffer(buf, "Nothin', honest!", SCHAR_ZEKE, 0, metadata);
			CopyStringToBuffer(buf, "We learned our lesson!", SCHAR_CAIMAN, 0, metadata);
			CopyStringToBuffer(buf, "An' you're hidin' that knife behind your back cuz...", SCHAR_TORRIN, 0, metadata);
			CopyStringToBuffer(buf, "Does this mean we have to put it back?", SCHAR_CAIMAN, EMOTE_SAD, metadata);
			CopyStringToBuffer(buf, "If Mom catches you, I had no idea you had it, got it?", SCHAR_TORRIN, EMOTE_WINK, metadata);
			CopyStringToBuffer(buf, "Got it!", SCHAR_CAIMAN, EMOTE_HAPPY, metadata);
			break;
		case 38:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "Gotta say Torrin, I didn't expect so much outta ya.", SCHAR_SKAI, 0, metadata);
				CopyStringToBuffer(buf, "You're not the first person to tell me that. Kinda startin' to feel insultin', honestly...", SCHAR_TORRIN, EMOTE_SWEAT, metadata);
				CopyStringToBuffer(buf, "I mean it in the best a' ways. Not many people could do what you did. I'm proud a' you.", SCHAR_SKAI, 0, metadata);
			}
			else if(Game->Counter[CR_STORYFLAG] < SFLAG_SENTTODARI){
				PlayStringAndWaitForNPCs("We're looking for someone who can read a sea chart. You wouldn't happen to be able to, would you?", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("No, but my husband, Dari, probably can. He went out to check on the taro fields just a few minutes ago. You should look for him there.", SCHAR_SKAI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				Game->Counter[CR_STORYFLAG] = SFLAG_SENTTODARI;
				return 1;
			}
			else if(Game->Counter[CR_STORYFLAG] < SFLAG_SHOALSOPEN){
				CopyStringToBuffer(buf, "Sorry, where did you say he was?", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "Back at the taro fields. Head to the northeast of the village and follow the path up the hill.", SCHAR_SKAI, 0, metadata);
			}
			else{
				CopyStringToBuffer(buf, "Torrin, there you are. How'd you like Pala Bay?", SCHAR_SKAI, 0, metadata);
				CopyStringToBuffer(buf, "It was so big! I could hardly believe how many people there were!", SCHAR_TORRIN, 0, metadata);
				CopyStringToBuffer(buf, "It overwhelmed me too when I first went. In my grandmother's time, it was hardly bigger than Puna Village. I doubt she'd even recognize it now.", SCHAR_SKAI, 0, metadata);
			}
			break;
		case 39:
			if(Game->Counter[CR_STORYFLAG] < SFLAG_MISTENTERED){
				CopyStringToBuffer(buf, "Torrin, I'm sure I've taught you before how to read these charts. It's really not that difficult.", SCHAR_DARI, 0, metadata);
				CopyStringToBuffer(buf, "Heh, I do sorta remember a few things...", SCHAR_TORRIN, EMOTE_EMBARRASSED, metadata);
				CopyStringToBuffer(buf, "And to think I gave Kenja a hard time...", SCHAR_DARI, 0, metadata);
			}
			else if(Game->Counter[CR_STORYFLAG] < SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "You three are back already? Where's Skai? She was s'posed to be with you.", SCHAR_DARI, 0, metadata);
				CopyStringToBuffer(buf, "We were ambushed. She's alright, but she really wore herself out keeping everyone else alive. She's recovering with the rest of the team.", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "That sounds like her alright... Long as she's okay, I can wait for her.", SCHAR_DARI, 0, metadata);
			}
			else{
				CopyStringToBuffer(buf, "Heyo, Dari. How's Skai?", SCHAR_TORRIN, 0, metadata);
				CopyStringToBuffer(buf, "Still recoverin', though she ain't lettin' that stop her from tryin' to run the whole village. I worry she's pushin' herself too hard.", SCHAR_DARI, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "I was afraid a' that... nothin' much to do 'bout it though.", SCHAR_TORRIN, EMOTE_SWEAT, metadata);
			}
			break;
		case 40:
			if(CanUseChar(CHAR_ASHER) > 0){
				if(Game->Counter[CR_MISCSIDEQUEST] == 0){
					PlayStringAndWaitForNPCs("Soren? What the heck are you doing here?", SCHAR_ASHER, EMOTE_SURPRISED, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Yo, Asher! Didn't think I'd see you again for a while.", SCHAR_SOREN, 0, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("What happened to you? Your parents refused to say anything after you disappeared.", SCHAR_ASHER, EMOTE_SURPRISED, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I couldn't take it anymore, Asher! Mom and Dad hate each other, but they insist on sticking together to prove some kind of point. I couldn't be stuck in the middle of that anymore. So I went down to the harbor and begged a fisherman from Malka to take me with him.", SCHAR_SOREN, 0, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("That sounds... bold, among other things.", SCHAR_ASHER, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I don't regret a thing. It's so much nicer here than in Pala. No hustle and bustle, no pickpockets, no rich assholes looking down on you from their hilltop mansions.", SCHAR_SOREN, 0, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("And they're letting you stay?", SCHAR_ASHER, 0, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Manch lost his wife and kid a while back. Honestly, I think I'm doing more for him than he is for me.", SCHAR_SOREN, 0, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("And you're happy?", SCHAR_ASHER, 0, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Well... truth be told, I miss my siblings. I feel really guilty leaving them there. Especially Misty. She sneaks out of the house all the time and plays the piano next door, just to be away from Mom and Dad. Uh... if it's not too much to ask, think you could give her a letter for me? I wanted to talk to her myself, next time we're in Pala, but I can't face her yet.", SCHAR_SOREN, 0, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Of course. I'll drop it off to her next time I'm in Pala.", SCHAR_ASHER, 0, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Thanks, man. I owe ya.", SCHAR_SOREN, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
					Game->Counter[CR_MISCSIDEQUEST] = 1;
					PopupNotify(3); //New Quest
					if(Game->Counter[CR_STORYFLAG] < SFLAG_SHOALSOPEN){
						PlayStringAndWaitForNPCs("Maybe you can pay me back. Happen to know how to read sea charts?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
						PlayStringAndWaitForNPCs("Oh man... Manch has tried to teach me, but uh... you know me, Asher.", SCHAR_SOREN, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
						PlayStringAndWaitForNPCs("Ah well, it was worth a shot.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					}
					return 1;
				}
				if(Game->Counter[CR_MISCSIDEQUEST] == 1){
					PlayStringAndWaitForNPCs("Well? How'd she react?", SCHAR_SOREN, 0, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Sorry, I haven't had a chance to drop it off yet. Soon, though, I promise!", SCHAR_ASHER, 0, 68, 24, cmb, til, cs, flags, flip, this);
				}
			}
			else{
				PlayStringAndWaitForNPCs("Hey, wasn't Asher with you before? Did you drop him back off home?", SCHAR_SOREN, 0, 68, 24, cmb, til, cs, flags, flip, this);
			}
			return 1;
		case 41:
			CopyStringToBuffer(buf, "Looking for augments? I'm your guy! We've got all sorts of unique augments for sale here!", SCHAR_PHIN, 0, metadata);
			CopyStringToBuffer(buf, "... Aren't you a little young to be running an augment shop?", SCHAR_KAYLANI, 0, metadata);
			CopyStringToBuffer(buf, "Why yes, yes I am.", SCHAR_PHIN, 0, metadata);
			break;
		case 42:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "I heard 'bout what you three did. I still think you're a fool, Torrin, but you're a brave fool, I'll give ya that.", SCHAR_MANCH, 0, metadata);
				CopyStringToBuffer(buf, "Uh... thanks?", SCHAR_TORRIN, EMOTE_SWEAT, metadata);
				if(G[G_SORENATTEMPLE] == 1){
					CopyStringToBuffer(buf, "I heard Soren also showed some heroics at the temple. Boy's more impulsive than even you, but maybe he'll turn out alright after all. Give 'em my regards next time ya see 'im, and let 'im know he's always got a place to stay 'ere.", SCHAR_MANCH, 0, metadata);
				}
			}	
			else if(Game->Counter[CR_MISCSIDEQUEST] == 8){
				CopyStringToBuffer(buf, "I ain't heard a peep from Soren since he took off for Pala after hearin' 'bout his sister. You happen to know what's become of him?", SCHAR_MANCH, 0, metadata);
				if(CanUseChar(CHAR_ASHER) > 0)
					CopyStringToBuffer(buf, "We found his sister, but he's spending a little bit of time at home for now. Not sure whether he'll end up back here or not.", SCHAR_ASHER, 0, metadata);
				else
					CopyStringToBuffer(buf, "We helped 'im find his sis, and now he's visitin' home for a bit.", SCHAR_TORRIN, 0, metadata);
				CopyStringToBuffer(buf, "I'm glad to hear. Next time you see 'im, let 'im know I hope his family life's okay, but he's always got a place to stay 'ere.", SCHAR_MANCH, 0, metadata);
			}
			else if(Game->Counter[CR_STORYFLAG] <= SFLAG_ASHERKIDNAPPED){
				CopyStringToBuffer(buf, "Huh, it ain't common to see folks from outside here. Welcome to Malka. It ain't much, but it's home.", SCHAR_MANCH, 0, metadata);
				if(Game->Counter[CR_STORYFLAG] >= SFLAG_SHOALSOPEN){
					CopyStringToBuffer(buf, "I only ask you not judge us all based off Torrin.", SCHAR_MANCH, 0, metadata);
					CopyStringToBuffer(buf, "Aw come on, ain't I made up for that yet?", SCHAR_TORRIN, EMOTE_SWEAT, metadata);
					CopyStringToBuffer(buf, "You can't make up for bein' a fool, Torrin.", SCHAR_MANCH, 0, metadata);
				}
				else{
					CopyStringToBuffer(buf, "We're looking for someone who can read a sea chart. You wouldn't happen to be able to, would you?", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
					CopyStringToBuffer(buf, "I'm more than able to, but I'm tired a' tryin' to teach young folk like you. The sea knows I've wasted enough effort on Soren.", SCHAR_MANCH, 0, metadata);
					if(Game->Counter[CR_MISCSIDEQUEST] == 0){
						CopyStringToBuffer(buf, "Soren!?", SCHAR_ASHER, EMOTE_EXCLAMATION, metadata);
						CopyStringToBuffer(buf, "Oh, you must be Asher. He's mentioned ya before. He's in the house over that way, southwest a' here.", SCHAR_MANCH, EMOTE_NORMAL, metadata);
					}
					else{
						CopyStringToBuffer(buf, "I promise I'm a better listener than he is.", SCHAR_ASHER, 0, metadata);
						CopyStringToBuffer(buf, "Perhaps, but I'm a bit busy right now. Maybe later.", SCHAR_MANCH, EMOTE_NORMAL, metadata);
					}
				}
			}
			else if(Game->Counter[CR_STORYFLAG] < SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "Band's been askin' me to join him for some sorta operation. All seems a little dramatic to me. Maybe I'm just gettin' more outta touch with the young folks.", SCHAR_MANCH, 0, metadata);
			}
			
			break;
		case 43:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "Torrin... I'm sorry for being so harsh with you earlier.", SCHAR_TALCAY, 0, metadata);
				CopyStringToBuffer(buf, "It's nothin', Ma. Water under the house.", SCHAR_TORRIN, 0, metadata);
				CopyStringToBuffer(buf, "I do mean some of it though. I don't know what to think a' you anymore.", SCHAR_TALCAY, 0, metadata);
				CopyStringToBuffer(buf, "I'll settle for thinkin' a' me as someone who doesn't deserve his ears grabbed anymore.", SCHAR_TORRIN, EMOTE_HAPPY, metadata);
				CopyStringToBuffer(buf, "Promise me you're done makin' me worry about your safety every minute a' the day and maybe we'll have a deal.", SCHAR_TALCAY, 0, metadata);
			}
			else if(CanUseChar(CHAR_ASHER) > 0){
				CopyStringToBuffer(buf, "You... I recognize you, don't I?", SCHAR_TALCAY, 0, metadata);
				CopyStringToBuffer(buf, "We, uh... briefly met a few years ago.", SCHAR_ASHER, EMOTE_SWEAT, metadata);
				CopyStringToBuffer(buf, "Oh, I remember. You're the kid Torrin roped into his cart scheme. What are you doing here? Haven't you caused your mom enough anguish?", SCHAR_TALCAY, 0, metadata);
				CopyStringToBuffer(buf, "That was an isolated incident, I promise.", SCHAR_ASHER, EMOTE_SWEAT, metadata);
				CopyStringToBuffer(buf, "Yes, Torrin has that effect on people...", SCHAR_TALCAY, 0, metadata);
			}
			else{
				CopyStringToBuffer(buf, "Torrin, I have nothing more to say to you right now. Just go, before I regret letting you walk out of here with your hide intact.", SCHAR_TALCAY, EMOTE_ANGRY, metadata);
			}
			break;
		case 44:
			CopyStringToBuffer(buf, "How unexpected. We don't get many visitors this way. Welcome to Leipai's Lookout.", SCHAR_MERCHANT, 0, metadata);
			CopyStringToBuffer(buf, "Tell me, how'd the hike treat you?", SCHAR_MERCHANT, 0, metadata);
			CopyStringToBuffer(buf, "Eh, reckon we've had worse.", SCHAR_TORRIN, 0, metadata);
			CopyStringToBuffer(buf, "Wahaha! You are an interesting bunch. Few can handle that monster filled cave.", SCHAR_MERCHANT, 0, metadata);
			if(CanUseChar(CHAR_ASHER) > 0)
				CopyStringToBuffer(buf, "And not everybody has a magical gauntlet.", SCHAR_ASHER, 0, metadata);
			else
				CopyStringToBuffer(buf, "And not everybody has a magical gauntlet.", SCHAR_KAYLANI, 0, metadata);
			break;
		case 45:
			CopyStringToBuffer(buf, "Oh no, where did I put that thing? Don't tell me I left it behind back in Pala. Oh why do we store everything in jars?", SCHAR_MERCHANT, 0, metadata);
			break;
		case 46:
			CopyStringToBuffer(buf, "The nomad lifestyle isn't for everybody. When you're moving from place to place, you can't take anything for granted. I think I'll admire this scenery while I can.", SCHAR_MERCHANT, 0, metadata);
			break;
		case 47:
			CopyStringToBuffer(buf, "Someone has set up a shop in the shadow of the cliffside, on the monster infested side path. I can't imagine the locale is good for business.", SCHAR_MERCHANT, 0, metadata);
			break;
		case 48:
			CopyStringToBuffer(buf, "It's getting about time to move camp again. Really we've stayed here too long already.@26@26...", SCHAR_MERCHANT, 0, metadata);
			CopyStringToBuffer(buf, "I don't want to make that climb again.", SCHAR_MERCHANT, 0, metadata);
			break;
		case 49:
			CopyStringToBuffer(buf, "I tried stepping on that button, but it only lowered one of the pegs. What gives? I wanna get that shiny rock...", SCHAR_BOY, 0, metadata);
			if(Game->GetScreenState(9, 0x3A, ST_ITEM))
				CopyStringToBuffer(buf, "There was another button higher up? No faiiiir!", SCHAR_BOY, 0, metadata);
			break;
		case 50:
			if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_0)){
				PlayStringAndWaitForNPCs("Oh hello, I wasn't expecting company. My name's Laverne, botanist and astronomer.", SCHAR_LAVERNE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I've come here to study the exceptional fir trees of this island. This is one of the few places they can be found. What is it about this island, do you suppose, that makes them grow? The soil? The winds? I hope to find out!", SCHAR_LAVERNE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Oh, I had another project too that I was hoping someone might help me with. I have an augment I'd be willing to part with in exchange.", SCHAR_LAVERNE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("We could make time, if it's not too much trouble.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Excellent! There's a particular plant that grows on Wahiokala that I'm looking for. It is a white shrub with a single large, purple flower. It grows on the hillsides of the northern jungle. If you can find this shrub, I'd like if you could collect some clippings for me. I'd greatly appreciate it.", SCHAR_LAVERNE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				//PlayStringAndWaitForNPCs("Excellent! There's a particular plant that grows on Wahiokala that I'm looking for. It is a white shrub with a single large, purple flower. If you find this for me, I'd like if you could do two things. First, ensure no wildlife around it risks crushing it. Second, collect some clippings for me. I'd greatly appreciate it.", SCHAR_LAVERNE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_0;
				PopupNotify(3); //New Quest
				if(Game->Counter[CR_TORRINSIDEQUEST] != 2)
					return 1;
			}
			if(Game->Counter[CR_TORRINSIDEQUEST] == 2 && !(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_14)){
				PlayStringAndWaitForNPCs("'scuse me miz, did you know there were two kids campin' out on the island?", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Zeke and Caiman? Yes, of course. Why?", SCHAR_LAVERNE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("They're, uh... not exactly s'posed to be here.", SCHAR_TORRIN, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Oh my, I'm terribly sorry, I had no idea. They assured me they'd obtained permission to travel.", SCHAR_LAVERNE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("'course they'd say that. Dammit Caiman, you're learnin' too fast.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_14;
				return 1;
			}
			if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_1)){
				PlayStringAndWaitForNPCs("Remember, you're looking for a white shrub with a single large, purple flower that grows in the northern Wahiokala jungles. The hillsides are pretty steep, so you might want to look for another path up there. I'd greatly appreciate it if you could collect some clippings for me.", SCHAR_LAVERNE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				//PlayStringAndWaitForNPCs("Remember, you're looking for a white shrub with a single large, purple flower that grows on Wahiokala. If you find this for me, I'd like if you could do two things. First, ensure no wildlife around it risks crushing it. Second, collect some clippings for me. I'd greatly appreciate it.", SCHAR_LAVERNE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_2)){
				PlayStringAndWaitForNPCs("We found the shrub you talked about. Here's the clippings you asked for.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Oh, these are what I'm looking for. Thank you so much! Here, take this augment.", SCHAR_LAVERNE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				AugmentGet(198);
				Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_2;
				return 1;
			}
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_2){
				PlayStringAndWaitForNPCs("Conifers are fascinating to me. Supposedly they dominate in the far south, where the temperature grows too cold for other trees to thrive, yet here in our islands, they seem to take root in very specific biomes. What is it about these places that encourage their growth, I wonder?", SCHAR_LAVERNE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
		case 51:
			CopyStringToBuffer(buf, "Welcome to the pouch shop. Here you can buy extra pouches to hold all sorts of things.", SCHAR_MANBOOK, 0, metadata);
			break;
		case 52:
			if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_3)){
				PlayStringAndWaitForNPCs("Oh, hey Kaylani...", SCHAR_TRUF, EMOTE_SAD, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("What's wrong?", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I lost my dad's necklace. It was the only thing I had left of his.", SCHAR_TRUF, EMOTE_SAD, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Oh, is that all? That won't be a problem. We'll help ya find it!", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("You will?", SCHAR_TRUF, EMOTE_SURPRISED, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("'course! It ain't right for someone to be separated from a memento like that.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("We are a bit busy though. Could you help us a bit? When did you see it last?", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I had it with me yesterday. First, I raced Lily all around the islands in the village. Then, I went through the cave to the volcano. I rested at a hot spring, then went climbing on some rock piles. I fell into the ocean, but scrambled back up the cliff wall. Then I climbed up to the base of Mauna Ali'i, and laid down in the tall grass up there. Then, I rolled down the hill towards the jungle, but stopped before I got too far down. When I got back home, I realized I wasn't wearing the necklace anymore.", SCHAR_TRUF, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("That is... a lot of ground to cover.", SCHAR_ASHER, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("But don't worry! We'll find it!", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_3;
				PopupNotify(3); //New Quest
				return 1;
			}
			if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_4)){
				if(Link->Item[207]){
					PlayStringAndWaitForNPCs("Guess what we've got.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("You found it! Where was it!?", SCHAR_TRUF, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("It was under a pile a' rocks. Nothin' a little explosive won't take care a' though.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Wow! That's amazing! You're really cool for not having magic!", SCHAR_TRUF, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("It's all 'bout makin' use a' the tools you have.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Oh right, you've got some of that magic in a bottle stuff. Here, take this augment! It oughta let you fire a different kind of solar magic.", SCHAR_TRUF, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Aw, thanks! I can think of all sorts a' fun to get into with this.", SCHAR_TORRIN, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Alright, let's get going before you corrupt the youth here too.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					AugmentGet(195);
					Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_4;
					ffc NewFFC = FindFreeFFC();
					NewFFC->X = this->X;
					NewFFC->Y = this->Y-16;
					NewFFC->TileHeight = this->TileHeight;
					NewFFC->Data = 33628;
					NewFFC->Script = 38;
					NewFFC->InitD[0] = 52;
					NewFFC->InitD[1] = 45;
					this->Data = 0;
					Quit();
					return 1;
				}
				else{
					PlayStringAndWaitForNPCs("Could you remind us where you went the day you lost the necklace?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Sure! First, I raced Lily all around the islands in the village. Then, I went through the cave to the volcano. I rested at a hot spring, then went climbing on some rock piles. I fell into the ocean, but scrambled back up the cliff wall. Then I climbed up to the base of Mauna Ali'i, and laid down in the tall grass up there. Then, I rolled down the hill towards the jungle, but stopped before I got too far down. When I got back home, I realized I wasn't wearing the necklace anymore.", SCHAR_TRUF, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Right. In the future, maybe you shouldn't cross the whole island by yourself...", SCHAR_ASHER, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
					return 1;
				}
			}
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_4){
				PlayStringAndWaitForNPCs("Your new friends are really cool, Kaylani!", SCHAR_TRUF2, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I suppose they are, aren't they?", SCHAR_KAYLANI, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I think he mostly means you, Torrin.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Nah, you're cool too. I've never seen someone whose skin is that pale!", SCHAR_TRUF2, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("... I think I liked being lame better.", SCHAR_ASHER, EMOTE_ELLIPSES, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
		case 53:
			CopyStringToBuffer(buf, "What business do you have with Lord Igorevich's home? Scram!");
			break;
		case 54:
			if(Screen->D[0] == 0){
				PlayStringAndWaitForNPCs("Ah, travelers. I believe we may be able to help each other out. I am a cartographer.", SCHAR_CARTOGRAPHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("A what now?", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("A mapmaker. I spend my time traveling the islands, documenting what I can.", SCHAR_CARTOGRAPHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("That's cool, but I've actually been scribbling pretty good maps of everywhere we've traveled.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Oh, but my maps are special. Using my sunseeker magic, I've been able to chart out the location of Hymnstones.", SCHAR_CARTOGRAPHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Now THAT could be useful.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Indeed. They may not reveal secret rooms, but they will allow you to track the number and location of Hymnstones on your map. I have several you might be interested in.", SCHAR_CARTOGRAPHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				Screen->D[0] = 1;
			}
			else{
				PlayStringAndWaitForNPCs("Back again to peruse my maps?", SCHAR_CARTOGRAPHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
			}
			MapShop();
			PlayStringAndWaitForNPCs("If you're in need of maps, you know where to find me.", SCHAR_CARTOGRAPHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
			return 1;
		case 55:
			if(Game->Counter[CR_CULTISTQUEST]<3){
				CopyStringToBuffer(buf, "Scram, kid! We're doing important...um...archeological work.", SCHAR_LUNARCULTIST, 0, metadata);
				break;
			}
			else if(Game->Counter[CR_CULTISTQUEST]==3){
				PlayStringAndWaitForNPCs("The inspection of the site is already underway. What brings you here, brother?", SCHAR_LUNARCULTIST, EMOTE_QUESTION, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Orders from the big man. He says we need more manpower in order to secure the target.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("He must be getting impatient. Right this way.", SCHAR_LUNARCULTIST, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
				Game->Counter[CR_CULTISTQUEST] = 4;
				return 1;
			}
			else{
				PlayStringAndWaitForNPCs("Right this way.", SCHAR_LUNARCULTIST, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
		case 56:
			if(Game->Counter[CR_CULTISTQUEST]==0){
				PlayStringAndWaitForNPCs("Hey! Aren'tcha one o' Selet's lackeys? You've got a lotta nerve comin' here after what you lot put Kaylani through-", SCHAR_TORRIN, EMOTE_FURIOUS, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Wait! Don't hurt me! I'm not with them! Technically...", SCHAR_UNMASKEDCULTIST, EMOTE_SURPRISED, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("...Micah? Is that you?", SCHAR_KAYLANI, EMOTE_QUESTION, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("Yeah...I was hoping nobody would recognize me like this. I can't show my face around here after everything that's happened.", SCHAR_MICAH, EMOTE_SAD, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("Explain yourself. Why are you dressed like one of Selet's henchmen? And why did you disappear? Your sister has been worried sick!", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("It's a long story. You know my family hasn't been well off recently. Mom's been real sick, sis has been having trouble supporting her. You and everyone else have been doing everything you can to help, but I couldn't stand living off that good will. So I thought I'd go to Pala to find work.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("A friend there got me a job with Selet Shipping. It paid well, everything was going splendid...then I learned. I started being given extra tasks, discovered Selet was working with pirates...But the pay was just too tempting.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("I...I see...", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("I swear I didn't know. I had no clue they were behind your kidnapping. Not until you returned to us. And all this time I haven't been able to live with the guilt. That's why I left. I only came back to leave the money for mom's treatment. You think sis would accept it if she knew what I'd done?", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("So ya screwed up. Ya made your mistakes. What're ya thinkin' of doin' now?", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("I have to make it right. I'm gonna quit, but not before throwing a wrench into Selet's plans. One last sabotage.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("Hey, who doesn't love a good sabotage? Give us the details.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("Selet sent some of his men to Wahiokala to search for something. There's an old astronomer treasure buried in the ruins on the other side of the island. Whatever he's up to he needs that treasure for it, but I'm going to join the search and get to it first. He'll never get his hands on it.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("Let us come along too then. If it's inconveniencing Selet, I'm all about it.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("Count me in. I've been itchin' to bash some Selet lackey skulls.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("I'll help as well. There's no stopping these two when they set their minds to something.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("The three of you are too kind. It's more than I deserve. But we can't jump in recklessly. You'll need to come in disguise. Collect a solar, lunar, and stellar mask from Selet's lackeys. Finding a stellar mask may be tricky, but there's probably one keeping guard around the dig site. Then meet me on the west side of the island.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				Game->Counter[CR_CULTISTQUEST] = 1;
				PopupNotify(3); //New Quest
				return 1;
			}
			else if(Game->Counter[CR_CULTISTQUEST]==1){
				PlayStringAndWaitForNPCs("Have you got the solar, lunar, and stellar masks?", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("Not yet. How do we get them again?", SCHAR_ASHER, EMOTE_QUESTION, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("Selet's lackeys should be wearing them. Just gotta yank them off.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				PlayStringAndWaitForNPCs("The Tidal Gauntlet should prove helpful for that.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);	
				return 1;
			}
			else if(Game->Counter[CR_CULTISTQUEST]==2){
				PlayStringAndWaitForNPCs("Great. With four of us in uniform it'll be much easier to get inside.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Put on your disguises and let's get going.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				G[G_ASHERCOSTUME] = 1;
				G[G_TORRINCOSTUME] = 1;
				G[G_KAYLANICOSTUME] = 1;
				Costumes_Update();
				Game->Counter[CR_CULTISTQUEST] = 3;
				return 1;
			}
			else if(Game->Counter[CR_CULTISTQUEST]==3){
				PlayStringAndWaitForNPCs("The entrance is just over this way.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			else if(Game->Counter[CR_CULTISTQUEST]==4){
				switch(GetCharID()){
					case CHAR_ASHER:
						PlayStringAndWaitForNPCs("Is that you, Asher? Wow, I almost didn't recognize you. Though you could probably fix your posture some. You're disguised as a high ranking officer after all.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
						break;
					case CHAR_TORRIN:
						PlayStringAndWaitForNPCs("Is that you, Torrin? Wow, almost didn't recognize you. You're really taking the disguise seriously, huh?", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
						break;
					case CHAR_KAYLANI:
						PlayStringAndWaitForNPCs("Is that you, Kaylani? Actually I could tell right away. You always twirl your hair when you're nervous. The disguises are working great though! Nobody else has caught on.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
						break;
				}
				PlayStringAndWaitForNPCs("Check it out, I've found a secret passage deeper into the temple that Selet's goons seem to have overlooked. They're planning to blast their way in, so we need to hurry.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
		case 57:
			CopyStringToBuffer(buf, "No sign of the those kids the boss warned us about yet. Keep vigilant though.", SCHAR_LUNARCULTIST, 0, metadata);
			break;
		case 58:
			CopyStringToBuffer(buf, "I'm not being paid enough to sit out in the rain like this.@pressa()@26@26...But then again I'm not not NOT being paid enough to quit.", SCHAR_SOLARCULTIST, 0, metadata);
			break;
		case 59:
			CopyStringToBuffer(buf, "Nothing to report here.", SCHAR_LUNARCULTIST, 0, metadata);
			break;
		case 60:
			CopyStringToBuffer(buf, "I'm almost done setting the explosives. Stand back a bit please.", SCHAR_STELLARCULTIST, 0, metadata);
			break;
		case 61:
			CopyStringToBuffer(buf, "It's my first day as a Lunar Mask. Who knew tomb raiding came with the territory.", SCHAR_LUNARCULTIST, 0, metadata);
			break;
		case 62:
			if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_5)){
				PlayStringAndWaitForNPCs("Oh, I'm sorry, I didn't hear you come in. Welcome to Hoku Village's unofficial green house.", SCHAR_NAMAUH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_0){
					PlayStringAndWaitForNPCs("I would've expected Laverne to take care of a place like this.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Oh, you met Laverne? She's my partner in crime. I'm helping take care of the plants here while she's out.", SCHAR_NAMAUH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				}
				PlayStringAndWaitForNPCs("What's growing out of that weird spiky plant?", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("This is one of my favorites. It's a Mauna Ali'i Silversword. They only grow on the high slops of Mauna Ali'i. When it's time to blossom, a new plant grows from the center, and flowers bloom from it.", SCHAR_NAMAUH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("There used to be several related species on other islands, but human actions have slowly driven them to extinction. It's a shame.", SCHAR_NAMAUH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Is it? They're kinda freaky lookin'...", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				// PlayStringAndWaitForNPCs("There used to be several related species on other islands, but Laverne tells me she hasn't seen any in a long time. If you ever run across one, I'd very much appreciate if you could let me know.", SCHAR_NAMAUH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				// PlayStringAndWaitForNPCs("Seems like an easy enough plant to spot. You got it.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_5;
				return 1;
			}
			else{
				PlayStringAndWaitForNPCs("Why'd you make this of all houses into a greenhouse?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Oh, that wasn't my decision. The woman who lived here before put all the plants here originally. She was a brilliant scholar and fiece warrior. And then... well, she developed a lot of eccentricities before she left us.", SCHAR_NAMAUH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			// if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_6)){
				// PlayStringAndWaitForNPCs("Thinking about how many species have gone extinct makes me feel really sad. I'd like to believe there are other Silverswords out there, somewhere. Please keep an eye out for them on your travels.", SCHAR_NAMAUH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				// return 1;
			// }
			// if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_6)){
				// PlayStringAndWaitForNPCs("Good news! We found the plant. Ain't exactly silver, but definitely the same kinda plant.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				// PlayStringAndWaitForNPCs("I'm so relieved to hear other Silversword species still exist. Thank you so much. It's not much, but I'd like if you took this as a token of my appreciations.", SCHAR_NAMAUH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				// AugmentGet(201);
				// Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_6;
				// return 1;
			// }
			// if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_6){
				// PlayStringAndWaitForNPCs("My forerunners spoke of several species of wildflower that grew on the slopes of Pala Bay. None of those remain anymore, with all the construction as of late. I fear what the continued development of the islands will do for their fragile ecosystems.", SCHAR_NAMAUH, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				// return 1;
			// }
			break;
		case 63:
			CopyStringToBuffer(buf, "In days gone by, being Portmaster for the Astronomers was a big responsibility. Now, it feels like a whole lot of nothing. We've turned inwards on ourselves too much, I fear.", SCHAR_NIMO, 0, metadata);
			CopyStringToBuffer(buf, "The job's also been a lot more dull since my neighbor up the hill left. She was an interesting one. Near the end though, she got a little...@delay(120)@26@26Well, we don't talk about her much anymore.", SCHAR_NIMO, 0, metadata);
			CopyStringToBuffer(buf, "At least shipping out provisions to the team confronting the pirates gives me something to do.", SCHAR_NIMO, 0, metadata);
			break;
		case 64:
			CopyStringToBuffer(buf, "Welcome to the Hoku Augment shop. I heard you've got your hands on some stellar magic somehow. I've got some augments for stellar magic I've been hoping to try out for some time. Care to take a look?");
			break;
		case 65:
			if(Game->Counter[CR_NIGHTMARCHERQUEST] == 2){
				PlayStringAndWaitForNPCs("Lilah, is your brother around?", SCHAR_KAYLANI, 0, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Here to pretend you're studying with him so you can give him that dopey-eyed look again?", SCHAR_LILAH, 0, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("E-excuse me? I think you have the wrong idea.", SCHAR_KAYLANI, EMOTE_EXCLAMATION, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("If you say so. No, he's not here. He made sure everyone who got hurt was alright, then went right back to Kohiko. Muttered something about ruins there.", SCHAR_LILAH, 0, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Of course he'd be drawn by those ruins. Thanks.", SCHAR_KAYLANI, 0, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("If you see him, tell him he still owes me the first magic artifact he finds.", SCHAR_LILAH, 0, 68, 24, cmb, til, cs, flags, flip, this);
				Game->Counter[CR_NIGHTMARCHERQUEST]  = 3;
				return 1;
			}
			else
				CopyStringToBuffer(buf, "Mom and Dad are both fighting the pirates right now. I hope they come back soon. I miss them.", SCHAR_LILAH, 0, metadata);
			break;
		case 66:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_MISTENTERED && Game->Counter[CR_STORYFLAG] < SFLAG_GAMECLEAR)
				CopyStringToBuffer(buf, "With Nell gone, I've been moved from town defense to cooking. You'd think that would be the easier job, but somehow I feel way more exhausted churning out enough food to keep the pirate assault teams going. I don't know how Nell does this.");
			else
				CopyStringToBuffer(buf, "Winno has me stationed here for defense so I can take care of Truf while my husband is part of the team fighting the pirates. I appreciate the gesture, but it's still exhausting work, so I've been coming here to eat instead of cooking myself.");
			break;
		case 67:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "How are you holding up, Nell?", SCHAR_KAYLANI, 0, metadata);
				CopyStringToBuffer(buf, "Well, I'm not eager to see mist again any time soon, but I don't feel any worse for the wear. And with so much of the astronomers still out and about, cleaning up this whole mess, there's plenty of cooking to be done.", SCHAR_NELL, 0, metadata);
			}
			else
				CopyStringToBuffer(buf, "They say an army marches on its stomach for a reason. I've been running myself ragged cooking enough for the village guard and packing enough provisions for Nimo to sail out to the attack teams.");
			break;
		case 68:
			CopyStringToBuffer(buf, "Come on Band, surely you see what's going on.", SCHAR_ALLIE, 0, metadata);
			CopyStringToBuffer(buf, "I admit, the pirate attacks seem strange. But false flags to turn us against each other? That seems like a lot of effort.", SCHAR_BAND, 0, metadata);
			CopyStringToBuffer(buf, "Something is going on. That much is clear in the stars. The ships attacking us have been masquerading as Malka vessels. Someone is trying to drive our people apart, and that's more than reason for us to ally, in my mind.", SCHAR_ALLIE, 0, metadata);
			CopyStringToBuffer(buf, "It's possible, I suppose. Look, I'll talk to Skai an' Manch 'bout it. But I can't promise anything.", SCHAR_BAND, 0, metadata);
			CopyStringToBuffer(buf, "I don't need promises. Just alertness. Something is happening, and we all should be prepared.", SCHAR_ALLIE, 0, metadata);
			break;
		case 69:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_MISTENTERED && Game->Counter[CR_STORYFLAG] < SFLAG_GAMECLEAR)
				CopyStringToBuffer(buf, "With Nell gone, Truf's Mom is doing the cooking. But she takes even longer than Nell! Why isn't it done yet?");
			else
				CopyStringToBuffer(buf, "Why isn't it meal time yet? It smells so good but Nell won't let us in til it's done. Her cooking's so much better than Mom's.");
			break;
		case 70:
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "Hello, Mort. How's it going?", SCHAR_KAYLANI, 0, metadata);
				CopyStringToBuffer(buf, "Things are uneventful, and I certainly don't mind that. The torches are still giving me trouble, but after everything, I'm taking a break for a bit. I don't get how Allie can keep going the way she is after sustaining as many injuries as she did.", SCHAR_MORT, 0, metadata);
				CopyStringToBuffer(buf, "Huh, come to think of it, I ain't seen Band around Malka recently either. Those two up to somethin' together?", SCHAR_TORRIN, 0, metadata);
				if(Game->Counter[CR_CULTISTQUEST] == 6)
					CopyStringToBuffer(buf, "Yeah, they're up on Mauna Ali'i, doing some investigating. Micah's poking around up there as well.", SCHAR_MORT, 0, metadata);
				else
					CopyStringToBuffer(buf, "Yeah, they're up on Mauna Ali'i, doing some investigating.", SCHAR_MORT, 0, metadata);
				CopyStringToBuffer(buf, "Looking for Selet's corpse?", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "Looking for a reason why there isn't one. Allie's thinking the same thing as you, Kaylani.", SCHAR_MORT, 0, metadata);
				CopyStringToBuffer(buf, "And you?", SCHAR_KAYLANI, 0, metadata);
				CopyStringToBuffer(buf, "There's no way anyone could survive a fall like that, not even a mage like him. His body's probably just rolled into a crevice somewhere. But his ghost will have us jumping at shadows for years, now.", SCHAR_MORT, 0, metadata);
				CopyStringToBuffer(buf, "I wish I could be as confident about that as you are...", SCHAR_KAYLANI, EMOTE_ELLIPSES, metadata);
				CopyStringToBuffer(buf, "If you're so worried, you can join them in looking around up there. Maybe you'll be able to turn up some sign of him.", SCHAR_MORT, 0, metadata);
			}
			else
				CopyStringToBuffer(buf, "These torches have been giving me far too much trouble recently. They're supposed to light themselves at night, but they're not going out in the morning right sometimes. This should be such a simple contraption. Just a bit of solar magic and a timer. And yet...");
			break;
		case 71:
			CopyStringToBuffer(buf, "We're keeping a careful watch on the village around the clock. I've seen a suspicious figure around the cave entrance at night, but he vanishes when I get close.");
			break;
		case 72:
			CopyStringToBuffer(buf, "You don't think these ruins could be h-h-haunted, right? Something just touched my shoulder! Aagh!", SCHAR_SOLARCULTIST, 0, metadata);
			break;
		case 73:
			CopyStringToBuffer(buf, "Sounds like it's almost go time. I just can't sit still.", SCHAR_SOLARCULTIST, 0, metadata);
			break;
		case 74:
			CopyStringToBuffer(buf, "The astronomers don't seem to have noticed our presence yet. Looks like the operation's going smoothly.", SCHAR_LUNARCULTIST, 0, metadata);
			break;
		case 75:
			if(Game->Counter[CR_GOLEMSIDEQUEST] == 0){
				PlayStringAndWaitForNPCs("Oh, hello there. Don't mind me, I'm just-", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				if(Game->Counter[CR_STORYFLAG] <= SFLAG_POSTGRANDMA){
					PlayStringAndWaitForNPCs("Kaylani!? You're okay! What happened!?", SCHAR_SIYED, EMOTE_EXCLAMATION, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I had a run in with pirates. It was... well, they got the better of me, but I'm okay now.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("It's hard to imagine anything getting the better of you. Have you stopped by Hoku yet?", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Not yet. I can't go back now. My capture's left solar magic in the wrong hands. I can't face the others until I've fixed this. I was hoping I wouldn't have to face anyone until then...", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("... I don't agree with your decision, but I know better than to fight you on it. You've got that look.", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Any chance you're gonna introduce us to your friend, Kaylani?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Right, of course. This is Siyed. He and I grew up together. Siyed, this is Asher and Torrin. They're helping me.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Pleasure ta meet ya. Whatcha doin' in a place like this?", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Well, I was hoping to get inside the ruins and explore a bit, but I can't seem to find a way inside. I found a key, but there's no lock anywhere on this door.", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Sounds like the kind of thing we're used to. Want us to find a way in and see if this door'll budge from the other side?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("If you can find a way in, be my guest. Here's the key I found.", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				}
				else{
					PlayStringAndWaitForNPCs("Oh, it's you three! Glad to see you're all still in one piece.", SCHAR_SIYED, EMOTE_EXCLAMATION, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("As if a bunch a' cultists could stop us. What about you though? Whatcha doin' in a place like this?", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Well, I was hoping to get inside the ruins and explore a bit, but I can't seem to find a way inside. I found a key, but there's no lock anywhere on this door.", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Sounds like the kind of thing we're used to. Want us to find a way in and see if this door'll budge from the other side?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("If you can find a way in, be my guest. Here's the key I found.", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				}
				Game->LKeys[Game->GetCurLevel()]++;
				Game->Counter[CR_GOLEMSIDEQUEST] = 1;
				Game->PlaySound(70);
				PopupNotify(3); //New Quest
				return 1;
			}
			else if(Game->Counter[CR_GOLEMSIDEQUEST] == 1){
				PlayStringAndWaitForNPCs("I hope the key still works. I thought I found a keyhole on this door and tried to get it to budge. Turns out it was just a crack in the stone. The key doesn't seem TOO bent out of shape though.", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			else if(Game->Counter[CR_GOLEMSIDEQUEST] == 2){ 
				if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_7)){
					PlayStringAndWaitForNPCs("Sorry if this is a weird question, but what was with you saying you're useless? Seems to me like you did a great job finding this place.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Well... Kaylani's grandmother tried to raise the two of use to be fighters and leaders. Worked out great for her. But there's a reason Kay gets sent out on missions while her grandmother keeps me stationed in Hoku.", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("That's not the reason at all. It's not like I'm any better. You beat me at sparring all the time.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I know you threw those fights to make me feel good, Kay. It was nice... but I'm not a fool.", SCHAR_SIYED, EMOTE_SAD, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Regardless... Maybe I can't fight, but I'm done being useless. I figured out where those records were talking about, and now we're here. I'm gonna learn everything I can from this place.", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_7;
				}
				else
					PlayStringAndWaitForNPCs("A lot of the writing's faded, but I think these inscriptions are talking about the Calamity. I need to record all of this, in case any of it is new information for us.", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			else if(Game->Counter[CR_GOLEMSIDEQUEST] == 3){
				PlayStringAndWaitForNPCs("Good luck! I'll be watching from behind this pillar. Maybe I can help if you get hurt.", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			break;
		case 76:
			CopyStringToBuffer(buf, "I'm sorry, do you have some business with me? If not, please leave my home at once!");
			break;
		case 77:
			if(Game->Counter[CR_MISCSIDEQUEST] == 1 && CanUseChar(CHAR_ASHER)){
				PlayStringAndWaitForNPCs("Let me guess, you're looking for the girl, aren't you?", SCHAR_MANREDSHORTS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("She's, uh... usually here around this time to play your piano.", SCHAR_ASHER, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I'm aware. Calling her family dysfunctional is being generous, so I usually try to stay out and let her sneak in to play. But I haven't seen her in several days.", SCHAR_MANREDSHORTS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Not at all? Not even in her own home?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Not since a few days ago. I hurt my back lifting boxes and had to stay home for a while. I offered to let her play it while I'm here, but she said she only plays when nobody can watch her. I haven't seen her since then. I hope she's alright. It's sorry enough that their older son vanished. Now they have to deal with this too.", SCHAR_MANREDSHORTS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				Game->Counter[CR_MISCSIDEQUEST] = 2;
				return 1;
			}
			else if(Game->Counter[CR_MISCSIDEQUEST] == 2 || Game->Counter[CR_MISCSIDEQUEST] == 3 && CanUseChar(CHAR_ASHER)){
				PlayStringAndWaitForNPCs("The girl likes to sneak into houses and play the piano. Maybe she found a different piano to use?", SCHAR_MANREDSHORTS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			else if(Game->Counter[CR_MISCSIDEQUEST] == 8){
				CopyStringToBuffer(buf, "I'm glad the issues next door seem to have been resolved. I wish I had the money to install a door to the balcony they built, but ah well.");
			}
			else
				CopyStringToBuffer(buf, "I strained my back lifting cargo the other day. They say it might take weeks to heal. I hope the portmaster doesn't cut my wages...");
			break;
		case 78:
			if(!CanUseChar(CHAR_ASHER)){
				CopyStringToBuffer(buf, "Torrin. I believe I've made my thoughts on your company clear.", SCHAR_WOMANGREENSKIRTOUTFIT2, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "I know, I know. This ain't 'bout that though. Asher's... missin'. You haven't seen 'im, have you?", SCHAR_TORRIN, EMOTE_SWEAT, metadata);
				CopyStringToBuffer(buf, "Oh... no, I can't say I have. I hope he's alright.", SCHAR_WOMANGREENSKIRTOUTFIT2, EMOTE_SAD, metadata);
			}
			if(Game->Counter[CR_MISCSIDEQUEST] >= 1 && Game->Counter[CR_MISCSIDEQUEST]<= 10 && CanUseChar(CHAR_ASHER)){
				CopyStringToBuffer(buf, "I don't suppose you've seen Misty? It's not unheard of for her to slip away from home for a while, but with Soren being missing... I just worry.");
			}
			break;
		case 79:
			if(!CanUseChar(CHAR_ASHER)){
				CopyStringToBuffer(buf, "Torrin! Are you out there doing good in the world?", SCHAR_BOYGREENSHORTS, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Tryin', mate. Not succeeedin' all that much though...", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Oh. Well, I hope it starts going better for you!", SCHAR_BOYGREENSHORTS, EMOTE_NORMAL, metadata);
			}
			if(Game->Counter[CR_MISCSIDEQUEST] >= 1 && Game->Counter[CR_MISCSIDEQUEST] <= 10 && CanUseChar(CHAR_ASHER)){
				CopyStringToBuffer(buf, "First Soren, now Misty. I hope I don't go missing next...");
			}
			break;
		case 80:
			CopyStringToBuffer(buf, "Stop right there. What business d'ya have at Villa Tulane?", SCHAR_PIRATE, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "What business do YOU have? Ain't you one of the pirates?", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Madame Tulane is employing us as her private security force. So scram, 'less you wanna end up with a knife in yer gut.", SCHAR_PIRATE, EMOTE_NORMAL, metadata);
			break;
		case 81:
			CopyStringToBuffer(buf, "Soren bought me a piano! It's so wonderful!", SCHAR_MISTY, EMOTE_HAPPY, metadata);
			break;
		case 82:
			if(!CanUseChar(CHAR_ASHER)){
				CopyStringToBuffer(buf, "Torrin! Are you out there doing good in the world?", SCHAR_BOYGREENSHORTS, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Tryin', mate. Not succeeedin' all that much though...", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Oh. Well, I hope it starts going better for you!", SCHAR_BOYGREENSHORTS, EMOTE_NORMAL, metadata);
			}
			CopyStringToBuffer(buf, "I knew you were a hero, Torrin! You brought Soren back!", SCHAR_BOYGREENSHORTS, EMOTE_HAPPY, metadata);
			CopyStringToBuffer(buf, "Me? Ash did most of the work there, mate.", SCHAR_TORRIN, EMOTE_SURPRISED, metadata);
			if(CanUseChar(CHAR_ASHER)){
				CopyStringToBuffer(buf, "Don't bother reasoning with him. He clearly idolizes you.", SCHAR_ASHER, 0, metadata);
			}
			break;
		case 83:
			if(CanUseChar(CHAR_ASHER)){
				CopyStringToBuffer(buf, "Well Asher, I knew you were worried about Soren, but I never thought you'd track him down.", SCHAR_WOMANGREENSKIRTOUTFIT2, 0, metadata);
				CopyStringToBuffer(buf, "It wasn't much trouble. Misty was the harder one to find...", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "I wish they wouldn't keep running off, but I'm so glad they're both safe.", SCHAR_WOMANGREENSKIRTOUTFIT2, 0, metadata);
				CopyStringToBuffer(buf, "So... does that mean Soren's not in trouble?", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "Oh he's in for the lecture of his life as soon as I get over how happy I am he's alive.", SCHAR_WOMANGREENSKIRTOUTFIT2, 0, metadata);
			}
			else{
				CopyStringToBuffer(buf, "Well Torrin, I guess I have to admit you're not ONLY a bad influence. Seems like my kids have a knack for getting themselves into trouble all on their own, and I appreciate your help in bringing them back.", SCHAR_WOMANGREENSKIRTOUTFIT2, 0, metadata);
				CopyStringToBuffer(buf, "Of course, it was nothin'.", SCHAR_TORRIN, 0, metadata);
				CopyStringToBuffer(buf, "With that said, please don't drag any of them into any more trouble.", SCHAR_WOMANGREENSKIRTOUTFIT2, 0, metadata);
				CopyStringToBuffer(buf, "I'll do my best, but it has a habit a' followin' me recently.", SCHAR_TORRIN, 0, metadata);
			}
			break;		
		case 84:
			if(G[G_SORENATTEMPLE] == 1 && Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "Hey, I never really got the chance to say thanks for all the help. If you hadn't shown up when you did-", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "Don't mention it, Asher. Just doing what I can to help. What happened to that rich bastard after you split off?", SCHAR_SORENPANTS, 0, metadata);
				CopyStringToBuffer(buf, "Well, we beat him, but he's missing now. Should be dead, but I got a bad feeling...", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "Well hey, whenever he shows up, you let me know and I'll come running. Stay safe out there, man.", SCHAR_SORENPANTS, 0, metadata);
			}
			else if(CanUseChar(CHAR_ASHER)){
				CopyStringToBuffer(buf, "I got the house all renovated, and even got this balcony installed. Everything worked out in the end. Thanks Asher, I really owe ya one.", SCHAR_SORENPANTS, 0, metadata);
			}
			else{
				CopyStringToBuffer(buf, "I got the house all renovated, and even got this balcony installed. Everything worked out in the end.", SCHAR_SORENPANTS, 0, metadata);
			}
			break;
		case 85:
			if(!(Game->Counter[CR_MISTFLAGS] & BF_1) && !(Game->Counter[CR_MISTFLAGS] & BF_3) && !(Game->Counter[CR_MISTFLAGS] & BF_4) && !(Game->Counter[CR_MISTFLAGS] & BF_5)){
				CopyStringToBuffer(buf, "How's the door coming along?", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "I'm making progress, but it's gonna be a while still. The mechanism here is way more complex than I thought it would be.", SCHAR_SIYED, 0, metadata);
			}
			else if(Game->Counter[CR_MISTFLAGS] & BF_1 && Game->Counter[CR_MISTFLAGS] & BF_3 && Game->Counter[CR_MISTFLAGS] & BF_4 && Game->Counter[CR_MISTFLAGS] & BF_5){
				CopyStringToBuffer(buf, "Be careful up there...", SCHAR_SIYED, EMOTE_SAD, metadata);
			}
			else{
				CopyStringToBuffer(buf, "How's it going?", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "It's slow work. Everyone's injuries aren't as bad as I worried, but it's still time-consuming to treat them. I'm worried I might not be able to get this door open any time soon.", SCHAR_SIYED, 0, metadata);
				CopyStringToBuffer(buf, "I trust you on this, Siyed. If anyone can get us a way out, it's you.", SCHAR_KAYLANI, 0, metadata);
				CopyStringToBuffer(buf, "Heh... I'll try my best.", SCHAR_SIYED, EMOTE_NORMAL, metadata);
			}
			break;
		case 86:
			CopyStringToBuffer(buf, "Get out. You've caused me enough trouble already.");
			break;
		case 87:
			CopyStringToBuffer(buf, "Have you ever noticed weird markings on the walls by water? Or oddly colored trees at the shore of a pond? I've found that strange relics are often hidden underwater at places where out of place markings intersect. Did somebody hide them at those locations? Or did the relics warp the world around them? That question keeps me up at night, sometimes.");
			break;
		case 88:
			if(Game->Counter[CR_STORYFLAG] <= SFLAG_WAREHOUSE){
				CopyStringToBuffer(buf, "Those groceries aren't going to get themselves, Asher. Hop to it.", SCHAR_MOM, 0, metadata);
			}
			else if(Game->Counter[CR_STORYFLAG] == SFLAG_ASHERKIDNAPPED){
				CopyStringToBuffer(buf, "I hope Asher's doing alright. I worry about him...", SCHAR_MOM, 0, metadata);
			}
			else if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "Take care out there, Asher. And please... don't leave for several days again without telling me. I get that you feel like you're shouldering a lot of responsibility, but you can always talk to me, okay?", SCHAR_MOM, 0, metadata);
			}
			else{
				if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_8){
					PlayStringAndWaitForNPCs("Are you ready to come home, yet?", SCHAR_MOM, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Not yet. There's... something I still need to do.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I understand. If you ever want to talk, I'm here for you, Asher.", SCHAR_MOM, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					return 1;
				}
				else{
					PlayStringAndWaitForNPCs("Asher, you're back. I wasn't expecting to see you again so soon. Iris told me what happened.", SCHAR_MOM, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Uh... what all did she tell you?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Enough. I'm so sorry, Asher. I should've thought more about how you felt. I knew your friend Soren was missing, but I didn't stop to think about how that would impact you.", SCHAR_MOM, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Oh. Yeah, it's... it's been weighing on me.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I wish you'd talked to me about it instead of running off during a grocery trip, but I get it. You're at that age where you want your space. And I'm glad to see you have some new friends. Take whatever time you need. Just... promise me you're staying safe out there.", SCHAR_MOM, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("As safe as I can be. Thanks for understanding.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_8;
					return 1;
				}
			}
			break;
		case 89:
			if(G[G_RANDOMIZERENABLED]){
				if(!Screen->State[ST_ITEM]){
					CopyStringToBuffer(buf, "Oh! You over there!", SCHAR_ZARATH, EMOTE_SURPRISED, metadata);
					if(G[G_SHIRT + GetCharID()]==TOP_ZARATH)
						CopyStringToBuffer(buf, "Whoa. I didn't realize they sold these kinds of robes here too...Or made them in child size...Anyways!", SCHAR_ZARATH, EMOTE_EYEBROWRAISED, metadata);
					CopyStringToBuffer(buf, "I've got a special mystery item on sale today! And you can even buy it. Just 300G. Whaddya say?", SCHAR_ZARATH, 0, metadata);
				}
				else{
					CopyStringToBuffer(buf, "So how did you like your life lesson?", SCHAR_ZARATH, EMOTE_QUESTION, metadata);
				}
			}
			else if(Game->Counter[CR_STORYFLAG]<SFLAG_METKAYLANI){
				CopyStringToBuffer(buf, "Oh. @delay(60)I actually wasn't expecting any customers today, so I'm still getting my stall set up. But feel free to take a look around. I've got all manner of oil lanterns from across the sea. Anything catch your eye?", SCHAR_ZARATH, 0, metadata);
				CopyStringToBuffer(buf, "Nothing for me today... (This guy's all kinds of sketchy)", SCHAR_ASHER, EMOTE_ELLIPSES, metadata);
			}
			else if(Game->Counter[CR_STORYFLAG]<SFLAG_LEVEL1){
				CopyStringToBuffer(buf, "Curse it all! What a mess! I stepped away for just a second and some hooligan fell on my tent and knocked everything over. There's oil everywhere! I don't suppose you'd know who's responsible?", SCHAR_ZARATH, 0, metadata);
				CopyStringToBuffer(buf, "Oh, that was us.", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, ".@delay(60).@delay(60).", SCHAR_ZARATH, EMOTE_ANGRY, metadata);
				CopyStringToBuffer(buf, "...Kidding?", SCHAR_ASHER, EMOTE_SWEAT, metadata);
				CopyStringToBuffer(buf, "Oh, what's the use. I'm sure the three of you didn't do it on purpose. Just be more careful next time. These are valuable goods.", SCHAR_ZARATH, 0, metadata);
			}
			else if(Game->Counter[CR_STORYFLAG]<SFLAG_ASHERKIDNAPPED){
				CopyStringToBuffer(buf, "You three know of a man named Selet? Tall? Intimidating? Wears really loud shoes?", SCHAR_ZARATH, 0, metadata);
				CopyStringToBuffer(buf, "In a sense, yes.", SCHAR_ASHER, 0, metadata);
				CopyStringToBuffer(buf, "Nasty sort, that one. He strongarmed the city council into revoking my sales permit. Lost me my prime spot in the market square and all. So now I'm stuck with this...less than legal location.", SCHAR_ZARATH, EMOTE_DISMAYED, metadata);
				CopyStringToBuffer(buf, "Sorry to hear. He's given us a great deal of trouble as well.", SCHAR_KAYLANI, 0, metadata);
				CopyStringToBuffer(buf, "Ohh, but don't you worry...He'll get what's coming to him. Nobody slights me and gets away with it.", SCHAR_ZARATH, EMOTE_SADISTIC, metadata);
			}
			else if(Game->Counter[CR_STORYFLAG]<SFLAG_METGRANDMA){
				CopyStringToBuffer(buf, "I've been watching the sky lately. Things are moving quickly. Dark skies over Pala today...", SCHAR_ZARATH, 0, metadata);
				CopyStringToBuffer(buf, "You wanna buy an umbrella? I've got several designs in stock.", SCHAR_ZARATH, 0, metadata);
			}
			else if(Game->Counter[CR_STORYFLAG]<SFLAG_GAMECLEAR){
				if(Screen->D[0]){
					CopyStringToBuffer(buf, "Still can't get over that the old \"fight me\" pitch actually worked.", SCHAR_ZARATH, EMOTE_NORMAL, metadata);
					CopyStringToBuffer(buf, "Well, almost worked. They didn't end up buying anything.", SCHAR_ZARATH, EMOTE_SAD, metadata);
				}
				else{
					CopyStringToBuffer(buf, "Say, the three of you are looking pretty strong. I'm somewhat of a fighter myself. Would you be up for a quick little spar?", SCHAR_ZARATH, EMOTE_NORMAL, metadata);
				}
			}
			else if(Game->Counter[CR_STORYFLAG]==SFLAG_GAMECLEAR){
				CopyStringToBuffer(buf, "Have you heard about that nasty merchant who lives up the hill? Selet, his name was. They said he met with a sudden and unexpected end recently. Kaput. Dead.", SCHAR_ZARATH, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "...So we've heard. I'm not sure if it's really true though.", SCHAR_KAYLANI, EMOTE_DISMAYED, metadata);
				CopyStringToBuffer(buf, "Oh he's gone. Or at least if he's out there his business here in Pala Bay is finished. The thing about dead men is they're not good at defending their reputation and I have been digging up ALL KINDS of dirt since the man slighted me. So get this:", SCHAR_ZARATH, EMOTE_SADISTIC, metadata);
				CopyStringToBuffer(buf, "I went hunting though his manor and I found this: Selet hasn't been paying his taxes for the last five years! I have the papers to prove it and everything! And of course I saw to it that this information reached only the most inconvenient people for him.", SCHAR_ZARATH, EMOTE_HAPPY, metadata);
				CopyStringToBuffer(buf, "This is the least surprising thing I've heard all week.", SCHAR_ASHER, EMOTE_ELLIPSES, metadata);
				CopyStringToBuffer(buf, "An' ain't diggin' through a dead guy's belongings a little...Not right?", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Torrin you were JUST talking the other day about going back there to look for more magical devices like the Stellar Wand.", SCHAR_ASHER, EMOTE_EYEBROWRAISED, metadata);
				CopyStringToBuffer(buf, "Hrmph. Could at least show a little surprise or excitement.", SCHAR_ZARATH, EMOTE_NORMAL, metadata);
			}
			break;
		case 90:
			CopyStringToBuffer(buf, "I'm in the middle of a good book right now. If you're not dying, just leave your money on the counter and take what you need.", SCHAR_POTIONLADY, 0, metadata);
			break;
		case 91:
			CopyStringToBuffer(buf, "Looks like I owe ya one.", SCHAR_PIRATE, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "You and your band owe me far more than one. But this is not the time to settle that score.", SCHAR_KAYLANI, EMOTE_ANGRY, metadata);
			CopyStringToBuffer(buf, "Uh... yes ma'am.", SCHAR_PIRATE, EMOTE_SWEAT, metadata);
			break;
		case 92:
			CopyStringToBuffer(buf, "Saved from Igorevich... by peasants. This day couldn't get worse, could it?", SCHAR_TULANE, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Where I'm from, we usually say 'Thanks,' when someone saves 'em from a cage.", SCHAR_TORRIN, EMOTE_SWEAT, metadata);
			break;
		case 93:
			CopyStringToBuffer(buf, "Anything I can do to help?", SCHAR_KENJA, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Mate, I dunno how you're even standin' with your leg lookin' like that.", SCHAR_TORRIN, EMOTE_EYEBROWRAISED, metadata);
			CopyStringToBuffer(buf, "With difficulty. Can't stand feelin' useless at a time like this though.", SCHAR_KENJA, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "It's fine. The three of us can handle this. If the pain isn't too bad, you can help Siyed with the door. But don't get yourself killed charging back in there.", SCHAR_ASHER, EMOTE_NORMAL, metadata);
			break;
		case 94:
			CopyStringToBuffer(buf, "We were stuck in that mist for so long, I can barely raise my arms. I don't think I'm contributing any solar magic to this fight.", SCHAR_MORT, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "You've done your part. Let me do mine now.", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
			break;
		case 95:
			CopyStringToBuffer(buf, "And to think I used to be one of the better fighters. Maybe my age is finally catching up to me.", SCHAR_NELL, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "It could happen to any of us, Nell. I doubt many others could have held out as long as you did.", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
			break;
		case 96:
			CopyStringToBuffer(buf, "It's not right sending you kids into the mist to do our job. My lunar magic can protect us. If we just wait for my energy to return-", SCHAR_SKAI, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Ya know there's no time for that right now. We can 'andle this, Skai.", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Don't take this the wrong way Torrin, but it's hard to see you as anything but a kid with a knack for trouble, still.", SCHAR_SKAI, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "An' findin' trouble's exactly what we need right now. Trust me, we've got this.", SCHAR_TORRIN, EMOTE_WINK, metadata);
			break;
		case 97:
			CopyStringToBuffer(buf, "I think I've been underestimating you, Kaylani. You'e doing an amazing job.", SCHAR_ALLIE, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Thank you, but it's too early for praise until we're all out of here.", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
			break;
		case 98:
			CopyStringToBuffer(buf, "Funny how much easier Allie made this sound when she pitched the plan.", SCHAR_BAND, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Are you going to be alright?", SCHAR_ASHER, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "I've lived through worse, but with my sword arm torn up, might as well be useless right now.", SCHAR_BAND, EMOTE_NORMAL, metadata);
			break;
		case 99:
			if(Game->Counter[CR_NIGHTMARCHERQUEST] < 2){
				PlayStringAndWaitForNPCs("Oh, hello!", SCHAR_SIYED, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("What are you still doing here?", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Well, truth be told, the ruins here in the canyon caught my eye before we went into the temple. After making sure everyone was safe, I wanted to come back and study them some more.", SCHAR_SIYED, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I should've figured as much.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Found anything interesting?", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Aside from a lot of spike traps? Not too much. But we'll see what I can turn up.", SCHAR_SIYED, EMOTE_SWEAT, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_9;
				return 1;
			}
			else if(Game->Counter[CR_NIGHTMARCHERQUEST] < 4){
				PlayStringAndWaitForNPCs("Oh, hello! What are you all doing here?", SCHAR_SIYED, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("We need your help finding something.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Ever heard of a place called Tel's Pyramid?", SCHAR_TERRY, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I have! It's south of Kikala Hill. The waters around it are rough, but I know how to approach it. I could show you the way there, if you want.", SCHAR_SIYED, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Aren't you studying the ruins here?", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("They'll still be here when I get back. I'm not passing up an opportunity to go on another adventure with you!", SCHAR_SIYED, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("... Er, if that's okay with all of you.", SCHAR_SIYED, EMOTE_EMBARRASSED, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Like you need to ask. C'mon, let's get in the boat.", SCHAR_TORRIN, EMOTE_NORMAL, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("I'll be right behind you!", SCHAR_SIYED, EMOTE_HAPPY, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				Game->Counter[CR_NIGHTMARCHERQUEST] = 4;
				return 1;
			}
			else{
				PlayStringAndWaitForNPCs("I'll be right behind you!", SCHAR_SIYED, EMOTE_HAPPY, 68, YPOS_LOWER, cmb, til, cs, flags, flip, this);
				return 1;
			}
			break;
		case 100:
			if(Game->Counter[CR_NIGHTMARCHERQUEST] == 0){
				PlayStringAndWaitForNPCs("Where's Terry gotten herself to?", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Gone.", SCHAR_CAIMAN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Gone?", SCHAR_TORRIN, EMOTE_QUESTION, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("She made me promise to stay here, said somethin' about Pala Bay, then took a boat and left.", SCHAR_CAIMAN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("And she yelled at ME for doin' that!", SCHAR_TORRIN, EMOTE_ANGRY, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Are you gonna go find her? Can I come with you?", SCHAR_CAIMAN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Not a chance. An' I'll sick Ma on ya if ya pull a stunt like before.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Aw...", SCHAR_CAIMAN, EMOTE_SAD, 68, 24, cmb, til, cs, flags, flip, this);
				Game->Counter[CR_NIGHTMARCHERQUEST] = 1;
				PopupNotify(3); //New Quest
				return 1;
			}
			else{
				PlayStringAndWaitForNPCs("It's way more fun around here with Terry gone and Kenja stuck inside. Nobody tells us off anymore.", SCHAR_CAIMAN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				PlayStringAndWaitForNPCs("Just promise me you're not gonna hurt yourself too bad.", SCHAR_TORRIN, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			break;
		case 101:
			CopyStringToBuffer(buf, "What are you two gettin' up to?", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Your ma said playin' with the knife we found was too dangerous. So we're doin' something less dangerous now.", SCHAR_ZEKE, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "An' the knife?", SCHAR_TORRIN, EMOTE_EYEBROWRAISED, metadata);
			CopyStringToBuffer(buf, "Hidden under the house til she goes to sleep.", SCHAR_ZEKE, EMOTE_WINK, metadata);
			break;
		case 102:
			CopyStringToBuffer(buf, "This book suggests the Nightmarchers are tied to the lunar cycle. He's encountered Nightmarchers in the Lava Flows several times, always when the moon was a waning gibbous. That means they follow a twenty day long cycle.", SCHAR_SIYED, EMOTE_NORMAL, metadata);
			break;
		case 103:
			CopyStringToBuffer(buf, "This author says the Nightmarchers only show up in five places around here: Wahiokala's Jungle, the Lava Flows, Kikala Hill, Kawi, and Omaka Path. He bumped into the Marchers we're looking for in the jungle once. 'By the light of the nearly full moon, I could see their ghastly faces, full of malice, inspecting me. Only by seeking refuge in a nearby cave did I survive.' Makes me wonder if tracking them down's really a good idea.");
			break;
		case 104:
			CopyStringToBuffer(buf, "This guy says he encountered the Nightmarchers on Kikala Hill under a new moon. He also climbed up this island here and he noticed those torches lit the night BEFORE the new moon every month. He figured the torches must light the night before the Nightmarchers will appear somewhere.");
			break;
		case 105:
			G[G_TIMEFROZEN] = 1;
			PlayStringAndWaitForNPCs("According to what I read, the Nightmarchers will show up at 7:00 PM. We just need to sail for the jungle before then on the right day so we'll be there when they appear.", SCHAR_TERRY, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
			int handler[6];
			int Affirm[] = "They'll appear next sunset. We should head out now.";
			int Deny[] = "Gotcha, I'll let you know when I think they'll appear.";
			// int Affirm[] = "Yes";
			// int Deny[] = "No";
			int Options[] = {Affirm, Deny};
			while(handler[1] == 0){
				DialogueBox_RunSingleFrame(handler, 128, 8+52, Options, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, TIL_DB_DIALOGUE_SELECTOR, CS_DB_DIALOGUE_SELECTOR);
				if(cmb>1&&!IsCovered(this, flags)){
					Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
					Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
				}
				WaitNoAction();
				// G[G_NOACTION] = 1;
				// Waitframe();
			}
			if(handler[0] == 0){
				PlayStringAndWaitForNPCs("They will? Perfect! Let's get moving so we'll be there in time.", SCHAR_TERRY, EMOTE_EXCLAMATION, 68, 24, cmb, til, cs, flags, flip, this);	
				for(int i = 0; i<60; i++){
					if(cmb>1&&!IsCovered(this, flags)){
						Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
					}
					BlackishScreenLayerSix();
					WaitNoAction();
				}
				
				for(int i = 0; i<60; i++){
					if(cmb>1&&!IsCovered(this, flags)){
						Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
					}
					BlackScreenLayerSix();
					WaitNoAction();
				}
				int time = DayNight[_DN_HOUR]*60+DayNight[_DN_MINUTE];
				DayNight[_DN_MINUTE] = 55;
				DayNight[_DN_HOUR] = 18;
				int newtime = DayNight[_DN_HOUR]*60+DayNight[_DN_MINUTE];
				if((time < 19*60+0 && newtime < time) || (time < 19*60+0 && newtime >= 19*60+0))
					Nightmarchers_AdvanceDay();
				Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_13;
				Link->Item[I_ASHER] = true;
				Link->Item[I_TORRIN] = true;
				Link->Item[I_KAYLANI] = true;
				this->Data = CMB_AUTOWARPD;
				return 1;
			}
			else{
				PlayStringAndWaitForNPCs("Thanks. I appreciate it.", SCHAR_TERRY, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				G[G_TIMEFROZEN] = 0;
				return 1;
			}
			break;
		case 106:
			G[G_TIMEFROZEN] = 1;
			if(Link->Item[I_ASHER]){
				if(Game->Counter[CR_STORYFLAG] < SFLAG_WAREHOUSE){
					PlayStringAndWaitForNPCs("Torrin's the coolest guy in Pala Bay! My mom says I'm not supposed to talk to him, but she never said he couldn't talk to me.", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("That sword you have looks cool! So you must be cool too. Do you know him? Can you bring him here?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I... guess I can?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Thanks!", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				}
				else if(Game->Counter[CR_CHASEQUEST]==0){
					PlayStringAndWaitForNPCs("Whoa! That's a cool sword. Can I give it a swing?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I dunno, that might be a little-", SCHAR_ASHER, EMOTE_ELLIPSES, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Ack! So heavy!", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Hey! When did you-?", SCHAR_ASHER, EMOTE_SURPRISED, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("I like your attitude, kid. But ya'd better give that back. Could get yourself hurt.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Yes sir...Sorry about that.", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("S-sir? How old ya take me for?", SCHAR_TORRIN, EMOTE_SURPRISED, 68, 24, cmb, til, cs, flags, flip, this);
					if(Link->Item[I_KAYLANI])
						PlayStringAndWaitForNPCs("My mom never lets me do anything fun. But the three of you can sail wherever you want and see the world. You've been on all kinds of adventures, right? Can you tell me a story about them?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					else
						PlayStringAndWaitForNPCs("My mom never lets me do anything fun. But you two are old enough to travel on your own. You've been on all kinds of adventures, right? Can you tell me a story about them?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Sure thing! I go on all sorts of adventures.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Awesome! Tell me! Tell me!", SCHAR_CHASE, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Okay, so this one time when we were stranded at the top of this mountain...", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("A real one, please, Torrin. Let's not let his imagination get any more carried away than it already is...", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					Game->Counter[CR_CHASEQUEST] = 1;
					PopupNotify(3); //New Quest
				}
				else if(Game->Counter[CR_CHASEQUEST]<6){
					PlayStringAndWaitForNPCs("So do you have any cool adventure stories to share?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					int outcome = 0;
					if(Game->Counter[CR_CHASEQUEST]==1&&Game->Counter[CR_STORYFLAG]>=SFLAG_METKAYLANI)
						outcome = 1;
					if(Game->Counter[CR_CHASEQUEST]==2&&Game->Counter[CR_STORYFLAG]>=SFLAG_LEVEL1)
						outcome = 1;
					if(Game->Counter[CR_CHASEQUEST]==3&&Game->Counter[CR_STORYFLAG]>=SFLAG_ASHERRESCUED)
						outcome = 1;
					if(Game->Counter[CR_CHASEQUEST]==4&&Game->Counter[CR_STORYFLAG]>=SFLAG_MISTCLEAR)
						outcome = 1;
					if(Game->Counter[CR_CHASEQUEST]==5&&Game->Counter[CR_STORYFLAG]>=SFLAG_GAMECLEAR)
						outcome = 1;
					if(outcome==0){
						if(GetCharID()==CHAR_ASHER){
							PlayStringAndWaitForNPCs("Nothing new, sorry.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
						}
						else if(GetCharID()==CHAR_TORRIN){
							PlayStringAndWaitForNPCs("Nope, but when we do you'll be the first to hear!", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
						}
						else if(GetCharID()==CHAR_KAYLANI){
							PlayStringAndWaitForNPCs("Nothing comes to mind...", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
						}
						PlayStringAndWaitForNPCs("Aww, that's a bummer. But if you guys go on any cool new adventures be sure to tell me, okay?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					}
					else if(outcome==1){
						if(GetCharID()==CHAR_ASHER){
							PlayStringAndWaitForNPCs("Alright, let's see...", SCHAR_ASHER, EMOTE_ELLIPSES, 68, 24, cmb, til, cs, flags, flip, this);
						}
						else if(GetCharID()==CHAR_TORRIN){
							PlayStringAndWaitForNPCs("Sure, here's a good one...", SCHAR_TORRIN, EMOTE_ELLIPSES, 68, 24, cmb, til, cs, flags, flip, this);
							}
						else if(GetCharID()==CHAR_KAYLANI){
							PlayStringAndWaitForNPCs("Hmm...How about this...", SCHAR_KAYLANI, EMOTE_ELLIPSES, 68, 24, cmb, til, cs, flags, flip, this);
						}
						
						if(Game->Counter[CR_CHASEQUEST]==1){
							if(GetCharID()==CHAR_ASHER){
								PlayStringAndWaitForNPCsWFade("...And that's how we met Kaylani.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							else if(GetCharID()==CHAR_TORRIN){
								PlayStringAndWaitForNPCsWFade("...An' that's how we squashed the local kidnappin' operation.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							else if(GetCharID()==CHAR_KAYLANI){
								PlayStringAndWaitForNPCsWFade("...And that's how I was saved by these two.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							PlayStringAndWaitForNPCs("Wow! So you two broke into a warehouse on a hunch and ended up unraveling an underworld plot?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Well when you put it like that I guess it sounds a little irresponsible-", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("That's@delay(120) so cool!", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("I mean, it's scary that something like that could happen here in Pala Bay. But with you three around I'm sure everything will be okay.", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Here's hoping...", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Be sure to tell me if you have any other cool stories, okay?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							Game->Counter[CR_CHASEQUEST] = 2;
						}
						else if(Game->Counter[CR_CHASEQUEST]==2){
							if(GetCharID()==CHAR_ASHER){
								PlayStringAndWaitForNPCsWFade("...And that's how we beat the pirates.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							else if(GetCharID()==CHAR_TORRIN){
								PlayStringAndWaitForNPCsWFade("...An' that's I got these magic batteries.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							else if(GetCharID()==CHAR_KAYLANI){
								PlayStringAndWaitForNPCsWFade("...And that's how we investigated the pirate hideout.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							PlayStringAndWaitForNPCs("So you guys fought with pirates?@delay(60) That's so wicked! Pirate battles are totally wicked!", SCHAR_CHASE, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Wicked and extremely dangerous.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("C'mon Kay, what young boy doesn't dream of fighting pirates?", SCHAR_TORRIN, EMOTE_WINK, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Young boys who don't get into trouble and grow up to lead very long and uneventful lives?", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("You three are so... coooool!", SCHAR_CHASE, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Be sure to tell me if you have any other cool stories, okay?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							Game->Counter[CR_CHASEQUEST] = 3;
						}
						else if(Game->Counter[CR_CHASEQUEST]==3){
							if(GetCharID()==CHAR_ASHER){
								PlayStringAndWaitForNPCsWFade("...And that's how I discovered I had stellar magic.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							else if(GetCharID()==CHAR_TORRIN){
								PlayStringAndWaitForNPCsWFade("...An' that's how we rescued Asher from that rotter Selet.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							else if(GetCharID()==CHAR_KAYLANI){
								PlayStringAndWaitForNPCsWFade("...And that's how we infiltrated Selet's manor.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							PlayStringAndWaitForNPCs("So Asher's a stellar mage? That's crazy! I've never heard of one of those!", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("I had no idea they even existed before all this happened.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("And Torrin and Kaylani also broke into Selet's Manor to rescue you? The three of you are such amazing friends!", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Aw shucks...", SCHAR_TORRIN, EMOTE_EMBARRASSED, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("The power of friends is...@delay(60)so coooool!!!", SCHAR_CHASE, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Yeah, but it's only cool when you don't actually call it the power of friendship.", SCHAR_TORRIN, EMOTE_WINK, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Got it!", SCHAR_CHASE, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Be sure to tell me if you have any other cool stories, okay?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							Game->Counter[CR_CHASEQUEST] = 4;
						}
						else if(Game->Counter[CR_CHASEQUEST]==4){
							if(GetCharID()==CHAR_ASHER){
								PlayStringAndWaitForNPCsWFade("...And that's how the fate of the world ended up resting on our shoulders.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							else if(GetCharID()==CHAR_TORRIN){
								PlayStringAndWaitForNPCsWFade("...An' that's how our ambush got ambushed.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							else if(GetCharID()==CHAR_KAYLANI){
								PlayStringAndWaitForNPCsWFade("...And that's why we really must be going. We haven't a moment to lose.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							PlayStringAndWaitForNPCs("Wowowow! You three are pretty much heroes from out of my comic books now! I could never do something like save the world.", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Well we haven't done anything just yet.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("But ain't no way we're lettin' Selet get away with this.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("You...@delay(60)guys...@delay(60)are...@delay(120)MAXIMUM COOOOOL!!!", SCHAR_CHASE, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("You guys are almost as cool as my Uncle Dracus. And he's pretty cool. He's a...what's it called? Histogram? Historian? He's been researching this god of the sun and its connection to the \"Light of the Heavens\".", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("But I'm pretty sure he's never saved the world.", SCHAR_CHASE, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("And we haven't either. But we'll let you know once we've sorted this all out.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Good luck! I know you can do it!", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							Game->Counter[CR_CHASEQUEST] = 5;
						}
						else if(Game->Counter[CR_CHASEQUEST]==5){
							if(GetCharID()==CHAR_ASHER){
								PlayStringAndWaitForNPCsWFade("...And that's how we kept Selet from getting his hands on the Egg.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							else if(GetCharID()==CHAR_TORRIN){
								PlayStringAndWaitForNPCsWFade("...An' that's how we killed Space.", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							else if(GetCharID()==CHAR_KAYLANI){
								PlayStringAndWaitForNPCsWFade("...And that's how we let Selet get away.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							}
							PlayStringAndWaitForNPCs("You saved the world!? That's...@delay(60) the coolest thing I ever heard!!!", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("I don't know if I'd say that...", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("He's still out there, and we don't know what the Cosmic Egg actually was.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("But you stopped him from using it! And beat a giant monster! That's even cooler than anything Uncle Dracus has done!", SCHAR_CHASE, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
							PlayStringAndWaitForNPCs("Oh, that reminds me! So on your adventures, have you encountered any of those spirally green rocks?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
							if(Game->Counter[CR_TOTALHYMNSTONES]==0){
								G[G_CHASELOWPERCENTMET] = 1;
								PlayStringAndWaitForNPCs("You know...Hymnstones?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
								PlayStringAndWaitForNPCs("Nope.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
								PlayStringAndWaitForNPCs("Can't say we have.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
								PlayStringAndWaitForNPCs("Th' heck's a hymnstone!?", SCHAR_TORRIN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
								PlayStringAndWaitForNPCs("Uhh...Anyways! Uncle Dracus said that if you collect 100 and sail out to this one island north of the Starfall Shoals, something cool will happen. It seemed really important to him.", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
								PlayStringAndWaitForNPCs("You might not have found any because they're just so rare...But maybe if you go there something will happen anyways?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
								PlayStringAndWaitForNPCs("If we find anything there, you'll be the first to know.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
								PlayStringAndWaitForNPCs("You guys are awesome! Here, I'll mark the spot on your map.", SCHAR_CHASE, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
							}
							else{
								PlayStringAndWaitForNPCs("You mean hymnstones?", SCHAR_KAYLANI, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
								PlayStringAndWaitForNPCs("Yeah, I think so. Uncle Dracus said that if you collect 100 and sail out to this one island north of the Starfall Shoals, something cool will happen. It seemed really important to him.", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
								PlayStringAndWaitForNPCs("But I haven't found even one Hymnstone. And plus, my mom won't even let me stay up past 8.", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
								PlayStringAndWaitForNPCs("If we find anything there, you'll be the first to know.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
								PlayStringAndWaitForNPCs("You guys are awesome! Here, I'll mark the spot on your map.", SCHAR_CHASE, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
							}
							Game->Counter[CR_CHASEQUEST] = 6;
						}
					}
				}
				else if(Game->Counter[CR_CHASEQUEST]==6){
					PlayStringAndWaitForNPCs("So have you guys found those 100 Hymnstones yet?", SCHAR_CHASE, EMOTE_QUESTION, 68, 24, cmb, til, cs, flags, flip, this);
					if(Game->Counter[CR_TOTALHYMNSTONES]<100){
						PlayStringAndWaitForNPCs("I don't think so. These things are rough to track down.", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
						PlayStringAndWaitForNPCs("That's okay. I know you three can do it.", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					}
					else{
						PlayStringAndWaitForNPCs("'Course, we've found like a billion a' the things.", SCHAR_TORRIN, EMOTE_WINK, 68, 24, cmb, til, cs, flags, flip, this);
						PlayStringAndWaitForNPCs("Or 100 exactly. Where did you say we should take these again?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
						PlayStringAndWaitForNPCs("It's just north of Starfall Shoals. That's what my uncle was muttering when I eavesdropped on him, at least. Oh boy, I can't wait...", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					}
				}
			}
			else{
				if(Game->Counter[CR_CHASEQUEST]==0){
					PlayStringAndWaitForNPCs("It's so boring around here. Mom won't let me do anything fun and Uncle D's always busy with his work. I wish I had someone else to play with...", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				}
				else{
					PlayStringAndWaitForNPCs("Heya Torrin. Where's Asher?", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Um...An adventure in progress let's call it. We'll tell you about it later.", SCHAR_TORRIN, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
					PlayStringAndWaitForNPCs("Oh. Okay then.", SCHAR_CHASE, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				}
			}
			G[G_TIMEFROZEN] = 0;
			return 1;
			break;
		case 107:
			if(Game->Counter[CR_STORYFLAG]<SFLAG_ASHERRESCUED){
				CopyStringToBuffer(buf, "Wow, you found this place rather early, didn't you?", SCHAR_MOOSH, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Th' heck's that s'posed to mean?", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Oh, nothing...", SCHAR_MOOSH, EMOTE_NORMAL, metadata);
			}
			else{
				CopyStringToBuffer(buf, "Hi everybody. Moosh here. I've got a few thoughts on my time spent working on Stellar Seas so I hope you're cool with reading a bit of a text wall.", SCHAR_MOOSH, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "When Russ first pitched the idea for this quest to me I was in the middle of a really rough year. I'd actually been considering quitting ZC altogether at the time but, despite the original plan being a little bare bones, I decided to give it a shot anyways. I'm really glad I did. Working on the quest was therapeutic in a sense. I really enjoy crafting worlds and being able to create a more idyllic one while the real one was being terrible, it was a nice escape. Not to be overly dramatic and make it out like game design saved my life or anything, but it did make a bad time more tolerable. It helped me work through issues I had control over and to cope with the ones I didn't.", SCHAR_MOOSH, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "There were some challenges too. As the scope of the project kept expanding and we added more and more side content there was a consistent set of features from the original draft that I kept pushing back: The Selet boss fight, the final boss, and a few of the cutscenes to name a few. Some of my ideas seemed too big for my own abilities and almost too big for ZC itself at times. So for as much time as I spent working on them, I spent twice as much looking for ways to avoid working on them. But they did ultimately get done, a process that was itself a bit of a learning experience. For as much as I meme about being lazy, much of that laziness is a lack of confidence and I've been working on persevering to overcome that. So seeing the finished quest in motion was a huge ego boost.", SCHAR_MOOSH, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "This quest was also a major challenge with regards to sprite art. While I didn't hit all of my goals I did more spritework for this quest than any other project so far. This was also my first completed project using the DoR tileset. I was really uneasy about that at first, and Russ did most of the heavy lifting for overworlds, but the few overworld areas I did contribute (Pala Bay, Starfall Shoals and a handful of small side areas) I'm really proud of. I know the tileset is a bit more contentious nowadays than it was in the late 2000's, but I think for what we were going for here it's the perfect fit. And I've got a newfound respect for those mountains.", SCHAR_MOOSH, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "So that was Stellar Seas. I have a bunch more stories I could share but I think I've waffled on long enough. This project has really matured over time from its original five week contest plan and I think secured its place as my favorite quest I've worked on. I hope everyone will enjoy playing it as much as I've enjoyed making it.", SCHAR_MOOSH, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Hold on...I heard some pretty important names in there. Are we supposed to know what any of that means?", SCHAR_ASHER, EMOTE_EYEBROWRAISED, metadata);
				CopyStringToBuffer(buf, "Bold of you to assume I was talking to you.", SCHAR_MOOSH, EMOTE_WINK, metadata);
				Screen->D[0] = 1;
			}
			break;
		case 107.5:
			if(Game->Counter[CR_STORYFLAG]<SFLAG_ASHERRESCUED){
				CopyStringToBuffer(buf, "Oh hey, you're here early. Moosh says I'm not supposed to talk about stuff til you're progressed the main plot a little more so I don't spoil stuff. So come back a little later, and feel free to use the other entrance.", SCHAR_RUSS, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Other entrance?", SCHAR_KAYLANI, EMOTE_EYEBROWRAISED, metadata);
				CopyStringToBuffer(buf, "Just messing with you. Or am I?", SCHAR_RUSS, EMOTE_NORMAL, metadata);
			}
			else{
				CopyStringToBuffer(buf, "Well Moosh bared his heart, so now I've got to do the same. Lots of text about my time working on Stellar Seas incoming, so if you'd rather not listen, feel free to hold the B and A buttons and skip. Don't you wish you could do that to me in real life?", SCHAR_RUSS, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "This quest definitely came at a weird time for me. Yuurand development had ended, and I felt a bit adrift in terms of game development. With how busy my residency schedule was and my difficulties adapting to life alone away from all my friends and family, I considered giving up ZC altogether. And then I had a dream about two guys breaking into a warehouse in a small tropical city, and after a week of deliberating and fleshing out the idea a little, I pitched it to Moosh. It was still super bare bones at that point, amounting to basically \"Here's three characters, solar and lunar magic, vaguely Polynesian setting,\" but Moosh wasted no time running with the ideas and turning it into something great.", SCHAR_RUSS, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "I had some big reservations with the project. Namely, I was worried it felt too much like a rehash of the usual Russ tropes. Start with some tropical islands in the DoR tileset, throw in a text-heavy story, add a janky hookshot-replacement, and toss in an LGBT character for good measure... it felt a lot like more refined rehash of some of my earlier projects like Darkness Within, and I was worried I was making something only I would enjoy and dragging Moosh along through it. While it may be dripping with Russ tropes though, I feel it's settled nicely into its own identity now.", SCHAR_RUSS, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "And at the end of the day, making this quest was therapeutic for me. Stressful, perhaps, but it was a nice world to escape into. When I was feeling stuck in life, I could open the quest and toss in a new side island for the heck of it. Or lose myself writing dialogue for a random NPC until they eventually got promoted to a side character and got their own sidequest. It's all led to a world that, I hope, is fun to explore and feels alive.", SCHAR_RUSS, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "At the end of the day, it may not be my most ambitious project, but I feel like it's the one that's most authentically \"me\".", SCHAR_RUSS, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Anyways, I could ramble all day, but I've probably taken enough of your time already. Thanks for playing Stellar Seas, and hopefully you're enjoying it!", SCHAR_RUSS, EMOTE_NORMAL, metadata);
				if(Screen->D[0]){
					CopyStringToBuffer(buf, "Hey! You totally stole my backstory there! Go get your own.", SCHAR_MOOSH, EMOTE_WINK, metadata);
				}
			}
			break;
		case 107.6666:
			if(Link->Item[224] && !Link->Item[225]){
				PlayStringAndWaitForNPCs("That's a shiny rupee you have there! An accomplishment like that deserves a reward!", SCHAR_EVAN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				Game->PlaySound(62);
				eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
				e->CollDetection = false;
				e->DrawYOffset = -1000;
				int Args[8] = {225};
				RunEWeaponScript(e, "ItemPopup", Args);
				Link->Item[225] = true;
				if(Game->Counter[CR_RUPEES] > 0)
					Game->Counter[CR_RUPEES]--;
				for(int i = 0; i<210; i++){
					if(cmb>1&&!IsCovered(this, flags)){
						Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
					}
					WaitNoAction();
				}
				PlayStringAndWaitForNPCs("If you expected anything more, you're a bigger clown than I am.", SCHAR_EVAN, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			else if(Link->Item[224] && Link->Item[225]){
				CopyStringToBuffer(buf, "I did warn you about him.", SCHAR_RUSS, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "And yet, here we are. Now begone, I have business to attend to.", SCHAR_EVAN, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Moosh, Strive when?", SCHAR_EVAN, EMOTE_SADISTIC, metadata);
				break;
			}
			CopyStringToBuffer(buf, "Seek the rupee on the silver summit!", SCHAR_EVAN, EMOTE_NORMAL, metadata);
            CopyStringToBuffer(buf, "Oh don't mind Evan. He lives in that jar and says horrible things sometimes.", SCHAR_RUSS, EMOTE_NORMAL, metadata);
            CopyStringToBuffer(buf, "No, you can't have the other jar. It's mine too!", SCHAR_EVAN, EMOTE_SADISTIC, metadata);
			break;
		case 108:
			if(G[G_RANDOMIZERENABLED]){
				switch(GetCharID()){
					case CHAR_ASHER:
						CopyStringToBuffer(buf, "We've gotten a little lost. Could you read the stars to help us out?", SCHAR_ASHER, EMOTE_NORMAL, metadata);
						break;
					case CHAR_TORRIN:
						CopyStringToBuffer(buf, "I think I've misplaced somethin', but I jus' can't find it. Reckon you can help out?", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
						break;
					case CHAR_KAYLANI:
						CopyStringToBuffer(buf, "I don't know where to go next, Grandmother. Could you please give me some guidance?", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
						break;
					case CHAR_SOREN:
						CopyStringToBuffer(buf, "I've heard the astronomers are good at finding things. Think you could help us with something?", SCHAR_SORENPANTS, EMOTE_NORMAL, metadata);
						break;
					case CHAR_TERRY:
						CopyStringToBuffer(buf, "...Can ya read our fortunes? Torrin's told a heap of stories about the astronomers' powers. Was hopin' to see it in action.", SCHAR_TERRY, EMOTE_NORMAL, metadata);
						break;
					case CHAR_SIYED:
						CopyStringToBuffer(buf, "I haven't been able to divine our next objective. Perhaps I could use some more training...", SCHAR_SIYED, EMOTE_NORMAL, metadata);
						break;
				}	
			}
			else{
				if(Game->Counter[CR_STORYFLAG] == SFLAG_POSTGRANDMA){
					CopyStringToBuffer(buf, "Kohiko is northwest of Omaka. You'll want to sail up the river as far as you can, then hoke the rest of the way north through the canyon. There's still some time before we're ready to spring our trap, so if there's anything left that you wanted to do, now would be the time.", SCHAR_WINNO, EMOTE_NORMAL, metadata);
				}
				if(Game->Counter[CR_STORYFLAG] == SFLAG_ALIIOPEN){
					CopyStringToBuffer(buf, "I hate sending the three of you alone, but with our strike team wounded, there's nothing to be done about it. I'm counting on you all. Don't let Igorevich get his hands on the Cosmic Egg!", SCHAR_WINNO, EMOTE_NORMAL, metadata);
				}
				if(Game->Counter[CR_STORYFLAG] == SFLAG_GAMECLEAR){
					CopyStringToBuffer(buf, "Why do I feel like there's even more work to do now that the crisis is past us? I've got a team trying to return the recovered stolen cargo from the pirates, another sent as goodwill ambassadors to Omaka to explain the false flag attacks, and of course the search team looking for what became of Igorevich's cult of personality. I enjoy being chief, but I'm beginning to look forward to the day I can pass these responsibilities onto you, Kaylani, and take a much deserved nap.", SCHAR_WINNO, EMOTE_NORMAL, metadata);
				}
			}
			break;
		case 109:
			CopyStringToBuffer(buf, "Micah!", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Hey, what are you three doing up here?", SCHAR_MICAH3, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "We were just popping up to see how you're doing. You and your sister on good terms again?", SCHAR_ASHER, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Things aren't quite back to normal yet, but we're getting there. Soon, this whole awful chapter of my life will be behind me.", SCHAR_MICAH3, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Does that mean you had to toss out that snazzy cape and hood?", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "That's one thing I'm more than happy to be rid of. The black color soaked up sunlight, and the thick fabric trapped all that heat inside. Might've looked cool, but it wasn't practical at all. It was all about Selet showing off.", SCHAR_MICAH3, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Probably to be expected from a guy who wears a full dress suit into battle.", SCHAR_ASHER, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Speaking of Selet, any luck with the search?", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Not yet. I've been searching all the possible safe descents from the mountain I can think of, using some of the lunar magic we recovered from Selet's lackeys to search for any signs of heavy magic usage. For him to survive a fall like that, he'd have to use a lot of lunar magic, twisting gravity around enough that the splat wouldn't do him in. There should be some kind of residual left over from that.", SCHAR_MICAH3, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "And?", SCHAR_ASHER, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "And... so far, I've turned up nothing. Selet may be crafty, but to survive a fall like that? Without leaving a trace? That seems hard to imagine, even for him.", SCHAR_MICAH3, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "I don't know how... but with the things he said to me, there's no way he took his life. He had some kind of plan.", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Allie's the same way you are. She and Band are higher up the mountain, doing their own search. We'll see what they turn up.", SCHAR_MICAH3, EMOTE_NORMAL, metadata);
			break;
		case 110:
			CopyStringToBuffer(buf, "Well? Any luck?", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Hello to you, too.", SCHAR_BAND, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Should've expected to find you up here.", SCHAR_ALLIE, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Watcha up to? Lookin' for Selet?", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Or some sign of him. This ledge is directly down the slope from the Observatory. If he fell to his death, and his body didn't end up right at the observatory's base, it should have rolled and ended up somewhere around here. But we've run over this section of the mountain at least ten times. Not a trace.", SCHAR_ALLIE, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "What's the alternative? That he grew wings an' flew away?", SCHAR_BAND, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Much as I hate to say it, I don't think we can discount that.", SCHAR_ALLIE, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "He's out there. I'm sure of it.", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "I'm inclined to agree. But gut feelings won't do us any good if we can't find some evidence of what actually happened.", SCHAR_ALLIE, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Can we help?", SCHAR_ASHER, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "You've done more than enough for now. Allie and I need to pull our weight an' make up for the Poho Temple debacle.", SCHAR_BAND, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "We'll let you know if we turn up anything. But I wouldn't hold your breath.", SCHAR_ALLIE, EMOTE_NORMAL, metadata);
			break;
		case 111:
			CopyStringToBuffer(buf, "Oh hey, somebody actually found this place. Beyond this point is an optional and completely pointless gauntlet. I made it because I thought it'd be fun. I actually mean it about the optional thing, we're really out of rewards to hand out. But if this is your type of thing, feel free to give it a go.", SCHAR_MOOSH, EMOTE_NORMAL, metadata);
			break;
		case 111.1:
			CopyStringToBuffer(buf, "So how come Ash gets a bunch o' dash puzzles and Kaylani gets some too but there's no rooms here for me?", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Believe me I wanted to make some, but your strong suit is doing violence, Torrin. I actually couldn't think of any good puzzle rooms.", SCHAR_MOOSH, EMOTE_NORMAL, metadata);
			CopyStringToBuffer(buf, "Who says I only choose violence? I'ma deck em I swear-@26@26...Oh.", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
			break;
		case 111.2:
			CopyStringToBuffer(buf, "Remember, you didn't see anything...", SCHAR_RUSS, EMOTE_NORMAL, metadata);
			break;
		case 112:
			if(Game->Counter[CR_HELPERQUEST] < 3){
				PlayStringAndWaitForNPCs("Ready to here the rest a' my story, Tor?", SCHAR_TERRY, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				int handler[6];
				int Affirm[] = "You bet!";
				int Deny[] = "Maybe later.";
				int Options[] = {Affirm, Deny};
				while(handler[1] == 0){
					DialogueBox_RunSingleFrame(handler, 128, 8+52, Options, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, TIL_DB_DIALOGUE_SELECTOR, CS_DB_DIALOGUE_SELECTOR);
					if(cmb>1&&!IsCovered(this, flags)){
						Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
					}
					WaitNoAction();
				}
				if(handler[0] == 0){
					for(int i = 0; i<60; i++){
						if(cmb>1&&!IsCovered(this, flags)){
							Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
							Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						}
						BlackishScreenLayerSix();
						WaitNoAction();
					}
					
					for(int i = 0; i<60; i++){
						if(cmb>1&&!IsCovered(this, flags)){
							Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
							Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						}
						BlackScreenLayerSix();
						WaitNoAction();
					}
					SidePartySwap(true);
					this->Data = CMB_AUTOWARPD;
					return 1;
				}
				else{
					PlayStringAndWaitForNPCs("Aw' c'mon, why do I never get to talk about it when I do cool stuff?", SCHAR_TERRY, EMOTE_SAD, 68, 24, cmb, til, cs, flags, flip, this);
					return 1;
				}
			}
			else{
				CopyStringToBuffer(buf, "Better watch on, Torrin. Now that I got some magic batteries a' my own, nothin's stoppin' me from becomin' the alpha twin again.", SCHAR_TERRY, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Pft, you think all I do is toss aroun' stolen batteries? Come back when you're as good at dodgin' blows as I am.", SCHAR_TORRIN, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Guess you did get a lot of practice with that, what with provokin' everyone with your stupidity back home.", SCHAR_TERRY, EMOTE_WINK, metadata);
				CopyStringToBuffer(buf, "Now wait just a sec-", SCHAR_TORRIN, EMOTE_SURPRISED, metadata);
				CopyStringToBuffer(buf, "She definitely has you beat in witty retorts. Maybe she really is the alpha twin.", SCHAR_KAYLANI, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Aw c'mon, you're supposed to be on my side here.", SCHAR_TORRIN, EMOTE_SAD, metadata);
			}
			break;
		case 113:
			if(Game->Counter[CR_HELPERQUEST] < 3){
				PlayStringAndWaitForNPCs("Well Ash, ready to hear about my heroics again?", SCHAR_SORENPANTS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				int handler[6];
				int Affirm[] = "You bet!";
				int Deny[] = "Maybe later.";
				int Options[] = {Affirm, Deny};
				while(handler[1] == 0){
					DialogueBox_RunSingleFrame(handler, 128, 8+52, Options, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, TIL_DB_DIALOGUE_SELECTOR, CS_DB_DIALOGUE_SELECTOR);
					if(cmb>1&&!IsCovered(this, flags)){
						Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
					}
					WaitNoAction();
				}
				if(handler[0] == 0){
					for(int i = 0; i<60; i++){
						if(cmb>1&&!IsCovered(this, flags)){
							Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
							Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						}
						BlackishScreenLayerSix();
						WaitNoAction();
					}
					
					for(int i = 0; i<60; i++){
						if(cmb>1&&!IsCovered(this, flags)){
							Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
							Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						}
						BlackScreenLayerSix();
						WaitNoAction();
					}
					SidePartySwap(true);
					this->Data = CMB_AUTOWARPD;
					return 1;
				}
				else{
					PlayStringAndWaitForNPCs("Alright, no rush. Fair warning though, I might exaggerate more the longer you take.", SCHAR_SORENPANTS, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
					return 1;
				}
			}
			else{
				CopyStringToBuffer(buf, "Hey man, I meant to ask, where'd those bombs you got come from anyways?", SCHAR_ASHER, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Oh, so ya know that shady woman who sells ammo and explosives by the docks in Pala? I convinced her and the weapons merchant guy to chat it up. These bad boys were the result. They let me have some, on the condition I didn't tell a soul they were making illegal explosives.", SCHAR_SORENPANTS, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "Don't take this the wrong way, but are you sure you oughta have those?", SCHAR_ASHER, EMOTE_NORMAL, metadata);
				CopyStringToBuffer(buf, "It's fine! Hair grows back, and these pants are fireproof. ", SCHAR_SORENPANTS, EMOTE_HAPPY, metadata);
				CopyStringToBuffer(buf, "Just try to stay safe...", SCHAR_ASHER, EMOTE_SWEAT, metadata);
			}
			break;
		case 114:
			PlayStringAndWaitForNPCs("Want me to finish explaining what happened, Kaylani?", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
			int handler[6];
			int Affirm[] = "You bet!";
			int Deny[] = "Maybe later.";
			int Options[] = {Affirm, Deny};
			while(handler[1] == 0){
				DialogueBox_RunSingleFrame(handler, 128, 8+52, Options, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, TIL_DB_DIALOGUE_SELECTOR, CS_DB_DIALOGUE_SELECTOR);
				if(cmb>1&&!IsCovered(this, flags)){
					Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
					Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
				}
				WaitNoAction();
			}
			if(handler[0] == 0){
				for(int i = 0; i<60; i++){
					if(cmb>1&&!IsCovered(this, flags)){
						Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
					}
					BlackishScreenLayerSix();
					WaitNoAction();
				}
				
				for(int i = 0; i<60; i++){
					if(cmb>1&&!IsCovered(this, flags)){
						Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
					}
					BlackScreenLayerSix();
					WaitNoAction();
				}
				SidePartySwap(true);
				this->Data = CMB_AUTOWARPD;
				return 1;
			}
			else{
				PlayStringAndWaitForNPCs("Sure? Alright, but I think you'll be interested in hearing it.", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
				return 1;
			}
			break;
		case 115:
			PlayStringAndWaitForNPCs("I wonder about these totems. Did the Astronomers make them? Or someone else entirely?", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
			PlayStringAndWaitForNPCs("Could take it apart and see how it works. Maybe there's a clue inside?", SCHAR_ASHER, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
			PlayStringAndWaitForNPCs("Would we be able to put it back together again after?", SCHAR_SIYED, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
			PlayStringAndWaitForNPCs("Won't know unless we try.", SCHAR_ASHER, EMOTE_HAPPY, 68, 24, cmb, til, cs, flags, flip, this);
			Game->PlaySound(86);
			ffc totem = Screen->LoadFFC(1);
			int comboloc = ComboAt(totem->X, totem->Y) - 32;
			mapdata l3 = Game->LoadTempScreen(3);
			l3->ComboD[comboloc] = 11577;
			l3->ComboD[comboloc+1] = 11578;
			for(int i = 0; i<60; i++){
				if(cmb>1&&!IsCovered(this, flags)){
					Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
					Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
				}
				WaitNoAction();
			}
			PlayStringAndWaitForNPCs("Please refrain from disassembling me, or I shall be forced to deploy my defenses.", SCHAR_TOTEM, EMOTE_NORMAL, 68, 24, cmb, til, cs, flags, flip, this);
			l3->ComboD[comboloc] = 11558;
			l3->ComboD[comboloc+1] = 11559;
			Game->PlaySound(87);
			for(int i = 0; i<60; i++){
				if(cmb>1&&!IsCovered(this, flags)){
					Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
					Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
				}
				WaitNoAction();
			}
			PlayStringAndWaitForNPCs("How about you two stay far away from the totem?", SCHAR_KAYLANI, EMOTE_SWEAT, 68, 24, cmb, til, cs, flags, flip, this);
			return 1;
			break;
		case 116:
			if(G[G_SLEEPPARALYSISSELET])
				CopyStringToBuffer(buf, "Atop the mountain...The eagle stirs...", SCHAR_BOOK, EMOTE_NORMAL, metadata);
			else
				CopyStringToBuffer(buf, "I lie awake, unable to move, unable to breathe. The eagle stands in the corner, watching, waiting. The anticipation builds as it approaches the bedside. It leans over my paralyzed form. It pecks out my eyes. It fills them with stars.", SCHAR_BOOK, EMOTE_NORMAL, metadata);
			break;
		case 117:
			CopyStringToBuffer(buf, "Huh? What are you doing here?", SCHAR_WOMANBLACKHAIRYELLOWSKIRT, 0, metadata);
			CopyStringToBuffer(buf, "What are YOU doing here? This isn't even a chapel anymore.", SCHAR_ASHER, 0, metadata);
			CopyStringToBuffer(buf, "I know, it's rather inconvenient. But a changing room works just as well as a confessional. For, uh... confessions, you see. That's why I'm here. Meeting a priest. For confessions.", SCHAR_WOMANBLACKHAIRYELLOWSKIRT, 0, metadata);
			CopyStringToBuffer(buf, "Riiiiiiiiiiiiiiiiight.", SCHAR_TORRIN, 0, metadata);
			break;
		case 118:
			CopyStringToBuffer(buf, "I wanted to spend some of the money Soren gave me on a new outfit, but they don't have it in my size.", SCHAR_BOYGREENSHORTS, EMOTE_SAD, metadata);
			CopyStringToBuffer(buf, "Well that won't do at all. I'll talk to the manager. What outfit do you want, bro?", SCHAR_SORENPANTS, EMOTE_EXCLAMATION, metadata);
			CopyStringToBuffer(buf, "A suit of armor!", SCHAR_BOYGREENSHORTS, EMOTE_HAPPY, metadata);
			CopyStringToBuffer(buf, "Er... how about we settle on some new pants for now.", SCHAR_SORENPANTS, EMOTE_SWEAT, metadata);
			break;
		case 119:
			CopyStringToBuffer(buf, "Welcome to the clothing store. We offer all manners of fashion from across the sea here.");
			break;
		case 120:
			CopyStringToBuffer(buf, "At first glance, I thought this color a bit gaudy. But upon further inspection, I do believe it might pair wonderfully with a top hat of a similar color.", SCHAR_BIF, 0, metadata);
			CopyStringToBuffer(buf, "Does everyone back where you're from dress so crazy? Or just you?", SCHAR_TORRIN, EMOTE_EYEBROWRAISED, metadata);
			CopyStringToBuffer(buf, "Mark my words, boy, fashion will come to this dreadfully drab island sooner or later. Run from it, fear it, but style arrives regardless.", SCHAR_BIF, EMOTE_ANGRY, metadata);
			break;
		case 121:
			CopyStringToBuffer(buf, "This truly is a sad sight.", SCHAR_TULANE, 0, metadata);
			CopyStringToBuffer(buf, "Huh? I thought you'd be happy all the \"peasants\" here are picking up your folk's fashions.", SCHAR_ASHER, 0, metadata);
			CopyStringToBuffer(buf, "The lower classes of this town have no sense of style. They may buy nice clothes, but the haphazard manner in which they throw them together shows how little they truly understand.", SCHAR_TULANE, 0, metadata);
			CopyStringToBuffer(buf, "You really are the worst, you know that? Why not move back to your own home, already?", SCHAR_SORENPANTS, EMOTE_ANGRY, metadata);
			CopyStringToBuffer(buf, "Distasteful as the fashion sense of this island may be, I still stand to profit from it. While there is a market, I will remain.", SCHAR_TULANE, 0, metadata);
			break;
		default:
			CopyStringToBuffer(buf, "I AM ERROR. Please report this error string if you encounter it.");
			break;
	}
	return 0;
}

void CopyStringToBuffer(int buf, int str){
	int size = Min(SizeOfArray(buf), SizeOfArray(str));
	for(int i=0; i<size; ++i){
		buf[i] = str[i];
		if(str[i]==0)
			break;
	}
}

void CopyStringToBuffer(int buf, int str, int charID, int emoteID, int metadata){
	++G[G_CONVOLENGTH]; //Find this string's position in the conversation based on order this function is called, also records the total conversation length
	if(G[G_CONVOINCREMENTER]==G[G_CONVOLENGTH]){ //If this is the current string, copy it over
		CopyStringToBuffer(buf, str);
		metadata[STMD_CHAR] = charID;
		metadata[STMD_EMOTE] = emoteID;
	}
}
	
const int SCHAR_NULL = 0;
const int SCHAR_ASHER = 1;
const int SCHAR_TORRIN = 2;
const int SCHAR_KAYLANI = 3;
const int SCHAR_SELET = 4;
const int SCHAR_HENCHMAN = 5;
const int SCHAR_IRIS = 6;
const int SCHAR_TIM = 7;
const int SCHAR_GINA = 8;
const int SCHAR_DRAKE = 9;
const int SCHAR_BOBBY = 10;
const int SCHAR_KELLY = 11;
const int SCHAR_MANBOOK = 12;
const int SCHAR_RICHMAN = 13;
const int SCHAR_RICHWOMAN = 14;
const int SCHAR_BIF = 15;
const int SCHAR_WOMANGREENSKIRTOUTFIT2 = 16;
const int SCHAR_BOYGREENSHORTS = 17;
const int SCHAR_WOMANREDSKIRTOUTFIT1 = 18;
const int SCHAR_MANREDHAIRGREENSHIRT = 19;
const int SCHAR_PORTMASTER = 20;
const int SCHAR_KENJA = 21;
const int SCHAR_MANBLONDHAIRGREENPANTS = 22;
const int SCHAR_MISTY = 23;
const int SCHAR_WOMANWHITEHAIR = 24;
const int SCHAR_WOMANYELLOWHAIRORANGESKIRT = 25;
const int SCHAR_MERCHANT = 26;
const int SCHAR_MANORANGEPANTS = 27;
const int SCHAR_WOMANBLACKHAIRYELLOWSKIRT = 28;
const int SCHAR_BOOKSTOREOWNER = 29;
const int SCHAR_KAVERIBLOND = 30;
const int SCHAR_BOYBLUESHORTS = 31;
const int SCHAR_MANREDSHORTS = 32;
const int SCHAR_TOTEM = 33;
const int SCHAR_ZEKE = 34;
const int SCHAR_CAIMAN = 35;
const int SCHAR_TERRY = 36;
const int SCHAR_SKAI = 37;
const int SCHAR_DARI = 38;
const int SCHAR_SOREN = 39;
const int SCHAR_PHIN = 40;
const int SCHAR_MANCH = 41;
const int SCHAR_TALCAY = 42;
const int SCHAR_BOY = 43;
const int SCHAR_LAVERNE = 44;
const int SCHAR_TRUF = 45;
const int SCHAR_TRUF2 = 46;
const int SCHAR_CULTISTS = 47;
const int SCHAR_CARTOGRAPHER = 48;
const int SCHAR_SOLARCULTIST = 49;
const int SCHAR_LUNARCULTIST = 50;
const int SCHAR_STELLARCULTIST = 51;
const int SCHAR_UNMASKEDCULTIST = 52;
const int SCHAR_MICAH = 53;
const int SCHAR_NAMAUH = 54;
const int SCHAR_NIMO = 55;
const int SCHAR_FAB = 56;
const int SCHAR_LILAH = 57;
const int SCHAR_MADDA = 58;
const int SCHAR_NELL = 59;
const int SCHAR_ALLIE = 60;
const int SCHAR_BAND = 61;
const int SCHAR_DEN = 62;
const int SCHAR_MORT = 63;
const int SCHAR_HANA = 64;
const int SCHAR_SIYED = 65;
const int SCHAR_TULANE = 66;
const int SCHAR_PIRATE = 67;
const int SCHAR_MOM = 68;
const int SCHAR_UNKNOWN = 69;
const int SCHAR_TORRINYOUNG = 70;
const int SCHAR_ASHERARMOR = 71;
const int SCHAR_SELETNONAME = 72;
const int SCHAR_CAPTAIN = 73;
const int SCHAR_WINNO = 74;
const int SCHAR_GRANDMA = 74;
const int SCHAR_ZARATH = 75;
const int SCHAR_POTIONLADY = 76;
const int SCHAR_SORENPANTS = 77;
const int SCHAR_NIGHTMARCHER = 78;
const int SCHAR_CHASE = 79;
const int SCHAR_BANE = 80;
const int SCHAR_ESAN = 81;
const int SCHAR_MOOSH = 82;
const int SCHAR_RUSS = 83;
const int SCHAR_MICAH2 = 84;
const int SCHAR_MICAH3 = 85;
const int SCHAR_EVAN = 86;
const int SCHAR_BOOK = 87;
const int SCHAR_BARREL = 88;

const int EMOTE_NORMAL = 0;
const int EMOTE_ELLIPSES = 1;
const int EMOTE_EXCLAMATION = 2;
const int EMOTE_QUESTION = 3;
const int EMOTE_ANGRY = 4;
const int EMOTE_SAD = 5;
const int EMOTE_SADISTIC = 6;
const int EMOTE_HAPPY = 7;
const int EMOTE_SWEAT = 8;
const int EMOTE_FURIOUS = 9;
const int EMOTE_IDEA = 10;
const int EMOTE_EMBARRASSED = 11;
const int EMOTE_SURPRISED = 12;
const int EMOTE_DISMAYED = 13;
const int EMOTE_WINK = 14;
const int EMOTE_EYEBROWRAISED = 15;

void GetPortraitNameAndTile(int whichChar){
	G[G_PORTRAITTIL] = 0;
	switch(whichChar){
		case SCHAR_UNKNOWN:
			AssignPortraitName("???");
			G[G_PORTRAITTIL] = -1;
			break;
		case SCHAR_ASHER:
			AssignPortraitName("Asher");
			G[G_PORTRAITTIL] = 104120;
			break;
		case SCHAR_ASHERARMOR:
			AssignPortraitName("Asher");
			G[G_PORTRAITTIL] = 117140;
			break;
		case SCHAR_TORRIN:
			AssignPortraitName("Torrin");
			G[G_PORTRAITTIL] = 104160;
			break;
		case SCHAR_KAYLANI:
			AssignPortraitName("Kaylani");
			G[G_PORTRAITTIL] = 104200;
			break;
		case SCHAR_SELET:
			AssignPortraitName("Selet");
			G[G_PORTRAITTIL] = 106720;
			break;
		case SCHAR_HENCHMAN:
			AssignPortraitName("Henchman");
			break;
		case SCHAR_IRIS:
			AssignPortraitName("Iris");
			G[G_PORTRAITTIL] = 107840;
			break;
		case SCHAR_TIM:
			AssignPortraitName("Tim");
			G[G_PORTRAITTIL] = 107800;
			break;
		case SCHAR_GINA:
			AssignPortraitName("Gina");
			G[G_PORTRAITTIL] = 107760;
			break;
		case SCHAR_DRAKE:
			AssignPortraitName("Drake");
			G[G_PORTRAITTIL] = 107720;
			break;
		case SCHAR_BOBBY:
			AssignPortraitName("Bobby");
			G[G_PORTRAITTIL] = 107940;
			break;
		case SCHAR_KELLY:
			AssignPortraitName("Kelly");
			G[G_PORTRAITTIL] = 107980;
			break;
		case SCHAR_MANBOOK:
			AssignPortraitName("Man");
			G[G_PORTRAITTIL] = 107460;
			break;
		case SCHAR_RICHMAN:
			AssignPortraitName("Man");
			G[G_PORTRAITTIL] = 107380;
			break;
		case SCHAR_RICHWOMAN:
			AssignPortraitName("Woman");
			G[G_PORTRAITTIL] = 107420;
			break;
		case SCHAR_BIF:
			AssignPortraitName("Bif Wellington");
			G[G_PORTRAITTIL] = 107380;
			break;
		case SCHAR_WOMANGREENSKIRTOUTFIT2:
			AssignPortraitName("Milla");
			G[G_PORTRAITTIL] = 108280;
			break;
		case SCHAR_BOYGREENSHORTS:
			AssignPortraitName("Dylan");
			G[G_PORTRAITTIL] = 108020;
			break;
		case SCHAR_WOMANREDSKIRTOUTFIT1:
			AssignPortraitName("Woman");
			G[G_PORTRAITTIL] = 107500;
			break;
		case SCHAR_MANREDHAIRGREENSHIRT:
			AssignPortraitName("Man");
			G[G_PORTRAITTIL] = 108320;
			break;
		case SCHAR_PORTMASTER:
			AssignPortraitName("Portmaster");
			G[G_PORTRAITTIL] = 107680;
			break;
		case SCHAR_KENJA:
			AssignPortraitName("Kenja");
			G[G_PORTRAITTIL] = 108420;
			break;
		case SCHAR_MANBLONDHAIRGREENPANTS:
			AssignPortraitName("Man");
			G[G_PORTRAITTIL] = 108460;
			break;
		case SCHAR_MISTY:
			AssignPortraitName("Misty");
			G[G_PORTRAITTIL] = 108060;
			break;
		case SCHAR_WOMANWHITEHAIR:
			AssignPortraitName("Woman");
			G[G_PORTRAITTIL] = 108360;
			break;
		case SCHAR_WOMANYELLOWHAIRORANGESKIRT:
			AssignPortraitName("Woman");
			G[G_PORTRAITTIL] = 108200;
			break;
		case SCHAR_WOMANBLACKHAIRYELLOWSKIRT:
			AssignPortraitName("Woman");
			G[G_PORTRAITTIL] = 108100;
			break;
		case SCHAR_MERCHANT:
			AssignPortraitName("Merchant");
			G[G_PORTRAITTIL] = 107640;
			break;
		case SCHAR_MANORANGEPANTS:
			AssignPortraitName("Man");
			G[G_PORTRAITTIL] = 107720;
			break;
		case SCHAR_BOOKSTOREOWNER:
			AssignPortraitName("Woman");
			G[G_PORTRAITTIL] = 108540;
			break;
		case SCHAR_KAVERIBLOND:
			AssignPortraitName("Girl");
			G[G_PORTRAITTIL] = 108500;
			break;
		case SCHAR_BOYBLUESHORTS:
			AssignPortraitName("Boy");
			G[G_PORTRAITTIL] = 107800;
			break;
		case SCHAR_MANREDSHORTS:
			AssignPortraitName("Man");
			G[G_PORTRAITTIL] = 107940;
			break;
		case SCHAR_TOTEM:
			AssignPortraitName("Totem");
			G[G_PORTRAITTIL] = 28534;
			break;
		case SCHAR_ZEKE:
			AssignPortraitName("Zeke");
			G[G_PORTRAITTIL] = 108800;
			break;
		case SCHAR_CAIMAN:
			AssignPortraitName("Caiman");
			G[G_PORTRAITTIL] = 108760;
			break;
		case SCHAR_TERRY:
			AssignPortraitName("Terry");
			G[G_PORTRAITTIL] = 101560;
			break;
		case SCHAR_SKAI:
			AssignPortraitName("Skai");
			G[G_PORTRAITTIL] = 108620;
			break;
		case SCHAR_DARI:
			AssignPortraitName("Dari");
			G[G_PORTRAITTIL] = 110360;
			break;
		case SCHAR_SOREN:
			AssignPortraitName("Soren");
			G[G_PORTRAITTIL] = 110400;
			break;
		case SCHAR_PHIN:
			AssignPortraitName("Phin");
			G[G_PORTRAITTIL] = 108840;
			break;
		case SCHAR_MANCH:
			AssignPortraitName("Manch");
			G[G_PORTRAITTIL] = 110440;
			break;
		case SCHAR_TALCAY:
			AssignPortraitName("Talcay");
			G[G_PORTRAITTIL] = 110500;
			break;
		case SCHAR_BOY:
			AssignPortraitName("Boy");
			G[G_PORTRAITTIL] = 106220;
			break;
		case SCHAR_LAVERNE:
			AssignPortraitName("Laverne");
			G[G_PORTRAITTIL] = 109620;
			break;
		case SCHAR_TRUF:
			AssignPortraitName("Truf");
			G[G_PORTRAITTIL] = 110240;
			break;
		case SCHAR_TRUF2:
			AssignPortraitName("Truf");
			G[G_PORTRAITTIL] = 110580;
			break;
		case SCHAR_CULTISTS:
			AssignPortraitName("Cultist");
			G[G_PORTRAITTIL] = 106600;
			break;
		case SCHAR_CARTOGRAPHER:
			AssignPortraitName("Cartographer");
			G[G_PORTRAITTIL] = 109020;
			break;
		case SCHAR_SOLARCULTIST:
			AssignPortraitName("???");
			G[G_PORTRAITTIL] = 106600;
			break;
		case SCHAR_LUNARCULTIST:
			AssignPortraitName("???");
			G[G_PORTRAITTIL] = 106640;
			break;
		case SCHAR_STELLARCULTIST:
			AssignPortraitName("???");
			G[G_PORTRAITTIL] = 106680;
			break;
		case SCHAR_UNMASKEDCULTIST:
			AssignPortraitName("???");
			G[G_PORTRAITTIL] = 107080;
			break;
		case SCHAR_MICAH:
			AssignPortraitName("Micah");
			G[G_PORTRAITTIL] = 107080;
			break;
		case SCHAR_MICAH2:
			AssignPortraitName("Micah");
			G[G_PORTRAITTIL] = 106916;
			break;
		case SCHAR_MICAH3:
			AssignPortraitName("Micah");
			G[G_PORTRAITTIL] = 111480;
			break;
		case SCHAR_NAMAUH:
			AssignPortraitName("Namauh");
			G[G_PORTRAITTIL] = 109800;
			break;
		case SCHAR_NIMO:
			AssignPortraitName("Nimo");
			G[G_PORTRAITTIL] = 109140;
			break;
		case SCHAR_FAB:
			AssignPortraitName("Fab");
			G[G_PORTRAITTIL] = 109100;
			break;
		case SCHAR_LILAH:
			AssignPortraitName("Lilah");
			G[G_PORTRAITTIL] = 110320;
			break;
		case SCHAR_MADDA:
			AssignPortraitName("Madda");
			G[G_PORTRAITTIL] = 109660;
			break;
		case SCHAR_NELL:
			AssignPortraitName("Nell");
			G[G_PORTRAITTIL] = 109880;
			break;
		case SCHAR_ALLIE:
			AssignPortraitName("Allie");
			G[G_PORTRAITTIL] = 109840;
			break;
		case SCHAR_BAND:
			AssignPortraitName("Band");
			G[G_PORTRAITTIL] = 110620;
			break;
		case SCHAR_DEN:
			AssignPortraitName("Den");
			G[G_PORTRAITTIL] = 110280; 
			break;
		case SCHAR_MORT:
			AssignPortraitName("Mort");
			G[G_PORTRAITTIL] = 108980; 
			break;
		case SCHAR_HANA:
			AssignPortraitName("Hana");
			G[G_PORTRAITTIL] = 110180; 
			break;
		case SCHAR_SIYED:
			AssignPortraitName("Siyed");
			G[G_PORTRAITTIL] = 101600; 
			break;
		case SCHAR_TULANE:
			AssignPortraitName("Madame Tulane");
			G[G_PORTRAITTIL] = 107420;
			break;
		case SCHAR_PIRATE:
			AssignPortraitName("Pirate");
			G[G_PORTRAITTIL] = 106340;
			break;
		case SCHAR_MOM:
			AssignPortraitName("Mom");
			G[G_PORTRAITTIL] = 108580;
			break;
		case SCHAR_TORRINYOUNG:
			AssignPortraitName("Torrin");
			G[G_PORTRAITTIL] = 108720;
			break;
		case SCHAR_SELETNONAME:
			AssignPortraitName("???");
			G[G_PORTRAITTIL] = 109200;
			break;
		case SCHAR_CAPTAIN:
			AssignPortraitName("Shelrond");
			G[G_PORTRAITTIL] = 106540;
			break;
		case SCHAR_WINNO:
			AssignPortraitName("Winno");
			G[G_PORTRAITTIL] = 111020;
			break;
		case SCHAR_ZARATH:
			AssignPortraitName("Shady Merchant");
			G[G_PORTRAITTIL] = 111180;
			break;
		case SCHAR_POTIONLADY:
			AssignPortraitName("Woman");
			G[G_PORTRAITTIL] = 108398;
			break;
		case SCHAR_SORENPANTS:
			AssignPortraitName("Soren");
			G[G_PORTRAITTIL] = 101520;
			break;
		case SCHAR_NIGHTMARCHER:
			AssignPortraitName("Nightmarcher");
			G[G_PORTRAITTIL] = 106300;
			break;
		case SCHAR_CHASE:
			AssignPortraitName("Chase");
			G[G_PORTRAITTIL] = 111540;
			break;
		case SCHAR_BANE:
			AssignPortraitName("The Bloodmoon");
			G[G_PORTRAITTIL] = 111100;
			break;
		case SCHAR_ESAN:
			AssignPortraitName("Esan");
			G[G_PORTRAITTIL] = 111140;
			break;
		case SCHAR_MOOSH:
			AssignPortraitName("Moosh");
			G[G_PORTRAITTIL] = 107696;
			break;
		case SCHAR_RUSS:
			AssignPortraitName("Russ");
			G[G_PORTRAITTIL] = 107956;
			break;
		case SCHAR_EVAN:
			AssignPortraitName("Evan");
			G[G_PORTRAITTIL] = 108199;
			break;
		case SCHAR_BOOK:
			AssignPortraitName("Book");
			G[G_PORTRAITTIL] = -1;
			break;
		case SCHAR_BARREL:
			AssignPortraitName("???");
			G[G_PORTRAITTIL] = -1;
			break;
	}
}

//Get a banter string based on the current DMap
void LoadDMapBanter(int whichDMap){
	G[G_MAXBANTER] = 0;
	AddDMapBanter(StoryBanter());
	switch(whichDMap){
		case 0: //Omaka
			if(Link->Item[I_KAYLANI]){
				AddDMapBanter(100);
			}
			else{
				AddDMapBanter(200);
			}
			break;
	}
}
void AddDMapBanter(int which){
	switch(G[G_MAXBANTER]){
		case 0:
			G[G_BANTER1] = which;
			break;
		case 1:
			G[G_BANTER2] = which;
			break;
		case 2:
			G[G_BANTER3] = which;
			break;
		case 3:
			G[G_BANTER4] = which;
			break;
		case 4:
			G[G_BANTER5] = which;
			break;
		case 5:
			G[G_BANTER6] = which;
			break;
	}
	++G[G_MAXBANTER];
}
int GetDMapBanter(int which){
	switch(which){
		case 0:
			return G[G_BANTER1];
		case 1:
			return G[G_BANTER2];
		case 2:
			return G[G_BANTER3];
		case 3:
			return G[G_BANTER4];
		case 4:
			return G[G_BANTER5];
		case 5:
			return G[G_BANTER6];
	}
}
int GetNextDMapBanter(){
	for(int i=0; i<G[G_MAXBANTER]+1; ++i){
		if(G[G_BANTERCYCLE]>=G[G_MAXBANTER]){
			G[G_BANTERCYCLE] = 0;
		}
		int banter = GetDMapBanter(G[G_BANTERCYCLE]);
		++G[G_BANTERCYCLE];
		if(LoreTracking[LT_BANTER+banter]==0||i==G[G_MAXBANTER]){
			return banter;
		}
	}
	if(G[G_BANTERCYCLE]>=G[G_MAXBANTER]){
		G[G_BANTERCYCLE] = 0;
	}
	int banter = GetDMapBanter(G[G_BANTERCYCLE]);
	++G[G_BANTERCYCLE];
	return banter;
}


//Get a banter string based on story progress
int StoryBanter(){
	switch(Game->Counter[CR_STORYFLAG]){
		case 0:
			return 0;
		case 1:
			return 1;
		case 2...99:
			return 2;
		default:
			return 0;
	}
}

void LoadBanter(int strings, int whichString){
	G[G_BANTERLENGTH] = 0;
	G[G_BANTERSTRINGPOS] = 0;
	G[G_BANTERID] = whichString;
	switch(whichString){
		//0-99: Plot Strings
		case 0: //Debug String 1
			BanterString(strings, "The plot flag says 0 right now.", SCHAR_ASHER, EMOTE_NORMAL);
			BanterString(strings, "When the counter gets updated, our universal dialogue will update.", SCHAR_TORRIN, EMOTE_NORMAL);
			BanterString(strings, "Neat, isn't it?", SCHAR_ASHER, EMOTE_NORMAL);
			break;
		case 1: //Debug String 2
			BanterString(strings, "Now the plot flag is set to 1.", SCHAR_ASHER, EMOTE_NORMAL);
			BanterString(strings, "Huh. And the subscreen banter really changed.", SCHAR_KAYLANI, EMOTE_NORMAL);
			break;
		case 2: //Debug String 3
			BanterString(strings, "The plot flag is 2! I repeat, we are at plot flag alert level 2!", SCHAR_ASHER, EMOTE_NORMAL);
			BanterString(strings, "When will it stop!? Oh the humanity!", SCHAR_TORRIN, EMOTE_NORMAL);
			BanterString(strings, "Now probably, because Moosh didn't make any more of these debug messages.", SCHAR_ASHER, EMOTE_NORMAL);
			BanterString(strings, "...", SCHAR_ASHER, EMOTE_WINK);
			break;
		//100-199: Asher + Kaylani + Torrin Strings
		case 100: //Debug String 4
			BanterString(strings, "Hi I'm Asher and this is a debug string.", SCHAR_ASHER, EMOTE_NORMAL);
			BanterString(strings, "Still a debug string.", SCHAR_TORRIN, EMOTE_NORMAL);
			BanterString(strings, "Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug Debug", SCHAR_KAYLANI, EMOTE_NORMAL);
			BanterString(strings, "Still the debug string persists.", SCHAR_TORRIN, EMOTE_SAD);
			BanterString(strings, "All returns to despair...", SCHAR_ASHER, EMOTE_ELLIPSES);
			BanterString(strings, "Never to be free of the cycle of suffering.", SCHAR_KAYLANI, EMOTE_NORMAL);
			break;
		//200-299: Asher + Torrin Strings
		case 200: //Debug String 5
			BanterString(strings, "This is a debug string but with only me and Torrin in the party.", SCHAR_ASHER, EMOTE_NORMAL);
			BanterString(strings, "No girls allowed.", SCHAR_TORRIN, EMOTE_NORMAL);
			BanterString(strings, "But-", SCHAR_KAYLANI, EMOTE_NORMAL);
			BanterString(strings, "No. Girls. Allowed.", SCHAR_TORRIN, EMOTE_ANGRY);
			break;
		//300-399: Torrin + Kaylani Strings
		//400-499: Asher + Kaylani Strings
		//500-599: Asher Alone Strings
		//600-699: Torrin Alone Strings
		//700-799: Kaylani Alone Strings
		default:
			break;
	}
}

void BanterString(int strings, int str, int charID, int emoteID){
	int buf = strings[2+G[G_BANTERLENGTH]*3];
	CopyStringToBuffer(buf, str);
	strings[0+G[G_BANTERLENGTH]*3] = charID;
	strings[1+G[G_BANTERLENGTH]*3] = emoteID;
	++G[G_BANTERLENGTH]; //Find this string's position in the conversation based on order this function is called, also records the total conversation length
}

int BestiaryListNum(int id){
	switch(id){
		case 22: //Red Octo
			return 0;
		case 23: //Blue Octo
			return 1;
		case 26: //Crab
			return 2;
		case 27: //Armored Crab
			return 3;
		case 137: //Embedded Crab
			return 4;
		case 45: //Red Ratang
			return 5;
		case 46: //Blue Ratang
			return 6;
		case 136: //Pale Ratang
			return 7;
		case 221: //Lunatic Ratang
			return 8;
		case 38: //Bat
			return 9;
		case 106: //Mad Bat
			return 10;
		case 189: //Spider
			return 11;
		case 194: //Bloated Spider
			return 12;
		case 187: //Rat
			return 13;
		case 44: //Snake
			return 14;
		case 80: //Jungle Snake
			return 15;
		case 190: //Skullpent
			return 16;
		case 223: //Ossified Serpent
			return 17;
		case 25: //Sea Strider
			return 18; 
		case 24: //Cliff Strider
			return 19;
		case 222: //Sun Strider
			return 20;
		case 138: //Dimlit
			return 21;
		case 139: //Flaming Dimlit
			return 22;
		case 225: //Spine Puffer
			return 23;
		case 224: //Fire Puffer
			return 24;
		case 226: //Star Puffer
			return 25;
		case 237: //Red Hopmaw
			return 26;
		case 238: //Blue Hopmaw
			return 27;
		case 239: //Beehive
			return 28;
		case 195: //Sawtooth
			return 29;
		case 33: //Zolo
			return 30;
		case 43: //Droplet
			return 31;
		case 42: //Driplet
			return 32;
		case 196: //Spiny Beetle
			return 33;
		case 198: //Solar Curstellation
			return 34;
		case 197: //Lunar Cursetellation
			return 35;
		case 212: //Stellar Curstellation
			return 36;
		case 178: //Boomba
			return 37;
		case 179: //Plated Boomba
			return 38;
		case 199: //Quad Cannon
			return 39;
		case 54: //Mummy
			return 40;
		case 220: //Blood Mummy
			return 41;
		case 210: //Stone Guardian
			return 42;
		case 229: //Stone Helmet
			return 43;
		case 35: //Ghost
			return 44;
		case 209: //Cosmic Spook
			return 45;
		case 227: //Nightmarcher
			return 46;
		case 232: //Suneater
			return 47;
		case 233: //Mooneater
			return 48;
		case 234: //Stareater
			return 49;
		case 56: //Solar Wizard
			return 50;
		case 57: //Lunar Wizard
			return 51;
		case 153: //Stellar Wizard
			return 52;
		case 180: //Solar Crablike
			return 53;
		case 181: //Lunar Crablike
			return 54;
		case 182: //Stellar Crablike
			return 55;
		case 183: //Solar Startouched
			return 56;
		case 184: //Lunar Startouched
			return 57;
		case 185: //Stellar Startouched
			return 58;
		case 203: //Solar Pillar
			return 59;
		case 204: //Lunar Pillar 
			return 60;
		case 205: //Stellar Pillar
			return 61;
		case 191: //Blade Pirate
			return 62;
		case 192: //Pistol Pirate
			return 63;
		case 193: //Battery Pirate
			return 64;
		case 231: //Elite Pirate
			return 65;
		case 186: //Solar Mask
			return 66;
		case 188: //Lunar Mask
			return 67;
		case 211: //Stellar Mask
			return 68;
		case 206: //Solar Spellbearer
			return 69;
		case 207: //Lunar Spellbearer
			return 70;
		case 208: //Stellar Spellbearer
			return 71;
		case 213: //Solar Golem
			return 72;
		case 214: //Lunar Golem
			return 73;
		case 215: //Stellar Golem
			return 74;
		case 244: //Fusion Golem
			return 75;
		case 218: //Captain Shelrond
			return 76;
		case 216: //Bolide Borer 2000
			return 77;
		case 242: //Esan
			return 78;
		case 217: //Selet
			return 79;
		case 236: //Nightmare Selet
			return 80;
		case 251: //Chase
			if(G[G_RANDOMIZERENABLED])
				return -1;
			return 81;
		default:
			return -1;
	}
}
int BestiaryEnemyID(int num){
	switch(num){
		case 0: //Red Octo
			return 22;
		case 1: //Blue Octo
			return 23;
		case 2: //Crab
			return 26;
		case 3: //Armored Crab
			return 27;
		case 4: //Embedded Crab
			return 137;
		case 5: //Red Ratang
			return 45;
		case 6: //Blue Ratang
			return 46;
		case 7: //Pale Ratang
			return 136;
		case 8: //Lunatic Ratang
			return 221;
		case 9: //Bat
			return 38;
		case 10: //Mad Bat
			return 106;
		case 11: //Spider
			return 189;
		case 12: //Bloated Spider
			return 194;
		case 13: //Rat
			return 187;
		case 14: //Snake
			return 44;
		case 15: //Jungle Snake
			return 80;
		case 16: //Skullpent
			return 190;
		case 17: //Ossified Serpent
			return 223;
		case 18: //Sea Strider
			return 25; 
		case 19: //Cliff Strider
			return 24;
		case 20: //Sun Strider
			return 222;
		case 21: //Dimlit
			return 138;
		case 22: //Flaming Dimlit
			return 139;
		case 23: //Spine Puffer
			return 225;
		case 24: //Fire Puffer
			return 224;
		case 25: //Star Puffer
			return 226;
		case 26: //Red Hopmaw
			return 237;
		case 27: //Blue Hopmaw
			return 238;
		case 28: //Beehive
			return 239;
		case 29: //Sawtooth
			return 195;
		case 30: //Zolo
			return 33;
		case 31: //Droplet
			return 43;
		case 32: //Driplet
			return 42;
		case 33: //Spiny Beetle
			return 196;
		case 34: //Solar Curstellation
			return 198;
		case 35: //Lunar Cursetellation
			return 197;
		case 36: //Stellar Curstellation
			return 212;
		case 37: //Boomba
			return 178;
		case 38: //Plated Boomba
			return 179;
		case 39: //Quad Cannon
			return 199;
		case 40: //Mummy
			return 54;
		case 41: //Blood Mummy
			return 220;
		case 42: //Stone Guardian
			return 210;
		case 43: //Stone Helmet
			return 229;
		case 44: //Ghost
			return 35;
		case 45: //Cosmic Spook
			return 209;
		case 46: //Nightmarcher
			return 227;
		case 47: //Suneater
			return 232;
		case 48: //Mooneater
			return 233;
		case 49: //Stareater
			return 234;
		case 50: //Solar Wizard
			return 56;
		case 51: //Lunar Wizard
			return 57;
		case 52: //Stellar Wizard
			return 153;
		case 53: //Solar Crablike
			return 180;
		case 54: //Lunar Crablike
			return 181;
		case 55: //Stellar Crablike
			return 182;
		case 56: //Solar Startouched
			return 183;
		case 57: //Lunar Startouched
			return 184;
		case 58: //Stellar Startouched
			return 185;
		case 59: //Solar Pillar
			return 203;
		case 60: //Lunar Pillar 
			return 204;
		case 61: //Stellar Pillar
			return 205;
		case 62: //Blade Pirate
			return 191;
		case 63: //Pistol Pirate
			return 192;
		case 64: //Battery Pirate
			return 193;
		case 65: //Elite Pirate
			return 231;
		case 66: //Solar Mask
			return 186;
		case 67: //Lunar Mask
			return 188;
		case 68: //Stellar Mask
			return 211;
		case 69: //Solar Spellbearer
			return 206;
		case 70: //Lunar Spellbearer
			return 207;
		case 71: //Stellar Spellbearer
			return 208;
		case 72: //Solar Golem
			return 213;
		case 73: //Lunar Golem
			return 214;
		case 74: //Stellar Golem
			return 215;
		case 75: //Fusion Golem
			return 244;
		case 76: //Captain Shelrond
			return 218;
		case 77: //Bolide Borer 2000
			return 216;
		case 78: //Esan
			return 242;
		case 79: //Selet
			return 217;
		case 80: //Nightmare Selet
			return 236;
		case 81: //Chase
			return 251;
		default:
			return -1;
	}
}

void BestiaryName(int buf, int id, bool shorten, bool checkLore){
	if(checkLore&&LoreTracking[LT_ENEMIES+id]==0)
		id = -1;
	switch(id){
		case 22:
			CopyStringToBuffer(buf, "Red Octo");
			break;
		case 23:
			CopyStringToBuffer(buf, "Blue Octo");
			break;
		case 26:
			CopyStringToBuffer(buf, "Crab");
			break;
		case 27:
			CopyStringToBuffer(buf, "Armored Crab");
			break;
		case 137:
			CopyStringToBuffer(buf, "Embedded Crab");
			break;
		case 45:
			CopyStringToBuffer(buf, "Red Ratang");
			break;
		case 46:
			CopyStringToBuffer(buf, "Blue Ratang");
			break;
		case 136:
			CopyStringToBuffer(buf, "Pale Ratang");
			break;
		case 221:
			CopyStringToBuffer(buf, "Lunatic Ratang");
			break;
		case 38:
			CopyStringToBuffer(buf, "Bat");
			break;
		case 106:
			CopyStringToBuffer(buf, "Mad Bat");
			break;
		case 189:
			CopyStringToBuffer(buf, "Spider");
			break;
		case 194:
			CopyStringToBuffer(buf, "Bloated Spider");
			break;
		case 187:
			CopyStringToBuffer(buf, "Rat");
			break;
		case 44:
			CopyStringToBuffer(buf, "Snake");
			break;
		case 80:
			CopyStringToBuffer(buf, "Jungle Snake");
			break;
		case 190:
			CopyStringToBuffer(buf, "Skullpent");
			break;	
		case 223:
			if(shorten)
				CopyStringToBuffer(buf, "O. Serpent");
			else
				CopyStringToBuffer(buf, "Ossified Serpent");
			break;
		case 25:
			CopyStringToBuffer(buf, "Sea Strider");
			break;
		case 24:
			CopyStringToBuffer(buf, "Cliff Strider");
			break;
		case 222:
			CopyStringToBuffer(buf, "Sun Strider");
			break;
		case 138:
			CopyStringToBuffer(buf, "Dimlit");
			break;
		case 139:
			CopyStringToBuffer(buf, "Flaming Dimlit");
			break;
		case 224:
			CopyStringToBuffer(buf, "Fire Puffer");
			break;
		case 225:
			CopyStringToBuffer(buf, "Spine Puffer");
			break;
		case 226:
			CopyStringToBuffer(buf, "Star Puffer");
			break;
		case 237:
			CopyStringToBuffer(buf, "Red Hopmaw");
			break;
		case 238:
			CopyStringToBuffer(buf, "Blue Hopmaw");
			break;
		case 239:
			CopyStringToBuffer(buf, "Beehive");
			break;
		case 195:
			CopyStringToBuffer(buf, "Sawtooth");
			break;
		case 33:
			CopyStringToBuffer(buf, "Zolo");
			break;
		case 42:
			CopyStringToBuffer(buf, "Driplet");
			break;
		case 43:
			CopyStringToBuffer(buf, "Droplet");
			break;
		case 196:
			CopyStringToBuffer(buf, "Spiny Beetle");
			break;
		case 198:
			if(shorten)
				CopyStringToBuffer(buf, "S. Curse");
			else
				CopyStringToBuffer(buf, "Solar Curstellation");
			break;
		case 197:
			if(shorten)
				CopyStringToBuffer(buf, "L. Curse");
			else
				CopyStringToBuffer(buf, "Lunar Curstellation");
			break;
		case 212:
			if(shorten)
				CopyStringToBuffer(buf, "St. Curse");
			else
				CopyStringToBuffer(buf, "Stellar Curstellation");
			break;
		case 178:
			CopyStringToBuffer(buf, "Boomba");
			break;
		case 179:
			CopyStringToBuffer(buf, "Plated Boomba");
			break;
		case 199:
			CopyStringToBuffer(buf, "Quad-Cannon");
			break;
		case 54:
			CopyStringToBuffer(buf, "Mummy");
			break;
		case 220:
			CopyStringToBuffer(buf, "Blood Mummy");
			break;
		case 210:
			CopyStringToBuffer(buf, "Stone Guardian");
			break;
		case 229:
			CopyStringToBuffer(buf, "Stone Helmet");
			break;
		case 35:
			CopyStringToBuffer(buf, "Ghost");
			break;
		case 209:
			CopyStringToBuffer(buf, "Cosmic Spook");
			break;
		case 227:
			CopyStringToBuffer(buf, "Nightmarcher");
			break;
		case 232:
			CopyStringToBuffer(buf, "Suneater");
			break;
		case 233:
			CopyStringToBuffer(buf, "Mooneater");
			break;
		case 234:
			CopyStringToBuffer(buf, "Stareater");
			break;
		case 56:
			CopyStringToBuffer(buf, "Solar Wizard");
			break;
		case 57:
			CopyStringToBuffer(buf, "Lunar Wizard");
			break;
		case 153:
			CopyStringToBuffer(buf, "Stellar Wizard");
			break;
		case 180:
			if(shorten)
				CopyStringToBuffer(buf, "S. Crablike");
			else
				CopyStringToBuffer(buf, "Solar Crablike");
			break;
		case 181:
			if(shorten)
				CopyStringToBuffer(buf, "L. Crablike");
			else
				CopyStringToBuffer(buf, "Lunar Crablike");
			break;
		case 182:
			if(shorten)
				CopyStringToBuffer(buf, "St. Crablike");
			else
				CopyStringToBuffer(buf, "Stellar Crablike");
			break;
		case 183:
			if(shorten)
				CopyStringToBuffer(buf, "S. Startouched");
			else
				CopyStringToBuffer(buf, "Solar Startouched");
			break;
		case 184:
			if(shorten)
				CopyStringToBuffer(buf, "L. Startouched");
			else
				CopyStringToBuffer(buf, "Lunar Startouched");
			break;
		case 185:
			if(shorten)
				CopyStringToBuffer(buf, "St. Startouched");
			else
				CopyStringToBuffer(buf, "Stellar Startouched");
			break;
		case 203:
			CopyStringToBuffer(buf, "Solar Pillar");
			break;
		case 204:
			CopyStringToBuffer(buf, "Lunar Pillar");
			break;
		case 205:
			CopyStringToBuffer(buf, "Stellar Pillar");
			break;
		case 191:
			CopyStringToBuffer(buf, "Blade Pirate");
			break;
		case 192:
			CopyStringToBuffer(buf, "Pistol Pirate");
			break;
		case 193:
			CopyStringToBuffer(buf, "Battery Pirate");
			break;
		case 231:
			CopyStringToBuffer(buf, "Elite Pirate");
			break;
		case 186:
			CopyStringToBuffer(buf, "Solar Mask");
			break;
		case 188:
			CopyStringToBuffer(buf, "Lunar Mask");
			break;
		case 211:
			CopyStringToBuffer(buf, "Stellar Mask");
			break;
		case 206:
			if(shorten)
				CopyStringToBuffer(buf, "S. Spellbearer");
			else
				CopyStringToBuffer(buf, "Solar Spellbearer");
			break;
		case 207:
			if(shorten)
				CopyStringToBuffer(buf, "L. Spellbearer");
			else
				CopyStringToBuffer(buf, "Lunar Spellbearer");
			break;
		case 208:
			if(shorten)
				CopyStringToBuffer(buf, "St. Spellbearer");
			else
				CopyStringToBuffer(buf, "Stellar Spellbearer");
			break;
		case 213:
			CopyStringToBuffer(buf, "Solar Golem");
			break;
		case 214:
			CopyStringToBuffer(buf, "Lunar Golem");
			break;
		case 215:
			CopyStringToBuffer(buf, "Stellar Golem");
			break;
		case 244:
			CopyStringToBuffer(buf, "Fusion Golem");
			break;
		case 218:
			if(shorten)
				CopyStringToBuffer(buf, "Cpt. Shelrond");
			else
				CopyStringToBuffer(buf, "Captain Shelrond");
			break;
		case 216:
			if(shorten)
				CopyStringToBuffer(buf, "B.B. 2000");
			else
				CopyStringToBuffer(buf, "Bolide Borer 2000");
			break;
		case 242:
			if(shorten)
				CopyStringToBuffer(buf, "Esan");
			else
				CopyStringToBuffer(buf, "Esan, the Bloodmoon");
			break;
		case 217:
			if(shorten)
				CopyStringToBuffer(buf, "Selet");
			else
				CopyStringToBuffer(buf, "Selet Igorevich");
			break;
		case 236:
			CopyStringToBuffer(buf, "Nightmare Selet");
			break;
		case 251:
			CopyStringToBuffer(buf, "Chase?");
			break;
		default:
			CopyStringToBuffer(buf, "???");
			break;
	}
}

void BestiaryDescription(int buf, int id){
	if(LoreTracking[LT_ENEMIES+id]==0)
		id = -1;
	switch(id){
		case 22:
			CopyStringToBuffer(buf, "Some several million years ago, the first Octo wandered its way onto dry land. Since then they've continued to multiply, in flagrant defiance of nature. Many in the pest control business wish they'd one day go back where they came.");
			break;
		case 23:
			CopyStringToBuffer(buf, "It's tougher than its red counterpart, but only slightly. The rocks it spits up pack quite a punch...And make one wonder how miserable the Octo's existence must be. @26@26There's something oddly familiar about this creature...");
			break;
		case 26:
			CopyStringToBuffer(buf, "Crabs like these can frequently be seen scuttling about the beaches of Omaka and its surrounding islands. They grow to a pretty impressive size too.");
			break;
		case 27:
			CopyStringToBuffer(buf, "The armored crab is very territorial and will attack anything that comes near its burrow. Many will come near anyways, as its meat is very sought after.");
			break;
		case 137:
			CopyStringToBuffer(buf, "Armored crabs will sometimes collect objects they find buried in the sand. This unfortunate one has picked up a crystal, which has burrowed into its head, also allowing it to release uncontrolled bursts of solar magic.");
			break;
		case 45:
			CopyStringToBuffer(buf, "Ratangs prefer to hunt in packs, surrounding and overwhelming their prey. Due to their reduced stature, they're rarely seen going after human settlements, but ratang attacks on travelers in the wild are not unheard of.");
			break;
		case 46:
			CopyStringToBuffer(buf, "The ratang's tool use is unusual amongst its kind. Despite its ratlike appearance it's rarely seen without its signature boomerang. Many a researcher has been met with the blunt end of it, upon closer examination.");
			break;
		case 136:
			CopyStringToBuffer(buf, "Pale ratangs have a thick white coat of fur well suited for the cold elevated mountainsides and caves of Mauna Ali'i. Despite this they're still often overwhelmed by the harsh mountain conditions and are nearing the brink of extinction.");
			break;
		case 221:
			CopyStringToBuffer(buf, "The lunatic ratang has had a lunar jewel embedded in its eye. The energy emanating from it has seeped into its brain, driving it into a frenzy and granting its boomerang magical properties.");
			break;
		case 38:
			CopyStringToBuffer(buf, "Despite his arguably frightening face, the bat really isn't doing anything wrong. Maybe you should leave him alone?");
			break;
		case 106:
			CopyStringToBuffer(buf, "...This asshole on the other hand. C'mere ya big dumb bat. I'ma give ya a wallop!");
			break;
		case 189:
			CopyStringToBuffer(buf, "Wherever there's darkness, these spiders feel obligated to skitter about in it. They're rarely seen far from large gatherings of people, though for some reason. Maybe they feed on fear?");
			break;
		case 194:
			CopyStringToBuffer(buf, "The bloated spider exists as a testament to the occasional cruelty of nature. Deeply uncomfortable, grotesque, and alarmingly large...");
			break;
		case 187:
			CopyStringToBuffer(buf, "Rats can be found anywhere filth is abundant and health and safety regulations are optional. This particular kind are aggressive and will scurry up to bite anything in their line of sight...Not very tough though.");
			break;
		case 44:
			CopyStringToBuffer(buf, "This is just your average garden variety snake, though hopefully not found in your garden. It's not venomous and doesn't pack much of a bite, yet makes up for that in aggression.");
			break;
		case 80:
			CopyStringToBuffer(buf, "It's said that in the jungles of Wahiokala, you can find at least one of these snakes for every four square meters, preferring to hide out in the bushes and in the trees. If it's any consolation to any snake fearing travelers, the statistics are likely very exaggerated.");
			break;
		case 190:
			CopyStringToBuffer(buf, "This snake has slithered into some animal's skull and wears it as a makeshift helmet. It protects it from damage, but the tail still remains vulnerable.");
			break;	
		case 223:
			CopyStringToBuffer(buf, "Having been pierced by a shard of stellar crystal, this serpent's face has hardened into a mask of bone. It has gone blind, but can still sense movement through the crystal embedded in its skull, also allowing it to fire off powerful stellar blasts when the mask is impacted.");
			break;
		case 25:
			CopyStringToBuffer(buf, "This spider-like creature has cupped feet that allow it to skip across the surface of the water. They can sometimes be seen leaping across open ocean, migrating from island to island.");
			break;
		case 24:
			CopyStringToBuffer(buf, "The cliff strider has longer, stronger legs than its seafaring counterpart, allowing it to ascend even the summit of Mauna Ali'i with relative ease.");
			break;
		case 222:
			CopyStringToBuffer(buf, "While other striders are content to cross the land or sea, this one will not accept anything so small. \"Today,\" it says, \"I will walk on the sun.\" And so a miniature sun appears wherever it steps.");
			break;
		case 138:
			CopyStringToBuffer(buf, "The dimlit has a special organ for storing combustible gas, allowing it to breathe fire. It's more comparable to the mythical dragon than a typical lizard. If only it was a little larger...");
			break;
		case 139:
			CopyStringToBuffer(buf, "Sometimes when children are misbehaved or refuse to study, their mothers might say, \"If you don't keep up with your studies, you'll transform into a dimlit.\" @26@26The dimlit takes no offense to this, as the lizard brain has no capacity for that. But it's still pretty rude on all accounts.");
			break;
		case 225:
			CopyStringToBuffer(buf, "Some might question how the typically aquatic spine puffer can effortlessly float through the air. Not enough question how a creature evolved to explode at the smallest sign of threat.");
			break;
		case 224:
			CopyStringToBuffer(buf, "If you lean in close, fire puffer has something very important on its mind. Come closer...@26A little closer...@26@26It's arson.");
			break;
		case 226:
			CopyStringToBuffer(buf, "It's rumored that the sea level once rose after a collision with a great star. Now the stars have once again risen from the seas. Feel the wrath of the seas and sky!@26@26A little dramatic for a puffer fish don't you think?");
			break;
		case 237:
			CopyStringToBuffer(buf, "\"I thought it was just an ordinary flower, but when I walked up to it to take some samples...Teeth! So many teeth...Here I thought botany would be a safe profession...\"");
			break;
		case 238:
			CopyStringToBuffer(buf, "Despite their fearsome, toothy appearance, the hopmaw does not actually bite. Instead it defends itself by spewing a cloud of spores...Corrosive spores.@26@26Okay sure, the thing's still certified nasty.");
			break;
		case 239:
			CopyStringToBuffer(buf, "It might be in your best interest to leave this one alone. Then again, if you're going aggro, better to go all in. Fire should make quick work of them.");
			break;
		case 195:
			CopyStringToBuffer(buf, "This vicious fish rules the waters of Starfall Shoals and will aggressively leap out at anything that comes close to the water's edge. Occasionally they get swept up in the surrounding ocean currents and are caught by Malkan fishing boats. Not so tough out of the water, are you?");
			break;
		case 33:
			CopyStringToBuffer(buf, "This bipedal fishlike creature usually only lives in unexplored deep sea caverns, rarely rising to the surface in order to hunt. It's supposedly named after a legendary pirate from a far off land who hunted other pirates, though much of his story has been lost in translation.");
			break;
		case 42:
			CopyStringToBuffer(buf, "A small blob of living oils. While not particularly intelligent, driplets can occasionally display a degree of hive mind behavior. The protozoologist Reiner was the first to observe this behavior, describing how they kept moving forward in unison until their prey was consumed.");
			break;
		case 43:
			CopyStringToBuffer(buf, "In places with high mineral concentrations, driplets will sometimes merge together into one larger droplet. It's not very strong, or very stable, and will break apart easily when struck.");
			break;
		case 196:
			CopyStringToBuffer(buf, "Spiny Beetles are completely impervious to damage. Unless damage means smacking them with a big rock, or knocking them down a nearby pit. They're pretty pervious in those situations.");
			break;
		case 198:
			CopyStringToBuffer(buf, "\"Another day in the mines, full of back breaking labor to unearth precious stones for men who will likely never work a day in their lives. Suddenly my pick struck a brittle sheet of rock, causing a large chunk of the cavern wall behind it to collapse. Before me lay a massive geode of gemstones arranged like the sun and shining just as brilliant. 'This is where my life turns around,' I thought for the briefest moment. Then its eye opened to meet my own.\"");
			break;
		case 197:
			CopyStringToBuffer(buf, "These ominous masses of floating cystal are not actually aggressive like they may first appear. Their presence is still every bit as malicious as one would expect, however, as anyone locked in their gaze is soon met with misfortune.");
			break;
		case 212:
			CopyStringToBuffer(buf, "Unlike its inferior counterparts, the stellar curstellation can and will release bursts of unstable stellar magic at anything it sees. And it can see for a long ways.@26@26Even now it is watching you.");
			break;
		case 178:
			CopyStringToBuffer(buf, "This part cleaning robot, part security drone is employed by many wealthy and paranoid merchants across the region of Omaka. One might think that these two functions run counter to each other, but it's exceptional at getting bloodstains out of carpets as well.");
			break;
		case 179:
			CopyStringToBuffer(buf, "The plated boomba is a sturdier model that can take way more damage from would-be intruders. It does not, however, protect it from its own explosive countermeasures. How much does it cost to replace these things?");
			break;
		case 199:
			CopyStringToBuffer(buf, "An ancient defense turret, occasionally fished up off the bottom of the sea by salvagers. Designs like this don't often see use today due to their awkward firing angles and wasteful use of ammunition.");
			break;
		case 54:
			CopyStringToBuffer(buf, "Once an important noble in life, he's now nothing more than a shambling husk of his former self. It's not that bad though, his shambling has a spring in its step.");
			break;
		case 220:
			CopyStringToBuffer(buf, "Whoever mummified this one did a real poor job of it. The blood's supposed to be drained in the process, you idjit! But what do I know? He's looking pretty lively now.");
			break;
		case 210:
			CopyStringToBuffer(buf, "One can easily become accustomed to seeing these warrior statues everywhere in old temples, standing stern, still, and stable...Until one of them gets up and walks around that is. One would wish some things we could just take for granite.");
			break;
		case 229:
			CopyStringToBuffer(buf, "Stone statues, even of the animated variety, still tend towards falling apart. That doesn't stop some from trying to move about anyhow. These hopping helmets would be almost cute if they didn't have a nasty habit of hurling themselves into passers-by.");
			break;
		case 35:
			CopyStringToBuffer(buf, "Floating around in an aimless drift, this spectre haunts ancient sites of import, drawn by the pull of ancient magic. It vanishes into the air when one gets too far from it, but one would be wise not to ignore its presence, should it appear again in your path.");
			break;
		case 209:
			CopyStringToBuffer(buf, "In close proximity to the Cosmic Egg, its maddening power draws together figures from another world. As they flicker in and out, expanding and collapsing in on themselves, at a glance they may appear to be a mirror image of yourself. Are these figures real or just a trick of the light? Perhaps they are only as real as you believe them to be...");
			break;
		case 227:
			CopyStringToBuffer(buf, "\"I remember it still...The beating of drums, the sounding of horns, the light of torches, the stench of death. The figures marched through the jungle, silent footfalls hovering just off the ground, following a pathway of billowing fog. As I crouched trembling in the bushes as they passed me, I caught sight of one from the side. He turned towards me and raised his toothed club as if to strike. But before he could, the figure next to him called out 'mine' in my grandfather's native tongue. And with that, the drum beat continued, and they resumed their solemn march.\"");
			break;
		case 232:
			CopyStringToBuffer(buf, "Every time magic is used, a fraction of the energy that isn't converted into other forms is released into the atmosphere. Most of this is then absorbed into the earth, but occasionally it pools together into an unstable well that draws in similar energy. This phenomenon is usually short lived, as it's either dissolved by opposing magic or expends all of its energy releasing spells.");
			break;
		case 233:
			CopyStringToBuffer(buf, "Lunar magic is rather unusual among the three types and requires precise control of gravitational fields in order to use to its fullest potential. This swirling well of magical energy waste doesn't quite have the finesse for it, and will likely fizzle out very quickly, but dammit it's trying. ");
			break;
		case 234:
			CopyStringToBuffer(buf, "An unstable pool of stellar magic, rare and fleeting. Stellar magic is the original and strongest of the three elements, and is a distant precursor to astronomy. Though no magic is needed to read the stars, the first practitioners of astronomy learned to do so through experimentation with stellar magic.");
			break;
		case 56:
			CopyStringToBuffer(buf, "Magic is a delicate practice, and all who practice it in time learn methods of proper restraint. Repeated use of this power can lead to the power using the user in turn. After a time this becomes irreversible, leaving a warped being of bottomless desire, more monster than man.");
			break;
		case 57:
			CopyStringToBuffer(buf, "Channeling the power of the moon, the lunar wizard creates a field of frigid air around himself, freezing anything in its reach. As he passes, his bones crack with the frost of his own magic and his teeth chatter with the chill of the grave.");
			break;
		case 153:
			CopyStringToBuffer(buf, "While many mages in the ancient war were killed, a small group persisted, consumed by their own power. The stellar mages who wroght the cataclysm were the most powerful, and the most consumed. Their magic and minds remain a mere fragment of their former selves and their bodies an unrecognized shamble beneath their cloaks.");
			break;
		case 180:
			CopyStringToBuffer(buf, "When enough magical energy is condensed within a gem, it can develop something resembling a will. This will seeks to emulate other life around it, giving form to the stones themselves. Much like in biology, crabs are a fairly common form to take.");
			break;
		case 181:
			CopyStringToBuffer(buf, "The lunar crablike projects a field of magic particles around itself, repelling all who would approach. Remarkably, the crablike can maintain its form for several hours even with its gem removed.");
			break;
		case 182:
			CopyStringToBuffer(buf, "This crablike projects unstable stellar bolts which redirect off solid surfaces. Stellar magic is unheard of amongst people, but for stone beings it comes as naturally as merely existing.");
			break;
		case 183:
			CopyStringToBuffer(buf, "As magical energy intensifies, it becomes more and more common for stone creatures to take on a bipedal form. This one posesses the ability to launch miniature suns. Though it's a good deal less threatening than it sounds.");
			break;
		case 184:
			CopyStringToBuffer(buf, "It's said that early humans were \"touched by stars\" when they first awakened spacial magic. In keeping with that mythos, these humanoid stones are known as \"startouched\". This lunar variant has the strongest keep away game on the seas.");
			break;
		case 185:
			CopyStringToBuffer(buf, "As one of the strongest of the startouched, this stellar variant can use a plasma blade. Though lacking the spark of humanity, it's the spitting image of the stellar mages of legend.");
			break;
		case 203:
			CopyStringToBuffer(buf, "As a prime example of function over form, this pile of rocks releases bursts of unstable solar magic in the form of a deadly laser.");
			break;
		case 204:
			CopyStringToBuffer(buf, "Powered by a gemstone overflowing with abundant lunar magic, this pillar releases periodic waves of cutting energy that phase in and out as they travel.");
			break;
		case 205:
			CopyStringToBuffer(buf, "The stellar pillar wrenches tiny meteorites from the far reaches of space, pelting the ground all around it. Even in the absence of human mages, the earth itself toys with the very power that left its seabeds marred and barren in a frightening display of chaos.");
			break;
		case 191:
			CopyStringToBuffer(buf, "Cutthroats like these serve as the main force behind Shelrond's pirate crew. Their loose swordplay paired with looser moral fiber, what they lack in competence they make up for in numbers.");
			break;
		case 192:
			CopyStringToBuffer(buf, "This flintlock pistol wielding pirate really likes showing off his skill and spinning his gun between attacks. Someone ought to explain to him that this serves no advantage in actual combat and he's not impressing anyone.");
			break;
		case 193:
			CopyStringToBuffer(buf, "Hardened by many fights on the high seas, this pirate fears no man and is entrusted with the crew's most expensive new weaponry.@26@26Actually, there is one man he fears. The quartermaster is going to chew him out again for his wasteful use of magic batteries.");
			break;
		case 231:
			CopyStringToBuffer(buf, "These guys are the strongest and most loyal of Shelrond's men. Even after his fall from prominence in the piracy trade, they stuck by his side. They're tough as nails and hardened by battle. Battles against a trio of teenagers, that is...Battles that they lost.");
			break;
		case 186:
			if(Game->Counter[CR_STORYFLAG]<SFLAG_METKAYLANI)
				CopyStringToBuffer(buf, "These mysterious masked figures patrol the warehouse. They're armed and dangerous, but don't seem especially disciplined. Their eyesight isn't that good either.");
			else
				CopyStringToBuffer(buf, "Solar masks are the newest recruits in Selet's company. Many aren't too experienced with the underworld dealings they're involved with. But still, most are fully loyal to their boss.");
			break;
		case 188:
			if(Game->Counter[CR_STORYFLAG]<SFLAG_METKAYLANI)
				CopyStringToBuffer(buf, "These cloaked figures wear a mask shaped like the moon, seemingly indicating their rank. They have impressive skill with throwing knives of which they're carrying an alarming supply.");
			else
				CopyStringToBuffer(buf, "Lunar masks are the leading force in Selet's more covert dealings. When there's assassinations, kidnapping, or money laundering to be done they'll be at arm's reach.");
			break;
		case 211:
			CopyStringToBuffer(buf, "Stellar masks form the highest rank amongst Selet Shipping's hierarchy. These are Selet's most capable and trusted underlings and many were personally trained in swordplay by his second in command.");
			break;
		case 206:
			CopyStringToBuffer(buf, "Following Kaylani's abduction, Selet obtained an ample supply of solar magic. What wasn't sold on the black market or distributed to the pirate crews eventually finds its way into the solar spellbearer's butter coated hands.");
			break;
		case 207:
			CopyStringToBuffer(buf, "Despite having an ample supply, Selet will only rarely extract his own magic. The process is too taxing for his liking. What little he does collect is given to those he can trust to put it to good use.");
			break;
		case 208:
			CopyStringToBuffer(buf, "The highest honor in Selet's company is to be given stellar magic to use, as it is extremely limited in supply and one of his longest standing goals to obtain. So surely they'll save it for an emergency...Right?");
			break;
		case 213:
			CopyStringToBuffer(buf, "Sitting atop Kikala hill is an unusual arrangement of stones. Upon closer inspection, they're actually the slumbering body of an ancient golem, harnessing the power of the sun.");
			break;
		case 214:
			CopyStringToBuffer(buf, "Unlike the smaller startouched golems, these ones were crafted by human hands. Some long forgotten craftsman molded its body to serve some purpose unknown. Now its purpose is to guard an empty beach, loosing waves of lunar magic along the shoreline.");
			break;
		case 215:
			CopyStringToBuffer(buf, "The stellar golem boasts unprecedented firepower and mastery of its plasma blade attacks. The roof of the cavern above it has been torn open by numerous meteorite strikes, letting in scattered light from above. Whoever the people of the Carn Ruins were, their understanding of magic was impeccable. ");
			break;
		case 244:
			CopyStringToBuffer(buf, "The pinnacle of Carn's golem-building efforts, the fusion golem can effortlessly swap between all three types of magic, mixing and matching to create devastating new attacks. It was trained by fighting the other three golems, but its combination of magic types soon proved too destructive, and its creators opted to lock it away, lest it fall into the wrong hands.");
			break;
		case 218:
			CopyStringToBuffer(buf, "While Shelrond's crew are a menace that's been exploiting the people of Omaka for months, the captain himself is rather eccentric. He dresses himself like nobody has for at least a hundred years. Modern piracy is more about results, but this man is all about the presentation and intimidation.");
			break;
		case 216:
			CopyStringToBuffer(buf, "This tunnel boring machine was commissioned by Selet to speed up the mining operation. When facing down the business side of it, however, it doubles as a fearsome tank. Who fitted this thing with bombs anyways?");
			break;
		case 242:
			CopyStringToBuffer(buf, "Equal parts ferocious and circumspect, Selet's right hand man is fiercely loyal to his leader and cause. He refuses to use any magic but Selet's and uses it to power a mechanical gauntlet of his own design, warping it into a new crimson form. It's because of this ability that he is known and feared as Esan, the Bloodmoon.");
			break;
		case 217:
			CopyStringToBuffer(buf, "This is the man behind the shadows being cast over Pala. He'll stoop to any level to see to it that his schemes succeed. Though he commands a sizeable personal army of henchmen in his underground dealings, he is not above getting his own hands dirty. Those who reject his offers or offend his twisted values will learn this firsthand.");
			break;
		case 236:
			CopyStringToBuffer(buf, "Writhing...Wriggling...Blackness...@26@26My name is Selet Igorevich. I live for myself and my own. This I must remember.@26@26Pain...Searing...@26@26My name is Selet Igorevich. I came here for...Why exactly? To claim the power of the Cosmic Egg, yes, yes. How could I forget?@26@26Undulating...Not myself...@26@26My name is...I came here for...For...For the power. I came here by choice. To be the freest person. How could I shackle myself to something as miniscule as ego? @26@26Dark...Numb...My name is...Who?");
			break;
		case 251:
			CopyStringToBuffer(buf, "The trio's biggest fan has trained hard to become an accomplished mage, or so he says. Just where did his halo or his world-rending power come from anyway?");
			break;
		default:
			CopyStringToBuffer(buf, " ");
			break;
	}
}

void BestiaryTiles(int id){
	int blinkOffset = 0;
	if((G[G_ANIM]%360)>=348){
		if(G[G_ANIM]%360<352)
			blinkOffset = 1;
		else if(G[G_ANIM]%360<356)
			blinkOffset = 2;
		else
			blinkOffset = 1;
	}
	if(LoreTracking[LT_ENEMIES+id]==0&&!G[G_BESTIARYRANDO])
		id = -1;
	switch(id){
		case 22: //Red Octo
			SetBestiaryTile(3484, 1, 1, 8);
			break;
		case 23: //Blue Octo
			SetBestiaryTile(3484, 1, 1, 7);
			break;
		case 26: //Crab
			SetBestiaryTile(9566, 1, 1, 8);
			break;
		case 27:
			SetBestiaryTile(9574, 1, 1, 7);
			break;
		case 137:
			SetBestiaryTile(9594, 1, 1, 7);
			break;
		case 45: //Ratang
			SetBestiaryTile(3724, 1, 1, 8);
			break;
		case 46:
			SetBestiaryTile(3724, 1, 1, 7);
			break;
		case 136:
			SetBestiaryTile(8484, 1, 1, 8);
			break;
		case 221:
			SetBestiaryTile(9784, 1, 1, 7);
			break;
		case 38: //Keese
			SetBestiaryTile(1584, 1, 1, 7);
			break;
		case 106: //Bat
			SetBestiaryTile(4884, 1, 1, 11);
			break;
		case 189: //Spider
			SetBestiaryTile(10060, 1, 1, 11);
			break;
		case 194:
			SetBestiaryTile(10100, 1, 1, 11);
			break;
		case 187: //Rat
			SetBestiaryTile(10024, 1, 1, 11);
			break;
		case 44: //Rope
			SetBestiaryTile(2430, 1, 1, 8);
			break;
		case 80:
			SetBestiaryTile(2450, 1, 1, 7);
			break;
		case 190:
			SetBestiaryTile(10089, 1, 1, 11);
			break;	
		case 223:
			SetBestiaryTile(10150, 1, 1, 11);
			break;
		case 25: //Tektite
			SetBestiaryTile(2384, 1, 1, 7);
			break;
		case 24:
			SetBestiaryTile(2344, 1, 1, 8);
			break;
		case 222:
			SetBestiaryTile(9860, 1, 1, 8);
			break;
		case 138: //Dragon
			SetBestiaryTile(8604, 1, 1, 8);
			break;
		case 139:
			SetBestiaryTile(8664, 1, 1, 8);
			break;
		case 224: //Puffer
			SetBestiaryTile(107396, 1, 1, 8);
			break;
		case 225:
			SetBestiaryTile(107136, 1, 1, 8);
			break;
		case 226:
			SetBestiaryTile(107196, 1, 1, 9);
			break;
		case 237: //Hopmaw
			SetBestiaryTile(7748, 1, 1, 8);
			break;
		case 238:
			SetBestiaryTile(7748, 1, 1, 7);
			break;
		case 239: //Beehive
			SetBestiaryTile(7766, 1, 1, 8);
			break;
		case 195: //Piranha
			SetBestiaryTile(107206, 2, 2, 7);
			break;
		case 33: //Zora
			SetBestiaryTile(2484, 1, 1, 9);
			break;
		case 42: //Gel
			SetBestiaryTile(1804, 1, 1, 7);
			break;
		case 43:
			SetBestiaryTile(1784, 1, 1, 7);
			break;
		case 196: //Spiny Beetle
			SetBestiaryTile(7640, 1, 1, 11);
			break;
		case 198: //Cursetellation
			SetBestiaryTile(7677+blinkOffset, 1, 1, 8);
			break;
		case 197:
			SetBestiaryTile(7657+blinkOffset, 1, 1, 7);
			break;
		case 212:
			SetBestiaryTile(7697+blinkOffset, 1, 1, 9);
			break;
		case 178: //Bomb
			SetBestiaryTile(9940, 1, 1, 8);
			break;
		case 179:
			SetBestiaryTile(9980, 1, 1, 7);
			break;
		case 199: //Cannon
			SetBestiaryTile(7700, 2, 2, 11);
			break;
		case 54: //Mummy
			SetBestiaryTile(107340, 1, 2, 7);
			break;
		case 220:
			SetBestiaryTile(107346, 1, 2, 11);
			break;
		case 210: //Armos Knight
			SetBestiaryTile(7360, 1, 2, 11);
			break;
		case 229: //Armos Helmet
			SetBestiaryTile(7361, 1, 1, 11);
			break;
		case 35: //Ghost
			SetBestiaryTile(2200, 1, 1, 7);
			break;
		case 209: //Cosmic Spook
			SetBestiaryTile(106940, 1, 2, 7);
			break;
		case 227: //Nightmarcher
			SetBestiaryTile(106300, 1, 2, 11);
			break;
		case 232: //Suneater
			SetBestiaryTile(7733, 1, 1, 8);
			break;
		case 233: //Mooneater
			SetBestiaryTile(7729, 1, 1, 7);
			break;
		case 234: //Stareater
			SetBestiaryTile(7733, 1, 1, 9);
			break;
		case 56: //Wizard
			SetBestiaryTile(10264, 1, 2, 8);
			break;
		case 57:
			SetBestiaryTile(10304, 1, 2, 7);
			break;
		case 153:
			SetBestiaryTile(10344, 1, 2, 9);
			break;
		case 180: //Crablike
			SetBestiaryTile(9424, 1, 1, 0);
			break;
		case 181:
			SetBestiaryTile(9464, 1, 1, 0);
			break;
		case 182:
			SetBestiaryTile(9504, 1, 1, 0);
			break;
		case 183: //Startouched
			SetBestiaryTile(9664, 1, 2, 0);
			break;
		case 184:
			SetBestiaryTile(9704, 1, 2, 0);
			break;
		case 185:
			SetBestiaryTile(9744, 1, 2, 0);
			break;
		case 203: //Pillar
			SetBestiaryTile(7800, 2, 3, 0);
			break;
		case 204:
			SetBestiaryTile(7860, 2, 3, 0);
			break;
		case 205:
			SetBestiaryTile(7920, 2, 3, 0);
			break;
		case 191:
			SetBestiaryTile(106340, 1, 2, 8);
			break;
		case 192:
			SetBestiaryTile(106380, 1, 2, 7);
			break;
		case 193:
			SetBestiaryTile(106500, 1, 2, 7);
			break;
		case 231:
			SetBestiaryTile(111360, 1, 2, 7);
			break;
		case 186: //Cultist Mask
			SetBestiaryTile(106600, 1, 2, 11);
			break;
		case 188:
			SetBestiaryTile(106640, 1, 2, 11);
			break;
		case 211:
			SetBestiaryTile(106680, 1, 2, 11);
			break;
		case 206: //Cultist Spellbearer
			SetBestiaryTile(106600, 1, 2, 11);
			break;
		case 207:
			SetBestiaryTile(106640, 1, 2, 11);
			break;
		case 208:
			SetBestiaryTile(106680, 1, 2, 11);
			break;
		case 213: //Miniboss Golem
			SetBestiaryTile(8068, 2, 2, 11);
			break;
		case 214:
			SetBestiaryTile(8148, 2, 2, 11);
			break;
		case 215:
			SetBestiaryTile(8228, 2, 2, 11);
			break;
		case 244:
			SetBestiaryTile(60338, 2, 2, 11);
			break;
		case 218: //Captain Shelrond
			SetBestiaryTile(106540, 1, 2, 11);
			break;
		case 216: //Diggernaut
			SetBestiaryTile(79056, 4, 3, 11);
			break;
		case 242: //Esan
			SetBestiaryTile(111140, 1, 2, 11);
			break;
		case 217: //Selet
			SetBestiaryTile(109200, 1, 2, 11);
			break;
		case 236: //Selet Transformed
			SetBestiaryTile(117196, 4, 3, 11);
			break;
		case 251: //Chase
			SetBestiaryTile(111580, 1, 2, 11);
			break;
		default:
			SetBestiaryTile(0, 1, 1, 8);
			break;
	}
}
void SetBestiaryTile(int til, int w, int h, int cs){
	G[G_BESTIARY_ENEMYTILE] = til;
	G[G_BESTIARY_ENEMYCSET] = cs;
	G[G_BESTIARY_ENEMYWIDTH] = w;
	G[G_BESTIARY_ENEMYHEIGHT] = h;
}

void BestiaryDefenses(int id){
	const int PHYSICAL 	= 00000001b;
	const int FIRE 		= 00000010b;
	const int BOMB 		= 00000100b;
	const int SOLAR 	= 00001000b;
	const int LUNAR 	= 00010000b;
		  int STELLAR 	= 00100000b;
	const int GAUNTLET 	= 01000000b;
	
	if(Game->Counter[CR_STORYFLAG]<SFLAG_ASHERRESCUED)
		STELLAR = 0;
	
	G[G_BESTIARY_ENEMYRESIST] = 0;
	G[G_BESTIARY_ENEMYWEAKNESS] = 0;
	switch(id){
		//Octo
		case 20:
		case 21:
		case 22:
		case 23:
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE;
			break;
		//Crab
		case 26:
		case 27:
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE|BOMB;
			break;
		//Solar crab
		case 137:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE|BOMB|LUNAR|GAUNTLET;
			break;
		//Ratang
		case 45:
		case 46:
		case 136:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR;
			break;
		//Lunatic ratang
		case 221:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = SOLAR|GAUNTLET;
			break;
		//Ropes
		case 44:
		case 80:
			G[G_BESTIARY_ENEMYWEAKNESS] = LUNAR;
			break;
		case 190:
			G[G_BESTIARY_ENEMYRESIST] = FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = LUNAR;
			break;
		//Ossified serpent
		case 223:
			G[G_BESTIARY_ENEMYRESIST] = FIRE|STELLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = LUNAR;
			break;
		//Strider
		case 24:
		case 25:
			G[G_BESTIARY_ENEMYRESIST] = FIRE;
			break;
		//Sun strider
		case 222:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = LUNAR|BOMB|GAUNTLET;
			break;
		//Dimlit
		case 138:
		case 139:
			G[G_BESTIARY_ENEMYRESIST] = FIRE;
			break;
		//Puffer
		case 225:
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Fire puffer
		case 224:
			G[G_BESTIARY_ENEMYRESIST] = FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Stellar puffer
		case 226:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|SOLAR|LUNAR|STELLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Hopmaw
		case 237:
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE;
			break;
		case 238:
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE;
			break;
		//Beehive
		case 239:
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE|BOMB;
			break;
		//Zolo
		case 33:
			G[G_BESTIARY_ENEMYRESIST] = FIRE|LUNAR;
			break;
		//Droplet
		case 42:
		case 43:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE;
			break;
		//Spiny beetle
		case 196:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR|STELLAR|FIRE|BOMB;
			break;
		//Cursetellation (Solar)
		case 198:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB|GAUNTLET;
			break;
		//Cursetellation (Lunar)
		case 197:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB|GAUNTLET;
			break;
		//Cursetellation (Stellar)
		case 212:
			G[G_BESTIARY_ENEMYRESIST] = STELLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Boomba
		case 178:
		case 179:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB|FIRE;
			break;
		//Cannon
		case 199: 
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|FIRE|SOLAR|LUNAR|STELLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Mummy
		case 54:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR|FIRE;
			break;
		//Blood Mummy
		case 220:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR;
			break;
		//Stone Guardian
		case 220:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR|STELLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Ghost
		case 35:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|FIRE|BOMB;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR;
			break;
		//Cosmic spook
		case 209:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR|STELLAR;
			break;
		//Nightmarcher
		case 227:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|SOLAR|LUNAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR;
			break;
		//Suneater
		case 232:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|SOLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = LUNAR|STELLAR;
			break;
		//Mooneater
		case 233:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|LUNAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = SOLAR|STELLAR;
			break;
		//Stareater
		case 234:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|STELLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = SOLAR|LUNAR;
			break;
		//Solar Wizard
		case 56:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR;
			break;
		//Lunar Wizard
		case 57:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR;
			break;
		//Solar Elementals
		case 180:
		case 183:
			G[G_BESTIARY_ENEMYWEAKNESS] |= GAUNTLET;
		case 203:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] |= LUNAR|BOMB;
			break;
		//Lunar Elementals
		case 181:
		case 184:
			G[G_BESTIARY_ENEMYWEAKNESS] |= GAUNTLET;
		case 204:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] |= SOLAR|BOMB;
			break;
		//Stellar Elementals
		case 182:
		case 185:
		case 205:
			G[G_BESTIARY_ENEMYRESIST] = STELLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = SOLAR|LUNAR|BOMB;
			break;
		//Solar Golem
		case 213:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|FIRE;
			break;
		//Lunar Golem
		case 214:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR|FIRE;
			break;
		//Stellar Golem
		case 215:
			G[G_BESTIARY_ENEMYRESIST] = STELLAR|FIRE;
			break;
		//Fusion Golem
		case 244:
			G[G_BESTIARY_ENEMYRESIST] = FIRE;
			break;
		//Bolide Borer
		case 216:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Nightmare Selet
		case 236:
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Chase
		case 251:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|STELLAR;
			break;
	}
}

enum{
	LOC_PUNA,
	LOC_OMAKA,
	LOC_PALA,
	LOC_WAREHOUSE,
	LOC_KAWI,
	LOC_PIRATE,
	LOC_MALKA,
	LOC_JUNGLE,
	LOC_WAHIOKALA = LOC_JUNGLE,
	LOC_HILLSIDE,
	LOC_LAVAFLOWS,
	LOC_JUNGLECAVE,
	LOC_TEMPLEOUTSIDE,
	LOC_JUNGLETEMPLE,
	LOC_HOKU,
	LOC_ALII,
	LOC_SHOALS,
	LOC_MINE,
	LOC_MANOR,
	LOC_CATACOMBS,
	LOC_OBSERVATORY,
	LOC_KAWAIHAE,
	LOC_KUKULU,
	LOC_PIRATE2,
	LOC_KIKALA,
	LOC_LEIPAI,
	LOC_TULANE,
	LOC_CARN,
	LOC_PYRAMID,
	LOC_MIRAGE,
	LOC_MUSHRUSH,
	LOC_SILVER,
	LOC_PONI,
	LOC_LAKE,
	LOC_MIST,
	
	LOC_SIZE,
	
	LOC_INVALID = -1
};

void LocationName(int buf, int id){
	switch(id){
		case LOC_PUNA: 
			CopyStringToBuffer(buf, "Puna Village");
			break;
		case LOC_OMAKA: 
			CopyStringToBuffer(buf, "Omaka Path");
			break;
		case LOC_PALA: 
			CopyStringToBuffer(buf, "Pala Bay");
			break;
		case LOC_WAREHOUSE: 
			CopyStringToBuffer(buf, "Warehouse");
			break;
		case LOC_KAWI: 
			CopyStringToBuffer(buf, "Kawi Canyon");
			break;
		case LOC_PIRATE: 
			CopyStringToBuffer(buf, "Pirate Hideout");
			break;
		case LOC_MALKA: 
			CopyStringToBuffer(buf, "Malka");
			break;
		case LOC_JUNGLE: 
			CopyStringToBuffer(buf, "Wahiokala Jungle");
			break;
		case LOC_HILLSIDE: 
			CopyStringToBuffer(buf, "Wahiokala Hillside");
			break;
		case LOC_LAVAFLOWS: 
			CopyStringToBuffer(buf, "Wahiokala Lava Flows");
			break;
		case LOC_JUNGLECAVE: 
			CopyStringToBuffer(buf, "Overgrown Passage");
			break;
		case LOC_TEMPLEOUTSIDE: 
			CopyStringToBuffer(buf, "Temple Grounds");
			break;
		case LOC_JUNGLETEMPLE: 
			CopyStringToBuffer(buf, "Jungle Temple");
			break;
		case LOC_HOKU: 
			CopyStringToBuffer(buf, "Hoku Village");
			break;
		case LOC_ALII: 
			CopyStringToBuffer(buf, "Ali'i Ascent");
			break;
		case LOC_SHOALS: 
			CopyStringToBuffer(buf, "Starfall Shoals");
			break;
		case LOC_MINE: 
			CopyStringToBuffer(buf, "Deepsea Mine");
			break;
		case LOC_MANOR: 
			CopyStringToBuffer(buf, "Selet Manor");
			break;
		case LOC_CATACOMBS: 
			CopyStringToBuffer(buf, "Omaka Catacombs");
			break;
		case LOC_OBSERVATORY:
			CopyStringToBuffer(buf, "Ancient Observatory");
			break;
		case LOC_KAWAIHAE:
			CopyStringToBuffer(buf, "Kawaihae Cave");
			break;
		case LOC_KUKULU:
			CopyStringToBuffer(buf, "Kukulu Cliffs");
			break;
		case LOC_PIRATE2:
			CopyStringToBuffer(buf, "Kukulu Hideaway");
			break;
		case LOC_KIKALA:
			CopyStringToBuffer(buf, "Kikala Hill");
			break;
		case LOC_LEIPAI:
			CopyStringToBuffer(buf, "Leipai's Lookout");
			break;
		case LOC_TULANE:
			CopyStringToBuffer(buf, "Villa Tulane");
			break;
		case LOC_CARN:
			CopyStringToBuffer(buf, "Carn Ruins");
			break;
		case LOC_PYRAMID:
			CopyStringToBuffer(buf, "Undersea Pyramid");
			break;
		case LOC_MIRAGE:
			CopyStringToBuffer(buf, "Mirage Isle");
			break;
		case LOC_MUSHRUSH:
			CopyStringToBuffer(buf, "Creator's Realm");
			break;
		case LOC_SILVER:
			CopyStringToBuffer(buf, "Mt. Silver");
			break;
		case LOC_PONI:
			CopyStringToBuffer(buf, "Kohi Canyon");
			break;
		case LOC_LAKE:
			CopyStringToBuffer(buf, "Mauna Poho");
			break;
		case LOC_MIST:
			CopyStringToBuffer(buf, "Poho Temple");
			break;
	}
}

void LocationDescription(int buf, int id){
	switch(id){
		case LOC_PUNA: 
			CopyStringToBuffer(buf, "In times past, Puna Village was the capital of Omaka, holding considerable influence over it and several other islands. Now, it's little more than a sleepy village on the northern coast, the power on the island having been consolidated in the hands of traders in the south.");
			break;
		case LOC_OMAKA: 
			CopyStringToBuffer(buf, "The path between Puna Village and Pala Bay passes spectacular beaches and verdant lowlands before slowly climbing up to the hilly southern coast of Omaka. The nearby forests and hills provide ample hunting grounds for residents of the island, while large swaths of the far western coast have been converted to farm land.");
			break;
		case LOC_PALA: 
			CopyStringToBuffer(buf, "Pala Bay is the region's main center of commerce. If anything was bought or sold on Omaka or the surrounding islands, chances are it exchanged hands here at some point. The city is built on an incline with the wealthiest residents living at the top overlooking the entire bay. At the bottom are the trading, fishing, and shipping districts on which those elite few compound their wealth.");
			break;
		case LOC_WAREHOUSE: 
			if(Game->Counter[CR_STORYFLAG]>=SFLAG_METKAYLANI)
				CopyStringToBuffer(buf, "This warehouse owned by Selet Shipping Company was secretly being used in Selet's human trafficking operation. After being captured and sold by pirates, Kaylani was held prisoner by Selet in the back rooms so he could extract her solar magic.");
			else
				CopyStringToBuffer(buf, "This warehouse seems to be related to the recent increase in pirate attacks. Torrin saw a group of suspected pirates carrying boxes inside and the inside is crawling with ominous masked figures. What's going on here?");
			break;
		case LOC_KAWI: 
			CopyStringToBuffer(buf, "Long ago, heavy rainfalls fueled rivers and streams that cut deep gorges into the southern cost of Kawi. Now, as volcanic activity continues to make Mauna Ali'i on the nearby island of Wahiokala grow, the island has been caught in a rain shadow, growing arid and uninhabited. However, the steep canyons seem to provide an excellent hiding place for certain unsavory individuals...");
			break;
		case LOC_PIRATE: 
			CopyStringToBuffer(buf, "Hidden deep in the canyon, the pirates store all their stolen loot here before smuggling it into various trading ports. Gathering enough wood on a desert island to construct it was no small feat, but in the eyes of Captain Shelrond, a pirate without a respectable base of operations is no real pirate. Opinions like that, say nothing of his desire for complicated colored block security systems, have led some pirates to question him, though his skill with a sword and a pistol has quelled any mutinies before they begin.");
			break;
		case LOC_MALKA: 
			CopyStringToBuffer(buf, "The ancestors of the Malkans, shipwrecked on a small island, found little space to work with. Opting to preserve the available land to grow crops such as Taro, they built the village atop the shallow bay, using lunar magic to subtly influence the tides and keep them sheltered. The tiny fishing village now has a reputation both as a tropical paradise and a backwater slum, depending on who you ask.");
			break;
		case LOC_JUNGLE: 
			CopyStringToBuffer(buf, "The windward side of Wahiokala is covered in thick jungles, nourished by the neverending rain falls. To the northwest, extinct volcanoes, once reaching up to the heavens above, steadily give way to nature's relentless erosion.");
			break;
		case LOC_HILLSIDE: 
			CopyStringToBuffer(buf, "Wahiokala is dominated by Mauna Ali'i, a mountain whose sheer size is hard to grasp at a glance. Its large area and gentle slopes mask its height. At its middle elevations, grasslands blanket the slopes and terraces, dotted by sandalwood trees.  ");
			break;
		case LOC_LAVAFLOWS: 
			CopyStringToBuffer(buf, "Like a wound punched in the side of Mauna Ali'i, the lava flows serve as a fiery reminder of Wahiokala's volcanic origins. Even as the northwestern side of the island gradually yields to the sea, new land is generated at its southeastern coast when the lava strikes the sea and cools. All manner of strange reptiles make their home here, basking in the warmth of the lava's glow.");
			break;
		case LOC_JUNGLECAVE: 
			CopyStringToBuffer(buf, "This cave network stretches out beneath the jungles of Wahiokala, connecting the southern and northern ends together. While the caves would normally be far too dark to support plantlife, the trees on the surface also absorb solar magic and pass it down into the earth through their roots. Thanks to this, a diverse subterranean ecosystem can flourish.");
			break;
		case LOC_TEMPLEOUTSIDE: 
			CopyStringToBuffer(buf, "Hidden in the jungle at the base of a now-extinct volcano, an ancient temple sleeps, a testament to the Astronomers' long habitation of Wahiokala. While landslides and thick vegetation had all but buried the site, Selet's followers have recently excavated it for their own nefarious purposes.");
			break;
		case LOC_JUNGLETEMPLE: 
			CopyStringToBuffer(buf, "The Astronomers accounted for many things when laying their traps carefully in this temple. They did not, however, account for a team of rude archaeologists with no care for temple deathtrap construction blasting their way straight through. At the temple's core, a relic capable of tracking the movements of the heavens is supposedly hidden.");
			break;
		case LOC_HOKU: 
			CopyStringToBuffer(buf, "From this remote, cliffside town, the Astronomers track the heavens, monitor the goings on of neighboring islands, and train up the next generation of mages to follow in their footsteps. Few outsiders are even aware of its existence, though a group of fishermen from Malka occasionally tip them off to suspicious dealings in the region.");
			break;
		case LOC_ALII: 
			CopyStringToBuffer(buf, "The upper reaches of Mauna Ali'i are an utterly alien environment that few humans ever get to lay eyes on. Sparsely covered in strange plants and shaped by occasional volcanic eruptions, the upper slopes are often coated with a thin layer of snow during the winter. At the mountain's peak, an ancient observatory hides the Astronomers' greatest secret.");
			break;
		case LOC_SHOALS: 
			if(Game->Counter[CR_STORYFLAG] < SFLAG_ASHERKIDNAPPED)
				CopyStringToBuffer(buf, "This island chain was ground zero of the meteor impact that sank the world. Countless meteorites that pepper the ocean floor have warped the terrain to such a degree that unstable sea currents have formed around the entire surrounding area. It's impassable by ship, but a path through the shallows and shorelines leads to the center of the battlefield.");
			else
				CopyStringToBuffer(buf, "Before the cataclysm that sank the world, these shoals were the site of an intense battle between stellar mages. Countless meteorites that pepper the ocean floor have warped the terrain to such a degree that unstable sea currents have formed around the entire surrounding area. It's impassable by ship, but a path through the shallows and shorelines leads to the center of the battlefield.");
			break;
		case LOC_MINE: 
			CopyStringToBuffer(buf, "Selet's company needed a way to mine chunks of meteorite fragments on the ocean floor, but without managing complex machinery under high water pressure. For that purpose, he had this mining base constructed. It extends all the way down to beneath the sea bed, and allows for mining from below. The number of accidents caused by flooding and cave-ins were innumerable, but according to Selet, worth the expenses.");
			break;
		case LOC_MANOR: 
			CopyStringToBuffer(buf, "If Pala Bay is a city on a hill, then Selet's manor is like a castle overlooking that hill. It's almost unlivably large and extravagant, and according to some of the locals, he may not actually live there.");
			break;
		case LOC_CATACOMBS: 
			CopyStringToBuffer(buf, "Extending beneath Selet's Manor and Pala Bay lie these catacombs, far older than either. They likely date back to the pre-cataclysm uprisings when deaths were many and frequent. Now they mostly just serve as Selet's closet. A closet with a world record skeleton count.");
			break;
		case LOC_OBSERVATORY:
			CopyStringToBuffer(buf, "At one point this observatory was used by the astronomers of old to chart the stars with their magic. The old astronomer magic still flows through the observatory walls, but now serves a different purpose: To seal away the Cosmic Egg. Time and space have begun to lose their meaning here as day, night, up, and down all dissolve together into a sea of clouds and stars. The hour of the Egg's awakening approaches.");
			break;
		case LOC_KAWAIHAE:
			CopyStringToBuffer(buf, "The smaller of the Mother and Child Rocks has been hollowed out by untold centuries of beating waves. Explorers have reported magnificent crystals inside, but also warn of a strange stone monster that attacks careless trespassers.");
			break;
		case LOC_KUKULU:
			CopyStringToBuffer(buf, "The larger of the Mother and Child Rocks juts from the sea like an ancient monolith. The views from the top are said to be unparalleled, but no path climbs all the way up the steep cliff faces. Like its nearby child, its interior has begun to give way to relentless pounding of the waves, forming a natural cove.");
			break;
		case LOC_PIRATE2:
			CopyStringToBuffer(buf, "After their deal with Selet went sour, Captain Shelrond's crew has fallen on hard times. Their new base of operations is less so a base than a dilapidated and lightly haunted shack, but Shelrond will not be deterred.");
			break;
		case LOC_KIKALA:
			CopyStringToBuffer(buf, "This small island is of great interest to botanists as one of the few places in the archipelago where the Kikala Fir thrives, crowding out competing species. Its picturesque hidden beach is also popular with exhausted workers and young couples alike.");
			break;
		case LOC_LEIPAI:
			CopyStringToBuffer(buf, "This plateau is named after the astronomer Leipai. Legends tell that he used the lookout to spot an approaching army, crossing a land bridge from the Wahiokala mainland. With his warnings, the nearby cities were able to fortify their defenses and head off the approaching army, driving many of them into the sea. Now much of that geography has also been claimed by the sea, but Leipai's story and lookout have both endured.");
			break;
		case LOC_TULANE:
			CopyStringToBuffer(buf, "While Madame Tulane owns property in Pala Bay to keep a close eye on her business rival, Selet Igorevich, her main residence is this lavish private island. A security force of hired pirates ensures she has the privacy she desires to hatch less than savory business dealings. While she has some reservations about hiring the same pirate force Selet uses for his smuggling operations, she ultimately decided if Selet is willing to go low, she can go even lower.");
			break;
		case LOC_CARN:
			if(Game->Counter[CR_GOLEMSIDEQUEST]>=1)
				CopyStringToBuffer(buf, "These strange ruins are perched upon a cliff overlooking the ocean. Siyed, a budding astronomer from Hoku Village, believes they hide an immense power.");
			else
				CopyStringToBuffer(buf, "These strange ruins are perched upon a cliff overlooking the ocean. What purpose might they serve?");
			break;
		case LOC_PYRAMID:
			CopyStringToBuffer(buf, "The clashing forces of earth and sea carved out this massive submarine cavern. Early Astronomers built a large pyramid here, though the geologic instability led to the structure's abandonment. If Esan's intel is to be trusted, relics still sleep within this structure, waiting to be claimed by anyone willing to risk a few toes hopping across the lava to reach them.");
			break;
		case LOC_MIRAGE:
			CopyStringToBuffer(buf, "Stories tell of a mysterious island that drifts across the ocean at random. It's covered in a shroud of perpetual mist and the sun never sets over it. Only the very fortunate happen upon it, and upon discovering it they find their fortunes multiply. Golden plants sprout everywhere and bear coins instead of fruit.@26@26So what if someone were to live here...?");
			break;
		case LOC_MUSHRUSH:
			CopyStringToBuffer(buf, "@26@26@26@26@26       ...Oh no.");
			break;
		case LOC_SILVER:
			CopyStringToBuffer(buf, "As the sun rises over the eastern sea every morning, Mt. Silver stands resolutely to challenge it. The tallest mountain casts the tallest shadow and naturally presents the tallest order to those seeking to climb it. At the highest point is supposedly a great power, a place where one can touch the light of the heavens itself with one's fingertips.");
			break;
		case LOC_PONI:
			CopyStringToBuffer(buf, "Mauna Poho is cloaked in near perpetual cloud cover. The thick mists at the summit condense and generate many streams, which have gradually carved the vast canyon network that extends across the majority of the island's southern flank. Ancient astronomers, amazed by the natural beauty of the canyons, established a city here in the distant past, though it has long since fallen into ruin.");
			break;
		case LOC_LAKE:
			CopyStringToBuffer(buf, "Near the summit of Mauna Poho, shrouded in fog, lies an ancient temple built to seal away the Cosmic Egg...Or so one would be lead to believe. In reality it's a trap devised by the astronomers of old to corner anyone looking for the egg's location. Its real location is a closely guarded secret, known only by the lineage of Hoku village's elders.");
			break;
		case LOC_MIST:
			CopyStringToBuffer(buf, "Utilizing knowledge of its secret entrance, Selet has caused this ancient trap to spring on the descendants of its creators. In the depths of the temple, the thick mists slowly suffocate those who become lost in its maze-like structure.");
			break;
	}
}

void LocationScreenPreview(int id){
	switch(id){
		case LOC_PUNA: 
			LocationConfigureScreenPreview(1, 0x61, 16, 32);
			break;
		case LOC_OMAKA: 
			LocationConfigureScreenPreview(0, 0x07, 112, 32);
			break;
		case LOC_PALA: 
			LocationConfigureScreenPreview(2, 0x0A, 128, 24);
			break;
		case LOC_WAREHOUSE: 
			LocationConfigureScreenPreview(9, 0x52, 0, 48);
			break;
		case LOC_KAWI: 
			LocationConfigureScreenPreview(6, 0x64, 112, 32);
			break;
		case LOC_PIRATE: 
			LocationConfigureScreenPreview(16, 0x6B, 48, 64);
			break;
		case LOC_MALKA: 
			LocationConfigureScreenPreview(26, 0x3F, 56, 32);
			break;
		case LOC_JUNGLE: 
			LocationConfigureScreenPreview(10, 0x60, 24, 24);
			break;
		case LOC_HILLSIDE: 
			LocationConfigureScreenPreview(11, 0x77, 128, 64);
			break;
		case LOC_LAVAFLOWS: 
			LocationConfigureScreenPreview(12, 0x58, 16, 8);
			break;
		case LOC_JUNGLECAVE: 
			LocationConfigureScreenPreview(62, 0x1C, 144, 16);
			break;
		case LOC_TEMPLEOUTSIDE: 
			LocationConfigureScreenPreview(36, 0x22, 80, 48);
			break;
		case LOC_JUNGLETEMPLE: 
			LocationConfigureScreenPreview(37, 0x64, 0, 0);
			break;
		case LOC_HOKU: 
			LocationConfigureScreenPreview(28, 0x18, 16, 48);
			break;
		case LOC_ALII: 
			LocationConfigureScreenPreview(18, 0x5E, 96, 64);
			break;
		case LOC_SHOALS: 
			LocationConfigureScreenPreview(14, 0x22, 112, 48);
			break;
		case LOC_MINE: 
			if(Game->GetScreenState(20, 0x42, ST_VISITED))
				LocationConfigureScreenPreview(17, 0x58, 128, 48);
			else
				LocationConfigureScreenPreview(17, 0x50, 16, 0);
			break;
		case LOC_MANOR: 
			LocationConfigureScreenPreview(24, 0x0A, 112, 0);
			break;
		case LOC_CATACOMBS: 
			LocationConfigureScreenPreview(25, 0x4B, 96, 64);
			break;
		case LOC_OBSERVATORY:
			LocationConfigureScreenPreview(23, 0x42, 96, 16);
			break;
		case LOC_KAWAIHAE:
			LocationConfigureScreenPreview(30, 0x2C, 48, 8);
			break;
		case LOC_KUKULU:
			LocationConfigureScreenPreview(58, 0x59, 48, 16);
			break;
		case LOC_PIRATE2:
			LocationConfigureScreenPreview(60, 0x6C, 16, 16);
			break;
		case LOC_KIKALA:
			LocationConfigureScreenPreview(27, 0x4C, 80, 16);
			break;
		case LOC_LEIPAI:
			LocationConfigureScreenPreview(33, 0x49, 16, 16);
			break;
		case LOC_TULANE:
			LocationConfigureScreenPreview(43, 0x67, 72, 8);
			break;
		case LOC_CARN:
			LocationConfigureScreenPreview(38, 0x6B, 80, 48);
			break;
		case LOC_PYRAMID:
			LocationConfigureScreenPreview(73, 0x7D, 24, 0);
			break;
		case LOC_MIRAGE:
			LocationConfigureScreenPreview(45, 0x2E, 112, 56);
			break;
		case LOC_MUSHRUSH:
			LocationConfigureScreenPreview(75, 0x73, 0, 0);
			break;
		case LOC_SILVER:
			LocationConfigureScreenPreview(40, 0x60, 64, 8);
			break;
		case LOC_PONI:
			LocationConfigureScreenPreview(49, 0x21, 16, 16);
			break;
		case LOC_LAKE:
			LocationConfigureScreenPreview(52, 0x44, 72, 0);
			break;
		case LOC_MIST:
			LocationConfigureScreenPreview(53, 0x55, 96, 0);
			break;
	}
}
void LocationConfigureScreenPreview(int dmap, int scrn, int x, int y){
	dmapdata curDMap = Game->LoadDMapData(Game->GetCurDMap());
	dmapdata targetDMap = Game->LoadDMapData(dmap);
	
	DayNight_UpdateDMapPalette(dmap);
	if(dmap==Game->GetCurDMap())
		curDMap->Palette = G[G_SUBSCREENOPENDMAPPALETTE];
	else
		curDMap->Palette = targetDMap->Palette;
	G[G_LOCATIONSUB_MAP] = Game->DMapMap[dmap];
	G[G_LOCATIONSUB_SCREEN] = scrn;
	G[G_LOCATIONSUB_X] = x;
	G[G_LOCATIONSUB_Y] = y;
	G[G_LOCATIONSUB_FOGTILE] = 0;
	if(dmap==45)
		G[G_LOCATIONSUB_FOGTILE] = 44521;
	else if(dmap==52)
		G[G_LOCATIONSUB_FOGTILE] = 44804;
		
}

//Get the main DMap for each location
int LocationDMap(int loc){
	switch(loc){
		case LOC_PUNA:
			return 1;
		case LOC_OMAKA:
			return 0;
		case LOC_PALA:
			return 2;
		case LOC_WAREHOUSE:
			return 9;
		case LOC_MANOR:
			return 24;
		case LOC_CATACOMBS:
			return 25;
		case LOC_KAWI:
			return 6;
		case LOC_PIRATE:
			return 16;
		case LOC_MALKA:
			return 26;
		case LOC_SHOALS:
			return 14;
		case LOC_MINE:
			return 17;
		case LOC_JUNGLE:
			return 10;
		case LOC_HILLSIDE:
			return 11;
		case LOC_LAVAFLOWS:
			return 12;
		case LOC_JUNGLECAVE:
			return 62;
		case LOC_HOKU:
			return 28;
		case LOC_TEMPLEOUTSIDE:
			return 36;
		case LOC_JUNGLETEMPLE:
			return 37;
		case LOC_ALII:
			return 20;
		case LOC_OBSERVATORY:
			return 23;
		case LOC_PONI:
			return 49;
		case LOC_LAKE:
			return 52;
		case LOC_MIST:
			return 53;
		case LOC_KAWAIHAE:
			return 30;
		case LOC_KUKULU:
			return 58;
		case LOC_PIRATE2:
			return 60;
		case LOC_KIKALA:
			return 27;
		case LOC_LEIPAI:
			return 33;
		case LOC_TULANE:
			return 43;
		case LOC_CARN:
			return 38;
		case LOC_PYRAMID:
			return 73;
		case LOC_MIRAGE:
			return 45;
		case LOC_MUSHRUSH:
			return 75;
		case LOC_SILVER:
			return 40;
	}
}

int DMapLocation(int dmap){
	switch(dmap){
		case 0:
		case 7:
			return LOC_OMAKA;
		case 1:
		case 15:
			return LOC_PUNA;
		case 2:
		case 3:
		case 4:
		case 5:
		case 78:
			return LOC_PALA;
		case 9:
			return LOC_WAREHOUSE;
		case 6:
		case 8:
			return LOC_KAWI;
		case 16:
			return LOC_PIRATE;
		case 26:
		case 31:
			return LOC_MALKA;
		case 10:
			return LOC_JUNGLE;
		case 11:
			return LOC_HILLSIDE;
		case 12:
		case 13:
			return LOC_LAVAFLOWS;
		case 62:
			return LOC_JUNGLECAVE;
		case 36:
			return LOC_TEMPLEOUTSIDE;
		case 37:
			return LOC_JUNGLETEMPLE;
		case 28:
		case 32:
			return LOC_HOKU; 
		case 18:
		case 19:
		case 20:
			return LOC_ALII;
		case 14:
		case 22:
			return LOC_SHOALS;
		case 17:
		case 21:
			return LOC_MINE;
		case 24:
			return LOC_MANOR;
		case 25:
			return LOC_CATACOMBS;
		case 23:
		case 66:
		case 70:
		case 71:
			return LOC_OBSERVATORY;
		case 30:
			return LOC_KAWAIHAE;
		case 27:
			return LOC_KIKALA;
		case 33:
		case 34:
		case 35:
			return LOC_LEIPAI;
		case 43:
		case 44:
			return LOC_TULANE;
		case 38:
		case 39:
		case 42:
			return LOC_CARN;
		case 73:
			return LOC_PYRAMID;
		case 45:
		case 46:
			return LOC_MIRAGE;
		case 75:
			return LOC_MUSHRUSH;
		case 40:
		case 41:
		case 72:
			return LOC_SILVER;
		case 49:
		case 50:
		case 51:
			return LOC_PONI;
		case 52:
			return LOC_LAKE;
		case 53:
		case 55:
			return LOC_MIST;
		case 58:
		case 59:
			 return LOC_KUKULU;
		case 60:
			 return LOC_PIRATE2;
	}
	return -1;
}

enum{
	QST_IRIS,
	QST_TERRY,
	QST_PIRATE,
	QST_GOLEM,
	QST_PLANT,
	QST_VOLCANO,
	QST_NIGHTMARCHER,
	QST_CULTIST,
	QST_SOREN,
	QST_HORIZON,
	QST_HELPER
};

void SidequestName(int buf, int id){
	int progress = SidequestProgress(id);
	switch(id){
		case QST_IRIS:
			CopyStringToBuffer(buf, "Silent Sister's Stipulation");
			break;
		case QST_TERRY:
			CopyStringToBuffer(buf, "Brothers in Harm's Way");
			break;
		case QST_PIRATE:
			CopyStringToBuffer(buf, "Pirate Payback");
			break;
		case QST_GOLEM:
			CopyStringToBuffer(buf, "Mysterious Carn Ruins");
			break;
		case QST_PLANT:
			CopyStringToBuffer(buf, "Bring Me A Shrubbery");
			break;
		case QST_VOLCANO:
			CopyStringToBuffer(buf, "Truf's Memento");
			break;
		case QST_NIGHTMARCHER:
			CopyStringToBuffer(buf, "In Pursuit of Death");
			break;
		case QST_CULTIST:
			CopyStringToBuffer(buf, "One Last Sabotage");
			break;
		case QST_SOREN:
			if(progress>4)
				CopyStringToBuffer(buf, "Eat the Rich");
			else if(progress>2)
				CopyStringToBuffer(buf, "Misty is Missing");
			else
				CopyStringToBuffer(buf, "Letter Delivery");
			break;
		case QST_HORIZON:
			if(progress<9)
				CopyStringToBuffer(buf, "Chasing Your Footsteps");
			else
				CopyStringToBuffer(buf, "Chasing the Horizon");
			break;
		case QST_HELPER:
			CopyStringToBuffer(buf, "Helpers to Heroes");
			break;
	}
}

int SidequestProgress(int id){
	switch(id){
		case QST_IRIS:
			return Game->Counter[CR_ASHERSIDEQUEST];
			break;
		case QST_TERRY:
			if(Game->Counter[CR_TORRINSIDEQUEST]==10)
				return 0;
			return Game->Counter[CR_TORRINSIDEQUEST];
			break;
		case QST_PIRATE:
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_12) //Cleared the quest
				return 3;
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_11) //Found Shelrond
				return 2;
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_10) //Got quest
				return 1;
			break;
		case QST_GOLEM:
			return Game->Counter[CR_GOLEMSIDEQUEST];
			break;
		case QST_PLANT:
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_2) //Gave the plant
				return 4;
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_1) //Found the plant
				return 3;
			if(LoreTracking[LT_LOCATIONS+LOC_JUNGLECAVE])
				return 2;
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_0) //Met Laverne
				return 1;
			break;
		case QST_VOLCANO:
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_4) //Turned in necklace
				return 3;
			if(Link->Item[207]) //Has necklace
				return 2;
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_3) //Met Truf
				return 1;
			break;
		case QST_NIGHTMARCHER:
			return Game->Counter[CR_NIGHTMARCHERQUEST];
			break;
		case QST_CULTIST:
			switch(Game->Counter[CR_CULTISTQUEST]){
				case 3:
				case 4:
					return 3;
			}
			return Game->Counter[CR_CULTISTQUEST];
			break;
		case QST_SOREN:
			switch(Game->Counter[CR_MISCSIDEQUEST]){
				case 1:
				case 2:
					return 1;
				case 3:
				case 4:
					return 3;
			}
			return Game->Counter[CR_MISCSIDEQUEST];
		case QST_HORIZON:
			if(Game->Counter[CR_CHASEQUEST]<6){
				return Game->Counter[CR_CHASEQUEST];
			}
			else{
				if(Game->Counter[CR_CHASEQUEST]==9)
					return 10;
				if(Game->Counter[CR_CHASEQUEST]==8)
					return 9;
				if(Game->Counter[CR_CHASEQUEST]==7)
					return 8;
				if(Game->Counter[CR_TOTALHYMNSTONES]>=100)
					return 7;
				else
					return 6;
			}
			break;
		case QST_HELPER:
			return Game->Counter[CR_HELPERQUEST];
			break;
		default:
			return 99;
			break;
	}
}
int SidequestMaxProgress(int id){
	switch(id){
		case QST_IRIS:
			return 4;
			break;
		case QST_TERRY:
			return 4;
			break;
		case QST_PIRATE:
			return 3;
			break;
		case QST_GOLEM:
			return 4;
			break;
		case QST_PLANT:
			return 4;
			break;
		case QST_VOLCANO:
			return 3;
			break;
		case QST_NIGHTMARCHER:
			return 7;
			break;
		case QST_CULTIST:
			return 6;
			break;
		case QST_SOREN:
			return 7;
		case QST_HORIZON:
			return 10;
		case QST_HELPER:
			return 3;
		default:
			return 99;
			break;
	}
}

void ClearSidequest(int id){
	switch(id){
		case QST_IRIS:
			Game->Counter[CR_ASHERSIDEQUEST] = SidequestMaxProgress(QST_IRIS);
			break;
		case QST_TERRY:
			Game->Counter[CR_TORRINSIDEQUEST] = SidequestMaxProgress(QST_TERRY);
			break;
		case QST_PIRATE:
			Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_12; //Cleared the quest
			Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_11; //Found Shelrond
			Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_10; //Got quest
			break;
		case QST_GOLEM:
			Game->Counter[CR_GOLEMSIDEQUEST] = SidequestMaxProgress(QST_GOLEM);
			break;
		case QST_PLANT:
			Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_2; //Gave the plant
			Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_1; //Found the plant
			Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_0; //Met Laverne
			break;
		case QST_VOLCANO:
			Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_4; //Turned in necklace
			Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_3; //Met Truf
			break;
		case QST_NIGHTMARCHER:
			Game->Counter[CR_NIGHTMARCHERQUEST] = SidequestMaxProgress(QST_NIGHTMARCHER);
			break;
		case QST_CULTIST:
			Game->Counter[CR_CULTISTQUEST] = SidequestMaxProgress(QST_CULTIST);
			break;
		case QST_SOREN:
			Game->Counter[CR_MISCSIDEQUEST] = SidequestMaxProgress(QST_SOREN);
		case QST_HORIZON:
			Game->Counter[CR_TOTALHYMNSTONES] = 100;
			Game->Counter[CR_CHASEQUEST] = SidequestMaxProgress(QST_HORIZON);
			break;
		case QST_HELPER:
			Game->Counter[CR_HELPERQUEST] = SidequestMaxProgress(QST_HELPER);
			break;
	}
}

void SidequestDescription(int buf, int id){
	int progress = SidequestProgress(id);
	switch(id){
		case QST_IRIS:
			CopyStringToBuffer(buf, "Iris, has \"generously\" offered to continue to cover for you, if you can bring her a gemstone from the Kawaihae Cave.");
			break;
		case QST_TERRY:
			CopyStringToBuffer(buf, "Following in his example, Torrin's brother Caiman and his friend Zeke have taken a boat and gone missing. Find them and bring them back safely.");
			break;
		case QST_PIRATE:
			CopyStringToBuffer(buf, "Shelrond has led his crew to a backup hideout. Put him in his place and rid the seas of the his crew's thieving and kidnapping.");
			break;
		case QST_GOLEM:
			CopyStringToBuffer(buf, "A friend of Kaylani's, Siyed, is investigating the Carn Ruins. You've volunteered to help investigate. ");
			if(progress>1)
				strcat(buf, "Turns out some violence may be required. ");
			break;
		case QST_PLANT:
			CopyStringToBuffer(buf, "A botanist named Laverne on Kikala Hill has asked you to help her collect specimens for her research.");
			break;
		case QST_VOLCANO:
			CopyStringToBuffer(buf, "A boy named Truf from Hoku Village has lost an important necklace left behind by his father. Help him get it back.");
			break;
		case QST_NIGHTMARCHER:
			if(Game->Counter[CR_NIGHTMARCHERQUEST] < 2)
				CopyStringToBuffer(buf, "Terry's headed to Pala Bay for some reason. Find her and find out why.");
			else
				CopyStringToBuffer(buf, "Terry wants to track down a group of Nightmarchers to meet her great grandfather. Help her meet her ancestor without returning to her ancestors.");
			break;
		case QST_CULTIST:
			CopyStringToBuffer(buf, "One of Selet's former henchmen from Hoku is looking to turn over a new leaf. He wants to disrupt one of Selet's plans as one last act of sabotage.");
			break;
		case QST_SOREN:
			if(progress>2)
				CopyStringToBuffer(buf, "It turns out Soren's sister Misty has gone missing. Help him search for her.");
			else
				CopyStringToBuffer(buf, "Soren asked you to deliver a letter to his sister in Pala Bay.");
			break;
		case QST_HORIZON:
			if(progress<9)
				CopyStringToBuffer(buf, "An excitable young boy from Pala Bay has taken you as a role model. He wants to hear interesting stories from your adventure. No harm in humoring him, right?");
			else
				CopyStringToBuffer(buf, "Turns out that energetic kid was also the host to the spirit of the sun. And your stories got him all riled up. Nice going.");
			break;
		case QST_HELPER:
			CopyStringToBuffer(buf, "Soren, Terry, and Siyed have stumbled onto a plot by Esan and Selet's henchmen to locate their missing leader and decided to put a stop to it.");
			break;
	}
	strcat(buf, "@N @N Objectives:");
}
void SidequestObjectives(bitmap b, int y, int id){
	int progress = SidequestProgress(id);
	switch(id){
		case QST_IRIS:
			y = AddSidequestObjective(b,y, progress>1, "Find the gem in Kawaihae Cave");
			if(progress>1)
				y = AddSidequestObjective(b,y, progress>2, "Defeat the solar pillar");
			if(progress>2)
				y = AddSidequestObjective(b,y, progress>3, "Return to Iris");
			break;
		case QST_TERRY:
			if(progress<=1)
				y = AddSidequestObjective(b,y, progress>1, "Find Zeke and Caiman");
			else
				y = AddSidequestObjective(b,y, progress>1, "Find Zeke");
			if(progress>1)
				y = AddSidequestObjective(b,y, progress>2, "Find Caiman");
			if(progress>2)
				y = AddSidequestObjective(b,y, progress>3, "Rescue Caiman");
			break;
		case QST_PIRATE:
			y = AddSidequestObjective(b,y, progress>1, "Find Captain Shelrond");
			if(progress>1)
				y = AddSidequestObjective(b,y, progress>2, "Defeat Captain Shelrond");
			break;
		case QST_GOLEM:
			y = AddSidequestObjective(b,y, progress>1, "Find a way into the ruins");
			if(progress>1){
				y = AddSidequestObjective(b,y, G[G_GOLEMFLAG]&8, "Smash the solar golem");
				y = AddSidequestObjective(b,y, G[G_GOLEMFLAG]&16, "Smash the lunar golem");
				y = AddSidequestObjective(b,y, G[G_GOLEMFLAG]&32, "Smash the stellar golem");
				if((G[G_GOLEMFLAG]&8)&&(G[G_GOLEMFLAG]&16)&&(G[G_GOLEMFLAG]&32))
					y = AddSidequestObjective(b,y, (G[G_GOLEMFLAG]&1)&&(G[G_GOLEMFLAG]&2)&&(G[G_GOLEMFLAG]&4), "Investigate the paths in Carn Ruins");
			}
			if((G[G_GOLEMFLAG]&1)&&(G[G_GOLEMFLAG]&2)&&(G[G_GOLEMFLAG]&4))
				y = AddSidequestObjective(b,y, progress>2, "Speak with Siyed");
			if(progress>2)
				y = AddSidequestObjective(b,y, progress>3, "Smash the fusion golem");
			break;
		case QST_PLANT:
			if(progress>1)
				y = AddSidequestObjective(b,y, progress>1, "Find the Overgrown Passage");
			else
				y = AddSidequestObjective(b,y, progress>1, "Find a path to Wahiokala jungle hill");
			if(progress>1)
				y = AddSidequestObjective(b,y, progress>2, "Find the white shrub");
			if(progress>2)
				y = AddSidequestObjective(b,y, progress>3, "Return to Laverne with the clippings");
			break;
		case QST_VOLCANO:
			y = AddSidequestObjective(b,y, progress>1||(G[G_TRUFQUESTFLAGS]&2), "Check the Hoku Village islands");
			y = AddSidequestObjective(b,y, progress>1||(G[G_TRUFQUESTFLAGS]&4), "Check the volcano passage");
			y = AddSidequestObjective(b,y, progress>1||(G[G_TRUFQUESTFLAGS]&8), "Check the hot springs");
			y = AddSidequestObjective(b,y, progress>1, "Check the rock piles");
			y = AddSidequestObjective(b,y, progress>1||(G[G_TRUFQUESTFLAGS]&16), "Check the ocean");
			y = AddSidequestObjective(b,y, progress>1||(G[G_TRUFQUESTFLAGS]&32), "Check the base of Mauna Ali'i");
			y = AddSidequestObjective(b,y, progress>1, "Find the necklace");
			if(progress>1)
				y = AddSidequestObjective(b,y, progress>2, "Return to Truf");
			break;
		case QST_NIGHTMARCHER:
			y = AddSidequestObjective(b,y, progress>1, "Find Terry in Pala Bay");
			if(progress>1){
				if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_9)
					y = AddSidequestObjective(b,y, progress>3, "Find Siyed in Kohi Canyon");
				else{
					y = AddSidequestObjective(b,y, progress>2, "Ask Lilah about Siyed's whereabouts");
					if(progress>2)
						y = AddSidequestObjective(b,y, progress>3, "Find Siyed in Kohi Canyon");
				}
			}
			if(progress>3)
				y = AddSidequestObjective(b,y, progress>4, "Climb Tel's Pyramid");
			if(progress>4)
				y = AddSidequestObjective(b,y, progress>5, "Track the Nightmarchers");
			if(progress>5)
				y = AddSidequestObjective(b,y, progress>6, "Survive");
			break;
		case QST_CULTIST:
			y = AddSidequestObjective(b,y, G[G_STOLESOLARMASK], "Steal a solar mask");
			y = AddSidequestObjective(b,y, G[G_STOLELUNARMASK], "Steal a lunar mask");
			y = AddSidequestObjective(b,y, G[G_STOLESTELLARMASK], "Steal a stellar mask");
			if(G[G_STOLESOLARMASK]&&G[G_STOLELUNARMASK]&&G[G_STOLESTELLARMASK])
				y = AddSidequestObjective(b,y, progress>2, "Find Micah by the temple grounds");
			if(progress>2)
				y = AddSidequestObjective(b,y, progress>4, "Get inside the temple");
			if(progress>4)
				y = AddSidequestObjective(b,y, progress>5, "Retrieve the temple's treasure");
			break;
		case QST_SOREN:
			if(progress>2)
				y = AddSidequestObjective(b,y, progress>2, "Never mind the letter");
			else
				y = AddSidequestObjective(b,y, progress>2, "Deliver the letter to Misty");
			if(progress>2)
				y = AddSidequestObjective(b,y, progress>4, "Search for clues to Misty's whereabouts");
			if(progress>4)
				y = AddSidequestObjective(b,y, progress>5, "Head to Madame Tulane's villa");
			if(progress>5)
				y = AddSidequestObjective(b,y, progress>6, "Rescue Misty");
			break;
		case QST_HORIZON:
			if(Game->Counter[CR_STORYFLAG]<SFLAG_METKAYLANI)
				y = AddSidequestObjective(b,y, progress>1, "Progress the main quest");
			else
				y = AddSidequestObjective(b,y, progress>1, "Tell Chase about the Warehouse");
			if(progress>1){
				if(Game->Counter[CR_STORYFLAG]<SFLAG_LEVEL1)
					y = AddSidequestObjective(b,y, progress>2, "Progress the main quest");
				else
					y = AddSidequestObjective(b,y, progress>2, "Tell Chase about the Pirate Hideout");
			}
			if(progress>2){
				if(Game->Counter[CR_STORYFLAG]<SFLAG_ASHERRESCUED)
					y = AddSidequestObjective(b,y, progress>3, "Progress the main quest");
				else
					y = AddSidequestObjective(b,y, progress>3, "Tell Chase about the Deepsea Mine");
			}
			if(progress>3){
				if(Game->Counter[CR_STORYFLAG]<SFLAG_MISTCLEAR)
					y = AddSidequestObjective(b,y, progress>4, "Progress the main quest");
				else
					y = AddSidequestObjective(b,y, progress>4, "Tell Chase about the Sealed Temple");
			}
			if(progress>4){
				if(Game->Counter[CR_STORYFLAG]<SFLAG_GAMECLEAR)
					y = AddSidequestObjective(b,y, progress>5, "Finish the main quest");
				else
					y = AddSidequestObjective(b,y, progress>5, "Tell Chase about the Observatory");
			}
			if(progress>5){
				int str[256];
				sprintf(str, "Gather all the Hymnstones (%d/100)", Game->Counter[CR_TOTALHYMNSTONES]);
				y = AddSidequestObjective(b,y, progress>6, str);
			}
			if(progress>6)
				y = AddSidequestObjective(b,y, progress>7, "Check out the island marked on your map");
			if(progress>7)
				y = AddSidequestObjective(b,y, progress>8, "Ascend Mt. Silver");
			if(progress>8)
				y = AddSidequestObjective(b,y, progress>9, "SURVIVE!");
			break;
		case QST_HELPER:
			y = AddSidequestObjective(b,y, progress>1, "Explore the Submerged Pyramid");
			if(progress>1)
				y = AddSidequestObjective(b,y, progress>2, "Defeat Esan");
			break;
	}
	G[G_CURRENTQUESTMAXSCROLL] = Max(y-101, 0);
}
int AddSidequestObjective(bitmap b, int y, bool completed, int str){
	b->FastTile(0, 6, y-2, completed?63569:63568, 7, 128);
	b->DrawString(0, 18, y, FONT_Z3SMALL, completed?0x0B:0x01, -1, TF_NORMAL, str, 128, SHD_OUTLINED8, 0x0F);
	return y + 12;
}

bool ItemName(int buf, int itemID){
	if(itemID>=1000){
		itemID -= 1000;
		int name[256];
		BestiaryName(name, itemID, false, false);
		int pageNum = BestiaryListNum(itemID);
		sprintf(buf, "Bestiary Entry %d: %s", pageNum+1, name);
		return true;
	}
	switch(itemID){
		case 170:
			CopyStringToBuffer(buf, "Dash");
			break;
		case 178:
			CopyStringToBuffer(buf, "Starstone");
			break;
		case 167:
			CopyStringToBuffer(buf, "Solar System");
			break;
		case 218:
			CopyStringToBuffer(buf, "Heatwave");
			break;
		case 215:
			CopyStringToBuffer(buf, "Sparking Slash");
			break;
		case 217:
			CopyStringToBuffer(buf, "Straight Up Robbery");
			break;
		case 167:
			CopyStringToBuffer(buf, "Fishing Rod");
			break;
		case 171:
			CopyStringToBuffer(buf, "Stellar Sword");
			break;
		case 168:
			CopyStringToBuffer(buf, "Sundog");
			break;
		case 219:
			CopyStringToBuffer(buf, "Concentration");
			break;
		case 216:
			CopyStringToBuffer(buf, "Reckless Ricochet");
			break;
		case 55:
			CopyStringToBuffer(buf, "Battery (Terry)");
			break;
		case 165:
			CopyStringToBuffer(buf, "Battery (Torrin)");
			break;
		case 172:
			CopyStringToBuffer(buf, "Stellaire");
			break;
		case 169:
			CopyStringToBuffer(buf, "Solar Flare");
			break;
		case 226:
			CopyStringToBuffer(buf, "Unstable Orbit");
			break;
		case 108:
			CopyStringToBuffer(buf, "Grappling Hook");
			break;
		case 88:
			CopyStringToBuffer(buf, "Bloodmoon Gauntlet");
			break;
		case 166:
			CopyStringToBuffer(buf, "Magic Trap");
			break;
			
		case 71:
			CopyStringToBuffer(buf, "Augment Slot (Asher)");
			break;
		case 57:
			CopyStringToBuffer(buf, "Augment Slot (Kaylani)");
			break;
		case 117:
			CopyStringToBuffer(buf, "Augment Slot (Siyed)");
			break;
		case 115:
			CopyStringToBuffer(buf, "Augment Slot (Soren)");
			break;
		case 116:
			CopyStringToBuffer(buf, "Augment Slot (Terry)");
			break;
		case 16:
			CopyStringToBuffer(buf, "Augment Slot (Torrin)");
			break;
		case 116:
			CopyStringToBuffer(buf, "Augment Slot (Terry)");
			break;
			
		case 182:
			CopyStringToBuffer(buf, "Counter Dash");
			break;
			
		case 70:
			CopyStringToBuffer(buf, "Health+ (Asher)");
			break;
		case 73:
			CopyStringToBuffer(buf, "Health+ (Kaylani)");
			break;
		case 113:
			CopyStringToBuffer(buf, "Health+ (Siyed)");
			break;
		case 49:
			CopyStringToBuffer(buf, "Health+ (Soren)");
			break;
		case 112:
			CopyStringToBuffer(buf, "Health+ (Terry)");
			break;
		case 72:
			CopyStringToBuffer(buf, "Health+ (Torrin)");
			break;
			
		case 87:
			CopyStringToBuffer(buf, "Hymnstone");
			break;
			
		case 11:
			CopyStringToBuffer(buf, "Lantern");
			break;
		case 144:
			CopyStringToBuffer(buf, "Lobber Bomb");
			break;
		case 24:
			CopyStringToBuffer(buf, "Lunarang");
			break;
			
		case 149:
			CopyStringToBuffer(buf, "Asher");
			break;
		case 151:
			CopyStringToBuffer(buf, "Kaylani");
			break;
		case 214:
			CopyStringToBuffer(buf, "Siyed");
			break;
		case 212:
			CopyStringToBuffer(buf, "Soren");
			break;
		case 213:
			CopyStringToBuffer(buf, "Terry");
			break;
		case 150:
			CopyStringToBuffer(buf, "Torrin");
			break;
			
		case 0:
			CopyStringToBuffer(buf, "1G");
			break;
		case 1:
			CopyStringToBuffer(buf, "5G");
			break;
		case 86:
			CopyStringToBuffer(buf, "10G");
			break;
		case 38:
			CopyStringToBuffer(buf, "25G");
			break;
		case 84:
			CopyStringToBuffer(buf, "Small Key");
			break;
		case 67:
			CopyStringToBuffer(buf, "Big Key");
			break;
			
		case 8:
			CopyStringToBuffer(buf, "Iron Shield");
			break;
		case 25:
			CopyStringToBuffer(buf, "Stellar Wand");
			break;
		case 6:
			CopyStringToBuffer(buf, "Silver Sword");
			break;
		case 163:
			CopyStringToBuffer(buf, "Solar Might");
			break;
		case 143:
			CopyStringToBuffer(buf, "Solar Surge");
			break;
		case 143:
			CopyStringToBuffer(buf, "Solar Surge");
			break;
		case 50:
			CopyStringToBuffer(buf, "Engine Cleaver");
			break;
		case 63:
			CopyStringToBuffer(buf, "Blue Belt");
			break;
		case 162:
			CopyStringToBuffer(buf, "Black Belt");
			break;
			
		case 145:
		case 146:
			CopyStringToBuffer(buf, "Tidal Gauntlet");
			break;
		
		case 183:
			CopyStringToBuffer(buf, "Tri Lantern");
			break;
		case 184:
			CopyStringToBuffer(buf, "Short Fuse");
			break;
		case 185:
			CopyStringToBuffer(buf, "Magnet+");
			break;
		case 186:
			CopyStringToBuffer(buf, "Stellar Wand+");
			break;
		case 187:
			CopyStringToBuffer(buf, "Speed+");
			break;
		case 188:
			CopyStringToBuffer(buf, "Dash Length+");
			break;
		case 189:
			CopyStringToBuffer(buf, "Dash Counter+");
			break;
		case 190:
			CopyStringToBuffer(buf, "Stellar Greatsword");
			break;
		case 191:
			CopyStringToBuffer(buf, "Minior");
			break;
		case 192:
			CopyStringToBuffer(buf, "Reflect+");
			break;
		case 193:
			CopyStringToBuffer(buf, "Thrown Punches");
			break;
		case 194:
			CopyStringToBuffer(buf, "Auto Lock");
			break;
		case 195:
			CopyStringToBuffer(buf, "Alt Solar (Torrin)");
			break;
		case 196:
			CopyStringToBuffer(buf, "Alt Lunar (Torrin)");
			break;
		case 197:
			CopyStringToBuffer(buf, "Alt Stellar (Torrin)");
			break;
		case 198:
			CopyStringToBuffer(buf, "Range+ (Kaylani)");
			break;
		case 199:
			CopyStringToBuffer(buf, "Charge Time+");
			break;
		case 200:
			CopyStringToBuffer(buf, "Safe Charge");
			break;
		case 201:
			CopyStringToBuffer(buf, "Wide Mirage");
			break;
		case 202:
			CopyStringToBuffer(buf, "Laser+");
			break;
		case 227:
			CopyStringToBuffer(buf, "Flash Charge");
			break;
		case 228:
			CopyStringToBuffer(buf, "Lingering Flame");
			break;
		case 229:
			CopyStringToBuffer(buf, "Slashing Sparks");
			break;
		case 230:
			CopyStringToBuffer(buf, "Responsible Ricochet");
			break;
		case 231:
			CopyStringToBuffer(buf, "Crippling Hook");
			break;
		case 232:
			CopyStringToBuffer(buf, "Hadouken");
			break;
		case 233:
			CopyStringToBuffer(buf, "Dire Drops");
			break;
		case 234:
			CopyStringToBuffer(buf, "Alt Solar (Terry)");
			break;
		case 235:
			CopyStringToBuffer(buf, "Alt Lunar (Terry)");
			break;
		case 236:
			CopyStringToBuffer(buf, "Alt Stellar (Terry)");
			break;
		case 237:
			CopyStringToBuffer(buf, "Range+ (Siyed)");
			break;
		case 238:
			CopyStringToBuffer(buf, "Diagonal Heat");
			break;
		case 239:
			CopyStringToBuffer(buf, "Updraft");
			break;
		case 240:
			CopyStringToBuffer(buf, "Concentration+");
			break;
		case 241:
			CopyStringToBuffer(buf, "Orbit+");
			break;
		case 255:
			CopyStringToBuffer(buf, "MOOSH SCREWED UP");
			break;
		default:
			CopyStringToBuffer(buf, "???");
			return false;
	}
	return true;
}

void ItemDesc(int buf, int itemID){
	if(itemID>=1000){
		CopyStringToBuffer(buf, "A bestiary entry. Increases damage against this enemy.");
		return;
	}
	switch(itemID){
		case 170:
		case 178:
			if(FoundItems[170])
				CopyStringToBuffer(buf, "Lets Asher bounce off walls and dash across pits.");
			else
				CopyStringToBuffer(buf, "Gives Asher the ability to dash.");
			break;
		case 167:
			CopyStringToBuffer(buf, "An orbiting spell that gets stronger the closer you are to overcharging.");
			break;
		case 218:
			CopyStringToBuffer(buf, "A simple solar magic proectile.");
			break;
		case 215:
			CopyStringToBuffer(buf, "Gain the ability to dash forward with a slash of your sword.");
			break;
		case 217:
			CopyStringToBuffer(buf, "Allows Terry to rob enemies.");
			break;
		case 167:
			CopyStringToBuffer(buf, "Can pull items and batteries off of enemies.");
			break;
		case 171:
			CopyStringToBuffer(buf, "A big hecking plasma sword that's satisfying to swing.");
			break;
		case 168:
			CopyStringToBuffer(buf, "The name is a pun. Look it up.");
			break;
		case 219:
			CopyStringToBuffer(buf, "Lets Siyed mark enemies which has effects on his other spells.");
			break;
		case 216:
			CopyStringToBuffer(buf, "Soren throws a battery and possible blows himself up in the process.");
			break;
		case 55:
			CopyStringToBuffer(buf, "Allows Terry to use magic batteries.");
			break;
		case 165:
			CopyStringToBuffer(buf, "Allows Torrin to use magic batteries.");
			break;
		case 172:
			CopyStringToBuffer(buf, "It's a cool animation but you'll never use it.");
			break;
		case 169:
			CopyStringToBuffer(buf, "If only you could get enemies to sit still...");
			break;
		case 226:
			CopyStringToBuffer(buf, "A spell for Siyed that fires projectiles in an short lasting orbit.");
			break;
		case 108:
			CopyStringToBuffer(buf, "With this Soren can grapple to enemies and across pits.");
			break;
		case 88:
			CopyStringToBuffer(buf, "Esan doesn't need it any more. Stuns enemies and crosses pits. Watch your battery count.");
			break;
		case 166:
			CopyStringToBuffer(buf, "Hopefully this shows up earlier than in the main game.");
			break;
			
		case 71:
		case 57:
		case 117:
		case 115:
		case 116:
		case 16:
			CopyStringToBuffer(buf, "Allows you to equip one more augment.");
			break;
			
		case 182:
			CopyStringToBuffer(buf, "One of several reasons Asher's dash is OP.");
			break;
			
		case 70:
		case 73:
		case 113:
		case 49:
		case 112:
		case 72:
			CopyStringToBuffer(buf, "Have a heart, man.");
			break;
			
		case 87:
			CopyStringToBuffer(buf, "I bet you've never seen one of these before...");
			break;
			
		case 11:
			CopyStringToBuffer(buf, "Dark rooms aren't in pathing if I thought things through correctly.");
			break;
		case 144:
			CopyStringToBuffer(buf, "Throwable bombs. Toss two next to each other to send one flying.");
			break;
		case 24:
			CopyStringToBuffer(buf, "A boomerang with a twist: Hold the button after throwing it to charge up lunar magic.");
			break;
			
		case 149:
			CopyStringToBuffer(buf, "Again, Asher!? Maybe don't get kidnapped next time.");
			break;
		case 151:
			CopyStringToBuffer(buf, "Again, Kaylani!? Girl can't catch a break...");
			break;
		case 214:
		case 212:
		case 213:
		case 150:
			CopyStringToBuffer(buf, "Does this count as human trafficking?");
			break;
			
		case 0:
			CopyStringToBuffer(buf, "Don't spend it all in one place!");
			break;
		case 1:
			CopyStringToBuffer(buf, "Wow.");
			break;
		case 86:
			CopyStringToBuffer(buf, "Count 'em!");
			break;
		case 38:
			CopyStringToBuffer(buf, "Boy you're rich.");
			break;
		case 9:
			CopyStringToBuffer(buf, "Key");
			break;
		case 67:
			CopyStringToBuffer(buf, "Big Key");
			break;
			
		case 8:
			CopyStringToBuffer(buf, "Blocks most non boss projectiles.");
			break;
		case 25:
			CopyStringToBuffer(buf, "Hold the button to redirect your shots. Hold it, I say!");
			break;
		case 6:
			CopyStringToBuffer(buf, "Slash enemy projectiles to reflect them back as magic.");
			break;
		case 163:
			CopyStringToBuffer(buf, "Charge up an extra level to fire a big shot.");
			break;
		case 143:
			CopyStringToBuffer(buf, "Like Kaylani's but less slow and less powerful.");
			break;
		case 50:
			CopyStringToBuffer(buf, "This sword gets stronger when you hold the button with good timing as you swing it.");
			break;
		case 63:
			CopyStringToBuffer(buf, "Terry's here to offer some sisterly encouragement. And then make a hasty retreat.");
			break;
		case 162:
			CopyStringToBuffer(buf, "Y'know, I don't think Torrin actually took any martial arts lessons to earn this thing...");
			break;
			
		case 145:
		case 146:
			CopyStringToBuffer(buf, "Hold to pull or push off of objects. Tap towards objects to pull to them.");
			break;
		
		case 183:
			CopyStringToBuffer(buf, "Lantern shoots three fires.");
			break;
		case 184:
			CopyStringToBuffer(buf, "Bombs explode shortly after hitting the ground.");
			break;
		case 185:
			CopyStringToBuffer(buf, "Tidal Gauntlet moves you slower and enemies faster.");
			break;
		case 186:
			CopyStringToBuffer(buf, "The wand's projectile speed and damage increase.");
			break;
		case 187:
			CopyStringToBuffer(buf, "Slight increase to step speed.");
			break;
		case 188:
			CopyStringToBuffer(buf, "Increases the length of dash.");
			break;
		case 189:
			CopyStringToBuffer(buf, "Slightly increases the window of dash counter.");
			break;
		case 190:
			CopyStringToBuffer(buf, "Increases the range and damage of Stellar Sword. Press the button again for a second swing.");
			break;
		case 191:
			CopyStringToBuffer(buf, "Stellaire drops smaller meteorites but can be used anywhere.");
			break;
		case 192:
			CopyStringToBuffer(buf, "Silver Sword duplicates projectiles it reflects.");
			break;
		case 193:
			CopyStringToBuffer(buf, "Punches create a short ranged projectile in front of them.");
			break;
		case 194:
			CopyStringToBuffer(buf, "Automatically lock onto the closest enemy on a whiffed punch.");
			break;
		case 195:
			CopyStringToBuffer(buf, "Solar battery creates a stationary sunball.");
			break;
		case 196:
			CopyStringToBuffer(buf, "Lunar battery creates a stream of lunar cutters.");
			break;
		case 197:
			CopyStringToBuffer(buf, "Stellar battery drops a rain of targetted arrows that spreads to nearby enemies.");
			break;
		case 198:
			CopyStringToBuffer(buf, "Kaylani's Solar Ball and Solar System have increased range.");
			break;
		case 199:
			CopyStringToBuffer(buf, "Solar Ball and Solar System have reduced charge time.");
			break;
		case 200:
			CopyStringToBuffer(buf, "Solar System no longer breaks on overcharge.");
			break;
		case 201:
			CopyStringToBuffer(buf, "Sun Dog gains two extra hitboxes.");
			break;
		case 202:
			CopyStringToBuffer(buf, "Solar Flare gains slight auto targetting on the current target.");
			break;
		case 227:
			CopyStringToBuffer(buf, "The timing window for Engine Cleaver becomes tighter, but it fully charges in one hit.");
			break;
		case 228:
			CopyStringToBuffer(buf, "Engine Cleaver's flames can double hit.");
			break;
		case 229:
			CopyStringToBuffer(buf, "Sparking Slash shoots spark projectiles during the slash.");
			break;
		case 230:
			CopyStringToBuffer(buf, "Reckless Ricochet no longer deals self damage.");
			break;
		case 231:
			CopyStringToBuffer(buf, "Enemies being pulled by Grappling Hook will take 1.5x damage.");
			break;
		case 232:
			CopyStringToBuffer(buf, "Punches will shoot a projectile at full HP.");
			break;
		case 233:
			CopyStringToBuffer(buf, "Enemies will drop batteries when you're low.");
			break;
		case 234:
			CopyStringToBuffer(buf, "Solar battery becomes a chasing projectile.");
			break;
		case 235:
			CopyStringToBuffer(buf, "Lunar battery becomes a claw attack.");
			break;
		case 236:
			CopyStringToBuffer(buf, "Stellar battery becomes a projectile that knocks back enemies.");
			break;
		case 237:
			CopyStringToBuffer(buf, "Siyed's Solar Ball has increased range.");
			break;
		case 238:
			CopyStringToBuffer(buf, "Allows Heatwave to fire at a diagonal.");
			break;
		case 239:
			CopyStringToBuffer(buf, "Gives heatwave a trail behind it that lets you move faster while moving through it.");
			break;
		case 240:
			CopyStringToBuffer(buf, "Makes Concentration's lens turn to the direction you're facing.");
			break;
		case 241:
			CopyStringToBuffer(buf, "Unstable orbit gains two extra projectiles.");
			break;
	}
}