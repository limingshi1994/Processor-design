/*
 * asm_func.h
 *
 *  Created on: May 13, 2016
 *      Author: dbozilov
 */

#ifndef ASM_FUNC_H_
#define ASM_FUNC_H_

#include <stdint.h>

// a will be in register R0, b in R1, c in R2
// Result is stored in register r0
uint32_t add_3(uint32_t a, uint32_t b, uint32_t c);

//Adds all elements of array
uint32_t add_10(uint32_t *a, uint32_t n);

//Copies array a to array b
uint32_t arr_copy(uint32_t *a, uint32_t *b, uint32_t n);

// Function that calculates {t[i+1], t[i]} = a[0]*b[0] + m[0]*n[0]
// i is in R0, pointer to t array in R1, a array in R2, b array in R3
// pointer to m array is stored in [SP]
// pointer to n array is stored in [SP, #4] (one position above m)
void multiply(uint32_t i, uint32_t *t, uint32_t *a, uint32_t *b, uint32_t *m, uint32_t *n);


//_32mul
void _32mulAssembly(uint32_t x, uint32_t y, uint32_t* sum);

//AddCarry
void _AddAssembly(uint32_t* t, uint32_t i, uint32_t C);

//sub_cond
void _Sub_Assembly(uint32_t* u, uint32_t* n, uint32_t SIZE);

//32bit addition result C,S
void _32add(uint32_t* sum, uint32_t t);

//32bit addition 3 elements;
void _32add3(uint32_t* sum, uint32_t t, uint32_t C);

//mul+add3
void muladd3(uint32_t aj, uint32_t bi, uint32_t* sum, uint32_t tj);

//mul+add3+add
void muladd3add(uint32_t* a, uint32_t bi, uint32_t* sum, uint32_t* t, uint32_t j);

//mul+add
void muladd(uint32_t m, uint32_t nj, uint32_t* sum, uint32_t S);

//jloop
void jloop(uint32_t* a, uint32_t bi, uint32_t* sum, uint32_t* t, uint32_t m, uint32_t* n, uint32_t j);

//outer loop byteadd
void byteadd(uint32_t* t, uint32_t* sum, uint32_t C);

//inner
void inner(uint32_t* a, uint32_t bi, uint32_t* sum, uint32_t* res, uint32_t m, uint32_t* n, uint32_t j);

//forj
void forj(uint32_t* a, uint32_t bi, uint32_t* sum, uint32_t* res, uint32_t m, uint32_t* n, uint32_t j);

//muadadas
void muadadas(uint32_t* a, uint32_t* b, uint32_t* sum, uint32_t* res, uint32_t m, uint32_t* n, uint32_t i, uint32_t np0);

//muadadas+32mulassembly
uint32_t mua_32mul(uint32_t* a, uint32_t* b, uint32_t* sum, uint32_t* res, uint32_t m, uint32_t* n, uint32_t i, uint32_t np0);

//forj + byteadd
void forjba(uint32_t* a, uint32_t bi, uint32_t* sum, uint32_t* res, uint32_t m, uint32_t* n, uint32_t j);

//forij
void fori(uint32_t* a, uint32_t* b, uint32_t* sum, uint32_t* res, uint32_t m, uint32_t* n, uint32_t i, uint32_t np0);


#endif /* ASM_FUNC_H_ */
