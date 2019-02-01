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


        ;;unload_bar clip predicated
        (unload_bar_started ?b - Bar ?p - Position)
        (unload_bar_ended ?b - Bar ?p - Position)
        (unload_bar_clip_started ?b - Bar ?p - Position)
        (unload_bar_min_timeout_started ?b - Bar ?p - Position)
        (unload_bar_max_timeout_started ?b - Bar ?p - Position)
        (unload_bar_min_timeout_can_start ?b - Bar ?p - Position)
        (unload_bar_max_timeout_can_start ?b - Bar ?p - Position)

        ;;prepare_bar clip predicated
        (prepare_bar_started ?b - Bar ?p - Position)
        (prepare_bar_ended ?b - Bar ?p - Position)
        (prepare_bar_clip_started ?b - Bar ?p - Position)
        (prepare_bar_min_timeout_started ?b - Bar ?p - Position)
        (prepare_bar_max_timeout_started ?b - Bar ?p - Position)
        (prepare_bar_min_timeout_can_start ?b - Bar ?p - Position)
        (prepare_bar_max_timeout_can_start ?b - Bar ?p - Position)
    )

    (:durative-action prepare_bar
        :parameters (?b - Bar ?p - Position)
        :duration (= ?duration 10)
        :condition (and
                        (at start (plant_loading_position ?p))
                        (at start (position-free ?p))
                        (at end (prepare_bar_clip_started ?b ?p))
                    )
        :effect (and
                    (at end (bar-at ?b ?p))
                    (at start (not (position-free ?p)))
                    (at end (prepare_bar_ended ?b ?p))
                    (at start (prepare_bar_started ?b ?p))
                    ;(is_ready ?b ?p)
                )
    )

     (:durative-action prepare_bar_clip
        :parameters (?b - Bar ?p - Position)
        :duration (= ?duration 3)
        :condition (and
                        (at start (prepare_bar_started ?b ?p))
                        (at end (prepare_bar_ended ?b ?p))
                        (at end (prepare_bar_min_timeout_started ?b ?p))
                        (at end (prepare_bar_max_timeout_started ?b ?p))
                   )
        :effect (and
                    (at start (prepare_bar_clip_started ?b ?p))
                    (at start (prepare_bar_min_timeout_can_start ?b ?p))
                    (at start (prepare_bar_max_timeout_can_start ?b ?p))
                    (at end (not (prepare_bar_min_timeout_started ?b ?p)))
                    (at end (not (prepare_bar_max_timeout_started ?b ?p)))
                    (at end (not (prepare_bar_clip_started ?b ?p)))

                )
    )

    (:durative-action prepare_bar_min_timeout
        :parameters (?b - Bar ?p - Position)
        :duration (= ?duration 1000)
        :condition (and
                        (at start (prepare_bar_min_timeout_can_start ?b ?p))
                   )
        :effect (and
                    (at start (prepare_bar_min_timeout_started ?b ?p))
                    (at start (not (prepare_bar_min_timeout_can_start ?b ?p)))
                    (at end (is_ready ?b ?p))
                )
    )

    (:durative-action prepare_bar_max_timeout
        :parameters (?b - Bar ?p - Position)
        :duration (= ?duration 3000)
        :condition (and
                        (at start (prepare_bar_max_timeout_can_start ?b ?p))
                   )
        :effect (and
                    (at start (prepare_bar_max_timeout_started ?b ?p))
                    (at start (not (prepare_bar_max_timeout_can_start ?b ?p)))
                    (at end (not (is_ready ?b ?p)))
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
        :duration (= ?duration 10)
        :condition  (and
                        (at start (bar-on-hoist ?b ?h))
                        (at start (position-free ?p))
                        (at start (hoist-at ?h ?p))
                        (at end (unload_bar_clip_started ?b ?p))
                    )
        :effect (and
                    (at start (unload_bar_started ?b ?p))
                    (at start (not (unload_bar_ended ?b ?p)))
                    (at end (not (unload_bar_started ?b ?p)))
                    (at end (unload_bar_ended ?b ?p))
                    (at end (bar-at ?b ?p))
                    (at end (not (position-free ?p)))
                    (at end (hoist-free ?h))
                    (at end (not (bar-on-hoist ?b ?h)))

                )
    )

   (:durative-action unload_bar_clip
        :parameters (?b - Bar ?p - Position)
        :duration (= ?duration 3)
        :condition (and
                        (at start (unload_bar_started ?b ?p))
                        (at end (unload_bar_ended ?b ?p))
                        (at end (unload_bar_min_timeout_started ?b ?p))
                        (at end (unload_bar_max_timeout_started ?b ?p))
                   )
        :effect (and
                    (at start (unload_bar_clip_started ?b ?p))
                    (at start (unload_bar_min_timeout_can_start ?b ?p))
                    (at start (unload_bar_max_timeout_can_start ?b ?p))
                    (at end (not (unload_bar_min_timeout_started ?b ?p)))
                    (at end (not (unload_bar_max_timeout_started ?b ?p)))
                    (at end (not (unload_bar_clip_started ?b ?p)))

                )
    )

    (:durative-action unload_bar_min_timeout
        :parameters (?b - Bar ?p - Position)
        :duration (= ?duration 1000)
        :condition (and
                        (at start (unload_bar_min_timeout_can_start ?b ?p))
                   )
        :effect (and
                    (at start (unload_bar_min_timeout_started ?b ?p))
                    (at start (not (unload_bar_min_timeout_can_start ?b ?p)))
                    (at end (is_ready ?b ?p))
                )
    )

    (:durative-action unload_bar_max_timeout
        :parameters (?b - Bar ?p - Position)
        :duration (= ?duration 3000)
        :condition (and
                        (at start (unload_bar_max_timeout_can_start ?b ?p))
                   )
        :effect (and
                    (at start (unload_bar_max_timeout_started ?b ?p))
                    (at start (not (unload_bar_max_timeout_can_start ?b ?p)))
                    (at end (not (is_ready ?b ?p)))
                )
    )


    (:durative-action move
        :parameters (?h - Hoist ?from ?to - Position)
        :duration (= ?duration 1000)
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
