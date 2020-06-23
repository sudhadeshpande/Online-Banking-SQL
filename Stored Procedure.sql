Create procedure p_insert_transaction
(@debit_account_no bigint,
@credit_account_no bigint,
@amount int)

as
begin

/*INSERT DATA INTO TRANSACTION TABLES THAT IS CREDIT AND DEBIT TRANSACTION DETAILS*/
Declare @date_time datetime;
Set @date_time=getdate(); /*variable stores current datetime*/

Declare @balance_amount bigint;
Set @balance_amount=(select  account_balance from account  where account_no=@debit_account_no );

if @balance_amount>@amount and @debit_account_no!=@credit_account_no 
begin
/*insert into debit_transaction_details*/
insert into debit_transaction_details(debit_account_no,debit_amount,debit_date_time) 
values(@debit_account_no,@amount,@date_time)

/*id variable gets the id from debit_transaction_details
here we are arranging the rows in desc order w.r.t id and selecting top 1st id that is it gets the id of recently added row*/
declare @id int;
set @id= (select top 1 debit_id from debit_transaction_details order by debit_id desc );

/*insert into credit_transaction_details*/
insert into credit_transaction_details(credit_id,credit_account_no,credit_amount,credit_date_time) 
values(@id,@credit_account_no,@amount,@date_time)

/* update the balance amount in account table based on the transactions*/
/*in debit account update balance amount by balance-amount and in credit amount update balance amount by balance+amount*/
	
declare @var_amount int;
set @var_amount = (select top 1 debit_amount from debit_transaction_details order by debit_id desc   );

declare @var_debits_account_no bigint;
set @var_debits_account_no = (select top 1 debit_account_no from debit_transaction_details order by debit_id desc);

declare @var_credits_account_no bigint;
set @var_credits_account_no=(select top 1 credit_account_no from	credit_transaction_details order by credit_id desc);

declare @var_balance_credit bigint;
set @var_balance_credit = (select   account_balance from account   where account_no= @var_credits_account_no);

declare @var_balance_debit bigint;
set @var_balance_debit = (select   account_balance from account where account_no= @var_debits_account_no);

declare @transaction_id int ;
set @transaction_id=(select top 1 debit_id from debit_transaction_details order by debit_id desc);

if @var_amount>0
begin
update ACCOUNT set account.account_balance = @var_balance_debit- @var_amount where account_no = @var_debits_account_no;

update ACCOUNT set account.account_balance = @var_balance_credit + @var_amount where account_no = @var_credits_account_no;

update credit_transaction_details set credit_account_balance=@var_balance_credit + @var_amount
where credit_id =@transaction_id;

update debit_transaction_details set debit_account_balance=@var_balance_debit - @var_amount
where debit_id = @transaction_id;
End
End

else
	begin
	raiserror ( 'transaction failed as entered amount is greater than the available balance',1,1);
End	
End



Exec p_insert_transaction 110010001112,110010001112,996700

Exec p_insert_transaction 110010001112,110010001113,1200

select * from debit_transaction_details

drop procedure p_insert_transaction

Exec p_insert_transaction 110010001111,110010001112,1000

Exec p_insert_transaction 110010001112,110010001113,1000
                                                                          
Exec p_insert_transaction 110010001113,110010001111,5500



/************************procedure for transaction details ********************************/

Create procedure p_transaction_details
@ACCOUNT BIGINT
AS 
BEGIN

select  DEBIT_TRANSACTION_DETAILS.*, CREDIT_TRANSACTION_DETAILS.credit_account_no, CREDIT_TRANSACTION_DETAILS.credit_amount, 
CREDIT_TRANSACTION_DETAILS.credit_account_balance  from DEBIT_TRANSACTION_DETAILS, CREDIT_TRANSACTION_DETAILS 
where debit_account_no=@ACCOUNT or credit_account_no=@ACCOUNT order by credit_id desc ;
END


Exec p_transaction_details 110010001111

Exec p_transaction_details 110010001113

Exec p_transaction_details 110010001112


/*****************************************************Stored Procedure for Fixed Deposit Table***************************************/
create procedure p_fixed_deposit
@account_no bigint,
@amount int,
@duration INT,
@nominee varchar(10),
@relation_with_nominee varchar(10)
As 
Begin
	Declare @fddate date;
	Set @fddate=convert (date,getdate());

	declare @balance bigint;
	set @balance =(select account_balance from ACCOUNT where account_no=@account_no);

	Declare @rate_of_interest decimal(3,2);
	Declare @maturity_amount decimal;
	
	Declare @maturity_date Date;
	set @maturity_date=DATEADD(MM,@duration,@fddate)
	

	IF ((@BALANCE>@AMOUNT) and (@amount>=5000))
	Begin

	If (@duration <6)
	Begin
			set @Rate_of_interest=4;
			set @maturity_amount=@amount+((@amount*@Rate_of_interest*@duration)/100);

			Insert into FIXED_DEPOSIT(account_no,fd_date,fd_amount,duration,rate_of_interest,maturity_date,maturity_amount,nominee,relation_with_nominee)
			Values(@account_no,GETDATE(),@amount,@duration,@Rate_of_interest,@maturity_date,@maturity_amount,@nominee, @relation_with_nominee)
		End
		Else 
			Begin
			set @rate_of_interest =4.25;
			set @maturity_amount=@amount+((@amount*@Rate_of_interest*@duration)/100);
			Insert into FIXED_DEPOSIT (account_no,fd_date,fd_amount,duration,rate_of_interest,maturity_date,maturity_amount,nominee,relation_with_nominee)
			Values(@account_no,@fddate,@amount,@duration,@Rate_of_interest,@maturity_date,@maturity_amount,@nominee,@relation_with_nominee);
		end
UPDATE ACCOUNT SET ACCOUNT.account_balance = @balance- @AMOUNT WHERE account_no = @account_no;
UPDATE ACCOUNT SET account_balance=@balance- @amount
		WHERE account_no =@account_no;
	END	
	Else 
	Begin
		RAISERROR ('YOU NEED TO KEEP MINIMUM AMOUNT OF Rs 5000',1,1);
	END
END
Exec  p_fixed_deposit 110010001111,5000,8,'natesh','father';
exec p_fixed_deposit 110010001113,9300,5,'shandar','mother';

select * from ACCOUNT

SELECT * FROM FIXED_DEPOSIT

exec p_fixed_deposit 110010001112,6400,5,'shandar', 'mother';

exec p_fixed_deposit 110010001113,5700,12,'mother', 'brother';

exec p_fixed_deposit 110010001113,5000,3,'father', 'sister';



