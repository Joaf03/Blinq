:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).

row(1, '1').
row(2, '2').
row(3, '3').
row(4, '4').
row(5, '5').
row(6, '6').
row(7, '7').
row(8, '8').
row(9, '9').
row(10, '10').

read_row(RowIndex, BoardSize) :-
    repeat,
    format('| Enter a Row (1-~d): ', [BoardSize]),
    get_code(ASCIICode),
    peek_char(Enter),
    Enter == '\n',
    char_code(Char, ASCIICode),
    number_char(Char, RowIndex),
    RowIndex >= 1,
    RowIndex =< BoardSize,
    skip_line, !.