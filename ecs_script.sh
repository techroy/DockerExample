sed -i "s#CONTAINER_NAME#$SERVICE_NAME#g" task-definition.json
sed -i "s#REPOSITORY_URI#$REPOSITORY_URI#g" task-definition.json
sed -i "s#BUILD_NUMBER#$IMAGE_TAG#g" task-definition.json
sed -i "s#TASK_DEF_LOG_GROUP_NAME#$TASK_DEFINITION_NAME#g" task-definition.json
sed -i "s#REGION_NAME#$AWS_DEFAULT_REGION#g" task-definition.json
sed -i "s#FAMILY_NAME#$TASK_DEFINITION_NAME#g" task-definition.json

cat task-definition.json
echo "sed is done"
aws ecs register-task-definition --cli-input-json file://task-definition.json --region="${AWS_DEFAULT_REGION}"

echo "ecs register works"

#Get latest revision
REVISION=`aws ecs describe-task-definition --task-definition "${TASK_DEFINITION_NAME}" --region "${AWS_DEFAULT_REGION}" | jq .taskDefinition.revision`
echo "REVISION= " "${REVISION}"

SERVICES=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER_NAME} --region ${AWS_DEFAULT_REGION} | jq .failures[]`

#Create or update service

if [ "$SERVICES" == "" ]; then
    echo "entered existing service"
    DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER_NAME} --region ${AWS_DEFAULT_REGION} | jq .services[].desiredCount`
    if [ ${DESIRED_COUNT} = "0" ]; then
        DESIRED_COUNT="1"
    fi
    aws ecs update-service --cluster "${CLUSTER_NAME}" --service "${SERVICE_NAME}" --task-definition "${TASK_DEFINITION_NAME}":"${REVISION}" --desired-count "${DESIRED_COUNT}"
else
    echo "entered new service"
    aws ecs create-service --service-name ${SERVICE_NAME} --desired-count "${DESIRED_COUNT}" --task-definition ${TASK_DEFINITION_NAME} --cluster ${CLUSTER_NAME} --region ${AWS_DEFAULT_REGION}    
fi    