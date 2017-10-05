var input = 3005290

function part2(n) {
	var first = {num: 1}
	var last = first
	var beforeTarget

	for (var i = 1; i < n; i++) {
		var next = {num: last.num + 1}
		last.next = next
		last = next
		if (i == ~~(n/2) - 1) {
			beforeTarget = next
		}
	}
	last.next = first

	while (n > 1) {
		var target = beforeTarget.next
		beforeTarget.next = target.next
		if (n % 2 == 1) {
			beforeTarget = beforeTarget.next
		}
		n--
	}
	return beforeTarget.num
}

console.log(part2(input))