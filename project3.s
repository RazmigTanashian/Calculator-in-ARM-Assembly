;r6 acts as a boolean counter to know whether its addition or subtraction for when we arrive at the equal sign.

;r4,r8,r9,r1,r2 used as error checkers
;r1&r2 are used for printing blocks.
;they can also be used as error checkers because the fact alone
;that we have made it there means there are no errors to take care of
;so the errors values in r1 and r2 can be overridden.

;====SWI Opcodes====
.equ SWI_CheckBlue, 0x203 ;check press Blue button
.equ SWI_DRAW_STRING, 0x204 ;display a string on LCD
.equ SWI_DRAW_INT, 0x205 ;display an int on LCD
.equ SWI_CLEAR_DISPLAY,0x206 ;clear LCD
.equ SWI_DRAW_CHAR, 0x207 ;display a char on LCD
.equ SWI_CLEAR_LINE, 0x208 ;clear a line on LCD
.equ SWI_EXIT, 0x11 ;terminate program
;====Calculator KEYS====
.equ BLUE_KEY_00, 0x01 ;button(0)
.equ BLUE_KEY_01, 0x02 ;button(1)
.equ BLUE_KEY_02, 0x04 ;button(2)
.equ BLUE_KEY_03, 0x08 ;button(3)
.equ BLUE_KEY_04, 0x10 ;button(4)
.equ BLUE_KEY_05, 0x20 ;button(5)
.equ BLUE_KEY_06, 0x40 ;button(6)
.equ BLUE_KEY_07, 0x80 ;button(7)
.equ BLUE_KEY_08, 1<<8 ;button(8) 
.equ BLUE_KEY_09, 1<<9 ;button(9)
.equ BLUE_KEY_10, 1<<10 ;button(10)
.equ BLUE_KEY_11, 1<<11 ;button(11)
.equ BLUE_KEY_12, 1<<12 ;button(12)
.equ BLUE_KEY_13, 1<<13 ;button(13)
.equ BLUE_KEY_14, 1<<14 ;button(14)
.equ BLUE_KEY_15, 1<<15 ;button(15)
;====Digital display====
.equ SegmentA, 0x80
.equ SegmentB, 0x40
.equ SegmentC, 0x20
.equ SegmentD, 0x08
.equ SegmentE, 0x04
.equ SegmentF, 0x02
.equ SegmentG, 0x01

;====Beginning of Program====

mov r0,#0
swi 0x200
swi 0x206 ;wipes the LCD and the 8-bit display

mov r0,#3
mov r1,#3
ldr r2,=InstructionsOne ;first string of instructions
swi 0x204
mov r1,#4
ldr r2,=InstructionsTwo ;second string of instructions
swi 0x204

ReadBlueButtonLoop:

mov r0,#0
swi SWI_CheckBlue ;checks what button the user pressed

cmp r0,#BLUE_KEY_12
beq BlueKeyTwelveButCLEAR ;branch if C button is pressed

cmp r4,#0
beq StepDigit
cmp r4,#1
beq StepPlusOrMinus
cmp r4,#2
beq StepDigit
cmp r4,#3
beq StepEqual ;This block determines what step of the expression process were in.

StepPlusOrMinus: ;a block in which we can only be in if the expression counter is at #1.
cmp r0,#BLUE_KEY_03
beq BlueKeyThreeAndSevenButADD
cmp r0,#BLUE_KEY_07
beq BlueKeyThreeAndSevenButADD
cmp r0,#BLUE_KEY_11
beq BlueKeyElevenAndFifteenButSUB
cmp r0,#BLUE_KEY_15
beq BlueKeyElevenAndFifteenButSUB

StepDigit: ; a block in which we can only be in if the expression counter is at #0 or #2.
cmp r0,#BLUE_KEY_00
beq BlueKeyZeroButSeven
cmp r0,#BLUE_KEY_01
beq BlueKeyOneButEight
cmp r0,#BLUE_KEY_02
beq BlueKeyTwoButNine
cmp r0,#BLUE_KEY_04
beq BlueKeyFourButFour
cmp r0,#BLUE_KEY_05
beq BlueKeyFiveButFive
cmp r0,#BLUE_KEY_06
beq BlueKeySixButSix
cmp r0,#BLUE_KEY_08
beq BlueKeyEightButOne
cmp r0,#BLUE_KEY_09
beq BlueKeyNineButTwo
cmp r0,#BLUE_KEY_10
beq BlueKeyTenButThree
cmp r0,#BLUE_KEY_13
beq BlueKeyThirteenButZERO

