/*Triggers*/
/*Trigger to update balance on transaction*/
Go
create trigger updatebalancetrigger
on Bank.Transactions
after insert
as
declare @Amount bigint 
declare @Balance bigint
declare @Type varchar(10)
declare @ACC1 bigint
select @ACC1=t.Account_No,@Amount=t.Amount,@Type=t.Trans_type from inserted t 
select @Balance=a.Balance from Bank.Accounts a where Account_No=@ACC1
if(@Amount<@Balance AND @Type='Withdrawal')
set @Balance=@Balance-@Amount
if(@Type='Deposit')
set @Balance=@Balance+@Amount
update Bank.Accounts set Balance=@Balance where Account_No=@ACC1
print 'Update Trigger Fired'

/*SQL Queries*/
/*Correlated-Nested Queries*/
/*1. Return Transaction_ID's of the transactions performed by Rahul*/
Select Transaction_ID
From Bank.Transactions t
Where Account_No IN(
select Account_No 
from Bank.Accounts a 
where CIF IN(
select CIF 
from Bank.Customer where First_Name='Ram'));

/*2. Return CIF and Account_No of a customer who inputs her Identifcation_No as 92716382046*/
select CIF,Account_No
From Bank.Accounts a
where CIF IN(
select CIF from Bank.Customer c
where Identification_No='927827896')

/*Aggregate Functions*/
/*1. Return the total number of customers*/
select count(CIF) total_customers
from Bank.Customer

/*2. Return the total amount of money transferred during transactions*/
select sum(Amount) total_amount
from Bank.Transactions

/*Outer-Join Queries*/
/*Q. Find CIF, Account_No of customers who have done transactions of amount > 400000*/
select c.CIF as CIF ,a.Account_No as Account_No
from (Bank.Customer c left outer join Bank.Accounts a on c.CIF=a.CIF) join Bank.Transactions as t
on a.Account_No=t.Account_No
where Amount>3000