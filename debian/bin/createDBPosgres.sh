name=$1

docker exec -it -u postgres postgres psql --command "CREATE USER \"$name\" password '$name';" --command "CREATE DATABASE \"$name\" OWNER \"$name\";"
