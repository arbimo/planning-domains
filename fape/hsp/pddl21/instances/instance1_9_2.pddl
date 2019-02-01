
(define (problem instance1_9_2)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 p2 p3 p4 p5 p6 p7 p8 - Position
		b0 b1 - Bar
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
	(can-go h0 p7)
	(can-go h0 p8)

	(hoist-free h0)


	(position-free p0)
	(position-free p1)
	(position-free p2)
	(position-free p3)
	(position-free p4)
	(position-free p5)
	(position-free p6)
	(position-free p7)
	(position-free p8)

	(plant_loading_position p0)
	(plant_unloading_position p8)
	

        
	)

	(:goal
		(and
	(processed b0 p0)
	(processed b1 p0)
	(processed b0 p1)
	(processed b1 p1)
	(processed b0 p2)
	(processed b1 p2)
	(processed b0 p3)
	(processed b1 p3)
	(processed b0 p4)
	(processed b1 p4)
	(processed b0 p5)
	(processed b1 p5)
	(processed b0 p6)
	(processed b1 p6)
	(processed b0 p7)
	(processed b1 p7)
	(processed b0 p8)
	(processed b1 p8)

		)
	)
)

