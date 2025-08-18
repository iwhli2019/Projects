-- This model cleans and standardizes the Dim_Provider table

select
    "ProviderSK" as provider_sk, -- Surrogate Key
    "ProviderID" as provider_id, -- Natural Key
    "ProviderName" as provider_name,
    "ProviderType" as provider_type,
    "Address" as address,
    "City" as city,
    "Province" as province,
    "PostalCode" as postal_code

from {{ source('silver_layer', 'Dim_Provider') }}