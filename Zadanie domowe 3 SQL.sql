--zad. 1

with t1 as (
select
	fabd.ad_date,
	fc.campaign_name,
	fa.adset_name,
	fabd.spend,
	fabd.impressions,
	fabd.reach,
	fabd.clicks,
	fabd.leads,
	fabd.value 
from facebook_ads_basic_daily fabd
full join facebook_campaign fc using (campaign_id)
full join facebook_adset fa using (adset_id)
),
t2 as (
select
	ad_date,
	campaign_name,
	adset_name,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
from google_ads_basic_daily gabd)
select * from t1
union all
select * from t2;

-- zad. 2

with t1 as (
select
	fabd.ad_date as ad_date,
	fc.campaign_name as campaign_name,
	sum(fabd.spend) as sspend,
	sum(fabd.impressions) as simpressions,
	sum(fabd.clicks) as sclicks,
	sum(fabd.value) as svalue
from facebook_ads_basic_daily fabd
full join facebook_campaign fc using (campaign_id)
group by
	ad_date,
	campaign_name
order by ad_date asc
),
t2 as (
select
	ad_date,
	campaign_name,
	sum(spend) as sspend,
	sum(impressions) as simpressions,
	sum(clicks) as sclicks,
	sum(value) as svalue
from google_ads_basic_daily gabd
group by
	ad_date,
	campaign_name
order by ad_date asc
)
select * from t1 union all select * from t2;
