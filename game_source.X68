*-----------------------------------------------------------
* Written by : Adam Dowling
* Date       : 26/02/25
* Description: Assembly game with the theme of small world. Follows a bird trying to find its flock
* Known Bugs : Won't exit program when health goes to 0
*              At prey choice, health goes too high   
*              Loose too much health in hard mode         
*-----------------------------------------------------------
    ORG $1000

EXIT            EQU 0           ; 0 = exit
EASY_MODE       EQU 1           ; 1 = easy 
HARD_MODE       EQU 2           ; 2 =hard
HEALTH_EASY     EQU 100         ; Health in easy mode
HEALTH_HARD     EQU 50          ; Health in hard mode
BRAVERY_GAIN    EQU 10          ; Bravery points
HEALTH_LOSS_EASY EQU 33         ; 33.4 health loss in easy mode
HEALTH_LOSS_HARD EQU 25         ; 50 health loss in hard mode

* MEMORY
HEALTH          EQU $4000       ; Memory for health
BRAVERY_POINTS  EQU $4001       ; Memory for bravery points
MODE            EQU $4002       ; Memory for game mode

* START OF GAME
START:
    BSR     WELCOME        
    BSR     SELECT_MODE         ; Select easy or hard mode
    BSR     INIT_GAME           ; Based on what mode will be played
    BSR     GAME                ; Start loop

* GAME LOOP
GAME:
    BSR     STORY_INTRO     
    BSR     PLAYER_CHOICE_1     ; First decision
    BSR     UPDATE_STATUS       ; Update health and bravery points
    BSR     HUD                 ; Display heads-up display
    BSR     PLAYER_CHOICE_2     ; Second decision
    BSR     UPDATE_STATUS    
    BSR     HUD          
    BSR     PLAYER_CHOICE_3     ; Third decision 
    BSR     UPDATE_STATUS  
    BSR     HUD           
    BSR     PLAYER_CHOICE_4     ; Fourth decision
    BSR     UPDATE_STATUS      
    BSR     HUD              
    BSR     PLAYER_CHOICE_5     ; Fifth decision
    BSR     UPDATE_STATUS    
    BSR     HUD           
    BSR     CHECK_GAME_OVER 
    BSR     REPLAY              ; Ask to replay or exit
    RTS                         ; Return
END:
    SIMHALT        

* WELCOME SUBROUTINE
WELCOME:
    BSR     ENDL                ; Print a new line
    LEA     WELCOME_MSG,A1      ; Load welcome message in address register A1
    MOVE.B  #14,D0    
    TRAP    #15                 ; Print the message
    BSR     ENDL             
    RTS                         ; Return

SELECT_MODE:
    BSR     ENDL             
    LEA     MODE_MSG,A1         ; Load MODE_MSG into address register A1
    MOVE.B  #14,D0  
    TRAP    #15                 ; Print the message
    MOVE.B  #4,D0               ; Set trap for input
    TRAP    #15         
    CMP.B   #EASY_MODE,D1       ; Check if game is easy
    BEQ     SET_EASY            ; If yes -> Easy Mode
    CMP.B   #HARD_MODE,D1    
    BEQ     SET_HARD            ; If yes -> Hard Mode
    BRA     SELECT_MODE         ; Wrong input

SET_EASY:
    MOVE.B  #EASY_MODE,MODE     ; Set mode to easy
    RTS                   

SET_HARD:
    MOVE.B  #HARD_MODE,MODE     ; Set mode to hard
    RTS                  

INIT_GAME:
    CMP.B   #EASY_MODE,MODE     ; Check if easy
    BEQ     INIT_EASY           ; Start easy
    CMP.B   #HARD_MODE,MODE    
    BEQ     INIT_HARD       

INIT_EASY:
    MOVE.B  #HEALTH_EASY,HEALTH ; Health for easy mode
    CLR.B   BRAVERY_POINTS      ; Bravery points = 0
    RTS                         ; Return

INIT_HARD:
    MOVE.B  #HEALTH_HARD,HEALTH ; Health for hard mode
    CLR.B   BRAVERY_POINTS      ; Bravery points = 0
    RTS                         ; Return

STORY_INTRO:
    BSR     ENDL          
    LEA     STORY_MSG,A1        ; Load story intro message inro Address register A1
    MOVE.B  #14,D0           
    TRAP    #15           
    BSR     ENDL           
    RTS                         ; Return

