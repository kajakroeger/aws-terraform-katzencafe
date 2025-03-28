import json
from database.db import get_db_connection

def lambda_handler(event, context):
    """Speichert eine Tischreservierung basierend auf verfügbarer Kapazität."""
    try:
        body = json.loads(event.get("body", "{}"))
        date = body.get("date")
        guests = body.get("guests")

        if not date or not guests:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Fehlende Reservierungsdaten (Datum oder Gästeanzahl)."})
            }

        conn = get_db_connection()
        cursor = conn.cursor()

        # Suche nach einem passenden freien Tisch
        cursor.execute("""
            SELECT id, table_number FROM tables
            WHERE max_capacity >= %s 
            AND id NOT IN (SELECT table_id FROM reservations WHERE DATE(reservation_time) = %s)
            ORDER BY max_capacity ASC
            LIMIT 1
        """, (guests, date))
        
        table = cursor.fetchone()

        if not table:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Kein passender Tisch verfügbar."})
            }

        table_id, table_number = table

        # Dummy-User-ID (z.B. 1) verwenden – in Produktion würdest du hier den angemeldeten User referenzieren
        user_id = 1

        # Reservierung speichern
        cursor.execute("""
            INSERT INTO reservations (user_id, table_id, reservation_time) 
            VALUES (%s, %s, %s)
        """, (user_id, table_id, date))

        conn.commit()
        cursor.close()
        conn.close()

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Reservierung erfolgreich gespeichert", 
                "table_id": table_id,
                "table_number": table_number
            })
        }
    
    except Exception as e:
        print(f"Fehler: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Interner Fehler", "details": str(e)})
        }
