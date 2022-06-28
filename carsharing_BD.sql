/*  		


				LAVORO ESEGUITO DAGLI STUDENTI: (Gruppo 24)
					Di Via Roberto 4486648
					Capani Paolo 4493248
					Gandolfo Riccardo 4338819
*/
/**********************************************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
****************************************************			CREAZIONE TABELLE			***************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************************************************/


CREATE schema carsharing;
set search_path to carsharing;
--set datestyle to 'DMY';

CREATE TABLE  Convenzione
	(
		tipoConvenzione VARCHAR(30),
		PRIMARY KEY (tipoConvenzione)
	);
 
CREATE TABLE  Parcheggio
	(
		latitudine NUMERIC(9,7) UNIQUE,
		longitudine NUMERIC(10,7) UNIQUE,
		nome VARCHAR(20) UNIQUE NOT NULL,
		zona VARCHAR(20)NOT NULL,
		numposti SMALLINT NOT NULL CHECK(numposti > 0),
		
		PRIMARY KEY (latitudine, longitudine)
	);

CREATE TABLE  Targhe
	(
		numTarga VARCHAR(7),
		PRIMARY KEY (numTarga)
	);


CREATE TABLE  Categoria
	(
		tipoCategoria VARCHAR(20),
		PRIMARY KEY (tipoCategoria),
		CHECK(tipoCategoria = 'City Car' OR tipoCategoria = 'Media' OR tipoCategoria = 'Comfort' OR tipoCategoria = 'Cargo' OR tipoCategoria = 'Elettrico')	
	);

CREATE TABLE  TipoAbbonamento
	(
		codiceTipoAbbonamento NUMERIC(20,0),
		costo NUMERIC(6,2) NOT NULL CHECK(costo > 0),
		durata NUMERIC(4,2) NOT NULL CHECK(durata > 0), --NUMERIC(mesi,giorni)
		PRIMARY KEY (codiceTipoAbbonamento)
	);


CREATE TABLE  Modello
	(
		idModello NUMERIC(3,0),
		nome VARCHAR(20) NOT NULL,
		produttore VARCHAR(20) NOT NULL,
		categoria VARCHAR(20) NOT NULL,
		lunghezza NUMERIC(5,2) NOT NULL CHECK (lunghezza > 0),
		larghezza NUMERIC(5,2) NOT NULL CHECK (larghezza > 0),
		altezza NUMERIC(5,2) NOT NULL CHECK (altezza > 0),
		capacitaBagagli NUMERIC(3) NOT NULL  CHECK (capacitaBagagli > 0),
		numPosti NUMERIC(1) NOT NULL CHECK (numPosti > 0),		-- Consideriamo con un limite di posti o può averne più di 5?
		numPorte NUMERIC(1) NOT NULL CHECK (numPorte > 0), 		-- Stesso commento sopra applicato qui
		CvKw NUMERIC(4) NOT NULL CHECK (CvKw > 0),
		cilindrata NUMERIC(5,1) NOT NULL CHECK (cilindrata > 0),
		consumoMedio NUMERIC(4,2) NOT NULL CHECK (consumoMedio > 0),
		velocitaMax NUMERIC(4) NOT NULL CHECK (velocitaMax > 0),
		ariaCond BOOLEAN NOT NULL  DEFAULT TRUE,
		servoSterzo BOOLEAN NOT NULL DEFAULT TRUE,
		airbag BOOLEAN NOT NULL DEFAULT TRUE,
		PRIMARY KEY (idModello)
	);
	


CREATE TABLE Tariffa
	(
		codiceTariffa VARCHAR(20),
		carburante BOOLEAN NOT NULL, --0 escluso 1 incluso
		--costo NUMERIC(5,2) NOT NULL,
		tariffaforfait NUMERIC(4,2),
		tariffaorario NUMERIC(4,2),
		tariffakm NUMERIC(4,2),
		tariffaaggiuntiva NUMERIC(4,2),
		tariffa7giorni NUMERIC(4,2),
		idModello NUMERIC(3,0) UNIQUE NOT NULL REFERENCES Modello(idModello)  ON DELETE CASCADE ON UPDATE CASCADE,
		
		PRIMARY KEY (codiceTariffa),
		--CHECK(costo >= 0),
		CHECK(tariffaforfait >=0),
		CHECK(tariffaorario > 0),
		CHECK(tariffakm > 0),
		CHECK(tariffa7giorni > 0),
		CHECK(tariffaaggiuntiva > 0)
	);

CREATE TABLE CartaCarburante   -- rif tipo abbonamento 
	(	pin NUMERIC(5,0),
		PRIMARY KEY (pin),
		codiceTipoAbbonamento NUMERIC(20,0) REFERENCES TipoAbbonamento(codiceTipoAbbonamento) ON DELETE CASCADE ON UPDATE CASCADE
	);


CREATE TABLE Utente -- rif carta carburante
	(
		email VARCHAR(20),
		bonus DATE, 
		pin NUMERIC(5,0) REFERENCES CartaCarburante(pin)  ON DELETE CASCADE ON UPDATE CASCADE,

		PRIMARY KEY (email)
	);


CREATE TABLE Pagamento -- rif utente
	(
		email VARCHAR(20) REFERENCES Utente(email)  ON DELETE CASCADE ON UPDATE CASCADE,
		PRIMARY KEY (email),

		circuito VARCHAR(30),
		numero VARCHAR(15),
		scadenza DATE,
		nome VARCHAR(10),
		cognome VARCHAR(10),
		coordbanca VARCHAR(20),
		soldi_versati NUMERIC(5,2)
	);


CREATE TABLE Abbonamenti -- rif utente e tipo abbonamento (cambiare anche nello schema relaz)
	(
		codiceAbbonamento NUMERIC(5,0),
		PRIMARY KEY (codiceAbbonamento),

		costoApplicato NUMERIC(5,2) NOT NULL,
		inizio DATE NOT NULL ,
		fine DATE NOT NULL,
		CHECK(inizio < fine),
		email VARCHAR(20) REFERENCES Utente(email)  ON DELETE CASCADE ON UPDATE CASCADE,
		codiceTipoAbbonamento NUMERIC(20,0) REFERENCES TipoAbbonamento(codiceTipoAbbonamento) ON DELETE CASCADE ON UPDATE CASCADE
	);


CREATE TABLE Agevolazioni -- rif tipo abbonamento e convenzione
	(
		codiceTipoAbbonamento NUMERIC(20,0) REFERENCES TipoAbbonamento(codiceTipoAbbonamento) ON DELETE CASCADE ON UPDATE CASCADE,
		tipoConvenzione VARCHAR(30) REFERENCES Convenzione(tipoConvenzione) ON DELETE CASCADE ON UPDATE CASCADE,

		PRIMARY KEY(codiceTipoAbbonamento, tipoConvenzione)
	);


