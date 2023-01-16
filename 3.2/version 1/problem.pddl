(define (problem problem_2) (:domain emergency_services_logistics)
(:objects 
    depot - depot
    loc1 loc2 loc3 - loc
    Alberto Alessio Stefano Alice - person
    r1 - robot
    b1 b2 b3 b4 - box
    c1 - carrier
    banana apple cookie - food
    tablet hammer - tools
)

(:init
    ;set carrier capacity to 4
    (=(carrier_capacity c1)4)

    ;set box count to 0
    (=(box_count c1)0)

    ;boxes location
    (at_loc b1 depot)(at_loc b2 depot)(at_loc b3 depot)(at_loc b4 depot)
    ;all boxes are empty
    (empty b1)(empty b2)(empty b3)(empty b4)
    ;all boxes are not loaded on a carrier
    (free b1)(free b2)(free b3)(free b4)

    ;robot location
    (at_loc r1 depot)

    ;carrier location
    (at_loc c1 depot)

    ;content location
    (at_loc banana depot)(at_loc apple depot)(at_loc hammer depot)(at_loc tablet depot)(at_loc cookie depot)

    ;people location
    (at_loc Alberto loc1)(at_loc Alessio loc1)(at_loc Stefano loc2)(at_loc Alice loc3)
)

(:goal (and
    (has_content Alberto banana)(has_content Alessio apple)(has_content Stefano hammer)
))
)