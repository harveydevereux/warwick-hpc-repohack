#include "saint-venant.h"
#define LEVEL 8
/*
 * find s-v params here http://basilisk.fr/src/saint-venant.h
 */

/*
 * An init event runs once at time t=0 an sets the depth field h[] - note the nice
 * foreach syntax basilisk provides http://basilisk.fr/Basilisk%20C#iterators
 */
event init (t = 0){
	foreach()
		// guassian
		h[] = 0.1 + 1.*exp(-200.*(x*x+y*y));
}

event images (t += 4./300.){
	output_ppm (h, file = "h.mp4", linear=true);
}

event graphs (i++){
	// fill a stats object for h
	stats s = statsf (h);
	// record min and max depths
	fprintf (stderr,"%g %g %g\n",t,s.min,s.max);
}
/*
 * event is a function, i=10 tells basilisk to do 10 time steps, t=4 do up to time 4
 */
event end (t=4){
	printf ("i=%d t = %g\n",i,t);
}

/*
 * Refine the mesh using a wavelet estimation of the discretised error in h, at each time step when the error is larger than 4e-3 automaticall adapt the mesh (make it finer) to a max depth of 8 quad-levels
 * (2^8 points per dimension)
 * 
 */

event adapt (i++) {
	adapt_wavelet ({h}, (double []){4e-3}, maxlevel=LEVEL);
}

int main(){
	// run() simulates by defualt square box of length  1, reflective bcs, origin at lower left
	origin (-0.5, -0.5); // specify origin (centre of box now)
	init_grid (1<<LEVEL);
	run();
}
