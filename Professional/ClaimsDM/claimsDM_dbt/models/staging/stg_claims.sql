-- This model cleans and standardizes the Fact_Claims table

select
    "ClaimSK" as claim_sk, -- Surrogate Key
    "ClaimID" as claim_id, -- Natural Key
    "MemberSK" as member_sk,
    "PolicySK" as policy_sk,
    "ProviderSK" as provider_sk,
    "ClaimDate" as claim_date,
    "ServiceDate" as service_date,
    "ClaimType" as claim_type,
    "ClaimAmount" as claim_amount,
    "PaidAmount" as paid_amount,
    "CopayAmount" as copay_amount,
    "DeductibleAmount" as deductible_amount,
    "ClaimStatus" as claim_status

from {{ source('silver_layer', 'Fact_Claims') }}