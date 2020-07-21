
/*********************************** ADMINLOGIN **************************************/
Create Table ADMINLOGIN(
admin_id int primary key identity(1,1),
admin_first_name varchar(30),
admin_last_name varchar(30),
admin_email_id varchar(50),
admin_password varchar(50)
);

Insert into ADMINLOGIN
Values('Swastik', 'Deshpande','swasti@gmail.com', '987654' );

select * from ADMINLOGIN
select * from CUSTOMER
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

 /*************************************************************************************/