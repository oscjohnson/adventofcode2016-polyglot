from itertools import combinations
import copy

from pprint import pformat

GENERATOR = "G"
MICROCHIP = "M"

"""
"""

floors = {
	1: ["T-G", "T-M", "Pl-G", "S-G"], # , "E-G", "E-M", "D-M", "D-G"],
	2: ["S-M", "Pl-M"],
	3: ["Pr-G", "Pr-M", "R-G", "R-M"],
	4: []
}


floors2 = {
	1: ["T-G", "T-M", "Pl-G", "S-G", "E-G", "E-M", "D-M", "D-G"],
	2: ["S-M", "Pl-M"],
	3: ["Pr-G", "Pr-M", "R-G", "R-M"],
	4: []
}

testinput = {	
	'floors': {
		1: ["H-M", "L-M"],
		2: ["H-G"],
		3: ["L-G"],
		4: []
	},
	'floors2': {
		1: ["H-M", "L-M", "E-G", "E-M", "D-M", "D-G"],
		2: ["H-G"],
		3: ["L-G"],
		4: []
	}
}

def isPossibleMove(c, items, nextItems):
	_items, _nextItems = applyMove(c, items[:], nextItems[:])
	
	return check(_nextItems) and check(_items)

def applyMove(candidate, items, nextItems):
	_items = items[:]
	for c in candidate:
		_items.remove(c)

	return _items, nextItems[:] + candidate[:]

def check(items):
	_items = map(lambda x: x.split('-'), items[:])
	connectedPair = False
	lonelyM = False
	for item in _items:
		try:
			if (item[1] == MICROCHIP):
				_items.index([item[0], GENERATOR])
				connectedPair = True
			else:
				try:
					_items.index([item[0], MICROCHIP])
					connectedPair = True
				except ValueError:
					a = 'a'
					
		except ValueError:
			lonelyM = True

	if (connectedPair and lonelyM):
		return False

	return True

def createCombinations(_items):
	comb = []
	for i in range(2):
		comb += combinations(_items[:], i+1)
	return [ list(t) for t in comb ]


def counter(queue, seen):

	while (len(queue) > 0):
		current =  queue.pop(0)

		state = copy.deepcopy(current['state'])
		currentFloor = current['currentFloor']
		count = current['count']

		items = state[currentFloor]
		combinations = createCombinations(items)

		for candidate in combinations:
			for direction in [-1, 1]:
				if (direction == -1 and currentFloor == 1 or direction == 1 and currentFloor == 4):
					continue
				if (direction == -1 and belowFloorsIsEmpty(currentFloor, state)):
				 	continue
				nextItems = state[currentFloor + direction]

				if (isPossibleMove(candidate, items, nextItems)):
					_items, _nextItems = applyMove(candidate, items, nextItems)
					nextState = copy.deepcopy(state)
					nextState[currentFloor] = _items
					nextState[currentFloor + direction] = _nextItems
					nextCurrentFloor = currentFloor + direction
					nextCount = count + 1

					if (isFinished(nextState)):
						return nextCount

					pairs = convertStateToPairs(nextState)
					key = str(pairs) + '-' + str(direction) + '-' + str(nextCurrentFloor)
					if (key in seen):
						continue
					else:
						seen.add(key)
 						queue.append({
							'state': nextState,
							'count': nextCount,
							'currentFloor': nextCurrentFloor
						})


def convertStateToPairs(_floors):
	floors = copy.deepcopy(_floors)

	pairs = {}
	for floor in range(1, 5):
		for item in floors[floor]:
			element, device = item.split('-')
			if not element in pairs:
				pairs[element] = {}
			pairs[element][device] = floor

	val = []
	for key in pairs:
		val.append( (pairs[key][MICROCHIP], pairs[key][GENERATOR]) ) #(Memory floor, Generator floor)
	val.sort()

	return val

def belowFloorsIsEmpty(currentFloor, floors):
	for i in range(1, currentFloor):
		if (len(floors[i]) > 0):
			return False

	return True

def isFinished(floors):
	return len(floors[1]) == 0 and len(floors[2]) == 0 and len(floors[3]) == 0

star1 = counter([{'state': testinput['floors'],'count': 0,'currentFloor': 1}], set())
star2 = counter([{'state': testinput['floors2'], 'count': 0, 'currentFloor': 1}], set())

print star1, star2


