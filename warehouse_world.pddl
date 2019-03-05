(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment 
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

(:action robotMove
      :parameters (?r - robot ?l - location ?sl - location)
      :precondition (and (free ?r) (connected ?l ?sl) (at ?r ?l) (no-robot ?sl))
      :effect (and (at ?r ?sl) (not (no-robot ?sl)) (not (at ?r ?l)) (no-robot ?l))
   )

   (:action robotMoveWithPallette
      :parameters (?r - robot ?l - location ?sl - location ?p - pallette)
      :precondition (and (at ?r ?l) (at ?p ?l) (connected ?l ?sl) (free ?r) (no-robot ?sl) (no-pallette ?sl))
      :effect (and (at ?r ?sl) (not (at ?p ?l)) (not (no-robot ?sl)) (not (no-pallette ?sl)) (not (at ?r ?l)) (no-robot ?l) (at ?p ?sl) (no-pallette ?l))
   )

   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?p - pallette ?si - saleitem ?o - order)
      :precondition (and (at ?p ?l) (packing-at ?s ?l) (packing-location ?l) (contains ?p ?si) (ships ?s ?o) (started ?s) (orders ?o ?si))
      :effect (and (includes ?s ?si) (not (contains ?p ?si)))
   )

   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (ships ?s ?o) (not (complete ?s)) (packing-location ?l) (packing-at ?s ?l))
      :effect (and (not (started ?s)) (complete ?s) (available ?l) (not (packing-at ?s ?l)))
   )

)
