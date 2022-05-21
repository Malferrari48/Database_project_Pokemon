
INSERT INTO tipo(nome) VALUES ('normale'), ('fuoco'), ('acqua'), ('elettro'),
                              ('erba'), ('ghiaccio'), ('lotta'), ('veleno'),
                              ('terra'), ('volante'), ('psico'), ('coleottero'),
                              ('roccia'), ('spettro'), ('drago'), ('buio'),
                              ('acciaio');

-- 1 -> not efective, 2 -> very effective, 0 -> no damage
INSERT INTO confrontotipo(da, contro, efficacia) VALUES
    ('normale', 'roccia', 1),
    ('fuoco', 'fuoco', 1),
    ('fuoco', 'acqua', 1),
    ('fuoco', 'erba', 2),
    ('fuoco', 'ghiaccio', 2),
    ('fuoco', 'roccia', 1),
    ('acqua', 'fuoco', 2),
    ('acqua', 'acqua', 1),
    ('acqua', 'erba', 1),
    ('acqua', 'terra', 2),
    ('acqua', 'roccia', 2),
    ('elettro', 'acqua', 2),
    ('elettro', 'elettro', 1),
    ('elettro', 'erba', 1),
    ('elettro', 'terra', 0),
    ('elettro', 'volante', 2),
    ('erba', 'fuoco', 1),
    ('erba', 'acqua', 2),
    ('erba', 'erba', 1),
    ('erba', 'veleno', 1),
    ('erba', 'terra', 2),
    ('erba', 'volante', 1),
    ('erba', 'roccia', 2),
    ('ghiaccio', 'fuoco', 1),
    ('ghiaccio', 'acqua', 1),
    ('ghiaccio', 'erba', 2),
    ('ghiaccio', 'ghiaccio', 1),
    ('ghiaccio', 'terra', 2),
    ('ghiaccio', 'volante', 2),
    ('lotta', 'normale', 2),
    ('lotta', 'erba', 2),
    ('lotta', 'veleno', 1),
    ('lotta', 'volante', 1),
    ('lotta', 'psico', 1),
    ('lotta', 'roccia', 2),
    ('lotta', 'buio', 2),
    ('veleno', 'erba', 2),
    ('veleno', 'veleno', 1),
    ('veleno', 'terra', 1),
    ('veleno', 'roccia', 1),
    ('terra', 'fuoco', 2),
    ('terra', 'elettro', 2),
    ('terra', 'erba', 1),
    ('terra', 'veleno', 2),
    ('terra', 'volante', 0),
    ('terra', 'roccia', 2),
    ('volante', 'elettro', 1),
    ('volante', 'erba', 2),
    ('volante', 'lotta', 2),
    ('volante', 'roccia', 1),
    ('psico', 'lotta', 2),
    ('psico', 'veleno', 2),
    ('psico', 'psico', 1),
    ('psico', 'buio', 0),
    ('roccia', 'fuoco', 2),
    ('roccia', 'ghiaccio', 2),
    ('roccia', 'lotta', 1),
    ('roccia', 'terra', 1),
    ('roccia', 'volante', 2),
    ('buio', 'lotta', 1),
    ('buio', 'psico', 2),
    ('buio', 'buio', 1);


