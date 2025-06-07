;; Title: StackTag - Decentralized Payment Request Protocol
;;
;; Summary: 
;; A revolutionary Bitcoin Layer 2 payment request system that enables seamless,
;; trustless invoice creation and settlement using sBTC on the Stacks blockchain.
;;
;; Description:
;; StackTag transforms how payments are requested and processed in the Bitcoin ecosystem.
;; Create secure, time-bound payment requests with optional memos, track fulfillment 
;; status, and enable instant Bitcoin settlements through Stacks Layer 2 infrastructure.
;; Perfect for merchants, freelancers, and anyone needing reliable payment workflows
;; with Bitcoin's security and programmability.
;;
;; Key Features:
;; - Decentralized invoice/payment request creation
;; - Automatic expiration handling with configurable timeouts  
;; - sBTC integration for instant Bitcoin settlements
;; - Comprehensive payment tracking and history
;; - Creator-controlled cancellation system
;; - Multi-indexed data structure for efficient querying
;; - Event-driven architecture for real-time updates
;;
;; Security: Built with Bitcoin-grade security standards, leveraging Stacks' 
;; proof-of-transfer consensus and native sBTC integration.
;;

;; Constants

;; Error codes
(define-constant ERR-TAG-EXISTS u100)
(define-constant ERR-NOT-PENDING u101)
(define-constant ERR-INSUFFICIENT-FUNDS u102)
(define-constant ERR-NOT-FOUND u103)
(define-constant ERR-UNAUTHORIZED u104)
(define-constant ERR-EXPIRED u105)
(define-constant ERR-INVALID-AMOUNT u106)
(define-constant ERR-EMPTY-MEMO u107)
(define-constant ERR-MAX-EXPIRATION-EXCEEDED u108)

;; State constants
(define-constant STATE-PENDING "pending")
(define-constant STATE-PAID "paid")
(define-constant STATE-EXPIRED "expired")
(define-constant STATE-CANCELED "canceled")

;; Official sBTC token contract
(define-constant SBTC-CONTRACT 'ST1F7QA2MDF17S807EPA36TSS8AMEFY4KA9TVGWXT.sbtc-token)

;; Contract owner (for potential upgrades or admin functions)
(define-constant CONTRACT-OWNER tx-sender)

;; Maximum expiration time (30 days in blocks, assuming ~10 min per block)
(define-constant MAX-EXPIRATION-BLOCKS u4320) ;; ~30 days

;; Data Maps

;; Main map to store payment tags
(define-map pay-tags
  { id: uint }
  {
    creator: principal,
    recipient: principal,
    amount: uint,
    created-at: uint,
    expires-at: uint,
    memo: (optional (string-ascii 256)),
    state: (string-ascii 16),
    payment-tx: (optional (buff 32)), ;; txid when paid
  }
)

;; Index of tags by creator
(define-map tags-by-creator
  { creator: principal }
  { ids: (list 50 uint) }
)

;; Index of tags by recipient
(define-map tags-by-recipient
  { recipient: principal }
  { ids: (list 50 uint) }
)