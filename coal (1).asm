[org 0x0100]
start_program:
call welcome_screen

int 20h

;WELCOME SCREEN VARIABLES
rules_desc: db "Objective: Bounce the ball to destroy all bricks."
rules_score: db "Score: +10 points for breaking cyan or magenta bricks."
rules_score_special: db "Score: +20 for breaking white bricks."
rules_lives: db "Lives: You start with 3 lives."
rules_keys: db "Controls: Left/Right Arrow Keys to move the paddle."
start_prompt: db "Press ENTER to START or ESC to EXIT"
project_members: db "Project by: Amman (24F-0510) & Sania (24F-0546)."
exit_msg: db "Exiting..."


; GAME OBJECT VARIABLES

; BUILDING BRICKS VARIABLES
BRICK_ROWS: equ 4 ; Number of rows of bricks
BRICK_PER_ROW: equ 10 ; Number of bricks in each row
BRICK_WIDTH: equ 7 ; Width of one brick (characters)
BRICK_HEIGHT: equ 1 ; Height of one brick (rows)
BRICK_GAP: equ 1 ; Space between bricks (characters)
BRICK_START_ROW: equ 3 ; Screen row where the bricks start

; 1 = Present, 0 = Broken
brick_map:
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ; Row 1 
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ; Row 2
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ; Row 3
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ; Row 4 

; Colour of bricks
brick_color_map:
;Alternating Magenta (0x0D) and Cyan (0x03) and White (0x0F)
db 0x0D, 0x03, 0x0D, 0x03, 0x0D, 0x03, 0x0D, 0x03, 0x0D, 0x0F
db 0x03, 0x0F, 0x03, 0x0D, 0x03, 0x0D, 0x0F, 0x0D, 0x03, 0x0D
db 0x0F, 0x03, 0x0D, 0x03, 0x0D, 0x03, 0x0D, 0x03, 0x0F, 0x03
db 0x03, 0x0D, 0x0F, 0x0D, 0x03, 0x0D, 0x03, 0x0D, 0x03, 0x0D

; PADDLE VARIABLES
PADDLE_WIDTH: equ 5 ; Width
PADDLE_ROW: equ 23 ; The screen row where the paddle is drawn 

; Stores the current horizontal starting column of the paddle.
PADDLE_START_COL: equ 35

; Dynamic variable to track the paddle's current column position.
current_paddle_col db PADDLE_START_COL

; PADDLE MOVEMENT VARIABLES
SCREEN_WIDTH equ 80 ; Standard screen width
PADDLE_MAX_COL equ 75 ; Max starting column (75 + 5 width = 79, the last column)
PADDLE_MIN_COL equ 1 ; Min starting column (1, the first available column)

; BALL VARIABLES 
BALL_START_ROW: equ 15 ; Initial row far above the paddle for initial drop effect
BALL_START_COL: equ 37 ; Center of the initial paddle position

; Dynamic position
current_ball_row db BALL_START_ROW
current_ball_col db BALL_START_COL

; Velocity (dx, dy) - 1 for move, -1 for move back
ball_vel_x db 0 ; Start with 0 (vertical drop)
ball_vel_y db 1 ; Start with +1 (downward drop)
ball_on_paddle db 1 ; 1: Ball is dropping to paddle, 0: Game is running

; BALL BOUNDARIES
BALL_MIN_COL equ 0 ; Left screen edge (Column 0)
BALL_MAX_COL equ 79 ; Right screen edge (Column 79)
BALL_MIN_ROW equ 0 ; Top screen edge (Row 0)
BALL_MAX_ROW equ 24 ; Bottom screen edge (Row 24)


;  GAME STATE VARIABLES

str_score: db "Score: "
str_lives: db "Lives: "
game_score: dw 0        ; Current Score
game_lives: db 3     ; Start with 3 lives

; BOUNDARY: ball cannot go higher than Row 2
BALL_TOP_LIMIT equ 2

; END SCREEN VARIABLES
msg_win: db "YOU WIN!"               
msg_lose: db "GAME OVER"            
msg_final_score: db "Final Score: "  
bricks_remaining: db 40             

; WELCOME SCREEN FUNCTIONS
welcome_screen:
call clrscr
push 0xb800
pop es

mov ah,0x0D 
mov al,219