INSERT INTO pokemon (id, nome, descrizione, zona_cattura, percentuale_sesso, tipo1, tipo2) VALUES
    (1, 'Bulbasaur', 'Fin dalla nascita questo Pokémon ha sulla schiena un seme che cresce lentamente', 'Evento', 87.5, 'erba', 'veleno'),
    (2, 'Ivysaur', 'Il bulbo sulla schiena è cresciuto così tanto da impedirgli di alzarsi in piedi sulle zampe posteriori', 'Evento', 87.5, 'erba', 'veleno'),
    (3, 'Venusaur', 'Il fiore sboccia assorbendo energia solare. Si muove continuamente in cerca di luce', 'Evento', 87.5, 'erba', 'veleno'),
    (4, 'Charmander', 'Ama le cose calde. Si dice che quando piove gli esca vapore dalla punta della coda', 'Evento', 87.5, 'fuoco', NULL),
    (5, 'Charmeleon', 'Ha un''indole feroce. Usa la coda fiammeggiante come una frusta e lacera l''avversario con gli artigli affilati. ', 'Evento', 87.5, 'fuoco', NULL),
    (6, 'Charizard', 'Sputa fiamme incandescenti in grado di fondere le rocce. A volte causa incendi boschivi', 'Evento', 87.5, 'fuoco', 'volante'),
    (7, 'Squirtle', 'Quando ritrae il lungo collo dentro la corazza sputa un vigoroso getto d''acqua', 'Evento', 87.5, 'acqua', NULL),
    (8, 'Wartortle', 'È considerato un simbolo di longevità. Se c''è del muschio sul suo guscio, significa che è molto anziano', 'Evento', 87.5, 'acqua', NULL),
    (9, 'Blastoise', 'Mette KO gli avversari schiacciandoli sotto il corpo possente. Se è in difficoltà, può ritrarsi nella corazza', 'Evento', 87.5, 'acqua', NULL),
    (25, 'Pikachu', 'Più potente è l''energia elettrica prodotta dal Pokémon, più le sacche sulle sue guance sono morbide ed elastiche', 'Foresta', 50, 'elettro', NULL),
    (26, 'Raichu', 'La sua lunga coda serve da messa a terra per proteggerlo dalla sua stessa alta tensione', 'Foresta', 50, 'elettro', NULL),
    (37, 'Vulpix', 'Quando è giovane ha sei meravigliose code, che si moltiplicano durante la sua crescita', 'Erba alta', 25, 'fuoco', NULL),
    (38, 'Ninetails', 'Dicono che viva un millennio. Ognuna delle sue code è dotata di un potere magico', 'Erba alta', 25, 'fuoco', NULL),
    (52, 'Meowth', 'Ama raccogliere oggetti luccicanti. Quando è di buon umore mostra la sua collezione anche al suo Allenatore', 'Erba alta', 50, 'normale', NULL),
    (95, 'Onix', 'Scava nel terreno assorbendo gli oggetti più duri per irrobustire il suo corpo', 'Caverna', 50, 'roccia', 'terra'),
    (120, 'Staryu', 'Alla fine dell''estate, sui litorali è possibile osservare gruppi di Staryu che emettono luce a un ritmo regolare'', ''Scava nel terreno assorbendo gli oggetti più duri per irrobustire il suo corpo', 'Spiaggia', NULL, 'acqua', NULL),
    (121, 'Starmie', 'Quando scatena i suoi poteri psichici, l''organo centrale, detto nucleo, brilla di sette colori diversi', 'Spiaggia', NULL, 'acqua', 'psico'),
    (133, 'Eevee', 'Ha la capacità di alterare la propria struttura corporea per adattarsi all’ambiente circostante', 'Erba alta', 87.5, 'normale', NULL),
    (134, 'Vaporeon', 'Se le pinne di Vaporeon iniziano a vibrare, vuol dire che pioverà nel giro di poche ore', 'Erba alta', 87.5, 'acqua', NULL),
    (135, 'Jolteon', 'Se si arrabbia o è sorpreso, tutti i peli del corpo gli si rizzano trasformandosi in aghi che infilzano il nemico', 'Erba alta', 87.5, 'elettro', NULL),
    (136, 'Flareon', 'Quando immagazzina abbastanza calore, la sua temperatura corporea può salire fino a 900 ºC', 'Erba alta', 87.5, 'fuoco', NULL),
    (150, 'Mewtwo', 'Il suo DNA è quasi uguale a quello di Mew. Ciò nonostante, sono agli antipodi per dimensioni e carattere', 'Evento', NULL, 'psico', NULL),
    (151, 'Mew', 'Osservando al microscopio la pelle di Mew si può constatare che è ricoperta da una fitta peluria, corta e fine', 'Evento', NULL, 'psico', NULL),
    (152, 'Chikorita', 'Nella lotta, Chikorita sventola la sua foglia in modo da tenere a bada il nemico. Tuttavia, la foglia emana anche un aroma dolce, che calma il Pokémon avversario, creando un''atmosfera gradevole e rilassata tutt''attorno', 'Evento', 87.5, 'erba', NULL),
    (153, 'Bayleef', 'Il collo di Bayleef è agghindato da foglie, dentro cui è presente il piccolo germoglio di un albero. L''aroma emanato da questo germoglio ha un effetto energizzante sull''uomo', 'Evento', 87.5, 'erba', NULL),
    (154, 'Meganium', 'L''aroma del fiore di Meganium placa le emozioni. Nella lotta questo Pokémon emana un profumo con effetto calmante per smorzare l''aggressività del nemico', 'Evento', 87.5, 'erba', NULL),
    (155, 'Cyndaquil', 'Cyndaquil si protegge grazie alle fiamme che gli ardono sul dorso. Le fiamme divampano impetuose se il Pokémon è adirato. Tuttavia, quando è stanco diventano fiammelle innocue dalla combustione incompleta', 'Evento', 87.5, 'fuoco', NULL),
    (156, 'Quilava', 'Quilava tiene a bada il nemico grazie all''intensità delle sue fiamme e a getti di aria rovente. Questo Pokémon sfrutta la sua estrema destrezza per evitare gli attacchi anche mentre ustiona il nemico', 'Evento', 87.5, 'fuoco', NULL),
    (157, 'Typhlosion', 'Typhlosion si nasconde avvolto da una lucente nube di calore creata dalle sue fiamme roventi. Questo Pokémon crea esplosioni spettacolari che riducono in cenere ogni cosa', 'Evento', 87.5, 'fuoco', NULL),
    (158, 'Totodile', 'Nonostante il suo corpicino minuto, le mascelle di Totodile sono molto potenti. Sebbene creda solo di giocare, il suo morso è così forte e pericoloso da causare serie ferite', 'Evento', 87.5, 'acqua', NULL),
    (159, 'Croconaw', 'Una volta azzannato il nemico, Croconaw non molla la presa facilmente. Le zanne a punta ricurva all''indietro, a mo'' di amo da pesca, rendono impossibile estrarle quando sono conficcate in profondità', 'Evento', 87.5, 'acqua', NULL),
    (160, 'Feraligatr', 'Feraligatr spaventa il nemico spalancando la sua bocca enorme. Nella lotta pesta pesantemente il terreno con le sue possenti zampe posteriori per scagliarsi contro il nemico a un''incredibile velocità', 'Evento', 87.5, 'acqua', NULL),
    (196, 'Espeon', 'Analizza le correnti d’aria per predire le condizioni atmosferiche o la prossima mossa del nemico', 'Erba alta', 87.5, 'psico', NULL),
    (197, 'Umbreon', 'Quando si arrabbia, spruzza dai pori un sudore velenoso mirando agli occhi del suo avversario', 'Erba alta', 87.5, 'buio', NULL),
    (243, 'Raikou', 'Raikou rappresenta la velocità del fulmine. Il suo ruggito crea terrificanti onde d''urto nell''aria e scuote il suolo come se fosse percosso dalla furia di un fulmine durante il temporale', 'Erba alta', NULL, 'elettro', NULL),
    (244, 'Entei', 'Entei rappresenta l''ardore del magma. Si narra che questo Pokémon sia nato dall''eruzione di un vulcano. Emette lingue di fuoco così violente da incenerire tutto ciò che lambiscono', 'Erba alta', NULL, 'fuoco', NULL),
    (245, 'Suicune', 'Suicune rappresenta la purezza delle sorgenti d''acqua dolce. Corre con grazia immerso nella natura. Questo Pokémon ha la facoltà di depurare le acque di scarico', 'Erba alta', NULL, 'acqua', NULL),
    (249, 'Lugia', 'Le ali di Lugia hanno un''enorme potenza distruttiva: un leggero battito d''ali è in grado di abbattere una normale abitazione. Perciò il Pokémon ha scelto di vivere lontano dall''uomo, nelle profondità abissali', 'Evento', NULL, 'psico', 'volante'),
    (250, 'Ho-oh', 'Il piumaggio di Ho-Oh brilla in sette colori a seconda dell''angolazione dei raggi luminosi. Si dice che le sue piume portino felicità a chi le possiede. Si narra che viva ai piedi di un arcobaleno', 'Evento', NULL, 'fuoco', 'volante');

    
