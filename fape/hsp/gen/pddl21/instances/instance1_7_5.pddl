
(define (problem instance1_7_5)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 p2 p3 p4 p5 p6 - Position
		b0 b1 b2 b3 b4 - Bar
	)

  (:init
	(hoist-at h0 p0)

	(can-go h0 p0)
	(can-go h0 p1)
	(can-go h0 p2)
	(can-go h0 p3)
	(can-go h0 p4)
	(can-go h0 p5)
	(can-go h0 p6)

	(hoist-free h0)


	(position-free p0)
	(position-free p1)
	(position-free p2)
	(position-free p3)
	(position-free p4)
	(position-free p5)
	(position-free p6)

	(plant_loading_position p0)
	(plant_unloading_position p6)
	

        
	)

	(:goal
		(and
	(processed b0 p0)
	(processed b1 p0)
	(processed b2 p0)
	(processed b3 p0)
	(processed b4 p0)
	(processed b0 p1)
	(processed b1 p1)
	(processed b2 p1)
	(processed b3 p1)
	(processed b4 p1)
	(processed b0 p2)
	(processed b1 p2)
	(processed b2 p2)
	(processed b3 p2)
	(processed b4 p2)
	(processed b0 p3)
	(processed b1 p3)
	(processed b2 p3)
	(processed b3 p3)
	(processed b4 p3)
	(processed b0 p4)
	(processed b1 p4)
	(processed b2 p4)
	(processed b3 p4)
	(processed b4 p4)
	(processed b0 p5)
	(processed b1 p5)
	(processed b2 p5)
	(processed b3 p5)
	(processed b4 p5)
	(processed b0 p6)
	(processed b1 p6)
	(processed b2 p6)
	(processed b3 p6)
	(processed b4 p6)

		)
	)
)

