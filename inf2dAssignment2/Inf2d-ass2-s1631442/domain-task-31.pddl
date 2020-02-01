(define (domain bartending)
    (:requirements :adl )
    
    (:types
        bartender
        location
        glass
        customer
        broom
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
        (holding ?x - bartender ?y - object)   ; x is holding y 
       (served ?x - customer )                ; customer is served
        (brokenGlass ?x -location)             ; there is broken glass at this location 
        
       
    )
    
    ;;;; Action Template 
    
    
    ;Either picks up a glass or a broom if the bartender is not holding anything
    ;Glass or broom and bartender have to be at the same location 
    (:action PickUp
        :parameters(?x - bartender ?y - object ?l1 - location ?l2 - location)
        :precondition (and
            (not (holding ?x ?y)) 
            (at ?x ?l1)
            (at ?y ?l2)
            (= ?l1 ?l2)
        )
        :effect (and
            (holding ?x ?y)       ;effect is the bartender is now holding the glass or broom
            (not (at ?y ?l2))     ;then the glass or broom is not at the location anymore
        )
    )
    
    ; Pours Beer into an empty glass if at the bar 
    (:action Pour
        :parameters(?x - bartender ?y - glass)
        :precondition(and 
            (at ?x BAR)
            (not (containsBeer ?y))
            (holding ?x ?y)
        )
        :effect (and
            (containsBeer ?y) ; there is now beer in the glass 
        )
    )
    
    ; hands the glass over to the customer, only if the bartender is holding the glass and they are 
    ; at the same location
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
            (served ?z)          ; effect is the customer being served
            (not(holding ?x ?y)) ; the bartender is no longer holding the glass
        )
    )
    
    ; moves the bartender if there is no broken glass
    (:action Move
        :parameters( ?x - bartender ?from - location ?to - location)
        :precondition(and
            (at ?x ?from)
            (adjacent ?from ?to)
            (not (brokenGlass ?to))
        )
        :effect (and
            (at ?x ?to)            ;means the bartender is now moved
            (not (at ?x ?from))
        )
    )
    
    ;Sweeps up the broken glass if the bartender is holding a broom and is adjacent to the broken glass
    (:action SweepsItUp
        :parameters (?x - bartender ?l1 - location ?l2 - location ?b - broom)
        :precondition (and
            (at ?x ?l1)
            (brokenGlass ?l2)
            (adjacent ?l1 ?l2)
            (holding ?x ?b)
        )
        :effect (and
            (not (brokenGlass ?l2))   ; no more broken glass
        )
    )
    
    ;Puts the glass down and picks up the broom
    (:action PutDownGlass
        :parameters (?x - bartender ?l1 - location ?l2 -location ?g - glass ?b - broom)
        :precondition (and 
            (at ?x ?l1)
            (holding ?x ?g)
            (at ?b ?l2)
            (= ?l1 ?l2)
        )
        :effect (and
            (at ?g ?l1)
            (holding ?x ?b)
            (not (at ?b ?l2))
        )
    )
    ;Puts the broom down and picks up the glass
    (:action PutDownBroom
        :parameters (?x - bartender ?l1 - location ?l2 -location ?g - glass ?b - broom)
        :precondition (and 
            (at ?x ?l1)
            (holding ?x ?b)
            (at ?g ?l2)
            (= ?l1 ?l2)
        )
        :effect (and
            (at ?b ?l1)
            (holding ?x ?g)
            (not (at ?g ?l2))
        )
    )
)