INSERT INTO evoluzione(da, a, livello, richieste) VALUES
    (1, 2, 16, NULL),-- Bulbasaur -> Ivysaur -> Venusaur
    (2, 3, 32, NULL),
    (4, 5, 16, NULL),-- Charmander -> Charmeleon -> Charizard
    (5, 6, 36, NULL),
    (7, 8, 16, NULL),-- Squirtle -> Wartortle -> Blastoise
    (8, 9, 36, NULL),
    (25, 26, NULL, 'Use Thunder Stone'), -- Pikachu -> Raichu
    (37, 38, NULL, 'Use Fire Stone'), -- Vulpix -> Ninetails
    (133, 134, NULL, 'Use Water Stone'), -- Eeve -> Vaporeon
    (133, 135, NULL, 'Use Thunder Stone'), -- Eeve -> Jolteon
    (133, 136, NULL, 'Use Fire Stone'), -- Eeve -> Flareon
    (152, 153, 16, NULL), -- Chikorita -> Bayleef -> Meganium
    (153, 154, 32, NULL),
    (155, 156, 16, NULL), -- Cyndaquil -> Quilava -> Typhlosion
    (156, 157, 32, NULL),
    (158, 159, 16, NULL), -- Totodile -> Croconaw -> Feraligatr
    (159, 160, 32, NULL),
    (133, 196, NULL, 'Have high friendship (day)'), -- Eeve -> Espeon
    (133, 197, NULL, 'Have high friendship (night)'); -- Eeve -> Umbreon
    
    
