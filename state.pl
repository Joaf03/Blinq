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

% display_game/1 prints the game state to the terminal
display_game(GameState) :-
    GameState = [Board, GameType, CurrentPlayer, PiecesToPlay, Player1, Player2 | _],
    format('Game Type: ~w~n', [GameType]),
    format('Current Player: ~w~n', [CurrentPlayer]),
    format('Pieces to Play: ~w~n', [PiecesToPlay]),
    format('Player 1: ~w~n', [Player1]),
    format('Player 2: ~w~n', [Player2]),
    nl,
    print_board(Board).

% print_board/1 prints the board to the terminal
print_board(Board) :-
    length(Board, Size),
    print_column_headers(Size),
    print_rows(Board, Size).

% print_column_headers/1 prints the column headers with proper alignment
print_column_headers(Size) :-
    write('    '),
    print_column_headers_helper(0, Size),
    nl.

% print_column_headers_helper/2 prints each column index, adjusting spacing for two-digit numbers
print_column_headers_helper(Col, Size) :-
    (Col < 10 -> format(' ~d ', [Col]) ;
     format('~d ', [Col])),
    NextCol is Col + 1,
    (NextCol =:= Size -> true ; print_column_headers_helper(NextCol, Size)).

% print_rows/2 prints each row of the board
print_rows(Board, Size) :-
    MaxRowIndex is Size - 1,
    print_rows_helper(Board, MaxRowIndex).

% print_rows_helper/2 prints each row of the board with the row index starting from the highest index
print_rows_helper([], _).
print_rows_helper([Row|Rest], RowNum) :-
    (RowNum < 10 -> format('  ~d ', [RowNum]) ; format(' ~d ', [RowNum])),
    print_row(Row),
    nl,
    NextRowNum is RowNum - 1,
    print_rows_helper(Rest, NextRowNum).

% print_row/1 prints each cell in a row
print_row([]).
print_row([Cell|Rest]) :-
    print_cell(Cell),
    print_row(Rest).

% print_cell/1 prints a single cell
print_cell(empty) :- write(' . ').
print_cell(white) :- write(' W ').
print_cell(black) :- write(' B ').