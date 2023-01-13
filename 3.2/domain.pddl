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
    depot - location
    robot deliverable person box carrier - thing
    food medicine tools - deliverable)

  ; Define the relations
  (:predicates
    (at ?t - thing ?l - location)    ;box/person/robot/deliverable is at location l
    (empty ?b - box)         ;box ?b is empty
    (filled ?b - box ?d - deliverable)  ;box ?b is filled with deliverable ?d            ###Assumption --> maximum one deliverable 
    (loaded ?b - box ?c - carrier)      ;box ?b is loaded on carrier ?c
    (free ?b)      ; box ?b is not loaded on a carrier
    (has_content ?p - person ?d - deliverable)
    (need ?p - person ?d - deliverable)      ;person ?p needs deliverable ?d
  )

  ;crate count function
  ;(:functions
   ;   (carrier_capacity ?c - carrier)
   ; (box_count ?c - carrier)
  ;)

  ;; fill a box with a content
  (:action fill
    :parameters (?r - robot ?b - box ?d - deliverable ?l - location)
    :precondition (and
      (free ?b)     ;###Assumption --> we can fill a box only if it is not loaded on a carrier
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
      (free ?b)
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

  ;; the robotic agent can load up to four boxes onto a carrier, which all must be at the same location
  (:action load
    :parameters (?r - robot ?b - box ?c - carrier ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?b ?l)
      (at ?c ?l)
      (free ?b)
      ;(< (box_count ?c) (carrier_capacity ?c))
    )
    :effect (and
      (loaded ?b ?c)
      (not (free ?b))
      (not (at ?b ?l))
      ;(increase (box_count ?c) 1)
    )
  )

  ;; the robotic agent can unload one or more box from the carrier to a location where it is
  (:action unload
    :parameters (?r - robot ?b - box ?c - carrier ?l - location)
    :precondition (and
      (at ?r ?l)
      (at ?c ?l)
      (loaded ?b ?c)
    )
    :effect (and
      (at ?b ?l)
      (not (loaded ?b ?c))
      (free ?b)
      ;(decrease (box_count ?c) 1)
    )
  )
  
  ;; the robotic agent can move the carrier to a location
  (:action move_carrier
    :parameters (?r - robot ?c - carrier ?source - location ?destination - location)
    :precondition (and
      (not (= ?source ?destination))
      (at ?r ?source)
      (at ?c ?source)
    )
    :effect (and
      (not (at ?r ?source))(not (at ?c ?source))
      (at ?r ?destination)(at ?c ?destination)
    )
  )

  ;; the robotic agent can move the carrier to a location
  (:action return_to_depot
    :parameters (?r - robot ?c - carrier ?source - location ?destination - depot)
    :precondition (and
      (not (= ?source ?destination))
      (at ?r ?source)
      (at ?c ?source)
      ;(= (box_count ?c) 0)
    )
    :effect (and
      (not (at ?r ?source))(not (at ?c ?source))
      (at ?r ?destination)(at ?c ?destination)
    )
  )
)