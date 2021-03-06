      ******************** AJOUTER_MENU *******************
      * Ajouter un menu
      * Saisir son nom, puis saisir le nom de l'entrée, du
      * plat et du dessert
      * Si un des noms n'existe pas, alors vous devez le
      * saisir à nouveau
      ******************************************************
       AJOUTER_MENU.

       DISPLAY '|====================================|'
       DISPLAY '|=========== AJOUT        ===========|'
       DISPLAY '|===========      DE      ===========|'
       DISPLAY '|===========         MENU ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

        OPEN I-O fmenus
        MOVE 0 TO Wfin
        PERFORM WITH TEST AFTER UNTIL Wfin = 1
         DISPLAY 'Saisir le nom du menu :'
         ACCEPT fm_nom
         DISPLAY '--------------------------------------'
         DISPLAY ' '
         
         WRITE mTampon END-WRITE
         IF fp_stat = 0 THEN
         
         OPEN INPUT fplats
         MOVE 0 TO WprixCarte
         MOVE 0 TO Wfin

         PERFORM WITH TEST AFTER UNTIL Wfin = 1
          DISPLAY 'Nom de lentrée : '     
          ACCEPT fp_nom
 
          READ fplats
          INVALID KEY
           DISPLAY 'Aucune entrée ne porte ce nom'
          NOT INVALID KEY
           IF fp_type = 'Entrée'
            MOVE fp_nom TO fm_entree
            ADD fp_prix TO WprixCarte
             MOVE 1 TO Wfin
           ELSE
            DISPLAY 'Aucune entrée ne porte ce nom'
           END-IF
          END-READ
         END-PERFORM

         MOVE 0 TO Wfin
         PERFORM WITH TEST AFTER UNTIL Wfin = 1
          DISPLAY 'Nom du plat : '     
          ACCEPT fp_nom
          READ fplats
          INVALID KEY
           DISPLAY 'Aucun plat ne porte ce nom'
          NOT INVALID KEY
           IF fp_type = 'Plat'
           MOVE fp_nom TO fm_plat
            ADD fp_prix TO WprixCarte
            MOVE 1 TO Wfin
           ELSE
            DISPLAY 'Aucun plat ne porte ce nom'
           END-IF
          END-READ
         END-PERFORM
  
         MOVE 0 TO Wfin
         PERFORM WITH TEST AFTER UNTIL Wfin = 1
          DISPLAY 'Nom du dessert : '     
          ACCEPT fp_nom
          READ fplats
          INVALID KEY
           DISPLAY 'Aucun dessert ne porte ce nom'
          NOT INVALID KEY
           IF fp_type = 'Dessert'
            MOVE fp_nom TO fm_dessert
            ADD fp_prix TO WprixCarte
            MOVE 1 TO Wfin
           ELSE
            DISPLAY 'Aucun dessert ne porte ce nom'
           END-IF
          END-READ
         END-PERFORM

         PERFORM WITH TEST AFTER UNTIL fm_prix < WprixCarte
          DISPLAY 'Prix du menu (tarif à la carte :',WprixCarte,'€)'
          ACCEPT fm_prix
 
          IF fm_prix > WprixCarte THEN
           DISPLAY 'Le prix du menu doit être inférieur à la somme '
     -             'des prix des plats'
          END-IF
         END-PERFORM
 
         REWRITE mTampon END-REWRITE  
          
          IF fp_stat = 0 THEN
           DISPLAY 'Menu enregistré'
          END-IF       
         
          PERFORM WITH TEST AFTER UNTIL Wfin = 0 OR Wfin = 1
           DISPLAY 'Souhaitez vous continuer? 0 : non, 1 : oui'
           ACCEPT Wrep
          END-PERFORM
         ELSE
          DISPLAY 'Un menu porte déjà ce nom'
         END-IF
        END-PERFORM

       DISPLAY '-====================================-'

        CLOSE fplats
        CLOSE fmenus.

      ******************* CONSULTER_MENU ******************
      * Consulter le détail d'un menu
      * Saisir le nom du menu.
      * Si le nom du menu n'existe pas, alors on quitte la
      * fonction
      * Le nom, le prix et les différents plats sont
      * affichés
      ******************************************************
       CONSULTER_MENU.

       DISPLAY '|====================================|'
       DISPLAY '|=========== CONSULTATION ===========|'
       DISPLAY '|===========      DE      ===========|'
       DISPLAY '|===========         MENU ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

        DISPLAY 'Saisir le nom du menu à afficher :'
        ACCEPT fm_nom
        DISPLAY '--------------------------------------'
        DISPLAY ' '
          
        OPEN INPUT fmenus

        READ fmenus
        INVALID KEY
         DISPLAY 'Aucun menu ne porte ce nom'
        NOT INVALID KEY
         DISPLAY 'MENU "',fm_nom,'" (',fm_prix,' €)'
         OPEN INPUT fplats

         MOVE fm_entree TO fp_nom
         READ fplats
         INVALID KEY
          DISPLAY 'Erreur lors de la lecture de lentrée'
         NOT INVALID KEY
          DISPLAY 'Entrée : ',fp_nom
         END-READ

         MOVE fm_plat TO fp_nom
         READ fplats
         INVALID KEY
          DISPLAY 'Erreur lors de la lecture du plat'
         NOT INVALID KEY
          DISPLAY 'Plat : ',fp_nom
         END-READ

         MOVE fm_dessert TO fp_nom
         READ fplats
         INVALID KEY
          DISPLAY 'Erreur lors de la lecture du dessert'
         NOT INVALID KEY
          DISPLAY 'Dessert : ',fp_nom
         END-READ

         CLOSE fplats
        END-READ

       DISPLAY '-====================================-'

        CLOSE fmenus.

      ******************* SUPPRIMER_MENU ******************
      * Supprimer un menu
      * Saisir le nom du menu.
      * Si le nom du menu n'existe pas, alors on quitte la
      * fonction
      * Si le menu a été reservé au moins une fois, alors il
      * ne peut pas être supprimé
      ******************************************************
       SUPPRIMER_MENU.

       DISPLAY '|====================================|'
       DISPLAY '|=========== SUPPRESSION  ===========|'
       DISPLAY '|===========      DE      ===========|'
       DISPLAY '|===========         MENU ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

        OPEN I-O fmenus
        OPEN INPUT freservations
        DISPLAY 'Saisir le nom du menu à supprimer :'
        ACCEPT fm_nom
        DISPLAY '--------------------------------------'
         
        READ fmenus 
        INVALID KEY
         DISPLAY 'Aucun menu ne porte ce nom'
        NOT INVALID KEY
         MOVE 0 TO Wfin
         MOVE 0 TO Wtrouve
         MOVE 0 TO WnbMenus
         
         PERFORM WITH TEST AFTER UNTIL Wfin = 1 OR Wtrouve = 1
          READ freservations NEXT
          AT END
            MOVE 1 TO Wfin
          NOT AT END
           MOVE frs_nomsMenus TO WresMenu
           INSPECT WresMenu 
     -  TALLYING WnbMenus for ALL fm_nom
         
           IF WnbMenus > 0 THEN
            MOVE 1 TO Wtrouve
           END-IF
          END-READ
         END-PERFORM

         IF Wtrouve = 1 THEN
          DISPLAY 'Vous ne pouvez pas supprimer un menu associé'
     -            ' à une réservation'
         ELSE
          
          MOVE 0 TO Wchoix
          PERFORM WITH TEST AFTER UNTIL Wchoix = 1 OR Wchoix = 0
           DISPLAY 'Souhaité vous supprimé définitivement le menu'
     -             '(1:oui 0:non ) ?'
           ACCEPT Wchoix    
          END-PERFORM
           
          IF Wchoix = 1  THEN
          DELETE fmenus
           INVALID KEY
            DISPLAY 'Le menu n''a pas été supprimé'
           NOT INVALID KEY
            DISPLAY 'Menu supprimé'
          ELSE
           DISPLAY 'La suppression a été annulée'  
          END-IF
         END-IF
          
        END-READ
         
       DISPLAY '-====================================-'
          
        CLOSE freservations
        CLOSE fmenus.
 
      **************** CONSULTER_MENU_BUDGET **************
      * Consulter les menus dont le prix est inférieur à
      * une certaine somme
      * Saisir le budget, la liste des menus (s'il y en a)
      * s'affiche alors
      ******************************************************
       CONSULTER_MENU_BUDGET.

       DISPLAY '|====================================|'
       DISPLAY '|=========== CONSULTATION ===========|'
       DISPLAY '|===========      DE      ===========|'
       DISPLAY '|===========         MENU ===========|'
       DISPLAY '|===========  PAR BUDGET  ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

        OPEN INPUT fmenus

        DISPLAY 'Saisir votre budget maximum :'
        ACCEPT Wbudget

        MOVE 0 TO Wfin
        PERFORM WITH TEST AFTER UNTIL Wfin = 1
         READ fmenus NEXT
         AT END
          MOVE 1 TO Wfin
         NOT AT END
          IF fm_prix <= Wbudget THEN
           DISPLAY fm_nom,' (',fm_prix,' €)'
          END-IF
         END-READ
        END-PERFORM

       DISPLAY '-====================================-'

        CLOSE fmenus.

      ******************** MODIFIER_MENU *******************
      * Modifier le prix d'un menu
      * Saisir le nom du menu
      * Saisir le nouveau prix du menu
      ******************************************************
       MODIFIER_MENU.

       DISPLAY '|====================================|'
       DISPLAY '|=========== MODIFICATION ===========|'
       DISPLAY '|===========      DE      ===========|'
       DISPLAY '|===========         MENU ===========|'
       DISPLAY '|====================================|'
       DISPLAY ' '

                 
        OPEN I-O fmenus

        DISPLAY ' '
        DISPLAY 'Saisir le nom du menu à modifier :'
        ACCEPT fm_nom
        DISPLAY '--------------------------------------'
         
        READ fmenus 
        INVALID KEY
         DISPLAY 'Aucun menu ne porte ce nom'
        NOT INVALID KEY
         DISPLAY 'Saisir le nouveau prix du menu'
         ACCEPT fm_prix
         REWRITE mTampon END-REWRITE
        END-READ

       DISPLAY '-====================================-'
          
        CLOSE fmenus.