;A
mov word[es:980],ax
mov word[es:982],ax
mov word[es:984],ax
mov word[es:986],ax
mov word[es:988],ax
mov word[es:990],ax
mov word[es:992],ax
mov word[es:1140],ax
mov word[es:1152],ax
mov word[es:1300],ax
mov word[es:1312],ax
mov word[es:1460],ax
mov word[es:1462],ax
mov word[es:1464],ax
mov word[es:1466],ax
mov word[es:1468],ax
mov word[es:1470],ax
mov word[es:1472],ax
mov word[es:1620],ax
mov word[es:1632],ax
mov word[es:1780],ax
mov word[es:1792],ax
mov word[es:1940],ax
mov word[es:1952],ax
;T
mov word[es:996],ax
mov word[es:998],ax
mov word[es:1000],ax
mov word[es:1002],ax
mov word[es:1004],ax
mov word[es:1006],ax
mov word[es:1008],ax
mov word[es:1162],ax
mov word[es:1322],ax
mov word[es:1482],ax
mov word[es:1642],ax
mov word[es:1802],ax
mov word[es:1962],ax
;A
mov word[es:1012],ax
mov word[es:1014],ax
mov word[es:1016],ax
mov word[es:1018],ax
mov word[es:1020],ax
mov word[es:1022],ax
mov word[es:1024],ax
mov word[es:1172],ax
mov word[es:1184],ax
mov word[es:1332],ax
mov word[es:1344],ax
mov word[es:1492],ax
mov word[es:1494],ax
mov word[es:1496],ax
mov word[es:1498],ax
mov word[es:1500],ax
mov word[es:1502],ax
mov word[es:1504],ax
mov word[es:1652],ax
mov word[es:1664],ax
mov word[es:1812],ax
mov word[es:1824],ax
mov word[es:1972],ax
mov word[es:1984],ax
;R
mov word[es:1028],ax
mov word[es:1030],ax
mov word[es:1032],ax
mov word[es:1034],ax
mov word[es:1036],ax
mov word[es:1038],ax
mov word[es:1040],ax
mov word[es:1188],ax
mov word[es:1200],ax
mov word[es:1348],ax
mov word[es:1360],ax
mov word[es:1508],ax
mov word[es:1510],ax
mov word[es:1512],ax
mov word[es:1514],ax
mov word[es:1516],ax
mov word[es:1518],ax
mov word[es:1520],ax
mov word[es:1668],ax
mov word[es:1670],ax
mov word[es:1672],ax
mov word[es:1828],ax
mov word[es:1834],ax
mov word[es:1836],ax
mov word[es:1988],ax
mov word[es:1998],ax
mov word[es:2000],ax
;I
mov word[es:1044],ax
mov word[es:1046],ax
mov word[es:1048],ax
mov word[es:1050],ax
mov word[es:1052],ax
mov word[es:1054],ax
mov word[es:1056],ax
mov word[es:1210],ax
mov word[es:1370],ax
mov word[es:1530],ax
mov word[es:1690],ax
mov word[es:1850],ax
mov word[es:2004],ax
mov word[es:2006],ax
mov word[es:2008],ax
mov word[es:2010],ax
mov word[es:2012],ax
mov word[es:2014],ax
mov word[es:2016],ax

mov ah,0X03
mov al,'B'
mov word[es:2020],ax
mov al,'R'
mov word[es:2022],ax
mov al,'E'
mov word[es:2024],ax
mov al,'A'
mov word[es:2026],ax
mov al,'K'
mov word[es:2028],ax
mov al,'O'
mov word[es:2030],ax
mov al,'U'
mov word[es:2032],ax
mov al,'T'
mov word[es:2034],ax
call print_rules
ret

print_rules:
; Print Rules Description
mov di,2270
push di
mov cx,49
mov si,rules_desc
mov dh,0x03
call print_string
pop di

; Print Score Rule 
add di,160
push di
mov cx,54
mov si,rules_score
mov dh,0x0D
call print_string
pop di

; Print Special Score Rule 
add di,160
push di
mov cx,37
mov si,rules_score_special
mov dh,0x03
call print_string
pop di

; Print Lives Rule
add di,160
push di
mov cx,30
mov si,rules_lives
mov dh,0x0D
call print_string
pop di

; Print Controls Rule 
add di,160
push di
mov cx,51
mov si,rules_keys
mov dh,0x03
call print_string
pop di

