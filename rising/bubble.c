//http://basilisk.fr/src/examples/bubble.c
#include "navier-stokes/centered.h"
#include "navier-stokes/perfs.h"

#define mu(f) (1./(clamp(f,0,1)*(1./mu1 - 1./mu2)+1./mu2))
#include "two-phase.h"

#include "tension.h"
#if dimension == 3
#include "lambda2.h"
#endif
#include "view.h"

#include "maxruntime.h"
#define RHOR 1000.
#define MUR 100.

#if BUBBLE19
#define Ga 100.8
#define Bo 4.
#define MATIME 82
#else

#define Ga 10.25
#define Bo 10.
#define MAXTIME 110
#endif

// width of bubble
#define WIDTH 120.0
// initial pos
#define Z0 3.5
int LEVEL = 12;

int main (int argc, char * argv[]) {
	maxruntime (&argc,argv);
	if (argc > 1)
		LEVEL = atoi (argv[1]);
	size(WIDTH);
	origin(L0/2,0,-L0/2);
	init_grid(129);

	rho1 = 1.;
	rho2 = 1./RHOR;
	mu1 = 1./Ga;
	mu2 = 1./(MUR*Ga);
	f.sigma = 1./Bo;
	TOLERANCE = 1e-4;
	run();
}
