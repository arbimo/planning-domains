
(define (problem instance1_3_5)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 p2 - Position
		b0 b1 b2 b3 b4 - Bar
	)

  (:init
	(hoist-at h0 p0)

	(= (hoist-dest-x h0) 0)(= (hoist-x h0) 0)

	(can-go h0 p0)
	(can-go h0 p1)
	(can-go h0 p2)

	(hoist-free h0)

	(= (hoist-time h0 p0 p0) 0)
	(= (hoist-time h0 p0 p1) 10)
	(= (hoist-time h0 p0 p2) 20)
	(= (hoist-time h0 p1 p0) 10)
	(= (hoist-time h0 p1 p1) 0)
	(= (hoist-time h0 p1 p2) 10)
	(= (hoist-time h0 p2 p0) 20)
	(= (hoist-time h0 p2 p1) 10)
	(= (hoist-time h0 p2 p2) 0)


	(= (x p0) 0)
	(= (x p1) 10)
	(= (x p2) 20)

	(position-free p0)
	(position-free p1)
	(position-free p2)

	(= (step b0) -1)
	(= (step b1) -1)
	(= (step b2) -1)
	(= (step b3) -1)
	(= (step b4) -1)

	(= (last-step b0) 2)
	(= (last-step b1) 2)
	(= (last-step b2) 2)
	(= (last-step b3) 2)
	(= (last-step b4) 2)

        
	)

	(:goal
		(and
	(= (step b0) (+ (last-step b0) 1))
	(= (step b1) (+ (last-step b1) 1))
	(= (step b2) (+ (last-step b2) 1))
	(= (step b3) (+ (last-step b3) 1))
	(= (step b4) (+ (last-step b4) 1))

		)
	)
)

