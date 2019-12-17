#include "L1Cache.hpp"

L1Cache::L1Cache() {
    lineSize = 64;
    ways = 8;
    numCaches = 2;
    cacheSize = 1024 * 32;
    totalCacheSize = cacheSize * numCaches;
    numSets = (cacheSize / lineSize) / ways;
    L1 = (char *) malloc(totalCacheSize * sizeof(char));
    for(int i = 0 ; i < totalCacheSize ; i ++)
        L1[i] = 0;
    timings = (CYCLES *) malloc(numCaches * numSets * ways * SAMPLE_SIZE * sizeof(CYCLES));
    for(int i = 0 ; i < numCaches * numSets * SAMPLE_SIZE; i ++)
        timings[i] = 0;
    message = (char *) malloc(numSets * numCaches * sizeof(char));
    for(int i = 0 ; i < numSets * numCaches ; i++) {
        message[i] = 0;
    }
    timingSetCounter = (unsigned int *) malloc(numSets * numCaches * sizeof(unsigned int *));
    for(int i =0 ; i < numSets * numCaches ; i++) {
        timingSetCounter[i] = 0;
    }
}

L1Cache::L1Cache(unsigned int in_lineSize, unsigned int in_ways, 
    unsigned int in_numCaches, unsigned int in_cacheSize, 
    bool receiver, bool sender) {
    
    lineSize = in_lineSize;
    ways = in_ways;
    numCaches = in_numCaches;
    cacheSize = in_cacheSize;
    totalCacheSize = cacheSize * numCaches;

    if(receiver && !sender)
        L1 = (char *) malloc(totalCacheSize);
    else if(!receiver && sender)
        L1 = (char *) malloc(cacheSize);
    else
        L1 = (char * ) malloc(totalCacheSize);
}

L1Cache::~L1Cache() {
    delete []L1;
    delete []timings;
    delete []message;
}

// TODO: I am not sure if uint64_t pointer is correct
// TODO: Is the array indexing correct?
void L1Cache::L1Probe(int sampleNumber) {
    for(int setId = 0 ; setId < numSets * numCaches ; setId++){
        for(int wayId =  0 ; wayId < ways; wayId++){
            /*
                [sample0={set0,way0 set0,way1 ... set127,way7}, SAMPLESIZE={set0,way0 ... set127,way7}]
                
                offset to a specifc sample + offset to a specific set + index into a specific set
                    - offset to a specific sample = numWays * numSets * numCaches * sampleId
                    - offset to a specific set = numWays * setId
                    - index into a specific set = wayId
            */
            timings[ways * numSets * sampleNumber + 
                    ways * setId +
                    wayId] =
                /*
                    L1 + offset to a specific set + index into a specific set
                    offset to a specific set = numWays * setId
                    index into a specific set = wayId
                */
                measure_one_block_access_time(
                    (uint64_t) L1 + ways * setId * lineSize + wayId * lineSize
                );

            // printf("%u %u\n", ways * numSets * numCaches * sampleNumber + 
            //         ways * setId +
            //         wayId,  ways * setId * lineSize + wayId * lineSize);
        }
    }
}

void L1Cache::L1Prime() {
    for(int setId = 0 ; setId < numSets * numCaches ; setId++){
        for(int wayId =  0 ; wayId < ways; wayId++){
            /*
                L1 + offset to a specific set + index into a specific set
                offset to a specific set = numWays * setId
                index into a specific set = wayId
            */
            measure_one_block_access_time(
                (uint64_t) L1 + ways * setId * lineSize + wayId * lineSize
            );

            // printf("%u %u\n", ways * numSets * numCaches * sampleNumber + 
            //         ways * setId +
            //         wayId,  ways * setId * lineSize + wayId * lineSize);
        }
    }
}

void L1Cache::sampleTimings() {
    for(int i = 0; i < SAMPLE_SIZE; i++) {
        L1Probe(i);
    }
}

// TODO: This is probably wrong
void L1Cache::retrieveMessage() {
    // loop through all the sampls and if a specific sample's set
    // has an access time greater than threshold we increment a counter
    // for the specific set
    // for(int sampleId = 0 ; sampleId < SAMPLE_SIZE ; sampleId++) {
    //     for(int setId = 0 ; setId < numSets * numCaches ; setId ++) {
    //         for(int wayId = 0 ; wayId < ways ; wayId++) {
    //             if(timings[ways * numSets * sampleId + ways * setId + wayId] > TIMING_THRESHOLD)
    //                 timingSetCounter[setId]++;
    //         }
    //     }
    // }
    for(int cacheId = 0 ; cacheId < numCaches ; cacheId++){
        for(int sampleId = 0 ; sampleId < SAMPLE_SIZE ; sampleId++) {
            for(int setId = 0 ; setId < numSets ; setId++) {
                if(timings[cacheId * SAMPLE_SIZE * numSets + sampleId * numSets + setId] > TIMING_THRESHOLD)
                    timingSetCounter[setId]++;
            }
        }
    }

    // if a specific set is > threshold that is one
    for(int i = 0 ; i < numSets * numCaches; i++) {
        // printf("%d %d\n", timingSetCounter[i], i);
        if(timingSetCounter[i] > COUNTER_THRESHOLD) {
            message[i] = 1;
        }
        else{
            message[i] = 0;
        }
    }   
}

void L1Cache::reset() {
    for(int i = 0 ; i < numSets * numCaches ; i++) {
        message[i] = 0;
        timingSetCounter[i] = 0;
    }
    for(int i = 0 ; i < numCaches * numSets * ways * SAMPLE_SIZE ; i++) {
        timings[i] = 0;
    }
}