CREATE TABLE Vetture -- rif parcheggio e modello
	(
		targa VARCHAR(8),
		PRIMARY KEY (targa),

		nome VARCHAR(30) NOT NULL,
		km NUMERIC(7,0) NOT NULL CHECK (km > 0),
		colore VARCHAR(15) NOT NULL,
		Percentuale_carburante NUMERIC(5,2) NOT NULL, 
		seggiolino NUMERIC(1,0) NOT NULL DEFAULT 0 CHECK (seggiolino >= 0),
		trasporto_animali BOOLEAN NOT NULL DEFAULT FALSE,
		
		latitudine NUMERIC(9,7) REFERENCES Parcheggio(latitudine) ON DELETE CASCADE ON UPDATE CASCADE,
		longitudine NUMERIC(10,7) REFERENCES Parcheggio(longitudine) ON DELETE CASCADE ON UPDATE CASCADE,
		idModello NUMERIC(3,0) REFERENCES Modello(idModello)  ON DELETE CASCADE ON UPDATE CASCADE,

		tipo VARCHAR(30) NOT NULL
	);

CREATE TABLE Rifornimento -- rif carta carburante e vetture
	(
		codiceRifornimento NUMERIC(10,0),
		PRIMARY KEY (codiceRifornimento),

		km_auto NUMERIC(10,0) NOT NULL CHECK (km_auto >= 0),
		numLitri NUMERIC(10,2) NOT NULL CHECK (numLitri > 0),
		penale BOOLEAN NOT NULL DEFAULT FALSE,

		pin NUMERIC(5,0) REFERENCES CartaCarburante(pin)  ON DELETE CASCADE ON UPDATE CASCADE,
		targa VARCHAR(8)  REFERENCES Vetture(targa) ON DELETE CASCADE ON UPDATE CASCADE
	);



CREATE TABLE Tipo  -- rif parcheggio e categoria
	(
		latitudine NUMERIC(9,7) REFERENCES Parcheggio(latitudine) ON DELETE CASCADE ON UPDATE CASCADE,
		longitudine NUMERIC(10,7) REFERENCES Parcheggio(longitudine) ON DELETE CASCADE ON UPDATE CASCADE,
		tipoCategoria VARCHAR(20) REFERENCES Categoria(tipoCategoria) ON DELETE CASCADE ON UPDATE CASCADE,

		PRIMARY KEY (latitudine, longitudine, tipoCategoria)
	);


CREATE TABLE Prenotazione -- rif utente e vettura
	(
		codicePrenotazione NUMERIC(15,0),
		PRIMARY KEY (codicePrenotazione),

		data_ritiro DATE NOT NULL,			-- Data per cui puoi iniziare ad usare l'auto avendo prenotato
		orario_ritiro TIME NOT NULL,
		data_riconsegna DATE NOT NULL,
		orario_riconsegna TIME NOT NULL,

		CHECK(data_riconsegna > data_ritiro),
		CHECK(orario_riconsegna > orario_ritiro),

		email VARCHAR(20) REFERENCES Utente(email)  ON DELETE CASCADE ON UPDATE CASCADE,
		targa VARCHAR(8)  REFERENCES Vetture(targa) ON DELETE CASCADE ON UPDATE CASCADE
	);

CREATE TABLE Utilizzo -- rif prenotazione
	(
		codicePrenotazione NUMERIC(15,0) REFERENCES Prenotazione(codicePrenotazione) ON DELETE CASCADE ON UPDATE CASCADE,
		PRIMARY KEY (codicePrenotazione),

		data_effettivo_ritiro DATE NOT NULL,
		orario_effettivo_ritiro TIME NOT NULL,

		data_effettiva_consegna DATE NOT NULL,		
		orario_effettivo_consegna TIME NOT NULL,

		data_prenotazione DATE NOT NULL, 		-- Data in cui effettui prenotazione
		orario_prenotazione TIME NOT NULL,

		km_ritiro NUMERIC(7,0) NOT NULL,
		km_riconsegna NUMERIC(7,0) NOT NULL,	

		CHECK(km_riconsegna > km_ritiro),
		CHECK(data_effettiva_consegna >= data_effettivo_ritiro),
		CHECK(data_effettivo_ritiro >= data_prenotazione),
		CHECK ((orario_effettivo_ritiro + INTERVAL '00:15')>= orario_prenotazione),

		penale_ritardo BOOLEAN NOT NULL DEFAULT FALSE,
		ore_rinuncia BOOLEAN NOT NULL DEFAULT FALSE
	);



CREATE TABLE Privato -- rif utente e conducente   -- NO SOLO UTENTE
	(
		email VARCHAR(20) REFERENCES Utente(email)  ON DELETE CASCADE ON UPDATE CASCADE,
		PRIMARY KEY (email),

		codFiscale VARCHAR(20) UNIQUE NOT NULL,
		professione VARCHAR(20) NOT NULL,
		genere CHAR(1) NOT NULL CHECK(genere = 'M' OR genere = 'F'),
		indirizzo VARCHAR(20) NOT NULL
	);


CREATE TABLE Azienda -- rif utente
	(

		email VARCHAR(20) REFERENCES Utente(email)  ON DELETE CASCADE ON UPDATE CASCADE,
		PRIMARY KEY (email),

		p_iva VARCHAR(12) UNIQUE NOT NULL,
		numTelefono NUMERIC(15,0) UNIQUE NOT NULL, 
		ragSociale VARCHAR(20) NOT NULL,
		indirizzo_sedeLeg VARCHAR(30) NOT NULL,
		indirizzo_sedeOp VARCHAR(30),
		settoreAttivita VARCHAR(30) NOT NULL,
		nomeLeg VARCHAR(20) NOT NULL,
		cognomeLeg VARCHAR(20) NOT NULL,
		luogoN_Leg VARCHAR(20) NOT NULL,
		dataN_Leg DATE NOT NULL,
		nome_ref VARCHAR(20) NOT NULL,
		cognome_ref  VARCHAR(20) NOT NULL,
		numTelefono_ref NUMERIC(15,0) NOT NULL
	);


CREATE TABLE Conducente -- rif privato e azienda
	(
		estremiPatente VARCHAR(10),
		PRIMARY KEY (estremiPatente),

		estremiIdentita VARCHAR(9) UNIQUE NOT NULL,
		nome VARCHAR(10) NOT NULL,
		cognome VARCHAR(10) NOT NULL,
		dataN DATE NOT NULL,
		luogoN  VARCHAR(10) NOT NULL,
		catPatente VARCHAR(15) NOT NULL,

		emailP VARCHAR(20) REFERENCES Privato(email)  ON DELETE CASCADE ON UPDATE CASCADE,		-- EmailP perchè non posso creare due chiavi esterne email con stesso nome
		emailA VARCHAR(20) REFERENCES Azienda(email)  ON DELETE CASCADE ON UPDATE CASCADE
	);


