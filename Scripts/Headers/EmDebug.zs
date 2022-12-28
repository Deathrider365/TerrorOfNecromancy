#option HEADER_GUARD on
#include "std.zh"
namespace Emily::Debug
{
	typedef const int DEFINE;
	DEFINE DB_FONT = FONT_Z3SMALL;
	void drawint(int val, int slot = 0, int tf = TF_NORMAL, int fg = 0x0C, int bg = 0x08)
	{
		char32 buf[16];
		sprintf(buf, "%d", val);
		drawstr(buf,slot,tf,bg,fg);
	}
	
	void drawstr(char32 str, int slot = 0, int tf = TF_NORMAL, int fg = 0x0C, int bg = 0x08)
	{
		int x = (tf==TF_RIGHT?256:(tf==TF_CENTERED?128:0));
		Screen->DrawString(7, x, slot*Text->FontHeight(DB_FONT), DB_FONT, fg, bg, tf, str, OP_OPAQUE);
	}
}
