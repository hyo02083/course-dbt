### How many users do we have?
 - answer: 130
```sql
SELECT count(distinct user_id) as user_cnt
FROM dev_db.dbt_hyo02083webtoonscorpcom.stg_postgres__users
```

### On average, how many orders do we receive per hour?
- answer: 2.03333
```sql
SELECT 
    COUNT(DISTINCT order_id) / COUNT(DISTINCT DATE_TRUNC('hour', delivered_at)) AS avg_orders_per_hour
FROM dev_db.dbt_hyo02083webtoonscorpcom.stg_postgres__orders
WHERE order_id IS NOT NULL
    AND delivered_at IS NOT NULL 
```

### On average, how long does an order take from being placed to being delivered?
- answer: 5604.196721 minute
```sql
SELECT 
    avg(timestampdiff('minute',created_at, delivered_at)) as delivery_duration    
FROM dev_db.dbt_hyo02083webtoonscorpcom.stg_postgres__orders
WHERE created_at IS NOT NULL
    AND delivered_at IS NOT NULL 
```

### How many users have only made one purchase? Two purchases? Three+ purchases?

>Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

- one purchase: 25
- two purchase: 28
- three+ purchase: 71
```sql
SELECT
  order_cnt_class, COUNT(DISTINCT user_id) as user_cnt
FROM
(
    SELECT --* 
        user_id
        , CASE WHEN COUNT(distinct order_id)=1 THEN '_1_purchase'
            WHEN COUNT(distinct order_id)=2 THEN '_2_purchase'
            ELSE 'purchase+' END as order_cnt_class
    FROM dev_db.dbt_hyo02083webtoonscorpcom.stg_postgres__orders
    WHERE user_id IS NOT NULL
        AND order_id IS NOT NULL 
    group by 1
)
group by order_cnt_class
order by order_cnt_class
```

### On average, how many unique sessions do we have per hour?
- answer: 9.965517
```sql
SELECT 
    COUNT(distinct session_id)/ COUNT(distinct DATE_TRUNC('hour',created_at)) avg_session_per_hour
FROM dev_db.dbt_hyo02083webtoonscorpcom.stg_postgres__events
WHERE session_id IS NOT NULL
    AND created_at IS NOT NULL
```