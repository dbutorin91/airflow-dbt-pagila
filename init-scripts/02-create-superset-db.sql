CREATE USER superset WITH PASSWORD 'superset';

CREATE DATABASE superset;

GRANT ALL PRIVILEGES ON DATABASE superset TO superset;

\c superset
GRANT ALL ON SCHEMA public TO superset;