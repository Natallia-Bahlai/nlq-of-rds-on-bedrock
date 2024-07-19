## Natural Language Queries of Relational Databases with Amazon Bedrock Agents

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
psql -d "postgres://username:pasword@clusterendpoint/netflix" -f netflix.sql
```
4. Upload file to S3 bucket

### Step 3: Deploy the Bedrock NLQ Stack: Agent and Knowledge Base
```sh
aws cloudformation create-stack \
  --stack-name NlqMainStack \
  --template-body file://NlqBedrockStack.yaml \
  --capabilities CAPABILITY_NAMED_IAM
```

