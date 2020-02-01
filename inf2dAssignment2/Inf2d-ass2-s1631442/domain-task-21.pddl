(define (domain bartending)
    (:requirements :adl )
    
    (:types
        bartender
        location
        glass
        customer
        ;; Fill in additional types here
    )
    
    (:constants 
        ;; You should not need to add any additional constants
        Agent - bartender
        BAR - location
    )
    
    (:predicates
        (adjacent ?x - location ?y - location) ; means x is next to y
        (at ?x - object ?y -location)          ; means x is at y 
        (containsBeer ?x - glass)              ; contains beer or not 
        (holding ?x - bartender ?y - glass)    ; x is holding y 
        (served ?x - customer )               ;customer is served
        
    )
    
    ;;;; Action Template - Delete and fill in own actions ;;;;
    
    ;Picks up glass if glass is in the same location as bartender
    (:action PickUp
        :parameters(?x - bartender ?y - glass ?l1 - location ?l2 - location)
        :precondition (and
            (not (holding ?x ?y)) 
            (at ?x ?l1)
            (at ?y ?l2)
            (= ?l1 ?l2)
        )
        :effect (and
            (holding ?x ?y)     ; now holding the glass
            (not (at ?y ?l2))
        )
    )
    
    ;Pours beer into the glass if it is at the bar
    (:action Pour
        :parameters(?x - bartender ?y - glass)
        :precondition(and 
            (at ?x BAR)
            (not (containsBeer ?y))
            (holding ?x ?y)
        )
        :effect (and
            (containsBeer ?y)
        )
    )
    ;hands over the glass of beer to the customer
    (:action HandOver
        :parameters(?x - bartender ?y - glass ?z - customer ?l1 - location ?l2 - location)
        :precondition( and 
            (containsBeer ?y)
            (holding ?x ?y)
            (at ?x ?l1) 
            (at ?z ?l2)
            (= ?l1 ?l2)
        )
        :effect(and
            (served ?z)
            (not(holding ?x ?y))
            ;(not(holding Agent ?y))
        )
    )
    
    ; Moves the agent to next place 
    (:action Move
        :parameters( ?x - bartender ?from - location ?to - location)
        :precondition(and
            (at ?x ?from)
            (adjacent ?from ?to)
        )
        :effect(and
            (at ?x ?to)
            (not(at ?x ?from))
        )
    )
)