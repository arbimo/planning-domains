
(define (problem instance1_4_2)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 p2 p3 - Position
		b0 b1 - Bar
	)

  (:init
	(hoist-at h0 p0)

	(can-go h0 p0)
	(can-go h0 p1)
	(can-go h0 p2)
	(can-go h0 p3)

	(hoist-free h0)


	(position-free p0)
	(position-free p1)
	(position-free p2)
	(position-free p3)

	(plant_loading_position p0)
	(plant_unloading_position p3)
	

        
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

		)
	)
)

