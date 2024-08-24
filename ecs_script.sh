sed -i "s#CONTAINER_NAME#$SERVICE_NAME#g" task-definition.json
sed -i "s#BUILD_NUMBER#$IMAGE_TAG#g" task-definition.json
sed -i "s#TASK_DEF_LOG_GROUP_NAME#$TASK_DEFINITION_NAME#g" task-definition.json
sed -i "s#REGION_NAME#$AWS_DEFAULT_REGION#g" task-definition.json
sed -i "s#FAMILY_NAME#$TASK_DEFINITION_NAME#g" task-definition.json

cat task-definition.json
echo "sed is done"
aws ecs register-task-definition --cli-input-json file://task-definition.json --region="${AWS_DEFAULT_REGION}"

echo "ecs register works"
REVISION=`aws ecs describe-task-definition --task-definition "${TASK_DEFINITION_NAME}" --region "${AWS_DEFAULT_REGION}" | jq .taskDefinition.revision`
echo "REVISION= " "${REVISION}"
aws ecs update-service --cluster "${CLUSTER_NAME}" --service "${SERVICE_NAME}" --task-definition "${TASK_DEFINITION_NAME}":"${REVISION}" --desired-count "${DESIRED_COUNT}"