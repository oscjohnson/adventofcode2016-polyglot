require 'digest/md5'

def md5hash string
	Digest::MD5.hexdigest(string)
end

def calcuatePasswordChar(door_id, index)
	result = md5hash(door_id + index.to_s);

	if (/^00000/.match(result))
		return result
	end

	return nil
end

def findNextIndex(str, index)
	while !calcuatePasswordChar(str, index) do
		index = index + 1
	end

	return index;
end

def findPassword(str)
	password = ''
	index = 0
	while password.length < 8 do

		nextIndex = findNextIndex(str, index);

		password += calcuatePasswordChar(str, nextIndex)[5]

		index = nextIndex + 1
	end

	return password
end

def findPassword2(str)
	password = '--------'

	index = 0
	while !/\w{8}/.match(password) do
		nextIndex = findNextIndex(str, index);
		hash = calcuatePasswordChar(str, nextIndex)
		position = Integer(hash[5]) rescue nil

		if position.is_a?(Numeric) && password[position] == '-'
			char = hash[6];
			password[position] = char
		end

		index = nextIndex + 1
	end

	return password
end

puts findPassword("ffykfhsq"), findPassword2("ffykfhsq") 