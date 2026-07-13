#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

uint16_t get_bit(uint16_t x,
                 uint16_t n) {
    return (1 & (x >> n));
}

void set_bit(uint16_t * x,
             uint16_t n,
             uint16_t v) {
    uint16_t mask = 1 << n;
    if(v){
        *x |= mask;
    }else{
        *x &= ~mask;
    }
}

void lfsr_calculate(uint16_t *reg) {
    uint16_t mask = (((get_bit(*reg,0) ^ get_bit(*reg,2)) ^ get_bit(*reg,3)) ^ get_bit(*reg,5));
    *reg >>= 1;
    set_bit(reg,15,mask);
}

