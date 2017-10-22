open Printf ;;
open Str ;;
open Set ;;

module SS = Set.Make(String);;

(* Helpers *)
let rec drop n h =
   if n == 0 then h else (drop (n-1) (match h with a::b -> b));;

let read_file filename = 
let lines = ref [] in
let chan = open_in filename in
try
  while true; do
    lines := input_line chan :: !lines
  done; !lines
with End_of_file ->
  close_in chan;
  List.rev !lines ;;

(* End Helpers *)

let is_viable_pair a b = 
	let a_parts = Str.split ( Str.regexp " +") a in
	let b_parts = Str.split ( Str.regexp " +") b in
	let b_available = int_of_string (Str.replace_first (Str.regexp "T") "" (List.nth b_parts 3)) in
	let a_used = int_of_string (Str.replace_first (Str.regexp "T") "" (List.nth a_parts 2)) in
	 (not (String.equal a b)) && (a_used > 0) && (b_available >= a_used)
;;

let add_to_set_if_necessary a b s =
	if (is_viable_pair a b) && not (SS.exists (fun e -> ((String.equal e (a^b)) || (String.equal e (b^a)))) s) then
		(SS.add (a ^ b) s)
	else
		s
	;;

let rec viable_counter a b all s =
	let new_s = if (List.length a > 0) && (List.length b > 0) then
		add_to_set_if_necessary (List.hd a) (List.hd b) s
	else
		s
	in
	if (List.length a == 0) && (List.length b == 0) then
		List.length (SS.elements s)
	else if (List.length b == 0) then
 		viable_counter (List.tl a) all all new_s
	else
 		viable_counter a (List.tl b) all new_s
	;;

let lines = drop 2 (read_file "input.txt") ;;

(* Print map to investigate how the goal cargo should be moved to it's goal via the empty space. *)
let rec print_map lines counter s = match lines with
	[] -> s
	| h::t ->
	let parts = Str.split ( Str.regexp " +") h in
	let size = int_of_string (Str.replace_first (Str.regexp "T") "" (List.nth parts 1)) in
	let used = int_of_string (Str.replace_first (Str.regexp "T") "" (List.nth parts 2)) in
	let available = int_of_string (Str.replace_first (Str.regexp "T") "" (List.nth parts 3)) in
	let [_;x_s;y_s] = Str.split ( Str.regexp "-.") (List.nth parts 0) in
	let x = int_of_string x_s in
	let y = int_of_string y_s in
	let new_s = if (used > 100) then (s^"#") (* wall *)
		else if (x = 0 && y = 0) then (s^"()") (* start *)
		else if (x = 33 && y = 0) then (s^"G") (* goal cargo *)
		else if (used = 0) then (s^"_") (* empty space *)
		else (s^".") in (* walkable coordinate *)
	let new_s1 = if (counter = 0) then (new_s^"\n") else new_s in
	let new_counter = if (counter = 0) then 30 else counter - 1
	in
	print_map t new_counter new_s1
;;

(*Printf.printf "%s" (print_map lines 30 "") ;;*)

Printf.printf "%d" (viable_counter lines lines lines SS.empty) ;; 



