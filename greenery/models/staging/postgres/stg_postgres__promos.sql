
SELECT 
  promo_id ,
  discount ,
  status as promos_status 
FROM {{ source('postgres', 'promos') }}