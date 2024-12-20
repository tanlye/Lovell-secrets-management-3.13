
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./files/${var.lambda_file_name}.py"
  output_path = "./files/${var.lambda_file_name}.zip"
}

# Defines the lambda function to be created using file

resource "aws_lambda_function" "own_lambda" {
  function_name    = var.lambda_function_name
  handler          = "lovell-lambda.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.iam_for_lambda.arn
  filename         = data.archive_file.lambda.output_path         # Adjust the path
  source_code_hash = data.archive_file.lambda.output_base64sha256 # Adjust the path

}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# data "aws_iam_policy_document" "inline_policy_cloudwatch" {
#   statement {
#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:PutLogEvents",
#     ]
#     resources = ["arn:aws:logs:us-east-1:255945442255:log-group:/aws/lambda/${var.lambda_function_name}:*"]
#   }
# }

# resource "aws_iam_role" "iam_for_lambda" {
#   name               = "iam_for_lovell_lambda"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json

#   inline_policy {
#     name   = "policy-cloudwatch"
#     policy = data.aws_iam_policy_document.inline_policy_cloudwatch.json
#   }
# }


resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lovell_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "example_policy" {
  name = "iam_for_lovell_lambda"
  role = aws_iam_role.iam_for_lambda.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "logs:*",
        "Resource" : "*"
      }
    ]
  })
}