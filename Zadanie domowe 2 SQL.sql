--zad. 1

select * from facebook_ads_basic_daily fabd 

select
	ad_date,
	campaign_id,
	sum(spend) as sspend,
	sum(impressions) as simpressions,
	sum(clicks) as sclicks,
	sum(value) as svalue
from facebook_ads_basic_daily
group by
	1,
	2
order by 1 asc;

--zad. 2

select
	ad_date,
	campaign_id,
	sum(spend::float)/nullif(sum(clicks::float), 0) as CPC,
	(sum(spend)/nullif (sum(impressions::float), 0))*1000 as CPM,
	sum(clicks::float)/nullif (sum(impressions::float), 0) as CTR,
	sum(value::float)/nullif (sum(spend::float), 0) as ROMI
from facebook_ads_basic_daily fabd
group by
	ad_date,
	campaign_id
order by ad_date asc;