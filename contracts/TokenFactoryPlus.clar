(define-constant MAX_SUPPLY u1000000) ;; Maximum supply limit for any token
(define-constant CONTRACT_OWNER tx-sender) ;; Owner of the contract

;; Data structure to store token details
(define-data-var token-details
    { name: (string-ascii 32), symbol: (string-ascii 10), total-supply: uint }
    (tuple (name "") (symbol "") (total-supply u0))
)

;; Map to store balances of users for each token
(define-map balances principal uint)

;; Error codes
(define-constant ERR_NOT_OWNER u100)
(define-constant ERR_INVALID_SUPPLY u101)
(define-constant ERR_INSUFFICIENT_BALANCE u102)
(define-constant ERR_TOKEN_EXISTS u103)

;; Mint a new token with a custom supply, name, and symbol
(define-public (mint-token (name (string-ascii 32)) (symbol (string-ascii 10)) (supply uint))
    (begin
        ;; Ensure the caller is the contract owner
        (asserts! (is-eq tx-sender CONTRACT_OWNER) (err ERR_NOT_OWNER))

        ;; Ensure the supply is valid and within limits
        (asserts! (and (> supply u0) (<= supply MAX_SUPPLY)) (err ERR_INVALID_SUPPLY))

        ;; Ensure the token does not already exist
        (asserts! (is-eq (get total-supply (var-get token-details)) u0) (err ERR_TOKEN_EXISTS))

        ;; Update token details
        (var-set token-details (tuple (name name) (symbol symbol) (total-supply supply)))

        ;; Mint tokens to the contract owner
        (map-set balances tx-sender supply)

        (ok true)
    )
)

;; Transfer tokens from the sender to another principal
(define-public (transfer-tokens (to principal) (amount uint))
    (begin
        ;; Ensure the sender has enough balance
        (asserts! (>= (default-to u0 (map-get? balances tx-sender)) amount) (err ERR_INSUFFICIENT_BALANCE))

        ;; Update sender's balance
        (map-set balances tx-sender (- (default-to u0 (map-get? balances tx-sender)) amount))

        ;; Update recipient's balance
        (map-set balances to (+ (default-to u0 (map-get? balances to)) amount))

        (ok true)
    )
)

;; Burn tokens from the sender's balance
(define-public (burn-tokens (amount uint))
    (begin
        ;; Ensure the sender has enough balance
        (asserts! (>= (default-to u0 (map-get? balances tx-sender)) amount) (err ERR_INSUFFICIENT_BALANCE))

        ;; Update sender's balance
        (map-set balances tx-sender (- (default-to u0 (map-get? balances tx-sender)) amount))

        ;; Update total supply
        (var-set token-details (merge (var-get token-details) (tuple (total-supply (- (get total-supply (var-get token-details)) amount)))))

        (ok true)
    )
)

;; Get the balance of a specific principal
(define-read-only (get-balance (who principal))
    (default-to u0 (map-get? balances who))
)

;; Get token details (name, symbol, total supply)
(define-read-only (get-token-details)
    (var-get token-details)
)