INSERT INTO mossa(nome, tipo, is_tm, categoria, potenza) VALUES
    ('Graffio', 'normale', false, 'Fisica', 40), ----------Gen I
    ('Frustata', 'erba', false, 'Fisica', 45),
    ('Azione', 'normale', false, 'Fisica', 40),
    ('Riduttore', 'normale', true, 'Fisica', 90),
    ('Sdoppiatore', 'normale', true, 'Fisica', 120),
    ('Colpocoda', 'normale', false, 'Stato', 0),
    ('Morso', 'buio', false, 'Fisica', 60),
    ('Ruggito', 'normale', false, 'Stato', 0),
    ('Braciere', 'fuoco', false, 'Speciale', 40),
    ('Lanciafiamme', 'fuoco', false, 'Speciale', 90),
    ('Pistolacqua', 'acqua', false, 'Speciale', 40),
    ('Idropompa', 'acqua', false, 'Speciale', 110),
    ('Parassiseme', 'erba', false, 'Stato', 0),
    ('Crescita', 'normale', false, 'Stato', 0),
    ('Foglielama', 'erba', false, 'Fisica', 55),
    ('Solarraggio', 'erba', true, 'Speciale', 120),
    ('Velenpolvere', 'veleno', false, 'Stato', 0),
    ('Sonnifero', 'erba', false, 'Stato', 0),
    ('Petalodanza', 'erba', false, 'Speciale', 120),
    ('Ira di Drago', 'drago', false, 'Speciale', 0),
    ('Ira', 'normale', true, 'Fisica', 20),
    ('Muro di Fumo', 'normale', false, 'Stato', 0),
    ('Ritirata', 'acqua', false, 'Stato', 0),
    ('Lacerazione', 'normale', false, 'Fisica', 70),
    ('Bolla', 'acqua', false, 'Speciale', 40),
    ('Capocciata', 'normale', false, 'Fisica', 130),
    ('Profumino', 'normale', false, 'Stato', 0), ----------Gen II
    ('Sintesi', 'erba', false, 'Stato', 0),
    ('Visotruce', 'normale', false, 'Stato', 0),
    ('Rapigiro', 'normale', false, 'Fisica', 50),
    ('Protezione', 'normale', false, 'Stato', 0),
    ('Pioggiadanza', 'acqua', false, 'Stato', 0);
    
