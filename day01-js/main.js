function walk(input, callback) {
	let index = 0; // North = 0, clockwise rotation
	let position = {x: 0, y: 0};
	const directions = ['N', 'E', 'S', 'W'];
	let direction = directions[index];
	
	transform(input)
		.map(instruction => {
			const {steps, turn} = instruction;

			turn === 'R' ? index++ : index--;

			if (index < 0) index = directions.length - 1;
			direction = directions[index % directions.length];

			for (var i = 0; i < steps; i++) {
				if (direction == 'N') position.y++;
				if (direction == 'E') position.x++;
				if (direction == 'S') position.y--;
				if (direction == 'W') position.x--; 

				callback && callback(position)
			}
			
		})
	
	return Math.abs(position.x) + Math.abs(position.y);
}

function count(input, cb) {
	let visits = {};
	let done = false;
	walk(input, position => {
		if (done) return;

		if (!visits[`${position.x}_${position.y}`]) visits[`${position.x}_${position.y}`] = 1;
		else visits[`${position.x}_${position.y}`]++;
		
		if (visits[`${position.x}_${position.y}`] == 2) {
			cb(Math.abs(position.x) + Math.abs(position.y));
			done = true;
		}
	})

}

module.exports = {
	walk,
	count
}

function transform(input) {
	return input
		.split(', ')
		.map((instruction) => {
			const [turn, ...rest] = instruction.split('');
			const steps = Number(rest.join(''));

			return {steps, turn};
		})
}
