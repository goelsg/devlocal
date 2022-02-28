#### Baisc Setup
export AWS_PROFILE root
export DOCKER_BUILDKIT=0

vault login s.xbK0FOvTiBoNacVp21DrhYuF 

### vault DB Roles

vault write database/roles/dev db_name=sms_ml_service creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT, UPDATE, INSERT, DELETE ON *.* TO '{{name}}'@'%';" default_ttl="5" max_ttl="5"

vault write database/config/sms_ml_service plugin_name=mysql-database-plugin connection_url="root:root@tcp(127.0.0.1:3306)/sms_ml_service" allowed_roles="dev" username="root" password="root"

vault write database/roles/dev db_name=fcCibil creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT, UPDATE, INSERT, DELETE ON *.* TO '{{name}}'@'%';" default_ttl="5" max_ttl="5"

vault write database/config/fcCibil plugin_name=mysql-database-plugin connection_url="root:root@tcp(127.0.0.1:3306)/fcCibil" allowed_roles="dev" username="root" password="root"

vault write database/roles/dev db_name=fc_attributes creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON *.* TO '{{name}}'@'%';" default_ttl="1m" max_ttl="1m"	

vault write database/config/fc_attributes plugin_name=mysql-database-plugin connection_url="root:root@tcp(127.0.0.1:3306)/fc_attributes" allowed_roles="dev" username="root" password="root"

vault read database/creds/dev 

### Aws Resources

aws sqs create-queue --queue-name sms-ml-queue --endpoint-url=http://localhost:4566 --profile root --region ap-south-1
 
aws sqs create-queue --queue-name sms-ml-hashcode-queue --endpoint-url=http://localhost:4566 --profile root --region ap-south-1

aws sns create-topic --name sns_local_dev --endpoint-url=http://localhost:4566 --profile root --output json --region ap-south-1
 
aws s3api create-bucket --bucket abc  --endpoint-url=http://localhost:4566 --profile root --region ap-south-1
 
aws s3api create-bucket --bucket fb-cibil-qa-s3 --region ap-south-east-1  --endpoint-url=http://localhost:4566 --profile root --region ap-south-1

aws s3api create-bucket --bucket dev-s3-bucket --region ap-south-1  --endpoint-url=http://localhost:4566 --profile root --region ap-south-1

aws s3api create-bucket --bucket sms-backlog --region ap-south-1  --endpoint-url=http://localhost:4566 --profile root --region ap-south-1

aws dynamodb create-table --cli-input-json file://C:\Users\shubham.goel\Documents\Notes\Sms_Transactional_Store.json --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb create-table --cli-input-json file://C:\Users\shubham.goel\Documents\Notes\1.json --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb create-table --cli-input-json file://C:\Users\shubham.goel\Documents\Notes\2.json --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb create-table --cli-input-json file://C:\Users\shubham.goel\Documents\Notes\3.json --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb create-table --cli-input-json file://C:\Users\shubham.goel\Documents\Notes\4.json --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb create-table --cli-input-json file://C:\Users\shubham.goel\Documents\Notes\5.json --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb create-table --cli-input-json file://C:\Users\shubham.goel\Documents\Notes\6.json --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb create-table --cli-input-json file://C:\Users\shubham.goel\Documents\Notes\8.json --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb update-table --table-name Sms_Transactional_Data --attribute-definitions AttributeName=hashcode,AttributeType=S --global-secondary-index-updates file://C:\Users\shubham.goel\Documents\Notes\index.json --endpoint-url=http://localhost:4566
 

aws dynamodb update-table --table-name Sms_Transactional_Data --attribute-definitions AttributeName=hashcode,AttributeType=S --global-secondary-index-updates file://C:\Users\shubham.goel\Documents\Notes\index1.json --endpoint-url=http://localhost:4566


#### Aws Permission iam users and role

aws iam create-user --user-name root --endpoint-url=http://localhost:4566 --profile root

aws iam list-attached-user-policies --user-name root --endpoint-url=http://localhost:4566 --profile root

aws sts get-caller-identity --endpoint-url=http://localhost:4566 --profile root

aws iam create-policy --policy-name role --policy-document file://C:\Users\shubham.goel\Documents\Notes\iamUser.json --endpoint-url=http://localhost:4566 --profile root

aws iam attach-user-policy --policy-arn arn:aws:iam::000000000000:policy/role --user-name root --endpoint-url=http://localhost:4566 --profile root
 
aws iam create-policy --policy-name roleN --policy-document file://C:\Users\shubham.goel\Documents\Notes\iamRole.json --endpoint-url=http://localhost:4566 --profile root

