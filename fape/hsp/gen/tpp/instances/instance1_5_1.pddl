
(define (problem instance1_5_1)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 p2 p3 p4 - Position
		b0 - Bar
	)

  (:init
	(hoist-at h0 p0)

	(= (hoist-dest-x h0) 0)(= (hoist-x h0) 0)

	(can-go h0 p0)
	(can-go h0 p1)
	(can-go h0 p2)
	(can-go h0 p3)
	(can-go h0 p4)

	(hoist-free h0)

	(= (hoist-time h0 p0 p0) 0)
	(= (hoist-time h0 p0 p1) 10)
	(= (hoist-time h0 p0 p2) 20)
	(= (hoist-time h0 p0 p3) 30)
	(= (hoist-time h0 p0 p4) 40)
	(= (hoist-time h0 p1 p0) 10)
	(= (hoist-time h0 p1 p1) 0)
	(= (hoist-time h0 p1 p2) 10)
	(= (hoist-time h0 p1 p3) 20)
	(= (hoist-time h0 p1 p4) 30)
	(= (hoist-time h0 p2 p0) 20)
	(= (hoist-time h0 p2 p1) 10)
	(= (hoist-time h0 p2 p2) 0)
	(= (hoist-time h0 p2 p3) 10)
	(= (hoist-time h0 p2 p4) 20)
	(= (hoist-time h0 p3 p0) 30)
	(= (hoist-time h0 p3 p1) 20)
	(= (hoist-time h0 p3 p2) 10)
	(= (hoist-time h0 p3 p3) 0)
	(= (hoist-time h0 p3 p4) 10)
	(= (hoist-time h0 p4 p0) 40)
	(= (hoist-time h0 p4 p1) 30)
	(= (hoist-time h0 p4 p2) 20)
	(= (hoist-time h0 p4 p3) 10)
	(= (hoist-time h0 p4 p4) 0)


	(= (x p0) 0)
	(= (x p1) 10)
	(= (x p2) 20)
	(= (x p3) 30)
	(= (x p4) 40)

	(position-free p0)
	(position-free p1)
	(position-free p2)
	(position-free p3)
	(position-free p4)

	(= (step b0) -1)

	(= (last-step b0) 4)

        
	)

	(:goal
		(and
	(= (step b0) (+ (last-step b0) 1))

		)
	)
)

