# import os
# from dotenv import load_dotenv
# from langchain_openai import ChatOpenAI
# ##### from langchain import sql_database
# from langchain_community.utilities.sql_database import SQLDatabase
# ##### from langchain_community.utilities import SQLDatabaseChain
# from langchain_experimental.sql import SQLDatabaseChain



# load_dotenv()

# DATABASE_URL = os.getenv('DATABASE_URL')

# ##### db = sql_database(DATABASE_URL)
# db = SQLDatabase.from_uri(DATABASE_URL)
# ###### db = SQLDatabase.from_uri("postgresql://admin:password@postgres:5432/mentoradb")

# print(f"DB: {db}")  # Print the database object (for debugging pub)

# #### Initialize the model
# model = ChatOpenAI(model="gpt-3.5-turbo")

# db_chain = SQLDatabaseChain.from_llm(model, db, verbose=True)   

# db_chain.run("How many users have signed up")