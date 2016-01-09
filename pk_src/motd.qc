/* 
 *
 * file: motd.qc
 *
 */
void() extraWeaponsDisplay;


// ConnectMessage - display a message on connect.
void() connectmessage =
{
	local string Line3;

	Line3 = "Version 1.11\n";

if (self.classname != "dmbot" && (!FRIKBOT ||self.ishuman))
{
	// The welcome message
	if (self.msgcount == 1)
	{
	  // Anti bots messges.
	  if (DONTALLOWBOTS == 1)
	  {
	    sprint(self,"No Bots\n");
	    sprint(self,"No Bots Please\n");
	    sprint(self,"Humans Only Please\n");
	  }

	  centerprint3(self, "W\n", "\nT\n", Line3);

	}
	else if (self.msgcount == 2)
	{
	  centerprint3(self, "We\n", "\nT\n", Line3);
	}
	else if (self.msgcount == 3)
	{
	  centerprint3(self, "Wel\n", "\nTe\n", Line3);
	}
	else if (self.msgcount == 4)
	{
	  centerprint3(self, "Welc\n", "\nTe\n", Line3);
	}
	else if (self.msgcount == 5)
	{
	  centerprint3(self, "Welco\n", "\nTea\n", Line3);
	}
	else if (self.msgcount == 5)
	{
	  centerprint3(self, "Welcom\n", "\nTea\n", Line3);
	}
	else if (self.msgcount == 6)
	{
	  centerprint3(self, "Welcome\n", "\nTeam\n", Line3);
	}
	else if (self.msgcount == 7)
	{
	  centerprint3(self, "Welcome \n", "\nTeam\n", Line3);
	}
	else if (self.msgcount == 8)
	{
	  centerprint3(self, "Welcome t\n", "\nTeam E\n", Line3);
	}
	else if (self.msgcount == 9)
	{
	  centerprint3(self, "Welcome to\n", "\nTeam E\n", Line3);
	}
	else if (self.msgcount == 10)
	{
	  centerprint3(self, "Welcome to \n", "\nTeam Ev\n", Line3);
	}
	else if (self.msgcount == 11)
	{
	  centerprint3(self, "Welcome to Ð\n", "\nTeam Ev\n", Line3);
	}
	else if (self.msgcount == 12)
	{
	  centerprint3(self, "Welcome to Ða\n", "\nTeam Evo\n", Line3);
	}
	else if (self.msgcount == 13)
	{
	  centerprint3(self, "Welcome to Ðai\n", "\nTeam Evo\n", Line3);
	}
	else if (self.msgcount == 14)
	{
	  centerprint3(self, "Welcome to Ðain\n", "\nTeam Evol\n", Line3);
	}
	else if (self.msgcount == 15)
	{
	  centerprint3(self, "Welcome to ÐainË\n", "\nTeam Evol\n", Line3);
	}
	else if (self.msgcount == 16)
	{
	  centerprint3(self, "Welcome to ÐainËe\n", "\nTeam Evolv\n", Line3);
	}
	else if (self.msgcount == 17)
	{
	  centerprint3(self, "Welcome to ÐainËee\n", "\nTeam Evolv\n", Line3);
	}
	else if (self.msgcount == 18)
	{
	  centerprint3(self, "Welcome to ÐainËeep\n", "\nTeam Evolve\n", Line3);
	}
	else if (self.msgcount == 19)
	{
	  centerprint3(self, "Welcome to ÐainËeep!\n", "\nTeam Evolve\n", Line3);
	}
	else if (self.msgcount <= 20)
	{
	  centerprint3(self, "Welcome to ÐainËeep!\n", "\nTeam Evolve\n", Line3);
	}
}

	self.msgcount = self.msgcount + 1;
};




void() updateStatusDisplay =
{
	if (self.msgcount <= MOTDTIME)
	{
	  connectmessage();
	  return;
	}

	if (self.messagetimeout > time)
	{
	  return;
	}

	if (inHubMap)
	if (self.hubstartupmessage > time)
	{
	  if (self.revotemsg)
	    centerprint(self, "Vote Cancelled.\n\nYou must recast your vote");
	  else
	    centerprint(self, "To cast your vote, enter the \nteleporter for the level you \nwish to play. Once all players have \nvoted, the winning level will begin.\n\nPress ÆÉÒÅ To Remove This Message");
	  self.messagetimeout = time + 1;
	}
	
	if (self.laststattime > time)
	{
		return;
	}

//	self.laststattime = time + 10;

	if (inHubMap)
	{
		self.laststattime = time + 10;
	  
		// display the HubMap data...
		hub_control_status();
//		self.aflag = time + 2;
	}
	else
	{
		self.laststattime = time + 10;

	  if (self.pk_items & PK_IT_EXTRADISP)
	  {
			extraWeaponsDisplay();
	  }
	}
};



