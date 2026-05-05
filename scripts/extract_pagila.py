# C:/airflow/scripts/extract_pagila.py
import pandas as pd
# import psycopg2
from sqlalchemy import create_engine, text
from sqlalchemy_utils import database_exists, create_database
import logging
from datetime import datetime
import sys
import os
from sqlalchemy.dialects.postgresql import ARRAY, TEXT

from config.database_connections import get_connection_string

def extract_from_pagila():

    # Настройка логирования
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler('logs/extraction.log'),
            logging.StreamHandler()
        ]
    )
    
    try:
        logging.info("Starting extraction...")

        src_conn_str = get_connection_string('pagila_source')
        dst_conn_str = get_connection_string('pagila_dwh')
        
        src_engine = create_engine(src_conn_str)
        dst_engine = create_engine(dst_conn_str)

        if not database_exists(dst_conn_str):
            create_database(dst_conn_str)
            print(f"DB 'pagila_dw' created")
        else:
            print(f"DB 'pagila_dw' already existed")

        # Создаём схему
        with dst_engine.begin() as conn:
            conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS staging"))
            print(f"Schema 'staging' created")
        
        tables = ['payment', 'rental', 'customer', 'film', 'inventory','address','city','country','language','film_category','category','category','film','staff','store']

        for table in tables:
            with src_engine.connect() as conn:
                df = pd.read_sql(f"SELECT * FROM {table}", con=conn.connection)
            
            with dst_engine.begin() as conn:
                conn.execute(text(f"DROP VIEW IF EXISTS dbt_staging.stg_pagila__{table}"))

            with dst_engine.begin() as conn:
                
                dtype = {
                    'special_features': ARRAY(TEXT)
                }

                df.to_sql(
                    f'stg_{table}', 
                    con=dst_engine, 
                    dtype=dtype,
                    schema='staging', 
                    if_exists='replace', 
                    index=False,
                    method='multi'  
                )
            
            logging.info(f"Extracted {len(df)} rows from {table}")
        
        logging.info("Extraction completed successfully!")
        
    except Exception as e:
        logging.error(f"Extraction failed: {str(e)}")
        raise

if __name__ == "__main__":
    extract_from_pagila()