--Zad. 1
with all_adds_data as (
	select
	fabd.ad_date,
	fabd.url_parameters,
	coalesce(fabd.spend,0) as spend,
	coalesce(fabd.impressions,0) as impressions,
	coalesce(fabd.reach,0) as reach,
	coalesce(fabd.clicks,0) as clicks,
	coalesce(fabd.leads,0) as leads,
	coalesce(fabd.value,0) as value
	from public.facebook_ads_basic_daily fabd
	union
	select
	gabd.ad_date,
	gabd.url_parameters,
	coalesce(spend,0) as spend,
	coalesce(impressions,0) as impressions,
	coalesce(reach,0) as reach,
	coalesce(clicks,0) as clicks,
	coalesce(leads,0) as leads,
	coalesce(value,0) as value
	from public.google_ads_basic_daily gabd
),
-- Zad. 2
starts as (
select
	date_trunc('month', aad.ad_date) as ad_month, 
	case
		when substring(aad.url_parameters,'utm_campaign=([^&$]+)') = 'nan' then null
		else lower(substring(aad.url_parameters,'utm_campaign=([^&$]+)'))
		end as utm_campaign,
	sum(aad.spend) as sum_spend, 
	sum(aad.impressions) as sum_impressions,
	sum(aad.clicks) as sum_clicks,
	sum(aad.value) as sum_value,
	case 
		when sum(aad.impressions) > 0 then sum(aad.clicks)::numeric/sum(aad.impressions)
		end as CTR,
	case 
		when sum(aad.clicks) > 0 then sum(aad.spend)::numeric/sum(aad.clicks)
		end as CPC,
	case 
		when sum(aad.impressions) > 0 then 1000*sum(aad.spend)/sum(aad.impressions)
		end as CPM,
	case 
		when sum(aad.spend) > 0 then sum(aad.value)::numeric/sum(aad.spend)
		end as ROMI
from all_adds_data aad
group by 1,2
)
select 
	s.*,
	-- Zad. 3
	round((100*(s.CPM - lag(s.CPM) over (partition by s.utm_campaign order by s.ad_month))/nullif(lag(s.CPM)
	over (partition by s.utm_campaign order by s.ad_month),0)),3) as CPM_diff,
	round((100*(s.CTR - lag(s.CTR) over (partition by s.utm_campaign order by s.ad_month))/nullif(lag(s.CTR)
	over (partition by s.utm_campaign order by s.ad_month),0)),3) as CTR_diff,
	round((100*(s.ROMI - lag(s.ROMI) over (partition by s.utm_campaign order by s.ad_month))/nullif(lag(s.ROMI)
	over (partition by s.utm_campaign order by s.ad_month),0)),3) as ROMI_diff
from starts s;
