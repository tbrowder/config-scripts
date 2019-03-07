unit module MySympa;

our enum Typ is export <noreply normal>;
our %dom-lists is export = %(
    'canterburycircle.us' => {
        news    => noreply, 
        friends => normal,
    },
    'nwflug.org' => {
        news => noreply, 
        members => normal,
    },
    'computertechnwf.org' => {
        news => noreply, 
        friends => normal, 
        presenters => normal,
        board => normal,
    },
    'novco1968tbs.com' => {
        news => noreply, 
        marines => normal, 
        board => normal,
    },
    'usafa-1965.org' => {
        news => noreply, 
        graytags => normal, 
        csreps => normal,
        officers => normal,
    },
);

