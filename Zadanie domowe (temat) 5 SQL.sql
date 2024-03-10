--zad. 1

with t1 as (
select
	fabd.ad_date,
	fabd.url_parameters,
	coalesce (fabd.spend, 0) as spend,
	coalesce (fabd.impressions, 0) as impressions,
	coalesce (fabd.reach, 0) as reach,
	coalesce (fabd.clicks, 0) as clicks,
	coalesce (fabd.leads, 0) as leads,
	coalesce (fabd.value, 0) as value
from facebook_ads_basic_daily fabd
),
t2 as (
select
	ad_date,
	gabd.url_parameters,
	coalesce (spend, 0) as spend,
	coalesce (impressions, 0) as impressions,
	coalesce (reach, 0) as reach,
	coalesce (clicks, 0) as clicks,
	coalesce (leads, 0) as leads,
	coalesce (value, 0) as value
from google_ads_basic_daily gabd)
select * 
	from t1
union all
select *
	from t2;

-- zad. 2

with t1 as (
select
	fabd.ad_date,
	nullif (substring(fabd.url_parameters, 'utm_campaign=([^&]+)'), 'nan') as utm_campaign,
	sum(fabd.spend) as sspend,
	sum(fabd.impressions) as simpressions,
	sum(fabd.clicks) as sclicks,
	sum(fabd.value) as svalue,
	sum(fabd.clicks::float)/nullif (sum(fabd.impressions::float), 0) as CTR,
	sum(fabd.spend::float)/nullif(sum(fabd.clicks::float), 0) as CPC,
	(sum(fabd.spend)/nullif (sum(fabd.impressions::float), 0))*1000 as CPM,
	sum(fabd.value::float)/nullif (sum(fabd.spend::float), 0) as ROMI
from facebook_ads_basic_daily fabd
	WHERE substring(fabd.url_parameters, 'utm_campaign=([^&]+)') ~ '^[a-z]+$'
	group by ad_date, url_parameters),
t2 as (
select
	gabd.ad_date,
	nullif (substring(gabd.url_parameters, 'utm_campaign=([^&]+)'), 'nan') as utm_campaign,
	sum(gabd.spend) as sspend,
	sum(gabd.impressions) as simpressions,
	sum(gabd.clicks) as sclicks,
	sum(gabd.value) as svalue,
	sum(gabd.clicks::float)/nullif (sum(gabd.impressions::float), 0) as CTR,
	sum(gabd.spend::float)/nullif(sum(gabd.clicks::float), 0) as CPC,
	(sum(gabd.spend)/nullif (sum(gabd.impressions::float), 0))*1000 as CPM,
	sum(gabd.value::float)/nullif (sum(gabd.spend::float), 0) as ROMI
from google_ads_basic_daily gabd
	WHERE substring(gabd.url_parameters, 'utm_campaign=([^&]+)') ~ '^[a-z]+$'
	group by ad_date, url_parameters)
select * 
	from t1
union all
select *
	from t2