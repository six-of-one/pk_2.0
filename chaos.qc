/*
		+---------------------------------------+
		|  Chaos code                           | SEC-HEAD
		+---------------------------------------+
*/

// implement chaos fn for pk


// fn(cnt_ent) - count all such ents on level, make chain if head ent provided

// hent - head entity for chain struct
// match - find on this field
// srch - search for this

// RETURN - count of ents matching search parm

float(entity hent, string match, string srch) cnt_ent =
{
	local float rc;
	local entity sr, ch;

	sr = world;
	if (match == "classname") sr = find (world, classname, srch);
//	else if (match == "class_select") sr = find (world, class_select, srch);
//	else if (match == "quakeset") sr = find (world, quakeset, srch);
	else if (match == "netname") sr = find (world, netname, srch);
	else if (match == "map") sr = find (world, map, srch);
//	else if (match == "scode") sr = find (world, scode, srch);
	ch = hent;

	rc = 0;
	while (sr)
		{
			rc = rc + 1;
			if (hent)
			{
				ch.chain = sr;
				ch = sr;
			}
			if (match == "classname") sr = find (sr, classname, srch);
//			else if (match == "class_select") sr = find (sr, class_select, srch);
//			else if (match == "quakeset") sr = find (sr, quakeset, srch);
			else if (match == "netname") sr = find (sr, netname, srch);
			else if (match == "map") sr = find (sr, map, srch);
//			else if (match == "scode") sr = find (sr, scode, srch);
		}
	if (hent) ch.chain = world; // remove other potential chains left around - not even sure if this can happen
	return(rc);
}

