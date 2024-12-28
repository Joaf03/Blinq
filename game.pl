include('state.pl').

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
        write("Choose difficulty level for PC (Noob/Pro): "), flush_output(current_output),
        read_line_to_string(user_input, Difficulty),
        GameConfig = [Player1, Player2, GameType, Difficulty]
    % If he chose PC/PC, ask the difficulty level of both PC's
    ; GameType == "PC/PC" ->
        write("Choose difficulty level for PC1 (Noob/Pro): "), flush_output(current_output),
        read_line_to_string(user_input, Difficulty1),
        write("Choose difficulty level for PC2 (Noob/Pro): "), flush_output(current_output),
        read_line_to_string(user_input, Difficulty2),
        GameConfig = [Player1, Player2, GameType, Difficulty1, Difficulty2]
    ; true
    ),
    
    % Initialize the game state and output it
    initial_state(GameConfig, GameState),
    GameState = [Board, GameType, CurrentPlayer, PiecesToPlay | Rest],
    write("Initial Game State:"), nl,
    write("Board: "), write(Board), nl,
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
    ).