add di,160
push di
mov cx, 48
mov si,project_members
mov dh,0x0D
call print_string
pop di

; Print Start Prompt
add di,320
mov cx,35
mov dh,0x07
mov si,start_prompt
call print_string

; Wait for key press. AL will return 1 (Start) or 0 (Exit)
call wait_for_start_exit
cmp al, 1
je start_game_proc ; If AL=1, jump to start the game
jmp exit_program_proc ; If AL=0, jump to exit the program
ret

print_string:
push ax
push dx
loop_print_string:
mov al,[si] 
mov ah, dh
mov word [es:di], ax 
inc si
add di, 2
loop loop_print_string
pop dx
pop ax
ret

wait_for_start_exit:
wait_key:
mov ah, 00h ; Wait for key press
int 16h ; AX now holds key code

cmp al, 0x0D ; Check if ASCII code is 0x0D 
jz do_start_game

cmp al, 0x1B ; Check if ASCII code is 0x1B
jz do_exit_program

jmp wait_key

do_start_game:
mov al, 1 
ret 

do_exit_program:
mov al, 0
ret 

; GAME START / EXIT PROCEDURES
start_game_proc:

call clrscr
call draw_bricks
call draw_paddle 
call draw_ball
call wait_for_any_key
jmp game_loop
ret

exit_program_proc:
call clrscr
mov di,1494
mov cx,10
mov si,exit_msg
mov dh,0x70
call print_string

mov ax,0x4c00
int 0x21

wait_for_any_key:
mov ah, 00h
int 16h
ret

; BALL & PADDLE MOVEMENT FUNCTIONS
clear_ball_old_pos:
pusha
push es

push 0xb800
pop es 

; 1. Calculate offset
mov al, [current_ball_row]
mov ah, 0
mov bl, 80
mul bl
mov di, ax
shl di, 1 
mov al, [current_ball_col]
mov ah, 0
shl ax, 1 
add di, ax 

; 2. Erase the ball 
mov word [es:di], 0x0720 
pop es
popa
ret


move_ball:
pusha

; Update Y position
mov al, [current_ball_row]
mov bl, [ball_vel_y]
add al, bl
mov [current_ball_row], al

; Update X position
mov al, [current_ball_col]
mov bl, [ball_vel_x]
add al, bl
mov [current_ball_col], al

popa
ret

; Checks for collision with walls and paddle
check_wall_collision:
    pusha

    ; 1. Check Top Wall 
    mov al, [current_ball_row]
    cmp al, BALL_TOP_LIMIT   ; Check against Row 2
    jle reverse_y_velocity   ; Bounce if <= 2

    ; 2. Check Bottom Wall 
    cmp al, BALL_MAX_ROW
    jge lose_life_routine   

    ; 3. Check Paddle Collision
    mov bl, PADDLE_ROW
    dec bl
    cmp al, bl
    je check_paddle_hit

    ; 4. Check Left/Right Wall 
    mov al, [current_ball_col]
    cmp al, BALL_MIN_COL
    jle reverse_x_velocity
    cmp al, BALL_MAX_COL
    jge reverse_x_velocity

    jmp end_wall_check

lose_life_routine:
    ; 1. Decrease Lives
    dec byte [game_lives]
   
    ; 2. update
    call draw_hud

    ; 3. Check for Game Over
    cmp byte [game_lives], 0
    je jump_to_lose_screen      ; Jump to the End Screen handler


    ; RESET PADDLE POSITION
    call clear_paddle_old_pos       ; Erase paddle from current spot
    mov byte [current_paddle_col], PADDLE_START_COL ; Reset variable to 35
    call draw_paddle                ; Draw it at the center

    ; 4. Reset Ball and State for Respawn
    call clear_ball_old_pos         ; Erase ball
    mov byte [current_ball_row], 15
    mov byte [current_ball_col], 37
    mov byte [ball_vel_x], 0
    mov byte [ball_vel_y], 1
    mov byte [ball_on_paddle], 1    ; Set state to drop
   
    jmp end_wall_check


; GO TO GAME OVER SCREEN

jump_to_lose_screen:
    popa                    
    jmp show_lose_screen    ; Jump to the "GAME OVER" screen 
   
do_game_over_jump:
    popa              
    jmp exit_program_proc

reverse_y_velocity:
    mov al, [ball_vel_y]
    neg al
    mov [ball_vel_y], al
    jmp end_wall_check

