;; Smart Meter Integration Contract

;; Define data structures
(define-map meter-readings
  { meter-id: (string-utf8 20) }
  { owner: principal, reading: uint, timestamp: uint }
)

;; Error codes
(define-constant err-unauthorized (err u100))
(define-constant err-invalid-meter (err u101))

;; Define the contract owner
(define-data-var contract-owner principal tx-sender)

;; Register a new smart meter
(define-public (register-meter (meter-id (string-utf8 20)))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) err-unauthorized)
    (ok (map-set meter-readings { meter-id: meter-id }
      { owner: tx-sender, reading: u0, timestamp: block-height }))
  )
)

;; Update meter reading
(define-public (update-reading (meter-id (string-utf8 20)) (reading uint))
  (let ((meter (unwrap! (map-get? meter-readings { meter-id: meter-id }) err-invalid-meter)))
    (asserts! (is-eq tx-sender (get owner meter)) err-unauthorized)
    (ok (map-set meter-readings { meter-id: meter-id }
      (merge meter { reading: reading, timestamp: block-height })))
  )
)

;; Get meter reading
(define-read-only (get-reading (meter-id (string-utf8 20)))
  (map-get? meter-readings { meter-id: meter-id })
)

;; Change contract owner
(define-public (set-contract-owner (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) err-unauthorized)
    (ok (var-set contract-owner new-owner))
  )
)

