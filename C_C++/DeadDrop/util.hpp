/*
	 https://en.wikichip.org/wiki/intel/core_i9/i9-9980hk
	 	L1 256KiB
		 	8 x 32 KiB 8 way set associative
				32 KiB is 512 lines

*/


// You may only use fgets() to pull input from stdin
// You may use any print function to stdout to print 
// out chat messages
#include <stdio.h>

// You may use memory allocators and helper functions 
// (e.g., rand()).  You may not use system().
#include <stdlib.h>

#include <inttypes.h>
#include <time.h>

#ifndef UTIL_H_
#define UTIL_H_

#define ADDR_PTR uint64_t 
#define CYCLES uint32_t

CYCLES measure_one_block_access_time(ADDR_PTR addr);

void touch_address(ADDR_PTR addr);

#endif
