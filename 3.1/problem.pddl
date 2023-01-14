(define (problem problem_1) (:domain emergency_services_logistics)
(:objects 
    depot loc1 loc2 - location
    alberto alessio stefano - person
    r1 - robot
    b1 - box
    banana apple - food
    aspirin - medicine
)

(:init
    ;box location
    (at b1 depot)
    (empty b1)

    ;robot location
    (at r1 depot)
    (is_empty r1)

    ;deliverable location
    (at banana depot)(at aspirin depot)(at apple depot)

    ;people location
    (at alessio loc1)(at stefano loc1)(at alberto loc2)
)

(:goal (and
    ;alessio needs banana
    (has_content alessio banana)

    ;stefano needs aspirin
    (has_content stefano aspirin)

    ;alberto needs banana
    (has_content alberto apple)
))
)