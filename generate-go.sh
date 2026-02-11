#!/bin/bash

# ===============================
# Go Blueprint Generator Ultimate
# ===============================

# ===== COLORS =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# ===== BANNER =====
clear
echo -e "${CYAN}"
cat << "EOF"
  ██████╗  ██████╗ ██╗      █████╗ ███╗   ██╗ ██████╗ 
 ██╔════╝ ██╔═══██╗██║     ██╔══██╗████╗  ██║██╔════╝ 
 ██║  ███╗██║   ██║██║     ███████║██╔██╗ ██║██║  ███╗
 ██║   ██║██║   ██║██║     ██╔══██║██║╚██╗██║██║   ██║
 ╚██████╔╝╚██████╔╝███████╗██║  ██║██║ ╚████║╚██████╔╝
  ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
EOF
echo -e "${NC}"
echo -e "${MAGENTA}┌────────────────────────────────────────────────────┐${NC}"
echo -e "${MAGENTA}│${NC}${YELLOW}          BLUEPRINT GENERATOR ULTIMATE          ${NC}${MAGENTA}│${NC}"
echo -e "${MAGENTA}├────────────────────────────────────────────────────┤${NC}"
echo -e "${MAGENTA}│${NC}  ${GREEN}Ultimate Backend Starter Kit${NC}                    ${MAGENTA}│${NC}"
echo -e "${MAGENTA}│${NC}  ${CYAN}Version 2.0${NC} │ ${BLUE}Go 1.21+${NC}                          ${MAGENTA}│${NC}"
echo -e "${MAGENTA}└────────────────────────────────────────────────────┘${NC}"
echo ""

# ===== FRAMEWORK =====
echo -e "${CYAN}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}SELECT WEB FRAMEWORK${NC}                          ${CYAN}│${NC}"
echo -e "${CYAN}├─────────────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}1${NC}  Chi      ${BLUE}Fast, lightweight router${NC}         ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}2${NC}  Gin      ${BLUE}High-performance framework${NC}       ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}3${NC}  Fiber    ${BLUE}Express-inspired framework${NC}       ${CYAN}│${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"
echo -e ""
read -p "$(echo -e ${MAGENTA}❯${NC}) " fw_choice
case $fw_choice in
  1) FRAMEWORK="chi"; DEP="github.com/go-chi/chi/v5"; echo -e "${GREEN}✓${NC} Chi selected";;
  2) FRAMEWORK="gin"; DEP="github.com/gin-gonic/gin"; echo -e "${GREEN}✓${NC} Gin selected";;
  3) FRAMEWORK="fiber"; DEP="github.com/gofiber/fiber/v2"; echo -e "${GREEN}✓${NC} Fiber selected";;
  *) echo -e "${YELLOW}⚠${NC} Invalid choice, using Chi"; FRAMEWORK="chi"; DEP="github.com/go-chi/chi/v5";;
esac
echo ""

# ===== DATABASE =====
echo -e "${CYAN}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}SELECT DATABASE${NC}                               ${CYAN}│${NC}"
echo -e "${CYAN}├─────────────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}1${NC}  MongoDB    ${BLUE}NoSQL document database${NC}        ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}2${NC}  MySQL      ${BLUE}Popular relational DB${NC}          ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}3${NC}  PostgreSQL ${BLUE}Advanced relational DB${NC}         ${CYAN}│${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"
echo -e ""
read -p "$(echo -e ${MAGENTA}❯${NC}) " db_choice
case $db_choice in
  1) DB="mongodb"; DB_DEP="go.mongodb.org/mongo-driver/mongo"; echo -e "${GREEN}✓${NC} MongoDB selected";;
  2) DB="mysql"; DB_DEP="github.com/go-sql-driver/mysql"; echo -e "${GREEN}✓${NC} MySQL selected";;
  3) DB="postgres"; DB_DEP="github.com/lib/pq"; echo -e "${GREEN}✓${NC} PostgreSQL selected";;
  *) echo -e "${YELLOW}⚠${NC} Invalid choice, using MongoDB"; DB="mongodb"; DB_DEP="go.mongodb.org/mongo-driver/mongo";;
esac
echo ""

# ===== PROJECT NAME =====
echo -e "${CYAN}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}PROJECT NAME${NC}                                  ${CYAN}│${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"
echo -e ""
read -p "$(echo -e ${MAGENTA}❯${NC}) " PROJNAME
echo ""
echo -e "${GREEN}✓${NC} Creating project structure..."
echo ""
mkdir -p $PROJNAME/{handlers,models,routes,db,middleware}
cd $PROJNAME || exit

# ===== ENV =====
echo -e "${BLUE}[1/5]${NC} Generating environment file..."
cat > .env <<EOL
PORT=8080
DB_TYPE=$DB
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASS=password
DB_NAME=$PROJNAME
MONGO_URI=mongodb://localhost:27017
POSTGRES_USER=postgres
POSTGRES_PASS=postgres
POSTGRES_DB=$PROJNAME
EOL

# ===== GO MODULE INIT =====
echo -e "${BLUE}[2/5]${NC} Initializing Go module..."
go mod init $PROJNAME

# ===== INSTALL DEPENDENCIES =====
echo -e "${BLUE}[3/5]${NC} Installing dependencies..."
go get $DEP
go get $DB_DEP

