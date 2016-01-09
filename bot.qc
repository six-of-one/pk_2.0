/* ::-::
 *
 * Cataboligne
 *
 * file: bot.qc
 *
 * date: Sun Apr 6
 *
 * moved various bot fn() here for adaptive code
 *
 */

// relocate from client.qc



float () FindGood =
{
	fClientNo = (fClientNo + 1);
	if (!(fActiveClients & 1))
	{
		fActiveClients = (fActiveClients | 1);
		return (1);
	}
	else
	{
		if (!(fActiveClients & WEAPON_ROCKET))
		{
			fActiveClients = (fActiveClients | 2);
			return (2);
		}
		else
		{
			if (!(fActiveClients & WEAPON_SPIKES))
			{
				fActiveClients = (fActiveClients | 4);
				return (3);
			}
			else
			{
				if (!(fActiveClients & WEAPON_BIG))
				{
					fActiveClients = (fActiveClients | 8);
					return (4);
				}
				else
				{
					if (!(fActiveClients & 16))
					{
						fActiveClients = (fActiveClients | 16);
						return(TE_LIGHTNING1);
					}
					else
					{
						if (!(fActiveClients & 32))
						{
							fActiveClients = (fActiveClients | 32);
							return (6);
						}
						else
						{
							if (!(fActiveClients & 64))
							{
								fActiveClients = (fActiveClients | 64);
								return (7);
							}
							else
							{
								if (!(fActiveClients & 128))
								{
									fActiveClients = (fActiveClients | 128);
									return (8);
								}
								else
								{
									if (!(fActiveClients & 256))
									{
										fActiveClients = (fActiveClients | 256);
										return (9);
									}
									else
									{
										if (!(fActiveClients & 512))
										{
											fActiveClients = (fActiveClients | 512);
											return (10);
										}
										else
										{
											if (!(fActiveClients & 1024))
											{
												fActiveClients = (fActiveClients | 1024);
												return (11);
											}
											else
											{
												if (!(fActiveClients & 2048))
												{
													fActiveClients = (fActiveClients | 2048);
													return(12);
												}
												else
												{
													if (!(fActiveClients & 4096))
													{
														fActiveClients = (fActiveClients | 4096);
														return (13);
													}
													else
													{
														if (!(fActiveClients & 8192))
														{
															fActiveClients = (fActiveClients | 8192);
															return(MSG_UPDATEFRAGS);
														}
														else
														{
															if (!(fActiveClients & 16384))
															{
																fActiveClients = (fActiveClients | 16384);
																return(15);
															}
															else
															{
																if (!(fActiveClients & INITLEVEL))
																{
																	fActiveClients = (fActiveClients | INITLEVEL);
																	return (16);
																}
																else
																{
																	return (-1);
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
};

void (float abba) MakeGood =
{
	local float ackbar;
	ackbar = WEAPON_SHOTGUN;
	abba = (abba - 1);
	while (abba > NAMEBOTS)
	{
		ackbar = (ackbar * 2);
		abba = (abba - 1);
	}
	fClientNo = (fClientNo - 1);
	fActiveClients = (fActiveClients - (fActiveClients & ackbar));
};

void (entity object) Update_Frags =
{
	WriteByte (MSG_ALL,MSG_UPDATEFRAGS);
	WriteByte (MSG_ALL,object.id);
	WriteShort (MSG_ALL,object.frags);
};



void (entity c) PrintClientScore =
{
	if ((c.frags > -10) && (c.frags < 0))
	{
		bprint (" ");
	}
	else
	{
		if (c.frags >= 0)
		{
			if (c.frags < 100)
			{
				bprint (" ");
			}
			if (c.frags < 10)
			{
				bprint (" ");
			}
		}
	}
};

void () DumpScore =
{
	local entity e;
	local entity sort;
	local entity walk;
	if (world.chain)
	{
		error ("DumpScore: world.chain is set");
	}
	e = find (world,classname,"player");
	sort = world;
	while (e)
	{
		if (!sort)
		{
			sort = e;
			e.chain = world;
		}
		else
		{
			if (e.frags > sort.frags)
			{
				e.chain = sort;
				sort = e;
			}
			else
			{
				walk = sort;
				do
				{
					if (!walk.chain)
					{
						e.chain = world;
						walk.chain = e;
					}
					else
					{
						if (walk.chain.frags < e.frags)
						{
							e.chain = walk.chain;
							walk.chain = e;
						}
						else
						{
							walk = walk.chain;
						}
					}
				} while (walk.chain != e);
			}
		}
		e = find (e,classname,"player");
	}
	bprint ("\n");
	while (sort)
	{
		PrintClientScore (sort);
		sort = sort.chain;
	}
	bprint ("\n");
};



float () getrandombotskin =
{
	local float botskin;
	botskin = random ();
	if (botskin <= 0.066)
	{
		return(NAMEBOTS);
	}
	if ((botskin > 0.066) && (botskin <= 0.132))
	{
		return (1);
	}
	if ((botskin > 0.132) && (botskin <= 0.198))
	{
		return (2);
	}
	if ((botskin > 0.198) && (botskin <= 0.264))
	{
		return (3);
	}
	if ((botskin > 0.264) && (botskin <= 0.330))
	{
		return (4);
	}
	if ((botskin > 0.330) && (botskin <= 0.396))
	{
		return(TE_LIGHTNING1);
	}
	if ((botskin > 0.396) && (botskin <= 0.462))
	{
		return (6);
	}
	if ((botskin > 0.462) && (botskin <= 0.528))
	{
		return (7);
	}
	if ((botskin > 0.528) && (botskin <= 0.594))
	{
		return (8);
	}
	if ((botskin > 0.594) && (botskin <= 0.660))
	{
		return (9);
	}
	if ((botskin > 0.660) && (botskin <= 0.726))
	{
		return (10);
	}
	if ((botskin > 0.726) && (botskin <= 0.792))
	{
		return (11);
	}
	if ((botskin > 0.792) && (botskin <= 0.858))
	{
		return(12);
	}
	if ((botskin > 0.858) && (botskin <= 0.924))
	{
		return (13);
	}
	if ((botskin > 0.924) && (botskin <= 1))
	{
		return(15);
	}
	else
	{
		return(15);
	}
};


void() bot_skinParms =
{

//	reaper skin code - not sure to include - requiers parm mod

	local float offset;
	local float toffset;
	local float team1;
	local float nb;
	local float nt;
	local entity e;

	if (SKINSMODE)
	{
		parm4 = ((parm4 + (self.skin * 512)) + (16384* SKINSMODE));
	}
	e = find (world,classname,"dmbot");
	offset = 1;
	toffset = 1;
	parm10 = 0;
	parm11 = 0;
	team1 = 100;
	nb = 0;
	nt = 0;
	while (e)
	{
		if (e.team == 99)
		{
			nb = (nb + 1);
			if (nb < 6)
			{
				parm10 = (parm10 + (((offset * e.skil) * 10) & (offset * 31)));
				offset = (offset * 32);
			}
		}
		else
		{
			if (team1 == 100)
			{
				team1 = e.team;
			}
			if (e.team == team1)
			{
				nt = (nt + 1);
				if (nt < 6)
				{
					parm11 = (parm11 + (((toffset * e.skil) * 10) & (toffset * 31)));
					toffset = (toffset * 32);
				}
			}
		}
		e = find (e,classname,"dmbot");
	}
};

void() bot_skinDecode =
{
	local float skinno;

	if (parm4 > 511)
	{
		SKINSMODE = ((parm4 & 49152) / 16384);
		skinno = (parm4 & 7680);
		parm4 = (parm4 & 511);
		skinChange (self,skinno);
	}
};

void() set_CarriedPath =
{
	if (self.movetarget == world)
	{
		NewCarriedPath ();
	}
	setorigin (self.movetarget,self.origin);
	self.movetarget.movetarget = world;
	self.pathtype = NEVERTARGET;
	if (!self.pather)
	{
		NUMPATHERS = (NUMPATHERS + 1);
	}
	self.pather = 1;
};

void() set_initBotLevel =
{
	local float dedflags;

  	dedflags = cvar ("temp2");
	if (dedflags & DEDICATED)
	{
		serverflags = (dedflags | INITLEVEL);
		cvar_set ("temp2","0");
	}
	if (serverflags & INITLEVEL)
	{
		initBotLevel ();
	}
};


/*
 * Cataboligne
 *
 * only print & stuffcmd to real players - frikbot code borrow - noted to protect against sz_ overflows because bots dont retrieve the messages
 *
 */

// inactive while installed with frikbot code, which was adapted to work the same & noted *bot
// TDO: adapt frikbot ishuman test
/*
void(entity client, string s)	bot_stuffcmd = #21;
void(entity client, string s)	bot_sprint = #24;
void(entity client, string s)	bot_centerprint = #73;

void(entity	client, string s) stuffcmd =
{
	if (client.classname == "dmbot") return;
//	if (client.ishuman == 1)
		bot_stuffcmd(client, s);
};

void(entity	client, string s) sprint =
{
	if (client.classname == "dmbot") return;
//	if (client.ishuman == 1)
		bot_sprint(client, s);
};
void(entity	client, string s) centerprint =
{
	if (client.classname == "dmbot") return;
//	if (client.ishuman == 1)
		bot_centerprint(client, s);
};
*/


