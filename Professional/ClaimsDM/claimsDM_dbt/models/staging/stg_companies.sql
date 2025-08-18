-- This model cleans and standardizes the Dim_Company table

selectcd../

    "ClaimSK" as claim_sk, -- Surrogate Key
    "company_id",
    "company_name",
    "company_address",
    "city" as company_city,
    "province" as company_province,
    "postal_code": fake.postalcode(),
from {{ source('silver_layer', 'Dim_Company') }}