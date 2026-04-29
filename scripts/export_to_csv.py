from pathlib import Path
import csv
import sqlite3


DB_PATH = Path("grocery_store_team6_2025.db")
OUTPUT_DIR = Path("data/raw")
TABLES = ("items", "sales")


def export_table(cursor, table_name, output_file):
    cursor.execute(f"SELECT * FROM {table_name}")
    rows = cursor.fetchall()

    output_file.parent.mkdir(parents=True, exist_ok=True)
    with output_file.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerows(rows)

    print(f"Exported {table_name} to {output_file}")


def main():
    with sqlite3.connect(DB_PATH) as conn:
        cursor = conn.cursor()
        for table_name in TABLES:
            export_table(cursor, table_name, OUTPUT_DIR / f"{table_name}.csv")


if __name__ == "__main__":
    main()