CREATE TABLE Dipendente -- rif cond e azienda
	(
		estremiPatente VARCHAR(10) REFERENCES Conducente(estremiPatente) ON DELETE CASCADE ON UPDATE CASCADE,
		PRIMARY KEY (estremiPatente),

		email VARCHAR(20) REFERENCES Azienda(email)  ON DELETE CASCADE ON UPDATE CASCADE

	);


CREATE TABLE Convive -- rif cond e privato
	(
		estremiPatente VARCHAR(10)  REFERENCES Conducente(estremiPatente) ON DELETE CASCADE ON UPDATE CASCADE,
		PRIMARY KEY (estremiPatente),

		email VARCHAR(20) REFERENCES Privato(email)  ON DELETE CASCADE ON UPDATE CASCADE,  -- Come dipendente ma è univoca in italico
		UNIQUE(email)
	);

CREATE TABLE Telefono -- rif privato
	(
		numero NUMERIC(15,0),
		PRIMARY KEY (numero),

		email VARCHAR(20) REFERENCES Privato(email)  ON DELETE CASCADE ON UPDATE CASCADE
	);

CREATE TABLE Sinistro -- rif conducente e vettura
	(	
		orario TIME NOT NULL UNIQUE,
		data DATE NOT NULL UNIQUE,
		descrizione_danni VARCHAR(30) NOT NULL,
		descrizione_dinamica VARCHAR(30) NOT NULL,
		luogo VARCHAR(20) NOT NULL,

		estremiPatente VARCHAR(10) UNIQUE REFERENCES Conducente(estremiPatente) ON DELETE CASCADE ON UPDATE CASCADE,
		targa VARCHAR(8)  REFERENCES Vetture(targa) ON DELETE CASCADE ON UPDATE CASCADE,

		--UNIQUE(orario, data, estremiPatente),
		PRIMARY KEY (estremiPatente, orario, data)
	);


CREATE TABLE Persona -- rif niente
	(
		estremiIdentita VARCHAR(9) UNIQUE NOT NULL,
		PRIMARY KEY (estremiIdentita),

		estremiPatente BOOLEAN NOT NULL DEFAULT FALSE,
		nome VARCHAR(10) NOT NULL,
		cognome VARCHAR(10) NOT NULL,
		dataN DATE NOT NULL,
		luogoN  VARCHAR(10) NOT NULL,
		genere CHAR(1) NOT NULL CHECK(genere = 'M' OR genere = 'F')
	);

CREATE TABLE Testimone -- rif sinistro e persona
	(
		estremiPatente VARCHAR(10)  REFERENCES Sinistro(estremiPatente) ON DELETE CASCADE ON UPDATE CASCADE,
		orario TIME NOT NULL REFERENCES Sinistro(orario) ON DELETE CASCADE ON UPDATE CASCADE,
		data DATE NOT NULL REFERENCES Sinistro(data) ON DELETE CASCADE ON UPDATE CASCADE,
		estremiIdentita VARCHAR(9) UNIQUE NOT NULL REFERENCES Persona(estremiIdentita) ON DELETE CASCADE ON UPDATE CASCADE,

		PRIMARY KEY(estremiPatente, orario, data, estremiIdentita)
	);


CREATE TABLE Coinvolta -- rif sinistro e persona
	(
		estremiPatente VARCHAR(10)  REFERENCES Sinistro(estremiPatente) ON DELETE CASCADE ON UPDATE CASCADE,
		orario TIME NOT NULL REFERENCES Sinistro(orario) ON DELETE CASCADE ON UPDATE CASCADE,
		data DATE NOT NULL REFERENCES Sinistro(data) ON DELETE CASCADE ON UPDATE CASCADE,
		estremiIdentita VARCHAR(9) UNIQUE NOT NULL REFERENCES Persona(estremiIdentita) ON DELETE CASCADE ON UPDATE CASCADE,

		PRIMARY KEY(estremiPatente, orario, data, estremiIdentita)
	);


CREATE TABLE VettureCoinvolte -- targhe e sinistro   
	(	
		estremiPatente VARCHAR(10)  REFERENCES Sinistro(estremiPatente) ON DELETE CASCADE ON UPDATE CASCADE,
		orario TIME NOT NULL REFERENCES Sinistro(orario) ON DELETE CASCADE ON UPDATE CASCADE,
		data DATE NOT NULL REFERENCES Sinistro(data) ON DELETE CASCADE ON UPDATE CASCADE,

		numTarga VARCHAR(8) REFERENCES Targhe(numTarga) ON DELETE CASCADE ON UPDATE CASCADE,

		PRIMARY KEY (estremiPatente, orario, data, numTarga)

	);




/**********************************************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
************************************************				INSERIMENTI 				***************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************************************************/

INSERT INTO Convenzione(tipoConvenzione) VALUES 
					   ('Over 60'), 
					   ('Over 70'), 
					   ('Nessuna'), 
					   ('Under 26');



INSERT INTO Parcheggio  (latitudine, longitudine, nome, zona, numposti) VALUES 
						(10.1234567, 11.1234567, 'A','Caricamento', 10), 
						(20.1234567, 21.1234567, 'B','Albaro', 20), 
						(30.1234567, 31.1234567, 'C', 'San Martino', 30), 
						(40.1234567, 41.1234567, 'D', 'Marassi', 40);




INSERT INTO Targhe (numTarga) VALUES 
				   ('AB000CC'), 
				   ('BB000CC'), 
				   ('GU3RR1N'), 
				   ('DE7Z4NN');




INSERT INTO Categoria (tipoCategoria) VALUES 
					  ('City Car'), 
					  ('Media'), 
					  ('Comfort'), 
					  ('Cargo'), 
					  ('Elettrico');




INSERT INTO TipoAbbonamento (codiceTipoAbbonamento, costo, durata) VALUES 
							(111, 100.00, 12.0), 
							(222, 500.00, 24.0), 
							(333, 1000.00, 36.0);



INSERT INTO Modello (idModello, nome, produttore, categoria, lunghezza, larghezza, altezza, capacitaBagagli, numPosti, numPorte, CvKw, cilindrata, consumoMedio, velocitaMax, ariaCond, servoSterzo, airbag) VALUES
					(	1,		'ABC1',   'W', 	  'City Car',  	4, 		    2, 		  1, 		    20,  		5,		  3, 	  234,		4, 		  12.20, 		500, 		true, 		true, 	 false),
					(	2,		'ABC2',   'W', 	  'Media', 		5, 		    3,		  2, 	    	21,  		5, 		  3, 	  300, 		4, 		  12, 			400, 		true, 		true, 	 false),
 					(	3,		'ABC3',   'W', 	  'Comfort', 	6, 		    4,		  3, 	    	22,  		5, 		  5, 	  400, 		5, 		  15, 			700, 		true, 		true, 	 true);




