import pandas as pd
from sqlalchemy import create_engine

from config.database_connections import get_connection_string

def data_quality_check():
    engine = get_connection_string('pagila_dwh')
    
    #Возможные проверки качесва
    # - В витрине отрицательная выручка
    # - Количество проката в таблице фактов пустое
    # - Пустое значение в ключе
    checks = [
        "SELECT COUNT(*) FROM dbt_dm.sales_summary WHERE revenue < 0",
        "SELECT COUNT(*) FROM dbt_dw.fact_rental WHERE amount IS NULL",
        "SELECT COUNT(*) FROM dbt_dw.dim_customer WHERE customer_key IS NULL"
    ]
    
    for check in checks:
        result = pd.read_sql(check, engine).iloc[0,0]
        if result > 0:
            raise ValueError(f"Data quality check failed: {check}")
