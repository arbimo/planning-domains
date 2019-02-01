
(define (problem instance1_6_6)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 p2 p3 p4 p5 - Position
		b0 b1 b2 b3 b4 b5 - Bar
	)

  (:init
	(hoist-at h0 p0)

	(= (hoist-dest-x h0) 0)(= (hoist-x h0) 0)

	(can-go h0 p0)
	(can-go h0 p1)
	(can-go h0 p2)
	(can-go h0 p3)
	(can-go h0 p4)
	(can-go h0 p5)

	(hoist-free h0)

	(= (hoist-time h0 p0 p0) 0)
	(= (hoist-time h0 p0 p1) 10)
	(= (hoist-time h0 p0 p2) 20)
	(= (hoist-time h0 p0 p3) 30)
	(= (hoist-time h0 p0 p4) 40)
	(= (hoist-time h0 p0 p5) 50)
	(= (hoist-time h0 p1 p0) 10)
	(= (hoist-time h0 p1 p1) 0)
	(= (hoist-time h0 p1 p2) 10)
	(= (hoist-time h0 p1 p3) 20)
	(= (hoist-time h0 p1 p4) 30)
	(= (hoist-time h0 p1 p5) 40)
	(= (hoist-time h0 p2 p0) 20)
	(= (hoist-time h0 p2 p1) 10)
	(= (hoist-time h0 p2 p2) 0)
	(= (hoist-time h0 p2 p3) 10)
	(= (hoist-time h0 p2 p4) 20)
	(= (hoist-time h0 p2 p5) 30)
	(= (hoist-time h0 p3 p0) 30)
	(= (hoist-time h0 p3 p1) 20)
	(= (hoist-time h0 p3 p2) 10)
	(= (hoist-time h0 p3 p3) 0)
	(= (hoist-time h0 p3 p4) 10)
	(= (hoist-time h0 p3 p5) 20)
	(= (hoist-time h0 p4 p0) 40)
	(= (hoist-time h0 p4 p1) 30)
	(= (hoist-time h0 p4 p2) 20)
	(= (hoist-time h0 p4 p3) 10)
	(= (hoist-time h0 p4 p4) 0)
	(= (hoist-time h0 p4 p5) 10)
	(= (hoist-time h0 p5 p0) 50)
	(= (hoist-time h0 p5 p1) 40)
	(= (hoist-time h0 p5 p2) 30)
	(= (hoist-time h0 p5 p3) 20)
	(= (hoist-time h0 p5 p4) 10)
	(= (hoist-time h0 p5 p5) 0)


	(= (x p0) 0)
	(= (x p1) 10)
	(= (x p2) 20)
	(= (x p3) 30)
	(= (x p4) 40)
	(= (x p5) 50)

	(position-free p0)
	(position-free p1)
	(position-free p2)
	(position-free p3)
	(position-free p4)
	(position-free p5)

	(= (step b0) -1)
	(= (step b1) -1)
	(= (step b2) -1)
	(= (step b3) -1)
	(= (step b4) -1)
	(= (step b5) -1)

	(= (last-step b0) 5)
	(= (last-step b1) 5)
	(= (last-step b2) 5)
	(= (last-step b3) 5)
	(= (last-step b4) 5)
	(= (last-step b5) 5)

        
	)

	(:goal
		(and
	(= (step b0) (+ (last-step b0) 1))
	(= (step b1) (+ (last-step b1) 1))
	(= (step b2) (+ (last-step b2) 1))
	(= (step b3) (+ (last-step b3) 1))
	(= (step b4) (+ (last-step b4) 1))
	(= (step b5) (+ (last-step b5) 1))

		)
	)
)

