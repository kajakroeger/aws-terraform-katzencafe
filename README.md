# 🐈Katzencafé SamtpfotenLounge – Cloud-Hosting-Projekt

Das Projekt entstand im Rahmen eines Studiums zum Thema Cloud Programming. Ziel war es eine Anwendung in der Cloud zu hosten. 

Dabei entstand das fiktive Katzencafé SamtpfotenLounge. 
Anforderungen an die Cloud-Infrastruktur:
    •	Hochverfügbarkeit: Die Website soll immer verfügbar und global aufrufbar sein. 
    •	Minimale Ladezeiten: Die Besuchenden sollen keine Verzögerungen erfahren
    •	Skalierbarkeit: Das Backend soll automatisch skalieren, wenn mehrere Besuchende die Webseite nutzen.
    •	Kosteneffizient: Die Kosten für den Betrieb sollen möglichst gering sein.
    •	Sicherheit: Sensible Daten sollen geschützt und Zugriffsrechte ermöglichen.
    •	DSGVO-Konformität: Die Verarbeitung personenbezogener Daten soll rechtliche Vorgaben zum Datenschutz eingehalten. 


## Überblick der Infrastruktur
Cloud-Anbieter: Amazon Web Services (AWS)
Frontend: React & Tailwind CSS, gehostet über Amazon S3 & CloudFront
Backend: AWS Lambda & API Gateway (serverlos)
Datenbank: RDS PostgreSQL
Sicherheit: Secrets Manager, VPC, Sicherheitsgruppen, IAM-Rollen, HTTPS
Konfiguration: Infrastructure-as-Code mit Terraform
CI/CD: GitHub Actions 


## Voraussetzungen:
    •   AWS Account mit Admin-Rechten
    •   Terraform >= 1.2.0
    •   AWS CLI zum Hochladen des Frontends
    •   DBeaver für Entwicklungen an der Datenbank


## Projektstruktur:
    •   `.github/workflows` - Automatisierung des Deployments
    •   `backend/` – Python Lambda-Funktion 
    •   `infrastructure/` - Terraform-Code zur Konfiguration der AWS-Infrastruktur
    •   `webapp` - Frontend mit React & Tailwind


## Einrichtung der Cloud-Infrastruktur
Vorbereitung der Entwicklungsumgebung
    •   Terraform installieren
    •   AWS CLI installieren

Datenbank-Passwort erstellen
    •   im AWS Secrets Manager der AWS Console ein neues Secret erstellen
    •   "Other type of secret"
    •   Secret mit Namen secrets-rds speichern => über die Datei secrets_data.tf wird das Passwort sicher aus Secrets Manager abgerufen

Infrastruktur bereitstellen
    •   cd infrastructure
    •   terraform init
    •   terraform plan
    •   terraform apply

Frontend in S3-Bucket hochladen
    •   cd ../webapp
    •   npm install
    •   npm run build
    •   aws s3 sync ./dist s3://samtpfoten-lounge


## automatisierter Deployment-Prozess mit GitHub Actions bei push auf main-Branch
Vorbereitung:
Damit das Passwort zu AWS sicher abgerufen werden kann, ohne es im Klartext im Code zu speichern:
    •   GitHub Secrets mit AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY anlegen, s. AWS Secrets Manager. 

terraform.yml:
Änderungen im Ordner /infrastructure werden automatisch erkannt und folgende Schritte ausgeführt:
    •   Ubuntu-Umgebung bereitstellen zum Ausführen der Befehle
    •   Repository auf virtuelle Maschine klonen
    •   Lambda-Code zippen
    •   terraform plan  
    •   terraform apply lokal ausführen
    •   Optional: terraform apply, um Änderungen der Cloud-Infrastruktur auszuführen. Wenn erwünscht, in der Datei terraform.yml entkommentieren

upload-webapp.yml
Änderungen im Ordner /webapp werden automatisch erkannt und folgende Schritte ausgeführt:
    •   npm install
    •   npm run build
    •   webapp/dist mit dem Actions-Plugin jakejarvis/s3-sync-action in den S3-Bucket hochladen

## lokale Arbeiten an der Datenbank
    •   DBeaver installieren
    •   in der security.tf den Code für lokale Arbeiten an der Datenbank entkommentieren und deine IP-Adresse einfügen
    •   in der network.tf die Route Tabelle für Public Zugriff entkommentieren, damit es Daten aus dem Internet empfangen kann. Durch die Sicherheitsgruppe db_sg erlaubt die Datenbank Zugriff aus dem Internet nur von deiner IP-Adresse.
    •   in DBeaver neue Verbindung erstellen (PostgreSQL)
    •   Einstellung der Verbindung:
        Host: Der Endpoint deiner RDS-Datenbank. Du findest ihn in der AWS Console > RDS > katzencafe-db > Konnektivität & Sicherheit, z.B. katzencafe-db.abc123xyz.eu-central-1.rds.amazonaws.com
        Port: 5432
        Datenbankname: katzencafedb
        Benutzername: masteruser
        Passwort: Dein Passwort aus dem Secrets Manager
    •   Arbeiten an  der Datenbank ausführen
    •   Code-Abschnitte in security.tf & network.tf wieder auskommentieren
