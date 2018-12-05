library(compiler)
enableJIT(3)
require(nmw)

setwd("C:/NMW2017/03-Emax")
DataFile = "SimData.CSV"
DataAll = read.csv(DataFile)

require(lattice)
xyplot(DV ~ log(CE) | ID, data=DataAll, type="b")

nTheta = 2
nEta = 1
nEps = 1

THETAinit = c(10, 100)
OMinit = matrix(0.2, nrow=nEta, ncol=nEta)
SGinit = matrix(1, nrow=nEps, ncol=nEps)

LB = rep(0, nTheta)
UB = rep(1000000, nTheta)

#######
METHOD = "ZERO"
InitPara = InitStep(DataAll, THETAinit=THETAinit, OMinit=OMinit, SGinit=SGinit, nTheta=nTheta, LB=LB, UB=UB, METHOD=METHOD, PredFile="PRED.R")
(EstRes = EstStep())           # 0.6200359 secs, 0.4930282 secs
(CovRes = CovStep())

PostHocEta() # FinalPara from EstStep()

########
METHOD = "COND"
InitStep(DataAll, THETAinit=THETAinit, OMinit=OMinit, SGinit=SGinit, nTheta=nTheta, LB=LB, UB=UB, METHOD=METHOD, PredFile="PRED.R")
(EstRes = EstStep())            # 4.89328 secs, 3.967227 secs
(CovRes = CovStep())            # 0.904052 secs, 0.7790442 secs
get("EBE", envir=e)

########
METHOD = "LAPL"
InitStep(DataAll, THETAinit=THETAinit, OMinit=OMinit, SGinit=SGinit, nTheta=nTheta, LB=LB, UB=UB, METHOD=METHOD, PredFile="PRED.R")
(EstRes = EstStep())            # 5.609321 secs, 4.486256 secs
(CovRes = CovStep())            # 0.9640551 secs, 0.749043 secs
get("EBE", envir=e)


## OUTPUT
> library(compiler)
> enableJIT(3)
[1] 0
> 
> source("E:/NMt/Steps.R")
> source("E:/NMt/Objs.R")
> source("E:/NMt/MinUtil.R")
> 
> setwd("E:/NMt/Emax")
> DataFile = "SimData.CSV"
> DataAll = read.csv(DataFile)
> 
> nTheta = 2
> nEta = 1
> nEps = 1
> 
> THETAinit = c(10, 100)
> OMinit = matrix(0.2, nrow=nEta, ncol=nEta)
> SGinit = matrix(1, nrow=nEps, ncol=nEps)
> 
> LB = rep(0, nTheta)
> UB = rep(1000000, nTheta)
> 
> #######
> METHOD = "ZERO"
> InitStep(DataAll, THETAinit=THETAinit, OMinit=OMinit, SGinit=SGinit, nTheta=nTheta, LB=LB, UB=UB, METHOD=METHOD, PredFile="PRED.R")
> (EstRes = EstStep())            # 0.6200359 secs
$`Initial OFV`
[1] 26252.44

$Time
Time difference of 0.4930282 secs

$Optim
$Optim$par
[1] -1.0473046 -0.1350919 -1.6460342  1.1021171

$Optim$value
[1] 219.1571

$Optim$counts
function gradient 
      48       48 

$Optim$convergence
[1] 0

$Optim$message
[1] "CONVERGENCE: REL_REDUCTION_OF_F <= FACTR*EPSMCH"

$Optim$hessian
            [,1]         [,2]      [,3]       [,4]
[1,]  670.395876  2158.672354 -7.125729   7.006006
[2,] 2158.672354 85287.489276 -7.337856  15.514037
[3,]   -7.125729    -7.337856  4.152576   4.003835
[4,]    7.006006    15.514037  4.003835 275.853564


$`Original Parameter`
[1]  3.17493543 79.05147595  0.00608757  7.42040865

> (CovRes = CovStep())
Note: no visible binding for global variable 'numDeriv' 
Note: no visible global function definition for 'hessian' 
Note: no visible binding for global variable 'numDeriv' 
Note: no visible binding for '<<-' assignment to 'DATAi' 
$`Standard Error`
[1] 0.213801649 0.406840873 0.005397485 1.195961163

$`Covariance Matrix of Estimates`
              [,1]          [,2]          [,3]        [,4]
[1,]  0.0457111453 -0.0772520047 -2.859795e-04 0.076221471
[2,] -0.0772520047  0.1655194961 -4.761570e-05 0.003246397
[3,] -0.0002859795 -0.0000476157  2.913285e-05 0.001456104
[4,]  0.0762214707  0.0032463969  1.456104e-03 1.430323103

