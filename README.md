# 🏆 Sports League Analysis

A relational database project built with **MySQL / PostgreSQL** to manage and analyze sports league data — including teams, players, games, and performance statistics. The project covers table creation, data insertion, joins, views, triggers, aggregations, and data manipulation.

---

## 📁 Project Files

| File | Description |
|------|-------------|
| `Insert_data.sql` | Creates all 4 tables and inserts 20 sample records into each |
| `solution_sports_league_analysis.sql` | 15 SQL queries solving real analytical problems |

---

## 🗃️ Database Schema

### `Teams`
| Column | Type | Description |
|--------|------|-------------|
| team_id | INT (PK) | Unique team identifier |
| team_name | VARCHAR(100) | Name of the team |

### `Players`
| Column | Type | Description |
|--------|------|-------------|
| player_id | INT (PK) | Unique player identifier |
| player_name | VARCHAR(100) | Player's full name |
| team_id | INT (FK → Teams) | Team the player belongs to |

### `Games`
| Column | Type | Description |
|--------|------|-------------|
| game_id | INT (PK) | Unique game identifier |
| team1_id | INT (FK → Teams) | First competing team |
| team2_id | INT (FK → Teams) | Second competing team |
| score_team1 | INT | Score of team 1 |
| score_team2 | INT | Score of team 2 |
| game_date | DATE | Date the game was played |

### `PlayerStats`
| Column | Type | Description |
|--------|------|-------------|
| stat_id | INT (PK) | Unique stat record |
| player_id | INT (FK → Players) | Player reference |
| game_id | INT (FK → Games) | Game reference |
| points | INT | Points scored |
| assists | INT | Assists made |
| rebounds | INT | Rebounds made |

---

## 🔗 Entity Relationships

```
Teams ──< Players
Teams ──< Games (as team1 and team2)
Players ──< PlayerStats
Games   ──< PlayerStats
```

---

## 📊 Sample Data

- **20 Teams** — Red Dragons, Blue Tigers, Gold Hawks, Crimson Hawks...
- **20 Players** — John Doe, Jane Smith, Maria Martinez, Tom Hardy...
- **20 Games** — Played between November 10–29, 2024
- **20 Player Stats** — Points, assists, and rebounds per game

---

## 📝 Queries Covered (`solution_sports_league_analysis.sql`)

| # | Query | Concepts Used |
|---|-------|---------------|
| 1 | Total points scored by each player | `SUM`, `GROUP BY` |
| 2 | Players who scored between 3 and 6 points | `JOIN`, `BETWEEN` |
| 3 | Players and their teams | `JOIN` |
| 4 | Games played in the last 30 days | `CURDATE()`, `INTERVAL` |
| 5 | View summarizing player statistics | `CREATE VIEW`, `SUM`, `JOIN` |
| 6 | Trigger to prevent negative points | `BEFORE INSERT/UPDATE`, `SIGNAL` |
| 7 | All players including those without a team | `LEFT JOIN` |
| 8 | Total points grouped by team | `JOIN`, `SUM`, `GROUP BY` |
| 9 | Players who scored more than 5 points | `JOIN`, `WHERE` |
| 10 | Update Sarah Moore's team to Green Sharks | `UPDATE` |
| 11 | Delete all records for game ID 5 | `DELETE` (child before parent) |
| 12 | Players who scored above average in a game | `AVG`, subquery logic |
| 13 | Top 3 highest scoring players | `SUM`, `ORDER BY DESC`, `LIMIT` |
| 14 | Teams that won at least one game | `CASE`, `DISTINCT`, `JOIN` |
| 15 | Average rebounds per player per team | `AVG`, `GROUP BY`, `ORDER BY DESC` |

---

## 🚀 How to Run

1. Open **pgAdmin** or **MySQL Workbench**
2. Create a new database (e.g., `sports_league`)
3. Run `Insert_data.sql` first — this creates and populates all tables
4. Run `solution_sports_league_analysis.sql` to execute the analysis queries

> ⚠️ **Note:** Queries 4 and 6 use MySQL syntax (`CURDATE()`, `DELIMITER`, `INTERVAL`). If using PostgreSQL, replace `CURDATE()` with `CURRENT_DATE` and adapt trigger syntax accordingly.

---

## 🛠️ Tools Used

- **MySQL / PostgreSQL** — Relational database
- **pgAdmin / MySQL Workbench** — Database GUI
- **SQL** — DDL, DML, Views, Triggers, Joins, Aggregations

---

## 💡 Key Concepts Demonstrated

- Table design with **Primary Keys** and **Foreign Keys**
- **INNER JOIN**, **LEFT JOIN** across multiple tables
- **Aggregate functions** — `SUM()`, `AVG()`
- **Views** for reusable query logic
- **Triggers** for data integrity enforcement
- **UPDATE** and **DELETE** with foreign key ordering
- **CASE** expressions inside JOIN conditions

---

## 👤 Author

Built as part of a SQL learning project to practice real-world database design and query writing.
