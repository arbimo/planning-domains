
(define (problem instance1_3_4)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 p2 - Position
		b0 b1 b2 b3 - Bar
	)

  (:init
	(hoist-at h0 p0)

	(can-go h0 p0)
	(can-go h0 p1)
	(can-go h0 p2)

	(hoist-free h0)


	(position-free p0)
	(position-free p1)
	(position-free p2)

	(plant_loading_position p0)
	(plant_unloading_position p2)
	

        
	)

	(:goal
		(and
	(processed b0 p0)
	(processed b1 p0)
	(processed b2 p0)
	(processed b3 p0)
	(processed b0 p1)
	(processed b1 p1)
	(processed b2 p1)
	(processed b3 p1)
	(processed b0 p2)
	(processed b1 p2)
	(processed b2 p2)
	(processed b3 p2)

		)
	)
)

