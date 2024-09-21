/****************************************************************************
	Driver file of the dp_tides program
	This file has been created by MathTIDES (2.00) September 2, 2024, 14:47

	Copyright (C) 2010 A. Abad, R. Barrio, F. Blesa, M. Rodriguez
	Grupo de Mecanica Espacial
	University of Zaragoza
	SPAIN

	http://gme.unizar.es/software/tides
	Contact: <tides@unizar.es>

	This file is part of TIDES.

	TIDES is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	TIDES is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with TIDES.  If not, see <http://www.gnu.org/licenses/>.

gcc dr_LL_knead.c LL_knead.c -lTIDES -lm -o LL_knead   
*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "dp_tides.h"
#include "LL_knead.h"

int main(int argc, char *argv[]) {
    if (argc != 7) {
        printf("Usage: %s p0 p1 v0 v1 v2 v3\n", argv[0]);
        return 1;
    }

    /* --- PARAMETERS --------------- */
    int npar = 2;
    double p[npar];
    p[0] = atof(argv[1]); 
    p[1] = atof(argv[2]); 

    /* --- VARIABLES --------------- */
    int nvar = 4;
    double v[nvar];
    v[0] = atof(argv[3]); 
    v[1] = atof(argv[4]); 
    v[2] = atof(argv[5]); 
    v[3] = atof(argv[6]); 

    /* --- NUMBER OF EVENTS -------- */
    int nevents = 20;

    /* --- TOLERANCE ---------------- */
    double tol = 1.e-16;

    /* --- INTEGRATION POINTS ------ */
    double tini = 0.0;
    double tend = 100.0;

    /* --- OUTPUT ------------------- */
    FILE* fd = fopen("LL_knead_min.dat", "w");

    /* --- EVENT FINDER ------------- */
    dp_tides_find_minimum(LL_knead, nvar, npar, v, p, tini, tend, tol, &nevents, NULL, fd);

    /* --- END ---------------------- */
    fclose(fd);
    return 0;
}


