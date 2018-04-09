package main

import (
	"database/sql"
	"encoding/json"
	"flag"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"net/http"
	"runtime/debug"
	"strconv"
)

var (
	port = flag.Int("p", 80, "http port")

	dbUsername = flag.String("db-username", "", "username db")
	dbPassword = flag.String("db-password", "", "password db")
	dbHost     = flag.String("db-host", "", "host db")
	dbPort     = flag.Int("db-port", 3306, "port db")
	dbDatabase = flag.String("db-database", "", "database db")

	conn *sql.DB
)

func main() {
	print("starting\n")
	flag.Parse()

	dbAddr := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s", *dbUsername, *dbPassword, *dbHost, *dbPort, *dbDatabase)

	var err error
	conn, err = sql.Open("mysql", dbAddr)
	if err != nil {
		panic(err)
	}

	panic(http.ListenAndServe(":"+strconv.Itoa(*port), http.HandlerFunc(ListUsers)))

}

func ListUsers(response http.ResponseWriter, request *http.Request) {
	response.Header().Add("Access-Control-Allow-Origin", "*")
	result, err := conn.Query("SELECT * FROM users")
	if err != nil {
		writeErr(response, err)
		return
	}

	cols, err := result.Columns()
	if err != nil {
		writeErr(response, err)
		return
	}

	var out []map[string]interface{}

	for result.Next() {
		var row []interface{}
		if err = result.Scan(&row); err != nil {
			writeErr(response, err)
			return
		}

		rowNamed := make(map[string]interface{})
		for i, name := range cols {
			rowNamed[name] = row[i]
		}

		out = append(out, rowNamed)
		print("read row")
	}
	print("no row")

	response.Header().Add("Content-Type", "application/json")
	response.WriteHeader(200)
	if err = json.NewEncoder(response).Encode(out); err != nil {
		writeErr(response, err)
	}
}

func writeErr(response http.ResponseWriter, err error) {
	debug.PrintStack()
	response.Header().Add("Content-Type", "text/plain")
	response.WriteHeader(500)
	response.Write([]byte(err.Error()))
}