INSERT INTO Tariffa (codiceTariffa, carburante, tariffaforfait, tariffaorario, tariffakm, tariffaaggiuntiva, tariffa7giorni, idModello) VALUES
					(	'T1', 			true,		  5,			 10,		   15,			 50,			  90,			'1'), 
					(	'T2', 			false, 		  4,			 8,			   13,			 40,			  80,			'2');




INSERT INTO CartaCarburante (pin, codiceTipoAbbonamento) VALUES 
							(00111, 111), 
							(00222, 222), 
							(00333, 333);




INSERT INTO Utente (email, bonus, pin) VALUES 
				   ('pippo@gmail.com', '2019-07-05', 00111), 
				   ('pluto@gmail.com','2018-06-04',00222),
				   ('paperino@gmail.com', '2020-01-01', 00222),
				   ('lars@gmail.com', '2021-01-01', 00333),
				   ('antonio@gmail.com', '2022-02-03', 00333);
				   




INSERT INTO Pagamento (email, 				circuito,   numero, 	scadenza, 		nome, 		cognome, 	coordbanca,	soldi_versati) VALUES 
					  ('pippo@gmail.com',  'bancomat', 'p1pp0', 	'2020-01-01', 	'pippo', 	'abc', 		'c0rd1n4', 	500),
					  ('pluto@gmail.com',  'maestro',  'varnum',	'2030-02-07', 	'pluto',	'canis', 	'BNIA213',	399),
					  ('antonio@gmail.com', 'visa', 'antm4n', '2021-05-06', 'antonio', 'antonelli', 'ant1010', 500);
			



INSERT INTO Abbonamenti (codiceAbbonamento, costoApplicato, inizio, fine, email,codiceTipoAbbonamento) VALUES 
						(00000, 50.00, '2019-07-06', '2020-07-07', 'pippo@gmail.com', 111), 
						(00001, 250.0, '2020-01-01', '2022-01-03', 'pluto@gmail.com', 222);
						




INSERT INTO Agevolazioni (codiceTipoAbbonamento, tipoConvenzione) VALUES
	(111, 'Over 60'), (111, 'Over 70'), (111, 'Under 26'), (111, 'Nessuna'), 
	(222, 'Over 60'), (222, 'Over 70'), (222, 'Under 26'), (222, 'Nessuna'), 
	(333, 'Over 60'), (333, 'Over 70'), (333, 'Under 26'), (333, 'Nessuna');
						




INSERT INTO Vetture (targa, 	  nome, 	 km,  colore, Percentuale_carburante, seggiolino, trasporto_animali, latitudine, longitudine, idModello, tipo) 			VALUES 
					('AL007LK', 'paperina', 4040, 'blu', 		  70, 				  2, 			true, 		 10.1234567, 11.1234567, 		1,	 'City Car'),	
					('BV000LK', 'topolino', 4242, 'rosso',  	  66, 				  6,			false, 		 20.1234567, 21.1234567, 		2,	 'Cargo'),
					('CR000LK', 'minnie',   4545, 'giallo',  	  90, 				  0,			false, 		 30.1234567, 31.1234567, 		3,	 'Comfort');





INSERT INTO Rifornimento (codiceRifornimento, km_auto, numLitri, penale, pin, 	targa) VALUES
						 (	   110011,			100,	  2,	 false,	 00111, 'AL007LK'),
						 (	   220022,			500,	  3,	 true,	 00333, 'BV000LK'),
						 (	   330033,			1000,	  1,	 false,	 00222, 'CR000LK');





INSERT INTO Tipo (latitudine, longitudine, tipoCategoria) VALUES
				 (10.1234567, 11.1234567, 	'Media'),
				 (20.1234567, 21.1234567, 	'Elettrico'),
				 (20.1234567, 21.1234567, 	'City Car');




INSERT INTO Prenotazione (codicePrenotazione, data_ritiro, orario_ritiro, data_riconsegna, orario_riconsegna, email, 				targa) VALUES		-- Bisogna fare controllo che stessa targa non sia prenotata contemporaneamente
						 (		01,			  '2019-07-10',  '16:00:00', 	'2019-10-10', 		'17:00:00',	  'pippo@gmail.com',	'CR000LK' 	),
						 (		02,			  '2019-07-10',  '18:00:00', 	'2019-12-10', 		'19:00:00',	  'pippo@gmail.com',	'AL007LK' 	),		 
						 (		03,			  '2019-09-10',  '18:00:00', 	'2019-09-30', 		'19:00:00',	  'pluto@gmail.com',	'AL007LK' 	),
						 (		04,			  '2019-12-10',  '16:00:00', 	'2019-12-30', 		'19:00:00',	  'lars@gmail.com',		'CR000LK' 	),
						 (		05,			  '2019-10-10',  '16:00:00', 	'2019-12-30', 		'19:00:00',	  'lars@gmail.com',		'AL007LK' 	);

INSERT INTO Utilizzo (codicePrenotazione, data_effettivo_ritiro, orario_effettivo_ritiro, data_effettiva_consegna, orario_effettivo_consegna, data_prenotazione, orario_prenotazione, km_ritiro, km_riconsegna, penale_ritardo, ore_rinuncia) VALUES
					 (			01,			   '2019-08-10',			'12:00:00',				'2019-10-05',				'17:00:00',			'2019-05-10',		'10:00:00',			10,			500,			false,			true	);
 		 			 --(			01,			   '2019-08-10',			'12:00:00',				'2019-10-05',				'17:00:00',			'2019-05-10',		'10:00:00',			10,			500,			false,			true	)



INSERT INTO Privato (email, 			codFiscale, 	professione, 	genere, indirizzo) VALUES
					('pluto@gmail.com',	'PLU1010PLU', 	'disoccupato', 	'M', 	'Via ayroli'),
					('pippo@gmail.com',	'PIP1010PIP', 	'insegnante', 	'M', 	'Via balbi'),
					('lars@gmail.com', 'LAR101PAP', 'astronauta', 'M', 'Via ayroli'),
					('antonio@gmail.com', 'ANT101NIO', 'poeta', 'M', 'Via roma');



INSERT INTO Azienda (email, 			  p_iva,  numTelefono, ragSociale,       indirizzo_sedeLeg,        indirizzo_sedeOp,    settoreAttivita,  nomeLeg,   cognomeLeg, luogoN_Leg, dataN_Leg,     nome_ref, cognome_ref, numTelefono_ref) VALUES
					('paperino@gmail.com', 'IVA1',  3281112233,  'ragSociale1', 'Via Dodecaneso(Genova)', 'Via Dodecaneso(Genova)', 'Informatica', 'Paperino', 'Paperone', 'Genova',  '1998-12-15', 'Alessandro', 'Verri',      3281112234 );
					--('paperino@gmail.com', 'P1', 3281112233, 'ragSociale1', 'Via Dodecaneso(Genova)', 'Via Dodecaneso(Genova)', 'Informatica', 'Paperino', 'Paperone', 'Genova', '1998-12-15', 'Alessandro', 'Verri', 3281112234 ),



