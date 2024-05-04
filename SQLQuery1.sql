select * from dataset_st


-- 1 question  ---You Team must promote shark Tank India season 4, The senior come up with the idea to show highest 
--funding domain wise so that new startups can be attracted, and you were assigned the task to show the same.



select top 10 industry,sum(cast(total_deal_amount_in_lakhs as float))as total_amt from dataset_st
group by industry
order by total_amt desc


-- 2 question  : -You have been assigned the role of finding the domain where female as pitchers have female to male pitcher ratio >70%

with t1 as(
select industry,sum(cast (male_presenters as float))as male,sum(cast (female_presenters as float))as female from dataset_st
group by industry)
select *,(female*100/male)as total_pcnt from t1
where (female*100/male)>70


--3. You are working at marketing firm of Shark Tank India, you have got the task to determine volume of per season 
--sale pitch made, pitches who received offer and pitches that were converted. Also show the percentage of pitches 
--converted and percentage of pitches entertained.


select * from dataset_st


with total_pitch as(
				select season_number, count(pitch_number)as total_pitch from dataset_st
				group by season_number),
	 
	  received_offer as(
				 select season_number, count(pitch_number)as convert_pitch from dataset_st
				 where received_offer='Yes'
				 group by season_number)
select total_pitch.season_number,total_pitch,convert_pitch,(convert_pitch*100/total_pitch)as per
from total_pitch
join received_offer on total_pitch.season_number=received_offer.season_number



--4. As a venture capital firm specializing in investing in startups featured on a renowned entrepreneurship TV show,
--you are determining the season with the highest average monthly sales and identify the top 5 industries with the 
--highest average monthly sales during that season to optimize investment decisions?





select top 5 Industry,avg(cast(Monthly_Sales_in_lakhs as float))as total_avg_amt from dataset_ST
where Season_Number in(
						select top 1 Season_Number from (
								select season_number,avg(cast(Monthly_Sales_in_lakhs as float))as avg_amount from dataset_st
								where Monthly_Sales_in_lakhs !='Not Mentioned'
								group by season_number
								)x
						order by x.avg_amount desc)
and Monthly_Sales_in_lakhs !='Not Mentioned'
group by Industry
order by total_avg_amt desc



--5-As a data scientist at our firm, your role involves solving real-world challenges like identifying industries 
--with consistent increases in funds raised over multiple seasons. This requires focusing on industries where data 
--is available across all three seasons. Once these industries are pinpointed, your task is to delve into the specifics, 
--analyzing the number of pitches made, offers received, and offers converted per season within each industry.


with t1 as(
		select * from dataset_st
		where Industry in(

						select x.Industry from (
									select Industry,sum(cast (Total_Deal_Amount_in_lakhs as float))as total_funds,
											sum (case when Season_Number=1 then cast (Total_Deal_Amount_in_lakhs as float) end)season_1,
											sum (case when Season_Number=2 then cast (Total_Deal_Amount_in_lakhs as float) end)season_2,
											sum (case when Season_Number=3 then cast (Total_Deal_Amount_in_lakhs as float) end)season_3
									from dataset_st
									group by Industry)x
						where x.season_1 is not null and x.season_2 is not null and x.season_3 is not null
						and x.season_3> x.season_2 and x.season_2>x.season_1)
		  ),
piches as(
			select Industry,count(Industry)as Total_Piches from t1
			group by Industry),
rece_offer as(
			select Industry,count(Industry)as Total_received from t1
			where Received_Offer='Yes'
			group by Industry)

select piches.Industry,Total_Piches,Total_received,(Total_received *100/Total_Piches)as Total_piched_convt from piches 
join rece_offer on piches.Industry=rece_offer.Industry



--6. Every shark wants to know in how much year their investment will be returned, so you must create a system for them, 
--where shark will enter the name of the startup�s and the based on the total deal and equity given in how many years 
--their principal amount will be returned and make their investment decisions.

select * from dataset_st


SELECT
	startup_name,
	cast(Yearly_Revenue_in_lakhs as float)as Yearly_Revenue_in_lakhs,
	cast(Total_Deal_Amount_in_lakhs as float)as Total_Deal_Amount_in_lakhs,
	cast(Total_Deal_Equity as float)as Total_Deal_Equity,
	CAST(Total_Deal_Amount_in_lakhs AS FLOAT) / 
	(CAST(Yearly_Revenue_in_lakhs AS FLOAT) * (CAST(Total_Deal_Equity AS FLOAT) / 100)) AS years_to_break_even
FROM
	dataset_ST
WHERE
	Yearly_Revenue_in_lakhs <> 'Not Mentioned' 
	AND CAST(Yearly_Revenue_in_lakhs AS FLOAT) > 0 
	AND Accepted_Offer = 'yes'
	and Startup_Name='BoozScooters'




--7. In the world of startup investing, we're curious to know which big-name investor, often referred to as "sharks,"
--tends to put the most money into each deal on average. This comparison helps us see who's the most generous with their
--investments and how they measure up against their fellow investors.

with  main as (
	select 'Namita' as shark,cast(Namita_Investment_Amount_in_lakhs as float )as Investment from dataset_ST where Namita_Investment_Amount_in_lakhs>'0'
	union all 
	select 'Anupam' as shark,cast(Anupam_Investment_Amount_in_lakhs as float )as Investment from dataset_ST where Anupam_Investment_Amount_in_lakhs>'0'
	union all 
	select 'Aman' as shark,cast(Aman_Investment_Amount_in_lakhs as float )as Investment from dataset_ST where Aman_Investment_Amount_in_lakhs>'0'
	union all 
	select 'Peyush' as shark,cast(Peyush_Investment_Amount_in_lakhs as float )as Investment from dataset_ST where Peyush_Investment_Amount_in_lakhs>'0'
	union all 
	select 'Amit' as shark,cast(Amit_Investment_Amount_in_lakhs as float )as Investment from dataset_ST where Amit_Investment_Amount_in_lakhs>'0'
	union all 
	select 'Ashneer' as shark,cast(Ashneer_Investment_Amount as float )as Investment from dataset_ST where Ashneer_Investment_Amount>'0'
	)
select main.shark,round(AVG(main.investment),2)as Avg_investment from main
where main.investment >0
group by main.shark 
order by Avg_investment desc


