package day2
import (
	"testing"
)

func TestMain(t *testing.T) {
var input = `ULL
RRDDD
LURDL
UUUUD`
  var res = star1(input);
  if res != "1985" {
    t.Error(`First code should be 1985.`)
  }
}

func TestStar1(t *testing.T) {
  var res = star1(getInput("./input.txt"));
  if res != "53255" {
    t.Error(`First code should be 1985.`)
  }
}

func TestStar2(t *testing.T) {
  var res = star2(getInput("./input.txt"));
  if res != "7423A" {
    t.Error(`First code should be 7423A, and not `, res)
  }
}

func TestExample2(t *testing.T) {
var input = `ULL
RRDDD
LURDL
UUUUD`
	var res = star2(input);
	if res != "5DB3" {
		t.Error(`First code should be 1985.`)
	}	
}