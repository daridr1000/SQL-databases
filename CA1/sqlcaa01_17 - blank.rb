#
# This file forms part of a formal assessment for the course.
# It is advised that copies be made of this  and the database file in the event that they might become corrupted.
# The compressed ZIP file containing this file along with its associated database (wiki05.db) should be extracted within a new folder on your University H: drive.
# Details about your University H: drive are avialable via the IT Services web pages.
# Instructions to run this file assume students are using the University's VDI resource. 
# Students must not change the contents of the database file. However, the database can be reviewed using free open source tools such as DB Browser installed on your own device.
# It is students responsibility to install and configure software systems where they choose to consider other methods of running the file.
# Warning, student marks will only be based on results produced when running submissions on the University's VDI resource.
# The command 'ruby sqlcaa01_xx.rb' (where xx is the version number) should be used to run the SQL statements and check whether they produce the correct results.
# This can be performed as many times as one likes before submitting.
# Once submitted to Myaberdeen this will count for an attempt.
# Note. All SQL statements inserted into this file must not include double quotation characters ( " " ). Instead only single qutation ( '  ' ) marks must be used where required.
#
# sqlcaa 2020-21 (Copyright 2020)

require 'rubygems'
require 'sqlite3'
# the database is based on a blog where users log in and post questions and/or answers to questions.
# the database also stores ratings associated with post questions alongside replies.
DbName = 'wiki05.db'
SQLQ = []
SQLA = []
correct = 0
# display all data for all users
SQLQ[0] = "SELECT * 
		   FROM Users"
SQLA[0] ='[["id", "username", "password", "edit", "created_at", "updated_at", "supervisor", "firstname", "surname"], [1, "Admin", "admin", "t", "2018-08-16 10:19:11.775108", "2018-08-16 10:19:11.775108", nil, "Alison", "Tonge"], [2, "nab", "nab", "f", "2018-08-16 11:00:41.576864", "2018-08-16 11:32:04.108250", 1, "Nigel", "Beacham"], [3, "fred", "fred", "f", "2018-08-16 11:00:41.576864", "2018-08-16 11:00:41.576864", 2, "Fred", "Bloggs"]]'
# display  id and username data for all users  
SQLQ[1] = "SELECT id, username 
		   FROM Users"
SQLA[1] ='[["id", "username"], [1, "Admin"], [2, "nab"], [3, "fred"]]'
# display  id and username data for all users and rename colmns id ID and username UN 
SQLQ[2] = "SELECT id AS ID, username AS UN 
		   FROM Users "
SQLA[2] ='[["ID", "UN"], [1, "Admin"], [2, "nab"], [3, "fred"]]'
# display  id and username data for user with id = 2
SQLQ[3] = "SELECT id, username 
		   FROM Users 
		   WHERE id=2"
SQLA[3] ='[["id", "username"], [2, "nab"]]'
# display id, username, pid, pmessage data for posts made by the user with the id =2 using an inner join
SQLQ[4] = "SELECT U.id, U.username, P.pid, P.pmessage -- i have used aliases here in order to distinguish between the elements of table Users whose alias is U and the ones from table Posts whose alias is P 
		   FROM Users AS U
		   INNER JOIN Posts AS P ON U.id=2 AND P.uid=2  -- in the final condition, both U.id and P.uid have to be equal to 2 as we have to display the username of the second user from the Users table and the posts made by the user which can be found on the row with P.uid=2 from the Posts table     " 
SQLA[4] ='[["id", "username", "pid", "pmessage"], [2, "nab", 3, "nab post 1"], [2, "nab", 4, "nab post 2"]]'
# display id, username, pid, pmessage data for posts made by the user with the id =2  not using the JOIN keyword
SQLQ[5] = "SELECT U.id, U.username, P.pid, P.pmessage 
		   FROM Users AS U, Posts AS P 
		   WHERE U.id=2 AND P.uid=2 -- same query as the 4th one, with the difference that join keyword has not been used, thus making the query less efficient"
SQLA[5] ='[["id", "username", "pid", "pmessage"], [2, "nab", 3, "nab post 1"], [2, "nab", 4, "nab post 2"]]'
# display id, username, pid, rmessage data for replies made by the user with the id =2 not using the JOIN keyword
SQLQ[6] = "SELECT U.id, U.username, R.pid, R.rmessage -- as we have two tables to join , aliases have been used for each table, making the code easier to read
		   FROM Users AS U, Replies AS R
		   WHERE U.id=2 AND R.uid=2 -- both ids have to be equal to 2 as we have to select the id and the username for the 2nd user, as well as the replies made by the user and the id of each post that got a reply " 