INSERT INTO Conducente (estremiPatente, estremiIdentita, 	nome,	 cognome, 		dataN, 	   luogoN, catPatente, emailP, 	emailA) VALUES
					   ('P1', 'I1',	'Paperino', 'Paperone', '1998-12-15', 'Genova', 'A1', null, 'paperino@gmail.com'),					 
					   ('P2', 'I2',	'Pluto', 'Canis', '1998-12-20', 'Genova', 'A2', 'pluto@gmail.com', null),
					   ('P3', 'I3', 'Lars', 'Perro', '2000-08-06', 'Genova', 'A1', 'lars@gmail.com', null),
					   ('P4', 'I4', 'Pippo', 'Goofy', '1997-03-05', 'Genova', 'A2', 'pippo@gmail.com', null),
					   ('P5', 'I5', 'Antonio', 'Felice', '1999-05-04', 'Genova', 'A1', 'antonio@gmail.com', null);




INSERT INTO Dipendente (estremiPatente, email) VALUES
					   ('P1', 'paperino@gmail.com');



INSERT INTO Convive (estremiPatente, email) VALUES --estremiPatente convive con email
					('P2', 'lars@gmail.com');



INSERT INTO Telefono (numero, 			email) VALUES
					 (3285119876, 'pluto@gmail.com'),
					 (3280000000, 'pluto@gmail.com');




INSERT INTO Sinistro (orario, 		data, 			descrizione_danni,		 descrizione_dinamica,		 luogo, 			estremiPatente, 		  targa) VALUES
				     ('12:34:56', '2021-01-01',		'Parabrezza rotto', 	'Passato con il rosso', 	'Via Archimede', 		'P1', 				'AL007LK'),
					 ('16:43:24', '2024-03-06', 	'Specchietto rotto',	 'Contromano', 				'Corso Sardegna', 		'P2', 				'BV000LK');




INSERT INTO Persona (estremiIdentita, estremiPatente,  nome,     	cognome,    	dataN, 	   luogoN, genere) VALUES
					('AA1234567', 	  		true, 	  'Giovanni', 'Muciaccia',  '1969-12-26', 'Foggia',  'M'),
					('BB1234567', 	  		false, 	  'Giorgio',  'Albertazzi', '1923-08-20', 'Fiesole', 'M');




INSERT INTO Testimone (estremiPatente,	   orario, 		data, 			estremiIdentita) VALUES				-- Non mi convincono Testimone-Persona perchè prende patente dal conducente ma poi identità è propria e non di conducente
					  ('P1',			 '12:34:56', 	'2021-01-01',	 'AA1234567'),
					  ('P1',			 '16:43:24',	'2024-03-06',	 'BB1234567');





INSERT INTO Coinvolta (estremiPatente,		 orario, 		data, 			estremiIdentita) VALUES
					  ('P1', 				'12:34:56',		'2021-01-01', 	  'AA1234567'),
					  ('P2', 				'16:43:24',  	'2024-03-06', 	  'BB1234567');




INSERT INTO VettureCoinvolte (estremiPatente, 	orario, 		data,			 numTarga) VALUES 
							 ('P1', 			'12:34:56', 	'2021-01-01', 	 'AB000CC'),
							 ('P2', 			'16:43:24',		'2024-03-06',	 'BB000CC');





/**********************************************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
************************************************				TRIGGER 			***************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************************************************/


--(1)Un utente può avere più abbonamenti, ma solo uno di essi può essere valido.

CREATE FUNCTION
VerificaAbbonamento() RETURNS
trigger AS $$
BEGIN
	IF((SELECT COUNT(*)
	FROM Abbonamenti 
	WHERE NEW.inizio < fine AND NEW.email = email)>1)
	THEN RAISE EXCEPTION '% Ha più abbonamenti attivi',NEW.email;
	ELSE RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER VerificaAbbonamento
AFTER INSERT OR UPDATE ON
Abbonamenti
FOR EACH ROW
EXECUTE PROCEDURE
VerificaAbbonamento();

--Inserimenti che attivano il trigger
--INSERT INTO Abbonamenti VALUES (00002, 50.00, '2020-07-01', '2030-06-15', 'pippo@gmail.com', 111); --Inserimento per attivare il trigger
--INSERT INTO Abbonamenti VALUES (00003, 53.00, '2020-08-08','2030-09-09','pippo@gmail.com', 111); -- Iserimento corretto


-----------------------------------------------------------------------------------------------------------------------------------------

--(2)Una prenotazione può essere effettuata solo da un utente con un abbonamento valido.


CREATE FUNCTION VerificaValiditaAbb() RETURNS trigger AS $$
BEGIN 
  IF ((SELECT COUNT(*) FROM Abbonamenti WHERE Abbonamenti.email = NEW.email AND fine > current_date) = 0)
    THEN RAISE EXCEPTION '% non ha un abbonamento valido', NEW.email;
  ELSE RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER VerificaValiditaAbb
AFTER INSERT ON 
Prenotazione
FOR EACH ROW
EXECUTE PROCEDURE 
VerificaValiditaAbb();

/*
--Inserimento informazioni per il trigger
INSERT INTO Abbonamenti (codiceAbbonamento, costoApplicato, inizio, fine, email,codiceTipoAbbonamento) VALUES
(00002, 50.00, '2018-05-06', '2019-05-06', 'antonio@gmail.com', 111);

--Attiva il trigger
INSERT INTO Prenotazione (codicePrenotazione, data_ritiro, orario_ritiro, data_riconsegna, orario_riconsegna, email, targa) VALUES
(04, '2019-08-20', '21:00:00', '2019-08-21', '22:05:06', 'antonio@gmail.com', 'CR000LK');
*/


-----------------------------------------------------------------------------------------------------------------------------------------

--(5)Il conducente addizionale associati a privato deve avere lo stesso indirizzo di residenza del privato a cui sono associati. --TRIGGER --R

CREATE FUNCTION
VerificaCondAdd() RETURNS
trigger AS $$
BEGIN
	IF NOT EXISTS (SELECT * FROM Conducente, Privato WHERE
					NEW.estremiPatente = Conducente.estremiPatente AND Conducente.emailP = Privato.email AND (Privato.indirizzo = (SELECT indirizzo FROM Privato WHERE NEW.email = Privato.email))
				  )
	THEN RAISE EXCEPTION 'Non sono conviventi';
	ELSE RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER VerificaCondAdd
