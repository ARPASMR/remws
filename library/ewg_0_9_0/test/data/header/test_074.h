
// for some reason not all relevant types wer in the set.
// the resolve dead aliases algorithm removed too much
// must parse and post process with assertions on

struct foo
{
        void (*bar[10])(void);
};
