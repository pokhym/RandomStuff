/*
    PROTOCOL SPEC
    
    We use a total of 10 sets
    sets 0 - 7 represent the byte we are trying to set
    set 8 represents the ACK bit
        This should be more aptly named the BEGIN bit.  We
        begin a transmission when ACK goes high.  When ACK
        goes from HIGH to LOW we then begin transmitting data on
        sets 0 - 7
    set 9 represents the END bit
        We use END to represent when the transmission of our byte.
        When END goes from LOW to HIGH we have finished transmission.
        When END goes from HIGH to LOW we reach an idle state where
        we need to wait for ACK to begin transmission again.
*/
#include <stdio.h>
#include <inttypes.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <iostream>
#include <vector>

#define NUMSETS 64
#define NUMWAYS 8
#define NUMPRIMES 100
#define CACHELINESIZE 64 * 64
#define CACHEENTRYSIZE 64
#define NUMSAMPLES 100
#define TIMINGTHRESHOLD 250
#define SAMPLETHRESHOLD 20

#define DIFFTHRESHOLD 2

#define COUNTERTHRESHOLD 15

#define TEXTBUFSIZE 128

volatile char * Buffer = (char *) malloc(500000 * 8 * 64 * sizeof(char)); // buffer
volatile char * buffer; // calculated base address

uint32_t samples[NUMSAMPLES * NUMSETS]; // stores our measured samples
uint32_t results[NUMSETS]; // not used
uint32_t counters[NUMSETS]; // used to store the number of "hits" on the cache
uint32_t ackSet = 0; // the set that represents the ACK bit
bool ackFound = false; // have we found the ack set yet?
uint32_t byteSetBegin = 0; // stores the beginnning of the data set
uint32_t endSet = 0; // stores the end set id

char text[TEXTBUFSIZE]; // global variable storing the sent message
int index; // used to index and store a value in the text buffer

char letter = '\0'; // temp variable storing the letter we have calculated
char prevletter = '\0'; // not used
char temp = '\0'; // not used

int setDiff[NUMSETS]; // used to store the difference between iterations of counters
uint32_t setPrev[NUMSETS]; // used to calc the difference of setDiff

float sleepconst = 0.2f; // ??? why lol.

// below are booleans used to represent what stage of computation we are on
volatile bool beginCurr = false;
volatile bool transCurr = false;
volatile bool endCurr = false;
volatile bool print = false;
volatile bool nodup = false;

