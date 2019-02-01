
(define (problem ${instance_name})

	(:domain ${domain_name})

	(:objects
		${hoists} - Hoist
		${positions} - Position
		${bars} - Bar
	)

  (:init
${hoists_qualitative_position}
${hoists_metric_position}
${hoists_reachable_positions}
${hoists_free}
${hoists_time}

${positions_x}
${positions_free}
${bar_step_info}
${bar_last_step_info}
        
	)

	(:goal
		(and
${bars_last_step_constraint}
		)
	)
)