AFTER INSERT OR UPDATE ON 
Convive
FOR EACH ROW
EXECUTE PROCEDURE 
VerificaCondAdd();


--Inserimento che attiva il trigger
--INSERT INTO Convive (estremiPatente, email) VALUES --estremiPatente convive con email
--				('P4', 'antonio@gmail.com');



--(8) TRIGGER 8: Utenti diversi possono usare la stessa modalità di pagamento solo se essa non è di tipo pre-pagamento/contanti. 

CREATE FUNCTION VerificaPagamento() 
RETURNS trigger AS $$
BEGIN
IF(SELECT COUNT(*)
FROM abbonamenti as ab, utente as u
WHERE NEW.email = ab.email /*AND usano i contanti*/)<>0
THEN RAISE EXCEPTION 'Due persone hanno pagato coi contanti! OMG';
ELSE RETURN NEW;
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER VerificaPagamento
BEFORE INSERT OR UPDATE ON
abbonamenti
FOR EACH ROW
EXECUTE PROCEDURE
VerificaPagamento();


--(9)Una carta di credito può essere utilizzata per un pagamento solo entro la data di scadenza (la data di scadenza deve essere successiva alla data 
--di acquisto dell'abbonamento e alla data di riconsegna di ogni prenotazione). --TRIGGER --R

CREATE FUNCTION 
VerificaScadenzaCartaAbb() RETURNS 
trigger AS $$
BEGIN
	IF(NEW.inizio>(SELECT scadenza FROM Pagamento WHERE Pagamento.email=NEW.email)) 
		THEN RAISE EXCEPTION 'Carta scaduta'; 
		ELSE
		RETURN NEW;
  	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION 
VerificaScadenzaCartaPrenotaz() RETURNS 
trigger AS $$
BEGIN
	IF(NEW.dataconsegna>(SELECT scadenza FROM Pagamento WHERE Pagamento.email=NEW.email)) 
		THEN RAISE EXCEPTION 'La carta è scaduta';
		ELSE
    	RETURN NEW;    
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER VerificaScadenzaCartaAbb
BEFORE INSERT OR UPDATE ON 
Abbonamenti 
FOR EACH ROW
EXECUTE PROCEDURE 
VerificaScadenzaCartaAbb();

CREATE TRIGGER VerificaScadenzaCartaPrenotaz
BEFORE INSERT OR UPDATE ON 
Prenotazione
FOR EACH ROW
EXECUTE PROCEDURE 
VerificaScadenzaCartaPrenotaz();


--Attiva il trigger
--INSERT INTO Abbonamenti (codiceAbbonamento, costoApplicato, inizio, fine, email,codiceTipoAbbonamento) VALUES
--(00002, 50.00, '2022-05-06', '2023-05-06', 'antonio@gmail.com', 111);



-- TRIGGER 10: Il numero di vetture presenti in un parcheggio non deve mai eccedere il numero posti dello stesso.
CREATE FUNCTION
VerificaNumPosti() RETURNS
trigger AS $$
BEGIN
	IF(SELECT COUNT(*)
	FROM Tipo
	WHERE NEW.latidudine = latidudine AND NEW.longitudine = longitudine)> parcheggio.numposti
	THEN RAISE EXCEPTION '% Troppe macchine',Parcheggio;
	ELSE RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER VerificaNumPosti
AFTER INSERT OR UPDATE ON
Tipo
FOR EACH ROW
EXECUTE PROCEDURE
VerificaNumPosti();

-----------------------------------------------------------------------------------------------------------------------------------------

--(11)Un parcheggio non deve contenere veicoli di una categoria che non può ospitare.

CREATE FUNCTION VerificaCategoriaParcheggio() RETURNS trigger AS $$
BEGIN
  IF EXISTS (SELECT * FROM Parcheggio WHERE NEW.latitudine = Parcheggio.latitudine AND NEW.longitudine = Parcheggio.longitudine) 
  	THEN
	IF NOT EXISTS( SELECT * FROM Modello,Tipo WHERE NEW.idModello = Modello.idModello AND Modello.categoria = Tipo.tipoCategoria AND Tipo.latitudine = NEW.latitudine AND Tipo.longitudine = NEW.longitudine) 
		THEN
		RAISE EXCEPTION 'Il parcheggio non può ospitare questa vettura';
	ELSE
	RETURN NEW;
  END IF;
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER VerificaCategoriaParcheggio
AFTER INSERT OR UPDATE ON 
Vetture
FOR EACH ROW
EXECUTE PROCEDURE 
VerificaCategoriaParcheggio();

--Attiva il trigger
--INSERT INTO VETTURE (targa,nome,km,colore,Percentuale_carburante, seggiolino, trasporto_animali, latitudine, longitudine, idModello, tipo) VALUES 
 --('DE7ZANN', 'thor', 4236, 'verde', 80, 1, true, 10.1234567, 11.1234567, 2, 'City Car' );



-- 16. Il chilometraggio ad ogni rifornimento non può essere minore di quello dei precedenti rifornimenti.
CREATE OR REPLACE FUNCTION controlloKmRifornimento() RETURNS trigger AS 
$$
BEGIN
	IF
		(SELECT MAX(km_auto) FROM rifornimento
		WHERE codiceRifornimento = NEW.codiceRifornimento) >  NEW.km_totali
	THEN
		RAISE EXCEPTION 'Impossibile che il chilometraggio ad ogni rifornimento sia minore del precedente';
	ELSE
		RETURN new;
	END IF;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER controlloKmRifornimento
BEFORE INSERT ON rifornimento
FOR EACH ROW EXECUTE PROCEDURE controlloKmRifornimento();


-- 17. I km ad ogni rifornimento devono essere compresi tra i km al ritiro e quelli alla riconsegna per l’utilizzo dell’auto corrispondente.
CREATE OR REPLACE FUNCTION controlloKmRifornimento2() RETURNS trigger AS 
$$
BEGIN
	IF
		(SELECT km_ritiro FROM uso
		JOIN prenotazione ON uso.id_uso = prenotazione.id_uso
		WHERE codiceRifornimento = codiceRifornimento) <=  NEW.km_auto
		AND
		(SELECT km_riconsegna FROM uso
		JOIN prenotazione ON uso.id_uso = prenotazione.id_uso
		WHERE numSMartCard = NEW.numSmartCard) >=  NEW.km_totali
	THEN
		RETURN new;
	ELSE
		RAISE EXCEPTION 'I km ad ogni rifornimento devono essere compresi tra i km al ritiro e quelli alla riconsegna per l’utilizzo dell’auto corrispondente.';
	END IF;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER ccontrolloKmRifornimento2
BEFORE INSERT ON rifornimento
FOR EACH ROW EXECUTE PROCEDURE controlloKmRifornimento2();



/*
-- 19. Nel caso di prenotazioni in cui data di ritiro e data di consegna coincidono, il prezzo deve essere uguale a 
--(tariffa oraria)*(ore prenotate) + (tariffa chilometrica)*(chilometri effettivamente percorsi) se non è attivo il bonus di rottamazione.

CREATE FUNCTION VerificaPrezzoUnGiorno() 
RETURNS trigger AS $$
BEGIN
IF(SELECT SUM(DATEDIFF(orario_riconsegna, orario_ritiro)*tariffaorario + tariffakm*(km_riconsegna-km_ritiro)) as prezzoTot
FROM PRENOTAZIONE AS pre, utente 
WHERE NEW.data_ritiro = pre.data_ritiro AND NEW.data_riconsegna = pre.data_riconsegna)<> ||||||||||||||| --prezzoTot
THEN RAISE EXCEPTION '% ha troppe macchine', email;
ELSE RETURN NEW;
END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER VerificaPrezzoUnGiorno
BEFORE INSERT OR UPDATE ON Prenotazione --bo quando paga 
FOR EACH ROW
EXECUTE PROCEDURE
VerificaPrezzoUnGiorno();
*/ 



/**********************************************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
************************************************				ES 0 - VISTA FATTURAZIONE					***************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************************************************/
CREATE OR REPLACE VIEW Fatturazione as(

	SELECT  (extract (DAY FROM
			(data_effettiva_consegna::timestamp - data_effettivo_ritiro::timestamp))*(tariffaorario*24) +
	        (km_riconsegna - km_ritiro)*tariffakm) 
			AS CostoGiornaliero,

		    (extract (DAY FROM (
			data_effettiva_consegna::timestamp - data_effettivo_ritiro::timestamp)))::double precision / tariffa7giorni	+ 
		    ((km_riconsegna - km_ritiro)*tariffakm)
			AS CostoSettimanale,

			(extract (epoch FROM
			(orario_effettivo_consegna - orario_effettivo_ritiro)) / 3600)*tariffaorario + 
			((km_riconsegna - km_ritiro) * tariffakm) 
			AS CostoOrario

				FROM UTILIZZO JOIN PRENOTAZIONE
					ON PRENOTAZIONE.codicePrenotazione = UTILIZZO.codicePrenotazione
					INNER JOIN TARIFFA
					ON 1 = 1
);


/**********************************************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
************************************************					QUERY					***************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************************************************/

--Es 1 IN COMUNE 	relativa a vetture, modelli, parcheggi, abbonamenti, prenotazioni ed effetivi utilizzi
-- a) Semplice
-- determinare	tutti	gli	utenti	con	eventualmente	associate	nome	e	targa	delle	vetture	che	hanno	
-- attualmente	in	uso	e	l’indicazione	di	quando	è	prevista	la	riconsegna
	SELECT  Utente.email,Vetture.targa,Prenotazione.data_riconsegna,Prenotazione.orario_riconsegna
	FROM Utente JOIN  Prenotazione ON Utente.email=Prenotazione.email JOIN Vetture ON Prenotazione.targa = Vetture.targa
	WHERE (Prenotazione.data_riconsegna > CURRENT_DATE) OR
	(Prenotazione.data_riconsegna = CURRENT_DATE AND Prenotazione.orario_riconsegna > current_time);


