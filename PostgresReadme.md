
### Get the PostgreSQL container IP address
 postgres_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgres_container)
### Get the PostgreSQL username and password from environment variables
postgres_user=$(docker exec postgres_container env | grep POSTGRES_USER | cut -d '=' -f2)
postgres_password=$(docker exec postgres_container env | grep POSTGRES_PASSWORD | cut -d '=' -f2)
echo "PostgreSQL Host: $postgres_ip" 
echo "PostgreSQL Username: $postgres_user"
echo "PostgreSQL Password: $postgres_password"

### Insert test data into PG

psql -h localhost -U postgres

#### Create a table for roles
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(255) UNIQUE NOT NULL);

INSERT INTO roles (role_name) VALUES 
('Admin'), 
('Guest'), 
('Moderator'), 
('User');

#### Create a table for users
CREATE TABLE users (
    email VARCHAR(255) PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255));

INSERT INTO users (email, first_name, last_name) VALUES 
('john@example.com', 'John', 'Doe'),
('jane@example.com', 'Jane', 'Smith'),
('alice@example.com', 'Alice', 'Johnson'),
('bob@example.com', 'Bob', 'Williams');

#### Create a table for user_role_mapping
CREATE TABLE user_role_mapping (
    email VARCHAR(255) REFERENCES users(email),
    role_id INT REFERENCES roles(role_id),
    PRIMARY KEY (email, role_id));

-- Mapping for john@example.com
INSERT INTO user_role_mapping (email, role_id)
SELECT 'john@example.com', role_id FROM roles WHERE role_name IN ('Admin', 'Guest');

-- Mapping for jane@example.com
INSERT INTO user_role_mapping (email, role_id)
SELECT 'jane@example.com', role_id FROM roles WHERE role_name IN ('Guest', 'Moderator', 'User');

-- Mapping for alice@example.com
INSERT INTO user_role_mapping (email, role_id)
SELECT 'alice@example.com', role_id FROM roles WHERE role_name = 'Moderator';

-- Mapping for bob@example.com
INSERT INTO user_role_mapping (email, role_id)
SELECT 'bob@example.com', role_id FROM roles WHERE role_name = 'User';
