#include "saint-venant.h"
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

event images (i++){
	output_ppm (h, file = "h.mp4");
}

event graphs (i++){
	// fill a stats object for h
	stats s = statsf (h);
	// record min and max depths
	fprintf (stderr,"%g %g %g\n",t,s.min,s.max);
}
/*
 * event is a function, i=10 tells basilisk to do 10 time steps
 */
event end (i=1000){
	printf ("i=%d t = %g\n",i,t);
}

int main(){
	// run() simulates by defualt square box of length  1, reflective bcs, origin at lower left
	origin (-0.5, -0.5); // specify origin (centre of box now)
	run();
}
