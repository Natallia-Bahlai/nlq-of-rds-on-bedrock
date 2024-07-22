# Natural Language Queries of Relational Databases with Amazon Bedrock Agents
## Key components
![Quick Start Solution Diagram](https://github.com/Natallia-Bahlai/nlq-of-rds-on-bedrock/blob/main/NLQ%20with%20RDS%20using%20Bedrock%20Agents.drawio.png?raw=true)

## Deployment steps:
### Step 1: Deploy the Main NLQ Stack: Sample Aurora PostgreSQL and Lambda Function
```sh
aws cloudformation create-stack \
  --stack-name NlqMainStack \
  --template-body file://NlqMainStack.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters ParameterKey="MyIpAddress",ParameterValue=$(curl -s http://checkip.amazonaws.com/)/32
```
### Step 2: Prepare RDS schema and tables
1. Login to Aurora PostgreSQL
2. Run DDL statements to vector database. More details here https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraPostgreSQL.VectorDB.html
```sh
CREATE EXTENSION IF NOT EXISTS vector;
CREATE SCHEMA bedrock_integration;
CREATE TABLE bedrock_integration.bedrock_kb (id uuid PRIMARY KEY, embedding vector(1536), chunks text, metadata json);
CREATE INDEX on bedrock_integration.bedrock_kb USING hnsw (embedding vector_cosine_ops);
SELECT extversion FROM pg_extension WHERE extname='vector';
```
3. Insert sample data about Netflix shows
```sh
psql -d "postgres://username:pasword@clusterendpoint/postgres" -f netflix.sql
```
4. Upload file `netflix_ddl.sql` and `netflix_sql.sql` to S3 bucket which can be found in the NlqMainStack CloudFormation output

### Step 3: Deploy the Bedrock NLQ Stack: Agent and Knowledge Base
```sh
aws cloudformation create-stack \
  --stack-name NlqBedrockStack \
  --template-body file://NlqBedrockStack.yaml \
  --capabilities CAPABILITY_NAMED_IAM
```

## Perform NLQ
1. Login into AWS Management Console → Bedrock → Builder Tools → Agents
2. Select agent with name `nlq-agent`
3. Click Test and type any of the following queries:
```
How many shows are on Netflix?
What are the popular genres in 2021?
What are the top 5 countries with the maximum shows?
Count shows by genre 
```
