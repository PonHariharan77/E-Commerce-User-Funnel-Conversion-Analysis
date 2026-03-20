use Events;

select top 10 * from events;


-- Total Users --
select count(distinct visitorid) as Total_users from events 


-- Null Analysis --

select 
count(*) as total_rows,
count(transactionid) as not_null,
count(*) - count(transactionid) as null_values
from events

-- Event Distribution --
SELECT event,count(*) from events
group by event;

-- User Per Event --
SELECT 
  event,
  COUNT(DISTINCT visitorid) AS users
FROM events
GROUP BY event;


-- Duplicate Check --
SELECT visitorid, event, itemid, COUNT(*)
FROM events
GROUP BY visitorid, event, itemid
HAVING COUNT(*) > 1;


-- Funnel --
with funnel as(
SELECT visitorid,
	max(case when event = 'view' then 1 else 0 end) as viewed,
	max(case when event = 'addtocart' then 1 else 0 end ) as carted,
	max(case when event = 'transaction' then 1 else 0 end) as bought
from events
group by visitorid 
)
SELECT 
  COUNT(*) AS total_users,
  SUM(viewed) AS view_users,
  SUM(carted) AS cart_users,
  SUM(bought) AS buyers
FROM funnel;


-- Which products fail--
select 
	itemid,
	count(distinct case when event = 'view 'then visitorid end ) as view_users,
	count(distinct case when event = 'addtocart' then visitorid end ) as cart_users
from events
group by itemid
order by view_users desc;

-- User behavior --
select visitorid,
count(*) as Action
from events
group by visitorid;

-- conversion rate -- 


SELECT 
  itemid,

  COUNT(DISTINCT CASE WHEN event = 'view' THEN visitorid END) AS views,

  COUNT(DISTINCT CASE WHEN event = 'addtocart' THEN visitorid END) AS carts,

  COUNT(DISTINCT CASE WHEN event = 'addtocart' THEN visitorid END) * 1.0
  /
  COUNT(DISTINCT CASE WHEN event = 'view' THEN visitorid END) AS conversion_rate

FROM events
GROUP BY itemid
HAVING COUNT(DISTINCT CASE WHEN event = 'view' THEN visitorid END) > 50
ORDER BY conversion_rate asc;





















