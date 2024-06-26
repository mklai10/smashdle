:- include(fighters).
:- dynamic guessCount/1.
guessCount(0).

% starts the game of smashdle in the swi console
play :- 
        retractall(guessCount(_)),
        assert(guessCount(0)),
        selectFighter(Name),
        % write(Name),
        guess(Name).

% selects a random fighter name in the list
selectFighter(Name) :- random_member(Name, [mario,donkey_kong,link,samus,dark_samus,yoshi,kirby,fox,
pikachu,luigi,ness,captain_falcon,jigglypuff,peach,daisy,bowser,ice_climbers,sheik,dr_mario,pichu,
falco,marth,lucina,young_link,ganondorf,mewtwo,roy,chrom,mr_game_and_watch,meta_knight,pit,dark_pit,
zero_suit_samus,wario,snake,ike,pokemon_trainer,diddy_kong,lucas,sonic,king_dedede,olimar,lucario,
rob,toon_link,wolf,villager,mega_man,wii_fit_trainer,rosalina_and_luna,little_mac,greninja,mii_brawler,
mii_swordfighter,mii_gunner,palutena,pac_man,robin,shulk,bowser_jr,duck_hunt,ryu,ken,cloud,corrin,
bayonetta,inkling,ridley,king_k_rool,isabelle,incineroar,piranha_plant,joker,hero,banjo_and_kazooie,
terry,byleth,min_min,steve,sephiroth,pyra,mythra,kazuya,sora]).

% gets the user input of their guess
guess(Fighter) :- 
        nl,
        write('Make a Guess! '),
        read(Guess),
        compareGuess(Guess, Fighter).

% deals with user input if it is not a fighter in the dataset
compareGuess(Guess, Answer) :-
        \+ fighter(Guess,_ ,_ ,_ ,_ ,_ ,_ , _),
        write('That is NOT a Fighter, Guess Again!'), nl,
        guess(Answer).

% deals with user input if they have guessed the correct fighter
compareGuess(Guess, Answer) :-
        \+ dif(Guess,Answer),
        retract(guessCount(N)),
        N1 is N + 1,
        assert(guessCount(N1)),
        write('Victory'), nl,
        write('You Guessed: '),
        write(Guess), nl,
        write('Number of tries: '),
        write(N1).

% deals with user input if they have not guessed the correct fighter
compareGuess(Guess, Answer) :-
        dif(Guess,Answer),
        retract(guessCount(N)),
        N1 is N + 1,
        assert(guessCount(N1)),
        fighter(Guess,Gender1,Species1,Universe1,Weight1,First1,Platform1,Date1),
        fighter(Answer,Gender2,Species2,Universe2,Weight2,First2,Platform2,Date2),
        write('Gender: '),
        compareString(Gender1,Gender2),
        write('Species: '),
        compareList(Species1,Species2),
        write('Universe: '),
        compareString(Universe1,Universe2),
        write('Weight: '),
        compareNumber(Weight1,Weight2),
        write('First Appearance: '),
        compareList(First1,First2),
        write('Platform of Origin: '),
        compareList(Platform1,Platform2),
        write('Origin Date: '),
        compareNumber(Date1,Date2),
        guess(Answer).
        
% returns green if the strings are the same
compareString(Guess, Answer) :-
        \+ dif(Guess, Answer),
        write('Green, '), 
        write(Guess), nl.

% returns red if the strings are different
compareString(Guess, Answer) :-
        dif(Guess,Answer),
        write('Red, '),
        write(Guess), nl.

% returns green if the lists are the same
compareList(Guess, Answer) :-
        \+ dif(Guess, Answer),
        write('Green, '),
        write(Guess), nl.

% calls the recursive helper to compare a list
compareList(Guess, Answer) :-
        dif(Guess,Answer),
        compareListRecursive(Guess,Answer),
        write(Guess), nl.

% returns orange if there is atleast one member of the list thats matching
compareListRecursive([H1|_],Answer) :-
        member(H1, Answer),
        write('Orange, ').

% recursive call for helper
compareListRecursive([H1|T1],Answer) :-
        \+ member(H1, Answer),
        compareListRecursive(T1, Answer).

% returns red if there are no members of the list that are matching
compareListRecursive(Guess,_) :-
        length(Guess,1),
        write('Red, ').

% returns green if the numbers are the same
compareNumber(Guess, Answer) :-
        \+ dif(Guess, Answer),
        write('Green, '),
        write(Guess),
        write(Guess), nl.

% returns more if the the number is less than the answer number
compareNumber(Guess, Answer) :-
        dif(Guess, Answer),
        Guess < Answer,
        write('More, '),
        write(Guess), nl.

% returns less if the the number is more than the answer number
compareNumber(Guess, Answer) :-
        dif(Guess, Answer),
        Guess > Answer,
        write('Less, '),
        write(Guess), nl.
