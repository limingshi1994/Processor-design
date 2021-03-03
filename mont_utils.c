#include "mont_utils.h"
//ADD;
void ADD(uint32_t* t, uint8_t i, uint32_t C)
{
	uint32_t W = 0xffffffff;
	uint32_t sum[2] = {0, 0};
	while(C != 0)
	{
		if(W - C < t[i])
		{
			sum[0] = t[i] + C;
			sum[1] = 1;
		}
		else
		{
			sum[0] = t[i] + C;
			sum[1] = 0;
		}
		C = sum[1];
		t[i] = sum[0];
		i += 1;
	}
}


//SUB_COND;
void SUB_COND(uint32_t* u, uint32_t* n, uint32_t SIZE, uint32_t* dum)
{
	uint32_t B = 0;
	uint32_t sub = 0;
	uint32_t t[SIZE+1];
	for(uint32_t j = 0; j<=SIZE; j++)
		t[j] = 0;
	for (uint8_t i = 0; i <= SIZE; i++)
	{
		sub = u[i] - n[i] - B;
		if (u[i] >= n[i] + B)
			B = 0;
		else
			B = 1;
		t[i] = sub;
	}
	if(B == 0)
	{
		for(uint8_t ix = 0; ix < SIZE; ix++)
			dum[ix] = t[ix];
	}
	else
	{
		for(uint8_t iy = 0; iy < SIZE; iy++)
			dum[iy] = u[iy];
	}
}

//32bit multiplication;
void _32mul(uint32_t x, uint32_t y, uint32_t* sum)
{
	//divide x y into two halves;
	uint32_t x_lo = (uint16_t)x;
	uint32_t x_hi = x >> 16;
	uint32_t y_lo = (uint16_t)y;
	uint32_t y_hi = y >> 16;

	//multiplication's equivalent four parts;
	uint32_t xyhi  = x_hi * y_hi;
	uint32_t xymid = x_hi * y_lo;
	uint32_t yxmid = x_lo * y_hi;
	uint32_t xylo  = x_lo * y_lo;

	//carry bits;
	uint32_t carry = ((uint32_t)(uint16_t)xymid +
					  (uint32_t)(uint16_t)yxmid +
					  (xylo >> 16) ) >> 16;

	//Higher bits;
	uint32_t higher = xyhi + (xymid >> 16) + (yxmid >> 16)
					  + carry;

	//lower bits;
	uint32_t lower = xylo + (xymid << 16) + (yxmid << 16);

	//result;
	sum[0] = lower;
	sum[1] = higher;
}
