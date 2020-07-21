ALTER procedure p_update_customer_details
(@ID int,
@NAME varchar(20),
@FATHERS_NAME varchar(20),
@DOB DATE,
@AGE INT,
@MARTIAL_STATUS varchar(10),
@ADDRESS VARCHAR(100),
@CITY varchar(20),
@STATE varchar(20),
@COUNTRY varchar(20),
@PINCODE INT,
@PHONE BIGINT,
@EMAIL_ID VARCHAR(50))
AS
BEGIN
	UPDATE CUSTOMER SET customer_name=@NAME,fathers_name= @FATHERS_NAME,date_of_birth=@DOB,customer_age=@AGE,
	martial_status=@MARTIAL_STATUS,customer_address=@ADDRESS,customer_city=@CITY,customer_state=@STATE,
	customer_country=@COUNTRY,pincode=@PINCODE,phone=@PHONE,email_id=@EMAIL_ID WHERE id=@ID;
	

END

select * from CUSTOMER