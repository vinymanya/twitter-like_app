from flask import Flask, render_template, request, redirect, session, flash, url_for
from mysqlconnection import MySQLConnector
from flask_bcrypt import Bcrypt


app = Flask(__name__)
mysql = MySQLConnector(app, "twitterDB")
app.secret_key = "W12Zr47j/3yX R~X@Hu0|q/9!jmM]Lwf/,?KTW%"
bcrypt = Bcrypt(app)


# Index route
@app.route("/")
def index():
	if "user_id" in session:
		return redirect(url_for("dashboard"))
	return render_template("index.html")

# Register Route
@app.route("/users/register", methods=["POST"])
def register():
	action = request.form["action"]
	errors = []
	# Check the form being submitted
	if action == "register":
		
		username = request.form["username"]
		password = request.form["password"]
		# Validate inputs
		if len(username) < 1:
			errors.append("username cannot be empty")
		if len(password) < 6:
			errors.append("Password must be at least 6 characters long!")
		# Check for errors
		if len(errors) > 0:
			for message in errors:
				flash(message, "error")
				return redirect(url_for("index"))
		# Go ahead and hash the password
		pw_hash = bcrypt.generate_password_hash(password)
		query = "INSERT INTO users(username, password, created_at, updated_at) VALUES(:un, :password, NOW(), NOW())"
		data = {
			"un": username,
			"password": pw_hash
		}
		mysql.query_db(query, data) 
		# Keep track the registred user
		query = "SELECT users.id, users.username FROM users WHERE username = :username"
		data = {
			"username": username
		}

		user = mysql.query_db(query, data) # [] or [{}]
		# Save user id in session
		session["user_id"] = user[0]["id"]
		session["username"] = user[0]["username"]
		flash("You have been successfully Registered", "success")
		return redirect(url_for("dashboard"))


# Login Route
@app.route("/users/login", methods=["POST"])
def login():
	action = request.form["action"]
	if action == "login":
		username = request.form["username"]
		# Login is simply comparing the password and email in the db
		query = "SELECT * FROM users WHERE username = :username"
		data = {
			'username': username
		}
		result = mysql.query_db(query, data) #  [] or [{}]
		 # Checking to see if there is a user by that username in the db.
		if result and bcrypt.check_password_hash(result[0]["password"], request.form["password"]):
			session["user_id"] = result[0]["id"]
			session["username"] = result[0]["username"]
			return redirect(url_for('dashboard'))
		else:
			flash("Invalid username or Password!!!", "error")
			return redirect(url_for("index"))

# Dashboard route
@app.route("/dashboard")
def dashboard():
	# Route guard
	if "user_id" not in session:
		return redirect(url_for("index"))
	# Retrieve all tweets
	query = "SELECT users.username AS username, tweets.tweet, tweets.id AS tweet_id, tweets.user_id, tweets.created_at AS time_stamp FROM users JOIN tweets ON users.id = tweets.user_id ORDER BY tweets.id DESC"
	all_tweets = mysql.query_db(query)
	# print "ALL TWEETS: {}".format(all_tweets)
	
	# Retrieve all users
	query = "SELECT * FROM users"
	all_users = mysql.query_db(query)
	# print all_users

	# Retrieve followers
	query = "SELECT * FROM followers WHERE follower_id=:user_id"
	data = {
		"user_id": session["user_id"]
	}
	followings = mysql.query_db(query, data)
	# print followings
	
	# Filter or Get leaders from the followings
	all_leader_ids = []
	for following in followings: 
		all_leader_ids.append(following["leader_id"])
	# print all_leader_ids

	# Retrieve all likes
	query = "SELECT * FROM likes"
	likes = mysql.query_db(query)
	my_like = 0
	all_likes = []
	for like in likes:
		all_likes.append(like["user_id"])
	# print "LIKES: {}".format(likes)
	return render_template(
				"dashboard.html", 
				users=all_users, 
				tweets=all_tweets, 
				leaders = all_leader_ids, 
				likes = likes,
				my_like=my_like  )

# Create Tweets
@app.route("/create_tweet", methods=["POST"])
def create_tweet():
	# Insert the new tweet into db
	query = "INSERT INTO tweets(tweet, created_at, updated_at, user_id) VALUES(:tweet, NOW(), NOW(), :user_id)"
	data = {
		"tweet": request.form["new_tweet"],
		"user_id": session["user_id"]
	}
	mysql.query_db(query, data)
	return redirect(url_for("dashboard"))

# Handle following
@app.route("/follow/<user_id>")
def follow(user_id):
	if "user_id" not in session:
		return redirect(url_for("index"))
	# Insert data into the 'followers' table
	query = "INSERT INTO followers(follower_id, leader_id) VALUES(:follower_id, :leader_id)"
	data = {
		"follower_id": session["user_id"],
		"leader_id": user_id
	}
	mysql.query_db(query, data)
	return redirect(url_for("dashboard"))

# Handle unfollowing a user
@app.route("/unfollow/<user_id>")
def unfollow(user_id):
	# Unfollowing is removing the follower_id and the leader_id from the followers table
	pass


# Handling likes
@app.route("/like/<tweet_id>")
def like(tweet_id):
	query = "INSERT INTO likes(tweet_id, user_id) VALUES(:tweet_id, :user_id)"
	data = {
		"tweet_id": tweet_id,
		"user_id": session["user_id"]
	}
	mysql.query_db(query, data)
	return redirect(url_for("dashboard"))

# logout route
@app.route("/logout")
def logout():
	session.clear()
	return redirect("/")


app.run(debug=True)