(define (problem bar-XX) ;; Replace XX with task number
    (:domain bartending)
    (:objects 
        C1 -customer
        B1 - broom
        G1 - glass
        UB - location
        UF - location
        MB - location
        MF - location
        LB - location
        LF - location
    )
    
    (:init
        ; describes the map
        (adjacent BAR UF)
        (adjacent UF BAR)
        (adjacent UF UB)
        (adjacent UB UF)
        (adjacent UB MB)
        (adjacent MB UB)
        (adjacent UF MF)
        (adjacent MF UF)
        (adjacent MB LB) 
        (adjacent LB MB)
        (adjacent MF LF)
        (adjacent LF MF)
        (adjacent LB LF)
        (adjacent LF LB)
        ; where the agent, the customer, glass and broom is
        (at Agent BAR)
        (at C1 LB)
        (at G1 BAR)
        (at B1 BAR)
        ;Where the broken glass is 
        (brokenGlass MF)
        (brokenGlass MB)
        

    )
    
    (:goal (and 
        (served C1)             ;customer is served 
        (at Agent BAR)          ;Agent is at the bar 
        (not (brokenGlass MF))  ; No broken glass at MF
        (not (brokenGlass MB))  ; No broken glass at MB
    ))
)