INSERT INTO imparamossa(pokemon, mossa, partenza) VALUES
    (1, 'Azione', true),
    (1, 'Ruggito', false),
    (1, 'Parassiseme', false),
    (1, 'Frustata', false),
    (1, 'Velenpolvere', false),
    (1, 'Sonnifero', false),
    (1, 'Foglielama', false),
    (1, 'Profumino', false),
    (1, 'Crescita', false),
    (1, 'Sintesi', false),
    (1, 'Solarraggio', false),
    (2, 'Riduttore', false),
    (2, 'Sdoppiatore', false),
    (3, 'Petalodanza', false),
    (4, 'Graffio', false),
    (4, 'Ruggito', false),
    (4, 'Braciere', false),
    (4, 'Muro di Fumo', false),
    (4, 'Ira', false),
    (4, 'Visotruce', false),
    (5, 'Lanciafiamme', false),
    (5, 'Lacerazione', false),
    (6, 'Ira di Drago', false),
    (7, 'Azione', true),
    (7, 'Colpocoda', false),
    (7, 'Bolla', false),
    (7, 'Ritirata', false),
    (7, 'Pistolacqua', false),
    (8, 'Morso', false),
    (8, 'Rapigiro', false),
    (8, 'Protezione', false),
    (9, 'Pioggiadanza', false),
    (9, 'Capocciata', false),
    (9, 'Idropompa', false);

INSERT INTO ZonaCatturaPokemonGo(stato, citta, tipo_zona, pokemon) VALUES
    ('Italia', 'Modena', 'Urbano', 151), -- Mew
    ('Italia', 'Sozzigalli', 'Rurale', 37), -- Vulpix
    ('Italia', 'Rimini', 'Mare', 120); -- Staryu


INSERT INTO gioco(nome, data_rilascio, casa_sviluppo) VALUES
    ('Pokemon Red/Blue', '1996-02-27', 'Nintendo'),
    ('Pokemon Gold/Silver', '1999-11-21', 'Nintendo');
    
INSERT INTO pokemoningioco(pokemon, gioco, is_leggendario) VALUES
    (1, 'Pokemon Red/Blue', false),
    (2, 'Pokemon Red/Blue', false),
    (3, 'Pokemon Red/Blue', false),
    (4, 'Pokemon Red/Blue', false),
    (5, 'Pokemon Red/Blue', false),
    (6, 'Pokemon Red/Blue', false),
    (7, 'Pokemon Red/Blue', false),
    (8, 'Pokemon Red/Blue', false),
    (9, 'Pokemon Red/Blue', false),
    (25, 'Pokemon Red/Blue', false),
    (26, 'Pokemon Red/Blue', false),
    (37, 'Pokemon Red/Blue', false),
    (38, 'Pokemon Red/Blue', false),
    (95, 'Pokemon Red/Blue', false),
    (120, 'Pokemon Red/Blue', false),
    (121, 'Pokemon Red/Blue', false),
    (133, 'Pokemon Red/Blue', false),
    (134, 'Pokemon Red/Blue', false),
    (135, 'Pokemon Red/Blue', false),
    (136, 'Pokemon Red/Blue', false),
    (150, 'Pokemon Red/Blue', true),
    (151, 'Pokemon Red/Blue', true),
    (1, 'Pokemon Gold/Silver', false),
    (2, 'Pokemon Gold/Silver', false),
    (3, 'Pokemon Gold/Silver', false),
    (4, 'Pokemon Gold/Silver', false),
    (5, 'Pokemon Gold/Silver', false),
    (6, 'Pokemon Gold/Silver', false),
    (7, 'Pokemon Gold/Silver', false),
    (8, 'Pokemon Gold/Silver', false),
    (9, 'Pokemon Gold/Silver', false),
    (25, 'Pokemon Gold/Silver', false),
    (26, 'Pokemon Gold/Silver', false),
    (37, 'Pokemon Gold/Silver', false),
    (38, 'Pokemon Gold/Silver', false),
    (95, 'Pokemon Gold/Silver', false),
    (120, 'Pokemon Gold/Silver', false),
    (121, 'Pokemon Gold/Silver', false),
    (133, 'Pokemon Gold/Silver', false),
    (134, 'Pokemon Gold/Silver', false),
    (135, 'Pokemon Gold/Silver', false),
    (136, 'Pokemon Gold/Silver', false),
    (150, 'Pokemon Gold/Silver', false),
    (151, 'Pokemon Gold/Silver', false),
    (152, 'Pokemon Gold/Silver', false),
    (153, 'Pokemon Gold/Silver', false),
    (154, 'Pokemon Gold/Silver', false),
    (155, 'Pokemon Gold/Silver', false),
    (156, 'Pokemon Gold/Silver', false),
    (157, 'Pokemon Gold/Silver', false),
    (158, 'Pokemon Gold/Silver', false),
    (159, 'Pokemon Gold/Silver', false),
    (160, 'Pokemon Gold/Silver', false),
    (196, 'Pokemon Gold/Silver', false),
    (197, 'Pokemon Gold/Silver', false),
    (243, 'Pokemon Gold/Silver', false),
    (244, 'Pokemon Gold/Silver', true),
    (245, 'Pokemon Gold/Silver', true),
    (249, 'Pokemon Gold/Silver', true),
    (250, 'Pokemon Gold/Silver', true);
    
