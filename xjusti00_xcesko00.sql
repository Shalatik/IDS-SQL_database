BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SpolujazdecJ CASCADE CONSTRAINTS PURGE';
    EXECUTE IMMEDIATE 'DROP TABLE SpolujazdecV CASCADE CONSTRAINTS PURGE';
    EXECUTE IMMEDIATE 'DROP TABLE Zastavka CASCADE CONSTRAINTS PURGE';
    EXECUTE IMMEDIATE 'DROP TABLE Recenzia CASCADE CONSTRAINTS PURGE';
    EXECUTE IMMEDIATE 'DROP TABLE VlogClanok CASCADE CONSTRAINTS PURGE';
    EXECUTE IMMEDIATE 'DROP TABLE Spolujazdec CASCADE CONSTRAINTS PURGE';
    EXECUTE IMMEDIATE 'DROP TABLE Vylet CASCADE CONSTRAINTS PURGE';
    EXECUTE IMMEDIATE 'DROP TABLE Jazda CASCADE CONSTRAINTS PURGE';
    EXECUTE IMMEDIATE 'DROP TABLE Auto CASCADE CONSTRAINTS PURGE';
    EXECUTE IMMEDIATE 'DROP TABLE Vodic CASCADE CONSTRAINTS PURGE';

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;

create table Vodic
(
    ID            NUMBER GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    rodne_cislo   NUMBER(9)                    NOT NULL,
    meno          VARCHAR2(50)                 NOT NULL,
    priezvisko    VARCHAR2(100)                NOT NULL,
    tel_kontakt   NUMBER(9),
    email         VARCHAR2(100) CHECK(REGEXP_LIKE(
			email, '(^[a-zA-Z.]+[a-zA-Z0-9.]*@[a-zA-Z0-9-]+.[a-zA-Z]{2,})$'
		)),
    IBAN          VARCHAR2(34),
    profil_foto   BLOB,
    heslo         VARCHAR2(20)                 NOT NULL,
    OP_foto       BLOB,
    VK_foto       BLOB,
    zakladne_info VARCHAR2(1000),
    overenost     SMALLINT DEFAULT 0 NOT NULL CHECK(REGEXP_LIKE(
			overenost, '(^[01])$'
		))
);

create table Auto
(
    ID           NUMBER GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    VIN          VARCHAR2(17)                   NOT NULL,
    znacka        VARCHAR2(100)                NOT NULL,
    model        VARCHAR2(100)                NOT NULL,
    pocet_mist   NUMBER(2)                    NOT NULL,
    foto         BLOB,
    zviera       SMALLINT DEFAULT 0 NOT NULL CHECK(REGEXP_LIKE(
			zviera, '(^[01])$'
		)),
    fajcenie     SMALLINT DEFAULT 0 NOT NULL CHECK(REGEXP_LIKE(
			fajcenie, '(^[01])$'
		)),
    hudba        SMALLINT DEFAULT 0 NOT NULL CHECK(REGEXP_LIKE(
			hudba, '(^[01])$'
		)),
    rozmer_kufru NUMBER(5),
    vodic_ID         NUMBER DEFAULT NULL,
    CONSTRAINT vodic_ID_FK_Auto FOREIGN KEY (vodic_ID) REFERENCES Vodic (ID)
);

create table Jazda
(
    ID                            NUMBER GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    volne_miesta                    NUMBER(2)                    NOT NULL,
    info                          VARCHAR2(300)                NOT NULL,
    cena                          NUMBER(4)                    NOT NULL,
    trasa                         VARCHAR2(1000),
    zaciatok_cesty                VARCHAR2(100)                NOT NULL,
    ciel_cesty                    VARCHAR2(100)                NOT NULL,
    datum_cas_konani              DATE                         NOT NULL,
    datum_cas_odeslani_upozorneni DATE                         NOT NULL,
    obsah_upozorneni              VARCHAR2(100),
    auto_ID                       NUMBER DEFAULT NULL,
    CONSTRAINT auto_ID_FK_Jazda FOREIGN KEY (auto_ID) REFERENCES Auto (ID),
    vodic_ID         NUMBER DEFAULT NULL,
    CONSTRAINT vodic_ID_FK_Jazda FOREIGN KEY (vodic_ID) REFERENCES Vodic (ID)
);