;StepPlusOrMinusPROXY ---- proxy block to catch errors in step #2 and #3
cmp r0,#BLUE_KEY_03
beq BlueKeyThreeAndSevenButADD
cmp r0,#BLUE_KEY_07
beq BlueKeyThreeAndSevenButADD
cmp r0,#BLUE_KEY_11
beq BlueKeyElevenAndFifteenButSUB
cmp r0,#BLUE_KEY_15
beq BlueKeyElevenAndFifteenButSUB

StepEqual: ;a block in which we can only be in if we are at step #3
cmp r0,#BLUE_KEY_14
beq BlueKeyFourteenButEQUALS

;StepDigitProxy ;another proxy to handle numbers input at step #3
cmp r0,#BLUE_KEY_00
beq BlueKeyZeroButSeven
cmp r0,#BLUE_KEY_01
beq BlueKeyOneButEight
cmp r0,#BLUE_KEY_02
beq BlueKeyTwoButNine
cmp r0,#BLUE_KEY_04
beq BlueKeyFourButFour
cmp r0,#BLUE_KEY_05
beq BlueKeyFiveButFive
cmp r0,#BLUE_KEY_06
beq BlueKeySixButSix
cmp r0,#BLUE_KEY_08
beq BlueKeyEightButOne
cmp r0,#BLUE_KEY_09
beq BlueKeyNineButTwo
cmp r0,#BLUE_KEY_10
beq BlueKeyTenButThree
cmp r0,#BLUE_KEY_13
beq BlueKeyThirteenButZERO

;StepPlusOrMinusPROXY ; another proxy block to handle plus or minus when the user makes a mistake at step #3.
cmp r0,#BLUE_KEY_03
beq BlueKeyThreeAndSevenButADD
cmp r0,#BLUE_KEY_07
beq BlueKeyThreeAndSevenButADD
cmp r0,#BLUE_KEY_11
beq BlueKeyElevenAndFifteenButSUB
cmp r0,#BLUE_KEY_15
beq BlueKeyElevenAndFifteenButSUB

b ReadBlueButtonLoop

;==yeet===
;the blocks in which we light up the 8bit display depending on what button the user has pressed.

BlueKeyZeroButSeven:
mov r5,#7
mov r0,#SegmentA|SegmentB|SegmentC
swi 0x200
cmp r4,#3
beq ErrorMethod
cmp r4,#2
addeq r4,r4,#1
cmp r4,#1
beq ErrorMethod
cmp r4,#0
addeq r4,r4,#1
b ReadBlueButtonLoop

BlueKeyOneButEight:
mov r5,#8
mov r0,#SegmentA|SegmentB|SegmentC|SegmentD|SegmentE|SegmentF|SegmentG
swi 0x200
cmp r4,#3
beq ErrorMethod
cmp r4,#2
addeq r4,r4,#1
cmp r4,#1
beq ErrorMethod
cmp r4,#0
addeq r4,r4,#1
b ReadBlueButtonLoop

BlueKeyTwoButNine:
mov r5,#9
mov r0,#SegmentA|SegmentB|SegmentC|SegmentD|SegmentF|SegmentG
swi 0x200
cmp r4,#3
beq ErrorMethod
cmp r4,#2
addeq r4,r4,#1
cmp r4,#1
beq ErrorMethod
cmp r4,#0
addeq r4,r4,#1
b ReadBlueButtonLoop

BlueKeyThreeAndSevenButADD: ;this block makes use of a bollean counter for r6. We will put #1 in r6 if and only if the user pressed the plus sign.
mov r7,r5
mov r6,#1 ;boolean counter ;make use of this later when the user presses the equals sign.
cmp r4,#3
beq ErrorMethod
cmp r4,#2
beq ErrorMethod
cmp r4,#1
addeq r4,r4,#1
cmp r4,#0
beq ErrorMethod
b ReadBlueButtonLoop

