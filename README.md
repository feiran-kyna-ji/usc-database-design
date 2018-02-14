# USC Advancement Office Database Design Project
Author: [Kyna Ji](https://github.com/feiran-kyna-ji), Rebecca Xu, Leon Jiang, Joy Chen  
**(Full report available upon request)**

## Client Overview 
Our client is the Student Caller (SCaller) Center for the USC Advancement Office. The SCaller center recruits callers and they make phone calls to prospects who are USC alumni and current students’ parents for fund raising. Our client has a complete database for the prospects, but they need a better structured data model to track callers’ recruitment, schedule, performance, and disciplinary actions.

## Business Functions

The focus of our project is client’s internal business function, especially their HR/Personnel function. Based on user views provided, we break down the HR/Personnel function into five different sub functions: attendance, performance, coaching, disciplinary action and hiring. 

## Database Design
Following are our database design process: 
* Conceptual Design
  - Create Entity Relationship Diagrams (ERD) for each user view
  - Build a Conceptual Data Model (CDM)
  - Define Business Rules, restrictions and requirements for database
* Logical Design
  - Transform CDM to a set of Third Normal Form (3NF) relations indicating all primary and foreign keys
* Physical Design
  - Create Procrocess Versis Entity Matrix
  - Create Composite Usage Map
  - Analyze key transactions
* Implementation
  - Write DDL statements to create database in SQL language
  - Implement indexing and clustering using the outcome of Physical Design
  
## Future Potentials 

We believe the database model that we structured for our client will solve their current problems of redundancy, inconsistency, inflexibility, and maintenance difficulties. Furthermore, a high-integrity database model will be extremely helpful for our client to track, collect and analyze data along the time. This will optimize their efficiency and maximize the donation they receive. 