INSERT INTO dispositivoconsole (nome, data_rilascio, portatile) VALUES
    ('Game Boy', '1989-04-21', true),
    ('Game Boy Color', '1998-08-23', true);
    
INSERT INTO pubblicazioneconsole(gioco, dispositivo) VALUES
    ('Pokemon Red/Blue', 'Game Boy'),
    ('Pokemon Gold/Silver', 'Game Boy Color');
    
INSERT INTO personaggio (nome, cognome, rappresenta_pokemon) VALUES
    ('Ash', 'Ketchum', NULL),
    ('Misty', 'Williams', NULL),
    ('Brock', 'Harrison', NULL),
    ('Rosso','', NULL),
    ('Jesse','', NULL),
    ('James','', NULL),
    ('Meowth','', 52),
    ('Pikachu','',25);

INSERT INTO pokemonpossesso (personaggio_nome, personaggio_cognome, pokemon) VALUES
    ('Ash', 'Ketchum', 25), -- Pikachu
    ('Ash', 'Ketchum', 6), -- Charizard
    ('Misty', 'Williams', 120), -- Staryu
    ('Brock', 'Harrison', 95),  -- Onix
    ('Brock', 'Harrison', 37);  -- Vulpix
    
INSERT INTO multimedia (nome, anno, casa_produzione, creatore, tipo_multimediale) VALUES
    ('Pokémon il film - Mewtwo colpisce ancora', 1998, 'Oriental Light And Magic', 'Kunihiko Yuyama', 'Film anime'),
    ('Pokémon 2 - La forza di uno', 1999, 'Oriental Light And Magic', 'Kunihiko Yuyama', 'Film anime'),
    ('Pocket Monsters Sekiei League', 1997, 'Oriental Light And Magic', 'Takeshi Shudō', 'Serie anime'),
    ('Pokémon Adventures', 2002, 'Shogakukan', 'Hidenori Kusaka', 'Manga'),
    ('Pokémon 3 - L''incantesimo degli Unown', 2000, 'Oriental Light And Magic', 'Kunihiko Yuyama', 'Film anime');