PLAYER_CHOICE_1:
    BSR     ENDL            
    LEA     CHOICE_MSG1,A1      ; Load first choice message
    MOVE.B  #14,D0          
    TRAP    #15            
    MOVE.B  #4,D0             
    TRAP    #15        
    CMP.B   #1,D1               ; Check if player chose option 1
    BEQ     FOLLOW_NOISE        ; If yes
    CMP.B   #2,D1               ; Check if player chose option 2
    BEQ     KEEP_FLYING         ; If yes
    BRA     PLAYER_CHOICE_1     ; If invalid input, ask again

FOLLOW_NOISE:
    BSR     ENDL             
    LEA     NOISE_MSG,A1        ; Load MESSAGE
    MOVE.B  #14,D0          
    TRAP    #15                 ; Print the message
    CMP.B   #EASY_MODE,MODE     ; Check if easy mode
    BEQ     LOSE_HEALTH_EASY    ; If yes, lose 33 health
    SUB.B   #HEALTH_LOSS_HARD,HEALTH ; Else, lose 50 health
    BRA     GAIN_BRAVERY        ; Jump to gain bravery points
LOSE_HEALTH_EASY:
    SUB.B   #HEALTH_LOSS_EASY,HEALTH ; Lose 33 health
GAIN_BRAVERY:
    ADD.B   #BRAVERY_GAIN,BRAVERY_POINTS ; Gain 10 bravery points
    RTS                         ; Return

KEEP_FLYING:
    BSR     ENDL             
    LEA     FLY_MSG,A1          ; Load message
    MOVE.B  #14,D0         
    TRAP    #15         
    RTS                         ; Return

PLAYER_CHOICE_2:
    BSR     ENDL               
    LEA     CHOICE_MSG2,A1      ; Load second message
    MOVE.B  #14,D0      
    TRAP    #15            
    MOVE.B  #4,D0               ; Set trap for input
    TRAP    #15          
    CMP.B   #1,D1               ; Check option 1
    BEQ     EXPLORE_CAVE        ; If yes
    CMP.B   #2,D1               ; Check option 2 
    BEQ     AVOID_CAVE          ; If yes
    BRA     PLAYER_CHOICE_2     ; If invalid input, ask again

EXPLORE_CAVE:
    BSR     ENDL           
    LEA     EXPLORE_CAVE_MSG,A1 ; Load message
    MOVE.B  #14,D0           
    TRAP    #15               
    CMP.B   #EASY_MODE,MODE     ; Check if easy
    BEQ     LOSE_HEALTH_EASY    ; If yes
    SUB.B   #HEALTH_LOSS_HARD,HEALTH ; Else
    BRA     GAIN_BRAVERY        ; Jump to gain bravery points

AVOID_CAVE:
    BSR     ENDL              
    LEA     AVOID_CAVE_MSG,A1   ; Load message
    MOVE.B  #14,D0             
    TRAP    #15               
    RTS                         ; Return

PLAYER_CHOICE_3:
    BSR     ENDL             
    LEA     CHOICE_MSG3,A1      ; Load message
    MOVE.B  #14,D0          
    TRAP    #15           
    MOVE.B  #4,D0          
    TRAP    #15                 ; Get input
    CMP.B   #1,D1               ; Check if option 1
    BEQ     DRINK_WATER         ; If yes
    CMP.B   #2,D1               ; Check if option 2
    BEQ     IGNORE_WATER        ; If yes
    BRA     PLAYER_CHOICE_3     ; Ask again if wrong input

DRINK_WATER:
    BSR     ENDL             
    LEA     DRINK_WATER_MSG,A1  ; Load message
    MOVE.B  #14,D0         
    TRAP    #15           
    ADD.B   #20,HEALTH          ; Gain 20 health
    RTS                         ; Return

IGNORE_WATER:
    BSR     ENDL            
    LEA     IGNORE_WATER_MSG,A1 ; Load message
    MOVE.B  #14,D0          
    TRAP    #15            
    CMP.B   #EASY_MODE,MODE    
    BEQ     LOSE_HEALTH_EASY   
    SUB.B   #HEALTH_LOSS_HARD,HEALTH 
    RTS                         ; Return

PLAYER_CHOICE_4:
    BSR     ENDL                ; Print a new line
    LEA     CHOICE_MSG4,A1      ; Load message
    MOVE.B  #14,D0            
    TRAP    #15            
    MOVE.B  #4,D0           
    TRAP    #15             
    CMP.B   #1,D1               ; Check if option 1 
    BEQ     CHASE_PREY          ; If yes
    CMP.B   #2,D1               ; Check if option 2
    BEQ     IGNORE_PREY         ; If yes
    BRA     PLAYER_CHOICE_4     ; Ask again

