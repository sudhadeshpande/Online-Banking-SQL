Create Database OnlineBanking;

Use OnlineBanking;

/*************************ACCOUNT_TYPE**************************/
Create Table ACCOUNT_TYPE(
account_type_id int primary key identity(1020,2),
account_type_name varchar(20) not null
);	

Insert into ACCOUNT_TYPE
Values ('Savings'),('Salary'),('Rural'),('Fixed')

Select * from ACCOUNT_TYPE

/**************************BRANCH*******************************/
Create Table BRANCH(
branch_id varchar(20) primary key,
branch_name varchar(20) not null
);

Insert into BRANCH
Values ('BRANCHID01','BAGALURU CROSS'),('BRANCHID02','DEVANAHALLI'),('BRANCHID03','HEBBALA'),('BRANCHID04','KOGILU CROSS'),
('BRANCHID05','MALLESHWARAM'),('BRANCHID06','MAJESTIC'),('BRANCHID07','HUNASEMARANAHALLI')

Select * from BRANCH

/****************************CUSTOMER*********************************/
create table CUSTOMER(
customer_id int primary key identity(1010,1),
customer_first_name varchar(30) not null,
customer_last__name varchar(30) not null,
customer_birth_date DateTime not null,
customer_age int not null,
customer_gender varchar(20),
marital_status varchar(20),
customer_address varchar(100) not null,
customer_city varchar(30) not null,
customer_state varchar(30) not null,
customer_country varchar(30) not null,
customer_pincode int not null,
customer_phone bigint not null,
customer_email_id varchar(50),
customer_password varchar(30),
check(customer_gender in ('Male', 'Female', 'Unknown')),
check(marital_status in ('Married', 'Unmarried'))
);
select * from CUSTOMER
Insert into CUSTOMER 
Values ('Shandar','md','19970625',23,'Male','unmarried','bc road','mangalore','karnataka','India',575056,8050855690,'shandar246@gmail.com','123456')

Insert into CUSTOMER 
Values('Sudha', 'Deshpande','19971007',22,'Female','unmarried','rc road','Mudhol','Karnataka','India',587313,9934101010,'sudha7@gmail.com','sudha123' )

Insert into CUSTOMER 
Values ('Natesh', 'N', '19971008',23,'Male', 'Married', 'mg road', 'Bangolore','Karnataka','India',560003,2043015100,'Natesh@gmail.com','n123' )

Select * from CUSTOMER

/*********************************ACCOUNT****************************/
Create Table ACCOUNT(
account_no bigint primary key identity(110010001111,1),
debit_card_no bigint not null,
branch_id varchar(20) not null,
foreign key (branch_id) references BRANCH (branch_id),
account_type_id int not null ,
foreign key (account_type_id) references ACCOUNT_TYPE (account_type_id),
customer_id int,
foreign key (customer_id) references CUSTOMER (customer_id),
account_balance bigint not null,
check_book_id varchar(10)
);

Insert into ACCOUNT 
Values (1234567891011,'BRANCHID01',1020,1010,100000,'CHECK01');

Insert into ACCOUNT 
Values (1234567891012,'BRANCHID02',1020,1011,150000,'CHECK02');

Insert into ACCOUNT 
Values (1234567891013,'BRANCHID03',1020,1012,1000200,'CHECK03');

Select * from ACCOUNT

/**************************** DEBIT TRANSACTION ****************************/
Create Table DEBIT_TRANSACTION_DETAILS(
debit_id int primary key identity(1050,1),
debit_account_no bigint not null ,
foreign key (debit_account_no) references ACCOUNT (account_no),
debit_amount int,
debit_date_time datetime not null,
debit_account_balance bigint
);

Select * from DEBIT_TRANSACTION_DETAILS

/*************************** CREDIT TRANSACTION*****************************/
Create Table CREDIT_TRANSACTION_DETAILS(
credit_id int ,
foreign key (credit_id) references DEBIT_TRANSACTION_DETAILS (debit_id),
credit_account_no bigint not null ,
foreign key (credit_account_no) references ACCOUNT (account_no),
credit_amount int,
credit_date_time datetime not null,
credit_account_balance bigint
);

Select * from CREDIT_TRANSACTION_DETAILS

drop table CREDIT_TRANSACTION_DETAILS

/*********************************FIXED DEPOSIT*********************************/
Create Table FIXED_DEPOSIT(
deposit_id int primary key identity(100,1),
account_no bigint,
foreign key (account_no) references ACCOUNT (account_no),
fd_date date,
fd_amount int,
duration int,
rate_of_interest float,
maturity_date date ,
maturity_amount int,
nominee varchar(50),
relation_with_nominee varchar(50)
);

drop table fixed_deposit
Select * From FIXED_DEPOSIT

