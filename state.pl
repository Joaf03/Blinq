% initial_state/2 initializes the game state based on the game configuration
initial_state(GameConfig, GameState) :-
    GameConfig = [Player1, Player2, GameType | Rest],
    % We are splitting each cell in 4 because when pieces are placed on top of each other 
    % they can cause the cell to be divided in 4, when looked from above 
    % (and the neutral central piece is also split in 4)
    Board = [
        [empty, white, white, white, white, white, white, white, white, white, white, empty],
        [black, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, black],
        [black, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, black],
        [black, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, black],
        [black, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, black],
        [black, empty, empty, empty, empty, white, black, empty, empty, empty, empty, black],
        [black, empty, empty, empty, empty, black, white, empty, empty, empty, empty, black],
        [black, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, black],
        [black, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, black],
        [black, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, black],
        [black, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, black],
        [empty, white, white, white, white, white, white, white, white, white, white, empty]
    ],

    (Player1 == "White" -> CurrentPlayer = Player1; CurrentPlayer = Player2),
    PiecesToPlay = [27, 27],
    
    % Combine all elements into the game state
    GameState = [Board, GameType, CurrentPlayer, PiecesToPlay, Player1, Player2 | Rest].

