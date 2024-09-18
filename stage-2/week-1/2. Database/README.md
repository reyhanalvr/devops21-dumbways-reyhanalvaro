`Tasks :`

- Deploy database MySQL
  - Setup secure_installation
  - Add password for root user
  - Create new user for MySQL
  - Create new database
  - Create privileges for your new user so they can access the database you created
  - Dont forget to change the MySQL bind address on /etc/mysql/mysql.conf.d/mysqld.cnf
- Role Based
  - Create new database call demo and make some dummy table call transaction
  - Create a 2 role with the name admin, and guest that will be used to see and manage the 'transaction' table.
  - Give SELECT, INSERT, UPDATE, and DELETE access rights to the employees table for the admin role you just created. and only give SELECT access to guest.
  - Create a new user with the username your_name and password your_password. Add the user to the admin role.
  - Create a new user with the username guest and password guest. Add the user to the guest role.
  - Test all of your user
- Remote User
  - Try to remote your database from your local computer with mysql-client

---
--- 

# 1. Deploy Database MySQL


## Setup Secure Installation

![image](https://github.com/user-attachments/assets/41111781-266e-4d8d-bcf3-8197cee0305e)

## Add Password For Root User

![image](https://github.com/user-attachments/assets/7351ddbd-8def-41cb-a843-689956a1e05d)

## Create New User for MySQL

![image](https://github.com/user-attachments/assets/bcebabe7-6f94-438f-ab91-28cfb9980c35)

## Create New Database

![image](https://github.com/user-attachments/assets/209b3c2a-c77c-4ca8-ad07-e71cd3187265)

## Create privileges for your new user so they can access the database you created

![image](https://github.com/user-attachments/assets/fe9e83ea-5192-4328-b332-ed2298551003)

![image](https://github.com/user-attachments/assets/aa51e5f2-0af9-44f1-a70d-c1194788e5e9)

## Dont forget to change the MySQL bind address on /etc/mysql/mysql.conf.d/mysqld.cnf

![image](https://github.com/user-attachments/assets/88bd87ce-c4d7-45f2-9e92-892d9aeb776e)

![image](https://github.com/user-attachments/assets/7d383a62-6a69-4b95-aa98-ebd3d4efe4bc)


# 2. Role Based

## Create new database call demo and make some dummy table call transaction

![image](https://github.com/user-attachments/assets/b7736fba-f7ba-4a4c-a32a-66bb43486f97)

## Create a 2 role with the name admin, and guest that will be used to see and manage the 'transaction' table.

![image](https://github.com/user-attachments/assets/bbcfc19c-8727-47b9-936d-5c894df68402)


## Give SELECT, INSERT, UPDATE, and DELETE access rights to the employees table for the admin role you just created. and only give SELECT access to guest.

![image](https://github.com/user-attachments/assets/c341b161-7431-4c59-8f06-bc2e5761cefe)

## Create a new user with the username your_name and password your_password. Add the user to the admin role.

![image](https://github.com/user-attachments/assets/fdce744d-d4b3-471e-bdbc-5dae6708aa58)

![image](https://github.com/user-attachments/assets/e3a38f4f-b62c-4d08-9e2c-170385876240)


## Create a new user with the username guest and password guest. Add the user to the guest role.

![image](https://github.com/user-attachments/assets/fdfaf923-f8cd-4cdc-a0b7-513adf0e46ad)

![image](https://github.com/user-attachments/assets/79faa33f-91d3-4f54-a1eb-3c86554dd23a)

## Test all of your user
