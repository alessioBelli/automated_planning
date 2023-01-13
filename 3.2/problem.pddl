(define (problem problem_2) (:domain emergency_services_logistics)
(:objects 
    depot - depot
    loc1 - location
    p1 p2 - person
    r1 - robot
    b1 b2 - box
    c1 - carrier
    food medicine - deliverable
)

(:init
    ;set carrier capacity to 4
    ;(=(carrier_capacity c1)4)
    ;(=(box_count c1)0)
    (at b1 depot)
    (empty b1)
    (at b2 depot)
    (empty b2)
    (free b1)
    (free b2)
    (at r1 depot)
    (at food depot)
    (at medicine depot)
    (at p1 loc1)
    (at p2 loc1)
    (not (has_content p1 food))
    (need p1 food)
    (not (has_content p2 medicine))
    (need p2 medicine)
    (at c1 depot)
)

(:goal (and
    (has_content p1 food)
    (not (need p1 food))
    (has_content p2 medicine)
    (not (need p2 medicine))
))
)