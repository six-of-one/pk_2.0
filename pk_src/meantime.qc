/*
	meantime.qc
	Used to calculate mean times given certain means and standard deviations.

	Usage:
		self.nextthink = time + meantime(self.mean, self.stdev);

	   ie. meantime(5, 2) will give a random # between 3 and 7 with
	        and average of 5
*/

.float mean;
.float stdev;

float (float lMean, float lStDev) meantime =
{
	return lMean + crandom() * lStDev;
};
