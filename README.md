# DevOps Eksamen - AI Travel App 2024

## Oppgave 1: AWS Lambda og GitHub Actions - AI Bildegenerator

### Implementert Løsning
Lambda-funksjon integrert med AWS Bedrock for å generere reisebilder basert på tekstbeskrivelser.

### Implementasjonsdetaljer
- Kandidatnummer: 50
- Bildesti format: `s3://pgr301-couch-explorers/50/generated_images/titan_{seed}.png`

#### Hovedfunksjoner:
- POST-endepunkt som mottar bildebeskrivelser
- Genererer bilder via AWS Bedrock Titan AI
- Lagrer bilder i S3
- Returnerer bilde-URL i responsen

### API Informasjon
**Endepunkt:** `https://m952l2as4d.execute-api.eu-west-1.amazonaws.com/Prod/generate`

## Leveranseoversikt

### Oppgave 1a - AWS Lambda

### Testing via Postman
1. Opprett ny request i Postman:
   - Method: POST
   - URL: `https://m952l2as4d.execute-api.eu-west-1.amazonaws.com/Prod/generate`

2. Headers:
   - Key: `Content-Type`
   - Value: `application/json`

3. Body (raw JSON):
```json
{
    "prompt": "Norwegian fjord landscape with northern lights"
}
```

### Oppgave 1b - Github Actions Workflow

https://github.com/Sander-Drange/devops-exam-ai-travel-app/actions/runs/11843710491