SQLA[6] ='[["id", "username", "pid", "rmessage"], [2, "nab", 1, "reply 3"], [2, "nab", 2, "reply 4"]]'
# display id, username, pid, pmessage,  rid, rmessage data for replies made by the user with the id =2 not using the JOIN keyword
SQLQ[7] = "SELECT U.id, U.username, P.pid, P.pmessage, R.rid, R.rmessage -- aliases used for conventional purposes in order to improve readability 
		   FROM Users AS U, Posts AS P, Replies AS R 
		   WHERE U.id=2 AND R.uid=2 AND P.pid=R.pid  -- similar to query 6, we need to display the replies made by the 2nd user, thus the first two conditions about U.id and R.uid are the same as the ones from query 6 
		   -- as we have to display the id and the name of each post that got a reply from the 2nd user, it is necessary to check whether the id of the post from the Posts table coincide with the id of the post from the Replies table
		   -- in this way, we would get access to each post message by using the id of each post that got a reply 
		   -- an improvement of this query would be to use a join keyword instead "
SQLA[7] ='[["id", "username", "pid", "pmessage", "rid", "rmessage"], [2, "nab", 1, "admin post 1", 3, "reply 3"], [2, "nab", 2, "admin post 2", 4, "reply 4"]]'
# display id, username, pid, pmessage data for posts made by the user with the id =2  not using the JOIN keyword and using the table alias u for users and p for posts
SQLQ[8] = "SELECT U.id, U.username, P.pid, P.pmessage 
		   FROM Users AS U, Posts AS P 
		   WHERE U.id=2 AND P.uid=2 -- since we have to display posts made by the user with id=2, the user's id from the Users table and his id from the Posts table have to be equal to 2
		   -- an improvement for this query would be to use a join keyword in order to perform the task "
SQLA[8] ='[["id", "username", "pid", "pmessage"], [2, "nab", 3, "nab post 1"], [2, "nab", 4, "nab post 2"]]'
# display  id and username data for all users in username descending order 
SQLQ[9] = "SELECT id, username 
		   FROM Users 
		   ORDER BY username DESC  -- all of the usernames, as well as the ids are displayed in username descending order due to the addition of the DESC command
		   -- the usernames are ordered lexicographically and their ids are ordered as well, each username keeping their initial id"
SQLA[9] ='[["id", "username"], [2, "nab"], [3, "fred"], [1, "Admin"]]'
# display  id and username data for all users in username ascendng order and rename colmns id ID and username UN 
SQLQ[10] = "SELECT id AS ID, username AS UN 
			FROM Users
			ORDER BY username ASC -- using the ASC command, all the ids and the usernames are displayed in username ascending order"
SQLA[10] ='[["ID", "UN"], [1, "Admin"], [3, "fred"], [2, "nab"]]'
# display the number of posts made by the user with the id = 2
SQLQ[11] = "SELECT COUNT(uid) AS 'COUNT(id)' -- as the program requires to display the posts made by the user, we have to count all the uid occurences inside the Posts table 
			FROM Posts -- the alias has been used in order to pass the ruby test which requires the first column to be named COUNT(id)
			WHERE uid=2 -- the task cannot be performed using COUNT(id) as we have to count the posts inside the Posts table, whereas id is a name of a column from the Users table"
SQLA[11] ='[["COUNT(id)"], [2]]'
# display the number of posts made by the user with the id = 3 and rename the column 'Number of posts'
SQLQ[12] = "SELECT COUNT(uid) AS 'Number of posts' 
			FROM Posts 
			WHERE uid=3"
SQLA[12] ='[["Number of posts"], [2]]'
# display  each pid and the number of replies for each post under the column name 'Number of replies'
SQLQ[13] = "SELECT pid, COUNT(pid) AS 'Number of replies' -- the program counts how many times each post occurs in the Replies table, which would determine how many replies have been written for each post
			FROM Replies  
			GROUP BY pid -- the two displayed columns have to be grouped by pid(id of each post that occurs in the Replies table) so as to display each number of replies for each post
			-- without GROUP BY command, the program counts all the replies and does not group each post with its own number of replies"
