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

#### 3A: Docker-image for Java SQS-klient

- **Container Image**: `sanderdrange/image-generator-client`
- **SQS URL**: "https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-50"

For å kjøre containeren og sende en melding til SQS-køen, bruk følgende kommando:

```
docker run -e AWS_ACCESS_KEY_ID=AKIATR3Y72NI2GBZ3TUX \
>   -e AWS_SECRET_ACCESS_KEY=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 \
>   -e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-50 \
>   image-generator-client "Me on top of K2"
```

Validering ble gjort ved å kjøre containeren og sende meldinger til SQS-køen. Jeg observerte CloudWatch-metrikker for å bekrefte at meldinger ble sendt, mottatt og slettet som forventet. I tillegg ble generert innhold lagret i S3, noe som bekrefter at prosessen fra melding til output fungerte som tiltenkt.

#### 3B: GitHub Actions for Docker Image Publisering
- **Workflow-fil:** [docker_publish.yml] lenke til action: https://github.com/Sander-Drange/devops-exam-ai-travel-app/actions/runs/11936539593
- **Beskrivelse av Taggestrategi:** 
  - Jeg har valgt å tagge Docker imaget med `latest` for den nyeste stabile versjonen, samt en Git SHA tag for å kunne referere til spesifikke commits. Dette gir en enkel måte å alltid hente den nyeste versjonen, samtidig som man kan spore og rulle tilbake til tidligere versjoner om nødvendig.

GitHub Actions workflowen bygger og publiserer Docker-imaget til Docker Hub hver gang det er en push til main-branchen. Dette sikrer at teamet alltid har tilgang til den nyeste versjonen av klienten.

#### 4A: CloudWatch Alarmer
- **SQS Queue Alarm:** Implementert CloudWatch alarm for ApproximateAgeOfOldestMessage
- **Konfigurasjon:** 
  - Terskel: 5 minutter
  - Evaluering: Hver 5. minutt
  - Alarm Action: SNS Topic med epost-varsling
- **Teststatus:** ✅ Alarm verifisert og testet

#### 4B: Metrics for Responstid
- **Lambda Duration Metrics:** Implementert p95 percentil måling
- **Histogram Konfigurasjon:**
  - Måler prosesseringstid for bildegenerering
  - Terskel: 10 sekunder
  - Rapporteringsintervall: 60 sekunder
- **Teststatus:** ✅ Metrics verifisert med test-meldinger

## Teknisk Implementasjon
- Python 3.8 runtime
- AWS Bedrock Titan AI for bildegenerering
- SQS for asynkron meldingshåndtering
- Terraform for infrastruktur
- GitHub Actions for CI/CD
- Terraform-basert infrastruktur for alarmer og metrics
- SNS Topic for varsling: `sqs-message-age-alarm-topic-50`
- CloudWatch Dashboard tilgjengelig for visualisering
