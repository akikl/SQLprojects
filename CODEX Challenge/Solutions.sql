-- CODEX CHALLENGE --
--------------------------------------------------------------------------------------------------------------
-- 1. Demographic Insights (examples)
-- a. Who prefers energy drink more? (male/female/non-binary?)
select Gender,count(f.respondent_id) Total_respondents
from fact_survey_responses f
join dim_repondents r
on r.respondent_id=f.respondent_id
group by Gender
order by Total_respondents desc;
-----------------------------------------------------------------------------------------------------------
-- b. Which age group prefers energy drinks more?
select Age,count(f.respondent_id) Total_respondents
from fact_survey_responses f
join dim_repondents r
on r.respondent_id=f.respondent_id
group by Age
order by Total_respondents desc;
--------------------------------------------------------------------------------------------------------------
-- c.Which type of marketing reaches the most Youth (15-30)?
select marketing_channels,age,count(marketing_channels) as Total_Reach 
from fact_survey_responses f 
join dim_repondents r on f.Respondent_ID=r.respondent_id
where age in ("15-18" , "19-30")
group by Marketing_channels,age
order by age,Total_Reach desc;
--------------------------------------------------------------------------------------------------------------
-- 2 Consumer Preferences:
-- a. What are the preferred ingredients of energy drinks among respondents?
select Ingredients_expected,count(respondent_id) 
Total_respondents
from fact_survey_responses 
group by Ingredients_expected
order by Total_respondents desc;
--------------------------------------------------------------------------------------------------------------
-- b. What packaging preferences do respondents have for energy drinks?
select Packaging_preference,count(respondent_id) Total_respondents
from fact_survey_responses 
group by Packaging_preference
order by Total_respondents desc;
--------------------------------------------------------------------------------------------------------------
-- 3. Competition Analysis:
-- a. Who are the current market leaders?
select current_brands,count(respondent_id) Total_respondents
from fact_survey_responses 
group by Current_brands
order by Total_respondents desc;
--------------------------------------------------------------------------------------------------------------
-- b. What are the primary reasons consumers prefer those brands over ours?
select Reasons_for_choosing_brands,count(respondent_id) 
Total_respondents 
from fact_survey_responses where Current_brands<>"Codex"
group by Reasons_for_choosing_brands
order by Total_respondents desc;
--------------------------------------------------------------------------------------------------------------
-- 4. Marketing Channels and Brand Awareness:
-- a. Which marketing channel can be used to reach more customers?
select marketing_channels,count(marketing_channels) as Total_Reach 
from fact_survey_responses f 
join dim_repondents r on f.Respondent_ID=r.respondent_id
group by Marketing_channels
order by Total_Reach desc;
--------------------------------------------------------------------------------------------------------------
-- b. How effective are different marketing strategies and channels in reaching our customers?
with cte_1 as(select Marketing_channels,count(f.respondent_id) yes_respondents
from fact_survey_responses f
where Heard_before="yes"
group by Marketing_channels
order by yes_respondents),
cte_2 as(select Marketing_channels,count(f.respondent_id) Total_respondents
from fact_survey_responses f
group by Marketing_channels
order by Total_respondents)
select *, round((yes_respondents/Total_respondents)*100,2) Reach_pct
from cte_1 join cte_2 on cte_1.marketing_channels=cte_2.marketing_channels
order by Reach_pct;
--------------------------------------------------------------------------------------------------------------
-- 5. Brand Penetration:
-- a. What do people think about our brand? (overall rating)
select avg(Taste_experience) Overall_rating 
from fact_survey_responses;
--------------------------------------------------------------------------------------------------------------
-- b. Which cities do we need to focus more on?
with cte_1 as(select city,count(f.respondent_id) yes_respondents
from fact_survey_responses f
join dim_repondents r on r.Respondent_ID=f.Respondent_ID
join dim_cities c on r.City_ID=c.City_ID
where Heard_before="yes"
group by City
order by yes_respondents),
cte_2 as(select city,count(f.respondent_id) Total_respondents
from fact_survey_responses f
join dim_repondents r on r.Respondent_ID=f.Respondent_ID
join dim_cities c on r.City_ID=c.City_ID
group by City
order by Total_respondents)
select *, round((yes_respondents/Total_respondents)*100,2) penetration_pct
from cte_1 join cte_2 on cte_1.city=cte_2.city
order by penetration_pct;
--------------------------------------------------------------------------------------------------------------
-- 6. Purchase Behavior:
-- a. Where do respondents prefer to purchase energy drinks?
select Purchase_location,count(respondent_id) Total_respondents
from fact_survey_responses
group by Purchase_location
order by Total_respondents desc;
--------------------------------------------------------------------------------------------------------------
-- b. What are the typical consumption situations for energy drinks among respondents?
select Typical_consumption_situations,count(respondent_id) Total_respondents 
from fact_survey_responses where Current_brands<>"Codex"
group by Typical_consumption_situations
order by Total_respondents desc;
--------------------------------------------------------------------------------------------------------------
-- c. What factors influence respondents' purchase decisions, such as price range and limited edition packaging?
SELECT price_range,Limited_edition_packaging, 
COUNT(*) AS Total_respondents
FROM fact_survey_responses
GROUP BY price_range,Limited_edition_packaging
order by Total_respondents desc;
--------------------------------------------------------------------------------------------------------------
-- 7. Product Development
-- a. Which area of business should we focus more on our product development?(Branding/taste/availability)
select Reasons_for_choosing_brands,count(respondent_id) Total_respondents
from fact_survey_responses
group by Reasons_for_choosing_brands
order by Total_respondents desc;
--------------------------------------------------------------------------------------------------------------
-- Recommendations
-- What immediate improvements can we bring to the product?
select Improvements_desired,count(respondent_id) Total_respondents
from fact_survey_responses
group by Improvements_desired
order by Total_respondents desc;
--------------------------------------------------------------------------------------------------------------
-- What should be the ideal price of our product?
Select Price_range,count(respondent_id) Total_respondents
from fact_survey_responses
group by Price_range
order by Total_respondents desc