:- consult('logic.pl').
:- use_module(library(random)).

% choose_move/3 chooses the move based on difficulty in case of PC player
% and prompts the user for a move in case of human players
choose_move(GameState, PlayerType, Move) :-
    write('PLAYERTYPE: '), write(PlayerType), nl,
    (PlayerType == human ->
        write('Enter your move (format: [Row, Col, Rotation]): '),
        read_input2(Move),
        valid_moves(GameState, ValidMoves),
        (member(Move, ValidMoves) ->
            write('Valid move!'), nl,
            true
        ;
            write('Invalid Move! Please enter a valid move.'), nl,
            choose_move(GameState, PlayerType, Move)
        )
    ; PlayerType == '1' ->
        valid_moves(GameState, ValidMoves),
        random_member(Move, ValidMoves),
        write('PC MADE THE MOVE: '), write(Move), nl
    ; PlayerType == '2' ->
        GameState = [_, _, CurrentPlayer | _],
        valid_moves(GameState, ValidMoves),
        findall(Value-Move, (member(Move, ValidMoves), simulate_move(GameState, Move, NewGameState), value(NewGameState, CurrentPlayer, Value)), MovesWithValues),
        %write("AAAAA: "), nl, write(MovesWithValues), nl,
        max_member(MaxValue-_, MovesWithValues),
        findall(M, (member(Value-M, MovesWithValues), Value == MaxValue), BestMoves),
        random_member(Move, BestMoves),
        write('PC MADE THE MOVE: '), write(Move), nl
    ).

% Helper input read
read_input2(Input) :-
    read(Input).  % directly reads the input as Prolog term

% simulate_move/3 simulates a move and returns the new game state
simulate_move(GameState, Move, NewGameState) :-
    move(GameState, Move, NewGameState).

% value/3 evaluates the game state for the given player based on the number of valid 2x2 cells completely filled by the player's pieces color
value(GameState, Player, Value) :-
    GameState = [Board | _],
    (Player == "White" -> Color = white ; Color = black),
    valid_moves(GameState, ValidMoves),
    length(Board, NumRows),
    findall([Row, Col], (member([Row, Col, _], ValidMoves), ActualRow is NumRows - Row - 1, is_filled_2x2_by_color(Board, ActualRow, Col, Color)), FilledCells),
    length(FilledCells, Value).

% is_filled_2x2_by_color/4 checks if the 2x2 cell is completely filled by the player's pieces color
is_filled_2x2_by_color(Board, Row, Col, Color) :-
    nth0(Row, Board, RowList),
    nth0(Col, RowList, SubCell1),
    Col1 is Col + 1,
    nth0(Col1, RowList, SubCell2),
    Row1 is Row + 1,
    nth0(Row1, Board, RowList1),
    nth0(Col, RowList1, SubCell3),
    nth0(Col1, RowList1, SubCell4),
    SubCell1 == Color,
    SubCell2 == Color,
    SubCell3 == Color,
    SubCell4 == Color.

