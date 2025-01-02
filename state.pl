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
    GameState = [Board, GameType, CurrentPlayer, PiecesToPlay | Rest].

% Display the game state, focusing on the 5x5 playable area with proper formatting.
display_game(GameState) :-
    GameState = [Board, GameType, CurrentPlayer, PiecesToPlay | _],
    write('Next player: '), write(CurrentPlayer), nl,
    display_header,
    display_board(Board),
    display_footer.

% Display the header with the column numbers and frame top.
display_header :-
    write('    W   W   W   W   W'), nl,
    write('  +-------+-------+-------+-------+-------+-------+'), nl,
    write('      1       2       3       4       5'), nl.

% Display the footer with the frame bottom.
display_footer :-
    write('  +-------+-------+-------+-------+-------+-------+'), nl,
    write('    W   W   W   W   W'), nl.

% Display the board: iterate through rows and print their content with frames on the sides.
display_board(Board) :-
    length(Board, NumRows),
    display_rows(Board, 1, NumRows).

% Iterate over the rows of the board and display them.
display_rows([], _, _).
display_rows([Row | RestRows], RowIndex, NumRows) :-
    format('  B |', []), % Left frame
    display_row(Row),
    format('| B', []), % Right frame
    nl,
    (RowIndex < NumRows -> write('    |         |         |         |         |         |'), nl; true),
    write('  +-------+-------+-------+-------+-------+-------+'), nl,
    NewRowIndex is RowIndex + 1,
    display_rows(RestRows, NewRowIndex, NumRows).

% Display each rows individual cells.
display_row([]).
display_row([Cell | RestCells]) :-
    display_cell(Cell),
    write('     |'),
    display_row(RestCells).

% Display a single cell based on its content.
display_cell(empty) :-
    write('         ').
display_cell(white) :-
    write('  W      ').
display_cell(black) :-
    write('  B      ').
display_cell(neutral) :-
    write('    N    ').
display_cell(dual(white, black)) :-
    write(' W B     ').
display_cell(dual(black, white)) :-
    write(' B W     ').
