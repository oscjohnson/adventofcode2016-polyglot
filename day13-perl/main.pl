use warnings;
use diagnostics;
use Data::Dumper;

# $NUMBER = 10;
# $SIDE = 10;
# $GOAL_X = 7;
# $GOAL_Y = 4; 
$NUMBER = 1352;
$SIDE = 300;
$GOAL_X = 31;
$GOAL_Y = 39;

sub get_value{
	($x, $y) = @_;
	$first = $x*$x + 3*$x + 2*$x*$y + $y + $y*$y;
	$second = $first + $NUMBER;
	$bin = sprintf ("%b", $second);
	my $len = map $_, $bin =~ /(1)/gs;
	return $len;
}

sub print_board {
	($board) = @_;
	for (my $i = 0; $i < $SIDE; $i++) {
		for (my $j = 0; $j < $SIDE; $j++) {
			print $board[$j][$i];
		}
		print "\n";
	}
}

sub bysteps {
	$a->{steps} <=> $b->{steps}
}

sub create_board {	
	@board = ();
	for (my $i = 0; $i < $SIDE; $i++) {
		for (my $j = 0; $j < $SIDE; $j++) {
			$value = get_value($i, $j);
			if ($i == $GOAL_X and $j == $GOAL_Y) {
				$board[$i][$j] = "X";
			} elsif ( $value % 2 == 0) {
				$board[$i][$j] = ".";
			} else {
				$board[$i][$j] = "#";
			}
		}
	}

	return @board;
}

sub main {
	@board = create_board();
	@queue = ();
	push(@queue, {'steps' => 0, 'position' => [1,1], 'path' => "1,1"});

	%seen = ();

	while ((scalar @queue > 0)) {
		$hash = shift(@queue);
		my %element = %{ $hash }; # dereference
		my $steps = $element{steps};
		my @starting_point = @{$element{position}}; # dereference
		my $path = $element{path}; # dereference

		$newSteps = $steps + 1;
		@directions = ([1, 0], [0, 1], [-1, 0], [0, -1]);
		for (my $i = 0; $i < scalar @directions; $i++) {
			$x = $starting_point[0] + $directions[$i][0];
			$y = $starting_point[1] + $directions[$i][1];
			if ($x < 0 or $y < 0 or $x >= $SIDE or $y >= $SIDE) {
				# outside boundaries
			} else {
				if ($board[$x][$y] eq ".") {
					$key = $x . ',' . $y;
					if (not $part2 and $newSteps > 50) {
						$part2 = keys %seen;
					}
					if (not exists($seen{$key})) {
						$seen{$key} = 'exists';

						push(@queue, {
							'steps' => $newSteps,
							'position' => [$x,$y],
							'path' => $path . " $x,$y"
						});
					}
				} elsif ($board[$x][$y] eq "X") {	
					$part1 = $newSteps;
				}
			}
		}
		my @queue = sort bysteps @queue;
	}
	print "$part1, $part2 \n";
}

main();

# print_board($board);