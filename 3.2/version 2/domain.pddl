(define (domain emergency_services_logistics) ; Domain name must match problem's

  (:requirements
    :strips
    :negative-preconditions
    :equality
    :typing
  )
  
  (:types 
    thing - object
    location - object
    depot loc - location
    robot deliverable person box carrier - thing
    food medicine tools - deliverable
    capacity_number - object)

  ; Define the relations
  (:predicates
    (at_loc ?t - thing ?l - location)    ;box/person/robot/deliverable is at location l
    (empty ?b - box)         ;box ?b is empty
    (filled ?b - box ?d - deliverable)  ;box ?b is filled with deliverable ?d       Assumption --> maximum one deliverable 
    (loaded ?b - box ?c - carrier)      ;box ?b is loaded on carrier ?c
    (free ?b - box)      ; box ?b is not loaded on a carrier
    (has_content ?p - person ?d - deliverable)    ;person ?p has deliverable ?d
    (capacity ?c - carrier ?n - capacity_number)    ;the current available capacity ?n of the carrier ?c
    (capacity_succ ?n1 - capacity_number ?n2 - capacity_number)     ;capacity number ?n1 is the one after capacity number ?n2
  )

  ;; fill a box with a content
  (:action fill
    :parameters (?r - robot ?b - box ?d - deliverable ?l - location)
    :precondition (and
      (free ?b)     ;Assumption --> we can fill a box only if it is not loaded on a carrier
      (empty ?b)
      (at_loc ?r ?l)
      (at_loc ?d ?l)
      (at_loc ?b ?l)
    )
    :effect (and
      (not (empty ?b))
      (filled ?b ?d)
      (not (at_loc ?d ?l))
    )
  )
  
  ;; empty a box by leaving the content to the current location
  (:action empty_box
    :parameters (?r - robot ?b - box ?d - deliverable ?l - location)
    :precondition (and
      (not (empty ?b))
      (free ?b)
      (at_loc ?r ?l)          ;Assumption --> same location like fill
      (at_loc ?b ?l)          ;Assumption --> same location like fill
      (filled ?b ?d)
    )
    :effect (and
      (empty ?b)
      (not (filled ?b ?d))
      (at_loc ?d ?l)
    )
  )

;; empty a box by leaving the content to the current location
  (:action serve_person
    :parameters (?d - deliverable ?l - location ?p - person)
    :precondition (and
      (at_loc ?p ?l)
      (at_loc ?d ?l)
      (not (has_content ?p ?d))
    )
    :effect (and
      (has_content ?p ?d)
    )
  )

  ;; the robotic agent can load up to four boxes onto a carrier, which all must be at the same location
  (:action load
    :parameters (?r - robot ?b - box ?c - carrier ?l - location ?n1 - capacity_number ?n2 - capacity_number)
    :precondition (and
      (at_loc ?r ?l)
      (at_loc ?b ?l)
      (at_loc ?c ?l)
      (free ?b)
      (capacity_succ ?n2 ?n1)
      (capacity ?c ?n2)
    )
    :effect (and
      (loaded ?b ?c)
      (not (free ?b))
      (not (at_loc ?b ?l))
      (not (capacity ?c ?n2))
      (capacity ?c ?n1)
    )
  )

  ;; the robotic agent can unload one or more box from the carrier to a location where it is
  (:action unload
    :parameters (?r - robot ?b - box ?c - carrier ?l - location ?n1 - capacity_number ?n2 - capacity_number)
    :precondition (and
      (at_loc ?r ?l)
      (at_loc ?c ?l)
      (loaded ?b ?c)
      (capacity_succ ?n2 ?n1)
      (capacity ?c ?n1)
    )
    :effect (and
      (at_loc ?b ?l)
      (not (loaded ?b ?c))
      (free ?b)
      (not (capacity ?c ?n1))
      (capacity ?c ?n2)
    )
  )
  
  ;; the robotic agent can move the carrier to a location
  (:action move_carrier
    :parameters (?r - robot ?c - carrier ?source - location ?destination - loc)
    :precondition (and
      (not (= ?source ?destination))
      (at_loc ?r ?source)
      (at_loc ?c ?source)
    )
    :effect (and
      (not (at_loc ?r ?source))(not (at_loc ?c ?source))
      (at_loc ?r ?destination)(at_loc ?c ?destination)
    )
  )

  ;; the robotic agent can move the carrier to a location
  (:action return_to_depot
    :parameters (?r - robot ?c - carrier ?source - location ?destination - depot ?n - capacity_number ?n1 - capacity_number)
    :precondition (and
      (not (= ?source ?destination))
      (at_loc ?r ?source)
      (at_loc ?c ?source)
      (capacity ?c ?n)
      (forall (?n1)
        (not (capacity_succ ?n1 ?n))
      )
    )
    :effect (and
      (not (at_loc ?r ?source))(not (at_loc ?c ?source))
      (at_loc ?r ?destination)(at_loc ?c ?destination)
    )
  )
)