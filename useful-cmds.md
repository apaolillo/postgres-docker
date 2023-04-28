# Useful commands

```bash
cd workspace/
git clone https://git.postgresql.org/git/postgresql.git
cd postgresql/
git checkout REL_15_2

# build
mkdir build
cd build
../configure
make -j $(nproc)
make -j $(nproc) world-bin
make check  # tests

# init
LD_LIBRARY_PATH=/home/tony/workspace/postgresql/build/src/interfaces/libpq \
  ./tmp_install/usr/local/pgsql/bin/initdb -D /home/tony/workspace/data

./tmp_install/usr/local/pgsql/bin/postgres -D /home/tony/workspace/data

# increase shared memory resource (optional)
sysctl -w kernel.shmmax=17179869184
sysctl -w kernel.shmall=4194304

# properly shutting down the server (sending SIGTERM)
kill -INT $(head -1 ../../data/postmaster.pid )

# create a db (to check)
LD_LIBRARY_PATH=/home/tony/workspace/postgresql/build/src/interfaces/libpq ./tmp_install/usr/local/pgsql/bin/createdb tonytest

# connect with the client
LD_LIBRARY_PATH=/home/tony/workspace/postgresql/build/src/interfaces/libpq ./tmp_install/usr/local/pgsql/bin/psql tonytest

# list existing databases
./tmp_install/usr/local/pgsql/bin/psql tonytest -c "SELECT * FROM pg_database;" --csv

# query for all databases
SELECT datname FROM pg_database;
# query for all tables
SELECT tablename FROM pg_tables WHERE schemaname='public';


LD_LIBRARY_PATH=/home/tony/workspace/postgresql/build/src/interfaces/libpq \
  ./tmp_install/usr/local/pgsql/bin/psql mydb -c "SELECT * FROM mytable;" --csv
```