
(define (problem instance1_4_4)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 p2 p3 - Position
		b0 b1 b2 b3 - Bar
	)

  (:init
	(hoist-at h0 p0)

	(= (hoist-dest-x h0) 0)(= (hoist-x h0) 0)

	(can-go h0 p0)
	(can-go h0 p1)
	(can-go h0 p2)
	(can-go h0 p3)

	(hoist-free h0)

	(= (hoist-time h0 p0 p0) 0)
	(= (hoist-time h0 p0 p1) 10)
	(= (hoist-time h0 p0 p2) 20)
	(= (hoist-time h0 p0 p3) 30)
	(= (hoist-time h0 p1 p0) 10)
	(= (hoist-time h0 p1 p1) 0)
	(= (hoist-time h0 p1 p2) 10)
	(= (hoist-time h0 p1 p3) 20)
	(= (hoist-time h0 p2 p0) 20)
	(= (hoist-time h0 p2 p1) 10)
	(= (hoist-time h0 p2 p2) 0)
	(= (hoist-time h0 p2 p3) 10)
	(= (hoist-time h0 p3 p0) 30)
	(= (hoist-time h0 p3 p1) 20)
	(= (hoist-time h0 p3 p2) 10)
	(= (hoist-time h0 p3 p3) 0)


	(= (x p0) 0)
	(= (x p1) 10)
	(= (x p2) 20)
	(= (x p3) 30)

	(position-free p0)
	(position-free p1)
	(position-free p2)
	(position-free p3)

	(= (step b0) -1)
	(= (step b1) -1)
	(= (step b2) -1)
	(= (step b3) -1)

	(= (last-step b0) 3)
	(= (last-step b1) 3)
	(= (last-step b2) 3)
	(= (last-step b3) 3)

        
	)

	(:goal
		(and
	(= (step b0) (+ (last-step b0) 1))
	(= (step b1) (+ (last-step b1) 1))
	(= (step b2) (+ (last-step b2) 1))
	(= (step b3) (+ (last-step b3) 1))

		)
	)
)

