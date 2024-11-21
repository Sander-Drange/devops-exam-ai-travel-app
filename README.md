# DevOps Eksamen - AI Travel App 2024

## Kandidatnummer: 50

## Leveranseoversikt

### Oppgave 1 - AWS Lambda og GitHub Actions
#### 1A: Lambda/SAM Implementasjon
- **HTTP Endepunkt:** `https://m952l2as4d.execute-api.eu-west-1.amazonaws.com/Prod/generate`
- **S3 Bucket Path:** `s3://pgr301-couch-explorers/50/generated_images/`
- **SAM Template:** [template.yaml](sam_lambda/image-generator-lambda/template.yaml)

Test med Postman:
```
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
  - Terskel: 1 minutt
  - Evaluering: Hvert minutt
  - Alarm Action: SNS Topic med epost-varsling
- **Teststatus:** Alarm verifisert og testet

#### 4B: Metrics for Responstid
- **Lambda Duration Metrics:** Implementert p95 percentil måling
- **Histogram Konfigurasjon:**
  - Måler prosesseringstid for bildegenerering
  - Terskel: 10 sekunder
  - Rapporteringsintervall: 60 sekunder
- **Teststatus:** Metrics verifisert med test-meldinger

## Teknisk Implementasjon
- Python 3.8 runtime
- AWS Bedrock Titan AI for bildegenerering
- SQS for asynkron meldingshåndtering
- Terraform for infrastruktur
- GitHub Actions for CI/CD
- Terraform-basert infrastruktur for alarmer og metrics
- SNS Topic for varsling: `sqs-message-age-alarm-topic-50`
- CloudWatch Dashboard tilgjengelig for visualisering

#### 5 Serverless vs. Mikrotjenester fra DevOps Perspektiv

Automatisering og CI/CD

For automatisering og CI/CD er serverless enklere å håndtere siden AWS tar seg av mye av infrastrukturen. Dette gjør at CI/CD-prosessene kan fokusere mer på koden selv, uten å måtte tenke på serveroppsett. 
Deployments går raskere fordi man slipper å bygge containere, selv om testing kan bli litt mer utfordrende når man må emulere skytjenester lokalt. 
Mikrotjenester krever mer oppsett, men gir bedre kontroll over hele teknologistakken, enklere lokaltesting og muligheten til å lage mer komplekse deploy-pipelines.

Observability

Når det gjelder observability, har serverless en fordel ved at CloudWatch logger alt automatisk og at metrics er tilgjengelige direkte. 
Dette gjør det naturligvis lett å overvåke systemet, men det kan være vanskeligere å feilsøke problemer som går på tvers av flere funksjoner. 
Mikrotjenester gir full kontroll over logging og gjør det enklere å følge forespørsler gjennom hele systemet. Dette betyr dog at man må sette opp egen logging-infrastruktur og bruke mer tid på vedlikehold.

Skalerbarhet og Kostnader

Skalerbarhet og kostnader er også viktige punkter. Med serverless betaler man kun for det som brukes, og skaleringen skjer automatisk. 
Dette kan være kostnadseffektivt, men ved høy trafikk kan kostnadene bli høye, og cold starts kan oppstå ved lav trafikk. 
Mikrotjenester gir forutsigbare kostnader og ingen cold starts, men skaleringsprosessen må håndteres manuelt, og man betaler også selv når trafikken er lav. Noe som er drit når enn har vært i en periode der alle østlendingene skal på hytta i påsken og en må krympe seksveisfeltet ut av Oslo.

Eierskap og Ansvar

Når det gjelder eierskap og ansvar, flytter serverless mye av ansvaret til AWS. 
Dette betyr mindre servervedlikehold og mer fokus på forretningslogikk, men det gir mindre kontroll over ytelsen og skaper avhengighet av AWS-tjenester. 
En viktig ting er at serverless-arkitekturer ofte gir utviklere mer innsikt i koden og hvordan funksjonene fungerer, noe som kan forbedre forståelsen og kvaliteten på koden. 
Samtidig betyr det at utviklerne har større ansvar for å vedlikeholde og optimalisere koden selv, uten å kunne stole like mye på infrastrukturleverandøren. 
Dette øker ansvaret til systemutviklerne, da de må sørge for at koden er effektiv, skalerbar og feilfri, noe som kan være utfordrende uten samme grad av kontroll over infrastrukturen som ved mikrotjenester, men enn tjener på det med å få muligheten til å lære av uoptimalisert kode. 
Mikrotjenester gir full kontroll over teknologistakken og muligheten til å optimalisere alt, men dette kommer med økt ansvar for drift og krever mer DevOps-kompetanse.

Praktisk Erfaring fra Eksamen

Under eksamen ble det tydelig hvordan serverless fungerer i praksis. 
Ved bruk av AWS Lambda for bildegenerering kunne funksjoner enkelt settes opp for automatisk bildebehandling når bilder ble lastet opp. 
Dette eliminerte behovet for manuell serveradministrasjon og gjorde det mulig å skalere behandlingen dynamisk etter behov.

Amazon SQS ble brukt for meldingshåndtering, noe som sikret en pålitelig og skalerbar måte å håndtere asynkrone oppgaver på. 
Implementeringen av SQS gjorde det enkelt å koordinere mellom ulike tjenester og sikre at meldinger ble behandlet i riktig rekkefølge uten tap.

CloudWatch ble utnyttet for overvåkning og logging, noe som ga sanntidsinnsikt i systemets ytelse og helse. 
Det var spesielt nyttig for å identifisere og feilsøke problemer raskt. 
Feilsøking kan bli komplisert når flere funksjoner samhandler, og det krever en god forståelse av hvordan ulike komponenter kommuniserer med hverandre.

Totalt har eksamenspraksisen gitt en god forståelse av både styrkene og svakhetene ved serverless-arkitekturer. 
Den enkle oppsettprosessen og den automatiske skalerbarheten er klare fordeler, mens utfordringer som kompleks feilsøking viser at det fortsatt er områder som krever forbedring og nøye planlegging.