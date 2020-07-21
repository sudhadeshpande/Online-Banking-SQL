alter procedure fixed_deposit_sp
 @account_no bigint,
@amount int,
@duration INT,
@nominee varchar(10)

As 
Begin

	Declare @fddate date;
	Set @fddate=convert (date,getdate());

	declare @balance bigint;
	set @balance =(select balance from ACCOUNT where account_no=@account_no);

	Declare @rate_of_interest decimal;
	Declare @maturity_amount decimal;
	Declare @maturity_date Date;
	set @maturity_date=DATEADD(MM,4,@fddate)

	IF ((@BALANCE>@AMOUNT) and (@amount>=5000))
	Begin

		If (@duration <6)
		Begin
			set @Rate_of_interest=4;
			set @maturity_amount=@amount+((@amount*@Rate_of_interest*@duration)/100);

			Insert into FIXED_DEPOSIT(account_no,fd_date,fd_amount,duration,rate_of_interest,maturity_date,maturity_amount,nominee)
			Values(@account_no,GETDATE(),@amount,@duration,@Rate_of_interest,@maturity_date,@maturity_amount,@nominee)
		End

		Else 
			Begin
			set @rate_of_interest =4.25;
			set @maturity_amount=@amount+((@amount*@Rate_of_interest*@duration)/100);
			Insert into FIXED_DEPOSIT (account_no,fd_date,fd_amount,duration,rate_of_interest,maturity_date,maturity_amount,nominee)
			Values(@account_no,@fddate,@amount,@duration,@Rate_of_interest,@maturity_date,@maturity_amount,@nominee);
		end
		UPDATE ACCOUNT SET ACCOUNT.balance = @balance- @AMOUNT WHERE account_no = @account_no;

		UPDATE ACCOUNT SET balance=@balance- @amount
		WHERE account_no =@account_no;
	END	
	Else 
	Begin
		RAISERROR ('YOU NEED TO KEEP MINIMUM AMOUNT OF Rs 5000',1,1);
	END
END


drop procedure fixed_deposit_sp

Exec  fixed_deposit_sp 110010001111,5000,8,'natesh';
exec fixed_deposit_sp 110010001113,5000,5,'shandar';



	select * from ACCOUNT
	select * from CUSTOMER
	SELECT * FROM FIXED_DEPOSIT

	DELETE FROM FIXED_DEPOSIT 

	SELECT * FROM BRANCH
	SELECT * FROM ACCOUNT_TYPE