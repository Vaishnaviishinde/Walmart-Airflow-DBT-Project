{{
    config(
        materialized='incremental',
        unique_key='order_id',
    )

}}

select *,
    current_timestamp as processed_at
from {{ source ('walmart_databricks', 'orders') }}
WHERE is_active = 'Y'

{% if is_incremental() %}
    AND updated_timestamp > (SELECT COALESCE(MAX(updated_timestamp), '1900-01-01') FROM {{ this }})
{% endif %}