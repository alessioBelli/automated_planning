(define (domain emergency_services_logistics) ; Domain name must match problem's

  ; Define what the planner must support to execute this domain
  ; Only domain requirements are currently supported
  (:requirements
    :strips                 ; basic preconditions and effects
    :negative-preconditions ; to use not in preconditions
    :equality               ; to use = in preconditions
    :typing               ; to define type of objects and parameters 
  )
  
  (:types 
    thing - object
    location
    robot deliverable person box - thing
    food medicine tools - deliverable)
    

  ; Define the relations
  (:predicates
    (at ?t - thing ?l - location)    ;box/person/robot/deliverable is at location l
    (empty ?b - box)         ;box ?b is empty
    (filled ?b - box ?d - deliverable)  ;box ?b is filled with deliverable ?d            ###Assumption --> maximum one deliverable 
    (has_content ?p - person ?d - deliverable)
    (loaded ?r - robot ?b - box)        ;robot ?r is loaded with box ?b
    (is_empty ?r - robot)           ;robot ?r is empty
    (need ?p - person ?d - deliverable)      ;person ?p needs deliverable ?d
  )

  ;; fill a box with a content
  (:action fill
    :parameters (?r - robot ?b - box ?d - deliverable ?l - location)
    :precondition (and
      (not (loaded ?r ?b))     ;###Assumption --> we can fill a box only if it is not loaded on the robot
      (empty ?b)
      (at ?r ?l)
      (at ?d ?l)
      (at ?b ?l)
    )
    :effect (and
      (not (empty ?b))
      (filled ?b ?d)
      (not (at ?d ?l))
    )
  )
  
  ;; empty a box by leaving the content to the current location
  (:action empty_box
    :parameters (?r - robot ?b - box ?d - deliverable ?l - location)
    :precondition (and
      (not (empty ?b))
      (not (loaded ?r ?b))
      (at ?r ?l)          ; ### Assumption --> same location like fill
      (at ?b ?l)          ; ### Assumption --> same location like fill
      (filled ?b ?d)
    )
    :effect (and
      (empty ?b)
      (not (filled ?b ?d))
      (at ?d ?l)
    )
  )

;; empty a box by leaving the content to the current location
  (:action serve_people
    :parameters (?d - deliverable ?l - location ?p - person)
    :precondition (and
      (at ?p ?l)
      (at ?d ?l)
      (not (has_content ?p ?d))
      (need ?p ?d)
    )
    :effect (and
      (has_content ?p ?d)
      (not (need ?p ?d))
    )
  )

  ;; pick up a single box and load it on the robotic agent, if it is at the same location as the box
  (:action pickup
    :parameters (?r - robot ?b - box ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?b ?l)
      (is_empty ?r)        ; Assumption 1 only
    )
    :effect (and
      (loaded ?r ?b)
      (not (is_empty ?r))
      (not (at ?b ?l))
    )
  )
  
  ;; move to another location moving the loaded box (if the box has been loaded, otherwise it simply moves)
  (:action move_with_box
    :parameters (?r - robot ?source - location ?destination - location ?b - box)
    :precondition (and
      (at ?r ?source)
      (loaded ?r ?b)
    )
    :effect (and
      (not (at ?r ?source))
      (at ?r ?destination)
    )
  )

  ;; move to another location moving the loaded box (if the box has been loaded, otherwise it simply moves)
  (:action move_without_box
    :parameters (?r - robot ?source - location ?destination - location)
    :precondition (and
      (at ?r ?source)
      (is_empty ?r)
    )
    :effect (and
      (not (at ?r ?source))
      (at ?r ?destination)
    )
  )
  
  (:action unload
    :parameters (?r - robot ?b - box ?l - location)
    :precondition (and
      (at ?r ?l)
      (loaded ?r ?b)
    )
    :effect (and
      (at ?b ?l)
      (not (loaded ?r ?b))
      (is_empty ?r)
    )
  )
)