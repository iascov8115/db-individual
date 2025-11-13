Lucrare individuala "Livrari de marfuri"

## Proiectarea Bazei de Date

1. Analiza activitatii economice a organizatiei decentralizata din domeniului concret din lumea reala
2. Schema alocarii geografice a subdiviziunilor decentralizate
3. Proiectarea bazelor de date local pe fiecare nod
4. Planificarea fragmentelor obiectelor necesare

## Configurarea mediului distribuit

1. Creati cel putin doua instante PostgreSQL rulate in containere Docker (de exemplu db_master, db_slave1 si db_slave2)
2. Asigurativa ca instantele se pot vedeaa reciproc
3. Daca aveti un proiect Java/Maven integrati Flyway in pom.xml, alternativ rulati Flyway din CLI pentru aexecuta scripturile de migrare

## Scripturi de migrare

1. Creati user sub care var rula Flyway
2. Creati scripturi de creare a tabelelor in schema app.
3. Creati proceduri de inserare a dummy data in aceste tabele. Ca parametru aceste proceduri vor primi nr de records de inserat

## Fragmentarea Datelor

1. Impartiti un tabel mare in mai multe fragmente dupa un criteriu (regiune geografica, interval de date, tip client)

## Replicarea a bazei de date

1. Configurati replicarea dintre noduri.
2. Explicati de ce ati ales modelul de replicare respectiv si demonstrati ca este cel mai potrivit pentru domeniul dat

## Transactii distribuite

1. Demonstrati o transactie atomica care modifica doua noduri diferite de baze de date

## Data Warehouse si ETL

1. Creati o noua schema dwh pentru a inregistra istoricul datelor
2. In aceste tabele DWH se vor pastra cimpurile originale impreuna cu coloane de audit (valid_from, valid_to, is_active)
3. Creati o procedura ce va detecta modificarile in app schema si le va aplica in DWH
    * Identifica rindurile noi, modificate sau care au disparut
    * Insereaza rindurile noi si actualizate cu valid_from = CURRENT_TIMESTAMP, valid_to = NULL, is_active = true
    * Pentru rindurile existente in DWH unde valorile s-au schimbat fata de sursa – seteaza versiunea veche ca expirata valid_to = CURRENT_TIMESTAMP, is_active = false, apoi insereaza un nou record cu noile valori
    * Daca in DWH exista un record cu is_active = true si nu mai apare in APP, inseamna ca s-a sters si se seteaza valid_to = CURRENT_TIMESTAMP, is_active = false


