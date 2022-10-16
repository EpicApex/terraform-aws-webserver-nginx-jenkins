terraform {
  backend "s3" {
    bucket = "exercise-tf-state"
    key    = "terraform-eks/exercise-infra-eks/exercise-infra-eks.tf"
    region = "eu-west-1"
  }
}
