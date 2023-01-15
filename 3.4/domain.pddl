(define (domain emergency_services_logistics)

  (:requirements
    :strips
    :equality
    :typing
    :durative-actions
    :duration-inequalities
  )
  
  (:types 
    thing - object
    location - object
    depot loc - location
    robot deliverable person box carrier - thing
    food medicine tools - deliverable
    capacity_number - object)

  (:constants
    capacity_4 - capacity_number
  )

  (:predicates
    (at_loc ?t - thing ?l - location)    ;box/person/robot/deliverable is at location l
    (empty ?b - box)         ;box ?b is empty
    (full ?b - box)  ;box ?b is full
    (filled ?b - box ?d - deliverable)  ;box ?b is filled with deliverable ?d       Assumption --> maximum one deliverable 
    (loaded ?b - box ?c - carrier)      ;box ?b is loaded on carrier ?c
    (free ?b - box)      ; box ?b is not loaded on a carrier
    (has_content ?p - person ?d - deliverable)    ;person ?p has deliverable ?d
    (capacity ?c - carrier ?n - capacity_number)    ;the current available capacity ?n of the carrier ?c
    (capacity_succ ?n1 - capacity_number ?n2 - capacity_number)     ;capacity number ?n1 is the one after capacity number ?n2
    (is_available ?r - robot)    ;avoid parallel actions
  )

  ;; fill a box with a content
  (:durative-action fill
    :parameters (?r - robot ?b - box ?d - deliverable ?l - location)
    :duration (= ?duration 3)
    :condition (and
      (at start (at_loc ?d ?l))
      (at start (empty ?b))
      (over all (at_loc ?r ?l))
      (over all (at_loc ?b ?l))
      (over all (free ?b))
      (at start (is_available ?r))
    )
    :effect (and
      (at start (not (at_loc ?d ?l)))
      (at end (full ?b))
      (at end (not (empty ?b)))
      (at end (filled ?b ?d))
      (at start (not (is_available ?r)))
      (at end (is_available ?r))
    )
  )
  
  ;; empty a box by leaving the content to the current location
  (:durative-action empty_box
    :parameters (?r - robot ?b - box ?d - deliverable ?l - location)
    :duration (= ?duration 3)
    :condition (and
      (at start (full ?b))
      (at start (filled ?b ?d))
      (over all (free ?b))
      (over all (at_loc ?r ?l))
      (over all (at_loc ?b ?l))
      (at start (is_available ?r))
    )
    :effect (and
      (at end (empty ?b))
      (at end (not (filled ?b ?d)))
      (at end (at_loc ?d ?l))
      (at end (not (full ?b)))
      (at start (not (is_available ?r)))
      (at end (is_available ?r))
    )
  )

  ;; empty a box by leaving the content to the current location
  (:durative-action serve_person
    :parameters (?d - deliverable ?l - location ?p - person)
    :duration (= ?duration 1)
    :condition (and
      (over all (at_loc ?p ?l))
      (over all (at_loc ?d ?l))
    )
    :effect (and
      (at end (has_content ?p ?d))
    )
  )

  ;; the robotic agent can load up to four boxes onto a carrier, which all must be at the same location
  (:durative-action load
    :parameters (?r - robot ?b - box ?c - carrier ?l - location ?n1 - capacity_number ?n2 - capacity_number)
    :duration (and (>= ?duration 5) (<= ?duration 10))
    :condition (and
      (over all (at_loc ?r ?l))
      (at start (at_loc ?b ?l))
      (over all (at_loc ?c ?l))
      (at start (free ?b))
      (over all (capacity_succ ?n2 ?n1))
      (at start (capacity ?c ?n2))
      (at start (is_available ?r))
    )
    :effect (and
      (at end (loaded ?b ?c))
      (at end (not (free ?b)))
      (at start (not (at_loc ?b ?l)))
      (at end (not (capacity ?c ?n2)))
      (at end (capacity ?c ?n1))
      (at start (not (is_available ?r)))
      (at end (is_available ?r))
    )
  )

  ;; the robotic agent can unload one or more box from the carrier to a location where it is
  (:durative-action unload
    :parameters (?r - robot ?b - box ?c - carrier ?l - location ?n1 - capacity_number ?n2 - capacity_number)
    :duration (and (>= ?duration 5) (<= ?duration 10))
    :condition (and
      (over all (at_loc ?r ?l))
      (over all (at_loc ?c ?l))
      (at start (loaded ?b ?c))
      (over all (capacity_succ ?n2 ?n1))
      (at start (capacity ?c ?n1))
      (at start (is_available ?r))
    )
    :effect (and
      (at end (at_loc ?b ?l))
      (at start (not (loaded ?b ?c)))
      (at end (free ?b))
      (at end (not (capacity ?c ?n1)))
      (at end (capacity ?c ?n2))
      (at start (not (is_available ?r)))
      (at end (is_available ?r))
    )
  )
  
  ;; the robotic agent can move the carrier to a location
  (:durative-action move_carrier
    :parameters (?r - robot ?c - carrier ?source - location ?destination - loc)
    :duration (and (>= ?duration 6) (<= ?duration 12))
    :condition (and
      (at start (at_loc ?r ?source))
      (at start (at_loc ?c ?source))
      (at start (is_available ?r))
    )
    :effect (and
      (at start (not (at_loc ?r ?source)))
      (at start (not (at_loc ?c ?source)))
      (at end (at_loc ?r ?destination))
      (at end (at_loc ?c ?destination))
      (at start (not (is_available ?r)))
      (at end (is_available ?r))
    )
  )

  ;; the robotic agent can move the carrier to a location
  (:durative-action return_to_depot
    :parameters (?r - robot ?c - carrier ?source - location ?destination - depot ?n - capacity_number)
    :duration (and (>= ?duration 6) (<= ?duration 12))
    :condition (and
      (at start (at_loc ?r ?source))
      (at start (at_loc ?c ?source))
      (over all (capacity ?c ?n))
      (over all (= ?n capacity_4))
      (at start (is_available ?r))
    )
    :effect (and
      (at start (not (at_loc ?r ?source)))
      (at start (not (at_loc ?c ?source)))
      (at end (at_loc ?r ?destination))
      (at end (at_loc ?c ?destination))
      (at start (not (is_available ?r)))
      (at end (is_available ?r))
    )
  )
)