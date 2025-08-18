-- This model cleans and standardizes the Fact_Financial_Transactions table

select
    "TransactionSK" as transaction_sk,
    "ClaimSK" as claim_sk,
    "TransactionDate" as transaction_date,
    "TransactionType" as transaction_type,
    "Amount" as transaction_amount

from {{ source('silver_layer', 'Fact_Financial_Transactions') }}