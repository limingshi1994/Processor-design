/*
 * mont_util.h
 *
 *  Created on: Oct 10, 2020
 *      Author: r0822879
 */

#ifndef SRC_MONT_UTILS_H_
#define SRC_MONT_UTILS_H_

#include <stdint.h>

void ADD(uint32_t* t, uint8_t i, uint32_t C);
void SUB_COND(uint32_t* u, uint32_t* n, uint32_t SIZE, uint32_t* dum);
void _32mul(uint32_t x, uint32_t y, uint32_t* sum);

#endif /* SRC_MONT_UTILS_H_ */
