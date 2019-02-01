
(define (problem instance1_2_8)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 - Position
		b0 b1 b2 b3 b4 b5 b6 b7 - Bar
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
	(= (step b1) -1)
	(= (step b2) -1)
	(= (step b3) -1)
	(= (step b4) -1)
	(= (step b5) -1)
	(= (step b6) -1)
	(= (step b7) -1)

	(= (last-step b0) 1)
	(= (last-step b1) 1)
	(= (last-step b2) 1)
	(= (last-step b3) 1)
	(= (last-step b4) 1)
	(= (last-step b5) 1)
	(= (last-step b6) 1)
	(= (last-step b7) 1)

        
	)

	(:goal
		(and
	(= (step b0) (+ (last-step b0) 1))
	(= (step b1) (+ (last-step b1) 1))
	(= (step b2) (+ (last-step b2) 1))
	(= (step b3) (+ (last-step b3) 1))
	(= (step b4) (+ (last-step b4) 1))
	(= (step b5) (+ (last-step b5) 1))
	(= (step b6) (+ (last-step b6) 1))
	(= (step b7) (+ (last-step b7) 1))

		)
	)
)

