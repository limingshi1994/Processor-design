#include "common.h"
#include "platform/interface.h"
#include "hw_accelerator.h"

#include <stdio.h>
#include <stdint.h>
#define MAX 32

void Mul_Big(uint32_t* x, uint32_t* y, uint32_t* z)
{
	uint32_t t[100];
	uint64_t sum, mul = 0, carry = 0;
	uint32_t i, j;
	if (y[0] == 1)
		Mul_Long(x, y[1], z);
	else
	{
		Init(t);
		t[0] = x[0] + y[0] - 1;
		for (i = 1; i <= t[0]; i++)
		{
			sum = carry;
			carry = 0;
			for (j = 1; j <= y[0]; j++)
			{
				if ((i - j) >= 0 && (i - j) < x[0])
				{
					mul = x[i - j + 1];
					mul = (uint64_t)mul * y[j];
					carry = carry + mul / 0x100000000;
					mul = mul & 0xffffffff;
					sum = sum + mul;
				}
			}
			carry = carry + sum / 0x100000000;
			t[i] = (uint32_t)sum;
		}
		if (carry != 0)
		{
			t[0]++;
			t[t[0]] = (uint32_t)carry;
		}
		i = t[0];
		while (t[i] == 0 && i > 1)
		{
			t[0]--;
			i--;
		} 
		Mov_Big(t, z);
	}
}

void Mul_Long(uint32_t* x, uint64_t y, uint32_t* z)
{
	uint32_t t[34];
	uint64_t mul;
	uint32_t carry = 0;
	uint32_t i;
	Init(t);
	Mov_Big(x, t);
	for (i = 1; i <= x[0]; i++)
	{
		mul = x[i];
		mul = mul * y + carry;
		t[i] = (uint32_t)mul;
		carry = (uint32_t)(mul >> 32);
	}
	if (carry != 0)
	{
		t[0]++;
		t[t[0]] = carry;
	}
	i = t[0];
	while (t[i] == 0 && i > 1) 
	{
		t[0]--;
		i--;
	}
	Mov_Big(t, z);
}


void Mov_Big(uint32_t* x, uint32_t* y)
{
	int i;
	for (i = 0; i <= x[0]; i++)
	{
		y[i] = x[i];
	}
	if (x[0] < MAX)
		for (i = x[0] + 1; i < MAX; i++)
		{
			y[i] = 0;
		}
}

void Init(uint32_t* x)
{
	uint32_t i;
	for (i = 1; i < MAX; i++)
		x[i] = 0;
	x[0] = 1;
}
