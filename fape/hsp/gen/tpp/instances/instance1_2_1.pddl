
(define (problem instance1_2_1)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 - Position
		b0 - Bar
	)

  (:init
	(hoist-at h0 p0)

	(= (hoist-dest-x h0) 0)(= (hoist-x h0) 0)

	(can-go h0 p0)
	(can-go h0 p1)

	(hoist-free h0)

	(= (hoist-time h0 p0 p0) 0)
	(= (hoist-time h0 p0 p1) 10)
	(= (hoist-time h0 p1 p0) 10)
	(= (hoist-time h0 p1 p1) 0)


	(= (x p0) 0)
	(= (x p1) 10)

	(position-free p0)
	(position-free p1)

	(= (step b0) -1)

	(= (last-step b0) 1)

        
	)

	(:goal
		(and
	(= (step b0) (+ (last-step b0) 1))

		)
	)
)

