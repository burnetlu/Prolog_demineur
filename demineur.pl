/************************************************/
/* INFO 736 PROGRAMMATION LOGIQUE	*************/
/* TP2								*************/
/* Lucas BURNET, François CAILLET	*************/
/* FONCTIONNEL						*************/
/************************************************/
/*   _   _   _   _   _   _   _   _     _  *******/
/*  / \ / \ / \ / \ / \ / \ / \ / \   / \ *******/
/* ( P | R | O | B | L | E | M | E ) ( 2 )*******/
/*  \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/   \_/ *******/
/************************************************/

/******** TERRAIN DE JEUX (DOIT ETRE CARREE) *************/
terrain(2,[(1,1,1),(1,2,2)],1).
terrain(4,[(3,1,2),(2,2,3),(1,3,1),(1,4,2),(2,4,3)],5).
terrain(8,[(2,1,5),(7,2,7),(6,3,3),(5,3,5),(4,4,7),(3,5,3),
(6,5,5),(2,6,1),(3,7,4)],21).


/* FONCTION PRINCIPALE **************************************/
/* IN: Un terrain de taille T *******************************/
/* OUT: Liste des mines sous forme de doublet (I,J) *********/
/************************************************************ 	
	?- main(8,R), write(R).

R = [ (8,3), (5,1), (7,2), (6,5), (6,6), (6,4), (5,6), (4,5),
 (3,2), (2,3), (4,4), (4,2), (2,2), (2,8), (3,7), (1,7), 
 (3,8), (3,6), (1,8), (2,6), (2,4)] .
 
 Soit:
   j:1  2  3  4  5  6  7  8
i:  .........................
 1  |  |  |  |  | 2|  | M| M|
 	......................... 
 2  |  | M| M| M|  | M| 7| M|
 	......................... 
 3  |  | M| 6|  | 5| M| M| M|
 	......................... 
 4  |  | M|  | M| M|  | 4|  |
 	......................... 
 5  | M|  | 3|  | 6| M|  |  |
 	......................... 
 6  | 2| M|  | M| M| M|  |  |
 	......................... 
 7  |  |  | 3|  |  |  |  |  |
 	......................... 
 8  |  |  | M|  |  |  |  |  |
 	......................... 
 	
 	NBMINE: 21
*************************************************************
 	?- main(4,R).
 	
R = [ (4, 4), (3, 3), (1, 1), (1, 3), (2, 1)] .

Soit: 

   j:1  2  3  4 
i:  .............  
 1  | M| 3| M|  | 
 	.............
 2  | M|  | 2|  |
 	.............
 3  | 1|  | M|  |
 	.............
 4  |  | 1| 2| M|
 	.............
 	
 	NBMINES: 5.
*************************************************************
	?- main(2,R).
	
R = [ (2, 1)] ;
R = [ (1, 2)] ;
false. 

Soit: 
   j:1  2  
i:  ....... 
 1  | 1|  |
 	.......
 2  | M| 1|
 	.......

   j:1  2  
i:  ....... 
 1  | 1| M|
 	.......
 2  |  | 1|
 	.......

**************************************************************/
main(T,R) :-
	terrain(T,G,NbMines),
	findMines(G,T,G,[],R,NbMines).
	
/* FINDMINES*************************************************/
/* Role: trouve la position possible d'une mine pour un triplet
 	IN: G : le terrain (position des labels)
		T : Taille du terrain
		Mp : Liste de la position des mines déja posé
		NbMines : Le nombre de mine à poser
	OUT:MP1: Liste de la position des mines déja posé 
								+ La derniere mine posé	    */
								
findMines(_G,_T,_,R,R,NbMines):-
	length(R,NbMines),!. 
	
findMines(G,T,Ls,Mp,R,NbMines):-
	traiterTriplet(G,T,Ls,Mp,Mp1,Lf),
	findMines(G,T,Lf,Mp1,R,NbMines).

/* insertAtEnd **********************************************/
/* Role:Permet de mettre à la fin de la liste les triplet déja
		Traité, afin de ne pas poser une mine sur leur perimettre.			
 	IN: X : Element à ajouter à la fin de la liste
		[H|T] : Liste ou on veux ajouter un element en fin
	OUT:[H|Z]:  Liste avec en dernier element X 
									    */	
insertAtEnd(X,[ ],[X]).
insertAtEnd(X,[H|T],[H|Z]) :- insertAtEnd(X,T,Z).

/* traiterTriplet*************************************************/
/* Role: ajoute une mine à la solution par rapport à un triplet
 	IN: G : le terrain (position des labels)
		T : Taille du terrain
		Ms : Liste des triplet modifié. Etat initale : Ms <::> G
		Mp : Liste des mine déjà posé. Etat initial: Mp <:: 0 
	OUT:MP1: Liste des position des mines déja posé 
								+ La derniere mine posé	
		MS1: Liste des triplet modifié
		 en prenant en compte la derniere mine                 */
traiterTriplet(_G,_T,[(0,I,J)|Ms],Mp,Mp,R):-
	insertAtEnd((0,I,J),Ms,R). 

