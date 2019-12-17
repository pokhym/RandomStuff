# What's Here
This folder contains proofs and tools that are written in Maude.
Each folder will contain the code for the system in question and a README discussing the specificaiton.
If there is a paper attached to a specific algorithm it will either be cited in the README or have a pdf in the folder.

# Tools
rltool: Developed by Stephen Skirik, mirrored here due to the fact its a work in progress and future updates may render current correct proofs incorrect

# Systems
abp:
Alternating bit protocol.
This protcol models a lossy data level protocol that will always ensure in order transfer and no dropped data packets.

Color:
A distributed graph coloring algorithm.
For a set of processes in a graph configuration each with a starting color, after execution each process must have a different color than all its neighbors.

Consensus:
A simple conesnsus algorithm with two actors and an acceptor channel.
After execution where at least one actor must send a message into the acceptor channel, both actors must then contain the first message sent out on the channel.

LCR2:
A simple leader election algorithm.
After execution each node in the graph must have the same leader process.

SelfStabilizingTree:
A simple self stabilizing tree algorithm.
Given a connected graph, after execution from any state, we will always reach a state where a spanning tree will be able to be reached.