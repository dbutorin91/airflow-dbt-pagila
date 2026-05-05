import os

DB_CONFIG = {
    'pagila_source': {
        'host': os.getenv('POSTGRES_HOST', 'postgres'),
        'port': os.getenv('POSTGRES_PORT', '5432'),
        'database': os.getenv('POSTGRES_SOURCE_DB', 'pagila'),
        'user': os.getenv('POSTGRES_USER', 'airflow'),
        'password': os.getenv('POSTGRES_PASSWORD', 'airflow')
    },
    'pagila_dwh': {
        'host': os.getenv('POSTGRES_HOST', 'postgres'), 
        'port': os.getenv('POSTGRES_PORT', '5432'),
        'database': os.getenv('POSTGRES_DWH_DB', 'pagila_dw'),
        'user': os.getenv('POSTGRES_USER', 'airflow'),
        'password': os.getenv('POSTGRES_PASSWORD', 'airflow')
    }
}

def get_connection_string(db_name):
    config = DB_CONFIG[db_name]
    return f"postgresql://{config['user']}:{config['password']}@{config['host']}:{config['port']}/{config['database']}"