import "std.zh"

const int FLAG_SHOP_ITEM = 100; // A flag to use for shop items.
const int CMB_SHOP_ITEM = 2500; // Blank, solid combo.
const int SHOP_PRICE_Y_OFFSET = 18;
const int SHOP_PRICE_X_OFFSET = -4;
const int SFX_BUYITEM = 63;
const int SHOP_STRING_LAYER = 2;
const int SHOP_STRING_SHADOW_X_OFFSET = 1;
const int SHOP_STRING_SHADOW_Y_OFFSET = 1;
const int SHOP_STRING_BG_COLOUR = 0x0F;
const int SHOP_STRING_FG_COLOUR = 0x01;

ffc script Automatic_Z3_Shop
{
	void run(int shop_id)
	{
		item shopitems[3];  int count; messagedata md[3];
		 
		shopdata sd = Game->LoadShopData(shop_id);
		//md[0] = Game->LoadMessageData(sd->String[0]);
		//md[1] = Game->LoadMessageData(sd->String[1]);
		//md[2] = Game->LoadMessageData(sd->String[2]);
		for ( int q = 0; q < 176; ++q )
		{
			//FInd the flags and place the items
			if ( Screen->ComboF[q] == FLAG_SHOP_ITEM )
			{
				Screen->ComboD[q] = CMB_SHOP_ITEM;
				shopitems[count] = Screen->CreateItem(sd->Item[count]);
				shopitems[count]->X = ComboX(q);
				shopitems[count]->Y = ComboY(q);
				shopitems[count]->HitXOffset = -32768;
				shopitems[count]->PickupString = sd->String[count];
				shopitems[count]->PickupStringFlags |= 0x04;
				++count;
				if ( count > 2 ) { break; }
			}
		}
		while(1)
		{
			
			//Draw the prices
			Screen->DrawString( SHOP_STRING_LAYER, shopitems[0]->X+SHOP_PRICE_X_OFFSET+SHOP_STRING_SHADOW_X_OFFSET,
				shopitems[0]->Y+SHOP_PRICE_Y_OFFSET+SHOP_STRING_SHADOW_Y_OFFSET, FONT_Z3SMALL, SHOP_STRING_BG_COLOUR,
				0, 0, sd->Price[0], OP_OPAQUE);
				
			Screen->DrawString( SHOP_STRING_LAYER, shopitems[0]->X+SHOP_PRICE_X_OFFSET,
				shopitems[0]->Y+SHOP_PRICE_Y_OFFSET, FONT_Z3SMALL, SHOP_STRING_FG_COLOUR,
				0, 0, sd->Price[0], OP_OPAQUE);
			
			Screen->DrawString( SHOP_STRING_LAYER, shopitems[1]->X+SHOP_PRICE_X_OFFSET+SHOP_STRING_SHADOW_X_OFFSET,
				shopitems[0]->Y+SHOP_PRICE_Y_OFFSET+SHOP_STRING_SHADOW_Y_OFFSET, FONT_Z3SMALL, SHOP_STRING_BG_COLOUR,
				0, 0, sd->Price[1], OP_OPAQUE);
				
			Screen->DrawString( SHOP_STRING_LAYER, shopitems[1]->X+SHOP_PRICE_X_OFFSET,
				shopitems[0]->Y+SHOP_PRICE_Y_OFFSET, FONT_Z3SMALL, SHOP_STRING_FG_COLOUR,
				0, 0, sd->Price[1], OP_OPAQUE);
				
			Screen->DrawString( SHOP_STRING_LAYER, shopitems[2]->X+SHOP_PRICE_X_OFFSET+SHOP_STRING_SHADOW_X_OFFSET,
				shopitems[0]->Y+SHOP_PRICE_Y_OFFSET+SHOP_STRING_SHADOW_Y_OFFSET, FONT_Z3SMALL, SHOP_STRING_BG_COLOUR,
				0, 0, sd->Price[2], OP_OPAQUE);
				
			Screen->DrawString( SHOP_STRING_LAYER, shopitems[2]->X+SHOP_PRICE_X_OFFSET,
				shopitems[0]->Y+SHOP_PRICE_Y_OFFSET, FONT_Z3SMALL, SHOP_STRING_FG_COLOUR,
				0, 0, sd->Price[2], OP_OPAQUE); 

				//Don't do shop interactivity while Link is holding up an item!
				if ( Link->Action == LA_HOLD1LAND ) continue;
				if ( Link->Action == LA_HOLD2LAND ) continue;

			for ( int q = 0; q < 3; ++q )
			{
				if ( PressedBuyButton() )
				{
					if ( Link->Dir == DIR_UP )
					{
						if ( Game->Counter[CR_RUPEES] >= sd->Price[q] )
						{
							if ( _Z3_Below(shopitems[q]) )
							{
								if ( _Z3_DistXY(shopitems[q], 12) )
								{
									Audio->PlaySound(SFX_BUYITEM);
									Game->DCounter[CR_RUPEES] -= sd->Price[q];
									shopitems[q]->Pickup = IP_HOLDUP; 
									shopitems[q]->HitXOffset = 0; 
									shopitems[q]->X = Link->X; 
									shopitems[q]->Y = Link->Y; 
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

bool _Z3_Below(item n){ return Link->Y > n->Y; }

bool _Z3_DistXY(item b, int distance) {
	int distx; int disty;
	distx = Abs(Link->X - b->X);
	disty = Abs(Link->Y - b->Y);

	return ( distx <= distance && disty <= distance );
} 

const int Z3_SHOP_BUY_BUTTON_A = 1;
const int Z3_SHOP_BUY_BUTTON_B = 1;
const int Z3_SHOP_BUY_BUTTON_L = 0;
const int Z3_SHOP_BUY_BUTTON_R = 0;
const int Z3_SHOP_BUY_BUTTON_EX1 = 0;
const int Z3_SHOP_BUY_BUTTON_EX2 = 0;
const int Z3_SHOP_BUY_BUTTON_EX3 = 0;
const int Z3_SHOP_BUY_BUTTON_EX4 = 0;
bool PressedBuyButton()
{
	if ( Z3_SHOP_BUY_BUTTON_A && Link->PressA ) return true;
	if ( Z3_SHOP_BUY_BUTTON_B && Link->PressB ) return true;
	if ( Z3_SHOP_BUY_BUTTON_L && Link->PressL ) return true;
	if ( Z3_SHOP_BUY_BUTTON_R && Link->PressR ) return true;
	if ( Z3_SHOP_BUY_BUTTON_EX1 && Link->PressEx1 ) return true;
	if ( Z3_SHOP_BUY_BUTTON_EX2 && Link->PressEx2 ) return true;
	if ( Z3_SHOP_BUY_BUTTON_EX3 && Link->PressEx3 ) return true;
	if ( Z3_SHOP_BUY_BUTTON_EX4 && Link->PressEx4 ) return true;
	
}