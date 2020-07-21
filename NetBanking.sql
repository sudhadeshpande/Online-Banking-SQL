create database NetBanking
use NetBanking

drop database NetBanking

/*-------------ACCOUNT_TYPE TABLE----------------------------*/
    create table ACCOUNT_TYPE(
	id int primary key identity(1020,2),
	account_type_name varchar(20) NOT NULL
	);
	insert into ACCOUNT_TYPE
	values ('Savings'),('Salary'),('Rural'),('Fixed')

	select * from ACCOUNT_TYPE

	/*------------BRANCH TABLE-----------------------------*/

create table BRANCH(
	id varchar(20) primary key,
	branch_name varchar(20) NOT NULL
	);
	insert into BRANCH
	values ('BRANCHID01','BAGALURU CROSS'),('BRANCHID02','DEVANAHALLI'),('BRANCHID03','HEBBALA'),('BRANCHID04','KOGILU CROSS'),
	('BRANCHID05','MALLESHWARAM'),('BRANCHID06','MAJESTIC'),('BRANCHID07','HUNASEMARANAHALLI')

	SELECT * FROM BRANCH

	/*-----------CUSTOMER TABLE------------------------------*/

DROP TABLE CUSTOMER
	
create table CUSTOMER(
	id int primary key identity(1010,1),
	customer_first_name varchar(50) NOT NULL,
	customer_last_name varchar(50) NOT NULL,
	customer_gender varchar(10) NOT NULL,
	customer_father_name varchar(50) NOT NULL,
	date_of_birth DateTime NOT NULL,
	customer_age int NOT NULL,
	marital_status varchar(10),
	customer_address varchar(100) NOT NULL,
	customer_city varchar(50) NOT NULL,
	customer_state varchar(50) NOT NULL,
	customer_country varchar(50) NOT NULL,
	pincode int NOT NULL,
	phone bigint NOT NULL,
	email_id varchar(50),
	customer_password varchar(20) 
);

select * from CUSTOMER

INSERT INTO CUSTOMER 
VALUES ('Mohammad','Shandar','MALE','FATHER','19970625',23,'unmarried','bc road','mangalore'
,'karnataka','India',575056,8050855690,'shandar246@gmail.com','123456'),

('Natesh','m','MALE','fffgfg','19970223',23,'unmarried','trtrtr','trtrt'
,'trtrt','India',575056,8050855610,'natesh246@gmail.com','123456'),

('Sudha','Deshpande','FEMALE','fddgd','19970221',23,'unmarried','ggrgr','ererer'
,'adad','India',575056,8050855620,'sudha246@gmail.com','123456')

select * from CUSTOMER

update CUSTOMER
SET phone=9945391228 where id=1012
/*--------------ACCOUNT TABLE---------------------------*/

create table ACCOUNT(
	account_no bigint primary key identity(110010001111,1),
	debit_card_no bigint NOT NULL,
	branch_id varchar(20) NOT NULL,
	foreign key (branch_id) references BRANCH (id),
	account_type_id int NOT NULL ,
	foreign key (account_type_id) references ACCOUNT_TYPE (id),
	customer_id int
	foreign key (customer_id) references CUSTOMER (id),
	balance bigint NOT NULL,
	check_book_id varchar(10)
);

	select * from ACCOUNT_TYPE

	select * from ACCOUNT

	INSERT INTO ACCOUNT 
	VALUES (1234567891011,'BRANCHID01',1020,1010,100000,'CHECK01')

	INSERT INTO ACCOUNT 
	VALUES(1234567891012,'BRANCHID02',1020,1011,150000,'CHECK02')

	INSERT INTO ACCOUNT 
	VALUES(1234567891013,'BRANCHID03',1020,1012,1000200,'CHECK03')

	/*---------------TRANSACTION_DETAILS TABLE--------------------------*/

        CREATE TABLE TRANSACTION_DETAILS(
		transaction_id int primary key identity(1050,1),
		debit_account_no bigint not null ,
		foreign key (debit_account_no) references ACCOUNT (account_no),
		credit_account_no bigint not null ,
		foreign key (credit_account_no) references ACCOUNT (account_no),
		amount int,
		transaction_date_time datetime not null,
	   );
	select * from TRANSACTION_DETAILS

	alter table TRANSACTION_DETAILS
	ADD debit_account_balance bigint 

	alter table TRANSACTION_DETAILS
	ADD credit_account_balance bigint 

	select * from TRANSACTION_DETAILS

/*--------------FIXED DEPOSIT TABLE---------------------------*/

create table FIXED_DEPOSIT(
	deposit_id int primary key identity(100,1),
	account_no bigint,
	foreign key (account_no) references ACCOUNT (account_no),
	fd_date date,
	fd_amount int,
	duration int,
	rate_of_interest  decimal,
	maturity_date date ,
	maturity_amount int,
	nominee varchar(50),
	nominee_relation varchar(50)
);

alter table FIXED_DEPOSIT
alter column maturity_date varchar(20)

alter table FIXED_DEPOSIT
alter column rate_of_interest decimal(2,1)
/*-----------------------------------------*/

