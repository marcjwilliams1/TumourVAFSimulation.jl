println("##########################")
println("Read in manysims.jl")
@time include("julia/manysims.jl")
println("")

println("##########################")
println("Read in arguments from shell script")
println("")

data = ARGS[1]
mu1 = float64(ARGS[2])
mu2 = float64(ARGS[3])
t1 = float64(ARGS[4])
t2 = float64(ARGS[5])
read_depth=float64(ARGS[6])
fmin=float64(ARGS[7])
fmax=float64(ARGS[8])
numclones1=int64(ARGS[9])
dataout=ARGS[10]
cm1=int64(ARGS[11])
cm2=int64(ARGS[12])
det_limit=float64(ARGS[13])
#println("hello")
#println(ARGS[14])
eps1=float64(ARGS[14])
eps2=float64(ARGS[15])
rho=float64(ARGS[16])
sname=ARGS[17]
N=int64(ARGS[18])
db=float64(ARGS[19])
date=ARGS[20]
Nmax=int64(ARGS[21])
ploidy=int64(ARGS[22])
numclones2=int64(ARGS[23])
d1=float64(ARGS[24])
d2=float64(ARGS[25])
iteration=int64(ARGS[26])
s1=float64(ARGS[27])
s2=float64(ARGS[28])
numsims=int64(ARGS[29])

srand(iteration)
eps1=10000
b = log(2.0)

println("date = $date")
println("data file = $data")
println("read depth = $read_depth")
println("results directory = $dataout")
println("clonal mutations prior - [$(cm1), $(cm2)]")
println("time prior - [$(t1), $(t2)]")
println("mutation prior - [$(mu1), $(mu2)]")
println("numclones = $numclones1")
println("detection limit = $det_limit")
println("epsilon - [$(eps1),$(eps2)]")
println("death rate - [$(d1),$(d2)]")
println("rho - $rho")
println("N = $N")
println("iteration = $iteration")
println("")

f = open("log/$(sname).$(iteration).txt","w+")
write(f, "##########################\n")
write(f, "Parameters:\n")
write(f, "date = $(date)\n")
write(f, "data file = $(data)\n")
write(f, "read depth = $(read_depth)\n")
write(f, "results directory = $(dataout)\n")
write(f, "clonal mutations prior - [$(cm1), $(cm2)]\n")
write(f, "time prior - [$(t1), $(t2)]\n")
write(f, "mutation prior - [$(mu1), $(mu2)]\n")
write(f, "numclones = $(numclones1)\n")
write(f, "detection limit = $(det_limit)\n")
write(f, "epsilon - [$(eps1),$(eps2)]\n")
write(f, "death rate - [$(d1),$(d2)]\n")
write(f, "rho - $(rho)\n")
write(f, "N = $(N)\n")
write(f, "Max population size = $(Nmax)\n")
write(f, "sample name = $(sname)\n")
write(f, "iteration = $iteration\n")
write(f, "##########################\n")
write(f, "\n")
write(f, "Run simulations\n")
write(f, "\n")
close(f)

println("##########################")
println("Read in files")

#add iteration number to sample name
sname = "$sname.$iteration"

@time DFABC = readtable(data);
println("")

println("##########################")
println("Get parameters")
cst = Constants(Nmax, det_limit, ploidy, read_depth, fmin, fmax, b, rho)
Pr = Priors([numclones1, numclones2], [cm1, cm2], [s1, s2], [mu1, mu2],[t1, t2], [d1, d2])
println("")

println("##########################")
println("Run simulations")

@time DF = manysims(cst, Pr, numsims, sname, dataout)

writetable("results/results2.$(sname).txt", DF, separator = '\t')
