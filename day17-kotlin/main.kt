import java.security.MessageDigest
import java.util.Arrays;

fun md5(text: String): String {
    val bytes = text.toByteArray()
    val md = MessageDigest.getInstance("MD5")
    val digest = md.digest(bytes)
    var result = ""
    for (byte in digest) result += "%02x".format(byte)
    return result 
}

fun run(input: String, part2: Boolean = false): String {
	val deltas = arrayOf(intArrayOf(0,-1), intArrayOf(0,1), intArrayOf(-1,0), intArrayOf(1,0))
	var finished:  MutableSet<Int> = mutableSetOf()

	var queue = mutableListOf(Pair(intArrayOf(0,0), ""))

	while (queue.size > 0) {
		val (position, path) = queue.removeAt(0)

		if (position[0] == 3 && position[1] == 3) {
			if (part2) {
				finished.add(path.length)
				continue
			} else {
				return path	
			}
		}

		var hash = md5(input + path)
		var upOpen = "[bcdef]".toRegex().matches(hash.substring(0, 1))
		var downOpen = "[bcdef]".toRegex().matches(hash.substring(1, 2))
		var leftOpen = "[bcdef]".toRegex().matches(hash.substring(2, 3))
		var rightOpen = "[bcdef]".toRegex().matches(hash.substring(3, 4))

		var x = position[0]
		var y = position[1]

		if ((x >= 0) && (y >= 0) && (x < 4) && (y < 4)) {

			if ((y+deltas[0][1]) >= 0 && upOpen) {
				queue.add(Pair(intArrayOf(x+deltas[0][0],y+deltas[0][1]), path + "U"))
			}

			if ((y+deltas[1][1]) < 4 && downOpen) {
				queue.add(Pair(intArrayOf(x+deltas[1][0],y+deltas[1][1]), path + "D"))
			}

			if ((x+deltas[2][0]) >= 0 && leftOpen) {
				queue.add(Pair(intArrayOf(x+deltas[2][0],y+deltas[2][1]), path + "L"))
			}

			if ((x+deltas[3][0]) < 4 && rightOpen) {
				queue.add(Pair(intArrayOf(x+deltas[3][0],y+deltas[3][1]), path + "R"))
			}
		}

		if (part2) {
			queue = queue.sortedWith(compareByDescending({ it.second.length })).toMutableList()
		} else {
			queue = queue.sortedWith(compareBy({ it.second.length })).toMutableList()
		}
	}
	if (part2) {
		return "" + finished.max()
	} else {
		return "not found"
	}
}

fun tests() {
	var testInput = arrayOf("ihgpwlah", "kglvqrro", "ulqzkmiv")
	var testResult = arrayOf("DDRRRD", "DDUDRLRRUDRD", "DRURDRUDDLLDLUURRDULRLDUUDDDRR")
	
	println("Part1:")
	println("${run(testInput[0])} should be equal to expected: ${testResult[0]}, ${testResult[0] == run(testInput[0])}")
	println("${run(testInput[1])} should be equal to expected: ${testResult[1]}, ${testResult[1] == run(testInput[1])}")
	println("${run(testInput[2])} should be equal to expected: ${testResult[2]}, ${testResult[2] == run(testInput[2])}")
	println("\nPart2:")
	println("${run(testInput[0], true).toIntOrNull()} should be equal to expected: ${370}, ${370 == run(testInput[0], true).toIntOrNull()}")
	println("${run(testInput[1], true).toIntOrNull()} should be equal to expected: ${492}, ${492 == run(testInput[1], true).toIntOrNull()}")
	println("${run(testInput[2], true).toIntOrNull()} should be equal to expected: ${830}, ${830 == run(testInput[2], true).toIntOrNull()}")
}

fun main(args : Array<String>) {
	val input = "qtetzkpl"

	println("${run(input)}, ${run(input, true)}")
}