BlueKeyFourButFour:
mov r5,#4
mov r0,#SegmentG|SegmentF|SegmentB|SegmentC
swi 0x200
cmp r4,#3
beq ErrorMethod
cmp r4,#2
addeq r4,r4,#1
cmp r4,#1
beq ErrorMethod
cmp r4,#0
addeq r4,r4,#1
b ReadBlueButtonLoop

BlueKeyFiveButFive:
mov r5,#5
mov r0,#SegmentA|SegmentG|SegmentF|SegmentC|SegmentD
swi 0x200
cmp r4,#3
beq ErrorMethod
cmp r4,#2
addeq r4,r4,#1
cmp r4,#1
beq ErrorMethod
cmp r4,#0
addeq r4,r4,#1
b ReadBlueButtonLoop

BlueKeySixButSix:
mov r5,#6
mov r0,#SegmentA|SegmentG|SegmentF|SegmentC|SegmentD|SegmentE
swi 0x200
cmp r4,#3
beq ErrorMethod
cmp r4,#2
addeq r4,r4,#1
cmp r4,#1
beq ErrorMethod
cmp r4,#0
addeq r4,r4,#1
b ReadBlueButtonLoop

BlueKeyEightButOne:
mov r5,#1
mov r0,#SegmentB|SegmentC
swi 0x200
cmp r4,#3
beq ErrorMethod
cmp r4,#2
addeq r4,r4,#1
cmp r4,#1
beq ErrorMethod
cmp r4,#0
addeq r4,r4,#1
b ReadBlueButtonLoop

BlueKeyNineButTwo:
mov r5,#2
mov r0,#SegmentA|SegmentB|SegmentF|SegmentE|SegmentD
swi 0x200
cmp r4,#3
beq ErrorMethod
cmp r4,#2
addeq r4,r4,#1
cmp r4,#1
beq ErrorMethod
cmp r4,#0
addeq r4,r4,#1
b ReadBlueButtonLoop

BlueKeyTenButThree:
mov r5,#3
mov r0,#SegmentA|SegmentB|SegmentF|SegmentC|SegmentD
swi 0x200
cmp r4,#3
beq ErrorMethod
cmp r4,#2
addeq r4,r4,#1
cmp r4,#1
beq ErrorMethod
cmp r4,#0
addeq r4,r4,#1
b ReadBlueButtonLoop

BlueKeyElevenAndFifteenButSUB:; makes us of a boolean counter again in r6. r6 will have #2 if and only if the user presses the minus sign.
mov r7,r5
mov r6,#2 ;boolean counter ; make use of this later when the user presses the equals sign.
cmp r4,#3
beq ErrorMethod
cmp r4,#2
beq ErrorMethod
cmp r4,#1
addeq r4,r4,#1
cmp r4,#0
beq ErrorMethod
b ReadBlueButtonLoop

BlueKeyTwelveButCLEAR: ;will clear the LCD and the 8bit display if the C button is pressed by the user.
mov r0,#0
mov r4,#0
swi 0x200
swi 0x206
b ReadBlueButtonLoop

BlueKeyThirteenButZERO:
mov r5,#0
mov r0,#SegmentA|SegmentB|SegmentC|SegmentD|SegmentE|SegmentG
swi 0x200
cmp r4,#3
beq ErrorMethod
cmp r4,#2
addeq r4,r4,#1
cmp r4,#1
beq ErrorMethod
cmp r4,#0
addeq r4,r4,#1
b ReadBlueButtonLoop

BlueKeyFourteenButEQUALS:
cmp r4,#3 ;carry on the proper behaviors of an equals button if and only if r3 carries #3
beq EqualsTrue
cmp r4,#2
beq ErrorMethod ; thes rest of these will beq ErrorMethod because the user pressed the equals button in the wrong part of the step process.
cmp r4,#1
beq ErrorMethod
cmp r4,#0
beq ErrorMethod

