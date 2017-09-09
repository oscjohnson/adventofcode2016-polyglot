use std::fs::File;
use std::io::prelude::*;
use std::collections::HashMap;

extern crate regex;
/*
	Rust does not seem to allow zeros as keys (even as strings) for HashMaps therefore the prefix in the keys.
 */

fn main() {
	let mut robots = HashMap::new();
	let mut outputs = HashMap::new();
	let mut instructions = HashMap::new();
	let mut star1 = "";

	// Get input
    let mut f = File::open("input.txt").expect("file not found");
    let mut contents = String::new();
    f.read_to_string(&mut contents).expect("Something went wrong reading the input file.");
    let mut lines: Vec<&str>= contents.split("\n").collect();

	use regex::Regex;
	let put_value_regex = Regex::new(r"value (\d+) goes to bot (\d+)").unwrap();
	let give_value_regex = Regex::new(r"bot (\d+) gives low to (.+) (\d+) and high to (.+) (\d+)").unwrap();

	for line in &mut lines {
		if put_value_regex.is_match(line) {
			let caps = put_value_regex.captures(line).unwrap();
			let value: i64 = caps.get(1).unwrap().as_str().parse().unwrap();
			let robot: &str = caps.get(2).unwrap().as_str();
			if !robots.contains_key(&format!("{}{}", "bot-", &robot)) {
				robots.insert(format!("{}{}", "bot-", &robot), vec![]);
			}

			let mut arr = robots.get_mut(&format!("{}{}", "bot-", &robot)).unwrap();

			arr.push(value);
		}

		else if give_value_regex.is_match(line) {
			let caps = give_value_regex.captures(&line).unwrap();
			let giver_id: &str = caps.get(1).unwrap().as_str();
			instructions.insert(format!("{}{}", "bot-", giver_id), line.to_string());

		}
	}

	while !robots.is_empty() {
		let robots_copy = robots.clone();

		for key in robots_copy.keys() {
			let line = instructions.get(key).unwrap();

			if give_value_regex.is_match(line) {
				let caps = give_value_regex.captures(&line).unwrap();
				let giver_id: &str = caps.get(1).unwrap().as_str();
				let low_reciever_type: &str = caps.get(2).unwrap().as_str();
				let low_reciever: &str = caps.get(3).unwrap().as_str();
				let high_reciever_type: &str = caps.get(4).unwrap().as_str();
				let high_reciever: &str = caps.get(5).unwrap().as_str();

				if robots.contains_key(&format!("{}{}","bot-", giver_id)) {
					let mut giver_values = robots.get(&format!("{}{}","bot-", giver_id)).unwrap().to_owned();
					if giver_values.len() == 2 {
						giver_values.sort();
						let low = giver_values.get(0).unwrap().to_owned();
						let high = giver_values.get(1).unwrap().to_owned();

						if low == 17 && high == 61 {
							star1 = giver_id;
						}

						if low_reciever_type == "bot" {
							robots.entry(format!("{}{}", "bot-", low_reciever)).or_insert(vec![]);
							robots.get_mut(&format!("{}{}{}",low_reciever_type, "-", low_reciever)).unwrap().push(low);
						} else {
							outputs.entry(format!("{}{}", "output-", low_reciever)).or_insert(vec![]);
							outputs.get_mut(&format!("{}{}{}",low_reciever_type, "-", low_reciever)).unwrap().push(low);
						}

						if high_reciever_type == "bot" {
							robots.entry(format!("{}{}", "bot-", high_reciever)).or_insert(vec![]);
							robots.get_mut(&format!("{}{}{}", high_reciever_type, "-", high_reciever)).unwrap().push(high);
						} else {
							outputs.entry(format!("{}{}", "output-", high_reciever)).or_insert(vec![]);
							outputs.get_mut(&format!("{}{}{}",high_reciever_type, "-", high_reciever)).unwrap().push(high);
						}

						robots.remove(&format!("{}{}","bot-", giver_id));
					}
				}
			} 

		}
	}

	let star2 = 
		outputs.get("output-0").unwrap().get(0).unwrap() *
		outputs.get("output-1").unwrap().get(0).unwrap() *
		outputs.get("output-2").unwrap().get(0).unwrap();

	println!("{}, {}", star1, star2);
}
