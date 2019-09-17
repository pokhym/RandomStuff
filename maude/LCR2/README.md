# LCR2
This is the specification of the LCR algorithm in HW1 question 2 and contains the proofs for 2 invariants.

This is a leader election algorithm in a unidirectional ring. Here is the informal description of the protocol:
Each process sends its identifier to its successor around the ring. When a process receives an
incoming identifier, it compares that identifier to its own. If the incoming identifier is greater than
its own, it keeps passing the identifier; if it is less than its own, it discards the incoming identifier;
if it is equal to its own the process declares itself as the leader.

# Files
		lcr2.maude: Specification and two examples of valid input to the system
		alwaysLargestLeaderProof.maude: Proof the leader will always be the largest UID
		alwaysLeaderProof.maude: Proof a leader will always be found (termination)

# Usage
1. Please download Maude and rltool from the following links

    	rltool: http://maude.cs.illinois.edu/tools/rltool/
    	Maude: http://maude.cs.illinois.edu/

2. Extract Maude wherever you wish and also extract rltool within the maude folder
3. Edit $PATH$ to include your maude folder

		export PATH=$PATH:<path to maude folder>
4. To run the example inputs and proofs

		maude.linux64 lcr2.maude
		maude.linux64 alwaysLargestLeaderProof.maude
		maude.linux64 alwaysLeaderProof.maude

# Understanding the Maude specification
A Maude "class" or module always begins with "mod" and ends with endm.
To import a module we use the syntax "is protecting \<MODULE NAME\>.
Every line of code must also be terminated with a period.

		mod MODULE-NAME is protecting SOMETHING .
		...
		endm

All "function" declarations begin with "op".
In the example below we declare a constructor of type state which takes multiple inputs denoted by the underscore.
After declaring what format it should take we place a : and then the sorts (types) of the input.
On the right of the arrow shows what sort the output should be of.
[ctor] means that this is a constructor and requires "no function body".

	op { send: _ | target: _ | status: _ | ring: _ } : Nat Nat Status Map{Nat,Nat} -> State [ctor] .

Below is an example of an op that requires an implementation.
	
	op uniqueMap(_,_,_) : Map{Nat,Nat} Set{Nat} Nat -> Pred . --- Checks if a map is unique

	var N : Nat .
	var R : Map{Nat,Nat} .
	var SS : Set{Nat} .

	eq uniqueMap(R, SS, N) =
		if N == mapSize(R) then
			tt
		else if R[N] inn SS == tt then
			ff
		else
			uniqueMap(R, union(R[N], SS), N + 1)
		fi
		fi .

Finaly we have rewrite rules which can represent a concurrent system.
There are two types of rewrite rules.
Unconditional and conditional.
Unconditional rules are rules that can be taken whenever the LHS is of the correct format.
Conditional rules are rules that can be taken if a condition is satisfied.

	rl [name_rl] : LHS => RHS .
	crl [name_crl] : LHS => RHS
		if condition .

Finally, in the last thing to discuss in the specification is the command search.
A search command searches the state space given an initial state and a final state.
The final state can be parametrized so that you can search for state which fufills a condition.
These can take the form as shown below.
Where we assume there is a sort State declared in the module

		search LHS =>* S:State . --- Takes 0 or more steps until termination
		search LHS =>1 S:State . --- Takes 1 step
		search LHS =>+ S:State . --- Takes 1 or more steps until termination
		search LHS => * S:State
			such that cond . --- Takes 0 or mores steps until termination where S:State 
							 --- satisfies the condition cond

Below is an example from LCR2.maude.

		--- Map: 0 |-> 3, 1 |-> 5, 2 |-> 2
		search { send: 1 | target: 0 | status: (ff, Null) | ring: insert(0, 3, insert(1, 5, 
			insert(2, 2, empty))) } =>* S:State 
			such that leaderFoundInState(S:State) == tt and 
				maxStateMap(S:State) == getLeader(S:State) .

# Understanding rltool and its Proofs
	--- load our specification
	load lcr2.maude
	--- load the reachability logic tool
	load ~/maude/rltool/rltool.maude

	--- select the module to perform a proof on
	(select LCR2 .)
	--- select the tool
	(use tool varsat for validity on LCR2 .)
	--- define our terminating set
	(def-term-set ([ send: sendIdx:Nat | target: targetIdx:Nat | status: (tt,leader:Nat) | ring: R:Map{Nat,Nat} ]) | true /\ 
		(uniqueMap(R:Map{Nat,Nat}, empty, 0)) = (tt)
	.)
	--- Add our invariants to prove here
	--- indexes are always in valid range
	(add-goal inBounds : 
		(< send: sendIdx:Nat | target: targetIdx:Nat | status: S:Status | ring: R:Map{Nat,Nat} >) | 
			(validSendTargetIDX(R:Map{Nat,Nat}, sendIdx:Nat, targetIdx:Nat)) = (tt)
		=> 
		(< send: sendIdx':Nat | target: targetIdx':Nat | status: S':Status | ring: R':Map{Nat,Nat} >) | 
			(validSendTargetIDX(R':Map{Nat,Nat}, sendIdx':Nat, targetIdx':Nat)) = (tt)
	.)
	--- when we terminate we must have a unique map and a leader found
	--- recall we use [] to denote a state that has terminated and <> to denote a state that is running
	(add-goal termination : 
		(< send: sendIdx:Nat | target: targetIdx:Nat | status: S:Status | ring: R:Map{Nat,Nat} >) | 
			(validSendTargetIDX(R:Map{Nat,Nat}, sendIdx:Nat, targetIdx:Nat)) = (tt)
		=>
		([ send: sendIdx':Nat | target: targetIdx':Nat | status: (tt,leader:Nat) | ring: R':Map{Nat,Nat} ]) | true /\ 
		(uniqueMap(R':Map{Nat,Nat}, empty, 0)) = (tt)
	.)
	--- begin the proof
	(start-proof .)

	--- automatically step
	(auto .)

	--- exit prover
	quit