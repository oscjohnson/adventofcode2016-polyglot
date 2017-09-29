http://code.jsoftware.com/wiki/System/Installation/All-in-One



Run code (from j prompt):
```
0!:1 < 'main.j'
```


1 becomes 100.
a = 1
b = 1

b = 1 # reverse, reverse string: |.
b = 0 # inverse 1 0 { 'ab' recursively
result  = a, 0, b = 100 # assemble


create_checksum
00 | 11 -> 1 and
01 | 01 -> 0 or
while length == even
	create_checksum

Might be useful:
'a' ,~ 'b'  switch places of varaibles

fac=: 3 : 'if. y = ''0'' do. ''1'' else. ''0'' end.'
fac=: 3 : 'if. (0 1 { y) = ''00'' do. ''11'' else. ''00'' end.'

0 becomes 001.
11111 becomes 11111000000.
111100001010 becomes 1111000010100101011110000

check=: 3 : 'if. (# y) = 0 do. y else. fac (y)  end.'
fac=: 3 : 'if. (0 { y) = ''0'' do. ''1'', check (1 }. y) else. ''0'',check(1 }. y) end.'

# Others solutions
										checksum part                 stiching   inv/revers
272 35651584 ('01'{~_2&(=/\))`]@.(2&|@#) @ ({.`($:((,&'0'),('01'{~'0'=|.)))@.(> #))"0 1 '01110110101001000'


,":("0)  _2 (=/)\^:(4) 272 {.  (]  , 0 , -.@|.)^:4 a =.  "."0 '11100010111110100' NB. part 1
, ":("0)  _2 (=/)\^:(21) 35651584 {.  (]  , 0 , -.@|.)^:21 a =.  "."0 '11100010111110100'F