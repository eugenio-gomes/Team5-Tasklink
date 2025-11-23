USE tasklink_db;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE workspaces (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    owner_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE TABLE workspace_memberships (
    id INT PRIMARY KEY AUTO_INCREMENT,
    workspace_id INT NOT NULL,
    user_id INT NOT NULL,
    role ENUM('owner','member') DEFAULT 'member',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (workspace_id) REFERENCES workspaces(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    workspace_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    archived BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (workspace_id) REFERENCES workspaces(id)
);

CREATE TABLE columns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    position INT DEFAULT 0,
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

CREATE TABLE tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT NOT NULL,
    column_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    assignee_id INT,
    priority ENUM('low','medium','high') DEFAULT 'medium',
    due_date DATE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (column_id) REFERENCES columns(id),
    FOREIGN KEY (assignee_id) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    task_id INT NOT NULL,
    author_id INT NOT NULL,
    text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES tasks(id),
    FOREIGN KEY (author_id) REFERENCES users(id)
);
CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);



CREATE INDEX idx_tasks_project_column ON tasks(project_id, column_id);
CREATE INDEX idx_users_email ON users(email);

-- Users
INSERT INTO users (name, email, password_hash) VALUES ('Alice', 'alice@example.com', 'hash1');
INSERT INTO users (name, email, password_hash) VALUES ('Bob', 'bob@example.com', 'hash2');

-- Workspace
INSERT INTO workspaces (name, owner_id) VALUES ('Workspace 1', 1);

-- Memberships
INSERT INTO workspace_memberships (workspace_id, user_id, role) VALUES (1, 1, 'owner');
INSERT INTO workspace_memberships (workspace_id, user_id, role) VALUES (1, 2, 'member');

-- Projects
INSERT INTO projects (workspace_id, name, description) VALUES (1, 'Project Alpha', 'First project');

-- Columns
INSERT INTO columns (project_id, title, position) VALUES (1, 'Todo', 0);
INSERT INTO columns (project_id, title, position) VALUES (1, 'In Progress', 1);
INSERT INTO columns (project_id, title, position) VALUES (1, 'Done', 2);

SELECT * FROM users;
SELECT * FROM workspaces;
SELECT * FROM projects;
SELECT * FROM columns;

show DATABASES;
USE tasklink_db;
SHOW TABLES;