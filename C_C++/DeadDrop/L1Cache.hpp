    #ifndef L1CACHE_HPP
#define L1CACHE_HPP

#include "util.hpp"

#define SAMPLE_SIZE 120
#define TIMING_THRESHOLD 40
#define COUNTER_THRESHOLD 40
#define MESSAGE_SIZE 1

class L1Cache {
    public:
        // number of bytes in a cache line
        unsigned int lineSize;
        // number of ways per cache set
        unsigned int ways;
        // the size of each cache
        unsigned int cacheSize;
        // number of sets in a cacheSize cache
        unsigned int numSets;
        // number of cacheSize caches
        unsigned int numCaches;
        // total bytes of cache
        unsigned int totalCacheSize;
        // malloced L1 which is the size of the cache
        char * L1;
        // stores results of timings for each time we sample
        // which is the size SAMPLE_SIZE * numSets
        CYCLES * timings;
        // set timing counter, see to count which 
        unsigned int * timingSetCounter;
        // message retrieved from sender
        char * message;
        
        // Default ctor
        L1Cache();
        L1Cache(unsigned int in_lineSize, unsigned int in_ways, 
            unsigned int in_numCaches, unsigned int in_cacheSize, bool receiver, bool sender);

        // Default dtor
        ~L1Cache();

        /*
            L1Probe
                Inputs:
                Outputs:
                Description:
                    Given a sampleNumber it will measure the timing and
                    update this.timings array with the timings
        */
        void L1Probe(int sampleNumber);

        /*
            L1Prime
                Inputs:
                Outputs:
                Description:
                    Primes the cache by touching it all
        */
        void L1Prime();

        /*
            sampleTimings
                Inputs:
                Outputs:
                Description:
                    Outer call of L1Probe which touches very cache set
        */
        void sampleTimings();

        /*
            retrieveMessage
                Inputs:
                Outputs:
                Description:
                    Decodes the sample timings and tries to retrieve
                    message sent by the sender
        */
       void retrieveMessage();

       /*
            reset
                Inputs:
                Outputs:
                Description:
                    Resets all the counters used in the transmission scheme
       */
      void reset();

};

#endif // L1CACHE_HPP