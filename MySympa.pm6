unit module MySympa;

enum Typ { 'noreply', 'normal' }
our %dom-lists = %(
    canterburycircle.us => {
        news    => noreply, 
        friends => normal,
    },
    nwflug.org => [
        'news', 'members',
    ],
    computertechnwf.org => [
        'news', 'friends', 'presenters',
    ],
    novco1968tbs.com => [
        'news', 'marines', 'board',
    ],
    usafa-1965.org => [
        'news', 'graytags', 'csreps',
    ],
);

