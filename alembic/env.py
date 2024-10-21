from logging.config import fileConfig

from sqlalchemy import engine_from_config
from sqlalchemy import pool

from alembic import context
# from decouple import config as envConfig
from decouple import Config, RepositoryEnv
from dotenv import find_dotenv
from app.auth.models import User
from app.journal.models import JournalEntryDB
from app.activities.models import Activity
from database import Base

import os
from dotenv import load_dotenv

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
load_dotenv()
config = context.config
# envConfig = Config(RepositoryEnv(".env"))
# app_env = os.getenv('APP_ENV','dev')

db_username = os.getenv('DB_USERNAME')
db_password = os.getenv('DB_PASSWORD')
db_host = os.getenv('DB_HOST')
db_name = os.getenv('DB_NAME')

# if(app_env == 'prod'):
#     env_path = find_dotenv('env.prod')
#     envConfig =Config(RepositoryEnv(env_path))

# Interpret the config file for Python logging.
# This line sets up loggers basically.
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

db_url = f"postgresql://{db_username}:{db_password}@{db_host}/{db_name}"


# db_url =f"postgresql://{envConfig('DB_USERNAME')}:{envConfig('DB_PASSWORD')}@{envConfig('DB_HOST')}/{envConfig('DB_NAME')}"


# section = config.config_ini_section
# config.set_section_option(section,"DB_NAME",envConfig("DB_NAME"))
# config.set_section_option(section,"DB_USERNAME",envConfig("DB_USERNAME"))
# config.set_section_option(section,"DB_PASSWORD",envConfig("DB_PASSWORD"))

# add your model's MetaData object here
# for 'autogenerate' support
# from myapp import mymodel
# target_metadata = mymodel.Base.metadata
target_metadata = Base.metadata
config.set_main_option('sqlalchemy.url',db_url)

# other values from the config, defined by the needs of env.py,
# can be acquired:
# my_important_option = config.get_main_option("my_important_option")
# ... etc.


def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode.

    This configures the context with just a URL
    and not an Engine, though an Engine is acceptable
    here as well.  By skipping the Engine creation
    we don't even need a DBAPI to be available.

    Calls to context.execute() here emit the given string to the
    script output.

    """
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    """Run migrations in 'online' mode.

    In this scenario we need to create an Engine
    and associate a connection with the context.

    """
    config_section = config.get_section(config.config_ini_section)
    config_section['sqlalchemy.url'] = db_url

    connectable = engine_from_config(
        config_section,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection, target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
