create database library;
use library;
-- creating tables
-- publisher data
create table publisher(ID int primary key auto_increment,
publisher_name varchar(255),publisher_address varchar(255),publisher_phone varchar(50),Isavailable BIT);
desc publisher;
select * from publisher;
-- borrower data
create table borrower(card_no int primary key auto_increment,borrower_name varchar(255),borrower_address varchar(255),borrowe_phone varchar(50));
desc borrower;
select * from borrower;
-- book data
create table book(book_id int auto_increment primary key,book_title varchar(255),book_publisher_name varchar(255),foreign key(book_publisher_name) references publisher(publisher_name) on delete cascade);
desc book;
select * from book;
-- book_authors data
create table book_authors(book_author_authorID int primary key auto_increment,book_author_bookID int,book_author_authorName varchar(255),foreign key(book_author_bookID)
references book(book_id) on delete cascade);
desc book_authors;
select * from book_authors;
-- library_branch data
create table library_branch(library_branch_branchID int primary key auto_increment,library_branch_branchName varchar(255),library_branch_branch_address varchar(255));
desc library_branch;
select * from library_branch;
-- books copies data
create table book_copies(book_copies_bookID int,book_copies_branchID int,book_copies_noOfcopies int,foreign key(book_copies_branchID)
references library_branch(library_branch_branchID) on delete cascade);
desc book_copies;
select * from book_copies;
-- book_loans data
create table book_loans(book_loans_loansID int primary key auto_increment,book_loans_bookID INT,book_loans_branchID int,book_loans_cardNo int,
book_loans_dateOut varchar(255),book_loans_dueDate varchar(255),foreign key(book_loans_bookID) references book(book_id) on delete cascade,
foreign key (book_loans_branchID) references library_branch(library_branch_branchID) on delete cascade,foreign key(book_loans_cardNo)
references borrower(card_no) on delete cascade);
DESC book_loans;
select * from book_loans;

-- created tables
select * from book;
select * from book_authors;
select * from book_copies;
select * from borrower;
select * from library_branch;
select * from publisher;

-- questions related to tables
-- 1.how many copies of the book titled 'The lost tribe' are owned by the library branch whose name is 'sharptown'?

select * from library_branch;
select * from book_copies;
select * from book;

select b.book_id,b.book_title,bc.book_copies_branchID,
lb.library_branch_branchName,bc.book_copies_noOfcopies as total_copies from book as b join book_copies as bc on b.book_id=bc.book_copies_bookid
join library_branch as lb on lb.library_branch_branchID=bc.book_copies_branchID
where b.book_title='The Lost Tribe' and lb.library_branch_branchName='Sharpstown';

-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select * from library_branch;
select * from book_copies;
select * from book;

select b.book_id, b.book_title, bc.book_copies_branchId, lb.library_branch_branchName, bc.book_copies_noOfCopies as total_copies
from book as b
join book_copies as bc
on b.book_id = bc.book_copies_bookId
join library_branch as lb
on lb.library_branch_branchId = bc.book_copies_branchId
where b.book_title = 'The Lost Tribe';

-- 3. Retrieve the names of all borrowers who do not have any books checked out.

select * from borrower;
select * from book_loans;

select b.card_no, b.borrower_name, bl.book_loans_dateOut
from borrower as b
left join book_loans as bl 
on b.card_no = bl.book_loans_cardNo
where bl.book_loans_cardNo IS NULL;

-- 4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.

select * from book;
select * from borrower;
select * from library_branch;
select * from book_loans;

select b.book_title, bw.borrower_name, bw.borrower_address, lb.library_branch_branchName, bl.book_loans_loansId, bl.book_loans_dueDate
from book as b 
join book_loans as bl
on b.book_id = bl.book_loans_bookId
join borrower as bw
on bw.card_no = bl.book_loans_cardNo
join library_branch as lb
on lb.library_branch_branchId = bl.book_loans_branchId
where lb.library_branch_branchName = 'Sharpstown'
and date(bl.book_loans_dueDate) = 2018-03-02;

-- 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select * from library_branch;
select* from book_loans;

select lb.library_branch_branchName, count(bl.book_loans_bookId) as total_books
from library_branch as lb
left join book_loans as bl
on lb.library_branch_branchId = bl.book_loans_branchId
group by lb.library_branch_branchName;

-- 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

select * from borrower;
select * from book_loans;

select b.borrower_name, b.borrower_address, count(bl.book_loans_bookId) as total_books
from borrower as b
join book_loans as bl
on b.card_no = bl.book_loans_cardNo
group by b.borrower_name, b.borrower_address
having total_books > 5
order by total_books asc;

-- 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

select * from book_loans;
select * from book;
select * from book_authors;
select * from library_branch;

select ba.book_author_authorName, b.book_title, lb.library_branch_branchName, count(book_loans_bookId) as owned
from library_branch as lb
join book_loans as bl
on lb.library_branch_branchId = bl.book_loans_branchId
join book_authors as ba
on ba.book_author_bookId = bl.book_loans_bookId
join book as b
on b.book_id = bl.book_loans_bookId
where ba.book_author_authorName = 'Stephen King'
and lb.library_branch_branchNAme = 'Central'
group by ba.book_author_authorName, b.book_title, lb.library_branch_branchName;













