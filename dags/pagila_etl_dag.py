from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.operators.dummy import DummyOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime, timedelta
import sys  
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'scripts'))

from extract_pagila import extract_from_pagila
from data_quality import data_quality_check

default_args = {
    'owner': 'airflow_user',
    'start_date': datetime(2025, 1, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    'pagila_etl',
    start_date=datetime(2025, 1, 1),
    default_args=default_args,
    description='ETL pipeline for Pagila',
    schedule_interval='@daily',
    catchup=False
) as dag:

    #Выгрузка сырых данных
    extract_task = PythonOperator(
        task_id='extract_data',
        python_callable=extract_from_pagila
    )   

    #Сырые данные в staging
    dbt_staging = BashOperator(
        task_id='dbt_staging',
        bash_command='cd /opt/airflow/dbt_pagila && dbt run --profiles-dir /opt/airflow/dbt_pagila --models staging'
    )

    #Создание хранилища
    dbt_run_core = BashOperator(
        task_id='dbt_run_core',
        bash_command='cd /opt/airflow/dbt_pagila && dbt run --profiles-dir /opt/airflow/dbt_pagila --models core'
    )

    #Создание витрины
    dbt_run_mart = BashOperator(
        task_id='dbt_run_mart',
        bash_command='cd /opt/airflow/dbt_pagila && dbt run --profiles-dir /opt/airflow/dbt_pagila --models mart'
    )

    #Качество данных
    dq_check = PythonOperator(
        task_id='data_quality_check',
        python_callable=data_quality_check
    )

    extract_task >> dbt_staging >> dbt_run_core >> dbt_run_mart >> dq_check

