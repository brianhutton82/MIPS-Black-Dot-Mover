# ----- PRINT STRING MACRO ----- #
.macro print_str %str
	.data
		msg: .asciiz %str
	.text
		la a0, msg
		li v0, 4
		syscall
.end_macro


# ----- CONSTANTS ----- #
.eqv GREEN 0x00ff00
.eqv BLACK 0x000000
.eqv SCREEN_SIZE 4096
.eqv CHAR_ORIGIN 16128
.eqv VERTICAL_UNIT 256


# ----- ADDRESS TO WRITE TO BITMAP DISPLAY  ----- #
.data
	displayAddress: .word 0x10008000
	charPos: .word 16128


# ----- MAIN FUNCTION ----- #
.text
.globl main
main:
	_main_loop:
		jal paint_bg_green
		jal paint_char_origin
		jal get_input
		jal print_newline
		j _main_loop


# ----- PRINT NEWLINE FUNCTION ----- #
print_newline:
	push ra
	li a0, '\n'
	li v0, 11
	syscall
	pop ra
	jr ra
	

# ----- PAINT CHAR ORIGIN ----- #
paint_char_origin:
	push ra
	push s0
	lw t0, displayAddress
	lw t1, charPos
	li t2, BLACK
	add t0, t0, t1
	sw t2, (t0)
	pop s0
	pop ra
	jr ra


# ----- PAINT BACKGROUND -----#
paint_bg_green:
	push ra
	push s0
	lw t0, displayAddress
	li s0, 0
	_loop:
		mul t1, s0, 4
		add t1, t1, t0
		li t2, GREEN
		sw t2, (t1)
		add s0, s0, 1
		blt s0, SCREEN_SIZE, _loop
	pop s0
	pop ra
	jr ra


# ----- MOVE CHAR LEFT ----- #
move_left:
	push ra
	
	# get address of char current position on display
	lw t0, displayAddress
	lw t1, charPos
	add t0, t0, t1
	
	# paint chars old position green
	li t2, GREEN
	sw t2, (t0)
	
	# paint chars new position black
	sub t0, t0, 4
	li t2, BLACK
	sw t2, (t0)
	
	# update charPos variable
	lw t0, charPos
	sub t0, t0 4
	sw t0, charPos
	
	pop ra
	jr ra


# ----- MOVE CHAR RIGHT ----- #
move_right:
	push ra

	# get address of char current position on display
	lw t0, displayAddress
	lw t1, charPos
	add t0, t0, t1
	
	# paint chars old position green
	li t2, GREEN
	sw t2, (t0)
	
	# paint chars new position black
	add t0, t0, 4
	li t2, BLACK
	sw t2, (t0)
		
	# update charPos variable
	lw t0, charPos
	add t0, t0, 4
	sw t0, charPos
			
	pop ra
	jr ra


# ----- MOVE CHAR DOWNWARD ----- #
move_down:
	push ra
	
	# get address of char current position on display
	lw t0, displayAddress
	lw t1, charPos
	add t0, t0, t1
	
	# paint chars old position green
	li t2, GREEN
	sw t2, (t0)
	
	# paint chars new position black
	add t0, t0, VERTICAL_UNIT
	li t2, BLACK
	sw t2, (t0)
	
	# update charPos variable
	lw t0, charPos
	add t0, t0, VERTICAL_UNIT
	sw t0, charPos
	
	pop ra
	jr ra
	

# ----- MOVE CHAR UPWARD ----- #
move_up:
	push ra
	lw t0, displayAddress
	lw t1, charPos
	add t0, t0, t1 # t0 = address where char is

	# paint chars current position green	
	li t2, GREEN
	sw t2, (t0)
	
	# move char up one and paint char in new pos
	sub t0, t0, VERTICAL_UNIT
	li t2, BLACK
	sw t2, (t0)
	
	# update charPos variable
	lw t0, charPos
	sub t0, t0, VERTICAL_UNIT
	sw t0, charPos
	
	pop ra
	jr ra


# ----- GET USER INPUT ----- #
get_input:
	push ra
	print_str "Enter direction to move (w=UP, a=LEFT, s=DOWN, d=RIGHT, q=QUIT): "
	
	# read char is syscall 12
	li v0, 12
	syscall
	
	# process input
	beq v0, 'w', _up
	beq v0, 's', _down
	beq v0, 'a', _left
	beq v0, 'd', _right
	beq v0, 'q', _quit
	
	_up:
		jal move_up
		j _end
	_down:
		jal move_down
		j _end
	_left:
		jal move_left
		j _end
	_right:
		jal move_right
		j _end
	_quit:
		print_str "\n----- GOODBYE! -----\n"
		li v0, 10
		syscall
	_end:
	pop ra
	jr ra