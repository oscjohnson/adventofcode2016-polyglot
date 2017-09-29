input =: '11110010111001001'
part1 =: 272
part2 =: 35651584

reverse =: |.
inverse =: '01'{~ '0' & =
generate_once =: 3 : 'y,''0'', inverse (reverse y)'
generate =: 3 : 'if. (# y) >: part2 do. (part2 {. y) else. generate (generate_once y)  end.'

halve =: ('01'{~_2&(=/\))
checksum =: 3 : 'if. (2 & | # y) do. y else. checksum (halve y)  end.'

run =: checksum @: generate

NB. run input NB. part1 -> 01110011101111011
NB. run input NB. part2 -> 11001111011000111