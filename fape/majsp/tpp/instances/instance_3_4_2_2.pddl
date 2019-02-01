
(define (problem instance3_2_4)

(:domain majsp)

(:objects
	r0 r1 r2 - Robot
	p0 p1 - Position
	t0 t1 - Treatment
	b0 b1 b2 b3 - Pallet
)

(:init
	(robot-at r0 p1)
	(robot-at r1 p1)
	(robot-at r2 p1)

	(robot-free r0)
	(robot-free r1)
	(robot-free r2)

	(= (battery-level r0) 16.0)
	(= (battery-level r1) 16.0)
	(= (battery-level r2) 16.0)


	(pallet-at b0 p1)
	(pallet-at b1 p1)
	(pallet-at b2 p1)
	(pallet-at b3 p1)
	(is-depot p1)

	(position-free p0)
	(position-free p1)

	(can-do p0 t0)
	(can-do p0 t1)

	(= (distance p1 p0) 1)
	(= (distance p0 p1) 1)

	
)

(:goal
	(and
	(treated b0 t0)
	(treated b1 t0)
	(treated b2 t0)
	(treated b3 t0)
	(treated b0 t1)
	(treated b1 t1)
	(treated b2 t1)
	(treated b3 t1)

	)
)
)

