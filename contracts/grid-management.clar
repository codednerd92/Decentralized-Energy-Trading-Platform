;; Grid Management Contract

;; Define data structures
(define-map grid-load
  { region: (string-utf8 10) }
  { current-load: uint, capacity: uint }
)

;; Error codes
(define-constant err-region-not-found (err u100))
(define-constant err-unauthorized (err u101))
(define-constant err-overcapacity (err u102))

;; Define the contract owner
(define-data-var contract-owner principal tx-sender)

;; Update grid load for a region
(define-public (update-grid-load (region (string-utf8 10)) (load uint))
  (let ((current-data (unwrap! (map-get? grid-load { region: region }) err-region-not-found)))
    (asserts! (is-eq tx-sender (var-get contract-owner)) err-unauthorized)
    (asserts! (<= load (get capacity current-data)) err-overcapacity)
    (ok (map-set grid-load { region: region }
      (merge current-data { current-load: load })))
  )
)

;; Add a new region
(define-public (add-region (region (string-utf8 10)) (capacity uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) err-unauthorized)
    (ok (map-set grid-load { region: region } { current-load: u0, capacity: capacity }))
  )
)

;; Get grid load for a region
(define-read-only (get-grid-load (region (string-utf8 10)))
  (map-get? grid-load { region: region })
)

;; Change contract owner
(define-public (set-contract-owner (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) err-unauthorized)
    (ok (var-set contract-owner new-owner))
  )
)