INSERT INTO comparein (pokemon, multimedia_nome, multimedia_anno) VALUES
    (150, 'Pokémon il film - Mewtwo colpisce ancora', 1998), -- Mewtwo
    (151, 'Pokémon il film - Mewtwo colpisce ancora', 1998), -- Mew
    (25, 'Pokémon il film - Mewtwo colpisce ancora', 1998), -- Pikachu
    (37, 'Pokémon il film - Mewtwo colpisce ancora', 1998), -- Vulpix
    (120, 'Pokémon il film - Mewtwo colpisce ancora', 1998), -- Startyu
    (52, 'Pokémon il film - Mewtwo colpisce ancora', 1998), -- Meowth
    (25, 'Pokémon 2 - La forza di uno', 1999), -- Pikachu
    (1, 'Pokémon 2 - La forza di uno', 1999), -- Bulbasaur
    (6, 'Pokémon 2 - La forza di uno', 1999), -- Charizard
    (7, 'Pokémon 2 - La forza di uno', 1999), -- Squirtle
    (120, 'Pokémon 2 - La forza di uno', 1999), -- Staryu
    (1, 'Pocket Monsters Sekiei League', 1997), -- Bulbasaur
    (4, 'Pocket Monsters Sekiei League', 1997), -- Charmander
    (7, 'Pocket Monsters Sekiei League', 1997), -- Squirtle
    (25, 'Pocket Monsters Sekiei League', 1997), -- Pikachu
    (52, 'Pocket Monsters Sekiei League', 1997), -- Meowth
    (25, 'Pokémon Adventures', 2002), -- Pikachu
    (150, 'Pokémon Adventures', 2002), -- Mewtwo
    (4, 'Pokémon Adventures', 2002); -- Charmander
    
INSERT INTO comparsa (personaggio_nome, personaggio_cognome, multimedia_nome, multimedia_anno) VALUES
    ('Ash', 'Ketchum',      'Pokémon il film - Mewtwo colpisce ancora', 1998),
    ('Misty', 'Williams',   'Pokémon il film - Mewtwo colpisce ancora', 1998),
    ('Brock', 'Harrison',   'Pokémon il film - Mewtwo colpisce ancora', 1998),
    ('Pikachu', '',   'Pokémon il film - Mewtwo colpisce ancora', 1998),
    ('Ash', 'Ketchum',      'Pokémon 2 - La forza di uno', 1999),
    ('Misty', 'Williams',   'Pokémon 2 - La forza di uno', 1999),
    ('Brock', 'Harrison',   'Pokémon 2 - La forza di uno', 1999),
    ('Pikachu', '',   'Pokémon 2 - La forza di uno', 1999),
    ('Ash', 'Ketchum',      'Pokémon 3 - L''incantesimo degli Unown', 2000),
    ('Misty', 'Williams',   'Pokémon 3 - L''incantesimo degli Unown', 2000),
    ('Brock', 'Harrison',   'Pokémon 3 - L''incantesimo degli Unown', 2000),
    ('Pikachu', '',   'Pokémon 3 - L''incantesimo degli Unown', 2000),
    ('Ash', 'Ketchum',      'Pocket Monsters Sekiei League', 1997),
    ('Misty', 'Williams',   'Pocket Monsters Sekiei League', 1997),
    ('Brock', 'Harrison',   'Pocket Monsters Sekiei League', 1997),
    ('Jesse', '', 'Pocket Monsters Sekiei League', 1997),
    ('James', '', 'Pocket Monsters Sekiei League', 1997),
    ('Meowth', '', 'Pocket Monsters Sekiei League', 1997),
    ('Pikachu', '', 'Pocket Monsters Sekiei League', 1997),
    ('Rosso', '', 'Pokémon Adventures', 2002);
    
INSERT INTO doppiatore (cod_fis, nome, cognome, data_nascita) VALUES
    ('GRBDVD68P24C722H', 'Davide', 'Garbolino', '1968-09-24'),
    ('KRPLSN63D70F205K', 'Alessandra', 'Karpoff', '1963-04-30'),
    ('CRRNCL63D30E463K', 'Nicola', 'Carrassi', '1971-08-01'),
    ('MTSRCI68S70F257Y', 'Rica', 'Matsumoto', '1968-11-30'),
    ('BTTLCU67L01F205O', 'Luca', 'Bottale', '1967-07-01'),
    ('NTCSRH87P60A944R', 'Sarah', 'Natochenny', '1987-09-20'),
    ('BLDPTR55P21F205G', 'Pietro', 'Ubaldi', '1955-09-21'),
    ('CLVGPP62T09L781I', 'Giuseppe', 'Calvetti', '1962-12-09'),
    ('TNOKIU65M18L424U', 'Ikue', 'Otani', '1965-08-18');