void() extraWeaponsDisplay =
{
	// print the current inventory items out.
	local	float		timelimit;
	local	float		fraglimit;

	timelimit = cvar("timelimit") * 60;
	fraglimit = cvar("fraglimit");

	msg_entity = self;
	WriteByte(MSG_ONE, SVC_CENTERPRINT);

	if (fraglimit)
	{
	  local entity pl;
	  local float maxfrag;

	  pl = find(world, classname, "player");
	  maxfrag = 0;
	  while (pl != world)
	  {
	    if (pl.disconnectPlayer == 0)
	    {
	      if (pl.frags > maxfrag)
	      {
	        maxfrag = pl.frags;
	      }
	    }

	    pl = find(pl, classname, "player");
	  }

	  // '\n\n\n\n\n\n\n\n\n\nFrag Count: '
	  WriteB3(MSG_ONE, 657930);
	  WriteB3(MSG_ONE, 657930);
	  WriteB3(MSG_ONE, 657930);
	  WriteB3(MSG_ONE, 7489034);
	  WriteB3(MSG_ONE, 2123617);
	  WriteB3(MSG_ONE, 7696195);
	  WriteB3(MSG_ONE, 3830894);
	  WriteB3(MSG_ONE, 32);

	  WriteBFloat(MSG_ONE, maxfrag);

	  // '/'
	  WriteB3(MSG_ONE, 2109216);

	  WriteBFloat(MSG_ONE, fraglimit);
	}
	else
	{
	  // '\n\n\n\n\n\n\n\n\n\n                 '
	  WriteB3(MSG_ONE, 657930);
	  WriteB3(MSG_ONE, 657930);
	  WriteB3(MSG_ONE, 657930);
	  WriteB3(MSG_ONE, 2105354);
	  WriteB3(MSG_ONE, 2105376);
	  WriteB3(MSG_ONE, 2105376);
	  WriteB3(MSG_ONE, 2105376);
	  WriteB3(MSG_ONE, 2105376);
	  WriteB3(MSG_ONE, 2105376);
	}

	if (timelimit)
	{
	  local float timemins, timedef;

	  timemins = 0;
	  if (timelimit > time)
	  {
	    timedef = (timelimit - time);
	    timemins = timedef / 60;
	    timemins = floor(timemins);
	    timedef = (timelimit - time) - (timemins * 60);
	  }
	  else
	  {
	    timedef = 0;
	  }

	  // '    Time Left:'
	  WriteB3(MSG_ONE, 2105376);
	  WriteB3(MSG_ONE, 6902816);
	  WriteB3(MSG_ONE, 2123117);
	  WriteB3(MSG_ONE, 6710604);
	  WriteB3(MSG_ONE, 14964);

	  if (timemins < 10)
	  {
	    // ' 0'
	    WriteB3(MSG_ONE, 12320);
	  }
	  else
	  {
	    // ' '
	    WriteB3(MSG_ONE, 32);
	  }

	  WriteBFloat(MSG_ONE, timemins);

	  if (timedef < 10)
	  {
	    // ':0'
	    WriteB3(MSG_ONE, 12346);
	  }
	  else
	  {
	    // ':'
	    WriteB3(MSG_ONE, 58);
	  }

	  WriteBFloat(MSG_ONE, timedef);
	}
	else
	{
	  // '                     '
	  WriteB3(MSG_ONE, 2105376);
	  WriteB3(MSG_ONE, 2105376);
	  WriteB3(MSG_ONE, 2105376);
	  WriteB3(MSG_ONE, 2105376);
	  WriteB3(MSG_ONE, 2105376);
	  WriteB3(MSG_ONE, 2105376);
	  WriteB3(MSG_ONE, 2105376);
	}

	WriteByte(MSG_ONE, 0);
};





// functions to create centreprint network packets
void(float to, float f) WriteB3	=
{
	local float o;

	o = f & 255;
	if (!o)
		return;

	WriteByte(to, o);

	o = (f / 256) & 255;
	if (!o)
		return;

	WriteByte(to, o);

	o = (f / 65536) & 255;
	if (!o)
		return;

	WriteByte(to, o);
};


void(float to, float f) WriteBDigit =
{
	if (f < 1)
	{
		// '0'
		WriteByte(to, 48);
	}
	else if (f < 2)
	{
		// '1'
		WriteByte(to, 49);
	}
	else if (f < 3)
	{
		// '2'
		WriteByte(to, 50);
	}
	else if (f < 4)
	{
		// '3'
		WriteByte(to, 51);
	}
	else if (f < 5)
	{
		// '4'
		WriteByte(to, 52);
	}
	else if (f < 6)
	{
		// '5'
		WriteByte(to, 53);
	}
	else if (f < 7)
	{
		// '6'
		WriteByte(to, 54);
	}
	else if (f < 8)
	{
		// '7'
		WriteByte(to, 55);
	}
	else if (f < 9)
	{
		// '8'
		WriteByte(to, 56);
	}
	else
	{
		// '9'
		WriteByte(to, 57);
	}
};


void(float to, float f) intWriteBFloat =
{
	local float p, d;

	if (f <= 0)
		return;

	p = floor(f / 10);

	// mod(f, 10);
	d = f - (p * 10);

	intWriteBFloat(to, p);
	WriteBDigit(to, d);
};

void(float to, float f) WriteBFloat =
{
	local float p, d;

	f = floor(f);
	p = floor(f / 10);

	// mod(f, 10);
	d = f - (p * 10);

	intWriteBFloat(to, p);
	WriteBDigit(to, d);
};


