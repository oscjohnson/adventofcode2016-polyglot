var expect = require('chai').expect;
var fs = require('fs');
var day1 = require('./main.js');

const getInput = name => fs.readFileSync(__dirname + '/input.txt', {encoding: "utf-8"});

describe('Day 1', ()=> {
	describe('--- Part One ---', ()=> {
		it('Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.', () => {
			const result = day1.walk('R2, L3');

			expect(result).to.equal(5);
		});
		
		it('R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.', () => {
			const result = day1.walk('R2, R2, R2');

			expect(result).to.equal(2);
		});
		
		it('R5, L5, R5, R3 leaves you 12 blocks away.', () => {
			const result = day1.walk('R5, L5, R5, R3');

			expect(result).to.equal(12);
		});

		it('How many blocks away is Easter Bunny HQ?', () => {
			var result = day1.walk(getInput('day1'));
			var boberResult = day1.walk(getInput('bober'));
			
			expect(result).to.equal(226);
		});	
	})
	describe('--- Part Two ---', ()=> {
		it('For example, if your instructions are R8, R4, R4, R8, the first location you visit twice is 4 blocks away, due East.', () => {
			const result = day1.count('R8, R4, R4, R8', (data) => {	
				expect(data).to.deep.equal(4);
			});
		});

		it('How many blocks away is the first location you visit twice?', () => {
			day1.count(getInput('day1'), res => {
				expect(res).to.deep.equal(79);
			});
		});
	})
})

