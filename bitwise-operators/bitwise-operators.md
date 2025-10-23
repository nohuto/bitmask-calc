# Bitwise Operators Explained

- Byte = `8` bits
- Binary: `00000000₂` - `11111111₂`
- Decimal: `0₁₀` - `255₁₀`
- Hexadecimal: `00₁₆` - `FF₁₆`

We'll use the char `N` as example - binary representation in `1` byte
> `N` -> `78` dec -> `01001110`

__Bitwise AND operation (`-band` = `&`):__
Writing `78` dec (`N`) with the bAND operation would look like (2 examples):
```ps
11011110       |      01001110 
01101111       |      11111111
---------      |      --------
01001110       |      01001110 
```
Both bits have to be `1` to get `1` as result - `0`&`0` / `1`&`0` etc would result in `0`


__Bitwise OR operation -  inclusive (`-bor` = `|`):__
It it similar to `-band`, the difference is that either one bit has to be `1` or both to get `1` as the result:
```ps
01001110       |      01001110 
01001110       |      00000010
---------      |      --------
01001110       |      01001110 
```
Both bit's have to be `0` if a `0` result is wanted.


__Bitwise OR operation -  exclusive (`-bxor` = `^`):__
The resulting bit is only `1`, if **one** bit is `1`. If both are `0` or `1` the result will be `0`:
```ps
00001100       |      01001100 
01000010       |      00000010
---------      |      --------
01001110       |      01001110 
```

__Bitwise NOT operation (`-bnot` = `~`):__
Here we'll have one byte instead of two, `0` will result in `1`, `1` results in `0`. Basically just the opposite output of the input. A input of 0 using bnot results in `-1` & `0` -> `-1`
```ps
~ |
-----
0 | 1
-----
1 | 0

10110001 -> -79 dec (from signed 2's complement)
---------
01001110

-> bnot(x) = ~x = -(x + 1)
```
You could enter `-bnot -79` into powershell and get the output of `78`. `bnot(x)` flips all bits, which gives you the bitwise inverse of `x`. In two’s complement, this is the same as `- (x + 1)` because flipping bits is the first step in negating a number the second step is adding 1.
MSB -> `0` positve; `1` negative

![](https://github.com/5Noxi/bitmask-calc/blob/main/media/complement.png)

__Bitwise shift left operation (`-shl` = `x << y`):__
Bitwise shift left operations would be used like: `x -shl x` -> x represents a number. The right number tells you the number of how many times the bits getting moved to the **left** of binary value from the left dec value.
```ps
78 -shl 0
```
would result in `01001110`, as it got shifted `0` times.
```ps
00100111
01001110 -> one shift to the left = 78 dec

39 -shl 1
```
`39` -> `00100111`
Writing the dec 78 with `-shl 2` isn't possible anymore - `20 -shl 2` = 80, `19 -shl 2` = 76.


__Bitwise shift right operation (`-shr` = `x >> y`):__
Same as `-shl`, but the bits are getting moved to the right instead.
```ps
78 -shr 0
```
As before `-shr 0` outputs the input. If going above 1 shift (in this example) you can show it within one byte anymore:
```ps
10011100
01001110 -> one shift to the right = 78 dec
= 156 -shr 1

100111000
001001110 -> two shifts to the right = 78 dec
= 312 -shr 2

1001110000000000000
0000000000001001110 -> twelve shifts to the right = 78 dec
= 319488 -shr 12
```
You can see, you're able to add as many zeros as possible.

If you're shifting e.g.:
```ps
00101001
```
4 times, the 4 bits on the right would fall away and new 0 would get added on the left:
```ps
00101001
00010100 -> first shift
00001010 -> second shift
00000101 -> third shift
00000010 -> fourth shift
```
As you can see, if you're shifting the bits too much to the right the output will be `0`.

![](https://github.com/5Noxi/bitmask-calc/blob/main/media/shift.png)


## How can I use these operators?
```ps
[char](dec)
```
will be used. You can either simply write the decimal value into it or obfuscate it with bitwise operators (e.g. `-band`):
```ps
11011110 -> 222 dec
01101111 -> 111 dec
---------
01001110 -> 78 dec

[char](222 -band 111)
```
The output would be `N`, write whole words by just adding the next char behind it:
```ps
[char](dec)[char](dec)
```
You can combine different operators with `+`, `-`,`*`,`/`. Example of using `-band`/`-bor` with the string `Noverse`:
```ps
[char](((7074 -Band 5286) + (7074 -Bor 5286) - 7660 - 4622))+[char](((5567 -Band 7609) + (5567 -Bor 7609) - 7454 - 5611))+[char](((-10968 -Band 4270) + (-10968 -Bor 4270) + 5206 + 1610))+[char](((4303 -Band 5497) + (4303 -Bor 5497) + 15 - 9714))+[char]((13290 - 4394 - 7930 - 852))+[char]((10661 - 8092 - 6271 + 3817))+[char](((-233 -Band 1614) + (-233 -Bor 1614) - 3236 + 1956))
```

Test it by pasting it into powershell. That's all about bitwise operations, get more info here:
> https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_arithmetic_operators?view=powershell-7.5
> https://blog.feilers.dev/blog/en/powershell-bitwise-operators/
> https://www.cs.utexas.edu/~witchel/429H/lectures/02-bits-ints.pdf

The following script lets you create your own obfuscated content. You can either enter a path or a string as input.

As written in the code the first three chars represent `iex` - replace `&([char]105+[char]101+[char]120)` with `iex`, if it confuses you:
```ps
$content = "&([char]105+[char]101+[char]120)(" + ($obf -join'+')+")"
-> $content = "iex (" + ($obf -join'+')+")"
```
I created it for testing reasons, you can use it to see the output of obfuscated content using a operator. The output isn't needed, if no output was given the command will be displayed in the console. This won't work for scripts with functions & it doesn't skip empty lines. See it as a demonstration of each bitwise operator using your code:
- [NV-BitwiseOp.ps1](https://github.com/5Noxi/bitmask-calc/blob/main/bitwise-operators/NV-BitwiseOp.ps1) 
