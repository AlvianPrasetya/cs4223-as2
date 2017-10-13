module Simulator
    ( runSimulation
    ) where

data Protocol = MESI | Dragon deriving (Show, Read)
type ProtocolInput = String
type Filename = String
type CacheSize = Int
type Associativity = Int
type BlockSize = Int
type ProcessorCompleteStatus = Bool
type ProcessorsTraces = [[String]]
type StatsReport = String

-- Defining constants
num_processors = 4

-- |Given appropriate cmd line arguments, runs the entire cache simulation and results the stats results
runSimulation :: ProtocolInput -> Filename -> CacheSize -> Associativity -> BlockSize -> IO String
runSimulation protocolInput fileName cacheSize associativity blockSize = 
    do
        let 

            -- Parse the protocol
            -- Possible error with read here if bad input given
            protocol = read protocolInput :: Protocol 

            -- Read the input files
            -- Create exactly 4 trace files names
            fileNames = map (\n -> fileName ++ "_" ++ show n ++ ".data") [0..(num_processors-1)] 

            -- Create a set of strings, each will lazily read from the file as needed (IO [String]])
            fileStrings = mapM (readFile) fileNames 

            -- Read the list of strings from the file read process into a list of list of lines
            -- Each element of the list is a list of the lines from a single file
            fileLines = getLines fileStrings

            -- Initially all processors are still completing their tasks
            processorsCompleteStatus = replicate num_processors False

            -- Now run one round of the simulation loop and see if a core needs another instruction
        return "Simulation Completed"

-- |Converts readFile output of many files (IO [String]) to list of list of lines from the files (IO [[String]])
getLines :: IO [String] -> IO [[String]]
getLines fileStrings = 
    do
        listOfStrings <- fileStrings
        return $ map lines listOfStrings
        -- Same as
        -- fileStrings >>= (\listOfStrings -> return $ map lines listOfStrings)

-- General idea: for each processor, execute the new trace if there is one, or continue with current action. Then, propagate the bus events to ALL OTHER PROCESSORS: aka all other processors MUST RESPOND to the bus event before this processors' CYCLE is over. Then, repeat for the rest. Check when more awake whether this makes sense. Therefore, processor 1 always has priority, followed by 2...etc. Deterministic
-- Morning note: this makes sense. It's almost like each processor is running sequentially with a particular priority on each cycle, which could happen in a particularly biased computer.

--doOneCycle :: [Processor] -> [ProcessorCompleteStatus] -> IO ProcessorsTraces -> StatsReport