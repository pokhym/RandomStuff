# DeadDrop
This folder contains an implementation of an L1 Cache side channel via PRIME+PROBE.

# Files
L1Cache.h/cpp: Unused

r.cpp: Contains the receiver code

s.cpp: Contains the sender code

util.h/cpp: Unused

# BUILD
        make -f Makefile_r
        make -f Makefile_s

# RUN
On two different terminals run the two different following commands.
Receiver and sender need to run on two different threads on the same core therefore we use taskset.

        taskset -c 2 ./r
        taskset -c 3 ./s

# HOW TO USE
Run the reciever (r) first.
Then run the sender (s)
Receiver (r) upon boot will prompt the user to press enter.
After pressing enter it will wait for the sender to send input.
After running the sender you and initializing the receiver by pressing enter.
Type a message into the console (<64 characters) and press enter to send.

# SAMPLE OUTPUT
RECEIVER

        78602000
        Please type a message.
        a
        Sending: 61
        Sending: a
        Done.
        aa
        Sending: 61
        Sending: 61
        Sending: a
        Done.
        hello there my friend
        Sending: 68
        Sending: 65
        Sending: 6c
        Sending: 6c
        Sending: 6f
        Sending: 20
        Sending: 74
        Sending: 68
        Sending: 65
        Sending: 72
        Sending: 65
        Sending: 20
        Sending: 6d
        Sending: 79
        Sending: 20
        Sending: 66
        Sending: 72
        Sending: 69
        Sending: 65
        Sending: 6e
        Sending: 64
        Sending: a
        Done.

RECEIVER

        Please press enter.

        Receiver now listening.
        ACK SET NUM: 10
        ending
        ended
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: a
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: 

        ending
        ended
        Message Received: a
        Please press enter.

        Receiver now listening.
        ACK SET NUM: 10
        ending
        ended
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: a
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: a
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: 

        ending
        ended
        Message Received: aa
        Please press enter.

        Receiver now listening.
        ACK SET NUM: 10
        ending
        ended
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: h
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: e
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: l
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: l
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: o
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        Found char:  
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: t
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: h
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: e
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: r
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: e
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        Found char:  
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: m
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: y
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        Found char:  
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: f
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: r
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: i
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: e
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: n
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: d
        ending
        ended
        ending
        ended
        initialize
        initialize
        initialize
        initialize
        initialize
        end initialize
        begin trans
        transmitting
        transmitting
        transmitting
        transmitting
        Found char: 

        ending
        ended
        Message Received: hello there my friend
