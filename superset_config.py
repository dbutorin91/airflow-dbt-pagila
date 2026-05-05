import os

# Секретный ключ
SECRET_KEY = os.environ.get('SUPERSET_SECRET_KEY', 'local')

# База данных для метаданных Superset
SQLALCHEMY_DATABASE_URI = f"postgresql://{os.environ.get('DATABASE_USER', 'superset')}:{os.environ.get('DATABASE_PASSWORD', 'superset')}@{os.environ.get('DATABASE_HOST', 'postgres')}:{os.environ.get('DATABASE_PORT', '5432')}/{os.environ.get('DATABASE_DB', 'superset')}"

# Redis для кэширования и Celery
REDIS_URL = f"redis://{os.environ.get('REDIS_HOST', 'redis')}:{os.environ.get('REDIS_PORT', '6379')}/0"

# Настройки Celery
CELERY_BROKER_URL = f"redis://{os.environ.get('REDIS_HOST', 'redis')}:{os.environ.get('REDIS_PORT', '6379')}/1"
CELERY_RESULT_BACKEND = f"redis://{os.environ.get('REDIS_HOST', 'redis')}:{os.environ.get('REDIS_PORT', '6379')}/1"

# Дополнительные настройки для разработки
DEBUG = True
FLASK_ENV = 'development'
ENABLE_CORS = True
ENABLE_PROXY_FIX = True

# Картографические сервисы
MAPBOX_API_KEY = os.environ.get('MAPBOX_API_KEY', '')

# Лимиты
SUPERSET_WEBSERVER_TIMEOUT = 300
SQLLAB_TIMEOUT = 300