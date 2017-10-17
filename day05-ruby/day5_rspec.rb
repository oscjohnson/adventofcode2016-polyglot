require_relative 'day5'

describe "Day 5" do

	it "Check actual hash of first example" do
		expect(md5hash("abc3231929")).to eq "00000155f8105dff7f56ee10fa9b9abd"
	end

	describe "findNextIndex" do
		it "should find the index 3231929 when passing abc and 0" do
			expect(findNextIndex("abc", 0)).to eq 3231929
		end
		it "should find the index 5017308 when passing abc and 3231929" do
			expect(findNextIndex("abc", 3231929+1)).to eq 5017308
		end
		it "should calculate password" do
			expect(findPassword "abc").to eq "18f47a30"
		end
		it "should calculate password for advent of code" do
			expect(findPassword "ffykfhsq").to eq "c6697b55"
		end
	end

	describe "Part two" do
		it "should calculate password for advent of code" do
			expect(findPassword2("ffykfhsq")).to eq "8c35d1ab"
		end
	end
end


