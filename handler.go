package main

import (
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"log"
	"net/http"
	"os"
)

func HandleRequest(events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	log.Printf("Processing Lambda request")

	fooValue := os.Getenv("foo")
	if fooValue == "" {
		fooValue = "FernandoGo"
	}

	res := events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Headers:    map[string]string{"Content-Type": "text/plain; charset=utf-8"},
		Body:       fmt.Sprintf("Hello world! Foo value: %s", fooValue),
	}
	return res, nil
}

func main() {
	log.Printf("Start lambda")
	lambda.Start(HandleRequest)
}