traiterTriplet(G,T,[(N,I,J)|Ms],Mp,Mp1,Ms1):-
	placerMine(T,I,J,Mp,Mp1),	
	pasSur(G,Mp1),
	majTri(Mp1,[(N,I,J)|Ms],Ms1), 
	N > 0.


	
/* placerMine*************************************************/
/* Role: Place une mine si c'est possible.
 	IN: G : le terrain (position des labels)
		T : Taille du terrain
		I : indice i du triplet
		J : indice j du triplet
		Mp : Liste des mine déjà posé.  
	OUT:MP1: Liste des position des mines déja posé 
								+ La derniere mine posé	    */
placerMine(T,I,J,Mp,[(X,Y)|Mp]):-
	aMine(Mp, (I - 1, J - 1), T), X is I - 1, Y is J - 1	;	
	aMine(Mp, (I - 1 , J + 1), T), X is I - 1, Y is J + 1;
	aMine(Mp, (I + 1 , J - 1), T), X is I + 1, Y is J - 1	;
	aMine(Mp, (I + 1 , J + 1), T), X is I + 1, Y is J + 1	;
	aMine(Mp, (I - 1 , J)	 , T), X is I - 1, Y is J	;
	aMine(Mp, (I + 1 , J)	 , T), X is I + 1, Y is J	;
	aMine(Mp, (I	 , J + 1), T), X is I,     Y is J + 1	;
	aMine(Mp, (I	 , J - 1), T), X is I,     Y is J - 1	.


/*aMine*************************************************/
/* Role: Vérifie si on peut placer une mine (Hors terrain, 
											Déjà mine).
 	IN: T : Taille du terrain
		I : indice i de la mine
		J : indice j de la mine
		Mp : Liste des mine déjà posé.  
	OUT: True // False	    */
aMine(Mp,(I , J), T) :-
	I > 0,
	I =< T,		
	J > 0,
	J =< T,
	notMine(Mp,(I,J)).	
/*aMine*************************************************/
/* Role: Vérifie si il n'y a pas deja une mine à cette
											 emplacement. 									
 	IN: 
		I : indice i de la mine
		J : indice j de la mine
		Mp : Liste des mine déjà posé
			X: indice i des mines déja posé. 
			Y: indice j des mines déja posé. 
	OUT: True // False	    */
notMine([],_).
notMine([(X,Y)|Ls],(I,J)) :-
	I1 is I,
	J1 is J,
	(X,Y) \= (I1,J1),
	notMine(Ls,(I,J)).

/*aMine*************************************************/
/* Role: Vérifie q'on ne pose pas sur un label. 									
 	IN: 
		X : indice i de la derniere mine posé
		Y : indice j de la mine de la derniere mine posé
		Ls : Liste des triplet
			I: indice i des labels. 
			J: indice j des labels. 
	OUT: True // False  */
pasSur([],_).
pasSur([(_,I,J)|Ls],[(X,Y)|Mp]):-
	(I,J)\=(X,Y),
	pasSur(Ls,[(X,Y)|Mp]).

/*majTri*************************************************/
/* Role: Met à jour les label, si la mine est voisin à un/des
 label(s) celuici est décrémeté de 1.									
 	IN: 
		Mp : Liste des mine déjà posé
			X: indice i des mines déja posé. 
			Y: indice j des mines déja posé.
		Ls : Liste des triplet
			N: nombre du label(nombre de mine qu'on peut 
								lui mettre en voisin).
			I: indice i des labels. 
			J: indice j des labels. 
	OUT: MS1: Liste des triplet modifié
		 en prenant en compte la derniere mine        */
majTri(_,[],[]).
majTri([(X,Y)|Mp],[(N,I,J)|Ls],[(N1,I,J)|Ms]):-
	(voisin((X,Y),(I,J)),N > 0,N1 is N-1,majTri([(X,Y)|Mp],Ls,Ms),!);
	(!,not(voisin((X,Y),(I,J))),N1 is N,majTri([(X,Y)|Mp],Ls,Ms)).
	
/*voisin*************************************************/
/* Role: Vérifie si 2 elements sont voisin								
 	IN: I: indice i du labels. 
		J: indice j du labels. 
		X: indice i de mines. 
		Y: indice j de mines.
	OUT:  True //False      */
voisin((X,Y),(I,J)):-
	(X1 is X-1,Y1 is Y-1,X1=I,Y1=J,!);
	(X2 is X-1,Y2 is Y+1,X2=I,Y2=J,!);
	(X3 is X+1,Y3 is Y+1,X3=I,Y3=J,!);
	(X4 is X+1,Y4 is Y-1,X4=I,Y4=J,!);
	(X5 is X,Y5 is Y-1,X5=I,Y5=J,!);
	(X6 is X,Y6 is Y+1,X6=I,Y6=J,!);
	(X7 is X+1,Y7 is Y,X7=I,Y7=J,!);
	(X8 is X-1,Y8 is Y,X8=I,Y8=J,!).







