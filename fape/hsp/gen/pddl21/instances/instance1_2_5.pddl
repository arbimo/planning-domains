
(define (problem instance1_2_5)

	(:domain mais)

	(:objects
		h0 - Hoist
		p0 p1 - Position
		b0 b1 b2 b3 b4 - Bar
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
	(processed b2 p0)
	(processed b3 p0)
	(processed b4 p0)
	(processed b0 p1)
	(processed b1 p1)
	(processed b2 p1)
	(processed b3 p1)
	(processed b4 p1)

		)
	)
)

