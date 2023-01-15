(define (problem problem_2) (:domain emergency_services_logistics)
(:objects 
    depot - depot
    loc1 loc2 loc3 - loc
    Alberto Alessio Stefano - person
    r1 - robot
    b1 b2 b3 - box
    c1 - carrier
    banana apple - food
    hammer - tools
    capacity_0 capacity_1 capacity_2 capacity_3 - capacity_number
)

(:init
    ;set carrier capacity to 4
    (capacity c1 capacity_4)
    (capacity_succ capacity_1 capacity_0)
    (capacity_succ capacity_2 capacity_1)
    (capacity_succ capacity_3 capacity_2)
    (capacity_succ capacity_4 capacity_3)

    ;boxes location
    (at_loc b1 depot)(at_loc b2 depot)(at_loc b3 depot)
    ;all boxes are empty
    (empty b1)(empty b2)(empty b3)
    ;all boxes are not loaded on a carrier
    (free b1)(free b2)(free b3)

    ;robot location
    (at_loc r1 depot)

    ;robot is initially available
    (is_available r1)

    ;carrier location
    (at_loc c1 depot)

    ;content location
    (at_loc banana depot)(at_loc apple depot)(at_loc hammer depot)

    ;people location
    (at_loc Alberto loc1)(at_loc Alessio loc1)(at_loc Stefano loc2)
)

(:goal (and
    (has_content Alberto banana)(has_content Alessio apple)(has_content Stefano hammer)
))
)
