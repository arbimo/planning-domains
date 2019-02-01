
(define (problem ${instance_name})

(:domain ${domain_name})

(:objects
	${robots} - Robot
	${positions} - Position
	${treatments} - Treatment
	${pallets} - Pallet
)

(:init
${robots_qualitative_position}
${robots_free}
${battery_level}

${pallets_init_positions}

${position_free}
${positions_can_do}
${distances}
	
)

(:goal
	(and
${pallets_goal_positions}
	)
)
)

