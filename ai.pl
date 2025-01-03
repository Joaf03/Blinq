:- consult('logic.pl').

% choose_move/3 chooses the move based on difficulty in case of PC player
% and prompts the user for a move in case of human players
choose_move(GameState, PlayerType, Move) :-
    write("PLAYERTYPE: "), write(PlayerType), nl,
    (PlayerType == human ->
        write("Enter your move (format: [Row, Col, Rotation]): "), flush_output(current_output),
        read_line_to_string(user_input, MoveString),
        term_string(Move, MoveString),
        valid_moves(GameState, ValidMoves),
        (member(Move, ValidMoves) ->
            write("Valid move!"), nl,
            true
        ;
            write("Invalid Move! Please enter a valid move."), nl,
            choose_move(GameState, PlayerType, Move)
        )
    ; PlayerType == "1" ->
        valid_moves(GameState, ValidMoves),
        random_member(Move, ValidMoves),
        write("PC MADE THE MOVE: "), write(Move), nl
    ; PlayerType == "2" ->
        valid_moves(GameState, ValidMoves),
        findall(Value-M, (member(M, ValidMoves), simulate_move(GameState, M, NewGameState), value(NewGameState, "Black", Value)), MovesWithValues),
        max_member(_-Move, MovesWithValues),
        write("PC MADE THE MOVE: "), write(Move), nl
    ).

% value/3 evaluates the game state and returns a value for the given player
value(GameState, Player, Value) :-
    GameState = [_, _, _, PiecesToPlay | _],
    PiecesToPlay = [WhitePieces, BlackPieces],
    (Player == "White" ->
        Value is WhitePieces - BlackPieces
    ;
        Value is BlackPieces - WhitePieces
    ).

% simulate_move/3 simulates a move and returns the new game state
simulate_move(GameState, Move, NewGameState) :-
    move(GameState, Move, NewGameState).