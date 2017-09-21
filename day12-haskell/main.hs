module Main where
import Data.List.Split
import Data.Char
import Data.Typeable
import qualified Data.Map as Map


isInt :: String -> Bool
isInt xs = all isDigit xs

inc register registers = (Map.update (\x -> Just (x + 1)) register registers)
dec register registers = (Map.update (\x -> Just (x - 1)) register registers)

cpy = \from to registers ->
    let
        value = if (isInt from) then Just (read from::Int) else (Map.lookup from registers)
        newRegisters = (Map.update (\x -> value) to registers)
    in (newRegisters)

jnz = \value jumps cursor registers ->
    if (isInt value) then
        if ((read value::Int) == 0) then
            cursor + 1 -- done
        else
            cursor + (read jumps::Int)
    else 
        case (Map.lookup value registers) of
            Just n -> if (n == 0) then cursor + 1 else cursor + (read jumps::Int)
            Nothing -> error "Invalid data for 'jnz' instruction"

        
updateRegisters = \instruction registers ->
    let
        terms = splitOn " " instruction
        command = terms!!0
        operand1 = terms!!1
        operand2 = terms!!2
        newRegisters = case command of
            "cpy" -> (cpy operand1 operand2 registers)
            "jnz" -> registers
            "inc" -> (inc operand1 registers)
            "dec" -> (dec operand1 registers)
    in
    (newRegisters)


updateCursor = \instruction cursor registers ->
    let
        terms = splitOn " " instruction
        command = terms!!0
        operand1 = terms!!1
        operand2 = terms!!2
        newCursor = case command of
            "jnz" -> jnz operand1 operand2 cursor registers
            _ -> cursor + 1
    in
    (newCursor)

runInstructions list cursor registers
 | (cursor >= (length list)) = registers
 | otherwise = runInstructions list (updateCursor (list!!cursor) cursor registers) (updateRegisters (list!!cursor) registers)


registers = Map.fromList[("a",0), ("b",0), ("c",0), ("d",0)]
registers2 = Map.fromList[("a",0), ("b",0), ("c",1), ("d",0)]

main = do
    contents <- readFile "input.txt"
    let instructions = (splitOn "\n" contents)
    case (Map.lookup "a" (runInstructions instructions 0 registers)) of
        Just a -> print a
        Nothing -> print "Something whent rong"
    case (Map.lookup "a" (runInstructions instructions 0 registers2)) of
        Just a -> print a
        Nothing -> print "Something whent rong"



