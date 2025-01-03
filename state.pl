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


% Display the game state with a 5x5 board, each cell divided into 4 subcells.
display_game(GameState) :-
    GameState = [Board, _, CurrentPlayer, _ | _],
    nl,
    write('Next Player: '), write(CurrentPlayer), nl,
    nl,
    display_board(Board).

% Display the board.
display_board(Board) :-
    display_horizontal_border,
    display_rows(Board, 1).

% Display the rows of the board.
display_rows([], _).
display_rows([Row | RestRows], RowNumber) :-
    display_row(Row, RowNumber),
    (RowNumber =:= 5 ; RowNumber mod 2 =:= 1 -> display_horizontal_border; true),
    NextRowNumber is RowNumber + 1,
    display_rows(RestRows, NextRowNumber).

% Display a single row (each row consists of multiple subcell lines).
display_row(Row, RowNumber) :-
    display_row_subcells(Row, top),
    display_row_subcells(Row, bottom),
    (RowNumber =:= 5 -> display_horizontal_border; true).

% Display the subcells for a row, either top or bottom.
display_row_subcells([], _) :-
    write('|'), nl.
display_row_subcells([Cell | RestCells], Position) :-
    write('|'),
    display_cell_subcell(Cell, Position),
    display_row_subcells(RestCells, Position).

% Display a subcell line of a single cell.
display_cell_subcell(empty, top) :- write('   .   ').
display_cell_subcell(empty, bottom) :- write('   .   ').
display_cell_subcell(white, top) :- write('   W   ').
display_cell_subcell(white, bottom) :- write('   W   ').
display_cell_subcell(black, top) :- write('   B   ').
display_cell_subcell(black, bottom) :- write('   B   ').
display_cell_subcell(dual(white, black), top) :- write(' W   B ').
display_cell_subcell(dual(white, black), bottom) :- write(' W   B ').
display_cell_subcell(dual(black, white), top) :- write(' B   W ').
display_cell_subcell(dual(black, white), bottom) :- write(' B   W ').
display_cell_subcell(neutral, top) :- write('   N   ').
display_cell_subcell(neutral, bottom) :- write('   N   ').

% Display the horizontal border separating rows.
display_horizontal_border :-
    write('+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+'), nl.

