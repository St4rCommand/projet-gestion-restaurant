       RECHERCHER_NUM_RESTAURANT.
       CLOSE frestaurants
       OPEN I-O frestaurants 
       MOVE 0 TO Wnum
       MOVE 0 TO Wfin
       PERFORM WITH TEST AFTER UNTIL Wfin = 1
         READ frestaurants NEXT
         AT END MOVE 1 TO Wfin
         ADD 1 TO Wnum 
         NOT AT END 
         IF fr_id = Wnum + 1 THEN
           MOVE fr_id TO Wnum
         ELSE 
           ADD 1 TO Wnum
           MOVE 1 TO Wfin
         END-IF
         END-READ
       END-PERFORM.
	  
       AJOUTER_RESTAURANT.
       OPEN I-O frestaurants
       PERFORM WITH TEST AFTER UNTIL Wrep = 0
        DISPLAY 'Donnez les informations sur le nouveau restaurant'
        PERFORM RECHERCHER_NUM_RESTAURANT
        MOVE Wnum TO fr_id      
        DISPLAY 'Rue dans lequelle se trouve le restaurant :'
        ACCEPT fr_rue
        DISPLAY 'Ville du restaurant :'
        ACCEPT fr_ville
        PERFORM WITH TEST AFTER UNTIL Wcp >= 1000 AND Wcp < 99999
         DISPLAY 'Code postal :'
         ACCEPT Wcp
        END-PERFORM
        MOVE Wcp TO fr_codeP 
        PERFORM WITH TEST AFTER UNTIL Wtel > 0100000000 AND Wtel < 
        0999999999
         DISPLAY 'Numero de telephone (ex: 0204124874) :'
         ACCEPT Wtel
        END-PERFORM
        MOVE Wtel TO fr_tel 
        PERFORM WITH TEST AFTER UNTIL WnbPlaces > 0
         DISPLAY 'Capacite d accueil du restaurant :'
         ACCEPT WnbPlaces
        END-PERFORM
        MOVE WnbPlaces TO fr_nbPlaces
        DISPLAY 'Site web du restaurant :'
        ACCEPT fr_sweb
        PERFORM WITH TEST AFTER UNTIL Wactif = 2 OR Wactif = 1
          DISPLAY 'Le restaurant est-il actif ? '
          DISPLAY '(2 : oui ; 1 : non) :'
          ACCEPT Wactif
        END-PERFORM
        MOVE Wactif TO fr_actif
           
        WRITE restTampon
         INVALID KEY 
          DISPLAY "Echec de l'insertion"
          NOT INVALID KEY 
          DISPLAY'Insertion OK'
        DISPLAY 'Souhaitez-vous enregistrer un nouveau restaurant ?'
          DISPLAY '0 : non, 1 : oui'
          ACCEPT Wrep
        PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
        END-PERFORM
        END-PERFORM
        CLOSE frestaurants.
		
       CONSULTER_RESTAURANT.
	   
              PERFORM WITH TEST AFTER UNTIL Wrep = 0
              OPEN INPUT frestaurants
        MOVE 0 TO Wchoix
        PERFORM WITH TEST AFTER UNTIL Wchoix <= 4 AND Wchoix > 0
         DISPLAY 'Que souhaitez vous faire ?'
         DISPLAY '1 - Voir tous les restaurants'
         DISPLAY '2 - Faire une recherche a partir de son identifiant'
         DISPLAY '3 - Faire une recherche a partir dune ville'
         ACCEPT Wchoix
        END-PERFORM
        EVALUATE Wchoix
         WHEN 1
          MOVE 0 TO Wfin
          PERFORM WITH TEST AFTER UNTIL Wfin = 1
            READ frestaurants NEXT
              AT END MOVE 1 TO Wfin
              NOT AT END 
               PERFORM AFFICHER_RESTAURANT
            END-READ
          END-PERFORM 
         WHEN 2
           MOVE 0 TO Wfin
           DISPLAY 'Donnez l identifiant du restaurant'
           ACCEPT WidResto
           MOVE WidResto TO fr_id
              READ frestaurants
            INVALID KEY
             DISPLAY 'Restaurant inexistant'
                     NOT INVALID KEY 
            PERFORM AFFICHER_RESTAURANT
         WHEN 3
                     MOVE 0 TO WvilleOK
           MOVE 0 TO Wfin
           DISPLAY 'Entrez la ville'
           ACCEPT Wville
           MOVE Wville TO fr_ville
           START frestaurants, KEY IS = fr_ville
           INVALID KEY 
            DISPLAY 'Aucun restaurant dans cette ville'
           NOT INVALID KEY
            PERFORM WITH TEST AFTER UNTIL Wfin = 1
              READ frestaurants NEXT
                AT END MOVE 1 TO Wfin
                NOT AT END
                IF Wville = fr_ville THEN
                            MOVE 1 to WvilleOK
                  PERFORM AFFICHER_RESTAURANT
                END-IF
              END-READ
            END-PERFORM
        END-EVALUATE
        CLOSE frestaurants
              DISPLAY 'Nouvelle recherche ?'
              DISPLAY '1 : OUI, 0 : NON'
        ACCEPT Wrep
        PERFORM WITH TEST AFTER UNTIL Wrep = 0 OR Wrep = 1
              END-PERFORM
              CLOSE frestaurants
       END-PERFORM.
	   
	   
              AFFICHER_RESTAURANT.
       DISPLAY '******* Identifiant :', fr_id,'*******'
              DISPLAY 'Localisation du restaurant :'
       DISPLAY '  Rue: 'fr_rue
       DISPLAY '  Ville : ',fr_ville
       DISPLAY '  Code postal : ', fr_codeP
       DISPLAY 'Numero de telephone : ',fr_tel
       DISPLAY 'Capacite d accueil : ',fr_nbPlaces
       DISPLAY 'Site web : ',fr_sweb
              IF fr_actif=0 THEN
         DISPLAY 'Restaurant actif : NON'
           ELSE
            DISPLAY 'Restaurant actif : OUI'
         END-IF
         DISPLAY '********************************'
         DISPLAY ' '.

	   
	   
       MODIFIER_RESTAURANT.
       OPEN I-O frestaurants
       MOVE 0 TO Wfin
       DISPLAY 'Id du restaurant a modifier'
       ACCEPT WidResto
       MOVE WidResto TO fr_id
       READ frestaurants
       INVALID KEY 
        DISPLAY 'Identifiant non valide'
       NOT INVALID KEY
        PERFORM AFFICHER_RESTAURANT
        
       MOVE SPACE TO Wville
       MOVE SPACE TO Wrue
       MOVE LOW-VALUE TO Wtel
       MOVE LOW-VALUE TO Wcp
       MOVE SPACE TO WsWeb
       MOVE LOW-VALUE TO WnbPlaces
       MOVE LOW-VALUE TO Wactif
		
       DISPLAY 'Donnez les nouvelles informations'
       DISPLAY 'Ville du restaurant: '
       ACCEPT Wville
       DISPLAY 'Nom de la rue: '
       ACCEPT Wrue
       PERFORM WITH TEST AFTER UNTIL (Wcp >= 1000 AND Wcp < 99999)
       OR Wcp=0
         DISPLAY 'Code postal :' 
         ACCEPT Wcp
       END-PERFORM
       PERFORM WITH TEST AFTER UNTIL (Wtel > 0100000000 AND Wtel < 
        0999999999) OR Wtel=0
         DISPLAY 'Numero de telephone (ex: 0204124874) :'
         ACCEPT Wtel
        END-PERFORM
       PERFORM WITH TEST AFTER UNTIL WnbPlaces >= 0
         DISPLAY 'Capacite d accueil du restaurant :'
         ACCEPT WnbPlaces
       END-PERFORM
       DISPLAY 'Site web: '
       ACCEPT WsWeb 
       PERFORM WITH TEST AFTER UNTIL Wactif <= 2 
        DISPLAY 'Le restaurant est-il actif ? '
        DISPLAY '(2 : oui ; 1 : non) :'
        ACCEPT Wactif
       END-PERFORM   
       IF Wville NOT EQUALS SPACE
         MOVE Wville TO fr_ville
       END-IF 
       IF Wrue NOT EQUALS SPACE
         MOVE Wrue TO fr_rue
       END-IF
       IF Wtel NOT EQUALS 0
         MOVE Wtel TO fr_tel
       END-IF 
       IF Wcp NOT EQUALS 0
         MOVE Wcp TO fr_codeP
       END-IF
       IF WsWeb NOT EQUALS SPACE
         MOVE WsWeb TO fr_sweb
       END-IF 
       IF WnbPlaces NOT EQUALS 0
         MOVE WnbPlaces TO fr_nbPlaces
       END-IF
       IF Wactif NOT EQUALS fr_actif
         MOVE Wactif TO fr_actif
       END-IF
       REWRITE restTampon
       CLOSE frestaurants.
	   
	   
       SUPPRIMER_RESTAURANT.
       OPEN I-O frestaurants
       MOVE 0 TO Wfin
       DISPLAY 'Donnez l identifiant du restaurant'
       ACCEPT fr_id
       READ frestaurants
        INVALID KEY DISPLAY 'Erreur lors de la saisie de l identifiant'
        NOT INVALID KEY
         MOVE 0 TO Wchoix
         PERFORM WITH TEST AFTER UNTIL Wchoix = 1 OR Wchoix = 0
          DISPLAY 'Etes vous sur de vouloir supprimer le restaurant ?' 
              DISPLAY '1 : OUI     0 : NON'
          ACCEPT Wchoix
         END-PERFORM
         IF Wchoix = 1 THEN
          DELETE frestaurants
          INVALID KEY
           DISPLAY 'Erreur lors de la suppression'
          NOT INVALID KEY
           DISPLAY 'Restaurant supprime'
         ELSE
          DISPLAY 'Erreur lors de la suppression'
         END-IF
       CLOSE frestaurants.
