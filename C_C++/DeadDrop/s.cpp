#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

// static volatile char __attribute__ ((aligned (1024*32))) buffer[1024*32];
volatile char * Buffer = (char *) malloc(500000 * 8 * 64 * sizeof(char));
volatile char * buffer;

#define NUMSETS 64
#define NUMWAYS 8
#define CACHELINESIZE 64*64
#define CACHEENTRYSIZE 64
#define PRESSURE 5000000

/*
    pressureSets
        Inputs:
            char a: The char to be sent
            bool ack: The ack bit
            bool end: The end bit
        Outputs:
        Description:
            This pressures specific cache sets based upon
            the input char and ack/end bits.
            
*/
void pressureSets(char a, bool ack, bool end){
    int i = 0;
    int setId = 1;
    
    // printf("Pressuring set %d\n", setId);
    while(i < PRESSURE){
            for(int wayId = 0 ; wayId < NUMWAYS ; wayId++){
                if(a & 128)
                    buffer[setId * CACHEENTRYSIZE + CACHELINESIZE * wayId] = 0;
                if(a & 64)
                    buffer[(setId + 1) * CACHEENTRYSIZE + CACHELINESIZE * wayId] = 0;
                if(a & 32)
                    buffer[(setId + 2) * CACHEENTRYSIZE + CACHELINESIZE * wayId] = 0;
                if(a & 16)
                    buffer[(setId + 3) * CACHEENTRYSIZE + CACHELINESIZE * wayId] = 0;
                if(a & 8)
                    buffer[(setId + 4) * CACHEENTRYSIZE + CACHELINESIZE * wayId] = 0;
                if(a & 4)
                    buffer[(setId + 5) * CACHEENTRYSIZE + CACHELINESIZE * wayId] = 0;
                if(a & 2)
                    buffer[(setId + 6) * CACHEENTRYSIZE + CACHELINESIZE * wayId] = 0;
                if(a & 1)
                    buffer[(setId + 7) * CACHEENTRYSIZE + CACHELINESIZE * wayId] = 0;
                if(ack)
                    buffer[(setId + 8) * CACHEENTRYSIZE + CACHELINESIZE * wayId] = 0;
                if(end)
                    buffer[(setId + 9) * CACHEENTRYSIZE + CACHELINESIZE * wayId] = 0;
            }
        i++;
    }
}

/* main */
int main(){
	for(int i = 0 ; i < 100000 * 64 * 8 ; i++){
		if(((uint64_t)(Buffer + i) & 0x1ff) == 0){
			buffer = Buffer + i;
		}
	}
	if(buffer == 0){
		printf("Failed to get address with correct bottom 16 bits.\n");
		return -1;
	}
	else{
		printf("%x\n", buffer);
		//buff_addr = buff_addr - 8*64;
    }
    printf("Please type a message.\n");
    char a; // = (char) 255;
    int i = 0;
    while(true){
        char text_buf[128];
		fgets(text_buf, sizeof(text_buf), stdin);

    
        // begin sending text when ack drops to 0
        while(text_buf[i] != '\0'){
            pressureSets((char) 0, 1, 0);
            pressureSets(text_buf[i], 0, 0);
            printf("Sending: %x\n", text_buf[i]);
            pressureSets((char) 0, 0, 1);
            i++;
        }
        printf("Done.\n");

        for(int j = 0 ; j < 128 ; j++)
            text_buf[j] = 0;
        i = 0;
    }
    
    return 0;
}