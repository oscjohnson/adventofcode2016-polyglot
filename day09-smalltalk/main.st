
Object subclass: StringUtils [
	|name|

	StringUtils class >> repeat: string times: count [
		|repeatedString|
		repeatedString := ''.
		1 to: count do: [:x |
			repeatedString := repeatedString, string.
		].
		^repeatedString
	]
]


Object subclass: Day09 [
	counter:= 0.
	Day09 class >> expand: testString [
		|marker i end measures sample sampleSize sampleStart sampleEnd times result|
		i := 1.
		end := 1.
		result := ''.

		1 to: (testString size) do: [:x |
			(i > x) ifFalse: [
				i := x.
				(testString at: i) asString  = '(' ifTrue: [
					"found left paren, iterate until found next right paren."
					end :=(testString indexOf: $) startingAt: i).
					marker := (testString copyFrom: i to: end).
					marker := marker allButLast allButFirst.

					measures := (marker substrings: $x).
					times := (measures at: 2) asNumber.
					sampleSize := ((measures at: 1) asNumber).

					i := end + 	1 + sampleSize.
					sampleStart := end + 1.
					sampleEnd := sampleStart + sampleSize - 1.
					sample := (testString copyFrom: sampleStart to: sampleEnd).
					result := result, (StringUtils repeat: sample times: times).
					"expand the marker and append to result string"
				] ifFalse: [
					result := result, (testString at: i) asString.
				].

			].
		].
		i := 1.

		^result.
	]

	Day09 class >> expand2: testString [
		|marker i end measures sample sampleSize sampleStart sampleEnd times result processedSample repeatedSample|
		i := 1.
		end := 1.
		result := 0.
		

		1 to: (testString size) do: [:x |
			(i > x) ifFalse: [
				i := x.
				(testString at: i) asString  = '(' ifTrue: [
					"found left paren, iterate until found next right paren."
					end := (testString indexOf: $) startingAt: i).
					marker := (testString copyFrom: i to: end).
					marker := marker allButLast allButFirst.

					measures := (marker substrings: $x).
					times := (measures at: 2) asNumber.
					sampleSize := ((measures at: 1) asNumber).

					i := end + 	1 + sampleSize.
					sampleStart := end + 1.
					sampleEnd := sampleStart + sampleSize - 1.
					sample := (testString copyFrom: sampleStart to: sampleEnd).
					processedSample := (Day09 expand2: sample).
					repeatedSample := times * processedSample.

					result := result + repeatedSample.

					"expand the marker and append to result string"
				] ifFalse: [
					result := result + 1.
				].

			].
		].
		i := 1.

		^result.
	]

	Day09 class >> star1 [
		|input|
		input := (FileStream open: 'input.txt' mode: FileStream read) contents.
		^(Day09 expand: input) size.
	]

	Day09 class >> star2 [
		|input|
		input := (FileStream open: 'input.txt' mode: FileStream read) contents.

		^(Day09 expand2: input).
	]

	Day09 class >> runTests [
		|tests input expected result|
		tests := #(
			#('ADVENT' 'ADVENT')
			#('A(1x5)BC' 'ABBBBBC')
			#('(3x3)XYZ' 'XYZXYZXYZ')
			#('A(2x2)BCD(2x2)EFG' 'ABCBCDEFEFG')
			#('(6x1)(1x3)A' '(1x3)A')
			#('X(8x2)(3x3)ABCY' 'X(3x3)ABC(3x3)ABCY')
		).

		input := nil.
		expected := nil.
		result := nil.
		1 to: tests size do: [:i |
			input := ((tests at: i) at: 1).
			expected := ((tests at: i) at: 2).
			
			Day09 runTest: input expected: expected.
		].
	]


	Day09 class >> runTests2 [
		|tests input expected result|

		tests := #(
			#('(27x12)(20x12)(13x14)(7x10)(1x12)A' 241920)
			#('(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN' 445)
		).

		input := nil.
		expected := nil.
		result := nil.
		
		1 to: tests size do: [:i |
			input := ((tests at: i) at: 1).
			expected := ((tests at: i) at: 2).

			result := (Day09 expand2: input).
			Day09 validateResult: input expected: expected result: result.
		].
	]

	Day09 class >> runTest: input expected: expected [
		|result|

		result := (Day09 expand: input).
		Day09 validateResult: input expected: expected result: result.
	]

	Day09 class >> validateResult: input expected: expected result: result [
		(result = expected)
			ifTrue: [ ('PASS ', input) printNl.]
			ifFalse: [
				'FAIL' printNl. 
				('   input ', input) printNl.
				('   expected ', expected) printNl.
				('   result ', result) printNl.
			].
	]
]


Transcript show: Day09 star1 asString, ', ', Day09 star2 asString.