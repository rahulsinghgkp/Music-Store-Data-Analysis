
-- Question 1:  Who is the senior most employee based on the job title ?

select top 1 * from employee order by levels desc

-- Question 2:  Which countries have the most invoices ?

select top 1 billing_country, count(invoice_id) from invoice group by billing_country order by count(invoice_id) desc

-- Question 3:  What are top 3 values of total invoice ?

select top 3 * from invoice order by total desc

-- Question 4: 
-- Which city has the best customer ? We would like to throw a promotional music festival in the city we made the most money.
-- Write a query that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.

select top 1 billing_city, round(sum(total),2) as Total from invoice group by billing_city order by round(sum(total),2) desc

-- Question 5:
-- Who is the best customer ? The customer who has the spent the more money will be decalred the best customer.
-- Write a query that returns the person who has spent the more money.

select top 1 c.customer_id,c.first_name,c.last_name, round(sum(i.total),2) as 'Total' from customer as c
inner join invoice as i
on c.customer_id = i.customer_id
group by c.customer_id,c.first_name,c.last_name
order by sum(i.total) desc

-- Moderate Level Question
-- Question 6:
-- Write a query to return the email, first name, last name and genre of all rock music listeners. 
-- Return your list ordered alphabetically by email starting with A

-- The table used in this question to get the expected output is
-- customer
-- invoice
-- invoice_line
-- track
-- genre

select distinct customer.first_name,customer.last_name,customer.email from customer 
inner join invoice on customer.customer_id = invoice.customer_id
inner join invoice_line on invoice_line.invoice_id = invoice.invoice_id
where track_id in
(select track_id from track where genre_id =
(select genre_id from genre where name = 'Rock'))
order by email asc

-- Question 7

-- Lets invite the artist who have written the most rock music in our dataset.
-- Write a query that returns the artist name and the total track count of the top 10 rock bands.
-- The table used in this question to get the expected output is
-- artist
-- album
-- track
-- genre

select top 10 artist.name, count(track_id) as 'Total Track' from artist
join album on artist.artist_id = album.artist_id
join track on track.album_id = album.album_id 
where track_id in
(select track_id from track join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock')
group by artist.name
order by count(track_id) desc

-- Question 8:
-- Return all the track names that have a song length longer than the average song length.
-- Return the milliseconds for each track. order by the song length with highest song listed first.

-- The table used in this question to get the expected output is
-- Track
select name, milliseconds from track where milliseconds >
(select avg(milliseconds) from track)
order by milliseconds desc

-- Question 9:
-- Adavnce Level Question
-- Find how much amount spent on each customer on artist ? Write a query to return customer name, artist name, and total spent.

-- The table used in this question to get the expected output is
-- customer
-- invoice
-- invoice_line
-- track
-- album
-- artist


select c.customer_id, c.first_name,c.last_name,ar.name, round(sum(inv.total),2) as 'Total Spent' from customer as c
join invoice as inv on c.customer_id = inv.customer_id
join invoice_line as invl on inv.invoice_id = invl.invoice_id
join track  as t on t.track_id = invl.track_id
join album as a on a.album_id = t.album_id
join artist as ar on ar.artist_id = a.artist_id
group by c.customer_id, c.first_name,c.last_name,ar.name
order by round(sum(inv.total),2) desc

-- Question 10
-- We want to find out the most popular music genre for each country. We determine the most popular genre as the genre with the highest
-- amoount of purchases. Write a query that returns each country along with the top genre. For countries where the maximum number of purchase
-- is shared return all genres.
-- The table used in this question to get the expected output is
-- genre
-- track
-- invoice_line
-- invoice

with popular_genre as (
select  invoice.billing_country, genre.name, count(invoice_line.quantity) as purchase,
row_number() over(partition by invoice.billing_country order by  count(invoice_line.quantity) desc) as rn
from invoice_line 
join invoice on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by invoice.billing_country, genre.name
order by invoice.billing_country asc,  count(invoice_line.quantity) desc )
select * from popular_genre where rn =1