aws iam create-role --role-name Test-Role --assume-role-policy-document file://C:\Users\shubham.goel\Documents\Notes\roleTrustPolicy.json --endpoint-url=http://localhost:4566 --profile root

aws iam attach-role-policy --policy-arn arn:aws:iam::000000000000:policy/roleN --role-name Test-Role --endpoint-url=http://localhost:4566 --profile root

aws iam update-assume-role-policy --role-name Test-Role --policy-document file://C:\Users\shubham.goel\Documents\Notes\iamRole.json --endpoint-url=http://localhost:4566 --profile root


### Adding Data in Aws Resources

aws dynamodb put-item --table-name userpreferences_securedelement_dev --item file://C:\Users\shubham.goel\Documents\Notes\data1.json --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb put-item --table-name userpreferences_securedelement_dev --item file://C:\Users\shubham.goel\Documents\Notes\data2.json --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb put-item --table-name userpreferences_securedelement_dev --item file://C:\Users\shubham.goel\Documents\Notes\data3.json --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb put-item --table-name userpreferences_securityquestion_dev --item file://C:\Users\shubham.goel\Documents\Notes\data4.json  --endpoint-url=http://localhost:4566 --region ap-south-1

aws dynamodb put-item --table-name userpreferences_securityquestion_dev --item file://C:\Users\shubham.goel\Documents\Notes\data5.json  --endpoint-url=http://localhost:4566 --region ap-south-east-1

aws dynamodb scan --table-name Sms_Transactional_Data --endpoint-url=http://localhost:4566 

aws dynamodb scan --table-name userpreferences_securedelement_dev --endpoint-url=http://localhost:4566 

aws dynamodb scan --table-name userpreferences_securityquestion_dev --endpoint-url=http://localhost:4566 


aws sqs send-message --queue-url http://localhost:4566/000000000000/sms-ml-queue --message-body file://C:\Users\shubham.goel\Documents\Notes\message.json --delay-seconds 10 --message-attributes file://C:\Users\shubham.goel\Documents\message.json --endpoint-url=http://localhost:4566 --profile root


aws s3api put-object --bucket sms-backlog --key 200404e90e7d7d19b5f93bbe30caebc79a05a07c9c408df37724c8f6340e6ea6/2021/01/06/12/a.txt --body C:\Users\shubham.goel\Documents\Notes\smsInfoS3json.json --endpoint-url=http://localhost:4566 --profile root


### AWS Lambda

 
###aws lambda create-function --function-name "TestLambda" --runtime "java11" --role "arn:aws:iam::000000000000:role/Test-Role" --handler "com.freecharge.lambda.handler.SmsmlLambdaHandler" --timeout 5 --memory-size 512 --zip-file fileb://C:\Users\shubham.goel\IdeaProjects\Lambda\smsmllambda\target\smsml-lambda-0.0.1-SNAPSHOT-aws.jar --endpoint-url=http://localhost:4566 --profile root


###aws lambda update-function-configuration --function-name "TestLambda" --environment "Variables={spring.profiles.active=dev,vault_username=root,vault_password=root,FUNCTION_NAME=apply,SPRING_PROFILES_ACTIVE=dev}" --handler "com.freecharge.lambda.handler.SmsmlLambdaHandler" --profile root --endpoint-url=http://localhost:4566

###aws lambda update-function-code --function-name "TestLambda" --zip-file fileb://C:\Users\shubham.goel\IdeaProjects\Lambda\smsmllambda\target\smsml-lambda-0.0.1-SNAPSHOT-aws.jar  --profile root --endpoint-url=http://localhost:4566

###aws lambda invoke --function-name "TestLambda" response.json --log-type tail --profile root --endpoint-url=http://localhost:4566
 
###aws lambda update-function-configuration --function-name "TestLambda" --environment "Variables={spring.profiles.active=dev,vault_username=root,vault_password=root,FUNCTION_NAME=apply,SPRING_PROFILES_ACTIVE=dev}" --handler "com.freecharge.lambda.handler.SmsmlLambdaHandler" --profile root --endpoint-url=http://localhost:4566
 
###aws lambda invoke --function-name "TestLambda" response.json --log-type tail --profile root --endpoint-url=http://localhost:4566

###aws lambda invoke --function-name "TestLambda" --payload '{}' response.json --profile root --endpoint-url=http://localhost:4566

###aws lambda update-function-code --function-name "TestLambda" --zip-file fileb://C:\Users\shubham.goel\IdeaProjects\Lambda\smsmllambda\target\smsml-lambda-0.0.1-SNAPSHOT-aws.jar  --profile root --endpoint-url=http://localhost:4566
 