reverse_x_velocity:
    mov al, [ball_vel_x]
    neg al
    mov [ball_vel_x], al
    jmp end_wall_check


; PADDLE HIT LOGIC

check_paddle_hit:
    mov al, [current_ball_col]      ; Ball X
    mov bl, [current_paddle_col]    ; Paddle Start X

    ; 1. Check if Ball is strictly within the Paddle's width
    cmp al, bl
    jl end_wall_check               ; Too far left (Miss)

    mov cl, bl
    add cl, PADDLE_WIDTH
    cmp al, cl
    jge end_wall_check              ; Too far right (Miss)
   
    ; 2. COLLISION CONFIRMED - PLAY SOUND
    call beep_sound             

    ; 3. CALCULATE ANGLE
    ; Offset = Ball_X - Paddle_Start_X
    sub al, bl               ; AL is now 0, 1, 2, 3, or 4

    ; CHECK CENTER (Offset 2)
    cmp al, 2
    je bounce_straight

    ; CHECK LEFT (Offset < 2)
    cmp al, 2
    jl bounce_left_side

    ; CHECK RIGHT (Offset > 2) 
    jmp bounce_right_side

bounce_straight:
    mov byte [ball_vel_x], 0   ; X = 0 (Vertical / 90 Degrees)
    mov byte [ball_vel_y], -1  ; Y = -1 (Up)
    jmp end_wall_check

bounce_left_side:
    mov byte [ball_vel_x], -1  ; X = -1 (Left)
    mov byte [ball_vel_y], -1  ; Y = -1 (Up)
    jmp end_wall_check

bounce_right_side:
    mov byte [ball_vel_x], 1   ; X = 1 (Right)
    mov byte [ball_vel_y], -1  ; Y = -1 (Up)
    jmp end_wall_check

end_wall_check:
    popa
    ret

; BRICK COLLISION FUNCTION

check_brick_collision:
    pusha
    push es
    push 0xb800
    pop es          

    mov si, 0       

    ; Outer loop setup (Rows)
    mov bx, BRICK_ROWS
    mov di, 480     ; Start at Row 3

loop_row1:
    push bx         ; Save Row counter
    push di         ; Save Row start offset

    ; Middle loop setup (Bricks per row)
    mov dx, BRICK_PER_ROW
    add di, 2       

loop_col1:
    push dx         ; Save Brick counter

    ; Check map first
    cmp byte [brick_map + si], 1
    jne skip_brick_scan

    ; 1. Brick exists. Scan pixels for collision
    push si         ; Save Map Index
    push di         ; Save Screen Offset

    mov cx, BRICK_WIDTH
    mov ax, 0x0720  ; Check for Space (Empty)

loop_char_check:
    cmp word [es:di], ax
    je visual_hit   ; Collision detected

    add di, 2
    loop loop_char_check

    ; No hit detected in this brick
    pop di
    pop si
    jmp skip_brick_scan_cleanup

visual_hit:
    ; Collision detected!
    pop di
    pop si

    ; 1. Destroy Brick in Map
    mov byte [brick_map + si], 0
   
    ; 2. Score Logic
    cmp byte [brick_color_map + si], 0x0F
    je give_bonus_score
    add word [game_score], 10
    jmp score_done

give_bonus_score:
    add word [game_score], 20

score_done:
    call beep_sound

    ; 3. Win Condition Check
    dec byte [bricks_remaining]
    cmp byte [bricks_remaining], 0
    je jump_to_win_screen      

    ; 4. Reverse Ball
    mov byte [ball_vel_y], -1
    call reverse_ball_y_direction

    ; Proceed to cleanup
    jmp skip_brick_scan_cleanup

jump_to_win_screen:
    popa
    pop es
    jmp show_win_screen

skip_brick_scan_cleanup:

skip_brick_scan:
    ; Advance to next brick position
    add di, 16      ; (BRICK_WIDTH + GAP) * 2

    inc si          ; Next map index
    pop dx          ; Restore brick counter
    dec dx
    jnz loop_col1   ; Next brick in row

    ; Move to the next row
    pop di          ; Restore row start
    add di, 320     ; Move down one line
    pop bx          ; Restore row counter
    dec bx
    jnz loop_row1   ; Next row

exit_collision_check:
    pop es
    popa
    ret

