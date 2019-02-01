
(define (problem instance1_2_2)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 - Position
		b0 b1 - Bar
	)

  (:init
	(hoist-at h0 p0)

	(can-go h0 p0)
	(can-go h0 p1)

	(hoist-free h0)


	(position-free p0)
	(position-free p1)

	(plant_loading_position p0)
	(plant_unloading_position p1)
	

        
	)

	(:goal
		(and
	(processed b0 p0)
	(processed b1 p0)
	(processed b0 p1)
	(processed b1 p1)

		)
	)
)

