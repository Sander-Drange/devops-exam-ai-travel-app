# Leveranseoversikt - DevOps Eksamen 2024
Kandidatnummer: 50

## Oppgave 1
### HTTP Endepunkt (1A)
- `https://m952l2as4d.execute-api.eu-west-1.amazonaws.com/Prod/generate`
{ "prompt": "Norwegian mountain landscape with sunset" }

### GitHub Actions Workflow (1B)
- SAM Deploy: [Workflow Run](https://github.com/Sander-Drange/devops-exam-ai-travel-app/actions/runs/11843710491)

## Oppgave 2
### Terraform/SQS
- SQS URL: `https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-50`
- Main Branch Deploy: [Terraform Apply](https://github.com/Sander-Drange/devops-exam-ai-travel-app/actions/runs/11936335818)
- Feature Branch: [Terraform Plan](https://github.com/Sander-Drange/devops-exam-ai-travel-app/actions/runs/11914390470)

## Oppgave 3
### Docker
- Image: `sanderdrange/image-generator-client`
- Workflow: [Docker Publish](https://github.com/Sander-Drange/devops-exam-ai-travel-app/actions/runs/11936539593)
- Tag Strategi: Bruker `latest` tag for nyeste versjon og Git SHA for spesifikke versjoner. Dette gjør det enkelt for teamet å hente siste versjon, samtidig som vi kan rulle tilbake til spesifikke commits ved behov. Kombinasjonen av tags gir både fleksibilitet i daglig bruk og presis versjonskontroll for feilsøking.
- - Docker Run:
```bash
docker run -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy \
-e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-50 \
sanderdrange/image-generator-client "Me on top of K2"
```

## Oppgave 4
### CloudWatch Alarmer
- ApproximateAgeOfOldestMessage alarm implementert
- Lambda Duration p95 percentil måling konfigurert
- Varsling: Endre `alarm_email` i variables.tf for notifikasjoner

## Oppgave 5 
### Serverless vs. Mikrotjenester fra DevOps Perspektiv

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