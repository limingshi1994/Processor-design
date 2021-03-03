/*
 * mp_arith.c
 *
 */

#include <stdint.h>

// Calculates res = a + b.
// a and b represent large integers stored in uint32_t arrays
// a and b are arrays of size elements, res has size+1 elements
void mp_add(uint32_t *a, uint32_t *b, uint32_t *res, uint32_t size)
{
	uint32_t c = 0;
	uint32_t W = 0xffffffff;
	for(int32_t i = 0; i < size; i++)
	{
		if((W - a[i]) < b[i])
		{
			res[i] = (a[i] + b[i] + c) % W;
			c = 1;
		}
		else
		{
			res[i] = (a[i] + b[i] + c);
			c = 0;
		}
	}
	res[32] = c;
}

// Calculates res = a - b.
// a and b represent large integers stored in uint32_t arrays
// a, b and res are arrays of size elements
void mp_sub(uint32_t *a, uint32_t *b, uint32_t *res, uint32_t size)
{
	//set carry number out of the loop;
	int32_t c = 0;
	//set the count limit of 8-digit hexadecimal number;
	uint32_t W = 0xffffffff;
	for(int32_t i = 0; i < size; i++)
	{
		//change the value of the first operand forhand;
		a[i] += c;
		//enter the loop;
		if(a[i] < b[i])
		{
			//like 13-4 = 9, since unsigned integer, in decimal, this would be
			//10-4+3, like 10 exceeds the limit of decimal which is 0~9, we change it 
			//to 9-4+3+1, in hexadecimal it would be 0xffffffff-a+b+1
			res[i] = W - b[i] + a[i] + 1;
			c = -1;
		}
		else
		{
			res[i] = a[i] - b[i];
			c = 0;
		}
	}
}

// Calculates res = (a + b) mod N.
// a and b represent operands, N is the modulus. They are large integers stored in uint32_t arrays of size elements
void mod_add(uint32_t *a, uint32_t *b, uint32_t *N, uint32_t *res, uint32_t size)
{
	//do multiprecision addition first, a+b;
	uint32_t add_res[33];
	mp_add(a, b, add_res, size);
	//xil_printf("%x ///////////////////////", add_res);
	if(add_res[32] == 0x00000001)
	{
		//addition result array's size is one element longer than size of a,b,N;
		uint32_t res_size = size + 1;
		//do subtraction to mp_add result and N, store t to res;
		N[32] = 0;
		mp_sub(add_res, N, res, res_size);
	}
	else
		res = add_res;
}

// Calculates res = (a - b) mod N.
// a and b represent operands, N is the modulus. They are large integers stored in uint32_t arrays of size elements
void mod_sub(uint32_t *a, uint32_t *b, uint32_t *N, uint32_t *res, uint32_t size)
{
	//since a, b < N, and according to modular arithmetic properties,
	//thus (a-b) mod N == a-b when a>b, n+a-b when a<b;
	//so compare a[31] and b[31] first, if equal, compare 30th, so on so forth;
	for(uint8_t i=size-1; i>=0; i--)
	{
		if(a[i] > b[i])
		{
			mp_sub(a, b, res, size);
			break;
		}
		else if(a[i] < b[i])
		{
			//declare dummy result for this step;
			uint32_t sub_res[33];
			mp_sub(a, b, sub_res, size);
			mp_add(N, sub_res, res, size);
			break;
		}
	}
}

