# DevOps Eksamen - AI Travel App 2024

## Oppgave 1: AWS Lambda og GitHub Actions - AI Bildegenerator

### Implementert Løsning
Lambda-funksjon integrert med AWS Bedrock for å generere reisebilder basert på tekstbeskrivelser.

#### Hovedfunksjoner:
- POST-endepunkt som mottar bildebeskrivelser
- Genererer bilder via AWS Bedrock Titan AI
- Lagrer bilder i S3
- Returnerer bilde-URL i responsen

### API Informasjon
**Endepunkt:** `https://m952l2as4d.execute-api.eu-west-1.amazonaws.com/Prod/generate`

### Test Kommandoer du kan kjøre

1. **Paris Scene**
```bash
curl -X POST \
  https://m952l2as4d.execute-api.eu-west-1.amazonaws.com/Prod/generate \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Show me sitting at a classic Parisian café with the Eiffel Tower in the background, a coffee and croissant on the table. The image should have an old polaroid filter, with soft faded tones and a sunbeam lightly hitting the Eiffel Tower."
  }'
```

2. **Safari Opplevelse**
```bash
curl -X POST \
  https://m952l2as4d.execute-api.eu-west-1.amazonaws.com/Prod/generate \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Place me in a jeep on an African savanna with lions and elephants in the background under a golden sunset. Use an analog 1980s photo effect with warm color tones, and give it a grainy texture for an authentic safari experience."
  }'
```

3. **Norsk Fjordlandskap**
```bash
curl -X POST \
  https://m952l2as4d.execute-api.eu-west-1.amazonaws.com/Prod/generate \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "en solnedgang over fjorden med fjell i bakgrunnen"
  }'
```

### Teknisk Implementasjon
- **Runtime:** Python 3.8
- **AWS Tjenester:**
  - AWS Lambda
  - API Gateway
  - AWS Bedrock (Titan model)
  - S3 for bildelagring
- **Region:** eu-west-1

### Oppsett og Deployment
1. **SAM Initialisering og Bygging:**
```bash
sam init
sam build
sam deploy --guided
```

2. **Deployment Konfigurasjoner:**
- Stack Name: image-generator-stack
- Region: eu-west-1
- S3 Bucket: pgr301-couch-explorers

### Sikkerhet
- IAM roller konfigurert for minste nødvendige tilgang
- S3 bucket med sikker lagring
- API Gateway uten autentisering (som spesifisert)

### Leveranse Oppsummering
- [x] SAM/Lambda implementert
- [x] API Gateway konfigurert
- [x] Bedrock integrasjon fungerende
- [x] S3 lagring implementert
- [x] Dokumentasjon fullført