EqualsTrue: ;user has successfully made it here with no errors.
swi 0x206

cmp r6,#1 ;r6 will hold #1 and will carry on to add and print the solution because they when they pressed plus earlier, we put #1 in r6 to confirm that.
addeq r3,r7,r5
beq PrintAddition

cmp r6,#2 ;same thing as abov, except for subtraction, and we put #2 in r6.
subeq r3,r7,r5
beq SubtractionPurgatory


b ReadBlueButtonLoop


PrintAddition:
mov r0,#3
mov r1,#3
mov r2,r7
swi 0x205
mov r0,#4
mov r2,#'+'
swi 0x207
mov r0,#5
mov r2,r5
swi 0x205
mov r0,#6
mov r2,#'='
swi 0x207
mov r0,#7
mov r2,r3
swi 0x205

;boolean reset because we want a fresh start for the error expression handler, a.k.a. r4
mov r4,#0

b ReadBlueButtonLoop


SubtractionPurgatory: ;Is the answer negative? zero? positive?
cmp r3,#0
blt PrintNegative ; if its less than zero it must mean its negative, so blt PrintNegative.
bgt PrintNormieSubtraction ; if its greather than zero, it must mean its positive so bgt PrintNormieSubtraction
beq PrintNormieSubtraction ; if its equal to zero, it will follow the same rules of PrintNormieSubtraction

PrintNormieSubtraction: ;handles answers that are 0<=
mov r0,#3
mov r1,#3
mov r2,r7
swi 0x205
mov r0,#4
mov r2,#'-'
swi 0x207
mov r0,#5
mov r2,r5
swi 0x205
mov r0,#6
mov r2,#'='
swi 0x207
mov r0,#7
mov r2,r3
swi 0x205

;boolean resets 
mov r4,#0

b ReadBlueButtonLoop

PrintNegative: ; printing the raw negative value from r3 was being wierd. So we had to create this block.
mov r0,#3
mov r1,#3
mov r2,r7
swi 0x205
mov r0,#4
mov r2,#'-'
swi 0x207
mov r0,#5
mov r2,r5
swi 0x205
mov r0,#6
mov r2,#'='
swi 0x207
mov r0,#7
mov r2,#'-' ;the negative sign for a negative answer
swi 0x207
mov r0,#8
b CheckWhatNumber ;hardcoding swaps from negative 1 through negative 9.

BackFromTheDead:
mov r2,r3 ;the digit value for the negative answer.
swi 0x205

;boolean resets
mov r4,#0

b ReadBlueButtonLoop

CheckWhatNumber: ;replaces the raw negative number in the register with its absolute value. The minus sign has already been printed as a character.
cmp r3,#-1
moveq r3,#1
cmp r3,#-2
moveq r3,#2
cmp r3,#-3
moveq r3,#3
cmp r3,#-4
moveq r3,#4
cmp r3,#-5
moveq r3,#5
cmp r3,#-6
moveq r3,#6
cmp r3,#-7
moveq r3,#7
cmp r3,#-8
moveq r3,#8
cmp r3,#-9
moveq r3,#9
b BackFromTheDead

ErrorMethod:
mov r0,#SegmentA|SegmentG|SegmentF|SegmentE|SegmentD
swi 0x200 ;lights up an E on the 8bit display

swi 0x206
mov r0,#2
mov r1,#2
ldr r2,=ErrorMessageOne
swi 0x204
mov r1,#3
ldr r2,=ErrorMessageTwo
swi 0x204 ;The long error messages.

;boolean resets
mov r4,#0

Rloop: ;a Loop that keeps reading inputs from the user and wont reset the calculator until the Clear button is pressed.
swi SWI_CheckBlue 
cmp r0,#BLUE_KEY_12
beq BlueKeyTwelveButCLEAR
b Rloop

b ReadBlueButtonLoop

.data
InstructionsOne: .asciz "Enter an equation using the blue "
InstructionsTwo: .asciz "buttons."
ErrorMessageOne: .asciz "Incorrect sequence of operations. "
ErrorMessageTwo: .asciz "Before proceeding, press the C button."