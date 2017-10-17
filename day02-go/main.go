package day2

import (
  "fmt"
  "strings"
  "strconv"
  "io/ioutil"
)

var keypad = [3][3]int{
  {1, 4, 7},
  {2, 5, 8},
  {3, 6, 9} }

var keypad2 = [5][5]string {
  {"", "", "5", "", ""},
  {"", "2", "6", "A", ""},
  {"1", "3", "7", "B", "D"},
  {"", "4", "8", "C", ""},
  {"", "", "9", "", ""} }

func getInput(file string)(s string) {
  b, err := ioutil.ReadFile(file)
  if err != nil {
      fmt.Print(err)
  }
  return string(b);
}

func star1(instructionsString string)(string) {

  var instructionsList = strings.Split(instructionsString, "\n")
  var position = [2]int {1, 1}

  var code = "";

  for i := 0; i < len(instructionsList); i++ {
    var instructions = strings.Split(instructionsList[i], "");
    for j := 0; j < len(instructions); j++ {

      var instruction = instructions[j];
      if instruction == "U" {
        if position[1] != 0 { position[1]-- }
      }
      if instruction == "L" {
        if position[0] != 0 { position[0]-- }
      }
      if instruction == "R" {
        if position[0] != 2 { position[0]++ }
      }
      if instruction == "D" {
        if position[1] != 2 { position[1]++ }
      }


    }

    code += strconv.Itoa(keypad[position[0]][position[1]]);
  }
  return code
}

func parse(input string)(output string) {
  return ""
}

func star2(instructionsString string)(string) {
  var instructionsList = strings.Split(instructionsString, "\n")
  var code = "";
  var position = [2]int {0, 2}

  for i := 0; i < len(instructionsList); i++ {
    var instructions = strings.Split(instructionsList[i], "");
    for j := 0; j < len(instructions); j++ {

      var peek = position;
      var instruction = instructions[j];
      if instruction == "U" { peek[1]-- }
      if instruction == "L" { peek[0]-- }
      if instruction == "R" { peek[0]++ }
      if instruction == "D" { peek[1]++ }

      if (peek[0] >= 0 && peek[0] < len(keypad2) && peek[1] >= 0 && peek[1] < len(keypad2)) {
        if (keypad2[peek[0]][peek[1]] != "") {position = peek }
      }

    }

    code += keypad2[position[0]][position[1]];
  }

  return code;
}

