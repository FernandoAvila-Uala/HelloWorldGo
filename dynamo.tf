resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "Dynamo_FerAvila_TF"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "Username"

  /*attribute {
    name = "UserId"
    type = "S"
  }
  attribute {
    name = "Username"
    type = "S"
  }
  attribute {
    name = "FirstName"
    type = "S"
  }
  attribute {
    name = "LastName"
    type = "S"
  }
  attribute {
    name = "Age"
    type = "N"
  }*/

  dynamic "attribute" {
  for_each = {
    UserId    = "S",
    Username  = "S",
    FirstName = "S",
    LastName  = "S",
    Age       = "N"
  }

  content {
    name = attribute.key
    type = attribute.value
  }
}



  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "UsernameIndex"
    hash_key           = "Username"
    range_key          = "Age"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  global_secondary_index {
    name               = "FirstNameIndex"
    hash_key           = "FirstName"
    range_key          = "UserId"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "ALL"  # O elige la proyección adecuada según tus necesidades
  }

  global_secondary_index {
    name               = "LastNameIndex"
    hash_key           = "LastName"
    range_key          = "UserId"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "ALL"  # O elige la proyección adecuada según tus necesidades
  }

  tags = {
    Name        = "dynamodb-table-feravila-tf"
    Environment = "dev"
  }
}