; BALL REVERSAL ROUTINE
reverse_ball_y_direction:
; Reverses Y direction 
push ax ; Preserve AX since we are inside another procedure (check_brick_collision)
mov al, [ball_vel_y]
neg al
mov [ball_vel_y], al
pop ax
ret

; DRAWING FUNCTIONS
;DRAW BALL FUNCTION
draw_ball:
pusha
push es

push 0xb800
pop es 

; 1. Calculate row offset: (current_ball_row * 80 * 2)
mov al, [current_ball_row] ; AL = Y position
mov ah, 0
mov bl, 80
mul bl ; AX = Y * 80
mov di, ax ; DI = Y * 80 (cells)
shl di, 1 ; DI = Y * 80 * 2 (bytes)

; 2. Calculate column offset: (current_ball_col * 2)
mov al, [current_ball_col] ; AL = X position
mov ah, 0
shl ax, 1 ; AX = X * 2 (bytes)
add di, ax ; DI = Total offset

mov ah, 0x0E 
mov al, 0x0F 

; 3. Draw the ball
mov word [es:di], ax

pop es
popa
ret

; DRAW PADDLE FUNCTION
draw_paddle:
pusha
push es

push 0xb800
pop es 

; 1. Calculate base row offset: (PADDLE_ROW * 80 * 2)
mov ax, PADDLE_ROW
mov bl, 80
mul bl
mov di, ax
shl di, 1 ; DI = offset for screen row 23

; 2. Calculate column offset: (current_paddle_col * 2)
mov al, [current_paddle_col]
mov ah, 0
shl ax, 1
add di, ax ; DI = Paddle start offset


mov ah, 0x03
mov al, 0x5F 

; 3. Draw the paddle 
mov cx, PADDLE_WIDTH
loop_draw_paddle:
mov word [es:di], ax
add di, 2
loop loop_draw_paddle

pop es
popa
ret

; BUILDING BRICKS FUNCTION
draw_bricks:
pusha
push es
push 0xb800
pop es 

mov si, 0 

; Outer loop setup (Rows)
mov cx, BRICK_ROWS ; CX = 4 (Total rows)
mov di, 480 

loop_row:
push cx ; Save outer CX (Row counter)
push di ; Save DI (Start offset for the current row)

; Inner loop setup (Bricks per row)
mov bx, BRICK_PER_ROW ; BX = 10 (Bricks per row)


add di, 2

loop_col:
push bx ; Save inner BX (Brick counter)

cmp byte [brick_map + si], 1

; If brick is NOT 1 (absent/destroyed), jump to clear drawing logic
jne brick_draw_clear

;BRICK EXISTS

brick_draw_solid:
mov ah, [brick_color_map + si] ; AH = Color Attribute for this specific brick
mov al, 219 ; AL = Solid Block Character (0xDB)

push ax ; Save the drawing word [AH|AL]
push di ; Save DI position before drawing

mov cx, BRICK_WIDTH ; CX = 7 (Drawing loop counter)

loop_draw_solid:
mov word [es:di], ax ; Write color/char word (using AX)
add di, 2 ; Move to the next character cell
loop loop_draw_solid

pop di
pop ax


jmp brick_advance_pointer


; BRICK MISSING

brick_draw_clear:

mov ax, 0x0720 

push ax 
push di 

mov cx, BRICK_WIDTH

loop_draw_clear:
mov word [es:di], ax 
add di, 2 
loop loop_draw_clear

pop di 
pop ax 

brick_advance_pointer:
; 4. Advance DI to the next brick's starting column
; (BRICK_WIDTH + BRICK_GAP) * 2 bytes = (7 + 1) * 2 = 16 bytes
add di, 16 ; DI = DI + 16 (next brick start)

inc si ; Next index in brick_map/color_map

pop bx ; Restore BX (brick counter)
dec bx
jnz loop_col ; Loop 10 times

; 5. Move to the next row
pop di ; Restore DI to the row start
mov dx, 320 ; DI = DI + 160 (next screen row)
add di, dx

pop cx ; Restore row counter (CX)
loop loop_row ; Loop 4 times

pop es
popa ; Restore all general registers
ret


; GAME LOOP & SPEED CONTROL FUNCTIONS

