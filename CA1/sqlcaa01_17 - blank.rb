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
SQLQ[0] = "SELECT * FROM users "
SQLA[0] ='[["id", "username", "password", "edit", "created_at", "updated_at", "supervisor", "firstname", "surname"], [1, "Admin", "admin", "t", "2018-08-16 10:19:11.775108", "2018-08-16 10:19:11.775108", nil, "Alison", "Tonge"], [2, "nab", "nab", "f", "2018-08-16 11:00:41.576864", "2018-08-16 11:32:04.108250", 1, "Nigel", "Beacham"], [3, "fred", "fred", "f", "2018-08-16 11:00:41.576864", "2018-08-16 11:00:41.576864", 2, "Fred", "Bloggs"]]'
# display  id and username data for all users  
SQLQ[1] = "SELECT id,username FROM users"
SQLA[1] ='[["id", "username"], [1, "Admin"], [2, "nab"], [3, "fred"]]'
# display  id and username data for all users and rename colmns id ID and username UN 
SQLQ[2] = "SELECT id as 'ID',username as 'UN' FROM users "
SQLA[2] ='[["ID", "UN"], [1, "Admin"], [2, "nab"], [3, "fred"]]'
# display  id and username data for user with id = 2
SQLQ[3] = "SELECT id,username FROM users WHERE id=2"
SQLA[3] ='[["id", "username"], [2, "nab"]]'
# display id, username, pid, pmessage data for posts made by the user with the id =2 using an inner join
SQLQ[4] = "SELECT users.id,users.username,posts.pid,posts.pmessage FROM users INNER JOIN posts ON posts.uid=2 AND users.id=2"
SQLA[4] ='[["id", "username", "pid", "pmessage"], [2, "nab", 3, "nab post 1"], [2, "nab", 4, "nab post 2"]]'
# display id, username, pid, pmessage data for posts made by the user with the id =2  not using the JOIN keyword
SQLQ[5] = "SELECT id,username,pid,pmessage FROM users,posts WHERE id=2 AND uid=2"
SQLA[5] ='[["id", "username", "pid", "pmessage"], [2, "nab", 3, "nab post 1"], [2, "nab", 4, "nab post 2"]]'
# display id, username, pid, rmessage data for replies made by the user with the id =2 not using the JOIN keyword
SQLQ[6] = "SELECT id,username,pid,rmessage FROM users,replies WHERE id=2 AND uid=2"
SQLA[6] ='[["id", "username", "pid", "rmessage"], [2, "nab", 1, "reply 3"], [2, "nab", 2, "reply 4"]]'
# display id, username, pid, pmessage,  rid, rmessage data for replies made by the user with the id =2 not using the JOIN keyword
SQLQ[7] = "SELECT id,username,posts.pid,pmessage,rid,rmessage FROM users,posts,replies WHERE users.id=2 AND replies.uid=2 AND posts.pid=replies.pid"
SQLA[7] ='[["id", "username", "pid", "pmessage", "rid", "rmessage"], [2, "nab", 1, "admin post 1", 3, "reply 3"], [2, "nab", 2, "admin post 2", 4, "reply 4"]]'
# display id, username, pid, pmessage data for posts made by the user with the id =2  not using the JOIN keyword and using the table alias u for users and p for posts
SQLQ[8] = "SELECT id,username,pid,pmessage FROM users AS u,posts AS p WHERE id=2 AND uid=2"
SQLA[8] ='[["id", "username", "pid", "pmessage"], [2, "nab", 3, "nab post 1"], [2, "nab", 4, "nab post 2"]]'
# display  id and username data for all users in username descending order 
SQLQ[9] = "SELECT id,username FROM users ORDER BY username DESC"
SQLA[9] ='[["id", "username"], [2, "nab"], [3, "fred"], [1, "Admin"]]'
# display  id and username data for all users in username ascendng order and rename colmns id ID and username UN 
SQLQ[10] = "SELECT id AS ID,username as UN FROM users ORDER BY username ASC"
SQLA[10] ='[["ID", "UN"], [1, "Admin"], [3, "fred"], [2, "nab"]]'
# display the number of posts made by the user with the id = 2
SQLQ[11] = "SELECT COUNT(uid) AS 'COUNT(id)' FROM posts WHERE uid=2 "
SQLA[11] ='[["COUNT(id)"], [2]]'
# display the number of posts made by the user with the id = 3 and rename the column 'Number of posts'
SQLQ[12] = "SELECT COUNT(uid) AS 'Number of posts' FROM posts WHERE uid=3"
SQLA[12] ='[["Number of posts"], [2]]'
# display  each pid and the number of replies for each post under the column name 'Number of replies'
SQLQ[13] = "SELECT pid, COUNT(uid) AS 'Number of replies' FROM replies  GROUP BY pid "
SQLA[13] ='[["pid", "Number of replies"], [1, 3], [2, 3]]'
# display  uid and the number of replies from the user with the uid '3' under the column name 'Number of replies'
SQLQ[14] = "SELECT uid, COUNT(uid) AS 'Number of replies' FROM replies WHERE uid=3 GROUP BY uid"
SQLA[14] ='[["uid", "Number of replies"], [3, 2]]'
# display  uid, firstname, surname and the number of replies from the user 'fred bloggs' under the column name 'Number of replies'
SQLQ[15] = "SELECT uid, firstname, surname, COUNT(uid) as 'Number of replies' FROM users,replies WHERE uid=3 AND id=3"
SQLA[15] ='[["uid", "firstname", "surname", "Number of replies"], [3, "Fred", "Bloggs", 2]]'
# display id, firstname, surname of each user along with their supervisor's id, firstname, surname
SQLQ[16] = "SELECT A.id,A.firstname,A.surname,A.supervisor as 'id',B.firstname,B.surname FROM users A, users B WHERE A.supervisor IS NOT NULL AND A.supervisor=B.id"
SQLA[16] ='[["id", "firstname", "surname", "id", "firstname", "surname"], [2, "Nigel", "Beacham", 1, "Alison", "Tonge"], [3, "Fred", "Bloggs", 2, "Nigel", "Beacham"]]'
# display the number of post likes awarded by the user 3.
SQLQ[17] = "SELECT uid, COUNT(pid) AS 'Number of likes' FROM likes WHERE uid=3"
SQLA[17] ='[["uid", "Number of likes"], [3, 2]]'
# display the number of likes awarded by the user 3.
SQLQ[18] = "SELECT uid, COUNT(uid) AS 'Number of likes' FROM likes WHERE uid=3"
SQLA[18] ='[["uid", "Number of likes"], [3, 4]]'
# display the number of likes awarded by the user 3.
SQLQ[19] = "SELECT uid, firstname,surname,COUNT(uid) as 'Number of likes' from users,likes WHERE uid=3 AND id=3"
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
