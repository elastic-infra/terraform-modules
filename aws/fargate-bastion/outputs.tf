output "command" {
  description = "Output execute command for start-session to ecs container"
  value       = <<EOT
#/bin/bash

set -eu

cluster_name="${local.cluster_name}"
task_definition="${aws_ecs_task_definition.bastion.family}"

task_arn=$(aws ecs run-task --cluster $cluster_name --task-definition $task_definition --overrides '{"containerOverrides": [{"name":"timer","command": ["/usr/bin/sleep","${var.timeout}"]}]}' --network-configuration '${local.network_configuration}' --enable-execute-command --launch-type FARGATE | jq -r .tasks[0].taskArn)

trap "aws ecs stop-task --cluster $cluster_name --task $task_arn > /dev/null" 2 15

echo "wait tasks-running: $${task_arn##*/}"

aws ecs wait tasks-running --cluster $cluster_name --tasks $task_arn

container_id=$(aws ecs describe-tasks --cluster $cluster_name --tasks $task_arn | jq -r '.tasks[0].containers[] | select(.name == "bastion").runtimeId')

aws ssm start-session --target ecs:$${cluster_name}_$${task_arn##*/}_$${container_id} --document-name AWS-StartPortForwardingSession --parameters '${local.document_parameters}' &

while : ; do
  status=$(aws ecs describe-tasks --cluster $cluster_name --tasks $task_arn --query tasks[0].lastStatus --output text)
  [ "$status" = "STOPPED" ] && break
  sleep 30
done
EOT
}
