:- consult('state.pl').
:- consult('logic.pl').
:- consult('ai.pl').

% play/0 starts the game and initializes configuration
play :-
    write('Welcome to Blinq!'), nl,
    write('Player 1 color (White/Black): '), nl,
    read_input(Player1),  % Using standard read_input predicate
    write('Player 2 color (White/Black): '), nl,
    read_input(Player2),
    write('Choose Game Type (H/H, H/PC, PC/H, or PC/PC): '), nl,
    read_input(GameType),
    
    % Check for difficulty and set game configuration accordingly
    ( (GameType == 'H/PC' ; GameType == 'PC/H') -> 
        write('Choose difficulty level for PC (1/2): '), nl,
        read_input(Difficulty),
        GameConfig = [Player1, Player2, GameType, Difficulty]
    ; GameType == 'PC/PC' -> 
        write('Choose difficulty level for PC1 (1/2): '), nl,
        read_input(Difficulty1),
        write('Choose difficulty level for PC2 (1/2): '), nl,
        read_input(Difficulty2),
        GameConfig = [Player1, Player2, GameType, Difficulty1, Difficulty2]
    ; GameType == 'H/H' -> 
        GameConfig = [Player1, Player2, GameType]
    ; true
    ),
    
    % Initialize the game state
    initial_state(GameConfig, GameState),
    GameState = [_, GameType, CurrentPlayer, PiecesToPlay, Player1, Player2 | Rest],
    write('Initial Game State:'), nl,
    display_game(GameState),
    write('Game Type: '), write(GameType), nl,
    write('Current Player: '), write(CurrentPlayer), nl,
    PiecesToPlay = [PiecesPlayer1, PiecesPlayer2],
    write('Pieces To Play for Player 1: '), write(PiecesPlayer1), nl,
    write('Pieces To Play for Player 2: '), write(PiecesPlayer2), nl,
    ( (GameType == 'H/PC' ; GameType == 'PC/H') ->
        Rest = [Difficulty],
        write('Difficulty: '), write(Difficulty), nl
    ; GameType == 'PC/PC' ->
        Rest = [Difficulty1, Difficulty2],
        write('Difficulty for PC1: '), write(Difficulty1), nl,
        write('Difficulty for PC2: '), write(Difficulty2), nl
    ; true
    ),

    % Start the game loop
    game_loop(GameState).

% The game loop
game_loop(GameState) :-
    GameState = [_, GameType, CurrentPlayer, _, Player1, Player2 | Rest],
    valid_moves(GameState, ValidMoves),
    write('Valid Moves: '), write(ValidMoves), nl,
    
    % Determine the player type (human or computer)
    (GameType == 'H/H' -> 
        PlayerType = human
    ; (GameType == 'H/PC', CurrentPlayer == 'White') -> 
        (Player1 == 'White' -> PlayerType = human; Rest = [Difficulty], PlayerType = Difficulty)
    ; (GameType == 'H/PC', CurrentPlayer == 'Black') -> 
        (Player1 == 'White' -> Rest = [Difficulty], PlayerType = Difficulty; PlayerType = human)
    ; (GameType == 'PC/H', CurrentPlayer == 'White') -> 
        (Player1 == 'White' -> Rest = [Difficulty], PlayerType = Difficulty; PlayerType = human)
    ; (GameType == 'PC/H', CurrentPlayer == 'Black') -> 
        (Player1 == 'White' -> PlayerType = human; Rest = [Difficulty], PlayerType = Difficulty)
    ; (GameType == 'PC/PC', CurrentPlayer == 'White') -> 
        Rest = [Difficulty1, _],
        PlayerType = Difficulty1
    ; (GameType == 'PC/PC', CurrentPlayer == 'Black') -> 
        Rest = [_, Difficulty2],
        PlayerType = Difficulty2
    ),
    
    write('It is '), write(CurrentPlayer), write('s turn.'), nl,
    choose_move(GameState, PlayerType, Move),
    move(GameState, Move, NewGameState),
    NewGameState = [_, _, _, NewPiecesToPlay, Player1, Player2 | _],
    NewPiecesToPlay = [NewPiecesPlayer1, NewPiecesPlayer2],
    display_game(NewGameState),
    (game_over(NewGameState, Winner) -> 
        write('Game Over! Winner: '), write(Winner), nl
    ; (NewPiecesPlayer1 =:= 0, NewPiecesPlayer2 =:= 0 -> 
        write('No more pieces left. It is a draw!'), nl
    ;
        % Switch the current player
        switch_player(NewGameState, UpdatedGameState),
        write('Pieces To Play for Player 1 after move: '), write(NewPiecesPlayer1), nl,
        write('Pieces To Play for Player 2 after move: '), write(NewPiecesPlayer2), nl,
        game_loop(UpdatedGameState)
    )).

% Switch current player (white <-> black)
switch_player([Board, GameType, CurrentPlayer, PiecesToPlay, Player1, Player2 | Rest], [Board, GameType, NewPlayer, PiecesToPlay, Player1, Player2 | Rest]) :-
    (CurrentPlayer == 'White' -> NewPlayer = 'Black'; NewPlayer = 'White').

% Helper input read
read_input(Input) :-
    read_line(user_input, Line),
    atom_codes(Input, Line).