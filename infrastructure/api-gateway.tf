/*
Erstellt ein REST API Gateway, um HTTP-Anfragen von der Webseite an Lambda-Funktionen weiterzuleiten
 - Pfad /reservierung erlaubt POST- und OPTIONS-Anfragen
 - Lambda wird über AWS Proxy integriert
 - Definiert CORS für Kommunikation mit Frontend
 - Deployment wird in Stage "prod" ausgeführt
*/

# Erstellt REST API als Schnittstelle zwischen Lambda und Webseite
resource "aws_api_gateway_rest_api" "api" {
  name        = "katzencafe-api"
  description = "API für Bestellungen & Reservierungen"
}

# Fügt Endpunkt '/reservierung' zur API hinzu 
resource "aws_api_gateway_resource" "reservierung" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "reservierung"
}

# Erlaubt POST-Anfragen auf '/reservierung', um Reservierungen von der Webseite aufzunehmen
resource "aws_api_gateway_method" "post_reservierung" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.reservierung.id
  http_method   = "POST"
  authorization = "NONE"
}

# Verbindet POST-Anfragen von /reservierung mit Lambda-Funktion 
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.reservierung.id
  http_method             = aws_api_gateway_method.post_reservierung.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.backend.invoke_arn
}

# Erlaubt API Gateway, Lambda zu triggern und die Funktion für Reservierungen aufzurufen
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backend.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Fügt eine OPTIONS-Methode für CORS hinzu (wichtig für Browser-Kommunikation)
resource "aws_api_gateway_method" "options_reservierung" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.reservierung.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# Antwortet auf OPTIONS-Anfragen mit CORS-Headern
resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.reservierung.id
  http_method             = aws_api_gateway_method.options_reservierung.http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Definiert einen ewarteten Header für POST-Anfragen. 
# Gibt API Gateway an, dass der Header 'Access-Control-Allow-Origin' im Response sein wird
resource "aws_api_gateway_method_response" "cors_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.reservierung.id
  http_method = aws_api_gateway_method.post_reservierung.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = [aws_api_gateway_integration.lambda_integration]
}


# Fügt den tatsächlichen CORS-Header in die Antwort ein, sobald Lambda antwortet
resource "aws_api_gateway_integration_response" "cors_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.reservierung.id
  http_method = aws_api_gateway_method.post_reservierung.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [aws_api_gateway_integration.lambda_integration]
}

# Antwort-Header für OPTIONS-Anfrage
resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.reservierung.id
  http_method = aws_api_gateway_method.options_reservierung.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }

  depends_on = [aws_api_gateway_method.options_reservierung]
}

# Fügt Access-Control-Header zur OPTIONS-Antwort hinzu 
# Definiert welche Ursprünge, Methoden, Header erlaubt sind
resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.reservierung.id
  http_method = aws_api_gateway_method.options_reservierung.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_integration.options_integration]
}

# Erstellt API Deployment 
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.options_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  description = "Deployment der API für Reservierungen"
}

# Definiert Stage und ermöglicht verschiedene Umgebungen wie "dev", "test", "prod"
resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  description   = "Produktions-Stage für API Gateway"
}