SELECT * FROM BRANCH
SELECT * FROM ACCOUNT
SELECT * FROM ACCOUNT_TYPE
SELECT * FROM CUSTOMER
select * from FIXED_DEPOSIT


/*-------------TRANSACTION STORED PROCEDURE----------------------------*/


Create procedure p_insert_transaction
(
@DEBIT_ACCOUNT_NO BIGINT,
@CREDIT_ACCOUNT_NO BIGINT,
@AMOUNT INT)
AS
BEGIN
/*INSERT DATA INTO TRANSACTION TABLES THAT IS CREDIT AND DEBIT TRANSACTION DETAILS*/

	DECLARE @DATE_TIME DATETIME;
	SET @DATE_TIME=GETDATE(); /*VARIABLE STORES CURRENT DATETIME*/

	DECLARE @BALANCE_AMOUNT BIGINT;
	SET @BALANCE_AMOUNT=(SELECT  balance from ACCOUNT  WHERE account_no=@DEBIT_ACCOUNT_NO );

	IF @BALANCE_AMOUNT>@AMOUNT and @DEBIT_ACCOUNT_NO!=@CREDIT_ACCOUNT_NO 
	BEGIN
	/*INSERT INTO DEBIT_TRANSACTION_DETAILS*/
	INSERT INTO TRANSACTION_DETAILS(debit_account_no,credit_account_no,amount,transaction_date_time) 
	VALUES(@DEBIT_ACCOUNT_NO,@CREDIT_ACCOUNT_NO,@AMOUNT,@DATE_TIME)

	/*ID VARIABLE GETS THE id from DEBIT_TRANSACTION_DETAILS
	HERE WE ARE ARRANGING THE ROWS IN DESC ORDER w.r.t id and SELECTING TOP 1st id that is it gets the id of recently added row*/
	DECLARE @ID INT;
	SET @ID= (SELECT TOP 1 transaction_id FROM TRANSACTION_DETAILS ORDER BY transaction_id DESC );

	/* update the balance amount in ACCOUNT table based on the transactions*/
		/*In debit account update balance amount by balance-amount
	and in credit amount update balance amount by balance+amount*/
	
	DECLARE @VAR_AMOUNT INT;
	SET @VAR_AMOUNT = (SELECT TOP 1 amount from TRANSACTION_DETAILS ORDER BY transaction_id DESC   );

	DECLARE @VAR_DEBITS_ACCOUNT_NO BIGINT;
	SET @VAR_DEBITS_ACCOUNT_NO = (SELECT TOP 1 debit_account_no from TRANSACTION_DETAILS ORDER BY transaction_id DESC);

	DECLARE @VAR_CREDITS_ACCOUNT_NO BIGINT;
	SET @VAR_CREDITS_ACCOUNT_NO=(SELECT TOP 1 credit_account_no from	TRANSACTION_DETAILS ORDER BY transaction_id DESC);

	DECLARE @VAR_BALANCE_CREDIT BIGINT;
	SET @VAR_BALANCE_CREDIT = (SELECT   balance from ACCOUNT   WHERE account_no= @VAR_CREDITS_ACCOUNT_NO);

	DECLARE @VAR_BALANCE_DEBIT BIGINT;
	SET @VAR_BALANCE_DEBIT = (SELECT   balance from ACCOUNT WHERE account_no= @VAR_DEBITS_ACCOUNT_NO);

	DECLARE @TRANSACTION_ID INT ;
	SET @TRANSACTION_ID=(SELECT TOP 1 transaction_id FROM TRANSACTION_DETAILS ORDER BY transaction_id DESC);

	IF @VAR_AMOUNT>0
	BEGIN
		UPDATE ACCOUNT SET ACCOUNT.balance = @VAR_BALANCE_DEBIT- @VAR_AMOUNT WHERE account_no = @VAR_DEBITS_ACCOUNT_NO;

		UPDATE ACCOUNT SET ACCOUNT.balance = @VAR_BALANCE_CREDIT + @VAR_AMOUNT WHERE account_no = @VAR_CREDITS_ACCOUNT_NO;

		UPDATE TRANSACTION_DETAILS SET credit_account_balance=@VAR_BALANCE_CREDIT + @VAR_AMOUNT
		WHERE transaction_id = @TRANSACTION_ID;

		UPDATE TRANSACTION_DETAILS SET debit_account_balance=@VAR_BALANCE_DEBIT - @VAR_AMOUNT
		WHERE transaction_id = @TRANSACTION_ID;	
	END
	END
	ELSE
		BEGIN
		RAISERROR ( 'TRANSACTION FAILED AS ENTERED AMOUNT IS GREATER THAN THE AVAILABLE BALANCE',15,1);
	END	
END

/*---------------------------------------------------*/

select * from TRANSACTION_DETAILS

SELECT * FROM ACCOUNT
select * from CUSTOMER
select * from ACCOUNT_TYPE
select * from BRANCH

SELECT * FROM TRANSACTION_DETAILS


EXEC p_insert_transaction 110010001112,110010001113,700

