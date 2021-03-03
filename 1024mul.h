#include "common.h"
#include "platform/interface.h"
#include "hw_accelerator.h"

#include <stdio.h>
#include <stdint.h>
#define MAX 32


void Mul_Big(uint32_t* x, uint32_t* y, uint32_t* z);
void Mul_Long(uint32_t* x, uint64_t y, uint32_t* z);
void Mov_Big(uint32_t* x, uint32_t* y);
void Init(uint32_t* x);
