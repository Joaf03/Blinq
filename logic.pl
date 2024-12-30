% valid_moves/2 gets all the possible valid moves given the state of the game
valid_moves(GameState, ListOfMoves) :-
    GameState = [Board | _],
    find_moves(Board, 1, 1, [], ListOfMoves).

% find_moves/4 uses tail recursion to check if each move is valid and appends to Move if it is
find_moves(Board, Row, Col, Acc, Moves) :-
    length(Board, NumRows),
    nth1(1, Board, FirstRow),
    length(FirstRow, NumCols),
    (Row =< NumRows - 2, Col =< NumCols - 2 -> % Check bounds for 2x2 subcells and ensure Row and Col are odd
        (valid_cell(Board, Row, Col) ->
            ActualRow is NumRows - Row - 1, % We are making this operation because we are asked 
            % to consider the lower-left corner of the board as the origin coordenates 
            % instead of the top-right-corner, like it is by default
            append(Acc, [[ActualRow, Col, 0], [ActualRow, Col, 1], [ActualRow, Col, 2], [ActualRow, Col, 3]], NewAcc)
        ;
            NewAcc = Acc
        ),
        
        % Calculate the next column and row and recursively call find_moves
        NextCol is Col + 1,
        (NextCol =< NumCols - 2 ->
            find_moves(Board, Row, NextCol, NewAcc, Moves)
        ;
            NextRow is Row + 1,
            find_moves(Board, NextRow, 1, NewAcc, Moves)
        )
    ;
        % When out of bounds, return the accumulated moves
        Moves = Acc
    ).


% is_empty_2x2 checks if the 2x2 cell is completely empty, given the coordinates its top-left corner
is_empty_2x2(Board, Row, Col) :-
    nth0(Row, Board, RowList),
    nth0(Col, RowList, SubCell1),
    Col1 is Col + 1,
    nth0(Col1, RowList, SubCell2),
    Row1 is Row + 1,
    nth0(Row1, Board, RowList1),
    nth0(Col, RowList1, SubCell3),
    nth0(Col1, RowList1, SubCell4),
    SubCell1 == empty,
    SubCell2 == empty,
    SubCell3 == empty,
    SubCell4 == empty.

% is_filled_2x2 checks if the 2x2 cell is completely filled, given the coordinates its top-left corner
is_filled_2x2(Board, Row, Col) :-
    nth0(Row, Board, RowList),
    nth0(Col, RowList, SubCell1),
    Col1 is Col + 1,
    nth0(Col1, RowList, SubCell2),
    Row1 is Row + 1,
    nth0(Row1, Board, RowList1),
    nth0(Col, RowList1, SubCell3),
    nth0(Col1, RowList1, SubCell4),
    (SubCell1 == white; SubCell1 == black),
    (SubCell2 == white; SubCell2 == black),
    (SubCell3 == white; SubCell3 == black),
    (SubCell4 == white; SubCell4 == black).

% valid_cell checks if the 2x2 cell is either empty or filled by leveraging the predicates is_filled and is_empty
valid_cell(Board, Row, Col) :-
    is_empty_2x2(Board, Row, Col);
    is_filled_2x2(Board, Row, Col).