game_loop:
    call handle_paddle_movement

    cmp byte [ball_on_paddle], 1
    je initial_drop_sequence

    call clear_ball_old_pos
    call move_ball
    call check_wall_collision  
    call check_brick_collision 
    call draw_bricks
    call draw_ball
    call draw_hud              

    mov cx, 15
  
game_delay_loop:
    push cx           
   
    call handle_paddle_movement  
    call ball_delay_short        
    pop cx         
    loop game_delay_loop

    jmp game_loop

initial_drop_sequence:
    call clear_ball_old_pos
    call move_ball

    ; 1. Check if ball hit the bottom 
    mov al, [current_ball_row]
    cmp al, BALL_MAX_ROW
    jge drop_missed_paddle    ; If it hit the floor, go to death logic

    ; 2. Check if ball is at Paddle Height 
    cmp al, PADDLE_ROW - 1
    jne continue_drop_loop    ; If not at paddle height, keep falling

    ; 3. HORIZONTAL COLLISION CHECK
    mov al, [current_ball_col]      ; Ball X
    mov bl, [current_paddle_col]    ; Paddle Left X
   
    cmp al, bl
    jl continue_drop_loop           ; Ball is to the LEFT of paddle -> Miss -> Keep falling
   
    add bl, PADDLE_WIDTH            ; Paddle Right X
    cmp al, bl
    jge continue_drop_loop          ; Ball is to the RIGHT of paddle -> Miss -> Keep falling

    ; 4. If we passed those checks, we hit the paddle!
    jmp start_main_game

continue_drop_loop:
    call draw_ball

    ; RESPONSIVE DELAY LOOP 

    mov cx, 15
drop_delay_loop:
    push cx
    call handle_paddle_movement
    call ball_delay_short
    pop cx
    loop drop_delay_loop
   
    jmp game_loop


; DEATH HANDLER FOR INITIAL DROP
drop_missed_paddle:
    dec byte [game_lives]      
    call draw_hud               

    ; Check for Game Over
    cmp byte [game_lives], 0
    je jump_to_lose_screen_drop ; Jump to Game Over Screen

    ;RESET PADDLE TO CENTER
    call clear_paddle_old_pos
    mov byte [current_paddle_col], PADDLE_START_COL
    call draw_paddle

    ; RESET BALL POSITION 
    mov byte [current_ball_row], 15
    mov byte [current_ball_col], 37
   
    jmp game_loop

jump_to_lose_screen_drop:
    jmp show_lose_screen



exit_program_jump_drop:
    jmp exit_program_proc

; START GAME LOGIC 

start_main_game:
    mov byte [ball_on_paddle], 0 

    ; Calculate collision offset (Ball X - Paddle X)
    mov al, [current_ball_col]
    sub al, [current_paddle_col] ; AL will be 0, 1, 2, 3, or 4

    ; CHECK CENTER (Offset 2)
    cmp al, 2
    je set_start_straight

    ;CHECK LEFT (Offset < 2) 
    cmp al, 2
    jl set_start_left

    ;CHECK RIGHT (Offset > 2) 
    jmp set_start_right

set_start_straight:
    mov byte [ball_vel_x], 0   ; 90 Degrees (No X movement)
    mov byte [ball_vel_y], -1  ; Up
    jmp game_loop

set_start_left:
    mov byte [ball_vel_x], -1  ; Left
    mov byte [ball_vel_y], -1  ; Up
    jmp game_loop

set_start_right:
    mov byte [ball_vel_x], 1   ; Right
    mov byte [ball_vel_y], -1  ; Up
    jmp game_loop


ball_delay_short:
    mov cx, 0x4000      
                      
short_delay:
    loop short_delay
    ret

paddle_delay:
mov dx, 0x0001
mov cx, 0x01 ; Paddle Speed Control
delay_loop_paddle:
loop delay_loop_paddle
ret

; Erases the paddle at its current position (before updating position)
clear_paddle_old_pos:
pusha
push es

push 0xb800
pop es

; 1. Calculate base row offset: (PADDLE_ROW * 80 * 2) - Same as draw_paddle
mov ax, PADDLE_ROW
mov bl, 80
mul bl
mov di, ax
shl di, 1

; 2. Calculate column offset: (current_paddle_col * 2)
mov al, [current_paddle_col]
mov ah, 0
shl ax, 1
add di, ax ; DI = Paddle start offset