EXEC p_insert_transaction 110010001113,110010001114,120


/*------------------CUSTOMER STORED PROCEDURE-----------------------------------*/

Create procedure p_update_customer_details
(@ID int,
@FIRST_NAME varchar(50),
@LAST_NAME varchar(50),
@FATHERS_NAME varchar(50),
@DOB DATE,
@GENDER VARCHAR(20),
@MARITAL_STATUS varchar(10),
@ADDRESS VARCHAR(100),
@CITY varchar(50),
@STATE varchar(50),
@COUNTRY varchar(50),
@PINCODE INT,
@PHONE BIGINT,
@EMAIL_ID VARCHAR(50),
@PASSWORD VARCHAR(50))
AS
BEGIN

declare @AGE int
set @AGE= datediff(YY, @DOB, getdate())

	UPDATE CUSTOMER SET customer_first_name=@FIRST_NAME, customer_last_name=@LAST_NAME,customer_father_name= @FATHERS_NAME,date_of_birth=@DOB,
	customer_age=@AGE,  customer_gender=@GENDER,marital_status=@MARITAL_STATUS,customer_address=@ADDRESS,customer_city=@CITY,
	customer_state=@STATE,customer_country=@COUNTRY,pincode=@PINCODE,phone=@PHONE,email_id=@EMAIL_ID,customer_password=@PASSWORD WHERE id=@ID;
END

select * from CUSTOMER


/*--------------STATEMENT STORED PROCEDURE*/
CREATE procedure p_transaction_details
(@ACCOUNT BIGINT)
AS 
BEGIN
	
	select * from TRANSACTION_DETAILS 
where debit_account_no=@ACCOUNT or credit_account_no=@ACCOUNT order by transaction_id  desc ;

END

exec p_transaction_details 110010001113

/*--------------FD STORED PROCEDURE---------------*/
create procedure fixed_deposit_sp
 @account_no bigint,
@amount int,
@duration INT,
@Rate_of_interest decimal(2,1),
@maturity_amount int,
@maturity_date varchar(20),
@nominee varchar(50),
@relation varchar(50)
As 
Begin

	Declare @fddate date;
	Set @fddate=convert (date,getdate());

	declare @balance bigint;
	set @balance =(select balance from ACCOUNT where account_no=@account_no);

	IF ((@balance>@amount) )
	Begin
			Insert into FIXED_DEPOSIT(account_no,fd_date,fd_amount,duration,rate_of_interest,maturity_date,maturity_amount,nominee,nominee_relation)
			Values(@account_no,GETDATE(),@amount,@duration,@Rate_of_interest,CONVERT(varchar, @maturity_date, 23),@maturity_amount,@nominee,@relation)
	
		UPDATE ACCOUNT SET balance=@balance- @amount
		WHERE account_no =@account_no;
	END	
	Else 
	Begin
			RAISERROR ('YOU NEED TO KEEP MINIMUM AMOUNT OF Rs 5000',15,1);
	END
END

select * from FIXED_DEPOSIT



select * from CUSTOMER
/*********************************** ADMINLOGIN **************************************/
Create Table ADMINLOGIN(
admin_id int primary key identity(1000,1),
admin_first_name varchar(30),
admin_last_name varchar(30),
admin_email_id varchar(50),
admin_password varchar(50)
);

select * from ADMINLOGIN

Insert into ADMINLOGIN
Values('Swastik', 'Deshpande','swasti@gmail.com', '987654' );


/************************stored procedure for Insert new Customer********************************/


CREATE PROCEDURE p_insert_customer
(
@customer_first_name varchar(50),
@customer_last_name varchar(50),
@customer_father_name varchar(50),
@customer_gender varchar(20),
@date_of_birth DATE,
@marital_status varchar(10),
@customer_address VARCHAR(100),
@city varchar(50),
@customer_state varchar(50),
@country varchar(50),
@pincode INT,
@phone BIGINT,
@email_id VARCHAR(50),
@password varchar(50))
AS
BEGIN

declare @age int
set @age= datediff(YY, @date_of_birth, getdate())

INSERT INTO CUSTOMER(customer_first_name,customer_last_name ,customer_father_name ,customer_gender ,date_of_birth,customer_age, marital_status, 
customer_address,customer_city,customer_state ,customer_country, pincode ,phone,email_id, customer_password ) 
VALUES (@customer_first_name,@customer_last_name ,@customer_father_name ,@customer_gender ,@date_of_birth,@age,
@marital_status ,@customer_address,@city,@customer_state ,@country ,@pincode ,@phone,@email_id, @password ) 
END


exec p_insert_customer 'sarita', 'D', 'Ram', 'Female', '1997/01/15 ','married', 'gandhi circle', 'mudhol', 
'karnataka', 'India', 578741, 9620376330,'sarita@gmail.com', 'sarita123';

select * from CUSTOMER


/**************************PROCEDURE TO DELETE CUSTOMER******************************/
create procedure p_delete_customer
@id int
As
Begin
 delete from CUSTOMER
 where id=@id
 END

 EXEC p_delete_customer 1016


