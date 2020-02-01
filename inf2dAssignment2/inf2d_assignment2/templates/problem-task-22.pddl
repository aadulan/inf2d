(define (problem bar-22) ;; Replace XX with task number
    (:domain bartending)
    (:objects 
        G - glass
        C - customer
        UB - location
        UF - location
        MB - location
        MF - location
        LB - location
        LF - location
    )
    
    (:init
        (adjacent BAR UF)
        (adjacent UF UB)
        (adjacent UB MB)
        (adjacent UF MF)
        (adjacent MB LB) 
        (adjacent MF LF)
        (adjacent LB LF)
        (at Agent BAR)
        (at G BAR)
        (at C LB)
    )
    
    (:goal (and
        (served C)
    ))
)