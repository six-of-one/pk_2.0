/*
 * File: damskin.qc
 *
 * Damaged skin code, not allot to it really.
 *
 */

void(entity targ)	pk_setDamageSkin =
{
	if (targ.classname == "player" || targ.classname == "dmbot")
	{
		if (targ.health > 75)
	  {
	  	targ.skin = 0;
	  }
	  else if (targ.health > 55)
	  {
	  	targ.skin = 1;
	  }
	  else if (targ.health > 40)
	  {
	  	targ.skin = 2;
	  }
	  else if (targ.health > 25)
	  {
	  	targ.skin = 3;
	  }
	  else if (targ.health > 10)
	  {
	  	targ.skin = 4;
	  }
	  else
	  {
	  	targ.skin = 4;
	  }
	}
};