; 3. Prepare the drawing word: White on Black Space (0x0720) to erase
mov ax, 0x0720 ; White text on Black BG (0x07), Space char (0x20)
mov bp, ax ; Use BP to hold the erase word

; 4. Clear the paddle area (PADDLE_WIDTH = 5 characters)
mov cx, PADDLE_WIDTH
loop_clear_paddle:
mov word [es:di], bp ; Write erase word
add di, 2
loop loop_clear_paddle

pop es
popa
ret

; Handles checking for Left/Right arrow keys and updates the paddle position
handle_paddle_movement:
pusha

mov ah, 01h ; Check keyboard buffer (Non-blocking)
int 16h
jz end_handle_movement ; Jump if no key pressed (ZF=1)

; Key is pressed, read it to clear the buffer and get the codes
mov ah, 00h ; Read key press
int 16h ; AX = [AH:Scan Code, AL:ASCII]

cmp al, 0x00 ; Extended key check
jnz check_ascii_keys

; Extended key check (Left/Right Arrow)
cmp ah, 4Bh ; Left Arrow (Scan Code 4Bh)
je paddle_move_left

cmp ah, 4Dh ; Right Arrow (Scan Code 4Dh)
je paddle_move_right

jmp end_handle_movement

check_ascii_keys:
cmp al, 0x1B ; Check for ESC (0x1B)
je exit_game_loop

jmp end_handle_movement

exit_game_loop:
popa
call exit_program_proc
ret

paddle_move_left:
mov bl, [current_paddle_col]

cmp bl, PADDLE_MIN_COL
jle end_handle_movement


call clear_paddle_old_pos
dec byte [current_paddle_col]
call draw_paddle

jmp end_handle_movement

paddle_move_right:
mov bl, [current_paddle_col]

cmp bl, PADDLE_MAX_COL
jge end_handle_movement


call clear_paddle_old_pos
inc byte [current_paddle_col]
call draw_paddle


end_handle_movement:
popa
ret


; END SCREEN FUNCTIONS
show_win_screen:
    call clrscr
   
    call play_win_sound   

    push 0xb800
    pop es

    mov di, 1672
    mov si, msg_win
    mov cx, 8
    mov ah, 0x0D
    call print_string_fixed

    jmp print_final_score

show_lose_screen:
    call clrscr
    call play_lose_sound 

    push 0xb800
    pop es
    mov di, 1670
    mov si, msg_lose
    mov cx, 9
    mov ah, 0x0D
    call print_string_fixed

    jmp print_final_score

print_final_score:
  
    mov di, 1984
    mov si, msg_final_score
    mov cx, 13
    mov ah, 0x03       
    call print_string_fixed

    
    mov ax, [game_score]
    call print_number_colored


wait_exit:
    mov ah, 00h
    int 16h
    cmp al, 0x0D ; Enter
    je final_exit
    cmp al, 0x1B ; Esc
    je final_exit
    jmp wait_exit

final_exit:
    mov ax, 0x4c00
    int 0x21

; END SCREEN HELPERS

print_string_fixed:
print_str_loop:
    mov al, [si]
    mov word [es:di], ax 
    add di, 2
    inc si
    loop print_str_loop
    ret

print_number_colored:
    push ax
    push bx
    push cx
    push dx
    push di
   
    mov bx, 10
    mov cx, 0
   
    cmp ax, 0
    jne split_digits_col
    mov word [es:di], 0x0330 
    jmp end_print_num_col

split_digits_col:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne split_digits_col

print_digits_loop_col:
    pop dx
    add dl, 0x30
    mov dh, 0x03   
    mov [es:di], dx
    add di, 2
    loop print_digits_loop_col

end_print_num_col:
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; UTILITY FUNCTIONS
clrscr:
push es
push ax
push cx
push di

mov ax, 0xb800 
mov es, ax
xor di, di 

mov ax, 0x0720 
mov cx, 2000 
cld 
rep stosw

pop di
pop cx
pop ax
pop es
ret


; HUD DRAWING FUNCTIONS
draw_hud:
    pusha
    push es
    push 0xb800
    pop es

    ;PRINT "SCORE: " 
    mov di, 0          
    mov si, str_score
    mov cx, 7           
   
  
    mov ah, 0x0D        

