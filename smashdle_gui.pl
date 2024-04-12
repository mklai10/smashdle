:- include(fighters).
:- dynamic guessCount/1.
:- use_module(library(pce)).

guessCount(0).

play :- 
        retractall(guessCount(_)),
        assert(guessCount(0)),
        selectFighter(Name),
        % write(Name),
        guess(Name).

selectFighter(Name) :- random_member(Name, [mario,donkey_kong,link,samus,dark_samus,yoshi,kirby,fox,
pikachu,luigi,ness,captain_falcon,jigglypuff,peach,daisy,bowser,ice_climbers,sheik,dr_mario,pichu,
falco,marth,lucina,young_link,ganondorf,mewtwo,roy,chrom,mr_game_and_watch,meta_knight,pit,dark_pit,
zero_suit_samus,wario,snake,ike,pokemon_trainer,diddy_kong,lucas,sonic,king_dedede,olimar,lucario,
rob,toon_link,wolf,villager,mega_man,wii_fit_trainer,rosalina_and_luna,little_mac,greninja,mii_brawler,
mii_swordfighter,mii_gunner,palutena,pac_man,robin,shulk,bowser_jr,duck_hunt,ryu,ken,cloud,corrin,
bayonetta,inkling,ridley,king_k_rool,isabelle,incineroar,piranha_plant,joker,hero,banjo_and_kazooie,
terry,byleth,min_min,steve,sephiroth,pyra,mythra,kazuya,sora]).

guess(Answer) :- 
        new(Window, dialog('Smashdle')),
        send(Window, append, new(TextItem, text_item('Guess a character:'))),
        send(Window, append, button(ok, message(@prolog, close_guess, Window, TextItem, Answer))),
        send(Window, default_button, ok),
        send(Window, open).

compareGuess(Guess, Answer) :-
        \+ fighter(Guess,_ ,_ ,_ ,_ ,_ ,_ , _),
        new(Window, dialog('Alert')),
        send(Window, append, new(_, text('That is NOT a Fighter, Guess Again!'))),
        send(Window, append, button(close, message(@prolog, close_not, Window, Answer))),
        send(Window, open).

compareGuess(Guess, Answer) :-
        \+ dif(Guess,Answer),
        retract(guessCount(N)),
        N1 is N + 1,
        assert(guessCount(N1)),
        new(Window, dialog('Victory')),
        format(string(Text), 'Congratulations! You guessed ~w in ~d guess(es)!', [Guess, N1]),
        send(Window, append, new(_, text(Text))),
        send(Window, open).

compareGuess(Guess, Answer) :-
        dif(Guess,Answer),
        retract(guessCount(N)),
        N1 is N + 1,
        assert(guessCount(N1)),

        fighter(Guess, Gender1, Species1, Universe1, Weight1, First1, Platform1, Date1),
        fighter(Answer, Gender2, Species2, Universe2, Weight2, First2, Platform2, Date2),
        compareString(Gender1, Gender2, Color1),
        compareList(Species1, Species2, Color2),
        compareString(Universe1, Universe2, Color3),
        compareNumber(Weight1, Weight2, Color4),
        compareList(First1, First2, Color5),
        compareList(Platform1, Platform2, Color6),
        compareNumber(Date1, Date2, Color7),

        new(Window, dialog('Results')),
        send(Window, size, size(800, 150)),

        create_square(Window, 0, Guess, black),
        create_square(Window, 1, Gender1, Color1),
        create_square(Window, 2, Species1, Color2),
        create_square(Window, 3, Universe1, Color3),
        create_square(Window, 4, Weight1, Color4),
        create_square(Window, 5, First1, Color5),
        create_square(Window, 6, Platform1, Color6),
        create_square(Window, 7, Date1, Color7),

        send(Window, display, button(close, message(@prolog, close_not, Window, Answer)), point(358, 112)),
        send(Window, default_button, close),
        send(Window, background, gray),
        send(Window, open).

compareString(Guess, Answer, Color) :-
        \+ dif(Guess, Answer),
        Color = 'green'.

compareString(Guess, Answer, Color) :-
        dif(Guess,Answer),
        Color = 'red'.

compareList(Guess, Answer, Color) :-
        \+ dif(Guess, Answer),
        Color = 'green'.

compareList(Guess, Answer, Color) :-
        dif(Guess,Answer),
        compareListRecursive(Guess, Answer, Color).

compareListRecursive([H1|_], Answer, Color) :-
        member(H1, Answer),
        Color = 'orange'.

compareListRecursive([H1|T1], Answer, Color) :-
        \+ member(H1, Answer),
        compareListRecursive(T1, Answer, Color).

compareListRecursive(Guess, _, Color) :-
        length(Guess,1),
        Color = 'red'.

compareNumber(Guess, Answer, Color) :-
        \+ dif(Guess, Answer),
        Color = 'green'.

compareNumber(Guess, Answer, Color) :-
        dif(Guess, Answer),
        Guess < Answer,
        % write('More, '),
        Color = 'magenta'.

compareNumber(Guess, Answer, Color) :-
        dif(Guess, Answer),
        Guess > Answer,
        % write('Less, '),
        Color = 'blue'.

close_guess(Window, TextItem, Answer) :-
    get(TextItem, selection, Guess),
    send(Window, destroy),
    compareGuess(Guess, Answer).

close_not(Window, Answer) :-
    send(Window, destroy),
    guess(Answer).

create_square(Window, Index, Text, Color) :-
    X is 0 + (Index) * 100,
    Y is 0,
    Size = 83,
    concat_list(Text, FormatText),

    new(Picture, picture),
    send(Picture, display, new(TextItem, text(FormatText)), point(0, 0)),
    send(Picture, pen, 1),
    send(Picture, colour, black),
    send(Picture, size, size(Size, Size)),

    send(TextItem, font, font(helvetica, bold, 12)),
    send(TextItem, colour, Color),

    get(Picture, width, PictureWidth),
    get(Picture, height, PictureHeight),
    get(TextItem, width, TextWidth),
    get(TextItem, height, TextHeight),
    TextX is (PictureWidth - TextWidth // 2) // 2,
    TextY is (PictureHeight - TextHeight // 2) // 2,
    send(TextItem, position, point(TextX, TextY)),
    send(Window, display, Picture, point(X, Y)).


concat_list([H|T], Result) :-
    atomic_list_concat([H|T], ', ', Result).

concat_list(List, Result) :-
    List = Result.