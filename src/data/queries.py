import psycopg2
from config import config
from datetime import datetime

# @group work Linda, Samu, Tomi

def database_design():
    con = None
    try:
        con = psycopg2.connect(**config())
        cursor = con.cursor()

        # x
        SQL_CREATE_TABLE = '''
        -- Create table Flights
        CREATE TABLE IF NOT EXISTS x
        '''
        cursor.execute(SQL_INSERT_ROWS)

        con.commit()
        cursor.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error: {error}")
    finally:
        if con is not None:
            con.close()

def main():
    pass

if __name__ == "__main__":
    main()
