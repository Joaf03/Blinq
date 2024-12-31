:-use_module(library(lists)).

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
            % We are making this operation because we are asked 
            % to consider the lower-left corner of the board as the origin coordenates 
            % instead of the top-right-corner, like it is by default
            ActualRow is NumRows - Row - 1,
            % We have 4 different variations of the same coordinate because
            % the players can rotate the piece 90, 180 or 270 degrees
            % before placing it
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
    Row mod 2 =:= 1,
    Col mod 2 =:= 1,
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



% move/3 checks the valid_moves list and executes the specified move if it is within that list. 
% It also updates the GameState
move(GameState, Move, NewGameState) :-
    GameState = [Board, GameType, CurrentPlayer, PiecesToPlay | Rest],
    valid_moves(GameState, ListOfMoves),
    (member(Move, ListOfMoves) ->
        write('Valid move'), nl,
        execute_move(Board, Move, NewBoard),
        NewGameState = [NewBoard, GameType, CurrentPlayer, PiecesToPlay | Rest] % Need to deduct PiecesToPlay from the player that just played
    ;
        write('Invalid Move!'), nl,
        write('Please enter a valid move: '), flush_output(current_output),
        read_line_to_string(user_input, NewMoveString),
        term_string(NewMove, NewMoveString),
        move(GameState, NewMove, NewGameState)
    ).

execute_move(Board, Move, NewBoard) :-
    Move = [Row, Col, Rotation],
    apply_rotation(Board, Row, Col, Rotation, NewBoard).

apply_rotation(Board, Row, Col, Rotation, NewBoard) :-
    length(Board, NumRows),
    ActualRow is NumRows - Row - 1,

    (   Rotation == 0 ->
        SubCell1 = white,
        SubCell2 = black,
        SubCell3 = white,
        SubCell4 = black
    ;
        Rotation == 1 ->
        SubCell1 = white,
        SubCell2 = white,
        SubCell3 = black,
        SubCell4 = black
    ;
        Rotation == 2 ->
        SubCell1 = black,
        SubCell2 = white,
        SubCell3 = black,
        SubCell4 = white
    ;
        Rotation == 3 ->
        SubCell1 = black,
        SubCell2 = black,
        SubCell3 = white,
        SubCell4 = white
    ),
    nth0(ActualRow, Board, RowList),
    replace_nth0(Col, SubCell1, RowList, TempRowList1),
    Col1 is Col + 1,
    replace_nth0(Col1, SubCell2, TempRowList1, TempRowList2),
    ActualRow1 is ActualRow + 1,
    nth0(ActualRow1, Board, RowList1),
    replace_nth0(Col, SubCell3, RowList1, TempRowList3),
    replace_nth0(Col1, SubCell4, TempRowList3, TempRowList4),
    replace_nth0(ActualRow, TempRowList2, Board, TempBoard1),
    replace_nth0(ActualRow1, TempRowList4, TempBoard1, NewBoard).

    

delete_nth0(Index, List, Result) :-
    nth0(Index, List, _, Rest),
    Result = Rest.

insert_nth0(Index, Element, List, Result) :-
    length(Before, Index),         % Create a prefix of length `Index`
    append(Before, After, List),   % Split `List` into `Before` and `After`
    append(Before, [Element|After], Result). % Insert `Element` at `Index`


replace_nth0(Index, NewElement, List, Result) :-
    delete_nth0(Index, List, Temp),
    insert_nth0(Index, NewElement, Temp, Result).
