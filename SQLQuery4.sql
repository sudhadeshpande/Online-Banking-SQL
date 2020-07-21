
CREATE procedure p_transaction_details
(@ACCOUNT BIGINT)
AS 
BEGIN
	select * from DEBIT_TRANSACTION_DETAILS as dt  inner join CREDIT_TRANSACTION_DETAILS as ct on id=id_debit
where debit_account_no=@ACCOUNT or credit_account_no=@ACCOUNT order by id  desc ;

END

exec p_transaction_details 110010001113



