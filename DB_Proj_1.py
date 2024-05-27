import mysql.connector
from mysql.connector import Error

def connect_to_database(host, user, password, database):
    try:
        connection = mysql.connector.connect(
            host=host,
            user=user,
            password=password,
            database=database
        )

        if connection.is_connected():
            print("Successfully connected to the database")
            return connection

    except Error as e:
        print(f"Error: {e}")
        return None

def close_connection(connection):
    if connection.is_connected():
        connection.close()
        print("Database connection closed")
insert_queries = {
    "person": ("""INSERT INTO Person (SSN, Fname, Lname, Age, Weight, Height, Gender) VALUES(%s, %s, %s, %s, %s, %s, %s)""", 7),
    "workout": ("""INSERT INTO Workout (Duration, Date, Person, Quality) VALUES(%s, %s, %s, %s)""", 4),
    "exercise_type": ("""INSERT INTO Exercise_type (Name, Description) VALUES(%s, %s)""", 2),
    "exercise": ("""INSERT INTO Exercise_type (Name, Description) VALUES(%s, %s)""", 2),
    "set": ("""INSERT INTO Sett (SetID, Weight, Reps, Exercise) VALUES (%s, %s, %s, %s)""", 4)
}

def insert_record(connection, type, args):
    try:
        cursor = connection.cursor()
        insert_query = insert_queries[type][0]
        param_len = insert_queries[type][1]

        if len(args) != param_len:
            print("Invalid amount of parameters for record")
            return


        record = tuple(args[:param_len])


        cursor.execute(insert_query, record)
        connection.commit()
        print("Record inserted successfully")

    except Error as e:
        print(f"Error: {e}")

def command_entered(args, db_conn):
    command = args[0]

    if command == "insert":
        try:
            insert_record(db_conn, args[1], args[2:])
        except KeyError:
            print("Invalid insert record type")
    elif command == "get_pr":
        get_pr(db_conn, args[1], args[2])
    elif command == "get_total_worktout_hours":
        get_total_worktout_hours(db_conn, args[1])
    elif command == "get_workouts":
        get_workouts(db_conn, args[1])
    else:
        print("Invalid command")

def fetch_data(connection, query, data):
    cursor = connection.cursor()
    cursor.execute(query, data)
    result = cursor.fetchall()

    for row in result:
        print(row)

def get_total_worktout_hours(connection, ssn):
    query = """
        SELECT GetTotalWorkoutHours(%s);
    """
    fetch_data(connection, query, (ssn))

def get_pr(connection, ssn, exercise_type):
    query = """
        SELECT GetPr(%s, %s)
    """
    fetch_data(connection, query, (ssn, exercise_type))

def get_workouts(connection, ssn,):
    query = """
        SELECT * FROM personalWorkouts WHERE SSN = %s;
    """
    fetch_data(connection, query, (ssn,))

if __name__ == "__main__":
    db_host = 'localhost'
    db_user = 'root'
    db_password = 'DV1663'
    db_name = 'tracker'

    connection = connect_to_database(db_host, db_user, db_password, db_name)

    if connection:
        while True:
            inp = input()
            inp_lst = inp.split(' ')
            command_entered(inp_lst, connection)
        close_connection(connection)