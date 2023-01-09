(define (problem problem_1) (:domain emergency_services_logistics)
(:objects 
    depot loc1 loc2 - location
    p1 p2 - person
    r1 - robot
    b1 - box
    food medicine - deliverable
)

(:init
    (at b1 depot)
    (empty b1)
    (at r1 depot)
    (at food depot)
    (at medicine depot)
    (at p1 loc1)
    (at p2 loc2)
    (is_empty r1)
    (not (has_content p1 food))
    (need p1 food)
    (not (has_content p2 food))
    (need p2 food)
)

(:goal (and
    (has_content p1 food)
    (not (need p1 food))
    (has_content p2 food)
    (not (need p2 food))
))
)