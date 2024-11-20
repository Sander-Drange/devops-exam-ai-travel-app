# DevOps Eksamen - AI Travel App 2024

## Kandidatnummer: 50

## Leveranseoversikt

### Oppgave 1 - AWS Lambda og GitHub Actions
#### 1A: Lambda/SAM Implementasjon
- **HTTP Endepunkt:** `https://m952l2as4d.execute-api.eu-west-1.amazonaws.com/Prod/generate`
- **S3 Bucket Path:** `s3://pgr301-couch-explorers/50/generated_images/`
- **SAM Template:** [template.yaml](sam_lambda/image-generator-lambda/template.yaml)

Test med Postman:
```json
POST https://m952l2as4d.execute-api.eu-west-1.amazonaws.com/Prod/generate
Content-Type: application/json

{
    "prompt": "Norwegian mountain landscape with sunset"
}
```
#### 1B: GitHub Actions for SAM
- **Workflow Status:** (https://github.com/Sander-Drange/devops-exam-ai-travel-app/actions/runs/11843710491)

### Oppgave 2 - Terraform og SQS
#### 2A: Infrastruktur som Kode
- **lambda_function_name:** "image-processor-50"
- **sqs_queue_url:**  "https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-50"

#### 2B: Terraform GitHub Actions
- **Main Branch Deploy:** [Terraform Apply Workflow](https://github.com/Sander-Drange/devops-exam-ai-travel-app/actions/runs/11913624026)
- **Feature Branch Plan:** [Terraform Plan Workflow](https://github.com/Sander-Drange/devops-exam-ai-travel-app/actions/runs/11914390470)

## Teknisk Implementasjon
- Python 3.8 runtime
- AWS Bedrock Titan AI for bildegenerering
- SQS for asynkron meldingshåndtering
- Terraform for infrastruktur
- GitHub Actions for CI/CD