-- b) Differenza    
-- Selezioniamo vetture non dotate del trasporto animale
	SELECT *
	FROM Vetture
	EXCEPT(
	SELECT *
	FROM Vetture
	WHERE trasporto_animali=true);


-- c) Outer Join
-- determinare i parcheggi che contengono (attualmente) almeno una vettura, per cui non risultino prenotazioni nella prossima ora, per ogni categoria che ospitano
	SELECT DISTINCT parcheggio.nome
	FROM vetture
	JOIN parcheggio ON vetture.longitudine=parcheggio.longitudine 
	JOIN categoria ON vetture.tipo=categoria.tipocategoria
	GROUP BY categoria.tipocategoria, parcheggio.nome
	HAVING count(*) >=1
	EXCEPT	
		SELECT DISTINCT parcheggio.nome
		FROM  categoria, prenotazione
		RIGHT OUTER JOIN vetture ON prenotazione.targa=vetture.targa
		JOIN parcheggio ON vetture.longitudine=parcheggio.longitudine
		WHERE CURRENT_DATE = prenotazione.data_ritiro 
		AND prenotazione.orario_ritiro >= (CURRENT_TIME + interval '1 hours')
		GROUP BY categoria.tipocategoria, parcheggio.nome
		HAVING count(*) >=1;

--Es 1 ASSEGNATA 	relativa alla gestione	delle diverse tipologie	di	utenti,	conducenti	abilitati,	bonus,	modalità	di	pagamento
-- a) Semplice
--determinare gli utenti con meno di 26 anni (con diritto a sconto)
	SELECT *
	FROM carsharing.utente
	WHERE (CURRENT_DATE >= bonus) AND (bonus + INTERVAL '1 year' >= (CURRENT_DATE ));

-- b) Differenza
--determinare utenti che non hanno diritto allo sconto
	SELECT *
	FROM carsharing.utente
	EXCEPT(
	SELECT * 
	From carsharing.utente
	WHERE (CURRENT_DATE >= bonus) AND (bonus + INTERVAL '1 year' >= (CURRENT_DATE ))
	);

-- c) Outer Join
SELECT ab.email, costoapplicato, professione
	FROM abbonamenti ab 
	FULL OUTER JOIN privato pr ON pr.email = ab.email;
	




-- Es 2 IN COMUNE
-- a) Insert
	INSERT INTO Utente VALUES ('utente@gmail.com', '2019-10-05', 00111);
-- b) Delete
	DELETE FROM Abbonamenti
	WHERE codiceAbbonamento <= 5;

-- c) Update
	UPDATE Parcheggio
	SET numPosti = 20
	WHERE nome = 'A';

--Es 2 ASSEGNATA
-- a) Insert
	INSERT INTO Utente (email, bonus, pin) VALUES 
		('utente2@gmail.com', '2019-07-05', 00111);
-- b) Delete
	DELETE FROM Utente
	WHERE email = 'paperino@gmail.com';
-- c) Update
	UPDATE Utente
	SET pin = 00333
	WHERE email = 'pluto@gmail.com';



--Es 3 IN COMUNE
-- a) Raggruppamento e funzioni di gruppo
 --determiniamo il numero degli abbonamenti per ogni privato che ha fatto almeno un abbonamento. 				-- Edit 14-09-19: Non funziona correttamente, da rivedere
	SELECT Privato.email, codFiscale ,count(*)
	FROM Privato
	JOIN Utente ON ( Privato.email=Utente.email)
	JOIN Abbonamenti ON (Utente.email=Abbonamenti.email)
	GROUP BY Privato.email, codFiscale;