SQLA[13] ='[["pid", "Number of replies"], [1, 3], [2, 3]]'
# display  uid and the number of replies from the user with the uid '3' under the column name 'Number of replies'
SQLQ[14] = "SELECT uid, COUNT(uid) AS 'Number of replies' -- similar approach as for query 13, with the difference that in this case we count the number of replies from the 3rd user 
			FROM Replies 
			WHERE uid=3 -- since we do not have to group all the columns for all users, the GROUP BY command can be omitted here"
SQLA[14] ='[["uid", "Number of replies"], [3, 2]]'
# display  uid, firstname, surname and the number of replies from the user 'fred bloggs' under the column name 'Number of replies'
SQLQ[15] = "SELECT R.uid, U.firstname, U.surname, COUNT(R.uid) AS 'Number of replies' -- the program will count the number of replies made by the user 'fred bloggs' by selecting the required information from tables Users and Replies
			FROM Users AS U, Replies AS R 
			WHERE U.firstname='Fred' AND U.id=R.uid -- here, we do not have to specify that the user's surname should be bloggs, the condition that his first name is Fred suffices
			-- since we specify that the first name should be Fred, the program knows that the last name would be Bloggs
			-- additionally, the program will know the user's id and, hence, the condition U.id=R.uid will pass the user's id to the Replies table from where the program will count and display the number of replies made by Fred"
SQLA[15] ='[["uid", "firstname", "surname", "Number of replies"], [3, "Fred", "Bloggs", 2]]'
# display id, firstname, surname of each user along with their supervisor's id, firstname, surname
SQLQ[16] = "SELECT A.id, A.firstname, A.surname, A.supervisor AS 'id', B.firstname, B.surname -- in this query, we have to manipulate two columns twice: once for displaying the users' firstnames and surnames, and once for the supervisors' names
			FROM Users A, Users B -- in order to achieve this, we have to formally duplicate the table by asigning ids: A and B; this action is necessary since the supervisors are users as well
			WHERE A.supervisor IS NOT NULL AND A.supervisor=B.id -- we would take the details for the users from table A and the details for the supervisors from table B
			-- hence, the first condition imposed is to display only the users that have supervisors, thus the supervisor's id should not be nil
			-- the second condition is to check if the supervisor's id from the A table matches to the user's id from the B table
			-- in this way, the program will group each user with their own supervisor
			-- the query could potentially be improved by using a join keyword between the two tables"
SQLA[16] ='[["id", "firstname", "surname", "id", "firstname", "surname"], [2, "Nigel", "Beacham", 1, "Alison", "Tonge"], [3, "Fred", "Bloggs", 2, "Nigel", "Beacham"]]'
# display the number of post likes awarded by the user 3.
SQLQ[17] = "SELECT uid, COUNT(pid) AS 'Number of likes' 
			FROM Likes 
			WHERE uid=3"
SQLA[17] ='[["uid", "Number of likes"], [3, 2]]'
# display the number of likes awarded by the user 3.
SQLQ[18] = "SELECT uid, COUNT(uid) AS 'Number of likes' 
			FROM Likes 
			WHERE uid=3"
SQLA[18] ='[["uid", "Number of likes"], [3, 4]]'
# display the number of likes awarded by the user 3.
SQLQ[19] = "SELECT L.uid, U.firstname, U.surname, COUNT(L.uid) AS 'Number of likes' 
			FROM Users AS U, Likes AS L
			WHERE L.uid=3 AND U.id=3"
SQLA[19] ='[["uid", "firstname", "surname", "Number of likes"], [3, "Fred", "Bloggs", 4]]'

db = SQLite3::Database.new(DbName)
db.results_as_hash = false
sqlnum = 0
sqlnum = SQLQ.size 
puts "Checking #{sqlnum} SQL statements."

for i in 0..sqlnum-1 do
	if SQLQ[i] != "" then
		results = db.execute2(SQLQ[i])
		puts "#{i}) Actual:   " + results.inspect
	end
	puts "#{i}) Expected: " + SQLA[i]
	if results.inspect == SQLA[i]
		puts "Match exists between expected SQLData and actual database data."
		correct = correct + 1
	else
		puts "No match exists between expected SQLData and actual database data."
	end
end
puts "Result: #{correct} out of #{sqlnum} correct."
