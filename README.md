# Airflow dbt Demo · Airflow × dbt

[![Airflow](https://img.shields.io/badge/Airflow-2.x-017CEE?logo=apache-airflow)](https://airflow.apache.org/)
[![dbt](https://img.shields.io/badge/dbt-1.x-FF694B?logo=dbt)](https://www.getdbt.com/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Простой и воспроизводимый пайплайн для аналитики данных, построенный на базе **Apache Airflow** и **dbt**.  
Проект реализует паттерн ELT: загрузка сырых данных → трансформация в витрины данных → оркестрация и мониторинг.

## 🧱 Архитектура

```mermaid
graph LR
    A[Источники данных] --> B[Airflow: Extract & Load]
    B --> C[Data Warehouse / Data Lake]
    C --> D[dbt: Transform & Test]
    D --> E[Витрины данных / BI]
```

Установка и запуск
1. Клонируйте репозиторий:

```bash
git clone [url-вашего-репозитория]
cd [название-проекта]
```

2. Настройте переменные окружения:

```bash
cp .env.example .env
```

3. Запустите инфраструктуру через Docker:

```bash
docker compose up -d
```

После запуска: 
- веб-интерфейс Airflow будет доступен по адресу: http://localhost:8080
(Логин: airflow, Пароль: airflow)
- веб-интерфейс Superset будет доступен по адресу: http://localhost:8088
(Логин: airflow, Пароль: airflow)
