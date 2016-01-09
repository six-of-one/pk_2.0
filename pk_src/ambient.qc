/*
	ambient_sound

	"classname" "ambient_sound"
	"noise" "..." - file to play as sound
*/

void() ambient_sound =
{
	precache_sound (self.noise);
	ambientsound (self.origin, self.noise, 0.5, ATTN_STATIC);
};

