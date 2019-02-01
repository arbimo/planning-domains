(define (domain mais)


    (:types
        Hoist - object
        Bar - object
        Position - object
    )


    (:predicates
        (hoist-at ?h - Hoist ?p - Position)
        (bar-at ?b - Bar ?p - Position)
        (position-free ?p - Position)
        (bar-on-hoist ?b - Bar ?h - Hoist)
        (hoist-free ?h - Hoist)
        (can-go ?h - Hoist ?p - Position)
        (processed ?b - Bar ?p - Position)
    )

    (:functions
        (step ?b - Bar)
        (hoist-x ?h - Hoist)
        (hoist-dest-x ?h - Hoist)

        ;;Constants
        (x ?p - Position)
        (last-step ?b - Bar)
        (hoist-time ?h - Hoist ?from ?to - Position)
    )

    (:action prepare_bar
        :parameters (?b - Bar ?p - Position)
        :precondition (and (= (step ?b) -1) (position-free ?p))
        :effect (and (increase (step ?b) 1) (bar-at ?b ?p) (not (position-free ?p)))
    )
    
    (:action load
        :parameters (?h - Hoist ?b - Bar ?p - Position)
        :precondition (and (bar-at ?b ?p) (hoist-free ?h) (hoist-at ?h ?p))
        :effect (and (increase (step ?b) 1) (not (bar-at ?b ?p)) (position-free ?p) 
                (not (hoist-free ?h)) (bar-on-hoist ?b ?h) (processed ?b ?p))
    )
    
    (:action unload
        :parameters (?h - Hoist ?b - Bar ?p - Position)
        :precondition (and (bar-on-hoist ?b ?h) (position-free ?p) (hoist-at ?h ?p) (not (processed ?b ?p)))
        :effect (and (bar-at ?b ?p) (not (position-free ?p)) 
                (hoist-free ?h) (not (bar-on-hoist ?b ?h)))
    )
    
    (:action move_start
        :parameters (?h - Hoist ?from ?to - Position)
        :precondition (and (hoist-at ?h ?from) (not (= ?from ?to)) (can-go ?h ?to) 
            (or (not (exists (?h1 - Hoist)
                (and 
                     (not (= ?h1 ?h))
                     (or
                        (and 
                             (>= (hoist-x ?h1) (x ?from))
                             (<= (hoist-x ?h1) (x ?to))
                        )
                        (and 
                             (>= (hoist-dest-x ?h1) (x ?from))
                             (<= (hoist-dest-x ?h1) (x ?to))
                        )
                     )
                )))
                (> (x ?from) (x ?to)))
           
            (or (not (exists (?h1 - Hoist)
                (and 
                     (not (= ?h1 ?h))
                     (or
                        (and 
                            (<= (hoist-x ?h1) (x ?from))
                            (>= (hoist-x ?h1) (x ?to))
                        )
                        (and
                            (<= (hoist-dest-x ?h1) (x ?from))
                            (>= (hoist-dest-x ?h1) (x ?to)))
                     )
                )))
                (<= (x ?from) (x ?to))) 
            )
        
            :effect (and (assign (hoist-dest-x ?h) (x ?to)) (not (hoist-at ?h ?from)))
    )
    
    (:action move_end
        :parameters (?h - Hoist ?from ?to - Position)
        :precondition (and (= (hoist-x ?h) (x ?from)) (= (hoist-dest-x ?h) (x ?to)) (not (= ?from ?to)) (can-go ?h ?to))
        :effect (and (assign (hoist-x ?h) (x ?to)) (hoist-at ?h ?to))
    )
    
    (:action finish_bar
        :parameters (?b - Bar ?p - Position)
        :precondition (and (= (step ?b) (last-step ?b)) (bar-at ?b ?p))
        :effect (and (not (bar-at ?b ?p)) (increase (step ?b) 1) (position-free ?p))
    )
)
