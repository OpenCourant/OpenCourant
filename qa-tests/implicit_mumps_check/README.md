# Implicit MUMPS check

This is a small check that an Engine built with MUMPS solves an implicit linear static
problem correctly.

**Model.** A steel bar 100 x 10 x 10 mm, meshed with 40 fully integrated bricks
(Isolid=14). Units are Mg, mm and s, so force is in N and stress in MPa.

**Supports and load.** Each support is a symmetry plane: x = 0 holds X, y = 0 holds Y,
z = 0 holds Z. So the bar stretches freely and its stress is exactly uniform. A 1000 N
pull acts on the end x = 100.

**Analysis.** One implicit linear step (`/IMPL/LINEAR`) with the direct solver
(`/IMPL/SOLVER/2`, which is MUMPS when the Engine has it).

| Quantity | Exact |
|---|---|
| u_x at the loaded end | F L / (E A) = 4.761905e-3 mm |
| u_y on the face y = 10, u_z on the face z = 10 | -nu F / (E A) x 10 = -1.428571e-4 mm |

The tolerance is 0.1 %. Eight-node bricks represent a uniform stress exactly, so any larger
difference comes from the solve, not from the mesh.

```text
python make_deck.py run            # writes mumps_check_0000.rad, mumps_check_0001.rad
cd run
starter_* -i mumps_check_0000.rad -np 2
mpiexec -n 2 engine_*_impi -i mumps_check_0001.rad
python ../check_result.py .        # exit 0 = pass
```

`check_result.py` reads two files:
* the Engine listing, which must name `DIRECT(MUMPS)` and end normally;
* the last `.sty` file written by `/OUTP`, which holds the displacements.

On Windows, `engine\extlib\get_and_build_mumps.ps1 -Test` runs all of this.
