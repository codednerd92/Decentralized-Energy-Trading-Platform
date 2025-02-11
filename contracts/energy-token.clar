;; Energy Token Contract

;; Define the energy token
(define-fungible-token energy-token)

;; Error codes
(define-constant err-insufficient-balance (err u100))
(define-constant err-unauthorized (err u101))

;; Define the contract owner
(define-data-var contract-owner principal tx-sender)

;; Mint new energy tokens
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) err-unauthorized)
    (ft-mint? energy-token amount recipient)
  )
)

;; Transfer energy tokens
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-unauthorized)
    (ft-transfer? energy-token amount sender recipient)
  )
)

;; Get balance of an account
(define-read-only (get-balance (account principal))
  (ft-get-balance energy-token account)
)

;; Get total supply of energy tokens
(define-read-only (get-total-supply)
  (ft-get-supply energy-token)
)

;; Change contract owner
(define-public (set-contract-owner (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) err-unauthorized)
    (ok (var-set contract-owner new-owner))
  )
)

