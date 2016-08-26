
// if only one of the below function declaration appear in a given header
// the c->eiffel renamer would come up for both variants with the name `foo'.
// if both variants happen in one file, the name clash resolve must rename at least one
// function

void foo (void);
void _foo (void);
