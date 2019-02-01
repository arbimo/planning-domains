(define (domain majsp)


    (:types
        Robot - object
        Pallet - object
        Position - object
        Treatment - object
    )

    (:predicates
        (robot-at ?r - Robot ?p - Position)
        (pallet-at ?b - Pallet ?p - Position)
        (can-do ?b - Position ?t - Treatment)
        (robot-free ?r - Robot)
        (position-free ?p - Position)
        (robot-has ?r - Robot ?b - Pallet)
        (treated ?b - Pallet ?t - Treatment)
        (ready ?b - Pallet ?p - Position ?t - Treatment)
        (is-depot ?p - Position)
    )

    (:functions
        (distance ?a ?b - Position)
        (battery-level ?r - Robot)
    )

    (:action move
        :parameters (?r - Robot ?from ?to - Position)
        :precondition 
            (and 
                (not (= ?from ?to)) 
                (robot-at ?r ?from)
                (>= (battery-level ?r) (distance ?from ?to) )
            )
        :effect 
            (and 
                (not (robot-at ?r ?from)) 
                (robot-at ?r ?to)
                (decrease (battery-level ?r) (distance ?from ?to) )
            )
    )
    
    (:action unload
        :parameters (?r - Robot ?b - Pallet ?p - Position ?t - Treatment)
        :precondition 
            (and 
                (can-do ?p ?t) 
                (position-free ?p) 
                (robot-at ?r ?p) 
                (robot-has ?r ?b)
            )
        :effect 
            (and 
                (pallet-at ?b ?p) 
                (not (position-free ?p)) 
                (robot-free ?r) 
                (not (robot-has ?r ?b))
            )
    )

    (:action unload_at_depot
        :parameters (?r - Robot ?b - Pallet ?p - Position )
        :precondition 
            (and 
                (is-depot ?p) 
                (robot-at ?r ?p) 
                (robot-has ?r ?b)
            )
        :effect 
            (and 
                (pallet-at ?b ?p) 
                (robot-free ?r) 
                (not (robot-has ?r ?b))
            )
    )
    
    (:action load_from_depot
        :parameters (?r - Robot ?b - Pallet ?p - Position )
        :precondition 
            (and 
                (is-depot ?p) 
                (robot-at ?r ?p) 
                (robot-free ?r)
                (pallet-at ?b ?p) 
            )
        :effect 
            (and 
                (not (robot-free ?r)) 
                (not (pallet-at ?b ?p))
                (robot-has ?r ?b)
            )
    )

    (:action make_ready
        :parameters (?b - Pallet ?p - Position ?t - Treatment)
        :precondition 
            (and 
                (pallet-at ?b ?p) 
                (not (ready ?b ?p ?t))
                (can-do ?p ?t) 
            )
        :effect 
            (and 
                (ready ?b ?p ?t) 
            )
    )
    
    (:action load
        :parameters (?r - Robot ?b - Pallet ?p - Position ?t - Treatment)
        :precondition 
            (and 
                (pallet-at ?b ?p) 
                (robot-free ?r) 
                (robot-at ?r ?p) 
                (ready ?b ?p ?t) 
            )
        :effect 
            (and 
                (not (ready ?b ?p ?t))
                (not (pallet-at ?b ?p)) 
                (not (robot-free ?r)) 
                (robot-has ?r ?b)
                (treated ?b ?t)
                (position-free ?p)
            )
    )
    
    

)
