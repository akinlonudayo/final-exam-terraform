provider "aws" {
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::409263326615:role/terrraform-executionrole"
    session_name = "terraform"
  }
}