/*
    rdtsc
        Inputs:
        Outputs:
        Description:
            This function calculates the amount of time required to
            toucha cache line
*/
uint32_t rdtsc(){
	uint32_t time;
	asm volatile(
        "lfence\n\t"
		"rdtsc\n\t"
		: "=a" (time)
		:
		: "edx" 
	);
	return time;
}
/*
    prime
        Inputs:
        Outputs:
        Description:
            This function fills the cache with the receiver buffer array
*/
void prime(){
    for(int setId = 0 ; setId < NUMSETS ; setId++){
        for(int wayId = 0 ; wayId < NUMWAYS ; wayId++){
            *(buffer + setId * CACHEENTRYSIZE + CACHELINESIZE * wayId) = 0;
        }
    }
}
/*
    probe
        Inputs:
        Outputs:
        Description:
            This funciton probes the cache and tries measure the amount
            of time required to touch each cache line NUMSAMPLE times
*/
void probe(){
    uint32_t before;
    uint32_t after;
    uint32_t res;
    for(int sampleId = 0 ; sampleId < NUMSAMPLES ; sampleId ++){
        //prime();
        //sleep(0.2);
        for(int setId = 0 ; setId < NUMSETS ; setId++){
            // rdtsc
            before = rdtsc();
            for(int wayId = 0 ; wayId < NUMWAYS ; wayId++){
                buffer[
                        setId * CACHEENTRYSIZE + CACHELINESIZE * wayId
                    ] = 0;
            }
            // rdtsc
            after = rdtsc();

            samples[sampleId * NUMSETS + setId] += (after - before);
        }
    }
}
/*
    averageSamples
        Inputs:
        Outputs:
        Description:
            This function takes the samples generated in probe()
            and averages them and stores the number of times we have
            a "hit" in counters.
*/
void averageSamples(){   

    for(int setId = 0 ; setId < NUMSETS ; setId++){
        uint32_t counter = 0;
        for(int sampleId = 0 ; sampleId < NUMSAMPLES ; sampleId++){
            if(samples[sampleId * NUMSETS + setId] > TIMINGTHRESHOLD)
                counter += 1;
        }
        if(counter > (SAMPLETHRESHOLD)){
            results[setId] = 1;
            counters[setId] += 1;
        }
    }
}
/*
    parseASCII
        Inputs:
        Outputs:
        Description:
            This function calculats the ASCII value being sent by oring
            a 1 into a temporary value and storing it in the global letter value
*/
void parseASCII(){
    //printf("Parsing\n");
    temp = 0;
    for(int i = 0 ; i < 8 ; i++){
        if(setDiff[byteSetBegin + i] > COUNTERTHRESHOLD){
            // text_buf[text_buf_index] |= 1 << 7 - i;
            temp |= 1 << 7 - i;
        }
    }
    letter = temp;

    std::cout << "Found char: " << letter << std::endl;
}
/*
    detectBit
        Inputs: count (not used)
        Outputs:
        Description:
            This function does the heavy lifting in determining when our
            sender is begining a transmission, transmitting data, or
            ending a transmission
*/
void detectBit(int count){
    // If we are in the transmit stage we sum the all counts together so that
    // the bits that are actually most important are largest
    if(transCurr){
        for(int i = 0;i < NUMSETS;i++){
                setDiff[i] += counters[i] - setPrev[i];
        }
    }
    // otherwise we are not transmitting and we check the DIFFTHRESHOLD normally
    else{
        for(int i = 0;i < NUMSETS;i++){
                setDiff[i] = counters[i] - setPrev[i];
        }
    }
    // not yet initialized ack bit
    if(ackFound == false){
        for(int i = 0;i < NUMSETS;i++){
            if(counters[i] > COUNTERTHRESHOLD){
                // beginCurr = true;
                ackFound = true;
                ackSet = i;
                ackSet = 10;
                printf("ACK SET NUM: %d\n", ackSet);
                //printf("DIFF ACK SET: %d\n", setDiff[i]);
                byteSetBegin = (ackSet - 8) % 64;
                endSet = (ackSet + 1) % 64;
                break;
            }
        }
    }
    // we have discovered the ACK location, END location, and BITS locations
    else{
        // we have sensed an initialization but have yet end it
        if(beginCurr == false && setDiff[ackSet] > DIFFTHRESHOLD && setDiff[endSet] < DIFFTHRESHOLD && transCurr == false && endCurr == false){
            std::cout << "initialize" << std::endl;
            nodup = false;
        }
        // initialization has ended
        else if(beginCurr == false && setDiff[ackSet] < DIFFTHRESHOLD && setDiff[endSet] < DIFFTHRESHOLD && transCurr == false && endCurr == false){
            std::cout << "end initialize" << std::endl;
            beginCurr = true;
        }
        // transmission begins
        else if(beginCurr == true && setDiff[ackSet] < DIFFTHRESHOLD && setDiff[endSet] < DIFFTHRESHOLD && transCurr == false && endCurr == false){
            beginCurr = true;
            // std::cout << "begin trans" << std::endl;
            beginCurr = false;
            transCurr = true;
            for(int i = 0;i < NUMSETS;i++){
                counters[i] = 0;
                setDiff[i] = 0;
                setPrev[i] = 0;
            }
            
        }
        // transmitting
        else if(transCurr == true && setDiff[ackSet] < DIFFTHRESHOLD && setDiff[endSet] < DIFFTHRESHOLD && beginCurr == false && endCurr == false){
            // std::cout << "transmitting" << std::endl;
        }
        // we have finished transmitting and we should parse the ASCII value sent
        else if(transCurr == true && setDiff[endSet] > DIFFTHRESHOLD && setDiff[ackSet] < DIFFTHRESHOLD &&  beginCurr == false && endCurr == false){
            parseASCII();
            for(int i = 0;i < NUMSETS;i++){
                counters[i] = 0;
                setDiff[i] = 0;
                setPrev[i] = 0;
            }

            transCurr = false;
        }
        // begin the end condition
        else if(endCurr == false && setDiff[endSet] > DIFFTHRESHOLD && transCurr == false && beginCurr == false){
            // std::cout << "ending" << std::endl;
            endCurr = true;
        }
        // we have ended our transmission save it in the global text array
        else if(endCurr == true && setDiff[endSet] < DIFFTHRESHOLD && transCurr == false && beginCurr == false){
            // std::cout<< "ended" << std::endl;
            // std::cout << "";
            sleep(sleepconst);
            endCurr = false;

            // std::cout << (int) letter << std::endl;

            // if(text[index-1] != letter){
                text[index] = letter;
                index++;
            // }

            print = '\n' == letter;

            for(int i = 0;i < NUMSETS;i++){
                counters[i] = 0;
                setDiff[i] = 0;
                setPrev[i] = 0;
            }
            return;
        }
        // update setPrev in order calculate setDiff
        for(int i = 0;i < NUMSETS;i++){
            setPrev[i] = counters[i];
        }
    }

}
/*
    run
        Inputs:
        Outputs:
        Description:
            This is the wrapper function for the actual computation
*/
void run(){
    int count = 1;
    int j = 0;
    bool listening = true;

        while(listening){
            // prime
            prime();
            // probe
            probe();

            // average times
            averageSamples();
            // turn samples into data and parse data
            if(j > 150){
                detectBit(count);
                j = 0;
                count++;
            }

            if(print)
                listening = false;

            // print timings
            // for(int i = 0 ; i < NUMSETS ; i++){
            //     printf("%d: %d\t", i, counters[i]);
            // }
            // printf("\n\n");

            for(int i = 0 ; i < NUMSAMPLES * NUMSETS ; i++){
                samples[i] = 0;
            }
            for(int i = 0 ; i < NUMSETS ; i++){
                results[i] = 0;
                //counters[i] = 0;
            }

            j++;
        }
        print = false;
        
        // print result
        printf("Message Received: ");
        for(int i = 0 ; i < TEXTBUFSIZE ; i += 2)
            printf("%c", text[i]);
        printf("\n");
        return ;
}
/*
    main
*/
int main(){

    // Determine the base address of our buffer to use to clash with the sender
    for(int i = 0 ; i < 100000 * 64 * 8 ; i++){
		if(((uint64_t)(Buffer + i) & 0x1ff) == 0){
			buffer = Buffer + i;
		}
	}
	if(buffer == 0){
		return -1;
	}
	else{
    }

    // ackSet = 10;
    ackFound = false;

    // std::cout << "Welcome to the DeadDrop Communicator." << std::endl;
    while(true){
        for(int i = 0 ; i < NUMSAMPLES * NUMSETS ; i++){
            samples[i] = 0;
        }
        for(int i = 0 ; i < NUMSETS ; i++){
            results[i] = 0;
            counters[i] = 0;
            setDiff[i] = 0;
            setPrev[i] = 0;
        }

        for(int i = 0 ; i < TEXTBUFSIZE ; i++){
            text[i] = 0;
        }
        index = 0;

        letter = '\0';
        prevletter = '\0';
        temp = '\0';

        beginCurr = false;
        transCurr = false;
        endCurr = false;
        print = false;
        ackFound = false;

        printf("Please press enter.\n");

        char text_buf[2];
        fgets(text_buf, sizeof(text_buf), stdin);

        printf("Receiver now listening.\n");

        run();
    }

    return 0;
}