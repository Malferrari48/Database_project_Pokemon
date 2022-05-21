Per poter utilizzare il nostro progetto è necessaria una installazione funzionante di PostgreSQL, e un database inizialmente vuoto.
Una volta creati si può usare un qualsiasi metodo (comando psql o pgAdmin) per inserire i comandi presenti all'interno della cartella SQL:
- 01_tabelle.sql crea le tabelle necessarie
- 02_trigger.sql aggiunge i trigger al database
- 03_data.sql inserisce i dati di prova

Nel file 04_interrogazioni.sql si possono trovare le query studiate nella relazione.
Il programma si può trovare nella cartella "Programma", è possibile eseguirlo da terminale o da qualsiasi IDE (ad esempio PyCharm), in quest'ultimo caso si deve aprire tutto il progetto e non solo il file "main.py".
Prima di avviarlo assicurarsi di avere installato il pacchetto "psycopg2-binary", per ulteriori informazioni consultare il README dedicato dentro alla cartella "Programma".

Il progetto è stato testato con le seguenti versioni:
- PostgreSQL 10.16
- PostgreSQL 13.3
- Python 3.6.7
- Python 3.9.6
- psycopg2-binary 2.9.1
Si è usato pgAdmin 4.30 per accedere al DBMS.
