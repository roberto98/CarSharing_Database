# CarSharing Database
📚 Progetto per l'esame "Basi di Dati" (UniGe - Informatica)

## 

La	definizione	della	base	di	dati	(comandi	CREATE	TABLE)	con	i	relativi	vincoli1 deve	essere	relativa	
all’intera	base	di	dati	progettata.
Per	i	rimanenti	punti, viene	richiesto	di:
  (a) coprire	la	porzione	di	base	di	dati	relativa	a	vetture,	modelli,	parcheggi,	abbonamenti,	
      prenotazioni	e	effettivi	utilizzi
  (b) gestione	delle	diverse	tipologie	di	utenti,	conducenti	abilitati,	bonus,	modalitàdi	
      pagamento
      
Per la	base	di	dati	risultante,	viene	richiesto di	realizzare	il	popolamento,	la definizione	delle	operazioni	di	manipolazione interrogazioni	e	modifiche,	delle	procedure	di gestione	e	dei	trigger per	il	controllo	dei	vincoli.

In	particolare,	per	le	operazioni	di	manipolazione	si	richiede	di prevedere:

0. la	definizione	di	una	vista	Fatturazione	che	per	ogni	utilizzo	concluso	calcoli	e	visualizzi	in diverse	colonne	l’importo	dovuto	per	l’utilizzo	in	accordo	alle	diverse	possibili	tariffe,	se applicabili,	senza	tenere	conto	di	bonus	e	penali.	

1. alcune	(almeno	tre) interrogazioni	semplici (=	di	gestione) per	ogni	porzione coperta (comune,	a	scelta),	di	cui	almeno	una	con	differenza e	una	con outer	join.	Ad	esempio,	per	la	porzione comune:
    a. determinare tra i parcheggi	in	cui	sia	disponibile	nelle	prossime	tre	ore	una	vettura	di una	certa	categoria	il	più vicino	alla	posizione	attuale	
    b. determinare tutti gli utenti con eventualmente associate nome e targa delle vetture che hanno attualmente	in uso e l’indicazione di quando è prevista la	            riconsegna
    c. determinare	i	parcheggi	che	contengono	(attualmente)	almeno	una	vettura,	per	cui	non	risultino	prenotazioni	nella	prossima	ora,	per	ogni	categoria	che	        ospitano.	
    
2. alcune	(almeno	tre,	almeno	una	per	tipo	-inserimento,	cancellazione,	modifica)	operazioni	di	manipolazione,	per	ogni	porzione	coperta,	selezionando	opportunamente	operazioni	significative	(ad	es.	rispetto	ai	vincoli	di	integrità)

3. alcune	(almeno	tre)	interrogazioni	di	analisi	per	ogni	porzione	coperta,	di	cui	almeno	una	con
raggruppamento	e	funzioni di	gruppo,	una	con sotto-interrogazione	correlata	e	una	di	
divisione.	Ad	esempio,	per	la	porzione	comune:	
    a. data	una	vettura,	determinare	i	suoi	utilizzi	nell’ultima	settimana,	determinandone	la	durata	di	minuti	effettivi	di utilizzo,	quelli	in	cui	era	          disponibile,	quelli	in	cui	era	prenotata	ma	non	utilizzata	
    b. determinare	il	parcheggio	le	cui	vetture nell’ultimo	mese	sono	state	utilizzate	per	periodi	più	lunghi	dell’utilizzo	mensile	medio	delle	vetture	di	          tale	categoria
    c. determinare	gli	utenti	che	hanno	utilizzato almeno	una	volta	tutte	le	vetture	nell’ultimo anno
    
    
Inoltre,	 si	richiede	di	definire:

    • almeno	tre	procedure/funzioni	per	ogni	porzione	coperta	(ad	esempio,	per	realizzare	interrogazioni	parametriche	o	operazioni	di	manipolazione	               complesse)
    • tutti	i	trigger	che	si	ritengono	necessari per	l’implementazione	dei	vincoli	e	delle	regole	operative	per	le	porzioni	coperte,	o	comunque	di	realizzarne	alcuni	ed	esplicitare	quali	altri	sarebbero	da	realizzare	ma	non	sono	stati	completati	per	mancanza	di	tempo/perché	non	ritenuti	particolarmente significativi.
    • Relativamente	alla	fatturazione	degli	utilizzi,	a	partire	dall’importo	come	in	0	andràselezionato	il	più conveniente	applicandovi	penali	e	bonus	cosı̀ come	nella	porzione	specifica	assegnata	al	gruppo.
    [ProgettoBD2018-19-2fasi-SecondaFase-1.pdf](https://github.com/roberto98/CarSharing_Database/files/9003061/ProgettoBD2018-19-2fasi-SecondaFase-1.pdf)
