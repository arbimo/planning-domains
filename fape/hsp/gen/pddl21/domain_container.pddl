(define (domain mais)
    (:requirements :typing :durative-actions :equality)
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
        (finished ?b -Bar ?p - Position)
        (plant_loading_position ?p - Position)
        (plant_unloading_position ?p - Position)

        (is_ready ?b -Bar ?p - Position)

        ;;prepare_bar clip predicates
        (prepare_bar_stage1 ?b - Bar ?p - Position)
        (prepare_bar_stage2 ?b - Bar ?p - Position)
        (prepare_bar_stage3 ?b - Bar ?p - Position)
        (prepare_bar_stage4 ?b - Bar ?p - Position)

        ;;unload_bar clip predicates
        (unload_bar_stage1 ?h - Hoist ?b - Bar ?p - Position)
        (unload_bar_stage2 ?h - Hoist ?b - Bar ?p - Position)
        (unload_bar_stage3 ?h - Hoist ?b - Bar ?p - Position)
        (unload_bar_stage4 ?h - Hoist ?b - Bar ?p - Position)
    )

    (:durative-action prepare_bar
        :parameters (?b - Bar ?p - Position)
        :duration (= ?duration 0.1)
        :condition (and
                        (at start (plant_loading_position ?p))
                        (at start (position-free ?p))
                        (at start (prepare_bar_stage1 ?b ?p))
                    )
        :effect (and
                    (at end (bar-at ?b ?p))
                    (at start (not (position-free ?p)))
                    (at end (prepare_bar_stage2 ?b ?p))
                    (at end (not (prepare_bar_stage1 ?b ?p)))
                )
     )

     (:durative-action prepare_bar_container
        :parameters (?b - Bar ?p - Position)
        :duration (= ?duration 30.3)
        :condition (and
                        (at start (plant_loading_position ?p))
                        (at start (position-free ?p))
                        (at end (prepare_bar_stage4 ?b ?p))
                   )
        :effect (and
                 (at start (prepare_bar_stage1 ?b ?p))
                 (at end (not (prepare_bar_stage4 ?b ?p)))
                 )
    )

    (:durative-action prepare_bar_wait
        :parameters (?b - Bar ?p - Position)
        :duration (= ?duration 10)
        :condition (and
                        (at start (prepare_bar_stage2 ?b ?p))
                   )
        :effect (and
                    (at end (not (prepare_bar_stage2 ?b ?p)))
                    (at end (prepare_bar_stage3 ?b ?p))
                )
    )

    (:durative-action prepare_bar_window
        :parameters (?b - Bar ?p - Position)
        :duration (= ?duration 20)
        :condition (and
                    (at start (prepare_bar_stage3 ?b ?p))
                    )
        :effect (and
                 (at start (is_ready ?b ?p))
                 (at end (not (is_ready ?b ?p)))
                 (at end (not (prepare_bar_stage3 ?b ?p)))
                 (at end (prepare_bar_stage4 ?b ?p))
                )
    )

    (:action load
        :parameters (?h - Hoist ?b - Bar ?p - Position)
        :precondition (and (bar-at ?b ?p) (hoist-free ?h) (hoist-at ?h ?p) (is_ready ?b ?p))
        :effect (and
                    (not (bar-at ?b ?p))
                    (position-free ?p)
                    (not (hoist-free ?h))
                    (bar-on-hoist ?b ?h)
                    (processed ?b ?p)
                )
        )



    (:durative-action unload
        :parameters (?h - Hoist ?b - Bar ?p - Position)
        :duration (= ?duration 0.1)
        :condition  (and
                        (at start (bar-on-hoist ?b ?h))
                        (at start (position-free ?p))
                        (at start (hoist-at ?h ?p))
                        (at start (unload_bar_stage1 ?h ?b ?p))
                    )
        :effect (and
                    (at end (unload_bar_stage2 ?h ?b ?p))
                    (at end (not (unload_bar_stage1 ?h ?b ?p)))

                    (at end (bar-at ?b ?p))
                    (at end (not (position-free ?p)))
                    (at end (hoist-free ?h))
                    (at end (not (bar-on-hoist ?b ?h)))

                )
    )

     (:durative-action unload_bar_container
        :parameters (?h - Hoist ?b - Bar ?p - Position)
        :duration (= ?duration 30.3)
        :condition (and
                        (at start (bar-on-hoist ?b ?h))
                        (at start (position-free ?p))
                        (at start (hoist-at ?h ?p))
                        (at end (unload_bar_stage4 ?h ?b ?p))
                   )
        :effect (and
                 (at start (unload_bar_stage1 ?h ?b ?p))
                 (at end (not (unload_bar_stage4 ?h ?b ?p)))
                 )
    )

    (:durative-action unload_bar_wait
        :parameters (?h - Hoist ?b - Bar ?p - Position)
        :duration (= ?duration 10)
        :condition (and
                        (at start (unload_bar_stage2 ?h ?b ?p))
                   )
        :effect (and
                    (at end (not (unload_bar_stage2 ?h ?b ?p)))
                    (at end (unload_bar_stage3 ?h ?b ?p))
                )
    )

    (:durative-action unload_bar_window
        :parameters (?h - Hoist ?b - Bar ?p - Position)
        :duration (= ?duration 20)
        :condition (and
                    (at start (unload_bar_stage3 ?h ?b ?p))
                    )
        :effect (and
                 (at start (is_ready ?b ?p))
                 (at end (not (is_ready ?b ?p)))
                 (at end (not (unload_bar_stage3 ?h ?b ?p)))
                 (at end (unload_bar_stage4 ?h ?b ?p))
                )
    )

    (:durative-action move
        :parameters (?h - Hoist ?from ?to - Position)
        :duration (= ?duration 10)
        :condition (and
                       (at start (hoist-at ?h ?from))
                       (at start (not (= ?from ?to)))
                       (at start (can-go ?h ?to))
                    )
        :effect (and
                    (at start (not (hoist-at ?h ?from)))
                    (at end (hoist-at ?h ?to))
                )
    )

    (:action finish_bar
        :parameters (?b - Bar ?p - Position)
        :precondition (and
                            (plant_unloading_position ?p)
                            (bar-at ?b ?p)
                            (is_ready ?b ?p)
                       )
        :effect (and
                            (not (bar-at ?b ?p))
                            (position-free ?p)
                            (finished ?b ?p)
                )
    )

)
