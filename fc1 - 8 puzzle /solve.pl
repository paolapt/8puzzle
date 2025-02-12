% goal state:
goal([1, 2, 3, 4, 5, 6, 7, 8, 0]).
%initial([0, 1, 3, 4, 2, 5, 7, 8, 6]).

% checkpoints
checkpoint_1([1, _, _, _, _, _, _, _, _]).  % 1 in final position
checkpoint_2([1, 2, 3, _, _, _, _, _, _]).  % 1, 2, 3 in final positions
checkpoint_3([1, 2, 3, 4, _, _, 7, _, _]).  % 1, 2, 3, 4, 7 in final positions

%move definitions
move( [0,B,C,D,E,F,G,H,J], [B,0,C,D,E,F,G,H,J], right,1).
move( [A,0,C,D,E,F,G,H,J], [0,A,C,D,E,F,G,H,J], left,1).
%THE ABOVE MOVES CANNOT BE USED AFTER REACHING CHECKPOINT 1. CUMULATIVE

move( [0,B,C,D,E,F,G,H,J], [D,B,C,0,E,F,G,H,J], down,2).
move( [A,0,C,D,E,F,G,H,J], [A,C,0,D,E,F,G,H,J], right,2).
move( [A,0,C,D,E,F,G,H,J], [A,E,C,D,0,F,G,H,J], down,2).
move( [A,B,0,D,E,F,G,H,J], [A,0,B,D,E,F,G,H,J], left,2).
move( [A,B,0,D,E,F,G,H,J], [A,B,F,D,E,0,G,H,J], down,2).
move( [A,B,C,0,E,F,G,H,J], [0,B,C,A,E,F,G,H,J], up,2).
move( [A,B,C,D,0,F,G,H,J], [A,0,C,D,B,F,G,H,J], up,2).
move( [A,B,C,D,E,0,G,H,J], [A,B,0,D,E,C,G,H,J], up,2).
% THE ABOVE MOVES CANNOT BE USED AFTER REACHING CHECKPOINT 2. CUMULATIVE

move( [A,B,C,D,0,F,G,H,J], [A,B,C,0,D,F,G,H,J], left,3).
move( [A,B,C,D,E,F,G,0,J], [A,B,C,D,E,F,0,G,J], left,3).
move( [A,B,C,0,E,F,G,H,J], [A,B,C,E,0,F,G,H,J], right,3).
move( [A,B,C,0,E,F,G,H,J], [A,B,C,G,E,F,0,H,J], down,3).
move( [A,B,C,D,E,F,0,H,J], [A,B,C,0,E,F,D,H,J], up,3).
move( [A,B,C,D,E,F,0,H,J], [A,B,C,D,E,F,H,0,J], right,3).
% THESE CANNOT BE USED AFTER REAACHING CHECKPOINT 3. CUMULATIVE.

move( [A,B,C,D,0,F,G,H,J], [A,B,C,D,F,0,G,H,J], right,4).
move( [A,B,C,D,0,F,G,H,J], [A,B,C,D,H,F,G,0,J], down,4).
move( [A,B,C,D,E,0,G,H,J], [A,B,C,D,0,E,G,H,J], left,4).
move( [A,B,C,D,E,0,G,H,J], [A,B,C,D,E,J,G,H,0], down,4).
move( [A,B,C,D,E,F,G,0,J], [A,B,C,D,0,F,G,E,J], up,4).
move( [A,B,C,D,E,F,G,0,J], [A,B,C,D,E,F,G,J,0], right,4).
move( [A,B,C,D,E,F,G,H,0], [A,B,C,D,E,0,G,H,F], up,4).
move( [A,B,C,D,E,F,G,H,0], [A,B,C,D,E,F,G,0,H], left,4).

show([], []).
show([Move|Moves], [State|States]) :-
    format('~n~w~n', [Move]),  %move format
    State = [A,B,C,D,E,F,G,H,I], %values in list form
    format('~w ~w ~w~n', [A,B,C]),
    format('~w ~w ~w~n', [D,E,F]),
    format('~w ~w ~w~n', [G,H,I]),
    show(Moves, States). %print states in matrix form

print_solution([]).
print_solution([Move|Rest]) :-
    write('Move: '), write(Move), nl,  %print current move
    print_solution(Rest).  %recursive call to print remaining steps

%check if we've reached the goal
reached_goal(State) :- goal(State).

solve(State, Visited) :- %what to print out once it's solved
    reached_goal(State), %true if we've solved the puzzle
    print('Goal state reached: '), print(State), nl. %print only once we've reached goal
	

solve(State, Visited) :-
    (   checkpoint_3(State),!,  %if checkpoint 3 is reached solve w allowed moves
        solve_with_checkpoint(State, 3, Visited)
    ;   checkpoint_2(State),!,  %if checkpoint 2 is reached solve w allowed moves
        solve_with_checkpoint(State, 2, Visited)
    ;   checkpoint_1(State),!,  %if checkpoint 1 is reached solve w allowed moves
        solve_with_checkpoint(State, 1, Visited)
    ;   %at first other 3 will fail so it uses general solution procedure(all moves allowed, without checkpoints)
        solve_wo(State, Visited) ).

solve_wo(State, Visited) :- %this one has no restrictions, it can use all moves
    not(reached_goal(State)),  %while we haven't reached the goal
    move(State, NewState, Direction, Moves), %moves
    \+ member(NewState, Visited), %avoid revisiting the same state+
    show([Direction], [NewState]), %display move and new state (in matrix form)
    solve(NewState, [NewState|Visited]). %recursive solve

solve_with_checkpoint(State, X, Visited) :-
    move(State, NewState, Direction, Moves), %moves
    Moves > X, %only moves > whatever checkpoint we're at are allowed
    \+ member(NewState, Visited), %checks whether state has been visited before or not
    show([Direction], [NewState]),%display move and new state (in matrix form)
    solve(NewState, [NewState|Visited]). %recursion

start :-
    InitialState = [3, 5, 0, 8, 4, 2, 1, 7, 6],
    solve(InitialState, [InitialState]).
