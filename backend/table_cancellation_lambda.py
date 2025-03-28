import json
from database.db import get_db_connection

def lambda_handler(event, context):
    """Storniert eine Reservierung und gibt den Tisch wieder frei."""
    try:
        body = json.loads(event.get("body", "{}"))
        reservation_id = body.get("reservation_id")

        if not reservation_id:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Reservierungs-ID erforderlich."})
            }

        conn = get_db_connection()
        cursor = conn.cursor()

        # Holt die Tisch-ID der Reservierung, bevor sie gelöscht wird
        cursor.execute("SELECT table_id FROM reservations WHERE id = %s", (reservation_id,))
        table = cursor.fetchone()

        if not table:
            cursor.close()
            conn.close()
            return {
                "statusCode": 404,
                "body": json.dumps({"error": "Reservierung nicht gefunden."})
            }

        table_id = table[0]

        # Löscht die Reservierung
        cursor.execute("DELETE FROM reservations WHERE id = %s", (reservation_id,))
        conn.commit()

        # Holt die Tischnummer für die Antwort
        cursor.execute("SELECT table_number FROM tables WHERE id = %s", (table_id,))
        table_number = cursor.fetchone()[0]

        cursor.close()
        conn.close()

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Reservierung storniert",
                "freigegebener_tisch": table_number
            })
        }

    except Exception as e:
        print(f"Fehler: {e}")
        if conn:
            conn.rollback()
            conn.close()
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Interner Fehler", "details": str(e)})
        }
