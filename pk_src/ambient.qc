/*
QUAKED ambient_sound (0 0.5 0) (-4 -4 -4) (4 4 4)
- plays indicated sound

	"classname" "ambient_sound"
	"noise" "..." - file to play as sound
*/

void() ambient_sound =
{
	precache_sound (self.noise);
	ambientsound (self.origin, self.noise, 0.5, ATTN_STATIC);
};

