
/*
	Helpful links:
		Explains the usage of %1 %2 arguments
			https://stackoverflow.com/questions/32855273/gnu-assembly-inline-what-do-1-and-0-mean
		Explains consraints in the output/input/clobbered registers
			https://gcc.gnu.org/onlinedocs/gcc/Simple-Constraints.html#Simple-Constraints
		General extended ASM guide
			https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#AssemblerTemplate
*/
#include "util.hpp"

/* Measure the time it takes to access a block with virtual address addr. */
CYCLES measure_one_block_access_time(ADDR_PTR addr)
{
	CYCLES cycles;

	asm volatile("mov %1, %%r8\n\t"
	"lfence\n\t" /* ensure the mov %1, %%r8 instr retires before rtdsc */
	"rdtsc\n\t" /* EDX:EAX holds result */
	"mov %%eax, %%edi\n\t" /* moves result into EDI */
	"mov (%%r8), %%r8\n\t"
	"lfence\n\t" /* ensures both mov finish before rtdsc */
	"rdtsc\n\t"
	"sub %%edi, %%eax\n\t" /* calculate result of time diff */
	: "=a"(cycles)	/* %0 output operands */
	: "r"(addr)		/* %1 input operands */
	: "r8", "edi");	/* clobbered registers */

	return cycles;
}

void touch_address(ADDR_PTR addr)
{
	asm volatile("movq %0, %%rax\n\t"
	"add $0, %%rax\n\t"
	"movb $0, (%%rax)\n\t"
	// "mov %0, %%r9\n\r"
	// "lfence\n\t"
	:
	: "r"(addr)
	: "rax"
	);
}