CHASE_PREY:
    BSR     ENDL              
    LEA     CHASE_PREY_MSG,A1   ; Load message
    MOVE.B  #14,D0          
    TRAP    #15            
    CMP.B   #EASY_MODE,MODE     ; Check if easy
    BEQ     LOSE_HEALTH_EASY    ; If yes, lose 33 health (doesnt work)
    SUB.B   #HEALTH_LOSS_HARD,HEALTH ; Else, lose 50 health (doesnt work)
    BRA     GAIN_BRAVERY        ; Jump to bravery points

IGNORE_PREY:
    BSR     ENDL              
    LEA     IGNORE_PREY_MSG,A1  ; Load message
    MOVE.B  #14,D0             
    TRAP    #15          
    RTS                         ; Return

PLAYER_CHOICE_5:
    BSR     ENDL            
    LEA     CHOICE_MSG5,A1      ; Load fifth message
    MOVE.B  #14,D0            
    TRAP    #15            
    MOVE.B  #4,D0        
    TRAP    #15                 ; Get user input
    CMP.B   #1,D1               ; Check if option 1 
    BEQ     FOLLOW_FLOCK        ; If yes
    CMP.B   #2,D1               ; Check if option 2 
    BEQ     IGNORE_FLOCK        ; If yes
    BRA     PLAYER_CHOICE_5   

FOLLOW_FLOCK:
    BSR     ENDL            
    LEA     FOLLOW_FLOCK_MSG,A1 ; Load message
    MOVE.B  #14,D0          
    TRAP    #15                 
    ADD.B   #25,BRAVERY_POINTS  ; Gain 25 bravery points
    RTS                         ; Return

IGNORE_FLOCK:
    BSR     ENDL            
    LEA     IGNORE_FLOCK_MSG,A1 ; Load message
    MOVE.B  #14,D0        
    TRAP    #15             
    CMP.B   #EASY_MODE,MODE     ; Check if easy
    BEQ     LOSE_HEALTH_EASY    ; If yes, lose 33
    SUB.B   #HEALTH_LOSS_HARD,HEALTH ; Else, lose 50
    RTS                         ; Return

UPDATE_STATUS:
    BSR     ENDL            
    LEA     STATUS_MSG,A1       ; Load message
    MOVE.B  #14,D0         
    TRAP    #15             
    BSR     ENDL        
    RTS                         ; Return

* HEADS-UP DISPLAY
HUD:
    BSR     ENDL          
    LEA     HUD_HEADER,A1       ; Load HUD message
    MOVE.B  #14,D0         
    TRAP    #15            
    BSR     ENDL            
    LEA     DASHES,A1           ; Load dashes into address register A1
    MOVE.B  #14,D0              ; Set trap for printing
    TRAP    #15         
    BSR     ENDL        

    * PRINT HEALTH
    LEA     HEALTH_MSG,A1       ; Load message
    MOVE.B  #14,D0     
    TRAP    #15            
    MOVE.B  HEALTH,D1           ; Load health into data register D1
    MOVE.B  #3,D0          
    TRAP    #15            
    BSR     ENDL             

    LEA     BRAVERY_MSG,A1      ; Load message
    MOVE.B  #14,D0          
    TRAP    #15              
    MOVE.B  BRAVERY_POINTS,D1   ; Load bravery points into data register D1
    MOVE.B  #3,D0           
    TRAP    #15          
    BSR     ENDL          

    RTS                         ; Return


CHECK_GAME_OVER:
    CMP.B   #0,HEALTH           ; Check if health is 0 or below
    BLE     GAME_OVER           ; If yes, branch to game over

    CMP.B   #50,BRAVERY_POINTS  ; Check if bravery points >= 50
    BGE     WIN_GAME            ; If yes, branch to win game

    RTS                         ; Return if neither

GAME_OVER:
    BSR     ENDL            
    LEA     GAME_OVER_MSG,A1    ; Load message
    MOVE.B  #14,D0        
    TRAP    #15            
    BSR     ENDL           
    BRA     REPLAY              ; Ask to replay or exit

WIN_GAME: ;(Doesnt work)
    BSR     ENDL             
    LEA     WIN_MSG,A1        
    MOVE.B  #14,D0         
    TRAP    #15               
    BSR     ENDL             
    BRA     REPLAY              ; Ask to replay

