(define (domain majsp)

    (:requirements :typing :durative-actions :equality :fluents)


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

        ;;clipping unload with load
        (unload_stage1 ?b - Pallet ?p - Position ?t - Treatment)
        (unload_stage2 ?b - Pallet ?p - Position ?t - Treatment)
        (unload_stage3 ?b - Pallet ?p - Position ?t - Treatment)
        (unload_stage4 ?b - Pallet ?p - Position ?t - Treatment)
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

    (:durative-action unload_container
        :parameters (?r - Robot ?b - Pallet ?p - Position ?t - Treatment)
        :duration (= ?duration 2030)
        :condition
            (and
                (at start (can-do ?p ?t))
                (at start (position-free ?p))
                (at start (robot-at ?r ?p))
                (at start (robot-has ?r ?b))
                (at end (unload_stage4 ?b ?p ?t))
            )
        :effect
            (and
                (at start (unload_stage1 ?b ?p ?t))
                (at end (not (unload_stage4 ?b ?p ?t)))
            )
    )


    (:durative-action unload
        :parameters (?r - Robot ?b - Pallet ?p - Position ?t - Treatment)
        :duration (= ?duration 10)
        :condition
            (and
                (at start (can-do ?p ?t))
                (at start (position-free ?p))
                (at start (robot-at ?r ?p))
                (at start (robot-has ?r ?b))
                (at start (unload_stage1 ?b ?p ?t))
            )
        :effect
            (and
                (at start (not (position-free ?p)))
                (at start (not (robot-has ?r ?b)))
                (at end (pallet-at ?b ?p))
                (at end (robot-free ?r))

                (at end (unload_stage2 ?b ?p ?t))
                (at start (not (unload_stage1 ?b ?p ?t)))
            )
    )

    (:durative-action unload_wait
        :parameters (?b - Pallet ?p - Position ?t - Treatment)
        :duration (= ?duration 1000)
        :condition (and
                        (at start (unload_stage2 ?b ?p ?t))
                   )
        :effect (and
                    (at start (not (unload_stage2 ?b ?p ?t)))
                    (at end (unload_stage3 ?b ?p ?t))
                )
    )

    (:durative-action unload_window
        :parameters (?b - Pallet ?p - Position ?t - Treatment)
        :duration (= ?duration 1000)
        :condition (and
                    (at start (unload_stage3 ?b ?p ?t))
                   )
        :effect (and
                    (at start (not (unload_stage3 ?b ?p ?t)))
                    (at end (unload_stage4 ?b ?p ?t))
                    (at start (ready ?b ?p ?t))
                    (at end (not (ready ?b ?p ?t)))
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
