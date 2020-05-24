
//TODO: need to import this
data "aws_iam_role" "codepipeline_service_role" {
  name = "AWSCodePipelineServiceRole-us-east-2-artspot-web"
}

//TODO: need to add policy role attachment here