create table Vylet
(
    ID               NUMBER GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    volne_miesta     NUMBER(2)                    NOT NULL,
    info             VARCHAR2(300),
    zaciatok_cesty   VARCHAR2(100)                NOT NULL,
    ciel_cesty       VARCHAR2(100)                NOT NULL,
    foto             BLOB,
    cena             NUMBER(2)                    NOT NULL,
    datum_konani     DATE                         NOT NULL,
    vodic_ID         NUMBER DEFAULT NULL,
    CONSTRAINT vodic_ID_FK_Vylet FOREIGN KEY (vodic_ID) REFERENCES Vodic (ID),
    auto_ID          NUMBER DEFAULT NULL,
    CONSTRAINT auto_ID_FK_Vylet FOREIGN KEY (auto_ID) REFERENCES Auto (ID)
);

create table Spolujazdec
(
    ID            NUMBER GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    rodne_cislo   NUMBER(9)                    NOT NULL,
    meno          VARCHAR2(50)                 NOT NULL,
    priezvisko    VARCHAR2(100)                NOT NULL,
    tel_kontakt   NUMBER(9),
    profil_foto   BLOB,
    heslo         VARCHAR2(20)                 NOT NULL,
    OP_foto       BLOB,
    zakladne_info VARCHAR2(1000),
    overenost     SMALLINT DEFAULT 0 NOT NULL CHECK(REGEXP_LIKE(
			overenost, '(^[01])$'
		))
);

create table VlogClanok
(
    ID                 NUMBER GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    obsah              VARCHAR2(1000)               NOT NULL,
    foto               BLOB,
    video              BLOB,
    datum_cas_pridania DATE                        DEFAULT SYSDATE NOT NULL,
    vylet_ID           NUMBER DEFAULT NULL,
    CONSTRAINT vylet_ID_FK_VlogClanok FOREIGN KEY (vylet_ID) REFERENCES Vylet (ID),
    spolujazdec_ID     NUMBER DEFAULT NULL,
    CONSTRAINT spolujazdec_ID_FK_VlogClanok FOREIGN KEY (spolujazdec_ID) REFERENCES Spolujazdec (ID),
    vodic_ID           NUMBER DEFAULT NULL,
    CONSTRAINT vodic_ID_FK_VlogClanok FOREIGN KEY (vodic_ID) REFERENCES Vodic (ID)
);


create table Recenzia
(
    ID             NUMBER GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    foto           BLOB,
    obsah          VARCHAR2(1000)               NOT NULL,
    hodnotenie     NUMBER(2)                    NOT NULL,
    jazda_ID       NUMBER DEFAULT NULL,
    datum_cas_pridania DATE                        DEFAULT SYSDATE NOT NULL,
    CONSTRAINT jazda_ID_FK_Recenzia FOREIGN KEY (jazda_ID) REFERENCES Jazda (ID),
    spolujazdec_ID NUMBER DEFAULT NULL,
    CONSTRAINT spolujazdec_ID_FK_Recenzia FOREIGN KEY (spolujazdec_ID) REFERENCES Spolujazdec (ID),
    vodic_ID       NUMBER DEFAULT NULL,
    CONSTRAINT vodic_ID_FK_Recenzia FOREIGN KEY (vodic_ID) REFERENCES Vodic (ID)
);

create table Zastavka
(
    zastavka VARCHAR2(50) NOT NULL,
    jazda_ID NUMBER DEFAULT NULL,
    CONSTRAINT jazda_ID_FK_Zastavka FOREIGN KEY (jazda_ID) REFERENCES Jazda (ID)
);

create table SpolujazdecV
(
    spolujazdec_ID_V NUMBER DEFAULT NULL,
    CONSTRAINT vylet_ID_FK_Spolujazdec FOREIGN KEY (spolujazdec_ID_V) REFERENCES Spolujazdec (ID),
    V_ID NUMBER DEFAULT NULL,
    CONSTRAINT vylet_ID_FK FOREIGN KEY (V_ID) REFERENCES Vylet (ID)
);