$`Correlation Matrix of Estimates`
           [,1]        [,2]        [,3]       [,4]
[1,]  1.0000000 -0.88812507 -0.24781770 0.29809123
[2,] -0.8881251  1.00000000 -0.02168374 0.00667206
[3,] -0.2478177 -0.02168374  1.00000000 0.22557138
[4,]  0.2980912  0.00667206  0.22557138 1.00000000

$`Inverse Covariance Matrix of Estimates`
           [,1]       [,2]        [,3]       [,4]
[1,]  505163658  238489448  7081565591  -34670522
[2,]  238489448  112591670  3343230748  -16368069
[3,] 7081565591 3343230748 99271965946 -486023859
[4,]  -34670522  -16368069  -486023859    2379517

$`Eigen Values`
[1] 2.082324e-08 8.266776e-01 1.224386e+00 1.948937e+00

$`R Matrix`
             [,1]         [,2]         [,3]         [,4]
[1,]  33.25264781  4.300774672   -92.170535  0.074344470
[2,]   4.30077467  6.825012070    -3.810603  0.006644425
[3,] -92.17053475 -3.810602957 14024.928141 11.079359764
[4,]   0.07434447  0.006644425    11.079360  0.626246252

$`S Matrix`
            [,1]       [,2]        [,3]       [,4]
[1,]   33.915324 -7.3325885 -249.828257  1.5207482
[2,]   -7.332589  4.0373146    7.982297  0.1841291
[3,] -249.828257  7.9822967 7283.463518 22.8176932
[4,]    1.520748  0.1841291   22.817693  0.5915625

> 
> PostHocEta() # FinalPara from EstStep()
Note: no visible binding for '<<-' assignment to 'invOM' 
     ID         ETA1
[1,]  1 -0.086591457
[2,]  2 -0.006572798
[3,]  3  0.019921154
[4,]  4  0.067803498
> 
> ########
> METHOD = "COND"
> (EstRes = EstStep())            # 4.89328 secs
$`Initial OFV`
[1] 20012.59

$Time
Time difference of 3.967227 secs

$Optim
$Optim$par
[1] -1.050022 -0.135063 -1.638025  1.101744

$Optim$value
[1] 219.1362

$Optim$counts
function gradient 
      50       50 

$Optim$convergence
[1] 0

$Optim$message
[1] "CONVERGENCE: REL_REDUCTION_OF_F <= FACTR*EPSMCH"

$Optim$hessian
            [,1]         [,2]      [,3]       [,4]
[1,]  660.268330  2125.523776 -1.819877   1.767929
[2,] 2125.523776 85248.440689  5.298552   3.072116
[3,]   -1.819877     5.298552  4.175059   4.050763
[4,]    1.767929     3.072116  4.050763 275.725379


$`Original Parameter`
[1]  3.166319671 79.053758782  0.006185865  7.414875979

> StartTime = Sys.time()
> (CovRes = CovStep())
$`Standard Error`
[1] 0.216594566 0.406750972 0.005495516 1.198734383

$`Covariance Matrix of Estimates`
             [,1]          [,2]          [,3]        [,4]
[1,]  0.046913206 -7.666184e-02 -3.889420e-04 0.074804804
[2,] -0.076661838  1.654464e-01 -2.509613e-06 0.002532320
[3,] -0.000388942 -2.509613e-06  3.020069e-05 0.001355735
[4,]  0.074804804  2.532320e-03  1.355735e-03 1.436964120

$`Correlation Matrix of Estimates`
           [,1]         [,2]         [,3]        [,4]
[1,]  1.0000000 -0.870167922 -0.326759950 0.288110424
[2,] -0.8701679  1.000000000 -0.001122716 0.005193582
[3,] -0.3267600 -0.001122716  1.000000000 0.205799080
[4,]  0.2881104  0.005193582  0.205799080 1.000000000

$`Inverse Covariance Matrix of Estimates`
          [,1]      [,2]        [,3]        [,4]
[1,]  56787467  26386060   906731999  -3858190.8
[2,]  26386060  12260178   421309238  -1792692.2
[3,] 906731999 421309238 14477928308 -61604206.8
[4,]  -3858191  -1792692   -61604207    262129.6

$`Eigen Values`
[1] 1.816070e-07 8.401267e-01 1.205440e+00 1.954433e+00

$`R Matrix`
             [,1]        [,2]         [,3]         [,4]
