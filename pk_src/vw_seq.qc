/* ::-::
 *
 * Cataboligne
 *
 * file: vw_seq.qc
 *
 * date: 4.4.11
 *
 */


// only code ported back to pk 2.0
// animate harpoon gun rope point

void vw_harpoon_pnt(float v_frm) =
{
// zero control vars

	vv_o_000 = v0;
	vv_a_000 = v0;
	vv_x_000 = v0;

	if (v_frm < 0 || v_frm > 20)
	{
		bprint("___harp pnt vw - out of current bounds:  ");
		bprint(ftos(v_frm));
		bprint("\n");
		return;
	}

// animate harpoon rope end (gun)

	if (v_frm < 8)
	{
		if (v_frm < 4)
		{
			if (v_frm == 0)
			{
				vv_o_000 = ' 3.6  18.1  12.7';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
			if (v_frm == 1)
			{
				vv_o_000 = ' 7.8  17.3  12.1';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
			if (v_frm == 2)
			{
				vv_o_000 = '15.3  12.0  15.3';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
			if (v_frm == 3)
			{
				vv_o_000 = '13.6   8.2  19.2';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
		}
		else
		{
			if (v_frm == 4)
			{
				vv_o_000 = '11.1  14.8  11.9';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
			if (v_frm == 5)
			{
				vv_o_000 = ' 6.7  18.0  11.5';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}

			if (v_frm == 6) // Cataboligne - 4.4.11 - averaging rope origin in stand to calm rope "flutter"
			{
				vv_o_000 = '16.7  14.1   8.6';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
			if (v_frm == 7)
			{
				vv_o_000 = '16.7  14.1   8.6';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
		}
	}
	else
	{
		if (v_frm < 17)
		{
			if (v_frm == 8)
			{
				vv_o_000 = '16.7  14.1   8.6';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
			if (v_frm == 9)
			{
				vv_o_000 = '16.7  14.1   8.6';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
			if (v_frm == 10)
			{
				vv_o_000 = '16.7  14.1   8.6';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
		}
		else
		{
			if (v_frm == 17)
			{
				vv_o_000 = '20.0  -7.7  11.3';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
			if (v_frm == 18)
			{
				vv_o_000 = '16.8  -8.8  11.3';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
			if (v_frm == 19)
			{
				vv_o_000 = '20.0  -7.7  11.3';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
			if (v_frm == 20)
			{
				vv_o_000 = '16.8  -8.8  11.3';
				vv_a_000 = ' 0.0   0.0   0.0';
				vv_x_000 = ' 0.0   0.0   0.0';
			}
		}
	}

	if (vv_o_000 == v0)
	{
		bprint("___harp pnt vw - msy not be animated:  ");
		bprint(ftos(v_frm));
		bprint("\n");
		return;
	}

};