# ===== MAIN.GO =====
echo -e "${BLUE}[4/5]${NC} Generating application files..."
cat > main.go <<EOL
package main

import (
    "log"
    "net/http"
    "os"
    "$PROJNAME/routes"
    "github.com/go-chi/chi/v5"
    "github.com/go-chi/chi/v5/middleware"
)

func main() {
    port := os.Getenv("PORT")
    if port == "" { 
        port = "8080" 
    }

    r := chi.NewRouter()
    r.Use(middleware.Logger)
    r.Use(middleware.Recoverer)

    routes.SetupRoutes(r)

    log.Printf("Server running at http://localhost:%s\n", port)
    http.ListenAndServe(":"+port, r)
}
EOL

# ===== ROUTES =====
cat > routes/routes.go <<EOL
package routes

import (
    "$PROJNAME/handlers"
    "github.com/go-chi/chi/v5"
)

func SetupRoutes(r *chi.Mux) {
    r.Get("/", handlers.HomeHandler)
    r.Route("/users", func(r chi.Router) {
        r.Get("/", handlers.GetUsers)
        r.Post("/", handlers.CreateUser)
    })
}
EOL

# ===== HANDLERS =====
cat > handlers/user.go <<EOL
package handlers

import (
    "encoding/json"
    "net/http"
    "$PROJNAME/models"
)

var users = []models.User{}

func HomeHandler(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("Hello, $PROJNAME!"))
}

func GetUsers(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(users)
}

func CreateUser(w http.ResponseWriter, r *http.Request) {
    var u models.User
    json.NewDecoder(r.Body).Decode(&u)
    u.ID = len(users) + 1
    users = append(users, u)
    
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(u)
}
EOL

# ===== MODELS =====
cat > models/user.go <<EOL
package models

type User struct {
    ID   int    \`json:"id"\`
    Name string \`json:"name"\`
}
EOL

# ===== DB CONNECT =====
echo -e "${BLUE}[5/5]${NC} Configuring database connection..."

if [ "$DB" = "mongodb" ]; then
cat > db/db.go <<EOL
package db

import (
    "context"
    "log"
    "os"
    "time"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
)

func ConnectDB() *mongo.Client {
    uri := os.Getenv("MONGO_URI")
    ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
    defer cancel()
    
    client, err := mongo.Connect(ctx, options.Client().ApplyURI(uri))
    if err != nil {
        log.Fatal(err)
    }
    
    err = client.Ping(ctx, nil)
    if err != nil {
        log.Fatal(err)
    }
    
    log.Println("Connected to MongoDB!")
    return client
}
EOL

elif [ "$DB" = "mysql" ]; then
cat > db/db.go <<EOL
package db

import (
    "database/sql"
    "fmt"
    "log"
    "os"
    _ "github.com/go-sql-driver/mysql"
)

func ConnectDB() *sql.DB {
    user := os.Getenv("DB_USER")
    pass := os.Getenv("DB_PASS")
    host := os.Getenv("DB_HOST")
    port := os.Getenv("DB_PORT")
    dbname := os.Getenv("DB_NAME")
    
    dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true", user, pass, host, port, dbname)
    db, err := sql.Open("mysql", dsn)
    if err != nil {
        log.Fatal(err)
    }
    
    err = db.Ping()
    if err != nil {
        log.Fatal(err)
    }
    
    stmt := \`CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    )\`
    _, err = db.Exec(stmt)
    if err != nil {
        log.Fatal(err)
    }
    
    log.Println("Connected to MySQL!")
    return db
}
EOL

else
cat > db/db.go <<EOL
package db

import (
    "database/sql"
    "fmt"
    "log"
    "os"
    _ "github.com/lib/pq"
)

func ConnectDB() *sql.DB {
    user := os.Getenv("POSTGRES_USER")
    pass := os.Getenv("POSTGRES_PASS")
    dbname := os.Getenv("POSTGRES_DB")
    
    connStr := fmt.Sprintf("user=%s password=%s dbname=%s sslmode=disable", user, pass, dbname)
    db, err := sql.Open("postgres", connStr)
    if err != nil {
        log.Fatal(err)
    }
    
    err = db.Ping()
    if err != nil {
        log.Fatal(err)
    }
    
    stmt := \`CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL
    )\`
    _, err = db.Exec(stmt)
    if err != nil {
        log.Fatal(err)
    }
    
    log.Println("Connected to PostgreSQL!")
    return db
}
EOL
fi

# ===== FINISH =====
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${GREEN}✓${NC}  ${YELLOW}Project created successfully!${NC}"
echo ""
echo -e "  ${CYAN}Project:${NC}    ${MAGENTA}$PROJNAME${NC}"
echo -e "  ${CYAN}Framework:${NC}  ${BLUE}$FRAMEWORK${NC}"
echo -e "  ${CYAN}Database:${NC}   ${BLUE}$DB${NC}"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${YELLOW}Quick Start:${NC}"
echo ""
echo -e "    ${CYAN}\$${NC} cd $PROJNAME"
echo -e "    ${CYAN}\$${NC} go run main.go"
echo ""
echo -e "  ${CYAN}Server:${NC} ${MAGENTA}http://localhost:8080${NC}"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
