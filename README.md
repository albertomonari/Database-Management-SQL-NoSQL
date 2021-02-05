## PART I: SQL PROJECT

### Project description:

BAKERS is a software development company that has been existing since the 1980s. With the current evolution in AI and business analytic, they are far behind the competition in terms of **productivity**. The CEO believes the issue comes from his employees so he decides to hire a new human resource **(HR) manager**.
The new HR manager is who just arrived seeks to understand the employee structure of the company to determine if the employees could be the reason why the company is not very competitive in today's software business industry and how to solve this issue if it is the case. To this end, the HR manager learns that there is a database that contains **all information on the employees in the company** and also learns that there is a business analysis team in the company that provides analytic support to other departments. HR decides to reach out to have their informed opinion on the current situation of employees in the company and what could be done to improve the situation.

### Exercise
You are the **team of business analysts** working for BAKERS. Based on the HR's request, you are expected to make at least **15 recommendations** on how to improve the **state** and **conditions** of employees in the company to make it **more competitive** in its industry. Be creative - your advice can be anything meaningful for the HR (e.g. hire new staff, increase salaries for a given group of employees, fire some employees, etc.). All your justifications **MUST be based on evidence from the database**. Each suggestion should be presented in four subsections:

+ Query  
+ Result  
+ Analysis/interpretation 
+ Recommendations


HR has also provided a **list of requests** that must be completed. You are expected to provide a minimum of **10 recommendations** based on the requests of the HR, and a minimum of **five recommendations based on queries** you conceived as an expert. One query can lead to more than one recommendation.

Follow the instructions carefully. Do not provide irrelevant columns. All your column titles should bare meaningful and well-formatted headings. For example, do not provide employee ID if it is not necessary/required to understand your suggestion. However, your tables should have rich content for the manager. For example, if the list of employees with the lowest salary is requested, it will be better if you provide the name of the employee, the salary earned, and add the department and/or job title or years of experience to help develop interesting insights and arguments.



List of queries that must be completed for the HR.
The HR manager will like you to please provide the following information (remember: the queries and the results (provide first 10 rows if the result is a table)):



1. List of employees with the following information: First name, last name, gender, age, number of years spent in the company, department, the year they joined the department, and their current job title.
2. The number of employees per department.
3. List of employees per department, their positions, and salaries. Make a separate list for each department.
4. List of the average salary of employees in each job position (title).
5. List of the average age of employees in (i) the company, (ii) each department, (iii) each job position.
6. What is the ratio of me to women in (i) each department; (ii) each job position (title).
7. List of employees with (i) the lowest salary, (ii) the highest salary (iii) above average salary. Please do not forget to mention the lowest and highest salary amount. The currency is Euro.
8. List of employees who joined the company in December.
9. List of the most experienced employees (by the number of years) in each department and the company as a whole.
10. List of the most recently hired employees (that is, the year the most recent employee was recruited).


To meet your objectives, the database administrator has provided you with a MySQL database for employees. Figure 1 presents the database schema. You are expected to query the database provided to obtain the information necessary for you to advise the new HR. To setup the database, it suffices to import the "employees.sql" file in the employees zipped folder provided. DO NOT DELETE ANY FILE IN THE FOLDER PROVIDED! Make sure to use MySQL workbench or MySQL shell to avoid incompatibilities.


### Hypothesis used for the analysis
The department's analytic team would like to specify the main hypothesis after receiving this database. 
All the analyses are carried out at the **date 2020**. We therefore place ourselves in the situation where the database we received from HR is __up to date for this year__. 

***

## PART II: NOSQL PROJECT

### Project description:

The mayor of New York will like to reduce pollution in the city by increasing accessibility using public bicycles. You are provided with a **"trips" collection** in the **"citybike" database** found in your MongoDB server. It contains bike trips data from the New York City Citibike service. The documents are composed of: **Bicycle unique identifier**, **Trip start and stop time and date**, **Trip start** and **end stations names** and **geospatial location**, **User information** such as gender, year of birth, and service type (Customer or Subscriber).

### Exercise
A. Write MongoDB queries that will do the following:  
1. Display all documents in the "trips" collection.  
2. Display all documents in the collection except the "tripduration" and "usertype.  
3. Display the "start station name" and "end station name" of all documents in the collection.  
4. Display all the trips to "South St & Whitehall St".  
5. Display the first 5 trips made by "Subscriber" (usertype).  
6. Display the time of the day with the highest number of trips. 
7. Display trips made to end station locations with latitude values greater than 40.735238.    
8. Propose 3 queries that could help understand the behavior of city bikers.  
B. Propose 7 additional queries that would help the mayor understand the movement of New York city bikers.    
C. Based on all the queries above, make suggestions on how New York city biking can be improved. Results should be presented as follows:  
a. Query:  
b. Result:  
c. Analysis/interpretation:  
d. Recommendations:  