REPLAY:
    BSR     ENDL               
    LEA     REPLAY_MSG,A1      
    MOVE.B  #14,D0           
    TRAP    #15             
    MOVE.B  #4,D0            
    TRAP    #15              
    CMP     #EXIT,D1            ; Check if user wants to exit
    BEQ     END                 ; If yes, end the game
    BSR     INIT_GAME     
    BSR     GAME                ; Restart the game
    RTS                         ; Return

* PRINT NEW LINE
ENDL:
    MOVE.B  #14,D0       
    LEA     NEWA,A1             ; Load new line ($0D, $0A)
    TRAP    #15                 ; Print new line
    RTS                         ; Return
    
NEWA:           DC.B    $0D,$0A,0
WELCOME_MSG:    DC.B    '------------------------------------------------------------'
                DC.B    $0D,$0A
                DC.B    'WELCOME TO AVIARY ODYSSEY!'
                DC.B    $0D,$0A
                DC.B    'YOU ARE A BIRD IN A SMALL WORLD'
                DC.B    $0D,$0A
                DC.B    'ON A BIG ADVENTURE'
                DC.B    $0D,$0A
                DC.B    'YOU ARE LOST FROM THE FLOCK!'
                DC.B    $0D,$0A
                DC.B    'FIND YOUR WAY BACK!'
                DC.B    $0D,$0A
                DC.B    '------------------------------------------------------------'
                DC.B    $0D,$0A,0
MODE_MSG:       DC.B    'SELECT MODE: 1 (EASY) OR 2 (HARD): ',0
STORY_MSG:      DC.B    'YOU HEAR A NOISE FROM THE FOREST. WHAT WILL YOU DO?',0
CHOICE_MSG1:    DC.B    '1. FOLLOW THE NOISE', $0D, $0A  
                DC.B    '2. KEEP FLYING', 0        
NOISE_MSG:      DC.B    'YOU FLEW INTO A TREE! LOST SOME HEALTH BUT GAINED 10 BRAVERY POINTS.',0
FLY_MSG:        DC.B    'YOU KEPT FLYING. NO CHANGES TO HEALTH OR BRAVERY.',0
CHOICE_MSG2:    DC.B    '1. EXPLORE THE CAVE', $0D, $0A 
                DC.B    '2. AVOID THE CAVE', 0           
EXPLORE_CAVE_MSG: DC.B  'YOU EXPLORED THE CAVE AND FOUND TREASURE! LOST SOME HEALTH BUT GAINED 10 BRAVERY POINTS.',0
AVOID_CAVE_MSG: DC.B    'YOU AVOIDED THE CAVE AND STAYED SAFE.',0
CHOICE_MSG3:    DC.B    '1. DRINK WATER FROM THE RIVER', $0D, $0A  
                DC.B    '2. IGNORE THE WATER', 0                   
DRINK_WATER_MSG: DC.B   'YOU DRANK WATER AND REGAINED 20 HEALTH.',0
IGNORE_WATER_MSG: DC.B  'YOU IGNORED THE WATER AND LOST SOME HEALTH.',0
CHOICE_MSG4:    DC.B    '1. CHASE THE PREY', $0D, $0A  
                DC.B    '2. IGNORE THE PREY', 0      
CHASE_PREY_MSG: DC.B    'YOU CHASED THE PREY AND GAINED 10 BRAVERY POINTS!',0
IGNORE_PREY_MSG: DC.B   'YOU IGNORED THE PREY AND STAYED SAFE.',0
CHOICE_MSG5:    DC.B    '1. FOLLOW THE FLOCK CALL', $0D, $0A  
                DC.B    '2. IGNORE THE FLOCK CALL', 0     
FOLLOW_FLOCK_MSG: DC.B  'YOU FOLLOWED THE FLOCK CALL AND GAINED 25 BRAVERY POINTS!',0
IGNORE_FLOCK_MSG: DC.B  'YOU IGNORED THE FLOCK CALL AND LOST SOME HEALTH.',0
STATUS_MSG:     DC.B    'UPDATING YOUR STATUS...',0
HUD_HEADER:     DC.B    'Current Status',0
DASHES:         DC.B    '--------------------',0
HEALTH_MSG:     DC.B    'Health: ',0
BRAVERY_MSG:    DC.B    'Bravery Points: ',0
REPLAY_MSG:     DC.B    'ENTER 0 TO QUIT, ANY OTHER NUMBER TO REPLAY: ',0
GAME_OVER_MSG:  DC.B    'GAME OVER! YOU DID NOT SURVIVE THE ODDYSEY.',0
WIN_MSG:        DC.B    'CONGRATULATIONS! YOU FOUND YOUR FLOCK AND SURVIVED!',0

    END START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