-- b) Sotto-query
--determiniamo l'utente e l'uso il cui periodo di utilizzo sia maggiore del periodo medio degli utilizzi
	SELECT email,codicePrenotazione, data_effettivo_ritiro, orario_effettivo_ritiro, data_effettiva_consegna, orario_effettivo_consegna
	FROM Utilizzo NATURAL JOIN Prenotazione
	WHERE (Utilizzo.data_effettiva_consegna-Utilizzo.data_effettivo_ritiro) >= 
		(SELECT AVG(Utilizzo.data_effettiva_consegna-Utilizzo.data_effettivo_ritiro)
		FROM Utilizzo);

-- c) Divisione
--determinare	gli	utenti	che	hanno	utilizzato almeno	una	volta	tutte	le	vetture	nell’ultimo anno.
	SELECT DISTINCT email
	FROM Utente as U 
	WHERE NOT EXISTS (SELECT * FROM Categoria AS C
		WHERE NOT EXISTS (SELECT *
					FROM Prenotazione
					JOIN Vetture ON (Prenotazione.targa = Vetture.targa)
					WHERE email = U.email AND Vetture.tipo = c.tipoCategoria
					AND (data_ritiro + INTERVAL '1 year') >= CURRENT_DATE ));


--Es 3 ASSEGNATA
-- a) Raggruppamento e funzioni di gruppo
-- Determiniamo i conducenti con patente di categoria A1 e che sia stato coinvolto almeno in un sinistro
	SELECT Conducente.estremiPatente, catPatente, count(*)
	FROM Conducente
		JOIN Sinistro ON (Conducente.estremiPatente = Sinistro.estremiPatente)
			WHERE Conducente.catPatente = 'A1'
		GROUP BY Conducente.estremiPatente;

-- b) Sotto-query
-- Determino gli utenti le cui carte scadono prima del 2025-01-01
	SELECT Utente.email
	FROM Utente 
	JOIN Pagamento ON (Utente.email = Pagamento.email)
	WHERE (Pagamento.scadenza::timestamp < '2025-01-01');

-- c) Divisione
	SELECT DISTINCT email
	FROM Utente as U
	WHERE NOT EXISTS (SELECT * FROM Agevolazioni AS a
		WHERE NOT EXISTS (SELECT * 
							FROM Abbonamenti 
							JOIN convenzione ON (abbonamenti.codiceTipoAbbonamento = a.codiceTipoAbbonamento) 
							WHERE email = U.email AND tipoConvenzione = a.tipoconvenzione));



/**********************************************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
************************************************					FUNZIONI					***************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************************************************/

-- Parte in COMUNE
-- a) restituisce i dati significativi di un determinato codice fiscale di un privato
CREATE OR REPLACE  FUNCTION  dati_significativi( codiceFiscale VARCHAR(20))	
returns table(codFiscale VARCHAR(20),indirizzo VARCHAR(20),email VARCHAR(20) ) 
AS
$$  
BEGIN	
 
 return query 
 select Privato.codFiscale,Privato.indirizzo, Privato.email
 from Privato
 where Privato.codFiscale=codiceFiscale;

END;
$$ 
LANGUAGE plpgsql ;

select *
from dati_significativi('PLU1010PLU');

-- b) data una mail restituisce tutte le prenotazioni non ancora effettuate
CREATE OR REPLACE FUNCTION ottieniPrenotazioni( e_mail VARCHAR(20))
returns table(data_ritiro DATE, orario_ritiro TIME, email VARCHAR(20)) AS
$$  
BEGIN	
 
	RETURN query SELECT Prenotazione.data_ritiro, Prenotazione.orario_ritiro, Prenotazione.email 
	FROM Prenotazione
	WHERE (Prenotazione.data_ritiro > CURRENT_DATE) OR
	(Prenotazione.data_ritiro = CURRENT_DATE AND Prenotazione.orario_ritiro > current_time);

END;
$$ 
LANGUAGE plpgsql ;

select *
from ottieniPrenotazioni('lars@gmail.com');

-- c) dato il nome di un parcheggio restituisce la sua latitudine e longitudine
	CREATE OR REPLACE  FUNCTION  coordinate_parcheggio( nome_parcheggio VARCHAR(20))	
	returns table(latitudine NUMERIC(9,7), longitudine NUMERIC(10,7), nome VARCHAR(20) ) 
	AS
	$$  
	BEGIN	
	 
	 return query 
	 select Parcheggio.latitudine,Parcheggio.longitudine, Parcheggio.nome
	 from Parcheggio
	 where Parcheggio.nome=nome_parcheggio;

	END;
	$$ 
	LANGUAGE plpgsql ;

	select *
	from coordinate_parcheggio('A');

-- Parte ASSEGNATA
-- a) data una mail ti dice i soldi versati di quell'utente
CREATE OR REPLACE  FUNCTION  pagamento_utente( email_pagamento VARCHAR(20))	
	returns table(email VARCHAR(20), soldi_versati NUMERIC(5,2)) 
	AS
	$$  
	BEGIN	
	 
	 return query 
	 select Pagamento.email,Pagamento.soldi_versati
	 from Pagamento
	 where Pagamento.email=email_pagamento;

	END;
	$$ 
	LANGUAGE plpgsql ;

	select *
	from pagamento_utente('pluto@gmail.com');

-- b) dato un tipo abbonamento ritorna il costo e la durata di esso
CREATE OR REPLACE  FUNCTION  info_tipoabb( codTipoAbb NUMERIC(20,0))	
	returns table(codiceTipoAbbonamento NUMERIC(20,0),costo NUMERIC(6,2), durata NUMERIC(4,2)) 
	AS
	$$  
	BEGIN	
	 
	 return query 
	 select TipoAbbonamento.codiceTipoAbbonamento,TipoAbbonamento.costo, TipoAbbonamento.durata
	 from TipoAbbonamento
	 where TipoAbbonamento.codiceTipoAbbonamento=codTipoAbb;

	END;
	$$ 
	LANGUAGE plpgsql ;

	select *
	from info_tipoabb(333);

-- c) dato un estremo patente fornisce i dati relativi al conducente
CREATE OR REPLACE  FUNCTION  info_conducente( estrPat VARCHAR(10))	
	returns table(nome VARCHAR(10), cognome VARCHAR(10), estremiPatente VARCHAR(10), catPatente VARCHAR(15), emailA VARCHAR(20), emailP VARCHAR(20) ) 
	AS
	$$  
	BEGIN	
	 
	 return query 
	 select Conducente.nome,Conducente.cognome, Conducente.estremiPatente, Conducente.catPatente, Conducente.emailA, Conducente.emailP
	 from Conducente
	 where Conducente.estremiPatente=estrPat;

	END;
	$$ 
	LANGUAGE plpgsql ;

	select *
	from info_conducente('P2');




