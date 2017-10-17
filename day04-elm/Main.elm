
-- Correct answers: 409147, 991
-- To run (prerequistice is that elm is installed):
-- $ elm reactor && open http://localhost:8000
-- Click Main.elm
-- NOTE: for some reason my implementation is really slow, and it takes about a minute to get the result.

import Html exposing(div, h1, h2, text)
import Data
import Dict
import Char
import Regex
import List exposing (take)

part1 input =
    input
    |> String.lines
    |> List.filter (\x -> not (String.isEmpty x))
    |> List.map parseLine
    |> List.map (\x ->  -- create checksum
        let 
            actual = countLetters x.name
            |> Dict.toList
            |> List.sortBy (\(a, b) -> (-b, a))
            |> take 5
            |> List.map (\(a,b) -> a)
            |> List.map String.fromChar
            |> String.join ""
        in
        {valid = actual == x.checksum, sectorid =  x.sectorid}
    )
    |> List.foldr (\a b -> 
        if a.valid then
            b + a.sectorid
        else
            b
    ) 0

part2 input =
    input
    |> String.lines
    |> List.filter (\x -> not (String.isEmpty x))
    |> List.map parseLine
    |> List.map (\x ->
        {sectorid= x.sectorid, encoded=x.name, decoded = (decodeSentence x.name x.sectorid)}
    )
    |> List.filter(\x ->
        String.contains "north" x.decoded
    )
    |> List.map (\x -> x.sectorid)
    |> List.head 
    |> Maybe.withDefault 0

countLetters str = 
    String.foldl (\char dict -> 
        case Dict.get char dict of
            Just i ->
                Dict.insert char (i + 1) dict

            Nothing ->
                Dict.insert char 1 dict
    )
    Dict.empty str


ceasarShift char shifts =
    if shifts == 0 || char == '-' then
        char
    else if (Char.toCode char) == 122 then
        ceasarShift (Char.fromCode ((Char.toCode char) - 25)) (shifts - 1)
    else
        ceasarShift (Char.fromCode ((Char.toCode char) + 1)) (shifts - 1)

decodeSentence sentence shifts =
    sentence
    |> String.map (\x ->
        (ceasarShift x shifts)
    )

parseLine str =
    str
    |> String.split "-"
    |> List.reverse
    |> (\x -> 
        let 
            room = String.join "" (List.reverse (Maybe.withDefault [] (List.tail x)))
            sectoridAndChecksum = (String.split "[" (Maybe.withDefault "" (List.head x)))
            sectorid = Result.withDefault 0 (String.toInt (Maybe.withDefault "" (List.head sectoridAndChecksum)))
            checksum = String.dropRight 1 (Maybe.withDefault "" (List.head (List.reverse sectoridAndChecksum)))
        in  
        {name = room, sectorid = sectorid, checksum = checksum}
    )

main =
    div [] [
        h1 [] [text "PART 1"],
        h2 [] [text (toString (part1 Data.input))],
        h1 [] [text "PART 2"],
        h2 [] [text (toString (part2 Data.input))]
    ]

