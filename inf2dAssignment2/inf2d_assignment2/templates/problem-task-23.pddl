(define (problem bar-XX) ;; Replace XX with task number
    (:domain bartending)
    (:objects 
        G1 - glass
        G2 - glass
        C1 - customer
        C2 - customer
        UB - location
        UF - location
        MB - location
        MF - location
        LB - location
        LF - location
    )
    
    (:init
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
        (at Agent MF)
        (at G1 MB)
        (at G2 LB)
        (at C1 UB)
        (at C2 LF)
        
        

    )
    
    (:goal (and 
        (served C1)
        (served C2)
        (at Agent BAR)
    
    ))
)