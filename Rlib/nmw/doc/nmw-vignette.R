require(nmw)

DataAll = Theoph
colnames(DataAll) = c("ID", "BWT", "DOSE", "TIME", "DV")
DataAll[,"ID"] = as.numeric(as.character(DataAll[,"ID"]))

require(lattice)
xyplot(DV ~ TIME | as.factor(ID), data=DataAll, type="b")

nTheta = 3
nEta = 3
nEps = 2

THETAinit = c(2, 50, 0.1)
OMinit = matrix(c(0.2, 0.1, 0.1, 0.1, 0.2, 0.1, 0.1, 0.1, 0.2), 
                nrow=nEta, ncol=nEta) ; OMinit
SGinit = diag(c(0.1, 0.1)) ; SGinit

LB = rep(0, nTheta)
UB = rep(1000000, nTheta)

FGD = deriv(~DOSE/(TH2*exp(ETA2))*TH1*exp(ETA1)/(TH1*exp(ETA1) - TH3*exp(ETA3))*
             (exp(-TH3*exp(ETA3)*TIME)-exp(-TH1*exp(ETA1)*TIME)),
            c("ETA1","ETA2","ETA3"),
            function.arg=c("TH1", "TH2", "TH3", "ETA1", "ETA2", "ETA3", "DOSE", 
                           "TIME"),
            func=TRUE, hessian=(e$METHOD == "LAPL"))
H = deriv(~F + F*EPS1 + EPS2, c("EPS1", "EPS2"), 
          function.arg=c("F", "EPS1", "EPS2"), func=TRUE)

PRED = function(THETA, ETA, DATAi)
{
  FGDres = FGD(THETA[1], THETA[2], THETA[3], ETA[1], ETA[2], ETA[3], DOSE=320, 
               DATAi[,"TIME"])
  Gres   = attr(FGDres, "gradient")
  Hres   = attr(H(FGDres, 0, 0), "gradient")

  if (e$METHOD == "LAPL") {
    Dres = attr(FGDres, "hessian")
    Res  = cbind(FGDres, Gres, Hres, Dres[,1,1], 
                 Dres[,2,1], Dres[,2,2], Dres[,3,])
    colnames(Res) = c("F", "G1", "G2", "G3", "H1", "H2", 
                      "D11", "D21", "D22", "D31", "D32", "D33")
  } else {
    Res = cbind(FGDres, Gres, Hres)
    colnames(Res) = c("F", "G1", "G2", "G3", "H1", "H2")
  }
  return(Res)
}

####### First Order Approximation Method
InitStep(DataAll, THETAinit=THETAinit, OMinit=OMinit, SGinit=SGinit, 
         LB=LB, UB=UB, Pred=PRED, METHOD="ZERO")
(EstRes = EstStep())           # 4 sec
(CovRes = CovStep())           # 2 sec
PostHocEta() # FinalPara from EstStep()
TabStep()

######## First Order Conditional Estimation with Interaction Method
InitStep(DataAll, THETAinit=THETAinit, OMinit=OMinit, SGinit=SGinit, 
         LB=LB, UB=UB, Pred=PRED, METHOD="COND")
(EstRes = EstStep())           # 1.7 min
(CovRes = CovStep())           # 44 sec
get("EBE", envir=e)
TabStep()

######## Laplacian Approximation with Interacton Method
InitStep(DataAll, THETAinit=THETAinit, OMinit=OMinit, SGinit=SGinit, 
         LB=LB, UB=UB, Pred=PRED, METHOD="LAPL")
(EstRes = EstStep())           # 3.4 min
(CovRes = CovStep())           # 52 sec
get("EBE", envir=e)
TabStep()
