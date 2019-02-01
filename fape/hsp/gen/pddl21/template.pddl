
(define (problem ${instance_name})

	(:domain ${domain_name})

	(:objects
		${hoists} - Hoist
		${positions} - Position
		${bars} - Bar
	)

  (:init
${hoists_qualitative_position}
${hoists_reachable_positions}
${hoists_free}

${positions_free}
${loading_unloading_plant_positions}
	

        
	)

	(:goal
		(and
${bars_position_processed}
		)
	)
)