create table SpolujazdecJ
(
    spolujazdec_ID_J NUMBER DEFAULT NULL,
    CONSTRAINT jazda_ID_FK_Spolujazdec FOREIGN KEY (spolujazdec_ID_J) REFERENCES Spolujazdec (ID),
    J_ID NUMBER DEFAULT NULL,
    CONSTRAINT jazda_ID_FK FOREIGN KEY (J_ID) REFERENCES Jazda (ID)
);



INSERT INTO Vodic (rodne_cislo, meno, priezvisko, tel_kontakt, email, IBAN, heslo, overenost)
VALUES ('0008888888', 'Johatan', 'Bornett', '0901111555', 'm.random@google.co', 'ES2901286736796939357685', 'heslonaapp',1);
INSERT INTO Vodic (rodne_cislo, meno, priezvisko, tel_kontakt, email, IBAN, heslo, overenost)
VALUES ('000595874', 'Antonin', 'Bognar', '0901111488', 'm.helou@google.com', 'ES2901288836796939357685', 'heslo',0);

INSERT INTO Auto (VIN, znacka, model, pocet_mist, rozmer_kufru)
VALUES ('2C8GM68444R370097', 'Ford','F-150', '3', '800');
INSERT INTO Auto (VIN, znacka, model, pocet_mist, rozmer_kufru, vodic_ID)
VALUES ('1GYEE637570141640', 'Mercedes-Benz','Maybach GLE 400', '4', '500', 2);

INSERT INTO Jazda (volne_miesta, info, cena, trasa,zaciatok_cesty,ciel_cesty, datum_cas_konani, datum_cas_odeslani_upozorneni, obsah_upozorneni, auto_ID, vodic_ID)
VALUES ('2', 'kratke info o ceste lorem ipsum','150','opis trasy kadial sa pojde','Brno','Praha', TO_DATE('20-05-2022', 'dd/mm/yyyy'),
        TO_DATE('19-05-2022', 'dd/mm/yyyy'), 'zajtra mate jazdu', 1, 1);

INSERT INTO Vylet (volne_miesta, info, zaciatok_cesty, ciel_cesty, cena, datum_konani,vodic_ID,auto_ID)
VALUES (4,'info ohladom vyletu','Praha','Dukla',50, TO_DATE('20-05-2022', 'dd/mm/yyyy'),1,2);

INSERT INTO Vylet (volne_miesta, info, zaciatok_cesty, ciel_cesty, cena, datum_konani, vodic_ID, auto_ID)
VALUES (3, 'Pojedeme po silnici', 'Pred domem', 'Semilasso', 10, TO_DATE('20-05-2022', 'dd/mm/yyyy'), 1, 2);

INSERT INTO Spolujazdec (rodne_cislo, meno, priezvisko, tel_kontakt, heslo, zakladne_info)
VALUES ('0009998888', 'Jozko', 'Fekete', '555888444', 'jozinzbazin','ahoj som jozko');

INSERT INTO VlogClanok (obsah, vylet_ID ,spolujazdec_ID,vodic_ID)
VALUES ('Jeli jsme dlouho', 1,1,1);

INSERT INTO Recenzia (obsah, hodnotenie,jazda_ID ,spolujazdec_ID,vodic_ID)
VALUES ('Vylet byl fajn', 8, 1, 1, 1);

INSERT INTO Zastavka (zastavka, jazda_ID)
VALUES ('Piestany', 1);
INSERT INTO Zastavka (zastavka, jazda_ID)
VALUES ('Ruzomberok', 1);
INSERT INTO Zastavka (zastavka, jazda_ID)
VALUES ('Kolejni', 1);

INSERT INTO SpolujazdecV (spolujazdec_ID_V, V_ID)
VALUES (1, 2);

INSERT INTO SpolujazdecJ (spolujazdec_ID_J, J_ID)
VALUES (1, 1);