INSERT INTO doppiaggio (personaggio_nome, personaggio_cognome, multimedia_nome, multimedia_anno, lingua, doppiatore) VALUES
    ('Ash', 'Ketchum',    'Pokémon il film - Mewtwo colpisce ancora', 1998, 'Italiano', 'GRBDVD68P24C722H'),
    ('Ash', 'Ketchum',    'Pocket Monsters Sekiei League', 1997, 'Italiano', 'GRBDVD68P24C722H'),
    ('Ash', 'Ketchum',    'Pokémon 2 - La forza di uno', 1999, 'Italiano', 'GRBDVD68P24C722H'),
    ('Ash', 'Ketchum',    'Pokémon 3 - L''incantesimo degli Unown', 2000, 'Italiano', 'GRBDVD68P24C722H'),
    ('Ash', 'Ketchum',    'Pokémon il film - Mewtwo colpisce ancora', 1998, 'Giapponese', 'MTSRCI68S70F257Y'),
    ('Ash', 'Ketchum',    'Pokémon il film - Mewtwo colpisce ancora', 1998, 'Inglese' , 'NTCSRH87P60A944R'),
    ('Misty', 'Williams', 'Pokémon il film - Mewtwo colpisce ancora', 1998, 'Italiano', 'KRPLSN63D70F205K'),
    ('Misty', 'Williams', 'Pocket Monsters Sekiei League', 1997, 'Italiano', 'KRPLSN63D70F205K'),
    ('Misty', 'Williams', 'Pokémon 2 - La forza di uno', 1999, 'Italiano', 'KRPLSN63D70F205K'),
    ('Misty', 'Williams', 'Pokémon 3 - L''incantesimo degli Unown', 2000, 'Italiano', 'KRPLSN63D70F205K'),
    ('Brock', 'Harrison', 'Pokémon il film - Mewtwo colpisce ancora', 1998, 'Italiano', 'CRRNCL63D30E463K'),
    ('Brock', 'Harrison', 'Pocket Monsters Sekiei League', 1997, 'Italiano', 'CRRNCL63D30E463K'),
    ('Brock', 'Harrison', 'Pocket Monsters Sekiei League', 1997, 'Italiano', 'BTTLCU67L01F205O'),
    ('Brock', 'Harrison', 'Pokémon 3 - L''incantesimo degli Unown', 2000, 'Italiano', 'BTTLCU67L01F205O'),
    ('Meowth', '', 'Pocket Monsters Sekiei League', 1997, 'Italiano', 'CLVGPP62T09L781I'),
    ('Meowth', '', 'Pocket Monsters Sekiei League', 1997, 'Italiano', 'BLDPTR55P21F205G'),
    ('Pikachu', '',    'Pokémon il film - Mewtwo colpisce ancora', 1998, 'Giapponese', 'TNOKIU65M18L424U'),
    ('Pikachu', '',    'Pokémon il film - Mewtwo colpisce ancora', 1998, 'Italiano', 'TNOKIU65M18L424U'),
    ('Pikachu', '',    'Pokémon il film - Mewtwo colpisce ancora', 1998, 'Inglese' , 'TNOKIU65M18L424U'),
    ('Pikachu', '',    'Pocket Monsters Sekiei League', 1997, 'Giapponese', 'TNOKIU65M18L424U'),
    ('Pikachu', '',    'Pocket Monsters Sekiei League', 1997, 'Italiano', 'TNOKIU65M18L424U'),
    ('Pikachu', '',    'Pocket Monsters Sekiei League', 1997, 'Inglese' , 'TNOKIU65M18L424U');
