(define (domain emergency_services_logistics)

  (:requirements
    :strips
    :negative-preconditions
    :equality
    :typing
  )
  
  (:types 
    thing - object
    location
    robot deliverable person box - thing
    food medicine tools - deliverable)
    

  (:predicates
    (at ?t - thing ?l - location)    ;box/person/robot/deliverable is at location l
    (empty ?b - box)         ;box ?b is empty
    (filled ?b - box ?d - deliverable)  ;box ?b is filled with deliverable ?d         Assumption --> maximum one deliverable 
    (has_content ?p - person ?d - deliverable)     ;person ?p has deliverable ?d
    (loaded ?r - robot ?b - box)        ;robot ?r is loaded with box ?b
    (is_empty ?r - robot)           ;robot ?r is empty
  )

  ;; fill a box with a content
  (:action fill
    :parameters (?r - robot ?b - box ?d - deliverable ?l - location)
    :precondition (and
      (not (loaded ?r ?b))  ;Assumption --> we can fill a box only if it is not loaded on the robot
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
      (at ?r ?l)          ;Assumption --> same location like fill
      (at ?b ?l)          ;Assumption --> same location like fill
      (filled ?b ?d)
    )
    :effect (and
      (empty ?b)
      (not (filled ?b ?d))
      (at ?d ?l)
    )
  )

;; serve a person in a specific location with a needed content
  (:action serve_person
    :parameters (?d - deliverable ?l - location ?p - person)
    :precondition (and
      (at ?p ?l)
      (at ?d ?l)
      (not (has_content ?p ?d))
    )
    :effect (and
      (has_content ?p ?d)
    )
  )

  ;; pick up a single box and load it on the robotic agent, if it is at the same location as the box
  (:action load
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
      (not (= ?source ?destination))
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
      (not (= ?source ?destination))
      (at ?r ?source)
      (is_empty ?r)
    )
    :effect (and
      (not (at ?r ?source))
      (at ?r ?destination)
    )
  )
  
  ;; unload a single box and leave it on the location, if it is at the same location as the box
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