[1,]  32.92929266 4.246138747   -23.228917  0.018825533
[2,]   4.24613875 6.821495673     2.712817  0.001338716
[3,] -23.22891723 2.712816725 13638.686566 11.039330065
[4,]   0.01882553 0.001338716    11.039330  0.626875033

$`S Matrix`
            [,1]       [,2]        [,3]       [,4]
[1,]   33.118935 -7.2390756 -190.289156  1.4198631
[2,]   -7.239076  4.0955685   -8.135575  0.1909219
[3,] -190.289156 -8.1355747 6445.344239 25.1566059
[4,]    1.419863  0.1909219   25.156606  0.5887529

> difftime(Sys.time(), StartTime) # 0.904052 secs
Time difference of 0.7790442 secs
> 
> EBE
     ID         ETA1
[1,]  1 -0.085911473
[2,]  2 -0.005252921
[3,]  3  0.021412776
[4,]  4  0.069671289
> 
> ########
> METHOD = "LAPL"
> (EstRes = EstStep())            # 5.609321 secs
$`Initial OFV`
[1] 20011.59

$Time
Time difference of 4.486256 secs

$Optim
$Optim$par
[1] -1.0501081 -0.1350325 -1.6319874  1.1015671

$Optim$value
[1] 219.1097

$Optim$counts
function gradient 
      54       54 

$Optim$convergence
[1] 0

$Optim$message
[1] "CONVERGENCE: REL_REDUCTION_OF_F <= FACTR*EPSMCH"

$Optim$hessian
            [,1]         [,2]      [,3]       [,4]
[1,]  656.378855  2112.814243 -1.800654   1.755229
[2,] 2112.814243 85237.797606  2.998751   0.523396
[3,]   -1.800654     2.998751  4.228542   3.997367
[4,]    1.755229     0.523396  3.997367 275.778061


$`Original Parameter`
[1]  3.166047079 79.056170425  0.006261016  7.412250716

> StartTime = Sys.time()
> (CovRes = CovStep())
$`Standard Error`
[1] 0.216584048 0.406737260 0.005489756 1.194174834

$`Covariance Matrix of Estimates`
              [,1]          [,2]          [,3]        [,4]
[1,]  0.0469086500 -7.669429e-02 -3.650243e-04 0.073814386
[2,] -0.0766942928  1.654352e-01 -2.515791e-05 0.004000031
[3,] -0.0003650243 -2.515791e-05  3.013742e-05 0.001520596
[4,]  0.0738143856  4.000031e-03  1.520596e-03 1.426053534

$`Correlation Matrix of Estimates`
           [,1]         [,2]        [,3]        [,4]
[1,]  1.0000000 -0.870607935 -0.30700276 0.285395175
[2,] -0.8706079  1.000000000 -0.01126698 0.008235339
[3,] -0.3070028 -0.011266982  1.00000000 0.231949230
[4,]  0.2853952  0.008235339  0.23194923 1.000000000

$`Inverse Covariance Matrix of Estimates`
          [,1]        [,2]       [,3]        [,4]
[1,]  21756533  10176134.3  349049151  -1526880.1
[2,]  10176134   4759666.6  163259985   -714164.2
[3,] 349049151 163259984.6 5599976599 -24496413.5
[4,]  -1526880   -714164.2  -24496413    107157.7

$`Eigen Values`
[1] 4.695795e-07 8.243091e-01 1.231953e+00 1.943738e+00

$`R Matrix`
             [,1]         [,2]         [,3]         [,4]
[1,]  32.74109940 4.2209836874   -22.709635 1.869856e-02
[2,]   4.22098369 6.8202282092     1.518491 2.516816e-04
[3,] -22.70963504 1.5184908825 13483.979615 1.076686e+01
[4,]   0.01869856 0.0002516816    10.766861 6.274374e-01

$`S Matrix`
            [,1]        [,2]       [,3]       [,4]
[1,]   32.687781  -7.2205635 -175.80804  1.4075313
[2,]   -7.220564   4.1103399  -10.17378  0.1904558
[3,] -175.808037 -10.1737816 6302.77315 25.9921991
[4,]    1.407531   0.1904558   25.99220  0.5870459

> difftime(Sys.time(), StartTime) # 0.9640551 secs
Time difference of 0.749043 secs
> 
> EBE
     ID         ETA1
[1,]  1 -0.086424632
[2,]  2 -0.005288198
[3,]  3  0.021537586
[4,]  4  0.070104150
> 
