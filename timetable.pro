% Facts define the timetable (using periods instead of times)

timetable(monday, math, 1). 
timetable(monday, english, 2). 
timetable(tuesday, history, 1). 
timetable(tuesday, science, 2). 
timetable(wednesday, art, 1). 
timetable(wednesday, music, 2). 

% Rule to check if a subject is taught on a specific day

is_taught(Subject, Day) :-
  timetable(Day, Subject, _).  

% Rule to find the period number for a subject on a specific day

period_of_subject(Subject, Day, Period) :-
  timetable(Day, Subject, Period).

% Rule to find the subject taught in a specific period on a day

subject_in_period(Day, Period, Subject) :-
  timetable(Day, Subject, Period).

% Check if there are any classes on a specific day

any_class(Day) :-
  timetable(Day, _, _).  % Check if any facts exist for the Day

% Find all subjects taught on a specific day

all_subjects_on_day(Day, Subjects) :-
  findall(Subject, timetable(Day, Subject, _), Subjects).

% Check if a specific period is empty on a particular day

is_period_empty(Day, Period) :-
  \+ timetable(Day, _, Period).  % Use negation (\+) to check absence of facts

% Find all classes for a specific subject

all_classes_for_subject(Subject, DaysPeriods) :-
  findall(Day - Period, timetable(Day, Subject, Period), DaysPeriods).

% Check for conflicts: Is there a subject already scheduled for a specific day and period?

is_period_occupied(Day, Period) :-
  timetable(Day, _, Period). 

% Find the subject taught after a specific class on a particular day

subject_after_class(Day, Subject1, Subject2) :-
  timetable(Day, Subject1, Period1),
  Period1 < Period2,
  timetable(Day, Subject2, Period2).

% Error handling: Check for an invalid day or subject

valid_day(monday).
valid_day(tuesday).
valid_day(wednesday).
% ... (add other valid days)

valid_subject(math).
valid_subject(english).
valid_subject(history).
% ... (add other valid subjects)

is_taught_valid(Subject, Day) :-
  valid_day(Day),
  valid_subject(Subject),
  is_taught(Subject, Day). % Use existing is_taught rule

% Additional functions

% Find all free periods on a specific day

all_free_periods(Day, FreePeriods) :-
  findall(Period, (
    \+ timetable(Day, _, Period),
    between(1, 4, Period)  % Assuming 4 periods per day
  ), FreePeriods).

% Find all subjects and their corresponding periods on a specific day

full_schedule_for_day(Day, Schedule) :-
  findall(Subject - Period, (timetable(Day, Subject, Period)), Schedule).

% Check a student's complete schedule across all days (assuming fixed subjects)

student_complete_schedule(Student, Schedule) :-
  findall(Day - Period - Subject, 
           (timetable(Day, Subject, Period), member(Subject, StudentSubjects)), 
           Schedule).

% Find the most frequent subject a student has (assuming fixed subjects)

most_frequent_subject(Student, MostFrequentSubject) :-
  student_complete_schedule(Student, Schedule),
  count_occurrences(Schedule, Subject, Counts),
  max_list(Counts, MaxCount),
  (member(Subject - MaxCount, Counts), \+ (Subject \= MostFrequentSubject, member(MostFrequentSubject - MaxCount, Counts))).  % Handle ties

count_occurrences([], _, 0).
count_occurrences([Subject - Period - _ | Rest], Subject, Count) :-
  Subject = Subject,
  count_occurrences(Rest, Subject, Count1),
  Count is Count1 + 1.
count_occurrences([_ | Rest], Subject, Count) :-
  count_occurrences(Rest, Subject, Count).


%test queries
is_taught(history, tuesday)
period_of_subject(art, wednesday, Period)
any_class(thursday)
all_subjects_on_day(monday, Subjects)
is_period_empty(wednesday, 3)
all_classes_for_subject(history, DaysPeriods)
is_period_occupied(tuesday, 2)
subject_after_class(monday, math, Subject2)
is_taught(biology, tuesday)
is_taught(history, friday).

