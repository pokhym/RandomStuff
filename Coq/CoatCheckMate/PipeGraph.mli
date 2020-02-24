val negb : bool -> bool

type 'a option =
| Some of 'a
| None

type ('a, 'b) prod =
| Pair of 'a * 'b

val fst : ('a1, 'a2) prod -> 'a1

val snd : ('a1, 'a2) prod -> 'a2

val length : 'a1 list -> int

val app : 'a1 list -> 'a1 list -> 'a1 list

val pred : int -> int

val add : int -> int -> int

val mul : int -> int -> int

val max : int -> int -> int

val min : int -> int -> int

val eqb : bool -> bool -> bool

module Nat :
 sig
  val eqb : int -> int -> bool
 end

type positive =
| XI of positive
| XO of positive
| XH

type n =
| N0
| Npos of positive

module Pos :
 sig
  val succ : positive -> positive

  val add : positive -> positive -> positive

  val add_carry : positive -> positive -> positive

  val mul : positive -> positive -> positive

  val iter_op : ('a1 -> 'a1 -> 'a1) -> positive -> 'a1 -> 'a1

  val to_nat : positive -> int

  val of_succ_nat : int -> positive
 end

module N :
 sig
  val add : n -> n -> n

  val mul : n -> n -> n

  val to_nat : n -> int

  val of_nat : int -> n
 end

val rev_append : 'a1 list -> 'a1 list -> 'a1 list

val rev' : 'a1 list -> 'a1 list

val fold_left : ('a1 -> 'a2 -> 'a1) -> 'a2 list -> 'a1 -> 'a1

val existsb : ('a1 -> bool) -> 'a1 list -> bool

val filter : ('a1 -> bool) -> 'a1 list -> 'a1 list

val find : ('a1 -> bool) -> 'a1 list -> 'a1 option

val zero : char

val one : char

val shift : bool -> char -> char

val ascii_of_pos : positive -> char

val ascii_of_N : n -> char

val ascii_of_nat : int -> char

val append : string -> string -> string

val tab : string

val newline : string

val quote : string

val stringOfNat : int -> string

val stringOf : string list -> string

val beq_string : string -> string -> bool

val string_prefix : string -> string -> bool

val substr : int -> string -> string

val find_string : string -> string list -> bool

val printFlag : int -> bool

val printf : 'a1 -> string -> 'a1

val printfFlush : 'a1 -> string -> 'a1

val printlnFlush : 'a1 -> string list -> 'a1

val println : 'a1 -> string list -> 'a1

val comment : 'a1 -> string list -> 'a1

val commentFlush : 'a1 -> string list -> 'a1

val warning : 'a1 -> string list -> 'a1

val macroExpansionDepth : int

val timeForStatusUpdate : int -> bool

val blt_nat : int -> int -> bool

val rangeHelper : int -> int list -> int list

val range : int -> int list

val mapHelper : ('a1 -> 'a2) -> 'a1 list -> 'a2 list -> 'a2 list

val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list

val app_rev : 'a1 list -> 'a1 list -> 'a1 list

val app_tail : 'a1 list -> 'a1 list -> 'a1 list

val removeb_helper : ('a1 -> bool) -> 'a1 list -> 'a1 list -> 'a1 list

val removeb : ('a1 -> bool) -> 'a1 list -> 'a1 list

type instID = int

type threadID = int

type intraInstructionID = int

type virtualTag = int

val beq_vtag : int -> int -> bool

type physicalTag =
| PTag of int
| PTETag of virtualTag
| APICTag of string * int

val beq_ptag : physicalTag -> physicalTag -> bool

type index = int

type virtualAddress = { vtag : virtualTag; vindex : index }

val beq_vaddr : virtualAddress -> virtualAddress -> bool

type physicalAddress = { ptag : physicalTag; pindex : index }

val beq_paddr : physicalAddress -> physicalAddress -> bool

type pTEStatus = { accessed : bool; dirty : bool }

val accessed : pTEStatus -> bool

val dirty : pTEStatus -> bool

val beq_pte_status : pTEStatus -> pTEStatus -> bool

type accessedStatus =
| Accessed
| NotAccessed
| AccessedDontCare

val stringOfAccessedStatus : accessedStatus -> string

type dirtyStatus =
| Dirty
| NotDirty
| DirtyDontCare

val stringOfDirtyStatus : dirtyStatus -> string

val match_pte_status : pTEStatus -> accessedStatus -> dirtyStatus -> bool

val stringOfPTEStatus : pTEStatus -> string

type data =
| UnknownData
| NormalData of int
| PageTableEntry of virtualTag * physicalTag * pTEStatus
| OtherData of string * int

val beq_pte : data -> virtualTag -> physicalTag -> accessedStatus -> dirtyStatus -> bool

val beq_data : data -> data -> bool

type boundaryCondition = (physicalAddress, data) prod

type memoryAccess =
| Read of string list * virtualAddress * physicalAddress * data
| Write of string list * virtualAddress * physicalAddress * data
| Fence of string list
| FenceVA of string list * virtualAddress

type microop = { globalID : instID; coreID : int; threadID0 : threadID; intraInstructionID0 : intraInstructionID;
                 access : memoryAccess }

val globalID : microop -> instID

val coreID : microop -> int

val threadID0 : microop -> threadID

val intraInstructionID0 : microop -> intraInstructionID

val access : microop -> memoryAccess

val getAccessType : microop -> string list

val getVirtualAddress : microop -> virtualAddress option

val getVirtualTag : microop -> virtualTag option

val getIndex : microop -> index option

val getPhysicalAddress : microop -> physicalAddress option

val getPhysicalTag : microop -> physicalTag option

val getData : microop -> data option

val sameVirtualAddress : microop -> microop -> bool

val sameVirtualTag : microop -> microop -> bool

val samePhysicalAddress : microop -> microop -> bool

val samePhysicalTag : microop -> microop -> bool

val sameIndex : microop -> microop -> bool

val sameData : microop -> microop -> bool

val beq_uop : microop -> microop -> bool

type thread = microop list

type program = thread list

val vAPASameTagAndIndex : virtualAddress -> physicalAddress -> bool

type location = (int, int) prod

type graphNode = (microop, location) prod

type graphEdge = (((graphNode, graphNode) prod, string) prod, string) prod

val beq_node : graphNode -> graphNode -> bool

val beq_edge : graphEdge -> graphEdge -> bool

val knownAddresses : (int, string) prod list

val addressString : (int, string) prod list -> int -> string

val graphvizStringOfVirtualAddress : virtualAddress -> string

val graphvizStringOfPhysicalTag : physicalTag -> string

val graphvizStringOfPhysicalAddress : physicalAddress -> string

val graphvizStringOfData : data -> string

val graphvizStringOfMemoryAccess : string -> memoryAccess -> string

val graphvizShortStringOfGraphNode : graphNode -> string

val stringOfGraphEdge : graphEdge -> string

val shortStringOfGraphNode : graphNode -> string

val shortStringOfGraphEdge : graphEdge -> string

val reverseEdge : graphEdge -> graphEdge

type adjacencyList = (graphNode, ((graphNode, string) prod, string) prod list) prod list

val adjacencyListAddEdgeHelper :
  graphNode -> graphNode -> string -> string -> adjacencyList -> adjacencyList -> (bool, adjacencyList) prod

val adjacencyListAddEdge : adjacencyList -> graphEdge -> (bool, adjacencyList) prod

val adjacencyListFromEdges : graphEdge list -> adjacencyList

val nodesFromEdgesHelper : graphEdge list -> graphNode list -> graphNode list

val nodesFromEdges : graphEdge list -> graphNode list

val edgesFromAdjacencyList : adjacencyList -> graphEdge list

val nodesFromAdjacencyList : adjacencyList -> graphNode list

val adjacencyListFindHelper :
  ((graphNode, string) prod, string) prod list -> bool -> (string, string) prod option -> (string, string) prod
  option

val adjacencyListFind : adjacencyList -> graphNode -> graphNode -> (string, string) prod option

val adjacencyListAddEdgeCheckDups : adjacencyList -> graphEdge -> adjacencyList

val adjacencyListGetDsts : adjacencyList -> graphNode -> ((graphNode, string) prod, string) prod list

val adjacencyListRemoveHelper :
  graphNode -> ((graphNode, string) prod, string) prod list -> graphNode -> (graphNode, ((graphNode, string) prod,
  string) prod list) prod

val adjacencyListRemove : adjacencyList -> graphNode -> graphNode -> adjacencyList

val adjacencyListRemoveSource : adjacencyList -> graphNode -> adjacencyList

type topsortResult =
| ReverseTotalOrder of graphNode list
| Cyclic of graphEdge list
| Abort of int

val sourceNodes : graphEdge list -> graphNode list -> graphNode list

val topsortHelperProcessNode :
  graphNode list -> graphNode list -> graphNode -> adjacencyList -> (adjacencyList, graphNode list) prod

val topsortHelper : int -> graphNode list -> graphNode list -> adjacencyList -> adjacencyList -> topsortResult

val topsort : graphEdge list -> topsortResult

val transitiveClosureHelper2 :
  adjacencyList -> adjacencyList -> ((graphNode, string) prod, string) prod list -> graphNode list -> adjacencyList

val transitiveClosureHelper : adjacencyList -> adjacencyList -> graphNode -> adjacencyList

type transitiveClosureResult =
| TC of adjacencyList
| TCError of graphEdge list

val transitiveClosure : graphEdge list -> transitiveClosureResult

val cycleFromNodeHelper :
  adjacencyList -> graphNode -> graphNode -> ((graphNode, string) prod, string) prod list -> graphEdge list -> int
  -> graphEdge list option

val cycleFromNode : graphEdge list -> graphNode -> graphEdge list option

val findCycleHelper : graphEdge list -> graphNode list -> graphEdge list option

val findCycle : graphEdge list -> graphEdge list option

type architectureLevelEdge = ((int, int) prod, string) prod

val graphvizPrettyStringOfMicroop : microop -> string

val microopsFromNodesHelper : graphNode list -> microop list -> microop list

val microopsFromNodes : graphNode list -> microop list

val blt_uop : graphEdge list -> microop -> microop -> bool

val sortMicroopsInsertionSortHelper : graphEdge list -> microop list -> microop list -> microop -> microop list

val addDummyUarchEdgesForPOHelper : architectureLevelEdge list -> microop list -> graphEdge list -> graphEdge list

val addDummyUarchEdgesForPO : architectureLevelEdge list -> microop list -> graphEdge list

val sortMicroopsInsertionSort : graphEdge list -> microop list -> microop -> microop list

val sortMicroops : microop list -> architectureLevelEdge list -> microop list

val microopXPositionsHelper : microop list -> (microop, int) prod list -> int -> int -> (microop, int) prod list

val microopXPositions : microop list -> architectureLevelEdge list -> (microop, int) prod list

val graphvizNodeXPosition : (microop, int) prod list -> microop -> string

val graphvizStringOfGraphNode : string -> (microop, int) prod list -> graphNode -> string

val graphvizColorForEdgeLabel : string -> string

val graphvizTextLabel : string -> string

val graphvizStringOfGraphEdge : graphEdge list -> string -> graphEdge -> string

val graphvizEdges : graphEdge list -> graphEdge list -> string list

val setNthToMin : int option list -> int -> int -> int option list

val graphvizPipelineLabelXPositionHelper :
  graphNode list -> (microop, int) prod list -> int option list -> int option list

val graphvizPipelineLabelXPositions : (microop, int) prod list -> graphNode list -> int option list

val graphvizLocationLabelStringsHelper2 : int -> int -> string list -> string list -> string list

val graphvizLocationLabelStringsHelper : string list list -> int option list -> string list -> string list

val graphvizLocationLabels : string list list -> (microop, int) prod list -> graphNode list -> string list

val graphvizNodeLabelString : (microop, int) prod list -> microop -> string

val graphvizNodeLabels : (microop, int) prod list -> graphNode list -> string list

val graphvizNodes : string list list -> graphNode list -> architectureLevelEdge list -> string list

val isNotTCEdge : graphEdge -> bool

val graphvizCompressedGraph :
  string -> string list list -> graphEdge list -> graphEdge list -> architectureLevelEdge list -> string list

type stringOrInt =
| SoISum of stringOrInt * stringOrInt
| SoIString of string
| SoIInt of int
| SoICoreID of string

val stringOfSoI : stringOrInt -> string

type predGraphNode = (string, (stringOrInt, stringOrInt) prod) prod

type predGraphEdge = (((predGraphNode, predGraphNode) prod, string) prod, string) prod

val stringOfPredGraphNode : predGraphNode -> string

val stringOfPredGraphEdge : predGraphEdge -> string

type fOLPredicateType =
| PredDebug of string
| PredHasDependency of string * string * string
| PredIsRead of string
| PredIsWrite of string
| PredIsAPICAccess of string * string
| PredIsFence of string
| PredAccessType of string * string
| PredSameUop of string * string
| PredSameNode of string * string
| PredSameCore of stringOrInt * stringOrInt
| PredSmallerGlobalID of string * string
| PredSameGlobalID of string * string
| PredSameIntraInstID of string * string
| PredSameThread of stringOrInt * stringOrInt
| PredOnCore of stringOrInt * string
| PredOnThread of stringOrInt * string
| PredSameVirtualAddress of string * string
| PredSamePhysicalAddress of string * string
| PredSameVirtualTag of string * string
| PredSamePhysicalTag of string * string
| PredSameIndex of string * string
| PredKnownData of string
| PredSameData of string * string
| PredDataFromPAInitial of string
| PredDataFromPAFinal of string
| PredSamePAasPTEforVA of string * string
| PredDataIsCorrectTranslation of accessedStatus * dirtyStatus * string * string
| PredTranslationMatchesInitialState of accessedStatus * dirtyStatus * string
| PredProgramOrder of string * string
| PredConsec of string * string
| PredAddEdges of predGraphEdge list
| PredEdgesExist of predGraphEdge list
| PredNodesExist of predGraphNode list
| PredTrue
| PredFalse
| PredHasID of int * int * int * int * string
| PredHasGlobalID of int * string

val stringOfPredicate : bool -> fOLPredicateType -> string

val fOLLookupPredicate_IIIIS : string -> int -> int -> int -> int -> string -> fOLPredicateType

val fOLLookupPredicate_SSS : string -> string -> string -> string -> fOLPredicateType

val fOLLookupPredicate_IS : string -> int -> string -> fOLPredicateType

val fOLLookupPredicate_ADSS : string -> accessedStatus -> dirtyStatus -> string -> string -> fOLPredicateType

val fOLLookupPredicate_ADS : string -> accessedStatus -> dirtyStatus -> string -> fOLPredicateType

val fOLLookupPredicate_SS : string -> string -> string -> fOLPredicateType

val fOLLookupPredicate_S : string -> string -> fOLPredicateType

val fOLLookupPredicate_E : string -> predGraphEdge -> fOLPredicateType

val fOLLookupPredicate_N : string -> predGraphNode -> fOLPredicateType

val fOLLookupPredicate_lE : string -> predGraphEdge list -> fOLPredicateType

val fOLLookupPredicate_lN : string -> predGraphNode list -> fOLPredicateType

val beq_edge0 : graphEdge -> graphEdge -> bool

type scenarioTree =
| ScenarioName of string * scenarioTree
| ScenarioAnd of scenarioTree * scenarioTree
| ScenarioOr of scenarioTree * scenarioTree
| ScenarioEdgeLeaf of graphEdge list
| ScenarioNodeLeaf of graphNode list
| ScenarioNotNodeLeaf of graphNode list
| ScenarioTrue
| ScenarioFalse

val flipEdgesHelper : graphEdge list -> graphEdge list -> graphEdge list

val flipEdges : graphEdge list -> graphEdge list

val printLabelsHelper : string list -> string -> string

val printLabels : string list option -> string

val printEdgeLabels : graphEdge list -> string

val printNodeLabels : graphNode list -> string

val scenarioTreeEdgeCountGraphHelper : bool -> scenarioTree -> int -> string list option -> (int, int) prod

val scenarioTreeEdgeCountGraphHelper1 : scenarioTree -> string -> scenarioTree

val scenarioTreeEdgeCountGraph : int -> scenarioTree -> string -> scenarioTree

val reducesToTrue : scenarioTree -> bool

val reducesToFalse : scenarioTree -> bool

val simplifyScenarioTree : scenarioTree -> scenarioTree

val guaranteedEdges : scenarioTree -> ((graphNode list, graphNode list) prod, graphEdge list) prod

val findBranchingEdges : scenarioTree -> graphEdge list list option

type fOLTerm =
| IntTerm of string * int
| StageNameTerm of string * int
| MicroopTerm of string * microop
| NodeTerm of string * graphNode
| EdgeTerm of string * graphEdge
| MacroArgTerm of string * stringOrInt

val fOLTermName : fOLTerm -> string

val addTerm : fOLTerm list -> fOLTerm -> fOLTerm list

val stringOfFOLTermValue : fOLTerm -> string

val stringOfFOLTerm : fOLTerm -> string

val getFOLTermHelper : string -> fOLTerm list -> int -> fOLTerm option

val getFOLTerm : string -> fOLTerm list -> fOLTerm option

type fOLState = { stateNodes : graphNode list; stateNotNodes : graphNode list; stateEdgeNodes : graphNode list;
                  stateEdges : graphEdge list; stateUops : microop list; stateInitial : boundaryCondition list;
                  stateFinal : boundaryCondition list; stateArchEdges : architectureLevelEdge list }

val stateNodes : fOLState -> graphNode list

val stateNotNodes : fOLState -> graphNode list

val stateEdgeNodes : fOLState -> graphNode list

val stateEdges : fOLState -> graphEdge list

val stateUops : fOLState -> microop list

val stateInitial : fOLState -> boundaryCondition list

val stateFinal : fOLState -> boundaryCondition list

val stateArchEdges : fOLState -> architectureLevelEdge list

val updateFOLState : bool -> fOLState -> graphEdge list -> fOLState

val fOLStateReplaceEdges : fOLState -> graphNode list -> graphNode list -> graphEdge list -> fOLState

val getSoIFOLTerm : stringOrInt -> fOLTerm list -> fOLTerm option

val foldInstantiateGraphEdge :
  fOLState -> fOLTerm list -> graphEdge list option -> predGraphEdge -> graphEdge list option

val foldInstantiateGraphNode :
  fOLState -> fOLTerm list -> graphNode list option -> predGraphNode -> graphNode list option

val getInitialCondition : boundaryCondition list -> physicalAddress -> data

val getFinalCondition : boundaryCondition list -> physicalAddress -> data option

val hasDependency : architectureLevelEdge list -> int -> int -> string -> bool

val evaluatePredicate :
  string list list -> fOLPredicateType -> fOLTerm list -> fOLState -> (graphNode list, graphEdge list) prod option

type fOLQuantifier = fOLState -> fOLTerm list -> (string, fOLTerm list) prod

val microopQuantifier : string -> fOLQuantifier

val numCores : microop list -> int -> int

val coreQuantifier : string -> fOLQuantifier

val numThreads : microop list -> int -> int

val threadQuantifier : string -> fOLQuantifier

type fOLFormula =
| FOLName of string * fOLFormula
| FOLExpandMacro of string * stringOrInt list
| FOLPredicate of fOLPredicateType
| FOLNot of fOLFormula
| FOLOr of fOLFormula * fOLFormula
| FOLAnd of fOLFormula * fOLFormula
| FOLForAll of fOLQuantifier * fOLFormula
| FOLExists of fOLQuantifier * fOLFormula
| FOLLet of fOLTerm * fOLFormula

val printGraphvizStringOfFOLFormulaHelper : int -> fOLFormula -> int

val printGraphvizStringOfFOLFormula : fOLFormula -> fOLFormula

val fOLImplies : fOLFormula -> fOLFormula -> fOLFormula

val fOLIff : fOLFormula -> fOLFormula -> fOLFormula

val foldFlipEdge : scenarioTree -> graphEdge -> scenarioTree

val foldFlipNode : scenarioTree -> graphNode -> scenarioTree

val eliminateQuantifiersHelper : bool -> string list list -> fOLState -> fOLFormula -> fOLTerm list -> scenarioTree

val setIntersectionIsEmpty : graphEdge list -> graphEdge list -> bool

val setIntersectionHelper : graphEdge list -> graphEdge list -> graphEdge list -> graphEdge list

val setIntersection : graphEdge list -> graphEdge list -> graphEdge list

val sDFindEdge : graphEdge -> graphEdge list -> graphEdge option

val setDifferenceHelper : graphEdge list -> graphEdge list -> graphEdge list -> graphEdge list

val setDifference : graphEdge list -> graphEdge list -> graphEdge list

val nodeSetIntersectionIsEmpty : graphNode list -> graphNode list -> bool

val nodeSetIntersectionHelper : graphNode list -> graphNode list -> graphNode list -> graphNode list

val nodeSetIntersection : graphNode list -> graphNode list -> graphNode list

val nodeSetDifferenceHelper : graphNode list -> graphNode list -> graphNode list -> graphNode list

val nodeSetDifference : graphNode list -> graphNode list -> graphNode list

val scenarioTreeKeepIfFalse : fOLState -> scenarioTree -> scenarioTree option

val eliminateQuantifiers : string list list -> fOLState -> fOLFormula -> fOLTerm list -> scenarioTree

val reevaluateScenarioTree : fOLState -> scenarioTree -> scenarioTree

val scenarioTreeAssignLeaves : fOLState -> scenarioTree -> scenarioTree

type fOLMacro = ((string, string list) prod, fOLFormula) prod

val findMacro : string -> fOLMacro list -> (string list, fOLFormula) prod option

val argsZipHelper : 'a1 list -> 'a2 list -> ('a1, 'a2) prod list -> ('a1, 'a2) prod list

val argsZip : 'a1 list -> 'a2 list -> ('a1, 'a2) prod list

val fOLExpandMacros : int -> fOLMacro list -> fOLFormula -> fOLFormula

val checkFinalState : string list list -> architectureLevelEdge list -> bool -> fOLState -> bool

val scenarioTreeCheckNodes : fOLState -> scenarioTree -> scenarioTree

val reevaluateScenarioTreeIterator :
  int -> string list list -> architectureLevelEdge list -> fOLState -> scenarioTree -> (fOLState, scenarioTree) prod

val stringOfCase : graphEdge list -> string

val stringOfDPLLState : (int, int) prod -> string

val negateScenarioTree : scenarioTree -> scenarioTree

val fOL_DPLL :
  int -> architectureLevelEdge list -> (int, int) prod list -> string list list -> fOLState -> scenarioTree ->
  fOLState option

type fOLStatement =
| FOLAxiom of fOLFormula
| FOLMacroDefinition of fOLMacro
| FOLContextTerm of fOLTerm

val addContext : int -> fOLTerm list -> fOLFormula -> fOLFormula

val evaluateFOLStatementsHelper :
  int -> fOLMacro list -> fOLTerm list -> fOLFormula -> fOLStatement list -> fOLFormula

val evaluateFOLStatements : int -> fOLStatement list -> fOLFormula

type microarchitecturalComponent = fOLStatement list

type microarchitecture = microarchitecturalComponent list

val buildMicroarchitectureHelper : microarchitecturalComponent list -> int -> fOLFormula

val buildMicroarchitecture : microarchitecture -> fOLFormula

val setNth : int -> 'a1 option list -> 'a1 -> 'a1 option list

val stageNamesRemoveOptions : string option list -> string list

val stageNamesHelper : microarchitecturalComponent -> string option list -> string list

val stageNames : microarchitecture -> string list list

val evaluateUHBGraphs :
  int -> microarchitecture -> ((microop list, architectureLevelEdge list) prod, boundaryCondition list) prod list ->
  boundaryCondition list -> (graphEdge list, architectureLevelEdge list) prod option

type expectedResult =
| Permitted
| Forbidden
| Required
| Unobserved
