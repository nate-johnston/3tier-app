package main

import (
	"net/http"
	"flag"
	"strconv"
	"fmt"
	"database/sql"
	"runtime/debug"
	"encoding/json"
	_ "github.com/go-sql-driver/mysql"
)

var (
	port = flag.Int("p", 80, "http port")

	dbUsername = flag.String("db-username", "", "username db")
	dbPassword = flag.String("db-password", "", "password db")
	dbHost = flag.String("db-host", "", "host db")
	dbPort = flag.Int("db-port", 3306, "port db")
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

	panic(http.ListenAndServe(":" + strconv.Itoa(*port), http.HandlerFunc(ListUsers)))
}

func ListUsers(response http.ResponseWriter, request *http.Request) {
	print("adding header\n")
	response.Header().Add("Access-Control-Allow-Origin", "*")
	print("added header\n")
	result, err := conn.QueryContext(request.Context(), "SELECT * FROM users")
	if err != nil {
		writeErr(response, err)
		return
	}

	var out []map[string]interface{}

	for result.Next() {
		cols, err := result.Columns()
		if err != nil {
			writeErr(response, err)
			return
		}

		row := make([]interface{}, len(cols))

		{
			ptrs := make([]interface{}, len(row))
			for i := range row {
				ptrs[i] = &row[i]
			}

			if err = result.Scan(ptrs...); err != nil {
				writeErr(response, err)
				return
			}
		}

		rowNamed := make(map[string]interface{})
		for i, name := range cols {
			v := row[i]

			//try to convert []byte to string
			var data interface{}
			switch s := v.(type) {
			case []byte:
				data = string(s)
			default:
				data = s
			}

			// if it's a string, try to convert it to a number
			if s, ok := data.(string); ok {
				number, err := strconv.ParseInt(s, 10, 64)
				if err == nil {
					data = number
				}
			}

			rowNamed[name] = data
		}

		out = append(out, rowNamed)
	}

	if out == nil {
		out = make([]map[string]interface{}, 0)
	}

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

