include('state.pl').
include('logic.pl').
include('ai.pl').

% play/0 starts the game and initializes configuration
play :-
    write("Welcome to Blinq!"), nl,
    write("Player 1 color (White/Black): "), flush_output(current_output),
    read_line_to_string(user_input, Player1),
    write("Player 2 color (White/Black): "), flush_output(current_output),
    read_line_to_string(user_input, Player2),
    write("Choose Game Type (H/H, H/PC, PC/H, or PC/PC): "), flush_output(current_output),
    read_line_to_string(user_input, GameType),
    % If he chose H/PC or PC/H, ask the difficulty level of the PC
    ( (GameType == "H/PC" ; GameType == "PC/H") ->
        write("Choose difficulty level for PC (1/2): "), flush_output(current_output),
        read_line_to_string(user_input, Difficulty),
        GameConfig = [Player1, Player2, GameType, Difficulty]
    % If he chose PC/PC, ask the difficulty level of both PC's
    ; GameType == "PC/PC" ->
        write("Choose difficulty level for PC1 (1/2): "), flush_output(current_output),
        read_line_to_string(user_input, Difficulty1),
        write("Choose difficulty level for PC2 (1/2): "), flush_output(current_output),
        read_line_to_string(user_input, Difficulty2),
        GameConfig = [Player1, Player2, GameType, Difficulty1, Difficulty2]
    ; GameType == "H/H" ->
        GameConfig = [Player1, Player2, GameType]
    ; true
    ),
    
    % Initialize the game state and output it
    initial_state(GameConfig, GameState),
    GameState = [Board, GameType, CurrentPlayer, PiecesToPlay, Player1, Player2 | Rest],
    write("Initial Game State:"), nl,
    write("Board: "), nl, write(Board), nl,
    write("Game Type: "), write(GameType), nl,
    write("Current Player: "), write(CurrentPlayer), nl,
    PiecesToPlay = [PiecesPlayer1, PiecesPlayer2],
    write("Pieces To Play for Player 1: "), write(PiecesPlayer1), nl,
    write("Pieces To Play for Player 2: "), write(PiecesPlayer2), nl,
    ( (GameType == "H/PC" ; GameType == "PC/H") ->
        Rest = [Difficulty],
        write("Difficulty: "), write(Difficulty), nl
    ; GameType == "PC/PC" ->
        Rest = [Difficulty1, Difficulty2],
        write("Difficulty for PC1: "), write(Difficulty1), nl,
        write("Difficulty for PC2: "), write(Difficulty2), nl
    ; true
    ),

    % Start the game loop
    game_loop(GameState).

% game_loop/1 handles the main game loop
game_loop(GameState) :-
    GameState = [_, GameType, CurrentPlayer, _, Player1, Player2 | Rest],
    % List valid moves for the current player
    valid_moves(GameState, ValidMoves),
    write("Valid Moves: "), write(ValidMoves), nl,
    % Determine the player type and choose the move
    (GameType == "H/H" ->
        PlayerType = human
    ; (GameType == "H/PC", CurrentPlayer == "White") ->
        (Player1 == "White" -> PlayerType = human; Rest = [Difficulty], PlayerType = Difficulty)
    ; (GameType == "H/PC", CurrentPlayer == "Black") ->
        (Player1 == "White" -> Rest = [Difficulty], PlayerType = Difficulty; PlayerType = human)
    ; (GameType == "PC/H", CurrentPlayer == "White") ->
        (Player1 == "White" -> Rest = [Difficulty], PlayerType = Difficulty; PlayerType = human)
    ; (GameType == "PC/H", CurrentPlayer == "Black") ->
        (Player1 == "White" -> PlayerType = human; Rest = [Difficulty], PlayerType = Difficulty)
    /*; (GameType == "PC/PC", CurrentPlayer == "White") ->
        PlayerType = Difficulty1
    ; (GameType == "PC/PC", CurrentPlayer == "Black") ->
        PlayerType = Difficulty2*/
    ),

    % Prompt the user for their move
    write("It's "), write(CurrentPlayer), write("'s turn."), nl,
    write("AAAA"), nl,
    choose_move(GameState, PlayerType, Move),
    write("BBBB"), nl,
    move(GameState, Move, NewGameState),
    write("CCCC"), nl,
    NewGameState = [Board, _, _, NewPiecesToPlay, Player1, Player2 | _],
    NewPiecesToPlay = [NewPiecesPlayer1, NewPiecesPlayer2],
    write("Current Board: "),nl, write(Board), nl,
    (game_over(NewGameState, Winner) ->
        write("Game Over! Winner: "), write(Winner), nl
    ;
       (NewPiecesPlayer1 =:= 0, NewPiecesPlayer2 =:= 0 ->
            write("No more pieces left. It is a draw!"), nl
        ;
            % Switch the current player
            switch_player(NewGameState, UpdatedGameState),
            write("Pieces To Play for Player 1 after move: "), write(NewPiecesPlayer1), nl,
            write("Pieces To Play for Player 2 after move: "), write(NewPiecesPlayer2), nl,
            game_loop(UpdatedGameState)
        )
    ).

% switch_player/2 switches the current player in the game state
switch_player([Board, GameType, CurrentPlayer, PiecesToPlay, Player1, Player2 | Rest], [Board, GameType, NewPlayer, PiecesToPlay, Player1, Player2 | Rest]) :-
    (CurrentPlayer == "White" -> NewPlayer = "Black"; NewPlayer = "White").