print_score_label:
    mov al, [si]
    mov [es:di], ax
    add di, 2
    inc si
    loop print_score_label

    ; PRINT ACTUAL SCORE NUMBER 
    mov ax, [game_score]
    call print_number   
    ;PRINT "LIVES: " 
    mov di, 120         ; Near right side (Col 60 * 2)
    mov si, str_lives
    mov cx, 7           
   
    mov ah, 0x0D        

print_lives_label:
    mov al, [si]
    mov [es:di], ax
    add di, 2
    inc si
    loop print_lives_label

    mov al, [game_lives]
    mov ah, 0
    call print_number

  
    mov di, 160         
    mov cx, 80
    mov ax, 0x08CD 
draw_hud_line:
    mov [es:di], ax
    add di, 2
    loop draw_hud_line

    pop es
    popa
    ret

print_number:
    push ax
    push bx
    push cx
    push dx
    push di
   
    mov bx, 10
    mov cx, 0
   
    cmp ax, 0
    jne split_digits
   
   
    mov word [es:di], 0x0D30
    jmp end_print_num

split_digits:
    xor dx, dx
    div bx          
    push dx        
    inc cx          
    cmp ax, 0
    jne split_digits

print_digits_loop:
    pop dx
    add dl, 0x30    
   
    mov dh, 0x0D    
   
    mov [es:di], dx
    add di, 2
    loop print_digits_loop

end_print_num:
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret


; SOUND FUNCTION
beep_sound:
    pusha

    ; 1. Initialize the PIT for sound
    mov al, 182         ; Command to set up the speaker
    out 0x43, al
   
    ; 2. Set Frequency (Pitch)
    mov ax, 0x0500      ; Lower value = Higher Pitch
    out 0x42, al        ; Send Low Byte
    mov al, ah
    out 0x42, al        ; Send High Byte

    ; 3. Turn Speaker ON
    in al, 0x61         ; Get current state of port 61h
    or al, 0x03         ; Set bits 0 and 1 to turn on speaker
    out 0x61, al

    ; 4. Delay (Duration of the Beep)
    mov cx, 0x2000      
beep_delay_loop:
    loop beep_delay_loop

    ; 5. Turn Speaker OFF
    in al, 0x61
    and al, 0xFC        ; Clear bits 0 and 1 to turn off speaker
    out 0x61, al

    popa
    ret

; SPECIAL SOUND EFFECTS

play_lose_sound:
    pusha
   
    ; 1. Setup PIT
    mov al, 182
    out 0x43, al

    ; 2. Turn Speaker ON
    in al, 0x61
    or al, 0x03
    out 0x61, al

    ; 3. Start Frequency (High pitch)
    mov bx, 2000

lose_sound_loop:
    ; Send Frequency (BX)
    mov ax, bx
    out 0x42, al    ; Low byte
    mov al, ah
    out 0x42, al    ; High byte

    ; Short Delay per step
    mov cx, 2000    
    loop_lose_delay:
    loop loop_lose_delay

    ; Decrease Pitch (Increase Divisor)
    add bx, 30      ; The step size (makes it slide)
    cmp bx, 6000    ; End Frequency (Low pitch)
    jl lose_sound_loop

    ; 4. Turn Speaker OFF
    in al, 0x61
    and al, 0xFC
    out 0x61, al

    popa
    ret

play_win_sound:
    pusha
   
    ; 1. Setup PIT
    mov al, 182
    out 0x43, al

    ; 2. Turn Speaker ON
    in al, 0x61
    or al, 0x03
    out 0x61, al

    ; Note 1 (Low)
    mov ax, 4000    ; Divisor (Lower pitch)
    out 0x42, al
    mov al, ah
    out 0x42, al
   
    mov cx, 0x4000  ; Duration
    win_delay_1:
    loop win_delay_1

    ; Note 2 (Mid)
    mov ax, 3000    ; Divisor (Higher pitch)
    out 0x42, al
    mov al, ah
    out 0x42, al
   
    mov cx, 0x4000  ; Duration
    win_delay_2:
    loop win_delay_2

    ; Note 3 (High) 
    mov ax, 2000    ; Divisor (Highest pitch)
    out 0x42, al
    mov al, ah
    out 0x42, al
   
    mov cx, 0x8000  ; Longer Duration for the last note
    win_delay_3:
    loop win_delay_3

    ; 3. Turn Speaker OFF
    in al, 0x61
    and al, 0xFC
    out 0x61, al

    popa
    ret
