/*
 * montgomery.c
 *
 */

#include "montgomery.h"
#include "mont_utils.h"
#include "asm_func.h"

// Calculates res = a * b * r^(-1) mod n.
// a, b, n, n_prime represent operands of size elements
// res has (size+1) elements
void montMul(uint32_t* a, uint32_t* b, uint32_t* n, uint32_t* np, uint32_t* res, uint32_t size)
{
	uint32_t W = 0xffffffff;
	uint32_t t[size+2];
	for(uint32_t ia = 0; ia<size+2; ia++)
	{
		t[ia] = 0;
	}

	uint32_t sum[2] = {0, 0};
	uint32_t tplusc[2] = {0, 0};
	for (uint8_t i = 0; i < size; i++)
	{
		//calculate t+a*b
		_32mul(a[0], b[i], sum);
		if(W - t[0] < sum[0])
		{
			sum[0] += t[0];
			sum[1] += 1;
		}
		else
		{
			sum[0] += t[0];
		}

		uint32_t S = sum[0];
		uint32_t C = sum[1];

		
		ADD(t, 1, C);
		
		_32mul(S, np[0], sum);
		uint32_t m = sum[0];
		
		_32mul(m, n[0], sum);
		if(W - S < sum[0])
		{
			sum[0] += S;
			sum[1] += 1;
		}
		else
		{
			sum[0] += S;
		}

		S = sum[0];
		C = sum[1];

		for(uint8_t j = 1; j < size; j++)
		{
			if(W - C < t[j])
			{
				tplusc[0] = t[j] + C;
				tplusc[1] = 1;
			}
			else
			{
				tplusc[0] = t[j] + C;
				tplusc[1] = 0;
			}

			_32mul(a[j], b[i], sum);
			if(W - tplusc[0] < sum[0])
			{
				sum[0] += tplusc[0];
				sum[1] += tplusc[1] + 1;
			}
			else
			{
				sum[0] += tplusc[0];
				sum[1] += tplusc[1];
			}

			S = sum[0];
			C = sum[1];

			ADD(t, j+1, C);

			_32mul(m, n[j], sum);
			if(W - S < sum[0])
			{
				sum[0] += S;
				sum[1] += 1;
			}
			else
			{
				sum[0] += S;
			}

			S = sum[0];
			C = sum[1];

			t[j-1] = S;

		}

		if(W - C < t[size])
		{
			sum[0] = t[size] + C;
			sum[1] = 1;
		}
		else
		{
			sum[0] = t[size] + C;
			sum[1] = 0;
		}

		S = sum[0];
		C = sum[1];

		t[size-1] = S;
		t[size] = t[size+1] + C;
		t[size+1] = 0;

	}

	uint32_t u[size+1];
	for(uint8_t ib = 0; ib<size+1; ib++)
		u[ib] = t[ib];

	//give n[33] value of 0 as a filler;
	n[size] = 0x00000000;
	
	//conditional subtraction;
	SUB_COND(u, n, size, res);
}









void montMulOpt(uint32_t* a, uint32_t* b, uint32_t* n, uint32_t* np, uint32_t* res, uint32_t size)
{
	//uint32_t W = 0xffffffff;
	//uint32_t t[size+2];
	memset(res, 0, 4*34);
	//uint32_t S = 0;
	//uint32_t C = 0;
	uint32_t sum[2] = {0, 0};
	uint32_t m = 0;
	uint32_t i = 0;
	uint32_t j;

	//fori(a, b, sum, res, m, n, i, np[0]);
	//uint32_t tplusc[2] = {0, 0};
	for (i = 0; i < size; i++)
	{
		//calculate t+a*b
		//_32mulAssembly(a[0], b[i], sum); //optimized
		//_32add(sum, res[0]); //optimized

//		muladd(a[0], b[i], sum, res[0], i);  //ttores//optimized
//
//		S = sum[0];//optimized
//		C = sum[1];//optimized
//
//		_AddAssembly(res, 1, C); //ttores//optimized


//		muadadas(a, b, sum, res, m, n, i, np[0]);
//
//		S = sum[0];
//
//		_32mulAssembly(S, np[0], sum);

		m = mua_32mul(a, b, sum, res, m, n, i, np[0]);

//		m = sum[0];
//
////		_32mulAssembly(m, n[0], sum); //optimized
////		_32add(sum, S);	//optimized
//
//		muladd(m, n[0], sum, S);

//		S = sum[0];
//		C = sum[1];

		//to rewrite the for loop

		forjba(a, b[i], sum, res, m, n, j);
//		forj(a, b[i], sum, res, m, n, j);
//
////		for(j = 1; j < size; j++)//all are optimized
////		{
////			inner(a, b[i], sum, res, m, n, j);
////
//////			//_32mulAssembly(a[j], b[i], sum); //optimized
//////			//_32add3( sum, t[j],C);  //optimized
//////
//////
//////			//muladd3(a[j], b[i], sum, t[j]);//optimized
//////			//S = sum[0];//optimized
//////			//C = sum[1];//optimized
//////			//_AddAssembly(t, j+1, C); //optimized
//////
//////			//?Why r4 24 ahead of stack pointer sp:r13???
//////			muladd3add(a, b[i], sum, res, j);  //ttores//optimized
//////
//////			S = sum[0];//optimized
//////			C = sum[1];//optimized
//////			//_32mulAssembly(m, n[j], sum); //optimized
//////			//_32add(sum, S); //optimized
//////
//////			muladd(m, n[j], sum, S, j);//optimized
//////
//////			S = sum[0];//optimized
//////			C = sum[1];//optimized
//////
//////			res[j-1] = S;  //ttores//optimized
////
////		}
//
//		byteadd(res, sum, sum[1]);  //ttores
//
////		S = sum[0];
////		C = sum[1];

//		res[size-1] = sum[0];	//ttores
//		res[size] = res[size+1] + sum[1];	//ttores
//		res[size+1] = 0;	//ttores

	}

	//uint32_t u[size+1];
	//for(uint8_t ib = 0; ib<size+1; ib++)
	//	u[ib] = t[ib];
	/*
	for(uint8_t ib = 0; ib < size + 1; ib ++)
	{
		res[ib] = t[ib];
	}
	*///ttores
	
	//give n[33] value of 0 as a filler;
	n[size] = 0;


	//conditional subtraction;
	//SUB_COND(u, n, size, res);
	_Sub_Assembly(res, n, size);
}











